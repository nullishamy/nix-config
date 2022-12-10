require('neoscroll').setup({
  respect_scrolloff = true,
})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150' } }
t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150' } }
t['K'] = { 'scroll', { '-10', 'true', '150' } }
t['J'] = { 'scroll', { '10', 'true', '150' } }

require('neoscroll.config').set_mappings(t)
