return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter").setup({
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "dockerfile",
        "gitignore",
        "sql",
        -- "latex",
        -- "typst",
      },
    })

    require("nvim-ts-autotag").setup()
  end,
}
