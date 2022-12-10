return {
  name = 'nix',

  lsp = {
    {
      key = 'rnix',
    },
  },

  format = {
    filetype = 'nix',
    runners = {
      function()
        return {
          exe = 'nixpkgs-fmt',
          stdin = true,
          args = {
          },
        }
      end,
    },
  },
}
