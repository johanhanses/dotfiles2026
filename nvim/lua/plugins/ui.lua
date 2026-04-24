return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        component_separators = "",
        section_separators = "",
      },
    },
  },
  {
    "shortcuts/no-neck-pain.nvim",
    cmd = "NoNeckPain",
    keys = {
      { "<leader>nn", "<cmd>NoNeckPain<CR>", desc = "No Neck Pain" },
    },
    opts = {
      width = 140,
    },
  },
}
