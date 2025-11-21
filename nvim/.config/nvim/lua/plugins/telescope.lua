return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local keymap = vim.keymap
			keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
			keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find Recent Files" })
			keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find Files with Live Grep" })
			keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
			keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" })
			keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--no-ignore-vcs",
						"--glob=!.git/",
						"--glob=!.ccd/",
						"--glob=!node_modules/",
						"--glob=!tmp/",
						"--glob=!build/",
						"--glob=!dist/",
						"--glob=!out/",
						"--glob=!.next/",
						"--glob=!.DS_Store",
					},
					-- Modern telescope improvements
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					sorting_strategy = "ascending",
					winblend = 0,
					border = true,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					path_display = { "truncate" },
					file_ignore_patterns = { "node_modules", ".git/" },
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						},
						n = {
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						},
					},
				},
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
							"!.ccd/",
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
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("fzf")
		end,
	},
}
