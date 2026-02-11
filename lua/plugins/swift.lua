-- Required brew dependencies:
--   brew install swiftlint xcode-build-server xcbeautify xcp rg jq coreutils
--
--   swiftlint          - linting & formatting for Swift files
--   xcode-build-server - BSP support so sourcekit-lsp understands xcodeproj/xcworkspace
--   xcbeautify         - pretty-prints xcodebuild log output
--   xcp                - manage Xcode project files from Neovim (Project Manager)
--   rg                 - ripgrep, used for Swift Testing framework file matching
--   jq                 - JSON processor, used by pymobiledevice3 integration
--   coreutils          - needed to print macOS app logs without attaching debugger
--
-- Optional (for debugging on physical devices):
--   pipx install pymobiledevice3

return {
  ---------------------------------------------------------------------------
  -- xcodebuild.nvim: Build, Debug, and Test iOS/macOS apps from Neovim
  ---------------------------------------------------------------------------
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("xcodebuild").setup({
        -- default settings work well; override only what you need
      })

      -- Suggested key bindings (under <leader>x)
      vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
      vim.keymap.set("n", "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })
      vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
      vim.keymap.set("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
      vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
      vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
      vim.keymap.set("v", "<leader>xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
      vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" })
      vim.keymap.set("n", "<leader>x.", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" })
      vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
      vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
      vim.keymap.set(
        "n",
        "<leader>xC",
        "<cmd>XcodebuildShowCodeCoverageReport<cr>",
        { desc = "Show Code Coverage Report" }
      )
      vim.keymap.set("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
      vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })
      vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Generate Preview" })
      vim.keymap.set("n", "<leader>x<cr>", "<cmd>XcodebuildPreviewToggle<cr>", { desc = "Toggle Preview" })
      vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
      vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
      vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })
    end,
  },

  ---------------------------------------------------------------------------
  -- nvim-dap: debugger integration for xcodebuild.nvim
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "wojciech-kulik/xcodebuild.nvim",
    },
    config = function()
      local xcodebuild = require("xcodebuild.integrations.dap")
      xcodebuild.setup()

      vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
      vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
      vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
      vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
      vim.keymap.set("n", "<leader>db", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
      vim.keymap.set("n", "<leader>dx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })
    end,
  },
  ---------------------------------------------------------------------------
  -- conform.nvim: use `swiftlint --fix` as the formatter for Swift files
  --   (instead of swiftformat, per user request)
  ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.swift = { "swiftlint" }

      opts.formatters = opts.formatters or {}
      opts.formatters.swiftlint = {
        command = "swiftlint",
        args = { "lint", "--fix", "--format", "--stdin", "--quiet" },
        stdin = true,
      }
    end,
  },
}
