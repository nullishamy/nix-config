return {
  name = 'language-name',

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
}
