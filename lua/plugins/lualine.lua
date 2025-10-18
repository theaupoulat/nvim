return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  config = function()
    require('lualine').setup {
      options = {
        theme = 'monokai-pro',
      },
    }
  end,
}
