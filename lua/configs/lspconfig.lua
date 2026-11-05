require("nvchad.configs.lspconfig").defaults()

vim.lsp.enable({
  "clangd",
  "gopls",
  "ols",
  "pyright",
  "rust_analyzer",
  "html",
  "cssls",
})
