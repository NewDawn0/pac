// Artworks and colours as macros so they can be formatted at compile time
#[rustfmt::skip]
macro_rules! col {
    (yellow) => { "\x1b[0;33m" };
    (red)    => { "\x1b[0;31m" };
    (cyan)   => { "\x1b[0;36m" };
    (pink)   => { "\x1b[0;35m" };
    (white)  => { "\x1b[0;37m" };
    (nc)     => { "\x1b[0m" };
}

#[rustfmt::skip]
macro_rules! pac {
    ($col:ident, 0) => { concat!(col!($col), "   ▄███████▄  ") };
    ($col:ident, 1) => { concat!(col!($col), " ▄█████████▀▀ ") };
    ($col:ident, 2) => { concat!(col!($col), " ███████▀     ") };
    ($col:ident, 3) => { concat!(col!($col), " ███████▄     ") };
    ($col:ident, 4) => { concat!(col!($col), " ▀█████████▄▄ ") };
    ($col:ident, 5) => { concat!(col!($col), "   ▀███████▀  ") };
}

#[rustfmt::skip]
macro_rules! balls {
    ($col:ident, 0) => { concat!(col!($col), "            ") };
    ($col:ident, 1) => { concat!(col!($col), "            ") };
    ($col:ident, 2) => { concat!(col!($col), " ▄██▄  ▄██▄ ") };
    ($col:ident, 3) => { concat!(col!($col), " ▀██▀  ▀██▀ ") };
    ($col:ident, 4) => { concat!(col!($col), "            ") };
    ($col:ident, 5) => { concat!(col!($col), "            ") };
}

#[rustfmt::skip]
macro_rules! ghost {
    ($col:ident, 0) => { concat!(col!($col), "   ▄██████▄   ") };
    ($col:ident, 1) => { concat!(col!($col), " ▄", col!(white), "█▀█", col!($col), "██", col!(white), "█▀█", col!($col), "██▄ ") };
    ($col:ident, 2) => { concat!(col!($col), " █", col!(white), "▄▄█", col!($col), "██", col!(white), "▄▄█", col!($col), "███ ") };
    ($col:ident, 3) => { concat!(col!($col), " ████████████ ") };
    ($col:ident, 4) => { concat!(col!($col), " ██▀██▀▀██▀██ ") };
    ($col:ident, 5) => { concat!(col!($col), " ▀   ▀  ▀   ▀ ") };
}

#[rustfmt::skip]
macro_rules! artln {
    ($i:tt, $(($recv:ident, $col:ident)),+) => { concat!($($recv!($col, $i)),+) };
}

macro_rules! art {
    // We cannot have multiple repeats therefore we have to explicitly set the amount of lines a..=f
    (($a:tt,$b:tt,$c:tt,$d:tt,$e:tt,$f:tt), $(($recv:ident, $col:ident)),+) => {
        concat!(
            artln!($a, $(($recv, $col)),+), col!(nc), "\n",
            artln!($b, $(($recv, $col)),+), col!(nc), "\n",
            artln!($c, $(($recv, $col)),+), col!(nc), "\n",
            artln!($d, $(($recv, $col)),+), col!(nc), "\n",
            artln!($e, $(($recv, $col)),+), col!(nc), "\n",
            artln!($f, $(($recv, $col)),+), col!(nc)
        )
    };
}

fn main() {
    println!("{}", ART);
}

const ART: &'static str = art!(
    (0, 1, 2, 3, 4, 5),
    (pac, yellow),
    (balls, white),
    (ghost, red),
    (ghost, cyan),
    (ghost, pink)
);
