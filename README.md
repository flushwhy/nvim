# Flush Nvim

A personal, update-friendly NvChad configuration. NvChad stays upstream; this repository contains only the configuration and selected extensions.

## Included

- NvChad UI and defaults, loaded as an upstream Lazy.nvim plugin.
- Doomchad theme with transparency enabled.
- Clean Alpha dashboard with file search, recent files, grep, file browser, and latest technology updates.
- Floating RSS reader with refresh and open-in-browser actions.
- Tuned completion menu with ghost text, bordered documentation, snippet navigation, and useful source labels.
- Telescope, NvimTree, Git signs, which-key, and the rest of NvChad's standard tools.
- Discord Rich Presence and Xmake project integration.
- C and C++ through `clangd`; Go through `gopls`; Odin through `ols`.
- Optional Python, Rust, HTML, and CSS language servers.
- Tree-sitter parsers for C, C++, Go, Odin, Lua, shell, JSON, YAML, TOML, Python, Rust, HTML, and CSS.
- Format-on-save for C/C++, Go, Odin, Lua, Python, CSS, and HTML.
- Transparent background designed to work with terminal transparency.

The dashboard and general UI use neutral editor branding. Odin remains supported as a language, but there is no Odin-themed logo, dashboard slogan, or Odin news feed.

## Install

Requires Neovim 0.11+, Git, and a Nerd Font. Clone this repository as your Neovim config:

```sh
git clone https://github.com/flushwhy/nvim.git ~/.config/nvim
nvim
```

On first launch, let Lazy install plugins. Then run:

```vim
:MasonInstallAll
:TSUpdate
```

Mason installs the configured C/C++, Go, Python, and Rust language servers. Install formatters and Odin tooling separately and ensure they are on `PATH`:

- C/C++: `clangd` and `clang-format`
- Go: `gopls` and `gofmt` (included with Go)
- Odin: `ols` and `odinfmt` from the Odin toolchain
- Python: `pyright` and `ruff`
- Rust: `rust-analyzer` and `rustfmt`
- CSS/HTML: `prettier`

For Odin, build [OLS](https://github.com/DanielGavin/ols) using its provided build scripts and keep it aligned with your Odin compiler version.

## Useful keys

- `Space` is the leader key.
- `Space u t` toggles transparency.
- `Space f m` formats the current buffer.
- `Space r s` opens the RSS reader.
- `Space r n` renames a symbol.
- `Space c a` opens code actions.
- `gd` goes to a definition; `K` shows hover documentation.
- `;` enters command mode; `jk` exits insert mode.
- `Ctrl+S` saves; `Ctrl+Z` undoes.

## Updating

This repository does not vendor or fork NvChad. It imports NvChad as an upstream Lazy.nvim plugin, keeping personal configuration changes separate from framework updates.

Update your configuration:

```sh
cd ~/.config/nvim
git pull
```

Then update plugins, including NvChad, inside Neovim:

```vim
:Lazy update
```

Use `:Lazy sync` after changing plugin specifications. Review NvChad's upstream release notes when updating its framework branch.
