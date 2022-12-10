# Chromium settings

{ config, lib, pkgs, ...}:

{
  programs.chromium = {
    enable = true;
    commandLineArgs = [ "--force-dark-mode" "--enable-features=WebUIDarkMode" ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; } # Refined GitHub
    ];
  };
}
