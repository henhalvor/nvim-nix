{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    lua-language-server
    pylsp
    tsserver
  ]
  ++ (with pkgsUnstable; [
    efm-langserver
  ])
