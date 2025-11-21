return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  priority = 1000,
  config = function()
    -- Get flavour from environment variable, default to mocha if not set or invalid
    local flavour = os.getenv("CATPPUCCIN_FLAVOUR") or "mocha"
    local valid_flavours = { "latte", "frappe", "macchiato", "mocha" }
    local is_valid = false

    for _, valid in ipairs(valid_flavours) do
      if flavour == valid then
        is_valid = true
        break
      end
    end

    if not is_valid then
      flavour = "mocha" -- fallback to mocha
    end

    require("catppuccin").setup({
      flavour = flavour, -- latte, frappe, macchiato, mocha
      -- background = { -- :h background
      --   light = "latte",
      --   dark = "mocha",
      -- },
      -- transparent_background = true, -- disables setting the background color.
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    })
  end,
}
