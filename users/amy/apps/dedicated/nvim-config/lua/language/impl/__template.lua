return {
  name = 'language-name',
  enable = true,

  lsp = {
    -- nil/true signifies enabled, false signifies disabled
    -- can be applied to each server or for all servers
    enable = true,
    -- Table of servers, will all be executed
    {
      key = 'language-lsp-key',
      config = {
        -- Additional LSP config
      },
    },
  },

  format = {
    -- nil/true signifies enabled, false signifies disabled
    enable = true,
    -- Can be a table too, will run on all types given
    filetype = 'filetype-to-format',
    runners = {
      -- Formatter runners
      require('formatter.filetypes.<filetype>').formatter,
    },
  },

  -- DOC: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  dap = {
    -- nil/false signifies disabled, true signifies enabled
    enable = false,

    -- The plugin that supplies the adapter/config(s)
    -- A require() of this will be attempted
    plugin = 'nvim-dap-python',

    -- To define the adapter
    adapter = {
      -- The key to index the adapters with (defaults to the language name)
      -- In case it differs from the language name
      key = 'python',
      config = {
        type = 'executable',
        command = 'path/to/virtualenvs/debugpy/bin/python',
        args = { '-m', 'debugpy.adapter' },
      },
    },

    -- To define the configs
    -- No name mapping here (like above) because DAP will use `type` to index
    configs = {
      {
        -- The first three options are required by nvim-dap
        type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch',
        name = 'Launch file',

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
        program = '${file}', -- This configuration will launch the current file if used.
        pythonPath = function()
          -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
          -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
          -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end,
      },
    },
  },
}
