return {
  name = 'null-ls',

  lsp = {
    {
      key = 'null-ls',
      config = {
        external_setup = function()
          local ns = require('null-ls').builtins

          require('null-ls').setup({
            sources = {
              ns.diagnostics.gitlint,
              ns.diagnostics.selene,
              ns.diagnostics.statix,

              ns.code_actions.statix,
              ns.code_actions.gitrebase,
              ns.code_actions.proselint,
            },
            update_in_insert = true,
            on_attach = require('language.misc.on_attach'),
          })
        end,
      },
    },
  },

  format = {
    -- null-ls will never have formatters
    enable = false,
  },
}
