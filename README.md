# ghui.nvim

[![CI](https://github.com/Christopherbilg/ghui.nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/Christopherbilg/ghui.nvim/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)

Run the [`ghui`](https://github.com/kitlangton/ghui) TUI — a keyboard-driven
interface for your GitHub pull requests — in a floating window inside Neovim, a
single reusable instance you toggle open and closed. Zero runtime dependencies.

Inspired by [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) and
[lazydocker.nvim](https://github.com/crnvl96/lazydocker.nvim).

![Screenshot of ghui.nvim inside of neovim](/screenshot.png)

## Requirements

- Neovim >= 0.11
- The [`ghui`](https://github.com/kitlangton/ghui) executable in your `PATH`
- The [GitHub CLI](https://cli.github.com) (`gh`), installed and authenticated
  with `gh auth login` — ghui uses it to talk to GitHub

Run `:checkhealth ghui` to verify.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "Christopherbilg/ghui.nvim",
  cmd = "Ghui",
  keys = {
    { "<leader>gh", "<cmd>Ghui<cr>", desc = "ghui" },
  },
  opts = {},
}
```

`opts = {}` calls `setup()` for you. The plugin also works with zero config.

## Usage

- `:Ghui` toggles the window.
- Lua API: `require("ghui").open() / .close() / .toggle()`.

Hiding the window keeps the `ghui` process running; quitting the TUI itself
closes the window.

## Configuration

Defaults:

```lua
require("ghui").setup({
  cmd = "ghui",
  args = {},
  window = {
    width = 0.9,
    height = 0.9,
    border = "rounded",
    relative = "editor",
    title = " ghui ",
    title_pos = "center",
    zindex = 50,
    winblend = 0,
  },
  start_insert = true,
  keymaps = { close = false },
  on_open = nil,
  on_exit = nil,
})
```

| Option | Default | Description |
| --- | --- | --- |
| `cmd` | `"ghui"` | Command (string or list) used to launch the TUI. |
| `args` | `{}` | Extra arguments appended to `cmd`. |
| `window.width` / `.height` | `0.9` | `<= 1` = fraction of the editor; `> 1` = absolute size. |
| `window.border` | `"rounded"` | Any `nvim_open_win()` border value. |
| `window.title` / `.title_pos` | `" ghui "` / `"center"` | Float title. |
| `window.zindex` / `.winblend` | `50` / `0` | Float z-index / transparency. |
| `start_insert` | `true` | Enter terminal-mode on open. |
| `keymaps.close` | `false` | Buffer-local "hide window" mapping, or `false`. |
| `on_open` / `on_exit` | `nil` | Lifecycle hooks. |

## License

MIT
