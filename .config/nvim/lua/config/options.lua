--[[
	Options are automatically loaded before lazy.nvim startup
	Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
	Add any additional options here
--]]

-- Set colorscheme
vim.g.colorscheme = "tokyonight-night"

-- Set spell check languages to English and Brazilian Portuguese
vim.opt.spelllang = { "en", "pt" }

-- Enables mousemove events (e.g., for triggering actions when the mouse moves)
vim.opt.mousemoveevent = true

-- Enable smart wrapping indentation
vim.opt.breakindent = true

-- Wrap lines at word boundaries instead of breaking in the middle of words
vim.opt.linebreak = true

-- Enable smart indentation for structured programming languages
vim.opt.smartindent = true

-- Use tabs instead of spaces
vim.opt.expandtab = false

-- Number of spaces that a <tab> counts for
vim.opt.tabstop = 2

-- Number of spaces that a <tab> counts for while editing
vim.opt.softtabstop = 2

-- Number of spaces to use for each step of (auto)indent
vim.opt.shiftwidth = 2

-- Round indentation to the nearest multiple of shiftwidth when shifting (<<, >>)
vim.opt.shiftround = true

-- Enable the display of invisible/whitespace characters
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  lead = "•",
  multispace = "•",
  trail = "•",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
