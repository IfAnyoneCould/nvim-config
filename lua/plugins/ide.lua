-- The IDE behaviours that are not just a LazyVim extra switched on.
return {
  -- Multiple carets. JetBrains: Alt+J takes the next occurrence of the word
  -- under the cursor, Ctrl+Alt+Shift+J takes all of them, and Escape drops
  -- back to one caret.
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local map = vim.keymap.set
      map({ "n", "x" }, "<M-j>", function() mc.matchAddCursor(1) end, { desc = "Caret at next match" })
      map({ "n", "x" }, "<M-S-j>", function() mc.matchSkipCursor(1) end, { desc = "Skip this match" })
      map({ "n", "x" }, "<C-M-S-j>", function() mc.matchAllAddCursors() end, { desc = "Select all occurrences" })
      map({ "n", "x" }, "<C-M-Up>", function() mc.lineAddCursor(-1) end, { desc = "Clone caret above" })
      map({ "n", "x" }, "<C-M-Down>", function() mc.lineAddCursor(1) end, { desc = "Clone caret below" })

      -- Only while extra carets exist: Escape clears them first, the way it
      -- collapses multiple carets in JetBrains, instead of leaving them behind.
      mc.addKeymapLayer(function(layer)
        layer({ "n", "x" }, "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },

  -- Alt+Shift+Up/Down moves the line or the selection, as in JetBrains.
  {
    "nvim-mini/mini.move",
    optional = true,
    opts = {
      mappings = {
        left = "<M-S-Left>",
        right = "<M-S-Right>",
        down = "<M-S-Down>",
        up = "<M-S-Up>",
        line_left = "<M-S-Left>",
        line_right = "<M-S-Right>",
        line_down = "<M-S-Down>",
        line_up = "<M-S-Up>",
      },
    },
  },

  -- Parameter info while you type the arguments, inline hints, and the
  -- run/usages annotations JetBrains shows above a symbol.
  {
    "saghen/blink.cmp",
    opts = {
      signature = { enabled = true },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 150 } },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      codelens = { enabled = true },
    },
  },
}
