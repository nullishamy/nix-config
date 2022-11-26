# Bspwm settings
{ config, lib, pkgs, ... }:

let
  mod = "mod1";
in {
  xsession.windowManager.bspwm = {
    enable = true;
    settings = { };
    extraConfig = ''
      bspc monitor -d Web Music Discord Editor Shell 6 7 8 9 10
    '';

    rules = {
      "Discord*" = {
        desktop = "^3";
        follow = false;
      };
      "Spotify" = {
        desktop = "^2";
        follow = false;
      };
      "*:*scratchpad-" = {
        state = "floating";
        center = true;
      };
    };

    startupPrograms = [
      "nm-applet"
      "${pkgs.polkit_gnome} /libexec/polkit-gnome-authentication-agent-1"
      "polybar -r top"
      "flameshot"
      "redshift -P -O 2500"
      "discord"
      "spotifywm" # Launch spotifywm instead, which has WM bug fixes (https://github.com/dasJ/spotifywm)
      "xrandr --output HDMI-A-0 --mode 1920x1080 --rate 144 --primary"
    ];
  };

  services.sxhkd = {
    enable = true;

    keybindings = {
      "${mod} + Return" = "alacritty";
      "${mod} + shift + q" = "bspc node -c";
      "${mod} + f" = "bspc node -t fullscreen";
      "${mod} + d" = "rofi -show run -no-lazy-grab -lines 15 -width 40";
      "Print" = "flameshot gui";
    };

    extraConfig = ''
      # Switch to different workspaces with back-and-forth support
      ${mod} + {1-9,0}
        desktop='^{1-9,10}'; \
        bspc query -D -d "$desktop.focused" && bspc desktop -f last || bspc desktop -f "$desktop"

      # Move windows to different workspaces
      ${mod} + shift + {1-9,0}
        bspc node -d ^{1-9,10}

      # Expand/contract a window by moving one of its side outward/inward
      ${mod} + s : {h,j,k,l}
          STEP=30; SELECTION={1,2,3,4}; \
          bspc node -z $(echo "left -$STEP 0,bottom 0 $STEP,top 0 -$STEP,right $STEP 0" | cut -d',' -f$SELECTION) || \
          bspc node -z $(echo "right -$STEP 0,top 0 $STEP,bottom 0 -$STEP,left $STEP 0" | cut -d',' -f$SELECTION)

      ${mod} + slash
          ${./bspwm/sxhkd-help.sh}
    '';
  };
}
