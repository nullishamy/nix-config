return {
  name = 'rust',
  -- FIXME: Enable this once rust-analyzer stops segfaulting randomly
  enable = false,

  lsp = {
    {
      key = 'rust_analyzer',
      config = {
        cmd = { 'rust-analyzer' },
        post_init = function(_, config)
          require('rust-tools').setup({
            server = {
              autostart = true,
              on_attach = config.on_attach,
              capabilities = config.capabilities,
            },
            tools = {
              inlay_hints = {
                auto = false,
              },
            },
          })
        end,
      },
    },
  },

  format = {
    filetype = 'rust',
  },

  dap = {
  }
}
