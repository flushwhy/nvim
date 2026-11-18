require("nvchad.configs.lspconfig").defaults()

-- Use the dedicated OCaml tooling switch on Windows; use the standard command elsewhere.
local ocaml_cmd = { "ocamllsp", "--stdio" }
if vim.fn.has("win32") == 1 then
  ocaml_cmd = {
    "opam", "exec", "--switch=ocaml-lsp-tooling", "--",
    "ocamllsp", "--prefer-dot-merlin",
  }
end

vim.lsp.config("ocamllsp", {
  cmd = ocaml_cmd,
  root_markers = {
    "dune-project", "dune-workspace", ".merlin", "*.opam",
    "opam", "esy.json", "package.json", ".git",
  },
})

-- Launch the ReScript language server through Node instead of the Mason .cmd shim.
local rescript_server_js = vim.fn.stdpath("data")
  .. "/mason/packages/rescript-language-server/node_modules/@rescript/language-server/out/cli.js"

vim.lsp.config("rescript_language_server", {
  cmd = { "node", rescript_server_js, "--stdio" },
  filetypes = { "rescript" },
  root_markers = { "bsconfig.json", "rescript.json", ".git" },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true },
    },
  },
})

vim.lsp.enable({
  "clangd",
  "gopls",
  "ols",
  "pyright",
  "rust_analyzer",
  "html",
  "cssls",
  "ocamllsp",
  "rescript_language_server",
})
