return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local parsers = {
        "bash", "css", "html", "javascript", "json", "jsonc",
        "lua", "markdown", "markdown_inline", "tsx", "typescript",
        "vim", "vimdoc", "yaml",
      }

      local installed = require("nvim-treesitter.config").get_installed()
      local to_install = vim.iter(parsers)
        :filter(function(p) return not vim.tbl_contains(installed, p) end)
        :totable()

      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(event)
          if pcall(vim.treesitter.start, event.buf) then
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        end,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
          if pcall(vim.treesitter.start, buf) then
            vim.api.nvim_buf_call(buf, function()
              vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            end)
          end
        end
      end
    end,
  },
}
