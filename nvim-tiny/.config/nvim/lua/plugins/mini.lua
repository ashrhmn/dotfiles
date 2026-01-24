return {
	-- Mini.ai: Extended text objects (better than default)
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				-- Disable treesitter-based text objects to avoid query errors
				-- You can still use the default text objects that come with mini.ai
				custom_textobjects = {
					-- Simple pattern-based text objects (always work)
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- HTML/XML tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					g = function() -- Whole buffer
						local from = { line = 1, col = 1 }
						local to = {
							line = vim.fn.line("$"),
							col = math.max(vim.fn.getline("$"):len(), 1),
						}
						return { from = from, to = to }
					end,
					u = ai.gen_spec.function_call(), -- u for "Usage" (function calls)
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
		end,
	},

	-- Mini.move: Move lines and selections easily
	{
		"echasnovski/mini.move",
		event = "VeryLazy",
		opts = {
			-- Move visual selection in Visual mode
			mappings = {
				left = "<M-h>",
				right = "<M-l>",
				down = "<M-j>",
				up = "<M-k>",

				-- Move current line in Normal mode
				line_left = "<M-h>",
				line_right = "<M-l>",
				line_down = "<M-j>",
				line_up = "<M-k>",
			},
		},
	},

	-- Mini.indentscope: Animated indent scope
	{
		"echasnovski/mini.indentscope",
		event = "VeryLazy",
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	-- Mini.splitjoin: Split/join arguments, arrays, etc.
	{
		"echasnovski/mini.splitjoin",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"gS",
				"<cmd>lua require('mini.splitjoin').toggle()<cr>",
				desc = "Toggle split/join",
			},
		},
	},
}
