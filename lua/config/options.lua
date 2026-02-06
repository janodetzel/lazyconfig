-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use comma as local leader (default is \)
vim.g.maplocalleader = ","

-- Only use prettier when a config file is found in the project.
-- This avoids conflicts with biome in biome-configured projects.
vim.g.lazyvim_prettier_needs_config = true

-- Diagnostics: disable virtual text, keep underline
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
})
