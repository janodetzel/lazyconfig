return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = { "Obsidian" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "work",
          path = "~/documents/Vaults/Work",
        },
        {
          name = "personal",
          path = "~/documents/Vaults/Personal",
        },
      },
      notes_subdir = "notes",
      new_notes_location = "notes_subdir",
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      completion = {
        blink = true,
        nvim_cmp = false,
      },
      -- callbacks = {
      --   enter_note = function()
      --     vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<CR>", {
      --       buffer = true,
      --       desc = "Obsidian Toggle Checkbox",
      --     })
      --   end,
      -- },
    },
  },
}
