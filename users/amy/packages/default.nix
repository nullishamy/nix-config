{ config, pkgs, ... }: {
  imports = [
    ./cargo
  ];

  config.home.packages = [ 
    (pkgs.callPackage ./catppuccin-gtk { })
    (pkgs.callPackage ./nvim { })
    (pkgs.callPackage ./emacs { })
  ];
}
