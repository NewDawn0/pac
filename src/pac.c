#include <stdio.h>

#define YELLOW "\x1b[0;33m"
#define RED "\x1b[0;31m"
#define CYAN "\x1b[0;36m"
#define PINK "\x1b[0;35m"
#define WHITE "\x1b[0;37m"
#define RESET "\x1b[0m"
#define SPACING "  "

#define ART_SIZE 6
#define len(xs) (sizeof(xs) / sizeof(xs[0]))

typedef unsigned char uchar; // small types

typedef struct {
  const char *art[ART_SIZE];
} Art;

const Art PAC = {
    .art =
        {
            "  ▄███████▄ ",
            "▄█████████▀▀",
            "███████▀    ",
            "███████▄    ",
            "▀█████████▄▄",
            "  ▀███████▀ ",
        },
};

const Art BALL = {
    .art =
        {
            "    ",
            "    ",
            "▄██▄",
            "▀██▀",
            "    ",
            "    ",
        },
};

const Art GHOST = {
    .art =
        {
            "  ▄██████▄  ",
            "▄█▀████▀███▄",
            "█▄▄███▄▄████",
            "████████████",
            "██▀██▀▀██▀██",
            "▀   ▀  ▀   ▀",
        },
};

// We do not use bool as it is an int and which is larger than needed
void printSeg(const char *art, const char *gcol, uchar isEye) {
  if (isEye) {
    printf("%s", gcol);
    for (uchar i = 0; art[i] != '\0'; i++) {
      // Ascii art char is 3 chars wide thereby to get the excat position we
      // multiply the normal/expected position*3 and insert the colour code
      if (i == 1 * 3 || i == 6 * 3) {
        printf(WHITE);
      } else if (i == 4 * 3 || i == 9 * 3) {
        printf("%s", gcol);
      }
      printf("%c", art[i]);
    }
    printf(SPACING);
    return;
  }
  // Sets the main colour
  printf("%s%s%s", gcol, art, SPACING);
}

int main(void) {
  for (uchar i = 0; i < len(PAC.art); i++) {
    char isEye = (i == 1 || i == 2) ? 1 : 0;
    printSeg(PAC.art[i], YELLOW, 0);
    printSeg(BALL.art[i], WHITE, 0);
    printSeg(BALL.art[i], WHITE, 0);
    printSeg(GHOST.art[i], RED, isEye);
    printSeg(GHOST.art[i], CYAN, isEye);
    printSeg(GHOST.art[i], PINK, isEye);
    printf("%s\n", RESET);
  }
}
