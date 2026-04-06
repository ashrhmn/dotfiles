return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- import comment plugin safely
		local comment = require("Comment")
		local ts_context_commentstring = require("ts_context_commentstring")

		-- Only calculate commentstring when commenting.
		-- The plugin's CursorHold autocmd is both unnecessary with Comment.nvim
		-- integration and is the source of occasional nil parser errors on
		-- nonstandard buffers like neo-tree.
		ts_context_commentstring.setup({
			enable_autocmd = false,
		})

		local integration = require("ts_context_commentstring.integrations.comment_nvim")

		-- enable comment
		comment.setup({
			-- for commenting tsx, jsx, svelte, html files
			pre_hook = integration.create_pre_hook(),
		})
	end,
}
