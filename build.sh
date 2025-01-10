#!/usr/bin/env bash

CFLAGS="-O3 -Ofast"
CPPFLAGS="$CFLAGS"
RUSTFLAGS="-C opt-level=3"
ZIGFLAGS="-OReleaseFast -fstrip"
ASMFLAGS="-fmacho64"
LDFLAGS="-static"

OUTFILE="pac"
OS="$(uname)"
ITERATIONS=1000

helpMsg() {
    cat << EOF
  builder.sh <rule(s)>

Available rules:
- c           => C version
- cpp         => C++ version
- zig         => Zig version
- asm         => Assembly version
- rust-v1     => Rust 1st version
- rust-v2     => Rust 2nd version with macros
- measure     => Get performance
- clean       => Remove built files
- -h | --help => Print this menu
EOF
}

clean() {
    rm pac*
}

checkBin() {
    if command -v "$1" &>/dev/null; then
        return 0
    else
        echo "$1 is not in the PATH -> exiting..."
        exit 1
    fi
}

measure() {
    echo "Testing pac for $ITERATIONS iterations"
    {
        time for ((i=1; i<="$ITERATIONS"; i++)); do
            ./pac > /dev/null 2>&1
        done
    } 2>&1 | grep real
}

build-c() {
    checkBin "gcc"
    echo "Building C version as $OUTFILE"
    gcc $CFLAGS -o "$OUTFILE" ./src/c/pac.c
    strip "$OUTFILE"
}

build-cpp() {
    checkBin "g++"
    echo "Building C++ version as $OUTFILE"
    g++ $CPPFLAGS -o "$OUTFILE" ./src/cpp/pac.cpp
    strip "$OUTFILE"
}

build-zig() {
    checkBin "zig"
    echo "Building Zig version as $OUTFILE"
    zig build-exe $ZIGFLAGS "-femit-bin=$OUTFILE" ./src/zig/pac.zig
    strip "$OUTFILE"
    rm "${OUTFILE}.o"
}

build-rust() {
    checkBin "rustc"
    echo "Building Rust version as $OUTFILE"
    rustc $RUSTFLAGS -o "$OUTFILE" "$1"
    strip "$OUTFILE"
}

build-asm() {
    checkBin "nasm"
    echo "Building Assembly version as $OUTFILE"
    if [ "$OS" != "Darwin" ]; then
      echo "This Assembly version is only available on macOS"
      exit 1
    fi
    nasm $ASMFLAGS -o "${OUTFILE}.o" ./src/asm/pac.asm
    ld $LDFLAGS -o "$OUTFILE" "${OUTFILE}.o"
    rm "${OUTFILE}.o"
    strip "$OUTFILE"
}

checkArg() {
    case "$1" in
        "c") build-c ;;
        "cpp") build-cpp ;;
        "zig") build-zig ;;
        "asm") build-asm ;;
        "rust-v1") build-rust ./src/rs/pac.rs ;;
        "rust-v2") build-rust ./src/rs/pac.rs ;;
        "clean") clean ;;
        "measure") measure ;;
        "-h" | "--help") helpMsg ;;
        *) echo "Invalid arg '$1'"
            helpMsg
            exit 1 ;;
    esac

}

main () {
    checkBin "ld"
    checkBin "strip"
    if [ "$1" != "" ]; then
        for arg in "$@"; do
            checkArg "$arg"
        done
    else
        echo "No arg provided"
        helpMsg
        exit 1
    fi
}

main "$@"
