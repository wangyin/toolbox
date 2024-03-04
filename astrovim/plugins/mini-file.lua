---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}
---@param opts? lsp.Client.filter
local function get_clients(opts)
  local ret = {} ---@type lsp.Client[]
  if vim.lsp.get_clients then
    print("top")
    ret = vim.lsp.get_clients(opts)
  else
    print("bottom")
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client lsp.Client
      ret = vim.tbl_filter(function(client) return client.supports_method(opts.method, { bufnr = opts.bufnr }) end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param from string
---@param to string
local function on_rename(from, to)
  local clients = get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method "workspace/willRenameFiles" then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding) end
    end
  end
end

return {
  {
    "echasnovski/mini.files",
    keys = {
      {
        "<leader>fe",
        function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
        desc = "Mini Explorer (directory of current file)",
      },
      {
        "<leader>fE",
        function() require("mini.files").open(vim.loop.cwd(), true) end,
        desc = "Mini Explorer (cwd)",
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = {
        use_as_default_explorer = false,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry) return true end
      local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh { content = { filter = new_filter } }
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak left-hand side of mapping to your liking
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event) on_rename(event.data.from, event.data.to) end,
      })
    end,
  },
}
