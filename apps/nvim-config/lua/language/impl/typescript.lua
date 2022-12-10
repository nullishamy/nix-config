return {
  name = 'language-name',

  lsp = {
    {
      key = 'tsserver',
    },
  },

  format = {
    filetype = 'typescript',
    runners = {
      require('formatter.filetypes.typescript').prettierd,
    },
  },
}
