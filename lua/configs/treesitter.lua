-- Compatibility helper for nvim-treesitter versions expecting vim.list.unique.
if not vim.list then vim.list = {} end
if not vim.list.unique then
  vim.list.unique = function(items)
    local seen, result = {}, {}
    for _, item in ipairs(items) do
      if not seen[item] then
        seen[item] = true
        result[#result + 1] = item
      end
    end
    return result
  end
end

-- Add local Windows tools to PATH when they are installed.
if vim.fn.has("win32") == 1 then
  local path_sep = package.config:sub(1, 1)
  local current_path = vim.env.PATH or ""
  local function prepend_if_available(path)
    if vim.fn.isdirectory(path) == 1 and not current_path:find(path, 1, true) then
      current_path = path .. path_sep .. current_path
    end
  end
  prepend_if_available(vim.fn.expand("$LOCALAPPDATA/zig"))
  prepend_if_available(vim.fn.expand("$APPDATA/npm"))
  vim.env.PATH = current_path
end

local base = require "nvchad.configs.treesitter"

-- Prefer Zig as a compiler on Windows, where Neovim may not inherit the VS build environment.
if vim.fn.has("win32") == 1 then
  require("nvim-treesitter.install").compilers = { "zig", "gcc", "clang", "cl" }
end

base.ensure_installed = vim.list_extend(base.ensure_installed or {}, {
  "python", "c", "cpp", "rust", "go",
  "html", "css", "javascript", "typescript", "tsx",
  "odin", "ocaml", "rescript", "scala",
  "json", "toml", "yaml", "markdown", "markdown_inline",
  "bash", "regex",
})

base.highlight = base.highlight or {}
base.highlight.enable = true
base.highlight.additional_vim_regex_highlighting = false
base.indent = { enable = true }

return base
