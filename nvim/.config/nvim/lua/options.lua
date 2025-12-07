vim.cmd("let g:netrw_banner = 0")
vim.cmd("let g:netrw_liststyle = 3")
-- vim.cmd("set t_Co=24")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.scrolloff = 10 -- start scrolling when 10 lines from top/bottom

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
-- opt.background = "light" -- Removed: Let keymaps.lua handle background state persistence
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- Modern Neovim options
opt.inccommand = "split" -- Live preview of substitute commands
opt.smoothscroll = true -- Smoother scrolling (Neovim 0.10+)
opt.virtualedit = "block" -- Better visual block editing
opt.undofile = true -- Persistent undo across sessions
opt.pumheight = 15 -- Limit completion menu height
opt.updatetime = 250 -- Faster updatetime for better experience (default 4000)
opt.timeoutlen = 300 -- Faster key sequence timeout

-- Better diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = false, -- Disabled to prevent UI shifts in terminal
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
