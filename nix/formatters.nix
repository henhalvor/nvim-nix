{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    stylua
    nodePackages.prettier
    black
    nixfmt
  ]
  ++ (with pkgsUnstable; [
    # any bleeding edge formatters here
  ])
