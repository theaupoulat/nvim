return {
  'folke/zen-mode.nvim',
  config = function()
    vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', { desc = 'Toggle [Z]en mode' })
  end,
}
