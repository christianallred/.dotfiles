-- TODO: what does thi add that isn't in the mason config?

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP auto complete
		"hrsh7th/cmp-vsnip", -- TODO: learn more about this stuff
		"hrsh7th/vim-vsnip",

		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		-- "hrsh7th/cmp-cmdline", -- source for command line args
	},

	config = function()
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},

			sources = cmp.config.sources(
				-- Group index 1
				{
					{ name = "nvim_lsp" },
					{ name = "copilot" },
					{ name = "vsnip" },
				},
				-- Group Index 2
				{
					{ name = "path" },
					{ name = "buffer" },
					-- { name = "cmdline" },
				}
			),

			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			window = {
				-- completion = cmp.config.window.bordered(),
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
						-- cmdline = "[cmd]",
					})[entry.source.name]
					return vim_item
				end,
			},
		})
	end,
}
