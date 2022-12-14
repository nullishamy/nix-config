return {
  name = 'lua',

  lsp = {
    {
      key = 'sumneko_lua',
      config = {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Setup your lua path
              path = vim.split(package.path, ';'),
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = {
                vim.fn.expand('$VIMRUNTIME/lua'),
                vim.fn.stdpath('config') .. '/lua',
              },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      },
    },
  },

  format = {
    filetype = 'lua',
    runners = {
      require('formatter.filetypes.lua').stylua,
    },
  },

  dap = {
    enable = true,

    plugin = 'osv',

    adapter = {
      key = 'nlua',
      config = function(callback, config)
        callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
      end,
    },

    configs = {
      {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
      },
    },

    -- The function used to start an external server, if needed
    -- Optional
    external_server = function()
      return false
    end,
  },
}
