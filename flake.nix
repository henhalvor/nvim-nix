{
  description = "Standalone Neovim config flake with modular package sets";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, unstable, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgsUnstable = import unstable { inherit system; };

      lsp = import ./nix/lsp.nix { inherit pkgs pkgsUnstable; };
      formatters = import ./nix/formatters.nix { inherit pkgs pkgsUnstable; };
      tools = import ./nix/tools.nix { inherit pkgs pkgsUnstable; };

      allPackages = lsp ++ formatters ++ tools;
    in {
      homeManagerModules.default = { config, lib, pkgs, ... }: {
        home.packages = allPackages;

        home.file.".config/nvim".source =
          config.lib.file.mkOutOfStoreSymlink "~/.nvim-nix/config";
      };

      devShells.${system}.default = pkgs.mkShell { packages = allPackages; };
    };
}
