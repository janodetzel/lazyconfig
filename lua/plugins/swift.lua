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
    cmd = {
      "XcodebuildPicker",
      "XcodebuildProjectManager",
      "XcodebuildBuild",
      "XcodebuildBuildForTesting",
      "XcodebuildBuildRun",
      "XcodebuildTest",
      "XcodebuildTestSelected",
      "XcodebuildTestClass",
      "XcodebuildTestRepeat",
      "XcodebuildToggleLogs",
      "XcodebuildToggleCodeCoverage",
      "XcodebuildShowCodeCoverageReport",
      "XcodebuildTestExplorerToggle",
      "XcodebuildFailingSnapshots",
      "XcodebuildPreviewGenerateAndShow",
      "XcodebuildPreviewToggle",
      "XcodebuildSelectDevice",
      "XcodebuildQuickfixLine",
      "XcodebuildCodeActions",
    },
    keys = {
      { "<leader>X", "<cmd>XcodebuildPicker<cr>", desc = "Show Xcodebuild Actions" },
      { "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", desc = "Show Project Manager Actions" },
      { "<leader>xb", "<cmd>XcodebuildBuild<cr>", desc = "Build Project" },
      { "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", desc = "Build For Testing" },
      { "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Build & Run Project" },
      { "<leader>xt", "<cmd>XcodebuildTest<cr>", desc = "Run Tests" },
      { "<leader>xt", "<cmd>XcodebuildTestSelected<cr>", mode = "v", desc = "Run Selected Tests" },
      { "<leader>xT", "<cmd>XcodebuildTestClass<cr>", desc = "Run Current Test Class" },
      { "<leader>x.", "<cmd>XcodebuildTestRepeat<cr>", desc = "Repeat Last Test Run" },
      { "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Toggle Xcodebuild Logs" },
      { "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Toggle Code Coverage" },
      { "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", desc = "Show Code Coverage Report" },
      { "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", desc = "Toggle Test Explorer" },
      { "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", desc = "Show Failing Snapshots" },
      { "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", desc = "Generate Preview" },
      { "<leader>x<cr>", "<cmd>XcodebuildPreviewToggle<cr>", desc = "Toggle Preview" },
      { "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Select Device" },
      { "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", desc = "Quickfix Line" },
      { "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", desc = "Show Code Actions" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("xcodebuild").setup({
        -- default settings work well; override only what you need
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- nvim-dap: debugger integration for xcodebuild.nvim
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dd",
        function()
          require("xcodebuild.integrations.dap").build_and_debug()
        end,
        desc = "Build & Debug",
      },
      {
        "<leader>dr",
        function()
          require("xcodebuild.integrations.dap").debug_without_build()
        end,
        desc = "Debug Without Building",
      },
      {
        "<leader>dt",
        function()
          require("xcodebuild.integrations.dap").debug_tests()
        end,
        desc = "Debug Tests",
      },
      {
        "<leader>dT",
        function()
          require("xcodebuild.integrations.dap").debug_class_tests()
        end,
        desc = "Debug Class Tests",
      },
      {
        "<leader>db",
        function()
          require("xcodebuild.integrations.dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("xcodebuild.integrations.dap").toggle_message_breakpoint()
        end,
        desc = "Toggle Message Breakpoint",
      },
      {
        "<leader>dx",
        function()
          require("xcodebuild.integrations.dap").terminate_session()
        end,
        desc = "Terminate Debugger",
      },
    },
    dependencies = {
      "wojciech-kulik/xcodebuild.nvim",
    },
    config = function()
      local xcodebuild = require("xcodebuild.integrations.dap")
      xcodebuild.setup()
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
