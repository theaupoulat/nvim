vim.keymap.set('n', '<M-l>', ':Gitsigns next_hunk <CR>', { desc = 'Next hunk' })
vim.keymap.set('n', '<M-h>', ':Gitsigns prev_hunk <CR>', { desc = 'Previous hunk' })

return {
  {
    'lewis6991/gitsigns.nvim', -- Adds git related signs to the gutter, as well as utilities for managing changes
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
}
