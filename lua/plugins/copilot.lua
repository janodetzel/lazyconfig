return {
  "github/copilot.vim",
  init = function()
    local group = vim.api.nvim_create_augroup("copilot_disable_env_files", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
      group = group,
      callback = function(args)
        local name = vim.fn.fnamemodify(args.file, ":t")
        if name:match("^%.env") then
          vim.b[args.buf].copilot_enabled = false
        end
      end,
    })
  end,
}
