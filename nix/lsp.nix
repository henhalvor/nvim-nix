{ pkgs, pkgsUnstable, }:
with pkgs;
[
  lua-language-server
  pyright
  typescript-language-server
  gopls
  nil # nix
  tailwindcss-language-server
  vscode-langservers-extracted
  eslint_d
] ++ (with pkgsUnstable; [ efm-langserver ])
