#include <stddef.h>
#include <stdio.h>

// Defines
#define ART_LINES 6
#define ARTS_COUNT 5
#define EYE_IDXS_COUNT 4

// Typdefs
typedef const char *Art[ART_LINES];
typedef const char *Colour;

// Colours
const Colour YELLOW = "\x1b[0;33m";
const Colour RED = "\x1b[0;31m";
const Colour BLUE = "\x1b[0;34m";
const Colour PINK = "\x1b[0;35m";
const Colour WHITE = "\x1b[0;37m";
const Colour NC = "\x1b[0m";

// Art decls
const Art PAC;
const Art BALLS;
const Art GHOST;

// Vars
// clang-format off
const Art *ARTS[ARTS_COUNT] = {&PAC, &BALLS, &GHOST, &GHOST, &GHOST}; // Art mapping
const Colour COLOURS[ARTS_COUNT] = {YELLOW, WHITE, RED, BLUE, PINK}; // Colour mapping
const size_t EYE_IDXS[EYE_IDXS_COUNT] = {4, 9, 6, 9};
// col, white, col, white, col <=> separation in chars
// clang-format on

// Fn decls
void printLn(const size_t ln);
void printPart(const Colour col, char **part, const int inc);

// @main
int main(void) {
  for (size_t line = 0; line < ART_LINES; ++line) {
    printLn(line);
  }
}

// Arts
const Art PAC = {
    // clang-format off
    "   ▄███████▄  ",
    " ▄█████████▀▀ ",
    " ███████▀     ",
    " ███████▄     ",
    " ▀█████████▄▄ ",
    "   ▀███████▀  ",
    // clang-format on
};
const Art BALLS = {
    // clang-format off
    "            ",
    "            ",
    " ▄██▄  ▄██▄ ",
    " ▀██▀  ▀██▀ ",
    "            ",
    "            ",
    // clang-format on
};
const Art GHOST = {
    // clang-format off
    "   ▄██████▄   ",
    " ▄█▀████▀███▄ ",
    " █▄▄███▄▄████ ",
    " ████████████ ",
    " ██▀██▀▀██▀██ ",
    " ▀   ▀  ▀   ▀ ",
    // clang-format on
};

// Fns
inline void printLn(const size_t ln) {
  for (size_t art = 0; art < ARTS_COUNT; ++art) {
    if ((ln == 1 || ln == 2) && (art == 2 || art == 3 || art == 4)) {
      const Colour col = COLOURS[art];
      Colour pcol = (Colour)col; // printable colour
      char *part = (char *)(*ARTS[art])[ln];
      for (int offsetIdx = 0; offsetIdx < EYE_IDXS_COUNT; ++offsetIdx) {
        if (offsetIdx % 2 != 0) {
          pcol = WHITE;
        } else {
          pcol = col;
        }
        printPart(pcol, &part, EYE_IDXS[offsetIdx]);
      }
      printf("%s%s", col, part);
    } else {
      printf("%s%s", COLOURS[art], (*ARTS[art])[ln]);
    }
  }
  printf("%s\n", NC);
}

inline void printPart(const Colour col, char **part, const int inc) {
  printf("%s%.*s", col, inc, *part);
  *part += inc;
}
