{
  description = "A very basic flake";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs"; };

  outputs = { nixpkgs, ... }:
    let
      mkPkgs = system: nixpkgs.legacyPackages.${system};

      flags = {
        cflags = "-O3 -Ofast -o pac";
        cxxflags = flags.cflags;
        rustflags = "-C opt-level=3 -o pac";
        zigflags =
          "-OReleaseFast -fstrip -femit-bin=pac --global-cache-dir $cacheDir";
        ldflags = "-static -o pac pac.o";
      };
      patches = pkgs: {
        zig = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
          # On Darwin the executable needs to link to libSystem found in /usr/lib/
          export LIBRARY_PATH=/usr/lib
          export DYLD_LIBRARY_PATH=/usr/lib
        '';
      };
      buildAttrs = {
        name = "pac";
        version = "v1.0.0";
        src = ./.;
        installPhase = ''
          mkdir -p $out/bin
          cp pac $out/bin
        '';
      };

      getPkgs = pkgs:
        (import ./build.nix {
          inherit pkgs buildAttrs flags;
          patches = patches pkgs;
        });
      macPkgs = sys:
        let inherit (getPkgs (mkPkgs sys)) all mac default;
        in all // mac // { inherit default; };
      linuxPkgs = sys:
        let inherit (getPkgs (mkPkgs sys)) all linux default;
        in all // linux // { inherit default; };
    in {
      overlays = {
        x86_64-darwin = (final: prev: { default = macPkgs "x86_64-darwin"; });
        aarch64-darwin = (final: prev: { default = macPkgs "aarch64-darwin"; });
        x86_64-linux = (final: prev: { default = macPkgs "x86_64-linux"; });
        aarch64-linux = (final: prev: { default = macPkgs "aarch64-linux"; });
      };
      packages = {
        x86_64-darwin = macPkgs "x86_64-darwin";
        aarch64-darwin = macPkgs "aarch64-darwin";
        x86_64-linux = linuxPkgs "x86_64-linux";
        aarch64-linux = linuxPkgs "aarch64-linux";
      };
    };
}
