return {
  "oxfist/night-owl.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("night-owl").setup({
      bold = true,
      italics = true,
      underline = true,
      undercurl = true,
      transparent_background = false,
    })
  end,
}
