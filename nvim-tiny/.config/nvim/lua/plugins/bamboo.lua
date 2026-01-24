return {
  "ribru17/bamboo.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("bamboo").setup({
      style = "vulgaris",
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      code_style = {
        comments = { italic = true },
        conditionals = { italic = true },
        keywords = {},
        functions = {},
        strings = {},
        variables = {},
      },
      lualine = {
        transparent = false,
      },
      colors = {},
      highlights = {},
    })
  end,
}
