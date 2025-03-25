{
  description = "Pacman Ascii Banner Speed Test 🏁👾";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { self, utils, ... }: {
    overlays.default = final: prev:
      let
        overlays = with builtins;
          listToAttrs (map (key: {
            name = key;
            value = self.packages.${prev.system}.${key};
          }) (filter (f: f != "default")
            (attrNames self.packages.${prev.system})));
      in (overlays // { pac = self.packages.${prev.system}.default; });
    packages = utils.lib.eachSystem { } (pkgs:
      let
        build = import ./build.nix { inherit pkgs; };
        packages = with builtins;
          listToAttrs (map (key: {
            name = key;
            value = build.${key};
          }) (attrNames build));
      in packages // { default = build.pac-zig; });
    devShells = utils.lib.eachSystem { } (pkgs:
      let
        scripts = import ./scripts.nix { inherit pkgs; };
        packages = map (p: scripts.${p}) (builtins.attrNames scripts);
      in { default = pkgs.mkShell { inherit packages; }; });
  };
}
