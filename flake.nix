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
      homeManagerModules.default =
        { config, lib, pkgs, configPath ? null, ... }: {
          home.packages = allPackages;

          # Use passed configPath if provided
          home.file.".config/nvim".source = if configPath != null then
            config.lib.file.mkOutOfStoreSymlink configPath
          else
            throw "You must pass `configPath` to the Neovim module.";
        };

      devShells.${system}.default = pkgs.mkShell { packages = allPackages; };
    };
}

