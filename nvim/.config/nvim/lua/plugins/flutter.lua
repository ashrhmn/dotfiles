return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      require("flutter-tools").setup({
        debugger = {
          enabled = false,
        },
        widget_guides = {
          enabled = false,
        },
        closing_tags = {
          enabled = false,
        },
        dev_log = {
          enabled = false,
          notify_errors = false,
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          auto_open = false,
        },
        lsp = {
          capabilities = capabilities,
          settings = {
            completeFunctionCalls = true,
            renameFilesWithClasses = "always",
            updateImportsOnRename = true,
            showTodos = true,
          },
        },
      })
    end,
  },
}
