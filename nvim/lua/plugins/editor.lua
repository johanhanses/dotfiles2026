return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader><space>", function() Snacks.picker.files() end, desc = "Find files" },
    },
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules", ".next", "dist" },
          },
          grep = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules", ".next", "dist" },
          },
        },
      },
    },
  },
}
