vim.opt.updatetime = 200

require("barbecue").setup({
  create_autocmd = false,
})

vim.api.nvim_create_autocmd({
  "WinScrolled",
  "BufWinEnter",
  "CursorHold",
  "InsertLeave",

  "BufModifiedSet",
}, {
  group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  callback = function()
    require("barbecue.ui").update()
  end,
})
