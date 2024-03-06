return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        window = {
          width = 60,
          position = "right",
        },
        indent = {
          indent_size = 1,
          padding = 0
        }
      }
    }
  end,
}
