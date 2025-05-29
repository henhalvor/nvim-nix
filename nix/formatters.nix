{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    stylua
    nodepackages.prettier
    black
    nixfmt
  ]
  ++ (with pkgsUnstable; [
    # any bleeding edge formatters here
  ])
