-- stylua: ignore start
local g = vim.g                                   -- Global variables
local o = vim.opt                                 -- Set options (global/buffer/windows-scoped) (operates like :set)
local w = vim.wo                                  -- Per-window options

-- General
o.completeopt = 'menu,noinsert,noselect,preview'  -- List of options for Insert mode completion
g.noshowmode = true                               -- If in Insert, Replace or Visual mode put a message on the last line.
o.showtabline = 0                                 -- Never show tabline
o.updatetime = 100                                -- Write to swap if left idle for n milliseconds
o.mouse = 'a'                                     -- Enable mouse support for visual select, scrolling


-- Window
w.number = true                                   -- Display numbers along the side
g.wrap = true                                     -- Enable line wrapping
o.scrolloff = 12                                  -- Keep 12 lines of context on either side of the cursor


-- Tab character setup
-- Tabs are inferred by the reading each file
-- though these act as sane defaults
o.shiftwidth = 4                                  -- Number of spaces to use for each step of indent. Used for 'cindent', >>, <<, etc.
o.expandtab = true                                -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
o.tabstop = 4                                     -- Number of spaces that a <Tab> in the file counts for. 


-- Memory & CPU
o.hidden = true                                   -- Enable background buffers
o.history = 100                                   -- Remember N lines in history
o.lazyredraw = true                               -- Faster scrolling
o.synmaxcol = 240                                 -- Max column for syntax highlight
o.updatetime = 700                                -- ms to wait for trigger an event


-- Shortmess[age] configures what (short) messages appear under certain conditions 
-- f  =>  use "(3 of 5)" instead of "(file 3 of 5)"
-- x  =>  use "[dos]" instead of "[dos format]", "[unix]" instead of
--	      "[unix format]" and "[mac]" instead of "[mac format]".
-- t  =>  truncate file message at the start if it is too long to fit on the command-line,
-- T  =>  truncate other messages in the middle if they are too long to fit on the command line.
-- o  =>  overwrite message for writing a file with subsequent message for reading a file 
-- O  =>  message for reading a file overwrites any previous message.
-- I  =>  disable the intro (:intro)
-- F  =>  don't give the file info when editing a file, like `:silent` was used for the command
o.shortmess = 'fxtToOIF'
-- stylua: ignore end

-- Disable builtins plugins
local disabled_built_ins = {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'matchit',
}

for _, plugin in pairs(disabled_built_ins) do
  g['loaded_' .. plugin] = true
end
