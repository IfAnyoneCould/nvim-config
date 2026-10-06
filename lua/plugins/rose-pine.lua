-- the sakura theme in wzt (~/Projects/wezterm-themes). rose pine moon with its
-- blues and teals swapped for the sakura-aura pinks and purples. lazy loads it
-- on :colorscheme rose-pine-moon
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "moon",
      palette = {
        moon = {
          base = "#1A1B28",
          surface = "#222333",
          overlay = "#2E2F42",
          muted = "#6E6A86",
          subtle = "#A091A9",
          text = "#E8DDE4",
          love = "#EB6F92",
          gold = "#F6B3A0",
          rose = "#F2A7C3",
          pine = "#9A82E0",
          foam = "#E0B6E8",
          iris = "#C4A7E7",
          highlight_low = "#21202E",
          highlight_med = "#3A3B50",
          highlight_high = "#4F4D66",
        },
        -- the gilded theme, through colors/gilded.lua. greys so the gold
        -- keywords and functions are the only bright thing
        main = {
          base = "#0F1012",
          surface = "#17181A",
          overlay = "#252627",
          muted = "#5A5752",
          subtle = "#8A8680",
          text = "#D6D2CA",
          love = "#D9725E",
          gold = "#A9B08A",
          rose = "#FFD978",
          pine = "#F5C451",
          foam = "#A8B4C4",
          iris = "#B8A2B0",
          highlight_low = "#1A1B1D",
          highlight_med = "#2E2B26",
          highlight_high = "#45403A",
        },
      },
    },
  },
}
