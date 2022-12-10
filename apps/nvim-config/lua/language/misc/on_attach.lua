return function(_, buf)
  local opts = { noremap = true, silent = true }
  local set = vim.api.nvim_buf_set_keymap

  set(buf, 'n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<cr>',                                        opts)
  set(buf, 'n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<cr>',                                         opts)
  set(buf, 'n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<cr>',                                     opts)
  set(buf, 'i', '<C-s>',      '<cmd>lua vim.lsp.buf.signature_help()<cr>',                                     opts)
  set(buf, 'n', '<C-s>',      '<cmd>lua vim.lsp.buf.signature_help()<cr>',                                     opts)
  set(buf, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>',                               opts)
  set(buf, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>',                            opts)
  set(buf, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',         opts)
  set(buf, 'n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<cr>',                                    opts)
  set(buf, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>',                                             opts)
  set(buf, 'n', 'gr',         '<cmd>lua vim.lsp.buf.references()<cr>',                                         opts)
  set(buf, '',  '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>',                                        opts)

  set(buf, '',  '<Leader>n',  '<cmd>lua vim.diagnostic.goto_next()<cr>',                                       opts)
  set(buf, '',  '<Leader>p',  '<cmd>lua vim.diagnostic.goto_prev()<cr>',                                       opts)
  set(buf, '',  '<Leader>d',  '<cmd>lua vim.diagnostic.open_float(nil, { focus = true, scope = "line" })<cr>', opts)
  set(buf, 'n', '<C-Space>',  '<cmd>lua vim.lsp.buf.hover()<cr>',                                              opts)
end
