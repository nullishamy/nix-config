{ config
, pkgs
, nix-doom-emacs
, ...
}: {
  imports = [
  ];

  users.users.amy = {
    isNormalUser = true;
    description = "Amy";
    hashedPassword = "$6$EuVxrglUIHa0ojiz$Oy9JF.PIAmsb.5Vz9icDwbpPp0Mw5ct3aOAniJ0n/s7.3ZGNQfiC4izz/Uc6FdgmPg9UWtoqGWo3mX6";
    extraGroups = [
      "networkmanager" # Use networks
      "wheel" # Sudoer
      "docker"
      "lxd" # Use docker without root
      "vboxusers" # Virtualbox 
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # CRON jobs
  services.cron = {
    enable = true;
    systemCronJobs = [
      "25 20 * * *   amy   . /etc/profile; ${./apps/dedicated/backup/run-backup.py} ${builtins.readFile ./apps/dedicated/backup/args.txt}"
    ];
  };

  home-manager.users.amy = {
    imports = [
      nix-doom-emacs.hmModule
      ./config.nix
    ];

    home = {
      inherit (config.system) stateVersion;

      username = "amy";
      homeDirectory = "/home/amy";
    };
  };
}
