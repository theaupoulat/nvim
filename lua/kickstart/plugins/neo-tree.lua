-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree toggle current position=right reveal_force_cwd<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>b', ':Neotree toggle show buffers right<cr>', desc = 'NeoTree reveal', silent = true },
    { '<leader>gs', ':Neotree float git_status<cr>', desc = 'NeoTree reveal [g]it [status]', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
