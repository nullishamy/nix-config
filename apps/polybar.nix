# Polybar settings

{ config, lib, pkgs, ...}:

{
  services.polybar = {
    enable = true;
    script = "polybar -r top &";
    config = {
      colors = {
        background = "#1E1E2E";
        background-alt = "#181825";
        foreground = "#CDD6F4";
        alert = "#F38BA8";
        underline = "#A6E3A1";
      };

      "bar/top" = {
        width = "100%";
        height = "3%";
        radius = 6;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = 3;
        line-color = "\${colors.underline}";

        modules-left = "wm";
        modules-right = "memory cpu eth date";

        font-0 = "FantasqueSansMono Nerd Font Mono:size=13;2";

        border-size = "4pt";
        border-color = "#00000000";

        padding-left = 0;
        padding-right = 1;

        module-margin = 1;

        separator = "|";
        separator-foreground = "\${colors.foreground}";

        wm-restack = "generic";
        cursor-click = "pointer";
      };

      "module/wm" = {
        type = "internal/xworkspaces";
        wrapping-scroll = true;

        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline= "\${colors.underline}";
        label-active-padding = 1;

        label-occupied = "%name%";
        label-occupied-padding = 1;

        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-foreground = "\${colors.background}";
        label-empty-padding = 1;

      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix-foreground = "\${colors.foreground}";
        label = "CPU: %percentage:2%%";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix-foreground = "\${colors.foreground}";
        label = "MEM: %percentage_used%%";
      };

      "module/eth" = {
        type = "internal/network"; 
        interface = "enp42s0";
        interval = 3;

        format-connected-prefix-foreground = "\${colors.foreground}";
        label-connected = "ETH: %local_ip%";

        label-disconnected = "ETH: N/A";
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%d %b %Y";
        time = "%H:%M";

        label = "%date% @ %time%";
      };

      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };

      "global/wm" = {
        margin-top = 0;
      };
    };
  };
}
