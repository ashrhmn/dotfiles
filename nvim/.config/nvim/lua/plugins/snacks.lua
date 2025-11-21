return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Enable the modules you want
		bigfile = { enabled = true }, -- Better performance for large files
		notifier = {
			enabled = true, -- Better notifications
			timeout = 3000,
		},
		quickfile = { enabled = true }, -- Fast file opening
		statuscolumn = { enabled = true }, -- Better statuscolumn
		words = { enabled = true }, -- Highlight word under cursor
		styles = {
			notification = {
				wo = { wrap = true },
			},
		},
	},
	keys = {
		{
			"<leader>un",
			function()
				require("snacks").notifier.hide()
			end,
			desc = "Dismiss all notifications",
		},
		{
			"<leader>sn",
			function()
				require("snacks").notifier.show_history()
			end,
			desc = "Show notification history",
		},
	},
}
