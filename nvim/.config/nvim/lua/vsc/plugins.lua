-- VSCode-specific plugins
-- Only include motion and editing plugins that don't conflict with VSCode's features
-- Avoid: LSP, treesitter syntax, statuslines, file explorers, color schemes, etc.

-- Setup Lazy Package Manager for VSCode
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

-- VSCode-specific plugin list
local vscode_plugins = {
	-- ============================================
	-- MOTION AND NAVIGATION PLUGINS
	-- ============================================
	
	-- Leap - Enhanced motion with 'f' and 'F'
	{
		"ggandor/leap.nvim",
		event = "VeryLazy",
		dependencies = { "tpope/vim-repeat" },
		config = function()
			local leap = require("leap")
			-- Use 'f' and 'F' for leap motions as you configured
			vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap-forward)", { desc = "Leap forward" })
			vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>(leap-backward)", { desc = "Leap backward" })
			
			-- Additional leap configurations
			leap.opts.case_sensitive = false
			leap.opts.equivalence_classes = { ' \t\r\n', }
		end,
	},

	-- Surround - Add/change/delete surrounding chars
	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile" },
		version = "*",
		config = function()
			require("nvim-surround").setup({
				-- Default keymaps work great: ys, cs, ds
				-- Examples: ysiw", cs"', ds"
			})
		end,
	},

	-- Substitute - Better substitute with motions
	{
		"gbprod/substitute.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local substitute = require("substitute")
			substitute.setup()

			-- Use same keymaps as your regular config
			vim.keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
			vim.keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
			vim.keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
			vim.keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
		end,
	},

	-- Text objects and motions
	{
		"wellle/targets.vim",
		event = { "BufReadPre", "BufNewFile" },
		-- Provides additional text objects like cin), da, and more
	},

	-- Comment plugin for better commenting
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("Comment").setup({
				-- VSCode already has good commenting, but this provides more vim-like motions
				-- Examples: gcc, gc{motion}, gbc (block comment)
			})
		end,
	},

	-- vim-repeat for better . repetition with plugins
	{
		"tpope/vim-repeat",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- ============================================
	-- EDITING ENHANCEMENT PLUGINS
	-- ============================================

	-- Multiple cursors that work well with VSCode
	{
		"mg979/vim-visual-multi",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Let VSCode handle most multi-cursor, but this adds vim motions to it
			vim.g.VM_default_mappings = 0
			vim.g.VM_maps = {
				["Find Under"] = "<C-n>",
				["Find Subword Under"] = "<C-n>",
				["Select All"] = "<C-A-n>",
				["Skip Region"] = "<C-x>",
				["Remove Region"] = "<C-p>",
				["Increase"] = "+",
				["Decrease"] = "-",
				["Add Cursor Down"] = "<C-Down>",
				["Add Cursor Up"] = "<C-Up>",
			}
		end,
	},

	-- Enhanced % matching
	{
		"andymass/vim-matchup",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Disable some features that might conflict with VSCode
			vim.g.matchup_matchparen_offscreen = {}
			vim.g.matchup_surround_enabled = 1
		end,
	},

	-- ============================================
	-- UTILITY PLUGINS
	-- ============================================

	-- Which-key for keybinding help (useful even in VSCode)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				-- Minimal setup since VSCode has its own command palette
				delay = 500,
				preset = "modern",
			})
		end,
	},
}

-- Setup Lazy with VSCode plugins
require("lazy").setup(vscode_plugins, {
	change_detection = { notify = false },
	install = { colorscheme = {} }, -- No colorscheme needed in VSCode
	ui = { border = "rounded" },
	performance = {
		rtp = {
			disabled_plugins = {
				-- Disable plugins that conflict with VSCode
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
}) 