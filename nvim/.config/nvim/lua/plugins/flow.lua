return {
  "0xstepit/flow.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("flow").setup({
      transparent = false,
      fluo_color = "pink",
      mode = "normal",
      aggressive_spell = false,
    })
  end,
}
