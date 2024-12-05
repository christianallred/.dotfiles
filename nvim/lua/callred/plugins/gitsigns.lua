local function on_attach(bufnr)
	local gs = package.loaded.gitsigns

	local function remap(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	remap("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, desc = "GSigns: next hunk" })

	remap("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, desc = "GSigns: prev hunk" })

	-- Actions
	remap("n", "<leader>gS", gs.stage_hunk, { desc = "GSigns: stage hunk" })
	remap("n", "<leader>gu", gs.undo_stage_hunk, { desc = "GSigns: undo stage buffer" })

	remap("n", "<leader>gp", gs.prev_hunk, { desc = "GSigns: previous hunk" })
	remap("n", "<leader>gn", gs.next_hunk, { desc = "GSigns: next hunk" })

	remap("n", "<leader>gr", gs.reset_hunk, { desc = "GSigns: reset hunk" })
	remap("n", "<leader>gR", gs.reset_buffer, { desc = "GSigns: reset buffer" })

	remap("n", "<leader>gd", gs.diffthis, { desc = "GSigns: diff this" })

	remap("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "GSigns: toggle current blame line" })
	remap("n", "<leader>td", gs.toggle_deleted, { desc = "GSigns: toggle deleted" })
end

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			on_attach = on_attach,
		})
	end,
}
