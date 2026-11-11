return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require "configs.alpha" end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function() require "configs.lspconfig" end,
  },
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    opts = function() return require("metals").bare_config() end,
    config = function(self, metals_config)
      local group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        group = group,
        callback = function() require("metals").initialize_or_attach(metals_config) end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = require "configs.cmp",
  },
  {
    "flushwhy/customrss.nvim",
    opts = {
      feeds = {
        { url = "https://go.dev/blog/feed.atom", name = "Go" },
        { url = "https://blog.rust-lang.org/feed.xml", name = "Rust" },
        { url = "https://ziglang.org/news/index.xml", name = "Zig" },
        { url = "https://neovim.io/news.xml", name = "Neovim" },
        { url = "https://github.blog/feed/", name = "GitHub" },
        { url = "https://hnrss.org/frontpage", name = "HN" },
      },
      sort = { by = "date", order = "desc" },
      fetch = { timeout = 10000, concurrency = 8 },
      state_file = vim.fn.stdpath("data") .. "/customrss.nvim/state.json",
    },
  },
  {
    "mistweaverco/discord.nvim",
    event = "VeryLazy",
    opts = {
      auto_connect = true,
      logo = "auto",
      main_image = "logo",
      client_id = "1233867420330889286",
      debounce_timeout = 10,
      show_time = false,
      global_timer = false,
      editing_text = "Editing %s",
      file_explorer_text = "Browsing %s",
      git_commit_text = "Committing changes",
      plugins_text = "Using %s",
      plugin_manager_text = "Managing plugins",
      reading_text = "Reading %s",
      workspace_text = "Working",
      line_number_text = "Line %s of %s",
      terminal_text = "Using Terminal",
      silence_discord_socket_errors = true,
    },
  },
  {
    "Mythos-404/xmake.nvim",
    version = "^3",
    event = "BufReadPost",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "go", "odin", "lua", "vim", "vimdoc",
        "json", "yaml", "toml", "python", "rust", "html", "css", "scala",
      },
    },
  },
}
