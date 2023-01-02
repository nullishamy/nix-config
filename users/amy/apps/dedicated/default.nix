{ config, pkgs, ... }: {
  config.home.file."etc/patches/patch-discord.sh" = { source = ./patch-discord.sh; };

  config.home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      DOOMPROFILELOADFILE = "${config.xdg.configHome}/doom-local/profiles.el";
    };
  };

  config.xdg.configFile = {
    "nvim" = {
      source = ./nvim-config;
    };
    "wezterm" = {
      source = ./wezterm-config;
    };
    "doom-config" = {
      source = ./emacs-config;
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync
          fi
        ''}";
    };
    "emacs" = {
      source = pkgs.fetchgit {
        url = "https://github.com/doomemacs/doomemacs";
        hash = "sha256-7AzL08qo5WLeJo10lnF2b7g6FdWnExVYS8yipNyAMMM=";
      };
      onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync -u
          fi
        ''}";
    };
  };
}
