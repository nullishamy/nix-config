local colors = {
  fg = '#93a4c3',

  black = '#0c0e15',
  purple = '#c75ae8',
  green = '#8bcd5b',
  orange = '#dd9046',
  blue = '#41a7fc',
  yellow = '#efbd5d',
  cyan = '#34bfd0',
  red = '#f65866',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  ft_not_empty = function()
    return vim.fn.empty(vim.bo.filetype) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local time = function()
  return os.date('%a %d %b %Y @ %H:%M')
end

local set_statusline_refresh = function()
  local redraw = function()
    vim.api.nvim_command('redrawtabline')
  end

  if _G.Tabline_timer == nil then
    _G.Tabline_timer = vim.loop.new_timer()
  else
    _G.Tabline_timer:stop()
  end
  --        never timeout, repeat every 5000ms
  _G.Tabline_timer:start(0, 5000, vim.schedule_wrap(redraw))
end

local function theme()
  return require('core.statusline-theme')
end

local config = {
  options = {
    theme = theme(),
    globalstatus = true,
    disabled_filetypes = { 'nvimtree' },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- these will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function right(component)
  table.insert(config.sections.lualine_x, component)
end

-- Left hand side
left({
  'filename',
  fmt = function(inp)
    -- Fallback for empty buffers
    return inp or '[No name]'
  end,
  color = { fg = colors.green, gui = 'bold' },
})

left({
  'filetype',
  icons_enabled = false,
  cond = conditions.ft_not_empty,
  color = { fg = colors.blue, gui = 'bold' },
})

local LSP_BLACKLIST = {
  'null-ls',
}

left({
  -- Lsp server name .
  function()
    local msg = 'None'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      -- LSP must have filetypes, the current ft must be supported, and it must not be in the blacklist
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and vim.fn.index(LSP_BLACKLIST, client.name) == -1 then
        return client.name
      end
    end
    return msg
  end,
  cond = conditions.buffer_not_empty,
  color = { fg = colors.blue, gui = 'bold' },
})

left({
  'location',
  fmt = function(inp)
    -- Strip spaces to make it look nicer
    return string.gsub(inp, ' ', '')
  end,
  color = { fg = colors.orange, gui = 'bold' },
})

left({
  'progress',
  color = { fg = colors.orange, gui = 'bold' },
})

-- Right hand side
right({
  'branch',
  icon = '',
  color = { fg = colors.purple, gui = 'bold' },
})

right({
  'diff',
  symbols = { added = ' ', modified = '柳', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
})

right({
  time,
  color = { fg = colors.fg, gui = 'bold' },
})

require('lualine').setup(config)

set_statusline_refresh()
