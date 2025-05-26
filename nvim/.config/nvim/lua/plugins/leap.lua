return {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = { "tpope/vim-repeat" },
  config = function()
    -- require("leap").add_default_mappings()
    -- require("leap").set_default_keymaps()
    vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap-forward)")
    vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>(leap-backward)")
    -- vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
  end,
}
