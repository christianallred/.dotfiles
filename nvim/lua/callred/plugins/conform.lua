return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>F",
			function()
				vim.lsp.buf.format({ async = false })
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "eslint_d" },
				-- typescript = { "prettierd", "eslint_d" },
				typescript = { "prettierd" },
				-- typescriptreact = { "prettierd", "eslint_d" },
				typescriptreact = { "prettierd" },
				go = { "gofumpt" },
			},
			-- Conform will run multiple formatters sequentially
			-- You can customize some of the format options for the filetype (:help conform.format)
			-- Conform will run the first available formatter
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = {
				timeout_ms = 1000,
			},
		})
	end,
}
