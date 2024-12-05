vim.g.mapleader = " "

-- Visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })

-- x mode
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over visual selection" })
vim.keymap.set("x", "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set("x", "<leader>d", [["_d]], { desc = "Delete to void register" })

-- Normal mode
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines but remain focus" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "When searching down center screen" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "When searching up center screen" })

-- TOOD: what is this all about?
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location" })

-- Good remaps from chad
-- Navigation in insert mode
vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "End of line" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

vim.keymap.set("n", "<Esc>", "<cmd> noh <CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", { desc = "Save file" })

-- TODO: Dont know that i really care about this
-- can use control + w instead
vim.keymap.set("n", "<leader>sh", "<C-w>v", { desc = "[s]plit window [v]ertically" })
vim.keymap.set("n", "<leader>sv", "<C-w>s", { desc = "[s]plit window [h]orizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "[s]plits [e]qual size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "[s]plit close" })

-- Buffer clenaup stuff
vim.keymap.set("n", "<leader>ba", "<cmd>%bd|e#<CR>", { desc = "call [b]uffers [a] but current" })
vim.keymap.set("n", "<leader>bA", "<cmd>%bd<CR>", { desc = "call [b]uffers [A]" })
