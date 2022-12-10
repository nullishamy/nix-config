local LANGUAGES = {
  'bash',
  'cpp',
  'csharp',
  'css',
  'docker',
  'go',
  'json',
  'lua',
  'nix',
  'nim',
  'null-ls',
  'php',
  'python',
  'rust',
  'typescript',
  'zeppelin',
}

-- Run the pre-setup system
require('language.impl._before_setup')

local format_config = {}
local lsp_config = require('lspconfig')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, language in pairs(LANGUAGES) do
  local lang_mod = require(string.format('language.impl.%s', language))

  assert(lang_mod.name, string.format('name field was not set (language %s)', language))

  local lsp = lang_mod.lsp
  local fmt = lang_mod.format

  assert(lsp, string.format('lsp field was not set (language %s)', lang_mod.name))
  assert(fmt, string.format('fmt field was not set (language %s)', lang_mod.name))

  -- Set up formatting

  -- Make it a table of one element if it isnt already a table
  local format_filetypes = type(fmt.filetype) == 'table' and fmt.filetype or { fmt.filetype }

  -- ~= false because nil signifies "enabled"
  if fmt.enable ~= false then
    assert(fmt.filetype, string.format('filetype field was not set (language %s)', lang_mod.name))

    for _, filetype in pairs(format_filetypes) do
      if format_config[filetype] ~= nil then
        return vim.notify_once(
          string.format('format config already set for key %s (language %s)', filetype, lang_mod.name)
        )
      end

      local runners =  fmt.runners

      -- Only set the runners if there's some set
      if runners ~= nil and #runners > 0 then
        format_config[filetype] = runners
      end
    end
  end

  -- Set up LSP
  -- ~= false because nil signifies "enabled"
  if lsp.enable ~= false then
    for _, server in pairs(lsp) do
      if server.enable ~= false then
        local config = server.config or {}
        local on_attach = require('language.misc.on_attach')

        config.autostart = true
        config.capabilities = capabilities
        config.on_attach = on_attach

        if config.pre_init then
          config.pre_init(config)
        end

        if config.external_setup then
          config.external_setup(config)
        else
          lsp_config[server.key].setup(config)
        end

        if config.post_init then
          config.post_init(config)
        end
      end
    end
  end
end

-- Install the formatter configs
require('formatter').setup({
  filetype = format_config,
})

-- Run the post-setup system
require('language.impl._after_setup')
