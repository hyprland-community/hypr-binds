# hypr-binds

[![ci-badge](https://img.shields.io/static/v1?label=Built%20with&message=nix&color=blue&style=flat&logo=nixos&link=https://nixos.org&labelColor=111212)](https://gvolpe.com)
[![built with garnix](https://img.shields.io/endpoint?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fgvolpe%2Fhypr-binds%3Fbranch%3Dmain)](https://garnix.io)

Keybinds helper for Hyprland.

![binds](./imgs/hypr-binds.png)

## How to use

NOTE: *For now, only Nix flake is supported. Broader support may be considered if there's enough interest*.
 
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

### Home Manager module

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
