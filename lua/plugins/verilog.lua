-- Verilog and SystemVerilog. LazyVim has no extra for either, so this is the
-- same four pieces one would import: parser, server, formatter, and the Mason
-- package behind the last two.
--
-- The tooling is all verible, which ships as a single prebuilt release - the
-- language server, the formatter and the linter are three binaries out of the
-- same archive - so declaring the server is enough to get the formatter too.
-- That matters on Windows: the alternatives (svls, svlangserver) are a cargo
-- and an npm build respectively.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "systemverilog" } },
    -- One parser covers both languages, but it is named after the newer one
    -- and nothing maps the older filetype onto it, so a .v file would fall
    -- back to the regex syntax file. The alias has to exist before the first
    -- FileType fires - that is what LazyVim hangs highlighting off - so it
    -- goes in init rather than in config.
    init = function()
      vim.treesitter.language.register("systemverilog", "verilog")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        verible = {
          cmd = {
            "verible-verilog-ls",
            -- Off by default, which means the built-in ruleset and nothing
            -- else. With it, a .rules.verible_lint found anywhere above the
            -- file being checked is what decides which lints run.
            "--rules_config_search",
            -- verible both answers diagnostic requests and pushes the same
            -- diagnostics unasked; Neovim files those under two namespaces,
            -- so every error is reported twice. Pull is the half to keep -
            -- it is what refreshes on a change.
            "--push_diagnostic_notifications=false",
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        verilog = { "verible" },
        systemverilog = { "verible" },
      },
    },
  },
}
