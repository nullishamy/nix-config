require('cutlass').setup({
  cut_key = 'x',
  override_del = nil,
  -- Don't override s and S, leap uses those
  exclude = { 'ns', 'nS' },
})
