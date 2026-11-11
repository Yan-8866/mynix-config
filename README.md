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
│   ├── modules/           # 共享模块（base / identity / nixpkgs / sops …）
│   └── hosts/<host>/      # 每主机配置（pu500c · um480xt · demo）
├── home/                  # Home Manager 用户配置
│   ├── flake-module.nix   # 生成 homeConfigurations（<user>@<host>）
│   ├── modules/           # 共享 home 模块
│   └── users/<user>/      # 每用户配置（kinos · jun · demo · arch）
├── per-system/            # flake-parts perSystem 配置
└── secrets/               # sops 加密密钥（密文，可入库）
    ├── hosts/<host>.yaml
    └── users/<user>.yaml
```

## 前置条件

- 启用 flakes 的 Nix（本仓库基于 `nixos-26.05`）。
- 远程部署需要目标机 SSH 可达且免密。
- 编辑 `secrets/` 需持有对应的 age 私钥（见「密钥」）。

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

首次裸机安装（disko 分区 + 装系统）：

```bash
nix run nixpkgs#nixos-anywhere -- --flake .#<host> \
  --target-host nixos@<ip> --extra-files /path/to/extra-files
```

## 主机与用户

| 主机      | 系统          | 用户   | NixOS |
|-----------|---------------|--------|-------|
| pu500c    | x86_64-linux  | jun    | 占位（不生成配置） |
| um480xt   | x86_64-linux  | kinos  | ✓     |
| demo      | x86_64-linux  | demo   | 占位（不生成配置） |
| arch      | x86_64-linux  | arch   | ✗（仅 Home Manager） |

## 密钥（sops-nix）

两类密文，各司其职：

| 文件 | 内容 | 收件人（`.sops.yaml`） | 解密方 |
|------|------|------------------------|--------|
| `secrets/hosts/<host>.yaml` | 主机级：密码哈希、服务密钥（如 mihomo） | 该主机 SSH key + 管理员 age key | NixOS activation（SSH 主机密钥） |
| `secrets/users/<user>.yaml` | 用户级：token、私钥等 | users 规则（当前统一为管理员 age key） | Home Manager（`~/.config/sops/age/keys.txt`） |

- 主机密钥：`/etc/ssh/ssh_host_ed25519_key`（见 `nixos/modules/sops.nix`）。
- 用户密钥：`~/.config/sops/age/keys.txt`（见 `home/modules/sops.nix`）；当前所有用户密文统一加密给管理员 key，由管理员代管。
- 管理员 age 私钥只保存在 `~/.config/sops/age/keys.txt`，在用密文中不保留备份，请务必离线备份（占位主机 `pu500c` / `demo` 的旧密文里仍有历史残留，勿视为可用备份）。
- 同一主机的所有密钥都写在该 host 文件里，避免按服务拆分 sops 文件。
- `sops` CLI 只读 `~/.config/sops/age/keys.txt` 或 `SOPS_AGE_KEY_FILE`，不读 `/etc/sops`；`/etc/sops/age/keys.txt` 无消费者，可删除。

编辑（需本地持有对应私钥）：

```bash
sops secrets/hosts/um480xt.yaml
sops secrets/users/kinos.yaml
```

修改 `.sops.yaml` 的收件人后，用 `sops updatekeys <file>` 同步数据密钥。

> `pu500c` / `demo` 为占位主机（`inventory.nix` 中 `placeholder = true`），不生成配置；其 `secrets/` 可能过期，勿据此修复。

## License

私有配置，未开放授权。
