{
  description = "Standalone Neovim config flake";

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
      homeManagerModules.default = { config, lib, pkgs, configPath ? null
        , # <-- custom path to real config
        ... }: {
          home.packages = allPackages;

          # Only use mkOutOfStoreSymlink if a real path was provided
          home.file.".config/nvim" = if configPath != null then {
            source = lib.file.mkOutOfStoreSymlink configPath;
          } else {
            # fallback: immutable store symlink (not recommended for development)
            source = ./config;
          };
        };

      devShells.${system}.default = pkgs.mkShell { packages = allPackages; };
    };
}

