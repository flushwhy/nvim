---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "doomchad",
  transparency = true,
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    MatchParen = { fg = "black", bg = "yellow", bold = true },
    CursorLine = { bg = "one_bg2" },
    CursorLineNr = { fg = "yellow", bold = true },
    IlluminatedWordText = { bg = "one_bg3", bold = true },
    IlluminatedWordRead = { bg = "one_bg3" },
    IlluminatedWordWrite = { bg = "one_bg3", underline = true },
    ["@keyword"] = { fg = "purple", bold = true },
    ["@keyword.function"] = { fg = "purple", bold = true, italic = true },
    ["@function"] = { fg = "blue", bold = true, italic = true },
    ["@function.call"] = { fg = "blue", bold = true, italic = true },
    ["@function.method"] = { fg = "blue", bold = true, italic = true },
    ["@function.builtin"] = { fg = "cyan", bold = true, italic = true },
    ["@type"] = { fg = "yellow", bold = true },
    ["@type.builtin"] = { fg = "yellow", bold = true },
    ["@variable"] = { fg = "white", italic = true },
    ["@variable.builtin"] = { fg = "white", italic = true },
    ["@variable.member"] = { fg = "white", italic = true },
    ["@parameter"] = { fg = "red", italic = true },
    ["@string"] = { fg = "green" },
    ["@number"] = { fg = "orange", bold = true },
    ["@constant"] = { fg = "orange", bold = true },
    ["@operator"] = { fg = "cyan", bold = true },
    ["@punctuation"] = { fg = "white" },
  },
  hl_add = {
    AlphaHeader = { fg = "blue", bold = true },
    AlphaButtons = { fg = "white" },
    AlphaFooter = { fg = "grey_fg", italic = true },
  },
}

M.mason = {
  pkgs = { "clangd", "gopls", "pyright", "rust-analyzer", "rescript-language-server" },
}

return M
