# nvim

LazyVim with some JetBrains keybinds.

- `lua/config/keymaps.lua` — the JetBrains keymap layer, and what it deliberately
  leaves to vim. Most of it needs WezTerm's kitty keyboard protocol, which
  `~/.wezterm.lua` turns on.
- `lua/config/lazy.lua` — which LazyVim extras are imported, and why.
- `lua/plugins/ide.lua` — multiple carets, line moving, signature help.
- `lua/plugins/lsp.lua` — how far a language server is allowed to look for a
  project root.
- `lua/plugins/verilog.lua` — Verilog and SystemVerilog, which LazyVim has no
  extra for.
- `lua/plugins/ui.lua` — colours, transparency, and where the tool windows dock.
- lua/plugins/rustaceanvim.lua - rustaceanvim plugin for rust development
