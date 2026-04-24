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
    end,
  },
}
