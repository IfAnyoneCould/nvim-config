-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Completion is LSP + snippets only. LazyVim ties blink.cmp's inline "ghost
-- text" preview to this flag, so turning it off means nothing ever previews a
-- whole line of code in front of the cursor. No ai.* extras are imported
-- either (see config/lazy.lua).
vim.g.ai_cmp = false

-- Coming from JetBrains: show the column guide and keep a little context
-- around the cursor rather than letting it sit on the last line.
vim.opt.colorcolumn = "100"
vim.opt.scrolloff = 8

-- JetBrains autosaves; LazyVim's format-on-save plus a persistent undofile
-- gets close, and confirm turns "unsaved changes" into a prompt instead of an
-- error when quitting.
vim.opt.confirm = true

-- LazyVim's python extra ships both pyright and basedpyright and defaults to
-- pyright; basedpyright is the fork with inlay hints and stricter inference,
-- which is closer to what PyCharm shows you.
vim.g.lazyvim_python_lsp = "basedpyright"

-- A .v file is ambiguous - Verilog, Coq or V - and Neovim guesses by reading
-- the first 500 lines, which means an empty new file opens as V and gets no
-- server. Nothing here is ever Coq or V.
vim.g.filetype_v = "verilog"

-- Started from msys2's zsh, Neovim takes $SHELL (zsh.exe) as its shell but
-- keeps cmd.exe's flags, so every :! and string job runs `zsh /s /c ...` and
-- zsh goes looking for a file called /s. Give a posix shell posix flags.
if vim.fn.has("win32") == 1 and vim.o.shell:match("[/\\]%a*sh%.exe$") then
  vim.o.shellcmdflag = "-c"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  vim.o.shellpipe = "2>&1 | tee"
  vim.o.shellredir = ">%s 2>&1"
end
