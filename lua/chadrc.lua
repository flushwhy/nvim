---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "doomchad",
  transparency = true,
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
  hl_add = {
    AlphaHeader = { fg = "blue", bold = true },
    AlphaButtons = { fg = "white" },
    AlphaFooter = { fg = "grey_fg", italic = true },
  },
}

M.mason = {
  pkgs = { "clangd", "gopls", "pyright", "rust-analyzer" },
}

return M
