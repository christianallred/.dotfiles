local opt = vim.opt

-- nunber lines
opt.number = true
opt.relativenumber = true

-- tab stuff
opt.tabstop = 2      -- 2 spaces for tabs
opt.softtabstop = 2  --  not sure what this one does
opt.shiftwidth = 2   -- 2 spaces for indent witdth
opt.expandtab = true -- expand tabs to spaces

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
opt.undofile = true

opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
-- opt.isfname:append("@-@")

opt.updatetime = 50
opt.colorcolumn = "120"
opt.exrc = true

-- Turn of netrw default vim file explorere
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
