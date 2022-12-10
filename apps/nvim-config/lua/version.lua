local M = {}

local COMMITS = {
  ['MunifTanjim/nui.nvim'] = 'latest',
  ['nvim-lua/plenary.nvim'] = 'latest',
  ['catppuccin/nvim'] = 'latest',
  ['neovim/nvim-lspconfig'] = 'latest',
  ['williamboman/mason.nvim'] = 'latest',
  ['WhoIsSethDaniel/mason-tool-installer.nvim'] = 'latest',
  ['folke/lsp-colors.nvim'] = 'latest',
  ['jose-elias-alvarez/null-ls.nvim'] = 'latest',
  ['nullishamy/zeppelin.nvim'] = 'latest',
  ['hrsh7th/nvim-cmp'] = 'latest',
  ['hrsh7th/cmp-nvim-lsp'] = 'latest',
  ['hrsh7th/cmp-buffer'] = 'latest',
  ['hrsh7th/cmp-path'] = 'latest',
  ['saadparwaiz1/cmp_luasnip'] = 'latest',
  ['nvim-treesitter/nvim-treesitter'] = '4cccb6',
  ['nvim-treesitter/nvim-treesitter-textobjects'] = 'latest',
  ['p00f/nvim-ts-rainbow'] = 'latest',
  ['windwp/nvim-ts-autotag'] = 'latest',
  ['windwp/nvim-autopairs'] = 'latest',
  ['nvim-treesitter/playground'] = 'latest',
  ['simrat39/rust-tools.nvim'] = 'latest',
  ['iamcco/markdown-preview.nvim'] = 'latest',
  ['alaviss/nim.nvim'] = 'latest',
  ['honza/vim-snippets'] = 'latest',
  ['L3MON4D3/LuaSnip'] = 'latest',
  ['chaoren/vim-wordmotion'] = 'latest',
  ['uga-rosa/ccc.nvim'] = 'latest',
  ['numToStr/Comment.nvim'] = 'latest',
  ['danymat/neogen'] = 'latest',
  ['nvim-neo-tree/neo-tree.nvim'] = 'latest',
  ['ggandor/leap.nvim'] = 'latest',
  ['folke/todo-comments.nvim'] = 'latest',
  ['karb94/neoscroll.nvim'] = 'latest',
  ['famiu/bufdelete.nvim'] = '46255e',
  ['numToStr/FTerm.nvim'] = 'latest',
  ['sindrets/winshift.nvim'] = 'latest',
  ['https://gitlab.com/yorickpeterse/nvim-pqf'] = 'latest',
  ['gbprod/cutlass.nvim'] = 'latest',
  ['nullishamy/nvim-compile'] = 'latest',
  ['tpope/vim-sleuth'] = 'latest',
  ['kylechui/nvim-surround'] = 'latest',
  ['tpope/vim-repeat'] = 'latest',
  ['nullishamy/autosave.nvim'] = 'latest',
  ['sudormrfbin/cheatsheet.nvim'] = 'latest',
  ['andrewferrier/debugprint.nvim'] = 'latest',
  ['linty-org/readline.nvim'] = 'latest',
  ['nacro90/numb.nvim'] = 'latest',
  ['mhartington/formatter.nvim'] = 'latest',
  ['wbthomason/packer.nvim'] = 'latest',
  ['wakatime/vim-wakatime'] = 'latest',
  ['andweeb/presence.nvim'] = 'latest',
  ['tweekmonster/startuptime.vim'] = 'latest',
  ['nathom/filetype.nvim'] = 'latest',
  ['nvim-telescope/telescope.nvim'] = 'latest',
  ['stevearc/dressing.nvim'] = 'latest',
  ['nvim-lualine/lualine.nvim'] = 'latest',
  ['lewis6991/gitsigns.nvim'] = 'latest',
  ['Shatur/neovim-session-manager'] = 'latest',
  ['kyazdani42/nvim-web-devicons'] = 'latest',
}

function M.wrapped_use(use_fn)
  return function (args)
    if not args.commit then
      local commit = COMMITS[args[0]]

      if commit ~= "latest" and commit ~= nil then
        args.commit = commit
      end
    end

    return use_fn(args)
  end
end

return M
