#include <cstddef>
#include <iostream>

// Define the size of the Art arrays
#define ART_SIZE 6
#define ARTS_SIZE 5

// Art typedef & consts
using namespace std;

// Colours
constexpr const char *YELLOW = "\x1b[0;33m";
constexpr const char *RED = "\x1b[0;31m";
constexpr const char *BLUE = "\x1b[0;34m";
constexpr const char *PINK = "\x1b[0;35m";
constexpr const char *WHITE = "\x1b[0;37m";
constexpr const char *NC = "\x1b[0m";

// Classes
class BaseArt {
protected:
  const char **art;
  const char *col;

public:
  constexpr BaseArt(const char *art[ART_SIZE], const char *col)
      : art(art), col(col){};
  virtual constexpr string getLn(const size_t ln) const;
};

class GhostArt : public BaseArt {
  const size_t eyeIdxs[4] = {4, 20, 33, 49};
  bool isEye(const size_t &ln) const;

public:
  constexpr GhostArt(const char *art[ART_SIZE], const char *col)
      : BaseArt(art, col){};
  constexpr string getLn(const size_t ln) const;
};

// Arts
// clang-format off
constexpr const char *PAC_ART[ART_SIZE] = {
  "   ▄███████▄  ",
  " ▄█████████▀▀ ",
  " ███████▀     ",
  " ███████▄     ",
  " ▀█████████▄▄ ",
  "   ▀███████▀  "

};
constexpr const char *BALLS_ART[ART_SIZE] = {
  "            ",
  "            ",
  " ▄██▄  ▄██▄ ",
  " ▀██▀  ▀██▀ ",
  "            ",
  "            "
};
constexpr const char *GHOST_ART[ART_SIZE] = {
  "   ▄██████▄   ",
  " ▄█▀████▀███▄ ",
  " █▄▄███▄▄████ ",
  " ████████████ ",
  " ██▀██▀▀██▀██ ",
  " ▀   ▀  ▀   ▀ "
};
// clang-format on

// Instances
constexpr BaseArt PAC = BaseArt((const char **)PAC_ART, YELLOW);
constexpr BaseArt BALLS = BaseArt((const char **)BALLS_ART, WHITE);
constexpr GhostArt GHOST0 = GhostArt((const char **)GHOST_ART, RED);
constexpr GhostArt GHOST1 = GhostArt((const char **)GHOST_ART, BLUE);
constexpr GhostArt GHOST2 = GhostArt((const char **)GHOST_ART, PINK);

// clang-format off
constexpr const BaseArt *ARTS[ARTS_SIZE] = {&PAC, &BALLS, &GHOST0, &GHOST1, &GHOST2};
// clang-format on

// Fn decls
constexpr string mkArt();

int main(void) {
  cout << mkArt();
  return 0;
}

// Fn impls
inline constexpr string mkArt() {
  string out;
  for (size_t ln = 0; ln < ART_SIZE; ++ln) {
    for (size_t a = 0; a < ARTS_SIZE; ++a) {
      out += ARTS[a]->getLn(ln);
    }
    out += NC;
    out += "\n";
  }
  return out;
}

// Class impl
constexpr string BaseArt::getLn(const size_t ln) const {
  string out;
  out += col;
  out += art[ln];
  return out;
};

bool GhostArt::isEye(const size_t &ln) const {
  if (ln == 1 || ln == 2)
    return true;
  return false;
}
constexpr string GhostArt::getLn(const size_t ln) const {
  string out, artStr;
  artStr += art[ln];
  if (isEye(ln)) {
    artStr.insert(4, WHITE);
    artStr.insert(20, col);
    artStr.insert(33, WHITE);
    artStr.insert(49, col);
  }
  out += col + artStr;
  return out;
};
