-- Snacks.picker replaces telescope
return {
	{
		"folke/snacks.nvim",
		keys = {
			{ "<leader><leader>", function() Snacks.picker.files() end, desc = "Find Files" },
			{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Find Recent Files" },
			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Find Files with Live Grep" },
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
			{ "<leader>fh", function() Snacks.picker.help() end, desc = "Find Help Tags" },
			{ "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find todos" },
		},
	},
}
