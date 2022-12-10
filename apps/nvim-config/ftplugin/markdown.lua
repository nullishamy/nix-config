require('nvim-surround').buffer_setup({
  surrounds = {
    pairs = {
      ['l'] = function()
        return {
          '[',
          -- getreg reads from the register, and we're reading from the system clipboard here
          '](' .. vim.fn.getreg('+') .. ')',
        }
      end,
    },
  },
})
