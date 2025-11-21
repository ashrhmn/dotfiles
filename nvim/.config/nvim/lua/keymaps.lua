vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- Navigate vim panes better
keymap.set("n", "<c-k>", ":wincmd k<CR>", { desc = "Move to window above" })
keymap.set("n", "<c-j>", ":wincmd j<CR>", { desc = "Move to window below" })
keymap.set("n", "<c-h>", ":wincmd h<CR>", { desc = "Move to window left" })
keymap.set("n", "<c-l>", ":wincmd l<CR>", { desc = "Move to window right" })

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

local background_state_file = vim.fn.stdpath("data") .. "/background_state"

local saveBackgroundState = function(state)
  local file = io.open(background_state_file, "w")
  if file then
    file:write(state)
    file:close()
  end
end

local loadBackgroundState = function()
  local file = io.open(background_state_file, "r")
  if file then
    local state = file:read("*a")
    file:close()
    if state == "light" then
      vim.opt.background = "light"
    elseif state == "dark" then
      vim.opt.background = "dark"
    end
  end
end

local toggleBackground = function()
  ---@diagnostic disable-next-line: undefined-field
  local current = vim.opt.background:get()

  if current == "light" then
    vim.opt.background = "dark"
    saveBackgroundState("dark")
    vim.notify("Background: dark", vim.log.levels.INFO)
  else
    vim.opt.background = "light"
    saveBackgroundState("light")
    vim.notify("Background: light", vim.log.levels.INFO)
  end
end

-- Load saved background state on startup
loadBackgroundState()

keymap.set("n", "<leader>bg", toggleBackground, { desc = "Toggle background (light/dark)" })

--keymap.set('n', '<C-q>', ':qa<CR>',{desc='Quit All'})
keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
-- keymap.set("n", "<C-s>", formatAndSave, { desc = "Format and Save File" })
-- keymap.set("n", "<leader>w", formatAndSave, { desc = "Format and Save File" })
keymap.set("n", "<C-q>", ":qa<CR>", { desc = "Quit all buffers" })
keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Close current buffer" })
keymap.set("n", "<leader>rl", ":e %<CR>", { desc = "Reload current buffer" }) -- reload current buffer

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

-- terminal mode escape mapping
-- keymap.set("t", "<leader><ESC>", "<C-\\><C-n>", { noremap = true })
-- keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal mode" })
keymap.set("t", "<M-ESC>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal mode" })

-- Update clipboard
vim.api.nvim_create_user_command("SyncClipboard", function()
  -- Calculate 80% of editor dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  -- Create a temporary buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "Sync Clipboard (Cmd+V then Ctrl+s)",
  })
  -- Set buffer options
  vim.bo[buf].buftype = "nofile"
  vim.wo[win].wrap = false
  -- Enter insert mode
  vim.cmd("startinsert")
  -- Custom sync keymap for this buffer only
  vim.keymap.set("i", "<C-s>", function()
    -- Get the content from the buffer
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local content = table.concat(lines, "\n")
    -- Exit insert mode first
    vim.cmd("stopinsert")
    -- Close the window and buffer
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    -- Set clipboard register if we got content
    if content and content ~= "" then
      vim.fn.setreg("+", content)
      vim.fn.setreg("*", content)
      vim.notify("Clipboard synced: " .. string.len(content) .. " characters", vim.log.levels.INFO)
    else
      vim.notify("No content pasted", vim.log.levels.WARN)
    end
  end, { buffer = buf, desc = "Sync clipboard content" })
  -- Also allow normal ESC to just close without syncing
  vim.keymap.set("i", "<ESC>", function()
    vim.cmd("stopinsert")
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    vim.notify("Clipboard sync cancelled", vim.log.levels.INFO)
  end, { buffer = buf, desc = "Cancel clipboard sync" })
end, { desc = "Sync clipboard from macOS" })
-- Create a keymap
vim.keymap.set("n", "<leader>sc", ":SyncClipboard<CR>", { desc = "Sync clipboard from macOS" })
