return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    local lspconfig = require("lspconfig")
    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls",
        -- "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        -- "svelte",
        "lua_ls",
        -- "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "jsonls",
        "yamlls",
        "solidity_ls_nomicfoundation",
        "gopls",
        "templ",
        "rust_analyzer",
        -- "csharp_ls",
        -- "omnisharp",
        -- "htmx",
      },
    })

    local function organize_ts_imports()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "Organize Imports",
      })
    end

    local function organize_go_imports()
      -- vim.lsp.buf.execute_command({
      --   command = "_gopls.organizeImports",
      --   arguments = { vim.api.nvim_buf_get_name(0) },
      --   title = "Organize Imports",
      -- })
      vim.lsp.buf.format()
      vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
      vim.lsp.buf.code_action({ context = { only = { "source.fixAll" } }, apply = true })
    end

    local cmp_nvim_lsp = require("cmp_nvim_lsp") -- import cmp-nvim-lsp plugin
    local capabilities = cmp_nvim_lsp.default_capabilities() -- used to enable autocompletion (assign to every lsp server config)

    vim.keymap.set("n", "<leader>ta", ":LspTypescriptSourceAction<CR>", { desc = "LspTypescriptSourceAction" })

    mason_tool_installer.setup({
      ensure_installed = {
        -- "prettier", -- prettier formatter
        "stylua", -- lua formatter
        -- "isort", -- python formatter
        -- "black", -- python formatter
        -- "pylint",
        -- "eslint_d",
        "biome",
      },
      handlers = { -- default handler for installed servers
        function(server_name)
          -- if server_name == "tsserver" then
          --   server_name = "ts_ls"
          -- end
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["gopls"] = function()
          -- configure graphql language server
          lspconfig["gopls"].setup({
            capabilities = capabilities,
            commands = {
              OrganizeImports = {
                organize_go_imports,
                description = "Organize Imports",
              },
            },
          })
        end,

        ["ts_ls"] = function()
          lspconfig["ts_ls"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              vim.lsp.inlay_hint.enable(true)
            end,
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
        end,

        -- ["tsserver"] = function()
        --   lspconfig["tsserver"].setup({
        --     capabilities = capabilities,
        --     on_attach = function(client, bufnr)
        --       vim.lsp.inlay_hint.enable(true)
        --     end,
        --     init_options = {
        --       hostInfo = "neovim",
        --       preferences = {
        --         importModuleSpecifierPreference = "non-relative",
        --         includeInlayParameterNameHints = "all",
        --         includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        --         includeInlayFunctionParameterTypeHints = false,
        --         includeInlayVariableTypeHints = false,
        --         includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        --         includeInlayPropertyDeclarationTypeHints = false,
        --         includeInlayFunctionLikeReturnTypeHints = false,
        --         includeInlayEnumMemberValueHints = false,
        --       },
        --     },
        --     commands = {
        --       OrganizeImports = {
        --         organize_ts_imports,
        --         description = "Organize Imports",
        --       },
        --     },
        --   })
        -- end,

        ["svelte"] = function()
          -- configure svelte server
          lspconfig["svelte"].setup({
            capabilities = capabilities,
            on_attach = function(client)
              vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.js", "*.ts" },
                callback = function(ctx)
                  -- Here use ctx.match instead of ctx.file
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                end,
              })
            end,
          })
        end,
        ["graphql"] = function()
          -- configure graphql language server
          lspconfig["graphql"].setup({
            capabilities = capabilities,
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
          })
        end,
        ["emmet_ls"] = function()
          -- configure emmet language server
          lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
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
        end,
        ["lua_ls"] = function()
          -- configure lua server (with special settings)
          lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                -- make the language server recognize "vim" global
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        end,
        ["yamlls"] = function()
          lspconfig["yamlls"].setup({
            capabilities = capabilities,
            settings = {
              yaml = {
                schemaStore = {
                  -- You must disable built-in schemaStore support if you want to use
                  -- this plugin and its advanced options like `ignore`.
                  enable = false,
                  -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                  url = "",
                },
                schemas = require("schemastore").yaml.schemas(),
              },
            },
          })
        end,
        ["jsonls"] = function()
          lspconfig["jsonls"].setup({
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,
        ["tailwindcss"] = function()
          lspconfig["tailwindcss"].setup({
            capabilities = capabilities,
            filetypes = { "templ", "astro", "javascript", "typescript", "react", "svelte", "vue", "html" },
            settings = {
              tailwindCSS = {
                includeLanguages = {
                  templ = "html",
                },
              },
            },
          })
        end,
        -- ["omnisharp"] = function()
        --   lspconfig["omnisharp"].setup({
        --     capabilities = capabilities,
        --     cmd = {
        --       "dotnet",
        --       "/opt/homebrew/Cellar/omnisharp/1.35.3/bin/omnisharp/OmniSharp.LanguageServerProtocol.dll",
        --     },
        --     filetypes = { "csharp" },
        --   })
        -- end,
      },
    })
  end,
}
