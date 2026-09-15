-- What a language server thinks "the project" is, because that is what it
-- indexes on startup.
--
-- lua-language-server picks its root by walking up from the file until it
-- finds a marker, and `.luarc.json` outranks `.git`. A stray
-- C:\Users\JonahW\.luarc.json therefore made the whole user profile the
-- workspace for every Lua file on this machine - including the files in this
-- config, whose own .git was never reached - which is the "More than 100000
-- files have been scanned" warning in nvim-data/lsp.log. That file is gone;
-- these are the ceilings that keep any future mis-detection cheap.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                -- lazydev loads the Neovim API and the plugin sources on
                -- demand, so the workspace only ever has to cover the files
                -- you actually opened; it does not need a big preload budget.
                maxPreload = 2000,
                preloadFileSize = 500,
                checkThirdParty = false,
                -- Ignored wherever they appear under the root. The first row
                -- is per-project build output, the second is what sits in a
                -- home directory and is worth thousands of files on its own.
                ignoreDir = {
                  ".git",
                  "node_modules",
                  ".venv",
                  "venv",
                  "target",
                  "build",
                  "dist",
                  "AppData",
                  "OneDrive",
                  "scoop",
                  "Downloads",
                  ".cache",
                  ".gradle",
                  ".m2",
                  "go/pkg",
                },
              },
            },
          },
        },
      },
    },
  },
}
