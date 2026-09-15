-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- ─── JetBrains keymap layer ──────────────────────────────────────────────────
--
-- This sits on top of LazyVim's own <leader> maps, which all still work; it
-- only adds the chords that JetBrains muscle memory reaches for first.
--
-- Nearly all of it depends on WezTerm's kitty keyboard protocol
-- (`enable_kitty_keyboard` in ~/.wezterm.lua). Without that a terminal cannot
-- encode Ctrl+Shift+F, Shift+F6 or Alt+Enter at all, and these maps go dead.
--
-- Deliberately NOT taken, because vim needs them more than JetBrains does:
--   <C-w> window prefix   <C-d>/<C-u> half-page scroll   <C-v> visual block
--   <C-r> redo            <C-a>/<C-x> increment/decrement
-- So there is no Ctrl+W close-tab, Ctrl+D duplicate-line or Ctrl+Y delete-line;
-- use <leader>bd, yyp and dd. Two keys ARE taken from vim: <C-e> (scroll down)
-- and <C-b> (page up), because recent-files and go-to-declaration earn them.
--
-- Double-Shift ("Search Everywhere") is not implementable - no terminal
-- reports a bare modifier press, kitty protocol included. Ctrl+Shift+N does
-- that job here, which is also a real JetBrains binding.

local map = vim.keymap.set

-- ─── Search and navigation ───────────────────────────────────────────────────
map("n", "<C-S-n>", function() Snacks.picker.smart() end, { desc = "Search Everywhere" })
map("n", "<C-n>", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Go to Class/Symbol" })
map("n", "<C-S-a>", function() Snacks.picker.commands() end, { desc = "Find Action" })
map("n", "<C-e>", function() Snacks.picker.recent() end, { desc = "Recent Files" })
map("n", "<C-S-f>", function() Snacks.picker.grep() end, { desc = "Find in Files" })
map("x", "<C-S-f>", function() Snacks.picker.grep_word() end, { desc = "Find selection in Files" })
map("n", "<C-S-r>", function() require("grug-far").open({ transient = true }) end, { desc = "Replace in Files" })
map("n", "<C-F12>", function() Snacks.picker.lsp_symbols() end, { desc = "File Structure" })
map("n", "<C-A-Left>", "<C-o>", { desc = "Navigate Back" })
map("n", "<C-A-Right>", "<C-i>", { desc = "Navigate Forward" })

-- ─── Code intelligence ───────────────────────────────────────────────────────
map("n", "<C-b>", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Declaration" })
map("n", "<C-A-b>", function() Snacks.picker.lsp_implementations() end, { desc = "Go to Implementation" })
map("n", "<M-F7>", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "Find Usages" })
map("n", "<C-q>", function() vim.lsp.buf.hover() end, { desc = "Quick Documentation" })
map("n", "<C-p>", function() vim.lsp.buf.signature_help() end, { desc = "Parameter Info" })
map({ "n", "x" }, "<M-CR>", function() vim.lsp.buf.code_action() end, { desc = "Context Actions" })
map("n", "<S-F6>", function()
  -- inc-rename previews the rename live in the buffer, the way the JetBrains
  -- rename dialog does.
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename" })
map({ "n", "x" }, "<C-A-l>", function() LazyVim.format({ force = true }) end, { desc = "Reformat Code" })
map("n", "<F2>", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Error" })
map("n", "<S-F2>", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous Error" })

-- Ctrl+/ comment. <C-_> is the same keypress as seen by a terminal that is not
-- speaking the kitty protocol, so both are mapped and this one keeps working
-- if you ever run nvim outside WezTerm.
map("n", "<C-/>", "gcc", { remap = true, desc = "Comment Line" })
map("x", "<C-/>", "gc", { remap = true, desc = "Comment Selection" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Comment Line" })
map("x", "<C-_>", "gc", { remap = true, desc = "Comment Selection" })

-- ─── Tool windows (Alt+<n>, as in JetBrains) ─────────────────────────────────
map("n", "<M-1>", function()
  require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
end, { desc = "Project" })
map("n", "<M-4>", "<cmd>OverseerToggle<cr>", { desc = "Run" })
map("n", "<M-5>", function() require("dapui").toggle({}) end, { desc = "Debug" })
map("n", "<M-6>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems" })
map("n", "<M-7>", function() require("aerial").toggle() end, { desc = "Structure" })
map("n", "<M-8>", function() require("neotest").summary.toggle() end, { desc = "Tests" })
map("n", "<M-9>", function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end, { desc = "Git" })
map("n", "<M-F12>", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal" })

-- ─── Run and debug ───────────────────────────────────────────────────────────
-- F7/F8/F9 are the JetBrains stepping keys unchanged.
map("n", "<S-F10>", "<cmd>OverseerRun<cr>", { desc = "Run" })
map("n", "<S-F9>", function() require("dap").continue() end, { desc = "Debug" })
map("n", "<F9>", function() require("dap").continue() end, { desc = "Resume Program" })
map("n", "<F8>", function() require("dap").step_over() end, { desc = "Step Over" })
map("n", "<F7>", function() require("dap").step_into() end, { desc = "Step Into" })
map("n", "<S-F8>", function() require("dap").step_out() end, { desc = "Step Out" })
map("n", "<C-F8>", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
map("n", "<C-S-F8>", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional Breakpoint" })
map("n", "<C-S-F10>", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run Tests in File" })

-- ─── Refactoring ─────────────────────────────────────────────────────────────
map("x", "<C-A-m>", function() require("refactoring").refactor("Extract Function") end, { desc = "Extract Method" })
map("x", "<C-A-v>", function() require("refactoring").refactor("Extract Variable") end, { desc = "Extract Variable" })
map("n", "<C-A-n>", function() require("refactoring").refactor("Inline Variable") end, { desc = "Inline Variable" })
map({ "n", "x" }, "<C-A-S-t>", function() require("refactoring").select_refactor() end, { desc = "Refactor This" })
