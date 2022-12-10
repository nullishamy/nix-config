return {
  wakatime = {
    enabled = true,
  },
  font = {
    name = 'VictorMono Nerd Font Mono',
    size = '13',
  },
  startuptime = {
    enabled = true,
  },
  tree = {
    hidden = {
      '.DS_Store',
      'thumbs.db',
      'node_modules',
    },
  },
  discord = {
    blacklist = {}
  },
  mason = {
    packages = {
      -- Packages to be installed automatically by mason
      -- Some of these are disabled by my personal nixos config, feel free to re-enable

      -- Format
      -- 'stylua',

      -- Lint
      -- 'selene',
      'gitlint',

      -- LSP
      -- 'lua-language-server',
      'typescript-language-server',
      'gopls',
      'bash-language-server',
      'omnisharp',
      -- 'rnix-lsp',

      -- DAP
      -- None
    },
  },
}
