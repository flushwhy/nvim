return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require "configs.alpha" end,
  },
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 80,
        min_count_to_highlight = 2,
        large_file_cutoff = 5000,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    config = function()
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      require("ibl").setup({
        indent = {
          char = "▏",
          highlight = {
            "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
            "RainbowGreen", "RainbowViolet", "RainbowCyan",
          },
        },
        scope = { enabled = true, show_start = true, highlight = { "RainbowCyan" } },
      })
    end,
  },
  {
    "echasnovski/mini.animate",
    event = "BufReadPost",
    config = function()
      local animate = require "mini.animate"
      animate.setup({
        cursor = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
        },
        scroll = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
      })
    end,
  },
  {
    "danilamihailov/beacon.nvim",
    event = "BufReadPost",
    opts = {
      speed = 2,
      width = 46,
      winblend = 70,
      fps = 60,
      min_jump = 10,
      cursor_events = { "CursorMoved" },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
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
    opts = function() return require "configs.cmp" end,
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
    opts = function() return require "configs.treesitter" end,
  },
}
