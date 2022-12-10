require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  ensure_installed = require('treesitter.ensure_installed'),
  rainbow = require('treesitter.rainbow_brackets'),
  textobjects = require('treesitter.textobjects'),
  incremental_selection = require('treesitter.incremental_selection'),
  plaground = require('treesitter.playground'),
})
