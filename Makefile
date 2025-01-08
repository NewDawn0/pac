CFLAGS = -O3 -Ofast -funroll-loops -ftree-vectorize -flto -fno-exceptions -fno-math-errno -fmerge-all-constants -fomit-frame-pointer -fno-stack-protector -march=native
CPPFLAGS = $(CFLAGS) -fno-rtti -fno-threadsafe-statics
RUSTFLAGS = -C target-cpu=native -C opt-level=3 -C debuginfo=none -C force-frame-pointers=no -C force-unwind-tables=no -C lto=y -C overflow-checks=n -C panic=abort -C strip=symbols
ZIGFLAGS = -mred-zone -OReleaseFast -fstrip -fomit-frame-pointer -fno-stack-check -fno-stack-protector -fno-builtin -fno-sanitize-thread -fno-unwind-tables -fno-error-tracing

build-c:
	gcc $(CFLAGS) -o pac ./src/c/pac.c

build-cpp:
	g++ $(CPPFLAGS) -o pac ./src/cpp/pac.cpp

build-rs:
	rustc $(RUSTFLAGS) ./src/rs/pac.rs

build-rs-macro:
	rustc $(RUSTFLAGS) -o pac ./src/rs/macro-pac.rs

build-zig:
	zig build-exe $(ZIGFLAGS) ./src/zig/pac.zig

build-all:
	gcc $(CFLAGS) -o pac-c ./src/c/pac.c
	g++ $(CPPFLAGS) -o pac-cpp ./src/cpp/pac.cpp
	rustc $(RUSTFLAGS) -o pac-rs ./src/rs/pac.rs
	rustc $(RUSTFLAGS) -o pac-rs2 ./src/rs/macro-pac.rs
	zig build-exe $(ZIGFLAGS) -femit-bin=pac-zig ./src/zig/pac.zig
