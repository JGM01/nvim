vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("i", "<C-c>", "<Esc>")

-- Enable clipboard integration
vim.opt.clipboard = 'unnamedplus'

-- Copy to system clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Copy to system clipboard NORMAL' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard VISUAL' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Copy line to system clipboard' })

-- Paste from system clipboard
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard NORMAL' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste from system clipboard VISUAL' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Paste line from system clipboard' })

-- Select all text in file
vim.keymap.set('n', '<leader>a', 'ggVG', { desc = 'Select all text' })
-- Optional: Select all and copy to system clipboard
vim.keymap.set('n', '<leader>A', 'ggVG"+y', { desc = 'Select all and copy to clipboard NORMAL' })
vim.keymap.set('v', '<leader>A', 'ggVG"+y', { desc = 'Select all and copy to clipboard VISUAL' })
