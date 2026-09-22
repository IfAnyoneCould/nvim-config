-- Diagnostic messages that stay on the screen.
--
-- LazyVim renders diagnostics as virtual text: the message is appended after
-- the code on the same line and is never wrapped, so everything past the right
-- edge of the window is simply not drawn. Prose linters are the worst case for
-- that, because their messages are sentences - markdownlint's
-- "MD013/line-length Line length [Expected: 80; Actual: 213]" is already
-- running off the edge before it says anything useful.
--
-- Neovim 0.11 added the virtual_lines handler, which puts the message on its
-- own lines underneath the code instead. That is the right shape, but on its
-- own it does not solve this, for two reasons, and the two pieces below are
-- one fix each.

-- The connector the handler draws in front of every message line - "└──── " on
-- the first line, six spaces on each continuation.
local CONNECTOR_CELLS = 6

-- Only a floor to keep the wrap loop sane if a window is somehow narrower than
-- the connector itself. With the indent removed (see the handler wrapper at
-- the bottom) there is always most of the window to wrap into.
local MIN_WIDTH = 8

--- Greedy word wrap measured in display cells rather than bytes, so multibyte
--- punctuation in a linter message does not throw the width off.
--- @param message string
--- @param width integer
--- @return string # the message with newlines inserted at the wrap points
local function wrap(message, width)
  local lines = {}
  local line, line_width = "", 0

  local function flush()
    if line ~= "" then
      lines[#lines + 1] = line
      line, line_width = "", 0
    end
  end

  for word in message:gmatch("%S+") do
    local word_width = vim.fn.strdisplaywidth(word)
    if line ~= "" and line_width + 1 + word_width <= width then
      line, line_width = line .. " " .. word, line_width + 1 + word_width
    elseif word_width <= width then
      flush()
      line, line_width = word, word_width
    else
      -- A single token wider than the column - a URL, or a Windows path out of
      -- a compiler - has to be broken mid-word or it runs off the edge again.
      -- strcharpart indexes by character rather than by byte, so this breaks
      -- between characters instead of through the middle of one.
      flush()
      for i = 0, vim.fn.strchars(word) - 1 do
        local char = vim.fn.strcharpart(word, i, 1)
        local char_width = vim.fn.strdisplaywidth(char)
        if line_width + char_width > width then
          flush()
        end
        line, line_width = line .. char, line_width + char_width
      end
    end
  end

  flush()
  return table.concat(lines, "\n")
end

-- Fix 1: the handler splits the message on newlines and nothing else, and it
-- anchors the extmark with virt_lines_overflow = "scroll", so one long
-- unbroken message still disappears off the right edge. The text has to
-- arrive with the line breaks already in it.
--- @param diagnostic vim.Diagnostic
--- @return string
local function format(diagnostic)
  local message = diagnostic.message

  -- What the built-in formatter does, minus the duplication: nvim-lint parses
  -- the rule name out of the linter's output into `code` but usually leaves it
  -- at the front of `message` as well.
  local code = diagnostic.code and tostring(diagnostic.code)
  if code and not vim.startswith(message, code) then
    message = string.format("%s: %s", code, message)
  end

  -- The text area only, so the number column and the sign column are not
  -- counted as room for the message.
  local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local width = info and (info.width - info.textoff) or vim.o.columns
  width = width - CONNECTOR_CELLS - (diagnostic.col or 0)

  return wrap(message, math.max(width, MIN_WIDTH))
end

-- Fix 2: the handler indents each message under the column the diagnostic
-- starts at. That is a useful pointer for a compiler error on a short line of
-- code, but MD013 reports at the column where the line got too long, so on a
-- full-width markdown line the indent eats the window and the message wraps
-- into a four-word-wide ribbon against the right margin. Reporting the column
-- to the handler as 0 moves the message to the left edge and gives it the
-- whole window; the sign column, the underline and the cursor still say which
-- line and which text the diagnostic is about.
local builtin = vim.diagnostic.handlers.virtual_lines
vim.diagnostic.handlers.virtual_lines = vim.tbl_extend("force", builtin, {
  show = function(namespace, bufnr, diagnostics, opts)
    local unindented = vim.tbl_map(function(diagnostic)
      return vim.tbl_extend("force", diagnostic, { col = 0 })
    end, diagnostics)
    return builtin.show(namespace, bufnr, unindented, opts)
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- Off, because virtual_lines would otherwise repeat the message that
        -- is already truncated at the end of the line. The sign column and the
        -- underline still mark every line that has a diagnostic; only the text
        -- moves.
        virtual_text = false,
        virtual_lines = {
          -- Only the line the cursor is on expands. Wrapping every diagnostic
          -- in the file at once pushes the code around as you scroll, which in
          -- a long markdown file is most of the screen.
          current_line = true,
          format = format,
        },
      },
    },
  },
}
