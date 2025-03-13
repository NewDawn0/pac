{
  description = "Pacman Ascii Banner Speed Test 🏁👾";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { self, utils, ... }: {
    overlays.default = final: prev: {
      pac = self.packages.${prev.system}.default;
      pac-asm = self.packages.${prev.system}.pac-asm;
      pac-c = self.packages.${prev.system}.pac-c;
      pac-cpp = self.packages.${prev.system}.pac-cpp;
      pac-f90 = self.packages.${prev.system}.pac-f90;
      pac-rs = self.packages.${prev.system}.pac-rs;
      pac-rs2 = self.packages.${prev.system}.pac-rs2;
      pac-zig = self.packages.${prev.system}.pac-zig;
    };
    packages = utils.lib.eachSystem { } (pkgs:
      with pkgs;
      let
        common = {
          name = "pac";
          version = "1.0.0";
          src = ./.;
          installPhase = "install -D pac $out/bin/pac";
          meta = {
            meta = {
              description = "Pacman Ascii Banner Speed Test 🏁👾";
              homepage = "https://github.com/NewDawn0/pac";
              license = lib.licenses.mit;
              maintainers = with lib.maintainers; [ NewDawn0 ];
              platforms = lib.platforms.all;
            };
          };
        };
        flags = {
          cflags = "-O3 -Ofast -o pac";
          cxxflags = "-O3 -Ofast -o pac -std=c++20";
          rustflags = "-C opt-level=3 -o pac";
          zigflags =
            "-OReleaseFast -fstrip -femit-bin=pac --global-cache-dir $cacheDir";
          ldflags = "-static -o pac pac.o";
          fortranflags = "-O3 -Ofast -fbackslash -o pac";
        };
        # Bins
        pac-asm = stdenv.mkDerivation {
          inherit (common) name version src installPhase meta;
          patchPhase = ''
            ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
              patch ./src/asm/pac.asm < ./patches/asm/pac.patch
            ''}
          '';
          buildPhase = ''
            ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
              nasm -fmacho64 -o pac.o ./src/asm/pac.asm
              ld -lSystem -L$(xcrun --show-sdk-path)/usr/lib -o pac pac.o
            ''}
            ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
              nasm -felf64 -o pac.o ./src/asm/pac.asm
              ld -o pac pac.o
            ''}
          '';
          buildInputs = [ nasm ];
        };
        pac-c = stdenv.mkDerivation {
          inherit (common) name version src installPhase meta;
          buildPhase = "cc ${flags.cflags} ./src/c/pac.c";
        };
        pac-cpp = stdenv.mkDerivation {
          inherit (common) name version src installPhase meta;
          buildInputs = [ libcxx ];
          buildPhase = "clang++ ${flags.cxxflags} ./src/cpp/pac.cpp";
        };
        pac-f90 = stdenv.mkDerivation {
          inherit (common) name version src installPhase meta;
          buildInputs = [ gfortran ];
          buildPhase = "gfortran ${flags.fortranflags} ./src/f90/pac.f90";
        };
        pac-rs = stdenv.mkDerivation {
          inherit (common) name version src installPhase meta;
          buildInputs = [ rustc ];
          buildPhase = "rustc ${flags.rustflags} ./src/rs/pac.rs";
        };
        pac-rs2 = stdenv.mkDerivation {
          inherit (common) name version src installPhase meta;
          buildInputs = [ rustc ];
          buildPhase = "rustc ${flags.rustflags} ./src/rs/pac-macro.rs";
        };
        pac-zig = stdenv.mkDerivation {
          inherit (common) name version src installPhase meta;
          buildInputs = [ zig ];
          buildPhase = ''
            ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
              # On Darwin the executable needs to link to libSystem
              export LIBRARY_PATH="$(xcrun --show-sdk-path)/usr/lib"
              export DYLD_LIBRARY_PATH="$(xcrun --show-sdk-path)/usr/lib"
            ''}
            cacheDir=$(mktemp -d)
            zig build-exe ${flags.zigflags} ./src/zig/pac.zig
          '';
        };
      in {
        inherit pac-asm pac-c pac-cpp pac-f90 pac-rs pac-rs2 pac-zig;
        default = pac-zig;
      });
  };
}
