{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    lua-language-server
    pyright
    typescript-language-server
    gopls
    nil #nix
  ]
  ++ (with pkgsUnstable; [
    efm-langserver
  ])
