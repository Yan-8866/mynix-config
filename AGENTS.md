# AGENTS.md

NixOS + 独立 Home Manager flake。主要目标：`um480xt` / `kinos`。

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
- `secrets/`：sops 密文，禁止明文

## 规则

- `pu500c` / `demo` 是占位主机（`inventory.nix` 中 `placeholder = true`），不生成配置；其 `secrets/` 可能过期，勿修复
- 私有配置只放对应 host/user，不放 `modules`
- 独立 HM：改用户配置只跑 `hm-switch`，改系统才跑 `nix-switch`
- 不主动 commit/push；不输出或提交密钥明文
- `um480xt` 不启用静态网络/旁路由；网络走 DHCP + mihomo TUN
- mihomo 在 `nixos/hosts/um480xt/mihomo.nix`，DNS 用 `insertNameservers = [ "198.18.0.2" ]`
- Emacs：`emacs-unstable-pgtk` 31.1 + Doom `v2.2.4`
- tree-sitter grammar 用 `ep.treesit-grammars.with-all-grammars`
- 改 `init.el` / `packages.el` 后：`~/.emacs.d/bin/doom sync --force`，再 `systemctl --user restart emacs`
- Doom 配置在 `home/users/kinos/emacs-doom/`；语言服务器在 `home/users/kinos/cli/dev.nix`
