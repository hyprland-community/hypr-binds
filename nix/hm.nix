{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.hypr-binds;
in
{
  meta.maintainers = [ lib.maintainers.gvolpe ];

  options.programs.hypr-binds = {
    enable = mkEnableOption "Keybinds helper for Hyprland";

    settings = {
      launcher = {
        app = mkOption {
          type = types.enum [ "rofi" "wofi" ];
          description = "The launcher application";
          default = "wofi";
        };

        style = {
          modkey = mkOption {
            type = types.str;
            description = "Launcher HTML style for modmask, key and description";
            default = "<b>$MOD$KEY</b> <i>$DESCRIPTION</i>";
          };

          command = mkOption {
            type = types.str;
            description = "Dispatcher and command color";
            default = "cyan";
          };
        };
      };

      dispatch = mkOption {
        type = types.bool;
        description = "Whether to execute the selected binding via hyprctl dispatch";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        hypr-binds = pkgs.callPackage ./binds.nix { } {
          launcher = cfg.settings.launcher.app;
          cmdcolor = cfg.settings.launcher.style.command;
          modkeyStyle = cfg.settings.launcher.style.modkey;
          dispatch = cfg.settings.dispatch;
        };
      in
      [ hypr-binds ];
  };
}
