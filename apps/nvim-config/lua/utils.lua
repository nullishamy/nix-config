local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.abbrev(from, to, opts)
  -- This API is only available from nvim 0.7 and up.
  -- Setting abbreviations without it is tedious so we wont bother
  if not vim.api.nvim_create_user_command then
    return vim.api.notify_once('Abbreviations are only available in nvim 0.7 and newer, please update.')
  end

  local options = { nargs = 0 }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end

  vim.api.nvim_create_user_command(from, to, options)
end

function M.border(hl_name)
  return {
    { '╭', hl_name },
    { '─', hl_name },
    { '╮', hl_name },
    { '│', hl_name },
    { '╯', hl_name },
    { '─', hl_name },
    { '╰', hl_name },
    { '│', hl_name },
  }
end

-- Safely load modules, handling errors that arise during the load
function M.load_module(mod)
  local ok, res = pcall(require, mod)

  if not ok then
    vim.notify_once(string.format('Failed to load module %s | %s', mod, res))
  end
end

return M
