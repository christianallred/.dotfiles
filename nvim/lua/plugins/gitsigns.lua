local function on_attach(bufnr)
  local gs = package.loaded.gitsigns

  local function remap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  remap("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gs.nav_hunk("next")
    end
  end, { desc = "GSigns: next hunk" })

  remap("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gs.nav_hunk("prev")
    end
  end, { desc = "GSigns: prev hunk" })

  remap("n", "<leader>gS", gs.stage_hunk, { desc = "GSigns: stage/unstage hunk" })
  -- stage_hunk on an already staged hunk unstages it (replaces undo_stage_hunk)
  remap("n", "<leader>gu", gs.stage_hunk, { desc = "GSigns: unstage hunk" })

  remap("n", "<leader>gp", function()
    gs.nav_hunk("prev")
  end, { desc = "GSigns: previous hunk" })
  remap("n", "<leader>gn", function()
    gs.nav_hunk("next")
  end, { desc = "GSigns: next hunk" })

  remap("n", "<leader>gr", gs.reset_hunk, { desc = "GSigns: reset hunk" })
  remap("n", "<leader>gR", gs.reset_buffer, { desc = "GSigns: reset buffer" })

  remap("n", "<leader>gd", gs.diffthis, { desc = "GSigns: diff this" })

  remap("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "GSigns: toggle current blame line" })
  remap("n", "<leader>td", gs.preview_hunk_inline, { desc = "GSigns: show deleted lines inline" })
end

return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      on_attach = on_attach,
    })
  end,
}
