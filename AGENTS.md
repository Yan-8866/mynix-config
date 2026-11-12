# AGENTS.md

NixOS + 独立 Home Manager flake。主要目标：`um480xt` / `kinos`、`pu500c` / `jun`。

## 常用命令

- 评估：`nix flake check --no-build`
- Home Manager：`home-manager switch --flake .#kinos@um480xt`
- NixOS：`sudo nixos-rebuild switch --flake .#um480xt`
- fish 别名：`hm-switch` 只跑 HM，`nix-switch` 只跑 NixOS
- 新文件先 `git add`，否则 flake 看不到
- 格式化 Nix：`nix fmt`

## 结构

- `inventory.nix`：主机/用户清单
- `nixos/modules/`：共享系统模块
- `nixos/hosts/<host>/`：主机私有
- `home/modules/`：共享用户模块
- `home/users/<user>/`：用户私有
- `secrets/users/<user>.yaml`：用户级 sops 密文，禁止明文

## 规则

- `demo` / `arch` 是占位主机（`inventory.nix` 中 `placeholder = true`），不生成配置
- NixOS 不参与 sops；密码 hash 直接写在 `accounts.nix`，root 锁定
- 用户 secret 走 Home Manager sops，key 在 `~/.config/sops/age/keys.txt`
- `kinos` 是每台主机的 wheel 管理员；`jun` 不是 wheel
- 私有配置只放对应 host/user，不放 `modules`
- 独立 HM：改用户配置只跑 `hm-switch`，改系统才跑 `nix-switch`
- 不主动 commit/push；不输出或提交密钥明文
- `um480xt` 不启用静态网络/旁路由；网络走 DHCP + mihomo TUN
- mihomo：NixOS 服务在 `nixos/hosts/<host>/mihomo.nix`，secret/模板在 `home/modules/mihomo.nix`；登录并 HM 激活后由 path unit 启动
- Emacs：`emacs-unstable-pgtk` 31.1 + Doom `v2.2.4`
- tree-sitter grammar 用 `ep.treesit-grammars.with-all-grammars`
- 改 `init.el` / `packages.el` 后：`~/.emacs.d/bin/doom sync --force`，再 `systemctl --user restart emacs`
- Doom 配置在 `home/users/kinos/emacs-doom/`；语言服务器在 `home/users/kinos/cli/dev.nix`
