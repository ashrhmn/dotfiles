local plugin_utils = require("plugins")

return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	enabled = plugin_utils.should_load_plugin("substitute.lua"),
	config = function()
		local substitute = require("substitute")

		substitute.setup()

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
		keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
		keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
		keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
	end,
}
