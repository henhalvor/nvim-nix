{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    stylua
    nodepackages_latest.prettier
    black
    nixfmt
  ]
  ++ (with pkgsUnstable; [
    # any bleeding edge formatters here
  ])
