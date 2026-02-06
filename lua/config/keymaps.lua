-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Center cursor after half-page scroll
map("n", "<C-u>", "<C-u>zz", { desc = "Center on <C-u>" })
map("n", "<C-d>", "<C-d>zz", { desc = "Center on <C-d>" })

-- Save buffer
map("n", "<Leader>w", "<cmd>w<CR>", { desc = "Write buffer" })
