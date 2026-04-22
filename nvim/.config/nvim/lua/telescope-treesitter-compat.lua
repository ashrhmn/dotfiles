local M = {}

function M.apply()
	local ok_utils, utils = pcall(require, "telescope.previewers.utils")
	if not ok_utils then
		return
	end

	local ok_parsers, ts_parsers = pcall(require, "nvim-treesitter.parsers")
	local ok_configs, ts_configs = pcall(require, "nvim-treesitter.configs")

	utils.ts_highlighter = function(bufnr, ft)
		if not ft or ft == "" then
			return false
		end

		local lang
		if ok_parsers and type(ts_parsers.ft_to_lang) == "function" then
			lang = ts_parsers.ft_to_lang(ft)
		end
		if not lang and vim.treesitter.language and type(vim.treesitter.language.get_lang) == "function" then
			lang = vim.treesitter.language.get_lang(ft)
		end
		lang = lang or ft

		if ok_configs and type(ts_configs.is_enabled) == "function" then
			if not ts_configs.is_enabled("highlight", lang, bufnr) then
				return false
			end

			local parser_ok, parser = pcall(ts_parsers.get_parser, bufnr, lang)
			if not parser_ok then
				return false
			end

			local highlighter_ok = pcall(vim.treesitter.highlighter.new, parser)
			if not highlighter_ok then
				return false
			end

			local config = ts_configs.get_module and ts_configs.get_module("highlight") or {}
			local add_regex = config.additional_vim_regex_highlighting
			local is_table = type(add_regex) == "table"
			if add_regex and (not is_table or vim.tbl_contains(add_regex, lang)) then
				pcall(vim.api.nvim_buf_set_option, bufnr, "syntax", ft)
			end

			return true
		end

		return pcall(vim.treesitter.start, bufnr, lang)
	end
end

return M
