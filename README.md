# mynix-config

跨主机 / 跨用户 / 跨架构的 **NixOS + Home Manager** 配置，基于 [flake-parts](https://github.com/hercules-ci/flake-parts) 组织。

## 特性

- **单仓库管多机**：`inventory.nix` 声明主机与用户，自动生成对应的 NixOS 与 Home Manager 配置。
- **声明式密钥**：[sops-nix](https://github.com/Mic92/sops-nix) 管理机密，`secrets/` 下均为加密密文，可安全入库。
- **可复现安装**：支持用 [disko](https://github.com/nix-community/disko) + [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) 做裸机部署。

## 结构

```
mynix-config/
├── flake.nix              # 入口：inputs（nixpkgs / home-manager / sops-nix / disko …）
├── flake.lock
├── inventory.nix          # 主机 ↔ 用户清单
├── overlays.nix
├── .sops.yaml             # sops 加密规则（密文 ↔ age 公钥映射）
├── nixos/                 # NixOS 系统配置
│   ├── flake-module.nix   # 由 inventory 生成 nixosConfigurations
│   ├── modules/           # 共享模块（base / identity / nixpkgs / tools …）
│   └── hosts/<host>/      # 每主机配置（pu500c · um480xt · demo）
├── home/                  # Home Manager 用户配置
│   ├── flake-module.nix   # 生成 homeConfigurations（<user>@<host>）
│   ├── modules/           # 共享 home 模块
│   └── users/<user>/      # 每用户配置（kinos · jun · demo · arch）
├── per-system/            # flake-parts perSystem 配置
└── secrets/               # 用户级 sops 密文（可入库）
    └── users/<user>.yaml
```

## 前置条件

- 启用 flakes 的 Nix（本仓库基于 `nixos-26.05`）。
- 远程部署需要目标机 SSH 可达且免密。
- 编辑 `secrets/` 需持有相应用户 key 或 admin key（见「密钥」）。

## 使用

在本机构建并切换系统：

```bash
sudo nixos-rebuild switch --flake .#<host>
```

构建并切换用户环境：

```bash
home-manager switch --flake .#<user>@<host>
```

远程部署到另一台机器：

```bash
nixos-rebuild switch --flake .#<host> --target-host nixos@<ip>
home-manager switch --flake .#<user>@<host> --target-host <user>@<ip>
```

### 全新系统安装

前提：目标机用 NixOS live USB 启动，UEFI 模式，能 SSH。

#### 1. 目标机 live 环境

```bash
passwd
sudo systemctl start sshd
ip -brief address

lsblk -o NAME,SIZE,TYPE,TRAN,MODEL
[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS
```

- 必须是 `UEFI`
- `/dev/sda` 必须是目标磁盘；不是的话改 `nixos/hosts/<host>/disk-config.nix`
- 安装会清空目标磁盘

#### 2. 从 um480xt 安装

```bash
cd /home/kinos/Projects/mynix-config

read -s SSHPASS
export SSHPASS

nix run nixpkgs#nixos-anywhere -- \
  --env-password \
  --flake .#<host> \
  --target-host nixos@<ip>

unset SSHPASS
```

没有 `--extra-files`，不需要 host key。

fish 下用：

```fish
read -s SSHPASS
set -x SSHPASS
# ...
set -e SSHPASS
```

常见参数：

```text
--no-disko-deps                          kexec 环境缺 libncursesw 等依赖时
--build-on local                        强制本地构建
--no-substitute-on-destination          目标机不自己下载
--no-use-machine-substituters           不把目标机 substituter 带进安装环境
--ssh-option "Compression=yes"          慢速链路压缩
```

> nixos-anywhere 1.13.0 的 `--ssh-store-setting` 有参数解析 bug，暂时别用，或放到命令最后。

#### 3. 首次启动

- 拔掉 live USB，从内置盘启动
- root 已锁定，用 jun 或 kinos 的密码登录
- kinos 是每台主机的 wheel 管理员；jun 不是 wheel

#### 4. 交付用户 key

kinos/um480xt：admin key 已经在 `~/.config/sops/age/keys.txt`，直接跑 HM。

jun/pu500c：把 `~/jun.agekey` 放到 jun 的 `~/.config/sops/age/keys.txt`：

```bash
umask 077

SOPS_AGE_KEY_FILE=~/jun.agekey \
  sops -d --extract '["jun-ssh-private-key"]' secrets/users/jun.yaml > ~/jun-ssh-key
chmod 600 ~/jun-ssh-key

ssh -i ~/jun-ssh-key jun@<ip> 'mkdir -p ~/.config/sops/age'
scp -i ~/jun-ssh-key ~/jun.agekey jun@<ip>:~/.config/sops/age/keys.txt
ssh -i ~/jun-ssh-key jun@<ip> 'chmod 600 ~/.config/sops/age/keys.txt'
```

或者用控制台 + U 盘。

#### 5. Home Manager

```bash
home-manager switch --flake .#<user>@<host>
```

远程：

```bash
cat >> ~/.ssh/config <<'EOF'
Host <host>
  HostName <ip>
  User <user>
  IdentityFile ~/jun-ssh-key
EOF

home-manager switch --flake .#<user>@<host> --target-host <host>
```

#### 6. 验证

```bash
sops -d secrets/users/<user>.yaml >/dev/null && echo sops-ok
ls ~/.config/sops-nix/secrets
systemctl status mihomo
```

mihomo 在 HM 渲染出配置后启动；HM 未跑时它会每 10 秒重试。

### 新增主机

1. 在 `inventory.nix` 加主机
2. 需要 secret 的用户，在 `.sops.yaml` 加用户规则并创建 `secrets/users/<user>.yaml`
3. `git add` 新文件
4. 按上面的「全新系统安装」安装，不需要 `extra-files`
5. 登录后交付用户 key，跑 `home-manager switch`

## 主机与用户

| 主机      | 系统          | 用户   | NixOS |
|-----------|---------------|--------|-------|
| pu500c    | x86_64-linux  | jun（+ kinos 管理员） | ✓     |
| um480xt   | x86_64-linux  | kinos  | ✓     |
| demo      | x86_64-linux  | demo   | 占位（不生成配置） |
| arch      | x86_64-linux  | arch   | 占位（仅 Home Manager） |

## 密钥（sops-nix）

只有用户级密文：

| 文件 | 内容 | 收件人 | 解密方 |
|------|------|--------|--------|
| `secrets/users/kinos.yaml` | github、deepseek、mihomo | admin | HM（`~/.config/sops/age/keys.txt`） |
| `secrets/users/jun.yaml` | jun SSH key、mihomo | jun + admin | HM（`~/.config/sops/age/keys.txt`） |

- 没有主机级 sops，也没有 host key / `extra-files`。
- NixOS 用户密码是 `accounts.nix` 里的 hash；root 锁定（`hashedPassword = "!"`）。
- kinos 是每台主机的 wheel 管理员；jun 不是 wheel。
- admin key 只在你机器上，作为所有文件的额外 recipient，用于编辑/恢复。
- 每个用户在自己的机器上用 `~/.config/sops/age/keys.txt` 解自己的文件。
- mihomo secret 在用户文件里；HM 渲染后由 systemd path unit 启动系统服务。
- 没有 recovery；admin key 和每个用户的 key 都要离线备份。
- arch 目前占位；启用时加 `secrets/users/arch.yaml` 和 arch 的 key。

编辑：

```bash
sops secrets/users/kinos.yaml
SOPS_AGE_KEY_FILE=~/jun.agekey sops secrets/users/jun.yaml
```

修改 `.sops.yaml` 收件人后：

```bash
sops updatekeys <file>
```

> `demo` / `arch` 为占位，不生成配置。`pu500c` 已启用，jun 非 wheel，kinos 是管理员。

## License

私有配置，未开放授权。
