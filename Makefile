CFLAGS = -O3 -Ofast -Os
CPPFLAGS = $(CFLAGS)
RUSTFLAGS = -C opt-level=3
ZIGFLAGS = -OReleaseFast -fstrip
ASMFLAGS = -fmacho64
LDFLAGS = -static

build-c:
	gcc $(CFLAGS) -o pac ./src/c/pac.c
	strip pac

build-cpp:
	g++ $(CPPFLAGS) -o pac ./src/cpp/pac.cpp
	strip pac

build-rs:
	rustc $(RUSTFLAGS) ./src/rs/pac.rs
	strip pac

build-rs-macro:
	rustc $(RUSTFLAGS) -o pac ./src/rs/macro-pac.rs
	strip pac

build-zig:
	zig build-exe $(ZIGFLAGS) ./src/zig/pac.zig
	strip pac
	rm *.o

build-asm:
	nasm $(ASMFLAGS) -o pac.o ./src/asm/pac.asm
	ld $(LDFLAGS) -o pac pac.o
	strip pac
	rm *.o

build-all:
	gcc $(CFLAGS) -o pac-c ./src/c/pac.c
	g++ $(CPPFLAGS) -o pac-cpp ./src/cpp/pac.cpp
	rustc $(RUSTFLAGS) -o pac-rs ./src/rs/pac.rs
	rustc $(RUSTFLAGS) -o pac-rs2 ./src/rs/macro-pac.rs
	zig build-exe $(ZIGFLAGS) -femit-bin=pac-zig ./src/zig/pac.zig
	nasm $(ASMFLAGS) -o pac-asm.o ./src/asm/pac.asm
	ld $(LDFLAGS) -o pac-asm pac-asm.o
	strip pac-c pac-cpp pac-rs pac-rs2 pac-zig pac-asm
	rm *.o

clean:
	rm pac*
