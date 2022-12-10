-- Bootstrap Packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end

-- Do not source the default filetype.vim, we do that ourselves
vim.g.did_load_filetypes = 1

-- Init Packer
return require('packer').startup(function(o_use)
  local version = require('version')
  local use = version.wrapped_use(o_use)

  -- Dependencies
  use('MunifTanjim/nui.nvim')
  use('nvim-lua/plenary.nvim')

  -- Theme
  use({ 'catppuccin/nvim', as = 'catppuccin' })

  -- LSP
  use('neovim/nvim-lspconfig')
  use('williamboman/mason.nvim')
  use('WhoIsSethDaniel/mason-tool-installer.nvim')
  use('folke/lsp-colors.nvim')
  use('jose-elias-alvarez/null-ls.nvim')
  use('nullishamy/zeppelin.nvim')

  -- CMP
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('saadparwaiz1/cmp_luasnip')

  -- Treesitter
  use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', commit = "4cccb6" })
  use('nvim-treesitter/nvim-treesitter-textobjects')
  use('p00f/nvim-ts-rainbow')
  use('windwp/nvim-ts-autotag')
  use('windwp/nvim-autopairs')
  use('nvim-treesitter/playground')

  -- Languages
  use('simrat39/rust-tools.nvim')
  use({
    'iamcco/markdown-preview.nvim',
    run = function()
      vim.fn['mkdp#util#install']()
    end,
    disable = true,
  })
  use('https://github.com/alaviss/nim.nvim')

  -- Snippets
  use('honza/vim-snippets')
  use('L3MON4D3/LuaSnip')

  -- Util
  use('chaoren/vim-wordmotion')
  use('uga-rosa/ccc.nvim')
  use('numToStr/Comment.nvim')
  use('danymat/neogen')
  use('nvim-neo-tree/neo-tree.nvim')
  use('ggandor/leap.nvim')
  use({ 'folke/todo-comments.nvim', branch = 'neovim-pre-0.8.0' })
  use('karb94/neoscroll.nvim')
  use({ 'famiu/bufdelete.nvim', commit = "46255e" })
  use('numToStr/FTerm.nvim')
  use('sindrets/winshift.nvim')
  use('https://gitlab.com/yorickpeterse/nvim-pqf')
  use('gbprod/cutlass.nvim')
  use('nullishamy/nvim-compile')
  use('tpope/vim-sleuth')
  use('kylechui/nvim-surround')
  use('tpope/vim-repeat')
  use({ 'nullishamy/autosave.nvim', branch = 'dev' })
  use('sudormrfbin/cheatsheet.nvim')
  use('andrewferrier/debugprint.nvim')
  use('linty-org/readline.nvim')
  use('nacro90/numb.nvim')

  -- Formatting
  use('mhartington/formatter.nvim')

  -- Misc
  use('wbthomason/packer.nvim')
  use({
    'wakatime/vim-wakatime',
    cond = function()
      return require('config').wakatime.enabled
    end,
  })
  use('andweeb/presence.nvim')
  use({
    'tweekmonster/startuptime.vim',
    cond = function()
      return require('config').startuptime.enabled
    end,
  })
  use('nathom/filetype.nvim')

  -- Selection
  use('nvim-telescope/telescope.nvim')
  use('stevearc/dressing.nvim')

  -- Statusline
  use('nvim-lualine/lualine.nvim')

  -- Git
  use('lewis6991/gitsigns.nvim')

  -- Sessions
  use('Shatur/neovim-session-manager')

  -- Devicons must be loaded last
  use('kyazdani42/nvim-web-devicons')

  if packer_bootstrap then
    -- If we just bootstrapped, sync.
    -- This will 1) install packer as a dependency and 2) install the rest of the plugins
    require('packer').sync()
  end
end)
