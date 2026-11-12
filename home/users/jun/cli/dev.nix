{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # C/C++
    clang
    clang-tools # clangd + clang-format
    gnumake
    cmake-language-server # CMake LSP

    # Rust
    rustc
    cargo
    rustfmt
    rust-analyzer # LSP

    # Nix
    nil # LSP
    sops # 编辑 secrets/*.yaml

    # Lua
    lua-language-server # LSP

    # JSON
    vscode-json-languageserver # LSP

    # Shell
    bash-language-server # LSP

    # Markdown
    marksman # LSP
  ];
}
