-- Protected in case the module is broken, or something
-- We need it to load modules safely
local ok, utils = pcall(require, 'utils')
if not ok then
  return vim.notify_once('Failed to load `utils` module, cannot proceed.')
end

local module = utils.load_module

-- Run preload
module('preload')

-- Initialise modules
module('core/editor')
module('core/autocmd')
module('core/keybinds')
module('theming/colours')
module('core/mason')

-- Core features
module('core/statusline')
module('core/sessions')

-- Neovide, if it exists
module('core/neovide')

-- Language features and navigation
module('util/ui/tree')
module('language/setup')

-- Snippets must be loaded before cmp
module('util/integrations/snippets')
module('language/misc/cmp')

-- Plugins
module('treesitter')

module('language/misc/lsp_colours')
module('language/misc/lsp_signs')

module('util/compile')
module('util/filetype')

module('util/navigation/leap')
module('util/navigation/scroll')

module('util/ui/quickfix')
module('util/ui/gui')
module('util/ui/terminal')
module('util/ui/cheatsheet')
module('util/ui/numb')

module('util/integrations/git')
module('util/integrations/discord')

module('util/text/autopairs')
module('util/text/surround')
module('util/text/comment')
module('util/text/neogen')
module('util/text/todo')
module('util/text/cutlass')
module('util/text/icons')
module('util/text/colorizer')
module('util/text/autosave')
module('util/text/debugprint')
module('util/text/wordmotion')
