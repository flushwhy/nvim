require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<ESC>", { nowait = true, desc = "Exit insert mode" })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })
map("n", "<C-z>", "<cmd> undo <cr>", { desc = "Undo" })
map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>ut", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })
map("n", "<leader>rs", function()
  require("configs.rss_reader").open()
end, { desc = "Open RSS reader" })
