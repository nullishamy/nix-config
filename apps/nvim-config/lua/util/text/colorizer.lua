-- require('colorizer').setup({
-- Include all, but modify below
-- '*',
-- Excludes packer from highlighting, as it uses GitHub references (issues / PRs)
-- which follow the same format as hex color codes and cause weird output
-- '!packer',

-- Same as above, but in lazygit
-- '!fterm_lazygit'
-- }, {
-- Disable names, they arent useful and cause annoying behaviour
-- names = false,
-- })

require('ccc').setup({
  exclude_pattern = {
    css_name = '*',
  },
  highlighter = {
    excludes = {
      'packer',
      'fterm_lazygit',
    },
    auto_enable = true,
  },
})
