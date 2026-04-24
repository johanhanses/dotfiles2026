return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayVariableTypeHints = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
              },
            },
          },
        },
      },
    },
  },
}
