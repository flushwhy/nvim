return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "go", "odin", "lua", "vim", "vimdoc",
        "json", "yaml", "toml",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
}
