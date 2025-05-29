{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    lua-language-server
    # pylsp
    typescript-language-server
  ]
  ++ (with pkgsUnstable; [
    efm-langserver
  ])
