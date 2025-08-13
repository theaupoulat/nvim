-- [[ Quickfix list keymaps]]
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>', { desc = '[Q]uickfix: next entry' })
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>', { desc = '[Q]uickfix: previous entry' })
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = '[Q]uickfix: open' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = '[Q]uickfix: close' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = '[E]xtend [d]iagnostic text' })

return {}
