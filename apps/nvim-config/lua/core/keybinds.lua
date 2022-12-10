local utils = require('utils')
local map = utils.map
local abbrev = utils.abbrev

-- Noop q: as it's an annoying typo and the feature isnt used
map('', 'q:', '<Nop>')

--Remap space as leader key
map('', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Formatter
map('', '<leader>y', '<cmd>Format<cr>')

-- Quick exit from insert mode
map('i', 'jk', '<Esc>')

-- Disable arrow keys to force hjkl usage
map('n', '<Up>', '<Nop>')
map('n', '<Down>', '<Nop>')
map('n', '<Left>', '<Nop>')
map('n', '<Right>', '<Nop>')

-- Buffer controls
map('', '<Leader>q', '<cmd>Bdelete<cr>')

-- Window controls
map('n', '<Leader>h', '<cmd>wincmd h<cr>')
map('n', '<Leader>j', '<cmd>wincmd j<cr>')
map('n', '<Leader>k', '<cmd>wincmd k<cr>')
map('n', '<Leader>l', '<cmd>wincmd l<cr>')
map('n', '<C-W>m', '<cmd>WinShift<cr>')

-- Telescope & tree
map('n', '<Leader>ff', '<cmd>Telescope find_files path_display={"truncate"}<cr>')
map('n', '<Leader>fo', '<cmd>Telescope buffers path_display={"truncate"}<cr>')
map('n', '<Leader>fh', '<cmd>Telescope help_tags path_display={"truncate"}<cr>')
map('n', '<Leader>fg', '<cmd>Telescope live_grep path_display={"truncate"}<cr>')
map('n', '<Leader>g', '<cmd>Neotree focus reveal<cr>')

-- Jump to start / end
map('', 'H', '^')
map('', 'L', 'g_') -- g_ jumps to the last non blank character, avoiding newlines

-- Hard close vim with ctrl q + q
map('n', '<C-q>q', '<cmd>qa!<cr>')

-- Terminal
map('n', '<C-t>', '<cmd>lua require("FTerm").toggle()<cr>')
map('t', '<C-t>', '<C-\\><C-n><cmd>lua require("FTerm").toggle()<cr>')
vim.cmd([[
  tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
]])
map('t', '<S-Esc>', '<C-\\><C-n>')

-- Sessions
map('n', '<Leader>sl', '<cmd>SessionManager load_session<cr>')
map('n', '<Leader>sd', '<cmd>SessionManager delete_session<cr>')
map('n', '<Leader>ss', '<cmd>SessionManager save_current_session<cr>')

-- Moving lines
-- Moving up requires two lines for some reason
map('n', '<C-j>', '<cmd>m +1<cr>')
map('n', '<C-k>', '<cmd>m -2<cr>')

-- Debugprint
map('n', '<Leader>uu', function()
  return require('debugprint').debugprint()
end, {
  expr = true,
})

map('n', '<Leader>U', function()
  return require('debugprint').debugprint({ above = true })
end, {
  expr = true,
})

map('n', '<Leader>uq', function()
  return require('debugprint').debugprint({ variable = true })
end, {
  expr = true,
})

map('n', '<Leader>uQ', function()
  return require('debugprint').debugprint({ above = true, variable = true })
end, {
  expr = true,
})

map('n', '<Leader>uo', function()
  return require('debugprint').debugprint({ motion = true })
end, {
  expr = true,
})

map('n', '<Leader>uO', function()
  return require('debugprint').debugprint({ motion = true, above = true })
end, {
  expr = true,
})

-- Readline
local readline = require('readline')
vim.keymap.set('!', '<C-f>', readline.forward_word)
vim.keymap.set('!', '<C-b>', readline.backward_word)
vim.keymap.set('!', '<C-a>', readline.beginning_of_line)
vim.keymap.set('!', '<C-e>', readline.end_of_line)
vim.keymap.set('!', '<C-d>', readline.kill_word)
vim.keymap.set('!', '<C-BS>', readline.backward_kill_word)
vim.keymap.set('!', '<C-w>', readline.unix_word_rubout)
vim.keymap.set('!', '<C-k>', readline.kill_line)
vim.keymap.set('!', '<C-u>', readline.backward_kill_line)

-- Abbreviations
abbrev('OrganiseImports', function()
  require('language.util').organize_imports()
end)

abbrev('Doc', function()
  require('neogen').generate()
end)

abbrev('DeleteDebugPrints', function()
  require('debugprint').deleteprints()
end)

abbrev('RPDisable', function()
  require('presence'):cancel()
end)

abbrev('RPEnable', function()
  require('presence'):connect()
end)

vim.cmd([[ command! -nargs=? Run unsilent lua require("nvim-compile").run("<args>") ]])
vim.cmd([[ command! ViewCommands unsilent lua require("nvim-compile").view() ]])
