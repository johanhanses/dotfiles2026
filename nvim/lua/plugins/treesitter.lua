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

      vim.treesitter.language.register("tsx", "typescriptreact")
      vim.treesitter.language.register("jsx", "javascriptreact")
      vim.treesitter.language.register("bash", "sh")
      vim.treesitter.language.register("markdown", "mdx")

      local function start_treesitter(buf)
        local ft = vim.bo[buf].filetype
        if ft == "" then return end
        local lang = vim.treesitter.language.get_lang(ft) or ft
        pcall(vim.treesitter.start, buf, lang)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(event)
          start_treesitter(event.buf)
        end,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          start_treesitter(buf)
        end
      end
    end,
  },
}
