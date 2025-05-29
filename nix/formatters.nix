{
  pkgs,
  pkgsUnstable,
}:
with pkgs;
  [
    stylua
    prettier
    black
  ]
  ++ (with pkgsUnstable; [
    # any bleeding edge formatters here
  ])
