return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("onedarkpro").setup({
        styles = {
          comments = "italic",
          keywords = "NONE",
          functions = "NONE",
        },
      })
      local is_dark = vim.fn.system("defaults read -g AppleInterfaceStyle 2>/dev/null"):match("Dark")
      vim.o.background = is_dark and "dark" or "light"
      vim.cmd.colorscheme(is_dark and "onedark" or "onelight")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("onedark")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("onelight")
      end,
    },
  },
}
