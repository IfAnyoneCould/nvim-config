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

-- Opening a .py file went looking for a python with pynvim, ~450ms every
-- time. Nothing here is a python remote plugin
vim.g.loaded_python3_provider = 0

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

-- windows power mode on best power efficiency (or energy saver) throttles the
-- cpu enough that the animations lag. checked once at startup, they stay off
-- until a restart
do
  local ffi = require("ffi")
  local saving = false
  if vim.fn.has("win32") == 1 then
    pcall(ffi.cdef, [[
      typedef struct { uint32_t a; uint16_t b, c; uint8_t d[8]; } GUID;
      uint32_t PowerGetEffectiveOverlayScheme(GUID *);
      typedef struct { uint8_t ac, flag, pct, saver; uint32_t life, full; } SYSTEM_POWER_STATUS;
      int GetSystemPowerStatus(SYSTEM_POWER_STATUS *);
    ]])
    local ok, powrprof = pcall(ffi.load, "powrprof")
    local g = ffi.new("GUID")
    if ok and powrprof.PowerGetEffectiveOverlayScheme(g) == 0 then saving = g.a == 0x961cc777 end
    local s = ffi.new("SYSTEM_POWER_STATUS")
    if ffi.C.GetSystemPowerStatus(s) ~= 0 and s.saver == 1 then saving = true end
  end
  vim.g.power_saving = saving
  -- snacks scroll and the rest of its animations
  if saving then vim.g.snacks_animate = false end
end
