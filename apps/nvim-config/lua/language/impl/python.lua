return {
  name = 'python',

  lsp = {
    {
      key = 'pyright',
    },
  },

  format = {
    filetype = 'py',
    runners = {
      require('formatter.filetypes.python').black,
    },
  },
}
