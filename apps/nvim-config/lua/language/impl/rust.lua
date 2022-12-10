return {
  name = 'rust',

  lsp = {
    {
      key = 'rust_analyzer',
      config = {
        cmd = { 'rust-analyzer' },
        post_init = function(config)
          require('rust-tools').setup({
            server = {
              autostart = true,
              on_attach = config.on_attach,
              capabilities = config.capabilities,
            },
            tools = {
              autoSetHints = false,
              inlay_hints = {
                show_parameter_hints = false,
                show_variable_name = false,
                on_initialized = function()
                  require('rust-tools').inlay_hints.disable()
                end,
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
}
