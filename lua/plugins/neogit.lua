vim.keymap.set('n', '<leader>hg', '<cmd>Neogit<CR>', { desc = 'Open Neo[g]it' })
return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim',
  },
  config = true,
}
