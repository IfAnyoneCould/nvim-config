-- the colorscheme of the theme wzt (~/Projects/wezterm-themes) last picked,
-- ashen if it never ran. wzt switches running nvims itself over their pipes
local f = io.open(vim.fn.expand("~/.config/wezterm/themes/current.json"), "r")
if not f then return "ashen" end
local ok, theme = pcall(vim.json.decode, f:read("*a"))
f:close()
return ok and theme.nvim or "ashen"
