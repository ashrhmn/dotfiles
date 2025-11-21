return {
  "sainnhe/edge",
  lazy = true,
  priority = 1000,
  config = function()
    vim.g.edge_style = "default"
    vim.g.edge_enable_italic = 1
    vim.g.edge_disable_italic_comment = 0
    vim.g.edge_transparent_background = 0
    vim.g.edge_better_performance = 1
  end,
}
