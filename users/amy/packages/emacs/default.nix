{ pkgs
, lib
, makeWrapper
, emacs
, runCommandNoCC
, clang
, nodejs
, python3
, cargo
, rustc
, gcc
, lua
, sumneko-lua-language-server
, nodePackages
, ...
}:

runCommandNoCC "emacs" { nativeBuildInputs = [ makeWrapper ]; } ''
  mkdir -p $out/bin
  makeWrapper ${emacs}/bin/emacs $out/bin/emacs \
    --set DOOMDIR "~/.config/doom-config" \
    --set DOOMLOCALDIR "~/.config/doom-local" \
    --set DOOMPROFILELOADFILE "~/.config/doom-local/profiles.el" \
    --prefix PATH : ${lib.makeBinPath [ 
      sumneko-lua-language-server
      nodePackages.typescript-language-server
      clang
      lua
      gcc
      cargo
      rustc
      nodejs
      python3
    ]}
''
