# ZSH settings

{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # OMZ Plugins
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
          sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "caa749d030d22168445c4cb97befd406d2828db0";
          sha256 = "17ck9lm8j6bv9fhag827kxrbwdwbhhss0sw7p1yz7nhpknj6apv1";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];

    # Aliases
    shellAliases = {
      py = "python";
      nv = "neovide";
      lg = "lazygit";
      nix-clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
      nix-update = "sudo nixos-rebuild switch --upgrade";
      nix-switch = "sudo nixos-rebuild switch";
      home-switch = "home-manager switch -f $HOME/nixos/profiles/personal.nix -b backup";
      sxhkd-switch = "pkill -usr1 -x sxhkd";
      bspwm-switch = "bspc wm --restart";

      # Modern unix
      grep = "rg $@";
      find = "fd $@";
      df = "duf $@";
      ls = "exa $@";
      cat = "bat $@";
      dig = "dog $@";
    };

    # OMZ Config
    oh-my-zsh = {
      enable = true;
      theme = "philips";
      plugins = [
        "git"
        "ssh-agent"
      ];
    };

    envExtra = ''
      export MCFLY_KEY_SCHEME=vim
      export MCFLY_DISABLE_MENU=TRUE
    '';

    initExtra = ''
      # Little helper because doing the spawning in ZSH causes many issues
      # also we use "bash-isms" in the script
      function shell { bash ~/shells/spawn-shell.sh $@; }

      eval "$(mcfly init zsh)"
    '';
  };
}
