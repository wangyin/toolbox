return {
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons'     -- optional
    },
    event = 'LspAttach',
    keys = {
      { "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
    },
    opts = {
      lightbulb = {
        enable = false,
      }
    },
  },
}
