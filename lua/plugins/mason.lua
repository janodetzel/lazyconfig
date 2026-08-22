return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "shfmt",
        "typescript-language-server",
        "eslint-lsp",
        "prettier",
        "biome",
        "json-lsp",
        "yaml-language-server",
        "tailwindcss-language-server",
        "rust-analyzer",
      },
    },
  },
}
