return {
  'dmmulroy/tsc.nvim', -- run and explore tsc errors
  config = function()
    require('tsc').setup()
    vim.keymap.set('n', '<leader>tt', ':TSC<CR>', { desc = '[T]SC' })
  end,
}
