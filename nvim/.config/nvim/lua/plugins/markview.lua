return {
  "OXY2DEV/markview.nvim",
  ft = { "markdown", "md", "rmd", "quarto" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>mv", "<cmd>Markview Toggle<cr>", desc = "Toggle Markview preview" },
    { "<leader>ms", "<cmd>Markview splitToggle<cr>", desc = "Toggle Markview split preview" },
  },
  config = function()
    local presets = require("markview.presets")

    -- Setup markview with configuration
    require("markview").setup({
      experimental = {
        check_rtp = false,
        check_rtp_message = false,
      },
      preview = {
        enable = true,
        filetypes = { "md", "rmd", "quarto", "markdown" },
        modes = { "n", "no", "c" },
        -- hybrid_modes = { "n" },
        debounce = 50,
      },
      markdown = {
        headings = presets.headings.slanted,
        horizontal_rules = presets.horizontal_rules.thin,
        tables = presets.tables.rounded,
      },
    })

    -- Setup extras
    require("markview.extras.checkboxes").setup()
    require("markview.extras.headings").setup()
    require("markview.extras.editor").setup()

    -- Additional keybindings for extras
    vim.keymap.set(
      { "n", "v" },
      "<leader>mc",
      "<cmd>Checkbox toggle<cr>",
      { noremap = true, silent = true, desc = "Toggle checkbox state" }
    )
  end,
}
