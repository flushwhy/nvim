require("nvchad.configs.lspconfig").defaults()

-- clangd and gopls are managed by Mason. OLS is installed with the Odin
-- toolchain and is configured directly because it is not assumed to exist
-- in every Mason registry.
vim.lsp.config("ols", {
  cmd = { "ols" },
  filetypes = { "odin" },
  root_markers = { "ols.json", ".git" },
})

vim.lsp.enable({ "clangd", "gopls", "ols" })
