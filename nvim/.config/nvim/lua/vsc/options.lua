-- VSCode-specific Neovim options
-- Keep these minimal since VSCode handles most UI and editor settings

local opt = vim.opt

-- Essential vim settings
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard (VSCode integration)
opt.smartcase = true -- Smart case searching
opt.ignorecase = true -- Case insensitive searching
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search

-- Indentation (VSCode will override visually, but this helps with motions)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 500 -- Shorter timeout for key combinations

-- Better motion behavior
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8
opt.wrap = false -- No line wrapping for better motions

-- Better search
opt.gdefault = true -- Global replace by default 