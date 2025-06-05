{ pkgs, pkgsUnstable, }:
with pkgs;
[
  lua-language-server
  pyright
  typescript-language-server
  gopls
  nil # nix
  tailwindcss-language-server
] ++ (with pkgsUnstable; [ efm-langserver ])
