-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Center cursor after half-page scroll
map("n", "<C-u>", "<C-u>zz", { desc = "Center on <C-u>" })
map("n", "<C-d>", "<C-d>zz", { desc = "Center on <C-d>" })

-- Save buffer
map("n", "<Leader>w", "<cmd>w<CR>", { desc = "Write buffer" })

-- Find current word / grep root dir aliases
map("n", "<leader>fc", function()
  Snacks.picker.grep_word()
end, { desc = "Find current word" })
map("n", "<leader>fw", "<leader>/", { remap = true, desc = "Find word (Grep root dir)" })

-- File browser (Snacks explorer)
vim.keymap.del("n", "<Leader>e")
vim.keymap.del("n", "<Leader>E")

map("n", "<Leader>e", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Toggle file browser" })

map("n", "<Leader>o", function()
  local pickers = Snacks.picker.get({ source = "explorer" })
  if #pickers > 0 and pickers[1]:is_focused() then
    vim.cmd("wincmd p")
  elseif #pickers > 0 then
    pickers[1]:focus()
  else
    Snacks.explorer({ cwd = LazyVim.root() })
  end
end, { desc = "Toggle focus file browser" })
