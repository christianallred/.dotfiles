vim.lsp.enable({
	"eslint",
	"gopls",
	"graphql",
	"jsonls",
	"lua_ls",
	"ts_ls",
})

vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = true,
	signs = {
		-- text = {
		-- 	[vim.diagnostic.severity.ERROR] = "",
		-- 	[vim.diagnostic.severity.WARN] = "",
		-- 	[vim.diagnostic.severity.HINT] = "",
		-- 	[vim.diagnostic.severity.INFO] = "",
		-- },
		-- numhl = {
		-- 	[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
		-- 	[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
		-- 	[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
		-- 	[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		-- },
	},
})
