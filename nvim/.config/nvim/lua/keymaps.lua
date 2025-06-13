vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- Navigate vim panes better
keymap.set("n", "<c-k>", ":wincmd k<CR>")
keymap.set("n", "<c-j>", ":wincmd j<CR>")
keymap.set("n", "<c-h>", ":wincmd h<CR>")
keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- local formatAndSave = function()
--   vim.lsp.buf.format()
--   vim.cmd("w")
-- end

local toggleInlayHints = function()
  local isEnabled = vim.lsp.inlay_hint.is_enabled()

  if isEnabled then
    vim.lsp.inlay_hint.enable(false)
  else
    vim.lsp.inlay_hint.enable(true)
  end
end

keymap.set("n", "<leader>hi", toggleInlayHints, { desc = "Toggle inlay hints" })

--keymap.set('n', '<C-q>', ':qa<CR>',{desc='Quit All'})
keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save File" })
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save File" })
-- keymap.set("n", "<C-s>", formatAndSave, { desc = "Format and Save File" })
-- keymap.set("n", "<leader>w", formatAndSave, { desc = "Format and Save File" })
keymap.set("n", "<C-q>", ":qa<CR>", { desc = "Close Current Buffer" })
keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Close Current Buffer" })
keymap.set("n","<leader>rl",":e %<CR>", { desc = "Reload Current Buffer" }) -- reload current buffer

-- keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>=", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- keymap.set("t", "<leader><ESC>", "<C-\\><C-n>", { noremap = true })
keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })
