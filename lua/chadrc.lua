---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  transparency = true,
}

M.mason = {
  pkgs = { "clangd", "gopls" },
}

return M
