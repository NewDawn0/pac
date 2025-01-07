fn main() {
    let arts: Vec<ArtType> = vec![
        ArtType::Art(Art::new(COLS.yellow, PAC_ART)),
        ArtType::Art(Art::new(COLS.white, BALLS_ART)),
        ArtType::Ghost(Ghost::new(COLS.red, GHOST_ART)),
        ArtType::Ghost(Ghost::new(COLS.cyan, GHOST_ART)),
        ArtType::Ghost(Ghost::new(COLS.pink, GHOST_ART)),
    ];
    print!("{}", build_str(&arts));
}

fn build_str(arts: &[ArtType]) -> String {
    // Use capacity for little performance gain
    let mut out = String::with_capacity(ART_SIZE * arts.len() * 20);
    for idx in 0..ART_SIZE {
        for art in arts.iter() {
            out.push_str(&art.artify()[idx]);
        }
        out.push_str(COLS.nc);
        out.push('\n');
    }
    out
}

// Global vars
const ART_SIZE: usize = 6;
static COLS: Cols = Cols::new();

trait Artifyable {
    fn artify(&self) -> &[String; 6];
}
// Use enum to avoid dynamic dispatch speeds up runtim
enum ArtType {
    Art(Art),
    Ghost(Ghost),
}
impl Artifyable for ArtType {
    fn artify(&self) -> &[String; 6] {
        match self {
            ArtType::Art(art) => art.artify(),
            ArtType::Ghost(ghost) => ghost.artify(),
        }
    }
}
// Art structs
struct Art {
    art: [String; ART_SIZE],
}
impl Art {
    fn new(col: &'static str, art: [&'static str; ART_SIZE]) -> Self {
        Self {
            art: art.map(|e| format!("{}{}", col, e)),
        }
    }
}
impl Artifyable for Art {
    fn artify(&self) -> &[String; 6] {
        &self.art
    }
}

struct Ghost {
    art: [String; ART_SIZE],
}
impl Ghost {
    fn new(col: &'static str, art: [&'static str; ART_SIZE]) -> Self {
        let eye_col = COLS.white;
        let art = art.map(|ln| {
            format!("{}{}", col, ln)
                .replace("C", eye_col)
                .replace("R", col)
        });
        Self { art }
    }
}
impl Artifyable for Ghost {
    fn artify(&self) -> &[String; 6] {
        &self.art
    }
}

// Colours
struct Cols {
    yellow: &'static str,
    red: &'static str,
    cyan: &'static str,
    pink: &'static str,
    white: &'static str,
    nc: &'static str,
}
impl Cols {
    const fn new() -> Self {
        Self {
            yellow: "\x1b[0;33m",
            red: "\x1b[0;31m",
            cyan: "\x1b[0;36m",
            pink: "\x1b[0;35m",
            white: "\x1b[0;37m",
            nc: "\x1b[0m",
        }
    }
}

// Artworks
const PAC_ART: [&'static str; 6] = [
    "   ▄███████▄  ",
    " ▄█████████▀▀ ",
    " ███████▀     ",
    " ███████▄     ",
    " ▀█████████▄▄ ",
    "   ▀███████▀  ",
];
const BALLS_ART: [&'static str; 6] = [
    "            ",
    "            ",
    " ▄██▄  ▄██▄ ",
    " ▀██▀  ▀██▀ ",
    "            ",
    "            ",
];
const GHOST_ART: [&'static str; 6] = [
    // C Is for the Art Eye color
    // R Is for reset to the color
    "   ▄██████▄   ",
    " ▄C█▀█R██C█▀█R██▄ ",
    " █C▄▄█R██C▄▄█R███ ",
    " ████████████ ",
    " ██▀██▀▀██▀██ ",
    " ▀   ▀  ▀   ▀ ",
];
