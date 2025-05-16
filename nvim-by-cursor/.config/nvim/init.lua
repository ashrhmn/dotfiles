-- Setup Lazy Package Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set Config Options
require("options")

-- Set KeyMaps
require("keymaps")

-- Setup Lazy Plugins only if not in VSCode
if not vim.g.vscode then
	require("lazy").setup("plugins", { change_detection = { notify = false } })
end
