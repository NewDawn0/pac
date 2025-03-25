{ pkgs }:
let
  name = "pac";
  src = ./.;
  installPhase = "install -D pac $out/bin/pac";
  mkMeta = { names ? [ pkgs.lib.maintainers.NewDawn0 ] }: {
    description = "Pacman Ascii Banner & Speed Test 🏁👾";
    homepage = "https://github.com/NewDawn0/pac";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.all;
    maintainers = names;
  };
in {
  # Each derivation must have:
  #   - version (starting at 1.0.0)
  #   - meta with maintainer (use mkMeta function with maintainer names)
  #   - other attrs can be inherited
  #
  #   - example:
  #     pac-c = pkgs.stdenv.mkDerivation {
  #       inherit name src installPhase meta;
  #       buildPhase = "cc -o pac src/c/pac.c";
  #       meta = mkMeta { names = [ "Your Name" "Some other contributor" ]; }
  #     };
  #
  pac-asm = let
    linuxPatch = with pkgs;
      lib.optionalString stdenv.hostPlatform.isLinux ''
        patch ./src/asm/pac.asm < ./patches/asm/pac.patch
      '';
    darwinBuild = with pkgs;
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        nasm -fmacho64 -o pac.o ./src/asm/pac.asm
        ld -lSystem -L$(xcrun --show-sdk-path)/usr/lib -o pac pac.o
      '';
    linuxBuild = with pkgs;
      lib.optionalString stdenv.hostPlatform.isLinux ''
        nasm -felf64 -o pac.o ./src/asm/pac.asm
        ld -o pac pac.o
      '';
  in pkgs.stdenv.mkDerivation {
    inherit installPhase name src;
    version = "1.0.1";
    meta = mkMeta { };
    patchPhase = linuxPatch;
    buildInputs = [ pkgs.nasm ];
    buildPhase = darwinBuild + linuxBuild;
  };
  pac-c = pkgs.stdenv.mkDerivation {
    inherit installPhase name src;
    version = "1.0.0";
    meta = mkMeta { };
    buildPhase = "cc -O3 -Ofast -o pac ./src/c/pac.c";
  };
  pac-cpp = pkgs.stdenv.mkDerivation {
    inherit installPhase name src;
    version = "1.0.1";
    meta = mkMeta { };
    buildInputs = [ pkgs.libcxx ];
    buildPhase = "clang++ -std=c++20 -O3 -Ofast -o pac ./src/cpp/pac.cpp";
  };
  pac-f90 = pkgs.stdenvNoCC.mkDerivation {
    inherit installPhase name src;
    version = "1.0.0";
    meta = mkMeta { };
    buildInputs = [ pkgs.gfortran ];
    buildPhase = "gfortran -O3 -Ofast -fbackslash -o pac ./src/f90/pac.f90";
  };
  pac-rs = pkgs.stdenv.mkDerivation {
    inherit installPhase name src;
    version = "1.0.0";
    meta = mkMeta { };
    buildInputs = [ pkgs.rustc ];
    buildPhase = "rustc -C opt-level=3 -o pac ./src/rs/pac.rs";
  };
  pac-rs-macro = pkgs.stdenv.mkDerivation {
    inherit installPhase name src;
    version = "1.0.0";
    meta = mkMeta { };
    buildInputs = [ pkgs.rustc ];
    buildPhase = "rustc -C opt-level=3 -o pac ./src/rs/pac-macro.rs";
  };
  pac-zig = let
    # On Darwin the executable needs to link to libSystem
    darwinBuildPatch = with pkgs;
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        export LIBRARY_PATH="$(xcrun --show-sdk-path)/usr/lib"
        export DYLD_LIBRARY_PATH="$(xcrun --show-sdk-path)/usr/lib"
      '';
  in pkgs.stdenvNoCC.mkDerivation {
    inherit installPhase name src;
    version = "1.0.0";
    meta = mkMeta { };
    buildInputs = [ pkgs.zig ];
    buildPhase = darwinBuildPatch + ''
      cacheDir=$(mktemp -d)
      zig build-exe -OReleaseFast -fstrip -femit-bin=pac --global-cache-dir $cacheDir ./src/zig/pac.zig
    '';
  };
}
