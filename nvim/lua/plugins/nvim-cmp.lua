return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/vim-vsnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "copilot" },
				{ name = "vsnip" },
			}, {
				{ name = "path" },
				{ name = "buffer" },
			}),
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			window = {
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				fields = { "menu", "abbr", "kind" },

				format = function(entry, vim_item)
					vim_item.menu = ({
						copilot = "[copilot]",
						nvim_lsp = "[lsp]",
						path = "[path]",
						buffer = "[buff]",
						vsnip = "[vsnip]",
					})[entry.source.name]
					return vim_item
				end,
			},
		})
	end,
}
