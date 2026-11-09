{
  description = "Go EDA template";

  inputs = {
    nixpkgs = {
      url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    };
  };

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = f:
      systems
      |> lib.genAttrs (system: import nixpkgs { inherit system; })
      |> lib.mapAttrs (_: pkgs: f pkgs);

    makePackage = pkgs:
      pkgs.buildGo127Module {
        pname = "system";
        version = "0.1.0";

        src = ./.;

        # replace with lib.fakeHash when we start using dependencies. when
        # building, it will output the real hash, which then must be used.
        # when not using any dependencies, this must be set to null.
        vendorHash = null;
      };

  in {
    packages = forAllSystems (pkgs: {
      default = makePackage pkgs;
    });
  };
}
