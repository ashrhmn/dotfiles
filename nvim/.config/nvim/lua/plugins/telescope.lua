-- Snacks.picker replaces telescope
local config_root = vim.fn.stdpath("config")

local function picker_sources(source)
	return {
		{
			source = source,
		},
		{
			source = source,
			dirs = { config_root },
			hidden = true,
		},
		{
			source = source,
			cmd = source == "files" and "fd" or nil,
			hidden = true,
			ignored = true,
			args = source == "files" and { "-g", ".env*" } or nil,
			glob = source == "grep" and ".env*" or nil,
		},
	}
end

return {
	{
		"folke/snacks.nvim",
		keys = {
			{
				"<leader><leader>",
				function()
					Snacks.picker({
						source = "files",
						multi = picker_sources("files"),
					})
				end,
				desc = "Find Files",
			},
				{
					"<leader>fr",
					function()
						Snacks.picker.recent()
					end,
					desc = "Find Recent Files",
				},
			{
				"<leader>fg",
				function()
					Snacks.picker({
						source = "grep",
						multi = picker_sources("grep"),
					})
				end,
				desc = "Find Files with Live Grep",
			},
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Buffers" },
			{ "<leader>fh", function() Snacks.picker.help() end, desc = "Find Help Tags" },
			{ "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find todos" },
		},
	},
}
