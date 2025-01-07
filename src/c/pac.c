#include <stdio.h>

#define YELLOW "\x1b[0;33m"
#define RED "\x1b[0;31m"
#define CYAN "\x1b[0;36m"
#define PINK "\x1b[0;35m"
#define WHITE "\x1b[0;37m"
#define NC "\x1b[0m"

const char **mkPac();
const char **mkBalls();

// Some macro trickery to have different compile-time ghost const char**
#define mkGhost(PREFIX)                                                        \
  (const char *[]) {                                                           \
    PREFIX "   ▄██████▄   ",                                                   \
        PREFIX " ▄" WHITE "█▀█" PREFIX "██" WHITE "█▀█" PREFIX "██▄ ",         \
        PREFIX " █" WHITE "▄▄█" PREFIX "██" WHITE "▄▄█" PREFIX "███ ",         \
        PREFIX " ████████████ ", PREFIX " ██▀██▀▀██▀██ ",                      \
        PREFIX " ▀   ▀  ▀   ▀ "                                        \
  }

int main(void) {
  const char **pac = mkPac();
  const char **balls = mkBalls();
  const char **ghost0 = mkGhost(RED);
  const char **ghost1 = mkGhost(CYAN);
  const char **ghost2 = mkGhost(PINK);
  // We use uchar since an int or size_t is unnessarely large
  for (unsigned char i = 0; i < 6; ++i) {
    // We use fputs to stdout buffer since it's faster
    fputs(pac[i], stdout);
    fputs(balls[i], stdout);
    fputs(ghost0[i], stdout);
    fputs(ghost1[i], stdout);
    fputs(ghost2[i], stdout);
    fputs("\n", stdout);
  }
  fflush(stdout);
  return 0;
}

const char **mkPac() {
  static const char *out[] = {
      // clang-format off
      YELLOW "   ▄███████▄  ",
      YELLOW " ▄█████████▀▀ ",
      YELLOW " ███████▀     ",
      YELLOW " ███████▄     ",
      YELLOW " ▀█████████▄▄ ",
      YELLOW "   ▀███████▀  ",
      // clang-format on
  };
  return out;
}

const char **mkBalls() {
  static const char *out[] = {
      // clang-format off
      WHITE "            ",
      WHITE "            ",
      WHITE " ▄██▄  ▄██▄ ",
      WHITE " ▀██▀  ▀██▀ ",
      WHITE "            ",
      WHITE "            ",
      // clang-format on
  };
  return out;
}
