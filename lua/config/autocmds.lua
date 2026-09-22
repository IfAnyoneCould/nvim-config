-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- checkOnSave holds cargo check, and with it the borrow checker, until :w.
-- Run it on InsertLeave instead. Debounced, so flicking in and out of
-- insert doesn't spawn a cargo process every time.
local flycheck_timer
vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("rust_flycheck_on_insert_leave", { clear = true }),
  pattern = "*.rs",
  callback = function(ev)
    if flycheck_timer then
      flycheck_timer:stop()
    end
    flycheck_timer = vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(ev.buf) and vim.lsp.get_clients({ bufnr = ev.buf, name = "rust-analyzer" })[1] then
        pcall(vim.cmd.RustLsp, { "flyCheck", "run" })
      end
    end, 500)
  end,
})
