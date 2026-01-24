return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = true,
  priority = 1000,
  config = function()
    vim.g.moonflyItalics = true
    vim.g.moonflyTransparent = false
    vim.g.moonflyNormalFloat = true
  end,
}
