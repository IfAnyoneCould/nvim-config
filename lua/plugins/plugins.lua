return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("transparent").setup({
        exclude_groups = {
          "Pmenu",
          "PmenuSel", -- completion menu
          "NormalFloat",
          "FloatBorder", -- LSP hover / diagnostics floats
          "StatusLine",
          "StatusLineNC", -- statusline
          "CursorLine", -- current-line bar (optional)
        },
        on_clear = function()
          -- Brighten low-contrast inline text so it reads over the image.
          -- These hexes are starting points — nudge them lighter if needed.
          vim.api.nvim_set_hl(0, "Comment", { fg = "#b8b088", italic = true })
          vim.api.nvim_set_hl(0, "LineNr", { fg = "#928374" })
        end,
      })
      vim.cmd("TransparentEnable")
    end,
  },
  { "luisiacc/gruvbox-baby" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-baby",
    },
  },
  {
    "karb94/neoscroll.nvim",
    opts = {
      easing_function = "quadratic",
    },
  },
}
