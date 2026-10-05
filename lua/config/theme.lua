-- the colorscheme of the theme wzt (~/Projects/wezterm-themes) last picked,
-- ashen if it never ran. wzt switches running nvims itself over their pipes.
-- in wsl the file is on the windows side
local path = vim.fn.expand("~/.config/wezterm/themes/current.json")
if vim.fn.has("wsl") == 1 then
  path = vim.fn.glob("/mnt/c/Users/*/.config/wezterm/themes/current.json", false, true)[1] or path
end
local f = io.open(path, "r")
if not f then return "ashen" end
local ok, theme = pcall(vim.json.decode, f:read("*a"))
f:close()
return ok and theme.nvim or "ashen"
