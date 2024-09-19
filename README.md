# hypr-binds

[![ci-badge](https://img.shields.io/static/v1?label=Built%20with&message=nix&color=blue&style=flat&logo=nixos&link=https://nixos.org&labelColor=111212)](https://nixos.org)
[![built with garnix](https://img.shields.io/endpoint?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fhyprland-community%2Fhypr-binds%3Fbranch%3Dmain)](https://garnix.io)

Keybinds helper for Hyprland.

![binds](./imgs/hypr-binds.png)

## Table of Contents

* [How to use](#how-to-use)
* [Nix support](#nix-support)
  * [Home Manager](#home-manager)
* [General support](#general-support)

## How to use

The `hypr-binds` program is mainly customizable via Home Manager (see below), but a program with sane defaults both for [Wofi](https://sr.ht/~scoopta/wofi/) and [Rofi](https://github.com/davatorium/rofi) is provided out of the box for *all Linux users*.

## Nix support
 
Try it out before buying:

```console
nix run github:gvolpe/hypr-binds
```

Still here? Add it to your flake inputs:

```nix
{
  hypr-binds-flake = {
    url = github:gvolpe/hypr-binds;
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

And add the package to your list of packages:

```nix
inherit (hypr-binds-flake.${system}) hypr-binds-wofi;
```

### Home Manager

Or make use of the Home Manager module by first adding it to your imports:

```nix
imports = [
  hypr-binds-flake.homeManagerModules.${system}.default
];
```

And then enabling the program:

```nix
{
  programs.hypr-binds.enable = true;
}
```

It comes with defaults, but it's possible to customize it:

```nix
{
  programs.hypr-binds = {
    enable = true;
    settings = {
      launcher = {
        app = "wofi"; # or rofi
        style = {
          modkey = "<b>$MOD$KEY</b> <i>$DESCRIPTION</i>";
          command = "cyan";
        };
      };
      dispatch = true;
    };
  };
}
```

## General support

The same script one can run via `nix` is also generally available for all non-nix users as simple bash scripts where the only hard dependencies are `bash` and [jq](https://github.com/jqlang/jq), besides either Wofi or Rofi.

Users are welcome to download either script and modify it at will:

- Rofi: [v0.0.1/hypr-binds-rofi.sh](https://github.com/hyprland-community/hypr-binds/releases/download/v0.0.1/hypr-binds-rofi.sh)
- Wofi: [v0.0.1/hypr-binds-wofi.sh](https://github.com/hyprland-community/hypr-binds/releases/download/v0.0.1/hypr-binds-wofi.sh)
