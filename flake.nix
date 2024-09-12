{
  description = "Hypr Binds: wofi keybinds helper for Hyprland";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hypr-binds =
            if pkgs.stdenv.isLinux
            then (pkgs.callPackage ./nix/binds.nix { }) { }
            else
              (pkgs.callPackage ./nix/binds.nix { }) {
                launcher = "${pkgs.lib.getExe pkgs.rofi} -dmenu -i -markup-rows -p 'Hypr binds'";
              };
        in
        {
          homeManagerModules.default = {
            imports = [ ./nix/hm.nix ];
          };

          packages = {
            default = hypr-binds;
            inherit hypr-binds;
          };
        }
      );
}
