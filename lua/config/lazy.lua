local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Languages. Each of these pulls in the LSP server, formatter, linter,
    -- treesitter parsers and - where one exists - the debug adapter and test
    -- adapter for that language, so they are what turn this from a text
    -- editor into an IDE. Mason installs the binaries on first start.
    { import = "lazyvim.plugins.extras.lang.python" },   -- basedpyright + ruff
    { import = "lazyvim.plugins.extras.lang.java" },     -- jdtls
    { import = "lazyvim.plugins.extras.lang.rust" },     -- rustaceanvim
    { import = "lazyvim.plugins.extras.lang.clangd" },   -- C / C++
    { import = "lazyvim.plugins.extras.lang.cmake" },
    { import = "lazyvim.plugins.extras.lang.go" },       -- gopls + delve
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.git" },

    -- The JetBrains tool windows: debugger, test runner, structure, run
    -- configurations, problems, project tree, and edgy to dock them all to
    -- fixed edges instead of leaving them as floating windows.
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.ui.edgy" },           -- docks the panels
    { import = "lazyvim.plugins.extras.editor.aerial" },      -- structure view
    { import = "lazyvim.plugins.extras.editor.neo-tree" },    -- project tree
    { import = "lazyvim.plugins.extras.editor.overseer" },    -- run configurations
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },  -- sticky scroll
    { import = "lazyvim.plugins.extras.ui.indent-blankline" },

    -- Editor behaviour JetBrains gives you for free.
    { import = "lazyvim.plugins.extras.editor.navic" },       -- breadcrumbs
    { import = "lazyvim.plugins.extras.editor.illuminate" },  -- highlight usages
    { import = "lazyvim.plugins.extras.editor.inc-rename" },  -- rename w/ preview
    { import = "lazyvim.plugins.extras.editor.refactoring" }, -- extract method/var
    { import = "lazyvim.plugins.extras.editor.mini-move" },   -- move line/selection
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.yanky" },       -- clipboard history
    { import = "lazyvim.plugins.extras.coding.neogen" },      -- docstring generation
    { import = "lazyvim.plugins.extras.util.project" },       -- recent projects

    -- NOTE: no lazyvim.plugins.extras.ai.* on purpose - completion stays LSP
    -- and snippets only, with inline full-line previews off (vim.g.ai_cmp in
    -- config/options.lua).

    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- Custom plugins lazy-load too, so LazyVim's own triggers decide when
    -- they come in. Anything that has to be up before the first draw says so
    -- itself with lazy = false.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  -- Off: the periodic check spawns git in the background, which is slow on
  -- Windows. :Lazy check when it matters.
  checker = { enabled = false },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
