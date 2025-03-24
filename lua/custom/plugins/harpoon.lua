return {
  'ThePrimeagen/harpoon',
  dependencies= {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, { desc = '[H]arpoon: [A]dd mark' })
    vim.keymap.set('n', '<leader>hm', require("harpoon.ui").toggle_quick_menu, { desc = '[H]arpoon: Toggle [M]enu' })
    vim.keymap.set('n', '<leader>hj', require("harpoon.ui").nav_next, { desc = '[H]arpoon: Navigate to next mark' })
    vim.keymap.set('n', '<leader>hk', require("harpoon.ui").nav_prev, { desc = '[H]arpoon: Navigate to prev mark' })
  end
}
