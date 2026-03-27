return {
	"ggandor/leap.nvim",
	lazy = true,
	event = "BufReadPre",
	config = function()
		require("leap").set_default_keymaps()
	end,
}
