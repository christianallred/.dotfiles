-- this is just a bunch of vim options for the most part
local opt = vim.opt

-- nunber lines
opt.number = true -- show line numbers
opt.relativenumber = true -- line nubmeres relative to cursor

-- tab stuff
opt.tabstop = 2 -- 2 spaces for tabs
opt.softtabstop = 2
opt.shiftwidth = 2 -- 2 spaces for indent witdth
opt.expandtab = true -- expand tabs to spaces

opt.smartindent = true -- indent properly when moving lines around

opt.wrap = true -- dont wrap lines

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.nvim/undodir" -- this was for undotree that i dont use anymore
opt.undofile = true

opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8 -- this make it so that cursor never gets to the bottom or top of the screen
opt.signcolumn = "yes"
-- opt.isfname:append("@-@")

-- completion (native vim.lsp.completion, see lua/lsp.lua)
-- menuone: show menu even for a single match
-- noselect: don't preselect/insert anything until I pick it with <C-n>/<C-p>
-- popup:   show docs in a floating window instead of a preview split
-- fuzzy:   fuzzy matching in the menu
opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
opt.shortmess:append("c") -- don't spam "match 1 of 40" in the cmdline

opt.updatetime = 50
opt.colorcolumn = "120" -- adds a colored bar at 120 charts
opt.exrc = true

-- Turn of netrw default vim file explorer
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
