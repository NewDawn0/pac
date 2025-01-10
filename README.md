![pac](./.github/pac.png)

# Pac

Fast pac man art in the terminal

<!-- vim-markdown-toc GFM -->

* [Description](#description)
* [Features](#features)
* [Supported versions](#supported-versions)
* [Building the Project](#building-the-project)
* [Measuring Performance](#measuring-performance)
* [Contributing](#contributing)
    * [Constraints](#constraints)
    * [Adding your version](#adding-your-version)

<!-- vim-markdown-toc -->

## Description

This project generates an ASCII art representation of Pac-Man using different programming languages and compares their performance. The output includes coloured Pac-Man ASCII art and utilizes Unicode characters for the visual effects. You can build and run different versions of the program written in C, C++, Zig, Rust, and Assembly. Additionally, the program allows you to measure the performance of each version by running 1000 iterations and reporting the elapsed time.

## Features

- ASCII art representation of Pac-Man
- Colours and Unicode characters used to enhance the visual output
- Multiple versions/implementations in different languages:
  - C
  - C++
  - Zig
  - Rust
  - Assembly (Nasm)
- Measures performance across languages and implementations

## Supported versions

To build a specific version of the project, use the following command:

```bash
./build.sh <version>
```

Where `<version>` can be any of the following:

- `c`: The first and initial version of the project
- `cpp`: The C++ version
- `zig`: Zig version utilizing comptime
- `rust-v1`: First Rust version
- `rust-v2`: Second Rust version utilizing macros at compile time
- `asm`: The assembly (nasm flavour) version

## Building the Project

To get started, clone the repository and navigate to the project director:

```bash
git clone https://github.com/NewDawn0/pac.git
cd pac
```

Next rune the build script to compile a version of the project

```bash
./build.sh <version>
```

This will compile the specific implementation you chose and generate the pac executable

## Measuring Performance

To get the performance of an implementation build and measure it using:

```bash
./build.sh <version> measure
```

This will:

- Build the executable
- Run the version for 1000 iterations
- Show the elapsed time

## Contributing

Feel free to upload your own version of the Pac-Man script in any language, and make it as fast as possible! To contribute, follow these steps:

### Constraints

- The version must be in a single file and must compile to the pac executable
- The version must at least support macOS & Linux
- All the figures objects (eg. Pac-Man, Ghosts, ...) must be stored separately and cannot be initially stored with colour formatting

### Adding your version

1. Fork the repo
2. Add your implementation in a new language or improve an existing one
3. Add your source in `./src/<your-language>/pac-<your-impl>` where the file must be just called `pac` if there isn't a preexisting file with that name
4. Add your build function to `build.sh`
5. Create a PR

I welcome contributions and look forward to seeing how fast you can make your version!
