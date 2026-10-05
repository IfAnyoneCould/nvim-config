-- pico / micropython. runs and uploads over mpremote (uv tool install
-- mpremote), :MPInit sets a project up with the rp2 stubs so basedpyright
-- knows machine, rp2 and friends
return {
  {
    "jim-at-jibba/micropython.nvim",
    dependencies = { "folke/snacks.nvim" },
    -- it io.popen()s with 2>/dev/null, which cmd.exe cant open so the command
    -- never runs (device list, port detection, fs ls). nul is the windows one
    init = function()
      if vim.fn.has("win32") == 0 then return end
      local popen = io.popen
      io.popen = function(cmd, ...) return popen((cmd:gsub("2>/dev/null", "2>nul")), ...) end
    end,
    cmd = {
      "MPRun", "MPRunMain", "MPUpload", "MPUploadAll", "MPRepl", "MPSync", "MPReset", "MPHardReset",
      "MPListFiles", "MPEraseOne", "MPEraseAll", "MPInit", "MPInstall", "MPSetPort", "MPSetBaud",
      "MPSetStubs", "MPListDevices",
    },
    keys = {
      { "<leader>mr", "<cmd>MPRun<cr>", desc = "Run file on device" },
      { "<leader>mm", "<cmd>MPRunMain<cr>", desc = "Run main.py on device" },
      { "<leader>mu", "<cmd>MPUpload<cr>", desc = "Upload file" },
      { "<leader>mU", "<cmd>MPUploadAll<cr>", desc = "Upload project" },
      { "<leader>ms", "<cmd>MPSync<cr>", desc = "Mount project on device" },
      { "<leader>mi", "<cmd>MPRepl<cr>", desc = "REPL" },
      { "<leader>mx", "<cmd>MPReset<cr>", desc = "Soft reset" },
      { "<leader>ml", "<cmd>MPListFiles<cr>", desc = "Files on device" },
      { "<leader>mp", "<cmd>MPSetPort<cr>", desc = "Set port" },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = { spec = { { "<leader>m", group = "micropython" } } },
  },
  -- the port, only in a project with a .micropython file
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, {
        function() return require("micropython_nvim").statusline() end,
        cond = function() return package.loaded["micropython_nvim"] and require("micropython_nvim").exists() end,
      })
    end,
  },
}
