return {
  -- TODO: move in own plugin
  'loctvl842/monokai-pro.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    require('monokai-pro').setup {}
    vim.cmd.colorscheme 'monokai-pro-spectrum'
  end,
}
