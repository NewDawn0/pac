# 🏎️ **Pac** – Gotta Go Fast!

![pac](./.github/pac.png)

### **What’s this?**

Pac is an ultra-fast **ASCII art Pac-Man renderer**, pitting compiled languages against each other in a **brutal speed showdown**. Ever wondered how slow your favorite language is? Don’t worry, we won’t judge... much. 😏

<details>
<summary>⏳ <b>Performance?</b> Let's just say, some languages age like fine wine... others age like milk.</summary>

![performance](./.github/perf.png)

</details>

<!-- vim-markdown-toc GFM -->

* [🕹️ **Description**](#-description)
* [✨ **Features**](#-features)
* [⚙️ **Building a Version**](#-building-a-version)
* [🚀 **Testing & Profiling**](#-testing--profiling)
    * [📊 **Measuring Performance**](#-measuring-performance)
    * [🔨 **Checking All Builds**](#-checking-all-builds)
* [🤝 **Contributing**](#-contributing)
    * [📌 **Constraints**](#-constraints)
    * [📢 **Adding Your Version**](#-adding-your-version)

<!-- vim-markdown-toc -->

## 🕹️ **Description**

This project **renders an ASCII Pac-Man** using various programming languages and **races them against each other**. Who will emerge victorious?

- **Assembly flexing its muscles?** 💪
- **Rust with its zero-cost abstractions?** 🦀
- **C & C++ clinging to their glory days?** 🤠
- **Zig casually outperforming them all?** ⚡
- **Fortran making a surprise comeback? 📈📊**
- **Python? Oh… wait, we left it out for a reason.** 🐌
- **And many more ...**

Each version runs **1000 iterations**, measuring how much CPU pain it inflicts. Let the battle begin! 🔥

## ✨ **Features**

- ✔️ **ASCII Pac-Man**, because why not?
- ✔️ **Beautiful colored Unicode output** (we fancy)
- ✔️ **Multiple implementations** (Assembly, C, C++, Rust, Zig, etc.)
- ✔️ **Performance benchmarking** – find out which language reigns supreme
- ✔️ **100% fun, 0% JavaScript** 😈

## ⚙️ **Building a Version**

First, clone the repo and navigate to the directory:

```bash
git clone https://github.com/NewDawn0/pac.git
cd pac
```

Then, build the default version:

```bash
nix build .
```

To build a specific version (because you have _taste_):

```bash
nix build .#<version>
```

To check all available implementations:

```bash
nix flake show
```

## 🚀 **Testing & Profiling**

Enter the **devshell** (grants access to testing tools):

```bash
nix develop
```

### 📊 **Measuring Performance**

To see how fast (or slow) an implementation is, run:

```bash
measure
```

This **executes the last built version for 1000 iterations** and spits out the elapsed time. If your language takes longer than a coffee break... well, you know what to do. ☕🚀

### 🔨 **Checking All Builds**

To verify that all versions at least **compile** (no participation trophies here):

```bash
build-all
```

## 🤝 **Contributing**

Think your favorite language can beat the competition? Prove it. **Submit your own implementation** and watch it rise (or crash and burn).

### 📌 **Constraints**

- The implementation **must compile** to a `pac` executable.
- Must work on **Linux and macOS**.
- **Pac-Man & Ghosts** must be **stored separately**, no color formatting baked in.
- **No external libraries or frameworks** – raw power only.

### 📢 **Adding Your Version**

1. **Fork the repo**
2. Write your **speed demon** of an implementation
3. Place it in `./src/<language-extension>/pac-<your-impl>`
4. Update `./build.nix` and **make sure it builds**
5. **Submit a PR**

🚀 **I dare you to make it faster.** **The real question is: are you brave enough?** 😏
