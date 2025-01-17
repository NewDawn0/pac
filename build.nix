{ pkgs, buildAttrs, patches, flags }:
let
  c = pkgs.stdenv.mkDerivation {
    inherit (buildAttrs) installPhase name src version;
    buildPhase = "cc ${flags.cflags} ./src/c/pac.c";
  };
  cpp = pkgs.stdenv.mkDerivation {
    inherit (buildAttrs) installPhase name src version;
    buildInputs = with pkgs; [ libcxx ];
    buildPhase = "clang++ ${flags.cxxflags} ./src/cpp/pac.cpp";
  };
  rust = pkgs.stdenv.mkDerivation {
    inherit (buildAttrs) installPhase name src version;
    buildInputs = [ pkgs.rustc ];
    buildPhase = "rustc ${flags.rustflags} ./src/rs/pac.rs";
  };
  rust2 = pkgs.stdenv.mkDerivation {
    inherit (buildAttrs) installPhase name src version;
    buildInputs = [ pkgs.rustc ];
    buildPhase = "rustc ${flags.rustflags} ./src/rs/pac-macro.rs";
  };
  asm = pkgs.stdenv.mkDerivation {
    inherit (buildAttrs) installPhase name src version;
    buildInputs = [ pkgs.nasm ];
    buildPhase = ''
      nasm -fmacho64 -o pac.o ./src/asm/pac.asm
      ld ${flags.ldflags}
    '';
  };
  zig = pkgs.stdenv.mkDerivation {
    inherit (buildAttrs) installPhase name src version;
    buildInputs = [ pkgs.zig ];
    buildPhase = ''
      ${patches.zig}
      cacheDir=$(mktemp -d)
      zig build-exe ${flags.zigflags} ./src/zig/pac.zig
    '';
  };
  fortran = pkgs.stdenv.mkDerivation {
    inherit (buildAttrs) installPhase name src version;
    buildInputs = [ pkgs.gfortran ];
    buildPhase = ''
      gfortran ${flags.fortranflags} ./src/fortran/pac.f90
    '';
  };
in {
  default = zig; # Default must be cross platform
  all = { inherit c cpp rust rust2 zig fortran; };
  mac = { inherit asm; };
  linux = { };
}
