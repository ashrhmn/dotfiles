if vim.g.vscode then
	-- VSCode extension
	require("vsc.options")
	require("vsc.keymaps")
	require("vsc.plugins")
else
	-- ordinary Neovim
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

-- Setup Lazy Plugins
require("lazy").setup("plugins", { change_detection = { notify = false } })
end