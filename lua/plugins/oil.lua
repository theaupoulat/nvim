function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies

  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    require('oil').setup {
      -- Your configuration comes here
      -- You can also pass in the config directly to setup()
      -- See :help oil-config for all available options
      winbar = {
        enabled = true,
        show_file_path = false,
        path = get_oil_winbar,
      },
      float = {
        padding = 12,
      }
    }
    vim.keymap.set('n', '\\', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' })
  end,

  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
