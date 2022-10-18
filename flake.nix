{
  # main
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  # dev
  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = with inputs; [
            devshell.overlay
          ];
        };
      in {
        packages = flake-utils.lib.flattenTree {
          default = pkgs.nimPackages.buildNimPackage {
            name = "nim-play";
            src = ./.;
          };
        };
        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
        };

        devShells.default = pkgs.devshell.mkShell {
          packages = with pkgs; [
            alejandra
            treefmt
            nimble-unwrapped
          ];
          commands = [
            {
              package = "treefmt";
              category = "formatter";
            }
          ];
          env = [
          ];
        };
      }
    );
}
