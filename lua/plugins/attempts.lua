return {
  {
    'm-demare/attempt.nvim', -- No need to specify plenary as dependency
    config = function()
      local attempt = require 'attempt'
      local map = vim.keymap.set

      map('n', '<leader>an', attempt.new_select, { desc = '[N]ew [a]ttempt from list' })
      map('n', '<leader>ai', attempt.new_input_ext, { desc = 'New [a]ttempt from [i]nput' })
      map('n', '<leader>ar', attempt.run, { desc = '[R]un [a]ttempt' })
      map('n', '<leader>ad', attempt.delete_buf, { desc = '[D]elete [a]ttempt from current buffer' })
      map('n', '<leader>ac', attempt.rename_buf, { desc = 'Rename [a]ttempt from [c]urrent buffer' })
      map('n', '<leader>al', require('attempt.snacks').picker, { desc = '[L]ist [a]ttempts' })
      attempt.setup {
        ext_options = { 'lua', 'js', 'ts', 'py', 'json', 'yaml', '' },
      }
    end,
  },

  {
    'Owen-Dechow/videre.nvim',
    cmd = 'Videre',
    dependencies = {
      'Owen-Dechow/graph_view_yaml_parser', -- Optional: add YAML support
      'Owen-Dechow/graph_view_toml_parser', -- Optional: add TOML support
      'a-usr/xml2lua.nvim', -- Optional | Experimental: add XML support
    },
    opts = {
      round_units = false,
      simple_statusline = true, -- If you are just starting out with Videre,
      --   setting this to `false` will give you
      --   descriptions of available keymaps.
    },
  },
}
