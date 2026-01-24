return {
  "scottmckendry/cyberdream.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = false,
      italic_comments = true,
      hide_fillchars = false,
      borderless_telescope = true,
      terminal_colors = true,
    })
  end,
}
