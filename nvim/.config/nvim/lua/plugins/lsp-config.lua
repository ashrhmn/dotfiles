return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = true },
  },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua", opts = {} }, -- Replaced neodev with lazydev
    "b0o/schemastore.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    -- LSP Keybindings on attach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Navigation
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { buffer = ev.buf, desc = "Show LSP references" })
        keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = ev.buf, desc = "Show LSP definitions" })
        keymap.set(
          "n",
          "gi",
          "<cmd>Telescope lsp_implementations<CR>",
          { buffer = ev.buf, desc = "Show LSP implementations" }
        )
        keymap.set(
          "n",
          "gt",
          "<cmd>Telescope lsp_type_definitions<CR>",
          { buffer = ev.buf, desc = "Show LSP type definitions" }
        )

        -- Actions
        keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          { buffer = ev.buf, desc = "See available code actions" }
        )
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Smart rename" })

        -- Diagnostics
        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          { buffer = ev.buf, desc = "Show buffer diagnostics" }
        )
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show line diagnostics" })
        keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "Go to previous diagnostic" })
        keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Go to next diagnostic" })

        -- Documentation
        keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show hover documentation" })

        -- Restart LSP
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", { buffer = ev.buf, desc = "Restart LSP" })
      end,
    })

    -- Capabilities for autocompletion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())

    -- Diagnostic symbols in the sign column with high priority
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "", priority = 10 })
    end

    -- Note: LSP server configurations are handled in mason.lua
  end,
}
