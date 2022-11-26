{ config, pkgs, ... }:

# Gruvbox resources: https://www.reddit.com/r/gruvbox/comments/np5ylp/official_resources/

let
  imports = [
    # Custom modules
    ../packages/cargo

    ../apps/rofi.nix
    ../apps/polybar.nix
    ../apps/flameshot.nix
    ../apps/zsh.nix
    ../apps/gtk.nix
    ../apps/chromium.nix
    ../apps/alacritty.nix
    ../apps/i3.nix
    ../apps/git.nix
    ../apps/keybase.nix
    ../apps/xdg.nix
    ../apps/lazygit.nix
    ../apps/mpris.nix
    ../apps/dunst.nix
    ../apps/bspwm.nix
    ../apps/cargo.nix
  ];
in
{
  inherit imports;
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "amy";
    homeDirectory = "/home/amy";

    # ENV vars
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "neovide";
      GIT_EDITOR = "nvim";
      TERMINAL = "alacritty";
    };

    file = {
      "shells/spawn-shell.sh" = { source = ../shells/spawn-shell.sh; };
      "shells/cpp.nix" = { source = ../shells/cpp.nix; };
      "shells/py.nix" = { source = ../shells/py.nix; };
      "shells/js.nix" = { source = ../shells/js.nix; };
      "shells/ts.nix" = { source = ../shells/js.nix; };
      "shells/docker.nix" = { source = ../shells/docker.nix; };
      "shells/rust.nix" = { source = ../shells/rust.nix; };
      ".background-image" = { source = ../wallpaper.png; };

      # Create a config.nix for doing some specific config, namely allowing unfree, which
      # doesn't work when declared anywhere else? 
      ".config/nixpkgs/config.nix" = { source = ../apps/nixpkgs.nix; };
      ".icons/default" = { source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ-AA"; };
    };

    packages = with pkgs; [
      # My packages
      (callPackage ../packages/catppuccin-gtk {})
      (callPackage ../packages/bspwm-scratch {})

      bottom
      neofetch
      gh
      rofi
      spotifywm
      flameshot
      lazygit
      keybase
      neovide
      discord
      discord-canary
      bitwarden
      gparted
      gimp
      steam
      lunar-client
      pavucontrol
      deluge
      realvnc-vnc-viewer
      notion-app-enhanced
      photoqt
      dunst

      # Modern unix
      ripgrep
      mcfly
      fd
      duf
      exa
      bat
      jq
      tldr
      dogdns
      httpie
      jetbrains.idea-community
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";
  };

  programs = {
    home-manager = {
      # Let Home Manager install and manage itself.
      enable = true;
    };
  };
}
