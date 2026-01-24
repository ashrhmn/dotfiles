local M = {}

-- Background state management
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

M.toggleBackground = function()
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

-- Theme state management
local theme_state_file = vim.fn.stdpath("data") .. "/theme_state"

local saveThemeState = function(theme)
  local file = io.open(theme_state_file, "w")
  if file then
    file:write(theme)
    file:close()
  end
end

local loadThemeState = function()
  local file = io.open(theme_state_file, "r")
  if file then
    local theme = file:read("*a")
    file:close()
    if theme and theme ~= "" then
      return theme
    end
  end
  return "everforest" -- default theme
end

local switchTheme = function(theme)
  local success, err = pcall(function()
    vim.cmd.colorscheme(theme)
    saveThemeState(theme)
    vim.notify("Theme: " .. theme, vim.log.levels.INFO)
  end)
  if not success then
    vim.notify("Failed to load theme: " .. theme .. "\n" .. err, vim.log.levels.ERROR)
  end
end

-- Telescope theme picker with live preview
M.themePickerWithPreview = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- List of available themes
  local themes = {
    "everforest",
    "catppuccin",
    "gruvbox",
    "kanagawa",
    "tokyonight",
    "rose-pine",
    "nord",
    "onedark",
    "nightfox",
    "monokai-pro",
    "dracula",
    "solarized-osaka",
    "cyberdream",
    "oxocarbon",
    "ayu",
    "material",
    "sonokai",
    "edge",
    "melange",
    "github_dark",
    "github_dark_dimmed",
    "github_dark_high_contrast",
    "github_light",
    "moonfly",
    "night-owl",
    "bamboo",
    "flow",
    "palenight",
    "horizon",
    "nightfly",
    "modus",
  }

  -- Store the current theme to restore on cancel
  local current_theme = vim.g.colors_name or loadThemeState()

  pickers
    .new({}, {
      prompt_title = "Color Schemes",
      finder = finders.new_table({
        results = themes,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        -- Apply theme on confirm
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            switchTheme(selection[1])
          end
        end)

        -- Restore original theme on cancel
        map("i", "<esc>", function()
          pcall(vim.cmd.colorscheme, current_theme)
          actions.close(prompt_bufnr)
        end)

        map("n", "<esc>", function()
          pcall(vim.cmd.colorscheme, current_theme)
          actions.close(prompt_bufnr)
        end)

        map("n", "q", function()
          pcall(vim.cmd.colorscheme, current_theme)
          actions.close(prompt_bufnr)
        end)

        -- Override move_selection to preview themes
        local function preview_theme()
          local selection = action_state.get_selected_entry()
          if selection then
            pcall(vim.cmd.colorscheme, selection[1])
          end
        end

        map("i", "<C-n>", function()
          actions.move_selection_next(prompt_bufnr)
          preview_theme()
        end)

        map("i", "<C-p>", function()
          actions.move_selection_previous(prompt_bufnr)
          preview_theme()
        end)

        map("i", "<Down>", function()
          actions.move_selection_next(prompt_bufnr)
          preview_theme()
        end)

        map("i", "<Up>", function()
          actions.move_selection_previous(prompt_bufnr)
          preview_theme()
        end)

        map("n", "j", function()
          actions.move_selection_next(prompt_bufnr)
          preview_theme()
        end)

        map("n", "k", function()
          actions.move_selection_previous(prompt_bufnr)
          preview_theme()
        end)

        map("n", "<Down>", function()
          actions.move_selection_next(prompt_bufnr)
          preview_theme()
        end)

        map("n", "<Up>", function()
          actions.move_selection_previous(prompt_bufnr)
          preview_theme()
        end)

        -- Preview the initially selected theme
        vim.defer_fn(preview_theme, 0)

        return true
      end,
    })
    :find()
end

-- Initialize on module load
local function init()
  -- Load saved theme state with delay to ensure plugins are loaded
  local saved_theme = loadThemeState()
  vim.defer_fn(function()
    switchTheme(saved_theme)
    -- Apply background after theme loads to prevent theme from overriding it
    vim.defer_fn(function()
      loadBackgroundState()
    end, 50)
  end, 100)
end

-- Auto-initialize
init()

return M
