return {
	"mason-org/mason-lspconfig.nvim",
	-- event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"mason-org/mason.nvim",
		"j-hui/fidget.nvim",
	},
	config = function()
		local servers = {
			gopls = {},
			html = { filetypes = { "html", "twig", "hbs" } },
			-- conform was fighting with ts_ls
			ts_ls = {
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				root_dir = require("lspconfig.util").root_pattern(".git"),
			},
			["eslint-lsp"] = {},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
		}

		-- local ensure_installed = vim.tbl_keys(servers or {})
		-- -- non-lsp installs for mason
		-- vim.list_extend(ensure_installed, {
		-- 	"stylua",
		-- 	"gofumpt",
		-- 	"prettierd",
		-- 	"eslint_d",
		-- })

		require("fidget").setup()

		require("mason").setup()

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local config = servers[server_name] or {}
					config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
					if server_name == "ts_ls" then
						config.root_dir = require("lspconfig.util").root_pattern(".git")
					end
					require("lspconfig")[server_name].setup(config)
				end,
			},
		})
	end,
}
