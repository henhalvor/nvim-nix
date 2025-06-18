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
] ++ (with pkgsUnstable; [ efm-langserver ])
