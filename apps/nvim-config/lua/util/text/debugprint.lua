require('debugprint').setup({
  print_tag = "--DEBUG--",
  -- Doesnt work very well, and clutters logs when you dont need it to find the location
  -- (we use the auto increment number feature)
  display_snippet = false,

  -- We do this
  create_commands = false,
  create_keymaps = false,
})


