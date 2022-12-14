vim.o.termguicolors = true
vim.o.background = 'dark'

local colors = require('catppuccin.palettes').get_palette("mocha")
colors.none = 'NONE'

require('catppuccin').setup({
  term_colours = true,
  flavour = "mocha",
  no_italic = true,
  integrations = {
    treesitter = true,
    treesitter_context = true,
    ts_rainbow = false,
    telescope = true,
    gitsigns = true,
    cmp = true,
    mason = true,
    leap = true,
  },
  custom_highlights = {
    -- Fix float text background
    CmpPmenu = { fg = colors.none, bg = colors.none },
    NormalFloat = { fg = colors.none, bg = colors.none },

    -- Make builtins the same colour as regular values, for consistency
    ["@function.builtin"] = { fg = colors.blue };
    ["@const.builtin"] = { fg = colors.blue },
    ["@const"] = { fg = colors.blue },
  },
})

vim.cmd([[ colorscheme catppuccin ]])

-- HACK: For some reason catppuccin doesnt set this, even though i asked it to?
-- HACK: This also use catppuccin internals which is not ideal, lol
local term_colurs = require('catppuccin.lib.mapper').apply('mocha').terminal
for key, value in pairs(term_colurs) do
  vim.g[key] = value
end
