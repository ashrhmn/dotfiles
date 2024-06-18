if true then
  return {}
end
return {
  --{
  --  "nvimtools/none-ls.nvim",
  --  config = function()
  --    local null_ls = require("null-ls")
  --    null_ls.setup({
  --      sources = {
  --        null_ls.builtins.formatting.stylua
  --      }
  --    })
  --  end
  --},
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          require("none-ls.formatting.jq"),
          require("none-ls.code_actions.eslint"),
          require("none-ls.diagnostics.eslint"),
          --require("none-ls.formatting.eslint"),
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
}
