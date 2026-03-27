return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon.setup()

		local keymap = vim.keymap
		keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add" })

		keymap.set("n", "<leader>ho", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Menu" })

		-- TODO: find a better maps for this
		keymap.set("n", "<C-j>", function()
			harpoon:list():select(1)
		end)
		keymap.set("n", "<C-k>", function()
			harpoon:list():select(2)
		end)
		keymap.set("n", "<C-l>", function()
			harpoon:list():select(3)
		end)
	end,
}
