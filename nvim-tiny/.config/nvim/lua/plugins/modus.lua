return {
  "miikanissi/modus-themes.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("modus-themes").setup({
      style = "auto",
      variant = "default",
      transparent = false,
      dim_inactive = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    })
  end,
}
