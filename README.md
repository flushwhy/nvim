# Flush Nvim

A small, update-friendly NvChad configuration for the Nusa Mokka workstation.

## Included

- NvChad UI and defaults, loaded directly from the upstream `NvChad/NvChad` plugin.
- NvChad's Telescope search, file explorer, completion, snippets, git signs, and which-key defaults.
- Transparent editor background for Konsole's Nusa Obsidian theme.
- C and C++ through `clangd`.
- Go through `gopls`.
- Odin through the Odin Language Server (`ols`).
- Tree-sitter parsers for C, C++, Go, Odin, Lua, shell, JSON, YAML, and TOML.
- Format-on-save for C/C++, Go, Odin, and Lua.

## Install

Requires Neovim 0.11+, Git, and a Nerd Font. Clone this repository as the Neovim config:

```sh
git clone https://github.com/flushwhy/nvim.git ~/.config/nvim
nvim
```

After the first launch, let lazy.nvim finish installing plugins, then run:

```vim
:MasonInstallAll
:TSUpdate
```

Mason installs `clangd` and `gopls` from the configured LSP servers. Install the matching formatters and Odin language server using your system packages/toolchains:

- C/C++: `clangd` and `clang-format`
- Go: `gopls` and `gofmt` (included with Go)
- Odin: build [OLS](https://github.com/DanielGavin/ols) from source with `./build.sh` and `./odinfmt.sh`; keep `ols`, `odinfmt`, and the OLS `builtin` directory together or set `OLS_BUILTIN_FOLDER`

Make sure those executables are on `PATH`. On FreeBSD, install your Odin toolchain first, then build OLS from its source repository using the included scripts. OLS tracks Odin master, so keep it reasonably aligned with your compiler version.

## Updating

This repository contains only your configuration. NvChad itself is **not copied or forked** into it; lazy.nvim imports it as an upstream plugin.

Update your personal configuration and plugins with:

```sh
cd ~/.config/nvim
git pull
```

Then inside Neovim:

```vim
:Lazy sync
```

To update plugins (including NvChad) later, run `:Lazy update`. The NvChad dependency follows its maintained `v2.5` branch, so upstream fixes can be pulled without merging NvChad source into this repository.

## Useful keys

- `Space` is the leader key.
- `Space u t` toggles transparency.
- `Space c f` formats the current buffer.
- `;` enters command mode.
- `jk` exits insert mode.
