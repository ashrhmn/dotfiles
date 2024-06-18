return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			local keymap = vim.keymap
			keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
			keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find Recent Files" })
			keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Files with Live Grep" })
			keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
			keymap.set("n", "<leader>fh", builtin.help_tags, {})
			keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

			require("telescope").setup({
				pickers = {
					find_files = {
						find_command = {
							"rg",
							"-uu",
							"--files",
							"--hidden",
							"-g",
							"!.git/",
							"-g",
							"!node_modules",
							"-g",
							"!tmp/",
							"-g",
							"!build/",
							"-g",
							"!dist/",
							"-g",
							"!out/",
							"-g",
							"!.next/",
							"-g",
							"!.DS_Store",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
