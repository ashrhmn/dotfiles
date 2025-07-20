return {
  "numToStr/FTerm.nvim",
  config = function()
    local fterm = require("FTerm")

    fterm.setup({
      ---Filetype of the terminal buffer
      ---@type string
      ft = "FTerm",

      ---Command to run inside the terminal
      ---NOTE: if given string[], it will skip the shell and directly executes the command
      ---@type fun():(string|string[])|string|string[]|string?
      cmd = os.getenv("SHELL"),

      ---Neovim's native window border. See `:h nvim_open_win` for more configuration options.
      border = "single",

      ---Close the terminal as soon as shell/command exits.
      ---Disabling this will mimic the native terminal behaviour.
      ---@type boolean
      auto_close = true,

      ---Highlight group for the terminal. See `:h winhl`
      ---@type string
      hl = "Normal",

      ---Transparency of the floating window. See `:h winblend`
      ---@type integer
      blend = 0,

      ---Object containing the terminal window dimensions.
      ---The value for each field should be between `0` and `1`
      ---@type table<string,number>
      dimensions = {
        height = 0.95, -- Height of the terminal window
        width = 0.95, -- Width of the terminal window
        x = 0.5, -- X axis of the terminal window
        y = 0.5, -- Y axis of the terminal window
      },

      ---Replace instead of extend the current environment with `env`.
      ---See `:h jobstart-options`
      ---@type boolean
      clear_env = false,

      ---Map of environment variables extending the current environment.
      ---See `:h jobstart-options`
      ---@type table<string,string>|nil
      env = nil,

      ---Callback invoked when the terminal exits.
      ---See `:h jobstart-options`
      ---@type fun()|nil
      on_exit = nil,

      ---Callback invoked when the terminal emits stdout data.
      ---See `:h jobstart-options`
      ---@type fun()|nil
      on_stdout = nil,

      ---Callback invoked when the terminal emits stderr data.
      ---See `:h jobstart-options`
      ---@type fun()|nil
      on_stderr = nil,
    })

    vim.api.nvim_create_user_command("FTermOpen", fterm.open, { bang = true })
    vim.api.nvim_create_user_command("FTermClose", fterm.close, { bang = true })
    vim.api.nvim_create_user_command("FTermExit", fterm.exit, { bang = true })
    vim.api.nvim_create_user_command("FTermToggle", fterm.toggle, { bang = true })

    vim.keymap.set({ "n", "t" }, "<C-t>", fterm.toggle, { noremap = true, silent = true })
    -- vim.keymap.set("n", "<leader>tt", fterm.toggle, { noremap = true, silent = true })
    -- vim.keymap.set("t", "<leader>tt", fterm.toggle, { noremap = true, silent = true })

    vim.api.nvim_create_user_command("PBuild", function()
      ---@diagnostic disable-next-line missing-fields
      fterm.scratch({ cmd = { "pnpm", "build" } })
    end, { bang = true })

    vim.api.nvim_create_user_command("PInstall", function()
      ---@diagnostic disable-next-line missing-fields
      fterm.scratch({ cmd = { "pnpm", "i" } })
    end, { bang = true })

    ---@diagnostic disable-next-line missing-fields
    local btop = fterm:new({
      ft = "fterm_btop",
      cmd = "btop",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })

    vim.api.nvim_create_user_command("Btop", function()
      btop:toggle()
    end, { bang = true })

    ---@diagnostic disable-next-line missing-fields
    local ghBrowse = fterm:new({
      ft = "fterm_gbrowse",
      cmd = "gh browse",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })

    vim.api.nvim_create_user_command("Gbrowse", function()
      ghBrowse:toggle()
    end, { bang = true })

    ---@diagnostic disable-next-line missing-fields
    local pm2Monit = fterm:new({
      ft = "fterm_pm2Monit",
      cmd = "pm2 monit",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })
    local togglePm2Monit = function()
      pm2Monit:toggle()
    end
    vim.api.nvim_create_user_command("PmMonit", togglePm2Monit, { bang = true })
    -- vim.keymap.set({ "n", "t" }, "<C-m>", togglePm2Monit, { noremap = true, silent = true, desc = "PM Monit" })

    ---@diagnostic disable-next-line missing-fields
    local pm2Logs = fterm:new({
      ft = "fterm_pm2Logs",
      -- cmd = "pm2 logs",
      cmd = "pm2logs",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })
    local togglePm2Logs = function()
      pm2Logs:toggle()
    end
    vim.api.nvim_create_user_command("PmLogs", togglePm2Logs, { bang = true })
    vim.keymap.set({ "n", "t" }, "<C-p>", togglePm2Logs, { noremap = true, silent = true, desc = "PM Logs" })

    ---@diagnostic disable-next-line missing-fields
    local claudeTerm = fterm:new({
      ft = "fterm_claude",
      -- cmd = "claude --dangerously-skip-permissions",
      cmd = "ccd",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })
    local toggleClaude = function()
      claudeTerm:toggle()
    end
    vim.api.nvim_create_user_command("Claude", toggleClaude, { bang = true })
    vim.keymap.set({ "n", "t" }, "<C-g>", toggleClaude, { noremap = true, silent = true, desc = "Claude" })

    ---@diagnostic disable-next-line missing-fields
    local pmStartTerm = fterm:new({
      ft = "fterm_pmStart",
      cmd = "pm2 start ecosystem.config.cjs",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })

    local pmStart = function()
      pmStartTerm:toggle()
    end

    vim.api.nvim_create_user_command("PmStart", pmStart, { bang = true })

    ---@diagnostic disable-next-line missing-fields
    local pmStopTerm = fterm:new({
      ft = "fterm_pmStop",
      cmd = "pm2 delete ecosystem.config.cjs",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })

    local pmStop = function()
      pmStopTerm:toggle()
    end

    vim.api.nvim_create_user_command("PmStop", pmStop, { bang = true })

    ---@diagnostic disable-next-line missing-fields
    local pmRestartTerm = fterm:new({
      ft = "fterm_pmRestart",
      cmd = "pm2 restart ecosystem.config.cjs",
      ---@diagnostic disable-next-line missing-fields
      dimensions = {
        height = 0.95,
        width = 0.95,
      },
    })

    local pmRestart = function()
      pmRestartTerm:toggle()
    end

    vim.api.nvim_create_user_command("PmRestart", pmRestart, { bang = true })

    vim.keymap.set("n", "<leader>ps", pmStart, { noremap = true, silent = true, desc = "PM Start" })
    vim.keymap.set("n", "<leader>pk", pmStop, { noremap = true, silent = true, desc = "PM Stop" })
    vim.keymap.set("n", "<leader>pr", pmRestart, { noremap = true, silent = true, desc = "PM Restart" })
  end,
}
