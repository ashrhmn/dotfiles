local plugin_utils = require("plugins")

return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	enabled = plugin_utils.should_load_plugin("surround.lua"),
	config = true,
}
