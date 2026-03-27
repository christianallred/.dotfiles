-- time to remove this?
return {
	"nvim-tree/nvim-tree.lua",
	enabled = true,
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local nvimtree = require("nvim-tree")
		nvimtree.setup({
			filters = {
				dotfiles = false,
				custom = {
					"^.git$",
				},
			},
			git = {
				ignore = false,
			},
			view = {
				width = 40,
			},
		})
		vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFile<CR>", { desc = "Find Files explorer" })
	end,
}
