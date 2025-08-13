return {
  'dmmulroy/tsc.nvim', -- run and explore tsc errors
  config = function()
    require('tsc').setup()
    vim.keymap.set('n', '<leader>to', ':TSCOpen<CR>', { desc = '[O]pen TSC window' })
    vim.keymap.set('n', '<leader>tc', ':TSCClose<CR>', { desc = '[C]lose TSC window' })
    vim.keymap.set('n', '<leader>tt', ':TSC<CR>', { desc = '[T]SC' })
  end,
}
