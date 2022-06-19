# Copyright 2022 Joshua Wong.
# SPDX-License-Identifier: Apache-2.0

{
  description = "Haskell Project Template";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem(system:
    let pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskell.packages.ghc923;
        shellDeps = with haskellPackages; [
          cabal-fmt
          cabal-install
          ghcid
          haskell-language-server
          ormolu
          hlint
        ];
        name = "PACKAGE NAME HERE";
        project = { shell ? false }:
          haskellPackages.developPackage {
            returnShellEnv = shell;
            withHoogle = shell;
            inherit name;
            root = ./.;
            overrides = final: prev: {
              # use pkgs.haskell.lib.callCabal2nix to override deps
            };
            modifier = drv:
            pkgs.haskell.lib.overrideCabal drv (oa: {
              buildTools = (oa.buildTools or [ ]) ++ pkgs.lib.optionals shell shellDeps;
            });
          };
        package = project { };
        app = flake-utils.lib.mkApp {
          drv = package;
        };
    in
    {
      packages.default = package;
      apps.default = app;
      devShells.default = project { shell = true; };
    });
}
