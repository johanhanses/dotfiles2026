local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", {
  group = augroup("highlight_yank", {}),
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", {}),
  command = "checktime",
})

autocmd("VimResized", {
  group = augroup("resize_splits", {}),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

autocmd("BufReadPost", {
  group = augroup("last_loc", {}),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("FileType", {
  group = augroup("close_with_q", {}),
  pattern = { "help", "man", "qf", "checkhealth", "notify", "lspinfo" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

autocmd("FileType", {
  group = augroup("json_md_conceal", {}),
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

autocmd("FileType", {
  group = augroup("md_text_settings", {}),
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = false
    vim.b.completion = false
  end,
})
