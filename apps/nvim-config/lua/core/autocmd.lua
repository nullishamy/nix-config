-- Line numbers should be relative in normal mode
-- but absolute in insert mode.
vim.cmd([[ 
    :augroup NumberToggle 
    :  autocmd!
    :  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    :  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
    :augroup END
]])

-- Don't auto comment new lines
vim.cmd([[ 
  autocmd BufEnter * set fo-=c fo-=r fo-=o 
]])

-- Disable annoying autoindent rules
vim.cmd([[
 autocmd BufEnter,WinEnter,FocusGained * set nocin nosi inde=
]])

-- Disable highlight searching for every buffer
vim.cmd([[
 autocmd BufEnter,WinEnter,FocusGained * set nohlsearch
]])

-- Recompile packer config when it changes
vim.cmd([[
 autocmd BufWritePost preload.lua source <afile> | PackerCompile
]])

-- Tell colourizer to colourize all open buffers when the session loads
-- vim.cmd([[
--   autocmd SessionLoadPost * ColorizerReloadAllBuffers
-- ]])

-- Show diagnostics on hover
-- HACK: try integrate this into the autocommand or something
vim.diagnostic._open_float = function()
  if vim.fn.mode() == 'i' then
    return
  end

  vim.diagnostic.open_float(nil, { focus = false, scope = 'line' })
end

vim.cmd([[
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic._open_float()
]])
