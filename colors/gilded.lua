-- the gilded theme in wzt (~/Projects/wezterm-themes). rose pine main with the
-- gilded palette from plugins/rose-pine.lua, renamed so smear-cursor can tell
-- it from sakura
package.loaded["rose-pine.palette"] = nil
require("rose-pine").colorscheme("main")
vim.g.colors_name = "gilded"
