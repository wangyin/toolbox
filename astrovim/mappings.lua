-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    ["0"] = { "^" },
    ["^"] = { "0" },

    -- navigate buffer tabs with `H` and `L`
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    ["<Char-0xAA>"] = { ":w!<cr>", desc = "Save File", silent=true },  -- change description but the same command
    ["<Char-0xAB>"] = { function() require("astronvim.utils.buffer").close() end, desc = "Close buffer" },
    ["<leader>fe"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    ["<leader>e"] = { function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end, desc = "Mini Explorer (directory of current file)" },
    ["<leader>E"] = { function() require("mini.files").open(vim.loop.cwd(), true) end, desc = "Mini Explorer (cwd)" },
    ["m"] = { '<plug>(matchup-%)', desc = "Match Up" },
  },
  v = {
    ["J"] = { ":move '>+1<CR>gv-gv", desc = "Move selected 1 line down" },
    ["K"] = { ":move '<-2<CR>gv-gv", desc = "Move selected 1 line down" },
    ["m"] = { '<plug>(matchup-%)', desc = "Match Up" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
