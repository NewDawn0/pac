{
  description = "Pacman Ascii Banner Speed Test 🏁👾";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { utils, ... }:
    let
      defaultPackage = "pac-zig";
      getBuild = pkgs: import ./build.nix { inherit pkgs; };
      mkOutPackages = pkgs: default:
        let
          build = getBuild pkgs;
          defaultPkg = default build;
        in (builtins.listToAttrs (map (key: {
          name = key;
          value = build.${key};
        }) (builtins.attrNames build)) // defaultPkg);
    in {
      overlays.default = final: prev:
        (mkOutPackages prev (b: { pac = b.${defaultPackage}; }));
      packages = utils.lib.eachSystem { }
        (pkgs: mkOutPackages pkgs (b: { default = b.${defaultPackage}; }));
      devShells = utils.lib.eachSystem { } (pkgs:
        let
          scripts = import ./scripts.nix { inherit pkgs; };
          packages = map (p: scripts.${p}) (builtins.attrNames scripts);
        in { default = pkgs.mkShell { inherit packages; }; });
    };
}
