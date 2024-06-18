return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"zbirenbaum/copilot.lua",
			"zbirenbaum/copilot-cmp",
			"hrsh7th/cmp-nvim-lua",
			"David-Kunz/cmp-npm",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("copilot").setup({
				suggestion = {
					enabled = true,
					max_length = 1000,
					debounce = 100,
				},
			})
			require("copilot_cmp").setup()

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				--				mapping = cmp.mapping.preset.insert({
				--					["<C-b>"] = cmp.mapping.scroll_docs(-4),
				--					["<C-f>"] = cmp.mapping.scroll_docs(4),
				--					["<C-Space>"] = cmp.mapping.complete(),
				--					["<C-e>"] = cmp.mapping.abort(),
				--					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				--				}),
				-- mapping = {
				--
				-- 	["<C-e>"] = cmp.mapping.abort(),
				-- 	["<C-Space>"] = cmp.mapping.complete(),
				-- 	-- ... Your other mappings ...
				-- 	["<CR>"] = cmp.mapping(function(fallback)
				-- 		if cmp.visible() then
				-- 			if luasnip.expandable() then
				-- 				luasnip.expand()
				-- 			else
				-- 				cmp.confirm({
				-- 					select = false,
				-- 				})
				-- 			end
				-- 		else
				-- 			fallback()
				-- 		end
				-- 	end),
				--
				-- 	["<Tab>"] = cmp.mapping(function(fallback)
				-- 		if cmp.visible() then
				-- 			cmp.select_next_item()
				-- 		elseif luasnip.locally_jumpable(1) then
				-- 			luasnip.jump(1)
				-- 		else
				-- 			fallback()
				-- 		end
				-- 	end, { "i", "s" }),
				--
				-- 	["<S-Tab>"] = cmp.mapping(function(fallback)
				-- 		if cmp.visible() then
				-- 			cmp.select_prev_item()
				-- 		elseif luasnip.locally_jumpable(-1) then
				-- 			luasnip.jump(-1)
				-- 		else
				-- 			fallback()
				-- 		end
				-- 	end, { "i", "s" }),
				--
				-- 	-- ... Your other mappings ...
				-- },
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "copilot" },
					{ name = "buffer" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "nvim_lua" },
					{ name = "npm" },
				}, {
					{ name = "buffer" },
				}),

				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})
		end,
	},
}
