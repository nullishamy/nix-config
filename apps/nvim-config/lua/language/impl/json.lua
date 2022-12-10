return {
  name = 'json',

  lsp = {
    {
      key = 'jsonls',
    },
  },

  format = {
    filetype = 'json',
    runners = {
      require('formatter.filetypes.json').prettierd,
    },
  },
}
