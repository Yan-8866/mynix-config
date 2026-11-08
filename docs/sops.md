# Sops 说明

这套配置用 sops-nix 管理 secrets：**两类 key、两类文件，互不混用**。

## 1. Key 模型

| 角色 | 来源 | 解密对象 | 存放位置 |
|---|---|---|---|
| 系统 key | 主机 SSH key `/etc/ssh/ssh_host_ed25519_key`（装机自动生成） | `secrets/hosts/<host>.yaml` | 主机本地，root-only |
| 用户 key | 一把共享 age key | `secrets/users/<user>.yaml` | NixOS：`/etc/sops/age/keys.txt`（root:users 0440）；非 NixOS：手工放 `~/.config/sops/age/keys.txt` |

- 系统 key **每台主机一把**，各解各的主机文件。
- 用户 key **所有用户共用一把**（当前不区分用户）。
- 用户 key 作为一个 secret（名为 `age-key`）放在主机文件里，由系统 key 解密后就地落盘。

## 2. 文件布局

```
.sops.yaml                    # 每条 path_regex 决定对应文件加密给谁
secrets/
  hosts/<host>.yaml           # 收件人 = 该主机 key
  users/<user>.yaml           # 收件人 = 用户 key
```

## 3. 启动链路

```
/etc/ssh/ssh_host_ed25519_key          （系统 key）
        │ 解密
        ▼
secrets/hosts/<host>.yaml              （内含 age-key）
        │ sops.secrets 写出
        ▼
/etc/sops/age/keys.txt  (root:users 0440)
        │
        ▼
Home Manager 用它解 secrets/users/<user>.yaml
```

**顺序要求**：先 `nixos-rebuild switch`（生成 `/etc/sops/age/keys.txt`），再 `home-manager switch`。

非 NixOS 主机（如 `arch`）没有上面这一步，需要手工把同一把用户 key 放到 `~/.config/sops/age/keys.txt`；Home 侧用 `isNixos` 自动选择路径。

## 4. 代码位置

| 文件 | 职责 |
|---|---|
| `nixos/modules/sops.nix` | 主机侧：`sshKeyPaths` + 下发 `age-key` 到 `/etc/sops/age/keys.txt` |
| `home/modules/sops.nix` | 用户侧：`keyFile` + 默认用户文件 |
| `nixos/flake-module.nix` | 存在 `secrets/hosts/<host>.yaml` 才注入 sops |
| `home/flake-module.nix` | 存在 `secrets/users/<user>.yaml` 才注入 sops |
| `.sops.yaml` | 各路径的收件人规则 |

## 5. 常用操作

### 编辑主机 secrets（在目标机上，root）

```bash
ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key -o /run/host.agekey
SOPS_AGE_KEY_FILE=/run/host.agekey sops secrets/hosts/<host>.yaml
rm /run/host.agekey
```

> 用 `ssh-to-age` 派生的 age key。不要用 `SOPS_AGE_SSH_PRIVATE_KEY_FILE`：那是 age 原生 SSH 身份，和 `ssh-to-age` 派生的不是同一套。

### 编辑用户 secrets

```bash
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/users/kinos.yaml
```

### 新增主机

1. 在该机取收件人：`ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub`
2. 在 `.sops.yaml` 加一条 `^secrets/hosts/<host>.yaml$` 规则
3. 建 `secrets/hosts/<host>.yaml`，至少包含 `age-key`（以及该主机的 `<user>-password`、`root-password`）

### 新增用户

1. 建 `secrets/users/<user>.yaml`（加密到用户 key）
2. 文件存在即自动启用，无需改代码

### 用户密码（accounts）

每台主机的 `accounts.nix` 用本机 sops 里预哈希的密码建用户：

```nix
users.mutableUsers = false;

sops.secrets."<user>-password".neededForUsers = true;
users.users.<user> = {
  isNormalUser = true;
  home = "/home/<user>";
  extraGroups = [ "networkmanager" "video" "wheel" ];
  hashedPasswordFile = config.sops.secrets."<user>-password".path;
};

sops.secrets."root-password".neededForUsers = true;
users.users.root.hashedPasswordFile = config.sops.secrets."root-password".path;
```

- `neededForUsers = true`：sops 在**建用户之前**解密，落盘到 `/run/secrets-for-users/<name>`。
- `mutableUsers = false`：密码每次激活按 sops 重置，`passwd` 改不了；以后改密码 = 改 sops。
- 生成 hash：`openssl passwd -6` 或 `mkpasswd -m sha-512`；想让所有用户/主机同一个密码，就把**同一行 hash** 粘到各主机对应条目。
- 填密码需要该主机 root：
  ```bash
  ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key -o /run/host.agekey
  SOPS_AGE_KEY_FILE=/run/host.agekey sops secrets/hosts/<host>.yaml
  rm /run/host.agekey
  ```

### 轮换用户 key

- 用新 age key 重新加密所有 `secrets/users/*.yaml`
- 更新每台 `secrets/hosts/*.yaml` 里的 `age-key`

## 6. 注意事项

- 所有用户共用一把用户 key：用户之间**不隔离**。
- 主机文件只加密给主机 key：编辑系统 secrets 需要目标机 root。想从任意机器编辑，可另加一把**离线 admin key**（独立的第三把，别复用用户 key）。
- 不要忽略 `secrets/`：flake 用 `builtins.pathExists` 判断是否启用，文件必须在 flake 源里。
- `sops-nix` 没有版本 tag，固定靠 `flake.lock` 锁 commit。
