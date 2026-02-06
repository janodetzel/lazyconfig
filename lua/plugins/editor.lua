return {
  -- Window resizer (activate with <C-w>r)
  {
    "simeji/winresizer",
    keys = {
      { "<C-w>r", "<cmd>WinResizerStartResize<CR>", desc = "Resize window" },
    },
  },

  -- Cursor Agent (AI assistant via Cursor CLI)
  {
    "Sarctiann/cursor-agent.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {},
  },
}
