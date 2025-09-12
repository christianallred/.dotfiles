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
