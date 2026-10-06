-- the cursor smears from where it was to where it lands, : included
return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- wezterm draws these itself (custom_block_glyphs), so the smear is less
      -- blocky even though the font has none
      legacy_computing_symbols_support = true,
    },
    config = function(_, opts)
      local smear = require("smear_cursor")
      smear.setup(opts)
      -- Normal has no background with transparent.nvim, so it blends the
      -- smear's edges against this. each wzt theme's terminal background
      local bgs = { ashen = "#121212", nord = "#2E3440", everforest = "#2D353B", ["rose-pine"] = "#1A1B28", gilded = "#0F1012" }
      local function fallback()
        smear.transparent_bg_fallback_color = bgs[vim.g.colors_name] or "#1d1d1d"
      end
      fallback()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = fallback })
    end,
  },
}
