vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save File" })

-- increment/decrement numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement


-- keymap.set("t", "<leader><ESC>", "<C-\\><C-n>", { noremap = true })
keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
