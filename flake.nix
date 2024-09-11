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
          hypr-binds = (pkgs.callPackage ./nix/binds.nix { }) { };
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
