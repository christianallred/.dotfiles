return {
	"laytan/cloak.nvim",
	config = function()
		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			try_all_patterns = true,
			patterns = {
				{
					file_pattern = ".env*",
					cloak_pattern = "=.+",
				},
				{
					file_pattern = "*-conf.yaml",
					cloak_pattern = ":.+",
				},
			},
		})
	end,
}
