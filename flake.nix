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
          buildPkg = pkgs.callPackage ./nix/binds.nix { };

          hypr-binds-wofi = buildPkg { };
          hypr-binds-rofi = buildPkg {
            launcher = "${pkgs.lib.getExe pkgs.rofi} -dmenu -i -markup-rows -p 'Hypr binds'";
          };
        in
        {
          homeManagerModules.default = {
            imports = [ ./nix/hm.nix ];
          };

          packages = {
            default = hypr-binds-wofi;
            inherit hypr-binds-wofi hypr-binds-rofi;
          };
        }
      );
}
