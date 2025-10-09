return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/todo-comments.nvim",
	},
	update = ":TSUpdate",
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.setup({
			-- file_ignore_patterns = {
			-- 	"node_modules",
			-- 	".git/",
			-- },
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({ hidden = true, file_ignore_patterns = { ".git/" } })
		end, { desc = "[f]ind [f]iles" })
		vim.keymap.set("n", "<leader>fl", "<cmd>Telescope resume<CR>", { desc = "[f]ind [l]last find (resume)" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[f]ind [k]eymaps" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[f]ind [g]rep" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[f]ind [h]elp" })
		vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "[f]ind fu[z]zy buffer" })

		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[f]ind [o]ld files" })
		vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "[f]ind [s]tring under cursor" })

		vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "[f]ind [t]odos" })

		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Find [g]it [c]ommits" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Find [g]it [s]tatus" })
		vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Find [g]it-ignorred [f]iles" })

		vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[f]ind [m]arks" })
	end,
}
