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

-- Move code keymaps from <leader>c to <leader>l and free lazy-related defaults
vim.keymap.del("n", "<leader>l")
vim.keymap.del("n", "<leader>L")

local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "<leader>l", group = "lsp", icon = { icon = " ", color = "orange" } },
    { "<leader>la", desc = "Code Action", mode = { "n", "x" }, icon = { icon = " ", color = "orange" } },
    { "<leader>lA", desc = "Source Action", icon = { icon = " ", color = "orange" } },
    { "<leader>lf", desc = "Format", mode = { "n", "x" }, icon = { icon = " ", color = "cyan" } },
    { "<leader>li", desc = "Lsp Info", icon = { icon = " ", color = "azure" } },
    { "<leader>lr", desc = "Rename", icon = { icon = "󰑕 ", color = "yellow" } },
    { "<leader>ld", desc = "Line Diagnostics", icon = { icon = "󱖫 ", color = "green" } },
    { "<leader>lD", desc = "Search Diagnostics", icon = { icon = "󱖫 ", color = "green" } },
    { "<leader>ls", desc = "Document Symbols", icon = { icon = "󰠱 ", color = "purple" } },
    { "<leader>lS", desc = "Symbols Outline", icon = { icon = "󰠱 ", color = "purple" } },
  })
end

map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>lA", LazyVim.lsp.action.source, { desc = "Source Action" })
map({ "n", "x" }, "<leader>lf", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })
map("n", "<leader>li", function()
  Snacks.picker.lsp_config()
end, { desc = "Lsp Info" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>lD", function()
  Snacks.picker.diagnostics()
end, { desc = "Search Diagnostics" })
map("n", "<leader>ls", function()
  Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter })
end, { desc = "Document Symbols" })
map("n", "<leader>lS", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols Outline" })
