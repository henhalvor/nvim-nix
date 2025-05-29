{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    stylua
    nodePackages.prettier
    black
    nixfmt-classic
  ]
  ++ (with pkgsUnstable; [
    # any bleeding edge formatters here
  ])
