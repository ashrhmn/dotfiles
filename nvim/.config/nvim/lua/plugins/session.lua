-- if true then
--   return {}
-- end
return {
  {
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        -- auto_save_enabled = true,
        -- auto_restore_enabled = true,

        post_restore_cmds = {
          function()
            vim.schedule(function()
              local buf = vim.api.nvim_get_current_buf()
              local view = vim.fn.winsaveview()
              vim.cmd("edit")
              vim.fn.winrestview(view)
            end)
          end,
        },

        -- ⚠️ This will only work if Telescope.nvim is installed
        -- The following are already the default values, no need to provide them if these are already the settings you want.
        session_lens = {
          -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
          buftypes_to_ignore = {}, -- list of buffer types that should not be deleted from current session when a new one is loaded
        },
      })

      -- Open the session picker through auto-session's public command.
      -- Recent auto-session versions no longer expose the old
      -- `auto-session.session-lens` Lua module path.
      vim.keymap.set("n", "<leader>ls", "<cmd>AutoSession search<CR>", {
        noremap = true,
        desc = "Search sessions",
      })
    end,
  },
}
