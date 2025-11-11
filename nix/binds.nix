{ lib, jq, pkgs, writeShellScriptBin }:

{ launcher ? "wofi"
, cmdcolor ? "cyan"
, modkeyStyle ? "<b>$MOD$KEY</b> <i>$DESCRIPTION</i>"
, dispatch ? true
}:

let
  modmasks = {
    "0" = "";
    "1" = "SHIFT+";
    "4" = "CTRL+";
    "5" = "SHIFT+CTRL+";
    "8" = "ALT+";
    "12" = "CTRL+ALT";
    "64" = "SUPER+";
    "65" = "SUPER+SHIFT+";
    "68" = "SUPER+CTRL+";
    "72" = "SUPER+ALT+";
  };
  keycodes = {
    "59" = "Comma";
    "60" = "Dot";
  };
  launcherConfigs = {
    fuzzel = {
      cmd = "${lib.getExe pkgs.fuzzel} --dmenu --width=100 -p 'Hypr binds '";
      # Fuzzel doesn't support pango formatting
      style = ''\(.mod)\(if .key == "" then .code else .key end) | \(.desc) | \(.dp) \(.arg)'';
      pipeline = cmd: ''column -t -s '|' | ${cmd}'';
      extract = ''sed -n 's/.*  \([^ ].*\)$/\1/p' '';
    };

    wofi = {
      cmd = "${lib.getExe pkgs.wofi} --dmenu -m -i -p 'Hypr binds'";
      style =
        let
          modkey = builtins.replaceStrings
            [ "$MOD" "$KEY" "$DESCRIPTION" ]
            [ "\\(.mod)" "\\(if .key == \"\" then .code else .key end)" "\\(.desc)" ]
            modkeyStyle;
        in
        ''${modkey} <span color=\"${cmdcolor}\">\(.dp) \(.arg)</span>'';
      pipeline = cmd: cmd;
      extract = ''sed -n 's/.*<span color=\"${cmdcolor}\">\(.*\)<\/span>.*/\1/p' '';
    };

    rofi = {
      cmd = "${lib.getExe pkgs.rofi} -dmenu -markup-rows -i -p 'Hypr binds'";
      style =
        let
          modkey = builtins.replaceStrings
            [ "$MOD" "$KEY" "$DESCRIPTION" ]
            [ "\\(.mod)" "\\(if .key == \"\" then .code else .key end)" "\\(.desc)" ]
            modkeyStyle;
        in
        ''${modkey} <span color=\"${cmdcolor}\">\(.dp) \(.arg)</span>'';
      pipeline = cmd: cmd;
      extract = ''sed -n 's/.*<span color=\"${cmdcolor}\">\(.*\)<\/span>.*/\1/p' '';
    };
  };

  config = launcherConfigs.${launcher} or launcherConfigs.wofi;
in
writeShellScriptBin "hypr-binds" ''
  hyprctl binds -j |
    ${lib.getExe jq} -r '
      map({mod:.modmask|tostring,key:.key,code:.keycode|tostring,desc:.description,dp:.dispatcher,arg:.arg,sub:.submap}) |
      map(.mod |= ${builtins.toJSON modmasks} [.]) |
      map(.code |= ${builtins.toJSON keycodes} [.]) |
      sort_by(.mod) | .[] |
      select(.sub == "") |
      "${config.style}" ' |
    ${config.pipeline config.cmd} |
    ${config.extract} |
    ${if dispatch then ''
      sed -e 's/^/"/g' -e 's/$/"/g' |
      xargs -n1 hyprctl dispatch
    '' else "xargs"}
''
