{ pkgs, config, ... }: {
  imports = [
    ./dedicated
    ./personal
    ./service
    ./system
    ./tools
    ./ui
  ];

  home.packages = with pkgs; [
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
    xdotool

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
    gitoxide

    jetbrains.idea-community

    # Emacs dependencies
    binutils
    (ripgrep.override { withPCRE2 = true; })
    libvterm
    gnutls
    fd
    imagemagick
    zstd
    nodePackages.javascript-typescript-langserver
    sqlite
    editorconfig-core-c
    emacs-all-the-icons-fonts
  ];
}
