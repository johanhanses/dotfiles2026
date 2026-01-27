-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Disable conceallevel for json, jsonc, and markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.wo.conceallevel = 0
  end,
})

-- Disable completions, diagnostics, and spell checking for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.b.blink_cmp_enabled = false
    vim.b.copilot_enabled = false
    vim.diagnostic.enable(false, { bufnr = 0 })
    vim.wo.spell = false
  end,
})
