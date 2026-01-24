return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- Global variable to control format on save
    vim.g.format_on_save = false -- Disabled by default, toggle with <leader>tf

    conform.setup({
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        svelte = { "biome" },
        css = { "biome" },
        svg = { "biome" },
        html = { "biome" },
        json = { "biome" },
        yaml = { "biome" },
        markdown = { "biome" },
        -- graphql = { "biome" },
        -- liquid = { "biome" },
        lua = { "stylua" },
        python = { "isort", "black" },
        templ = { "templ" },
        -- go = { "goformat" },
      },
      format_on_save = function(bufnr)
        -- Check global toggle
        if not vim.g.format_on_save then
          return
        end
        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end,
    })

    -- Manual format keymap
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Toggle format on save
    vim.keymap.set("n", "<leader>tf", function()
      vim.g.format_on_save = not vim.g.format_on_save
      vim.notify("Format on save: " .. tostring(vim.g.format_on_save), vim.log.levels.INFO)
    end, { desc = "Toggle format on save" })
  end,
}
