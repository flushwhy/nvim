require("nvchad.configs.lspconfig").defaults()

-- nvim-lspconfig supplies the server definitions for all three languages.
vim.lsp.enable({ "clangd", "gopls", "ols" })
