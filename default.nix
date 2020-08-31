{ system ? builtins.currentSystem
, nixpkgsMozilla ? builtins.fetchGit {
    url = https://github.com/mozilla/nixpkgs-mozilla;
    ref = "4521bc61c2332f41e18664812a808294c8c78580";
  }
, cargo2nix ? builtins.fetchGit {
    url = https://github.com/tenx-tech/cargo2nix;
    ref = "ada69dafa095da4133a42abb292f22f12f2c4f36";
  }
}:
let
  pkgs = import <nixpkgs> {
    inherit system;
    overlays = [
      (import "${cargo2nix}/overlay")
      (import "${nixpkgsMozilla}/rust-overlay.nix")
    ];
  };

  rustPkgs = pkgs.rustBuilder.makePackageSet' {
    rustChannel = "stable";
    packageFun = import ./Cargo.nix;
  };
in rustPkgs.workspace.zmq {}
