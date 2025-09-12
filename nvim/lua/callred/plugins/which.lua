return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		disable = {
			gx = {},
		},
		filter = function(mapping)
			if mapping.lhs == "gx" then
				return false
			end
			return true
		end,
		--
	},
}
