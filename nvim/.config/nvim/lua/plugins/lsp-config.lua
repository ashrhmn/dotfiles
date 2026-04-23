return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
    "b0o/schemastore.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )

    local function organize_ts_imports()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "Organize Imports",
      })
    end

    local function organize_go_imports()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
      vim.lsp.buf.code_action({
        context = { only = { "source.fixAll" } },
        apply = true,
      })
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
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
        keymap.set(
          { "n", "v" },
          "<leader>ca",
          vim.lsp.buf.code_action,
          { buffer = ev.buf, desc = "See available code actions" }
        )
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Smart rename" })
        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          { buffer = ev.buf, desc = "Show buffer diagnostics" }
        )
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show line diagnostics" })
        keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "Go to previous diagnostic" })
        keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Go to next diagnostic" })
        keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show hover documentation" })
        keymap.set("n", "<leader>rs", "<cmd>lsp restart<CR>", { buffer = ev.buf, desc = "Restart LSP" })
      end,
    })

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "", priority = 10 })
    end

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("ts_ls", {
      init_options = {
        hostInfo = "neovim",
        preferences = {
          importModuleSpecifierPreference = "non-relative",
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
        },
      },
      commands = {
        OrganizeImports = {
          organize_ts_imports,
          description = "Organize Imports",
        },
      },
    })

    vim.lsp.config("gopls", {
      commands = {
        OrganizeImports = {
          organize_go_imports,
          description = "Organize Imports",
        },
      },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
      },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    })

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config("tailwindcss", {
      filetypes = { "templ", "astro", "javascript", "typescript", "react", "svelte", "vue", "html" },
      settings = {
        tailwindCSS = {
          includeLanguages = {
            templ = "html",
          },
        },
      },
    })

    vim.lsp.enable({
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "lua_ls",
      "emmet_ls",
      "prismals",
      "pyright",
      "jsonls",
      "yamlls",
      "solidity_ls_nomicfoundation",
      "gopls",
      "templ",
      "rust_analyzer",
    })
  end,
}
