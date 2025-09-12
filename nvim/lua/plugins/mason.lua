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

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("my-lsp-attach", { clear = true }),

			callback = function(event)
				-- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
				local map = function(mode, keys, func, desc)
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				local tele_builtin = require("telescope.builtin")

				map("n", "gd", tele_builtin.lsp_definitions, "[g]oto [d]efinition")
				map("n", "gr", function()
					tele_builtin.lsp_references({ show_line = false })
				end, "[g]oto [r]eferences")

				map("n", "gi", tele_builtin.lsp_implementations, "[g]oto [i]mplementation")
				map("n", "<leader>D", tele_builtin.lsp_type_definitions, "Type [D]efinition")
				map("n", "<leader>ds", tele_builtin.lsp_document_symbols, "[d]ocument [s]ymbols")
				map("n", "<leader>ws", tele_builtin.lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")
				map("n", "<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
				map("n", "<leader>lh", vim.lsp.buf.signature_help, "[l]sp [h]elp")
				map("n", "K", vim.lsp.buf.hover, "Hover Documentation")

				map("n", "gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")

				map("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP")

				-- this belongs somehwere else
				map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
				map("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic")
				map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
			end,
		})

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
