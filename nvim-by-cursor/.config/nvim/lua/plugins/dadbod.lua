return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_table_helpers = {
      postgresql = {
        Count = 'select count(*) from "{table}"',
      },
    }

    local filePath = os.getenv("DBS_PATH")
    if not filePath then
      return
    end
    local file = io.open(filePath, "r")

    if not file then
      return
    end

    local dbs = {}

    while true do
      local line = file:read("*l")
      if not line then
        file:close()
        break
      end
      local name, url = line:match("([^,]+),([^,]+)")
      table.insert(dbs, { name = name, url = url })
    end
    vim.g.dbs = dbs
  end,
}
