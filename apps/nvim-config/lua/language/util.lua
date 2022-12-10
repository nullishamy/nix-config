local M = {}

local ORGANISE_IMPORTS_MAPPING = {
  tsserver = function()
    return {
      command = '_typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = '',
    }
  end,
}

function M.organize_imports()
  vim.lsp.for_each_buffer_client(vim.api.nvim_get_current_buf(), function(client)
    local params = ORGANISE_IMPORTS_MAPPING[client.name]

    if not params then
      return
    end

    vim.lsp.buf.execute_command(params())
  end)
end


function M.setup_lsp_borders()
  local border = require('utils').border

  -- Configure borders
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border('FloatBorder'),
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border('FloatBorder'),
  })
end

return M
