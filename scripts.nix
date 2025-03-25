{ pkgs }: {
  measure = pkgs.writeShellApplication {
    name = "measure";
    runtimeInputs = with pkgs; [ gnugrep ];
    text = ''
      FILE="./result/bin/pac"
      ITERATIONS=1000
      echo "Testing $FILE for $ITERATIONS iterations"
      {
          time for ((i=1; i<="$ITERATIONS"; i++)); do
              ./"$FILE" > /dev/null 2>&1
          done
      } 2>&1 | grep real
    '';
  };
  build-all = pkgs.writeShellApplication {
    name = "build-all";
    runtimeInputs = with pkgs; [ jq ];
    text = ''
      nix flake show --all-systems --json | jq -r '.packages."x86_64-linux" | keys[]' | while read -r pkg; do
          echo "Building package: $pkg"
          nix build ".#$pkg" || (echo "Failed to build $pkg" && exit 1)
      done
    '';
  };
}
