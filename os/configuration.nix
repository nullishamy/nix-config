# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let unstablePkgs = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { };
in
{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>

      # Apps not supported by home-manager
      ../apps/steam.nix
    ];

  boot.loader = {
    systemd-boot = {
      enable = true;
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Configure nix itself
  nix = {
    # Automatically run the garbage collector
    gc.automatic = false;
    gc.dates = "12:45";

    # Automatically run the nix store optimiser
    optimise.automatic = false;
    optimise.dates = [ "12:55" ];

    settings = { 

      # Nix automatically detects files in the store that have identical contents, and replaces them with hard links to a single copy.
    autoOptimiseStore = true;

      # Maximum number of concurrent tasks during one build
    buildCores = 4;

      # Maximum number of jobs that Nix will try to build in parallel
      # "auto" is broken: https://github.com/NixOS/nixpkgs/issues/50623
      maxJobs = 16;

      # Perform builds in a sandboxed environment
      useSandbox = true;
    };
  };

  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network.networks =
    let
      networkConfig = {
        DHCP = "yes";
        DNSSEC = "yes";
        DNSOverTLS = "yes";
        DNS = [ "1.1.1.1" "1.0.0.1" ];
      };
    in
    {
      # Config for all useful interfaces
      "40-wired" = {
        enable = true;
        name = "en*";
        inherit networkConfig;
        dhcpV4Config.RouteMetric = 1024; # Better be explicit
      };
      "40-wireless" = {
        enable = true;
        name = "wl*";
        inherit networkConfig;
        dhcpV4Config.RouteMetric = 2048; # Prefer wired
      };
    };

  # Wait for any interface to become available, not for all
  # This avoids a hang where wifi isnt available
  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    ""
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.utf8";

  # CRON jobs
  services.cron = {
    enable = true;
    systemCronJobs =  [
      "25 20 * * *   amy   . /etc/profile; ${../backup/run-backup.py} ${builtins.readFile ../backup/args.txt}"
    ];
  };

  # Configure X11
  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "";

    windowManager.bspwm = {
      enable = true;
    };

    desktopManager = {
      wallpaper = {
        mode = "center";
      };
    };

    xautolock = {
      enable = true;

      # Time, in minutes, before the screen automatically locks
      time = 60;

      # The command to run when locking
      locker = "${pkgs.i3lock}/bin/i3lock -c 282828";
      nowlocker = "${pkgs.i3lock}/bin/i3lock -c 282828";
    };
  };

  # Configure picom
  services.picom = {
    enable = true;

    settings = {
      # -- SHADOWS --
      shadow = false;
      shadow-radius = 2;
      shadow-opacity = .75;
      shadow-offset-x = -2;
      shadow-offset-y = -2;
      shadow-exclude = [ ];

      # -- FADING --
      fading = false;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      fade-delta = 5;
      fade-exclude = [ ];
      no-fading-openclose = 1;

      # -- TRANSPARENCY / OPACITY --
      inactive-opacity = 1;
      frame-opacity = 1;
      inactive-opacity-override = false;
      active-opacity = 1;
      inactive-dim = 0;
      focus-exclude = [ ];
      # inactive-dim-fixed = 1.0;
      opacity-rule = [ ];

      # -- CORNERS --
      corner-radius = 10;
      round-borders = 1;
      rounded-corners-exclude = [ ];

      # -- GENERAL --
      backend = "glx";
      glx-no-rebind-pixmap = 1;
    };
  };

  # Hardware configuration
  hardware = {
    bluetooth = {
      enable = true;
    };
  };

  # Blueman
  services.blueman = {
    enable = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configure console keymap
  console.keyMap = "us";

  # Define my user account.
  users.users.amy = {
    isNormalUser = true;
    description = "Amy Erskine";
    extraGroups = [
      "networkmanager" # Use networks
      "wheel" # Sudoer
      "docker"
      "lxd" # Use docker without root
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # Add myself to the vbox group
  users.extraGroups.vboxusers.members = [ "amy" ];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplip ];
  };

  # Pinentry / GPG
  # services.pcscd.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryFlavor = "gtk2";
  #   enableSSHSupport = true;
  # };

  # Increase open file limits
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "8192";
  }];

  # Enable yubikey support for the OS
  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
    control = "sufficient";
  };

  # Enable the pcscd daemon for smartcard support
  services.pcscd.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts.fonts = with pkgs; [
    # Only use the given nerdfonts, saves cloning *everything*
    (nerdfonts.override { fonts = [ "Hack" "Iosevka" "FantasqueSansMono" "VictorMono" ]; })
  ];

  environment = {
    # Add zsh to /etc/shells
    shells = [
      pkgs.zsh
    ];

    # List packages installed in system profile (globally).
    systemPackages = with pkgs; [
      wget
      alacritty
      polybar
      chromium
      git
      redshift
      home-manager
      pipewire
      wireplumber
      pulseaudio
      zsh
      dconf
      fontconfig
      unzip
      gnupg
      pinentry-gtk2
      unstablePkgs.protonvpn-gui
      unstablePkgs.protonvpn-cli
      ntfsprogs
      yubico-pam
      yubikey-manager-qt
      yubioath-desktop
      xclip
      i3lock

      # My wrappers
      (callPackage ../wrappers/nvim.nix { })
    ];

    pathsToLink = [ "/share/zsh" ];
  };

  # Virtualisation with VirtualBox
  virtualisation.virtualbox = {
    host = {
      # enable = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
