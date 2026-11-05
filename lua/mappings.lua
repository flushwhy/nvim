require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("n", "<leader>ut", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparency" })
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
