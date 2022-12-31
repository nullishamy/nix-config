{ config, ... }: {
  config.home.file.".config/nvim" = { source = ./nvim-config; };
  config.home.file.".config/wezterm" = { source = ./wezterm-config; };
  config.home.file."etc/patches/patch-discord.sh" = { source = ./patch-discord.sh; };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./emacs-config;
  };
}
