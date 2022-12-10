local pid = vim.fn.getpid()

return {
  name = 'c-sharp',

  lsp = {
    {
      key = 'omnisharp',
      config = {
        cmd = { 'omnisharp', '--languageserver', '--hostPID', tostring(pid) },
        filetypes = { 'cs', 'c_sharp' },
      },
    },
  },

  format = {
    filetype = 'csharp',
    runners = {
      require('formatter.filetypes.cs').dotnetformat,
    },
  },
}
