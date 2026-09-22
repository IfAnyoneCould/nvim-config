-- Colours, transparency and where the tool windows live.
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
          -- The WezTerm background is now dimmed to brightness 0.3 rather than
          -- 2.0, so these no longer have to fight a washed-out photo.
          vim.api.nvim_set_hl(0, "Comment", { fg = "#949494", italic = true })
          vim.api.nvim_set_hl(0, "LineNr", { fg = "#535353" })
        end,
      })
      vim.cmd("TransparentEnable")
    end,
  },
  { "luisiacc/gruvbox-baby" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ashen",
    },
  },
  {
    "karb94/neoscroll.nvim",
    opts = {
      easing_function = "quadratic",
    },
  },

  -- Structure docks to the right edge instead of floating, so Alt+7 opens a
  -- panel where JetBrains puts it rather than a window over your code.
  {
    "stevearc/aerial.nvim",
    optional = true,
    opts = function(_, opts)
      opts.layout = vim.tbl_deep_extend("force", opts.layout or {}, {
        default_direction = "right",
        placement = "edge",
        min_width = 30,
      })
      opts.close_on_select = false
      return opts
    end,
  },

  -- edgy already docks neo-tree (left), Trouble, the terminal, Neotest and
  -- grug-far. These are the panels it does not know about: Structure on the
  -- right, Run and the debugger along the bottom - the JetBrains arrangement.
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, { title = "Structure", ft = "aerial", size = { width = 0.22 } })

      opts.bottom = opts.bottom or {}
      vim.list_extend(opts.bottom, {
        { title = "Run", ft = "OverseerList", size = { height = 0.3 } },
        { title = "Debug REPL", ft = "dap-repl", size = { height = 0.3 } },
        { title = "Debug Console", ft = "dapui_console", size = { height = 0.3 } },
        { title = "Variables", ft = "dapui_scopes", size = { height = 0.3 } },
        { title = "Call Stack", ft = "dapui_stacks", size = { height = 0.3 } },
        { title = "Watches", ft = "dapui_watches", size = { height = 0.3 } },
        { title = "Breakpoints", ft = "dapui_breakpoints", size = { height = 0.3 } },
      })
      return opts
    end,
  },

  -- "Always Select Opened File", and a tree that notices changes on disk.
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = { width = 32 },
    },
  },
}
