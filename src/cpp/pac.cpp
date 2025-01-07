#include <array>
#include <iostream>
#include <string>
#include <vector>

typedef unsigned char uchar;

constexpr const char *YELLOW = "\x1b[0;33m";
constexpr const char *RED = "\x1b[0;31m";
constexpr const char *CYAN = "\x1b[0;36m";
constexpr const char *PINK = "\x1b[0;35m";
constexpr const char *WHITE = "\x1b[0;37m";
constexpr const char *NC = "\x1b[0m";

class Art {
public:
  const std::string col;
  std::array<std::string, 6> art;
  Art(const std::string col, const std::array<std::string, 6> &art);
  std::array<std::string, 6> getArt() const;
};

class Ghost : public Art {
private:
  inline void repl(std::string &str, const std::string &x,
                   const std::string &xs) const;
  inline void setFmt();

public:
  Ghost(const std::string col, const std::array<std::string, 6> &art);
};

const void cleanUp();
std::string buildArt(std::vector<Art *> arts);

// Arts
Art *PAC = // clang-format off
  new Art(YELLOW, {
    "   ▄███████▄  ",
    " ▄█████████▀▀ ",
    " ███████▀     ",
    " ███████▄     ",
    " ▀█████████▄▄ ",
    "   ▀███████▀  ",
  }
);
// clang-format on
Art *BALLS = // clang-format off
  new Art(WHITE, {
    "            ",
    "            ",
    " ▄██▄  ▄██▄ ",
    " ▀██▀  ▀██▀ ",
    "            ",
    "            ",
  }
);
// clang-format on

const std::array<std::string, 6> GHOST_ART = {
    // clang-format off
        // C Is for the Art Eye color
        // R Is for reset to the color
        "   ▄██████▄   ",
        " ▄C█▀█R██C█▀█R██▄ ",
        " █C▄▄█R██C▄▄█R███ ",
        " ████████████ ",
        " ██▀██▀▀██▀██ ",
        " ▀   ▀  ▀   ▀ "
    // clang-format on
};
Ghost *GHOST0 = new Ghost(RED, GHOST_ART);
Ghost *GHOST1 = new Ghost(CYAN, GHOST_ART);
Ghost *GHOST2 = new Ghost(PINK, GHOST_ART);

int main(void) {
  std::cout << buildArt({PAC, BALLS, GHOST0, GHOST1, GHOST2}) << std::endl;
  cleanUp();
  return 0;
}

const void cleanUp() {
  delete PAC;
  delete BALLS;
  delete GHOST0;
  delete GHOST1;
  delete GHOST2;
}

std::string buildArt(std::vector<Art *> arts) {
  std::string out;
  out = "";
  std::vector<std::array<std::string, 6>> artStrs;
  for (const auto &art : arts) {
    artStrs.push_back(art->getArt());
  }
  for (uchar i = 0; i < 6; ++i) {
    for (const auto &artStr : artStrs) {
      out += artStr[i];
    }
    out += "\n";
  }
  return out;
}

// Art impl
Art::Art(const std::string col, const std::array<std::string, 6> &art)
    : col(col), art(art){};
std::array<std::string, 6> Art::getArt() const {
  std::array<std::string, 6> modArt = art;
  for (auto &ln : modArt) {
    ln = col + ln;
  }
  return modArt;
}

// Ghost impl
Ghost::Ghost(const std::string col, const std::array<std::string, 6> &art)
    : Art(col, art) {
  setFmt();
}
inline void Ghost::repl(std::string &str, const std::string &x,
                        const std::string &xs) const {
  size_t pos = 0;
  while ((pos = str.find(x, pos)) != std::string::npos) {
    str.replace(pos, 1, xs);
    pos += 2;
  }
}
inline void Ghost::setFmt() {
  for (uchar i = 1; i < 3; i++) {
    repl(art[i], "C", WHITE);
    repl(art[i], "R", col);
  }
}
