return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}
      opts.servers["*"].keys = opts.servers["*"].keys or {}

      vim.list_extend(opts.servers["*"].keys, {
        -- Disable default <leader>c LSP keys.
        { "<leader>ca", false, mode = { "n", "x" } },
        { "<leader>cA", false, mode = "n" },
        { "<leader>cc", false, mode = { "n", "x" } },
        { "<leader>cC", false, mode = "n" },
        { "<leader>cl", false, mode = "n" },
        { "<leader>cr", false, mode = "n" },
        { "<leader>cR", false, mode = "n" },

        -- Explicit <leader>l mappings, applied by LazyVim's LSP key handler.
        -- `has` keeps mappings scoped to attached servers that support methods.
        {
          "<leader>ll",
          function()
            Snacks.picker.lsp_config()
          end,
          desc = "Lsp Info",
        },
        {
          "<leader>lt",
          function()
            local lsp = {}
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
              table.insert(lsp, client.name)
            end

            local formatters = {}
            if package.loaded["conform"] then
              local conform_formatters, use_lsp = require("conform").list_formatters_to_run(0)

              for _, formatter in ipairs(conform_formatters) do
                table.insert(formatters, formatter.name)
              end

              if use_lsp then table.insert(formatters, "lsp-format") end
            end

            vim.notify(table.concat({
              "LSP: " .. (#lsp > 0 and table.concat(lsp, ", ") or "none"),
              "Formatters: " .. (#formatters > 0 and table.concat(formatters, ", ") or "none"),
            }, "\n"), vim.log.levels.INFO, { title = "Buffer tools" })
          end,
          desc = "Show Buffer Tools",
        },
        { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
        { "<leader>lc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, has = "codeLens" },
        { "<leader>lC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = "n", has = "codeLens" },
        {
          "<leader>lR",
          function()
            Snacks.rename.rename_file()
          end,
          desc = "Rename File",
          mode = "n",
          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
        },
        { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
        { "<leader>lA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
      })

      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls.keys = opts.servers.vtsls.keys or {}
      vim.list_extend(opts.servers.vtsls.keys, {
        { "<leader>co", false },
        { "<leader>cM", false },
        { "<leader>cu", false },
        { "<leader>cD", false },
        { "<leader>cV", false },
        { "<leader>lo", LazyVim.lsp.action["source.organizeImports"], desc = "Organize Imports" },
        { "<leader>lM", LazyVim.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports" },
        { "<leader>lu", LazyVim.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
        { "<leader>lD", LazyVim.lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
        {
          "<leader>lV",
          function()
            LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
          end,
          desc = "Select TS workspace version",
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    keys = {
      { "<leader>cm", false },
      { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = opts.mapping or {}
      opts.mapping["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      opts.mapping["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    end,
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>cs", false },
      { "<leader>cS", false },
      { "<leader>ls", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>lS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
    },
  },
  {
    "stevearc/conform.nvim",
    keys = {
      { "<leader>cF", false, mode = { "n", "x" } },
      {
        "<leader>lF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "x" },
        desc = "Format Injected Langs",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>c", desc = "Close Buffer", icon = { icon = "󰅖 ", color = "red" } },
        { "<leader>C", desc = "Close Buffer and Window", icon = { icon = "󰅖 ", color = "red" } },
        { "<leader>l", group = "code", icon = { icon = " ", color = "orange" } },
        { "<leader>n", group = "notifications" },
      })
    end,
  },
  -- Window resizer (activate with <C-w>r)
  {
    "simeji/winresizer",
    keys = {
      { "<C-w>r", "<cmd>WinResizerStartResize<CR>", desc = "Resize window" },
    },
  },
}
