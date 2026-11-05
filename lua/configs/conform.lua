return {
  formatters = {
    odinfmt = {
      command = "odinfmt",
      args = { "-stdin" },
      stdin = true,
    },
  },
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    go = { "gofmt" },
    odin = { "odinfmt" },
    lua = { "stylua" },
    python = { "ruff_format" },
    css = { "prettier" },
    html = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}
