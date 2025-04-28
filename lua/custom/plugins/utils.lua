vim.api.nvim_create_user_command("ShowFileType", function()
  print(vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(0), 'filetype'))
end, {})

vim.api.nvim_create_user_command("ShowFileName", function()
  local file_name = vim.fn.expand('%:p')
  vim.fn.setreg('+', file_name)
  print(file_name)
end, {})


return {}
