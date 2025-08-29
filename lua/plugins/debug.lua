return {
  'andrewferrier/debugprint.nvim',
  config = function()
    local debugprint = require 'debugprint'
    debugprint.setup()
    vim.keymap.set('n', '<leader>dv', '', {
      callback = function()
        debugprint.debugprint { variable = true }
      end,
      desc = '[D]ebug [v]ariable with console.log',
    })

    vim.keymap.set('n', '<leader>dp', '', {
      callback = function()
        debugprint.debugprint {}
      end,
      desc = '[D]ebug [p]lain with console.log',
    })
  end,
  dependencies = {
    'echasnovski/mini.nvim', -- Optional: Needed for line highlighting (full mini.nvim plugin)
    'echasnovski/mini.hipatterns', -- Optional: Needed for line highlighting ('fine-grained' hipatterns plugin)
    'nvim-telescope/telescope.nvim', -- Optional: If you want to use the `:Debugprint search` command with telescope.nvim
  },
  lazy = false, -- Required to make line highlighting work before debugprint is first used
  version = '*', -- Remove if you DON'T want to use the stable version
}
