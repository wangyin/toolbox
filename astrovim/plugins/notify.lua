return {
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "static",
      render = "compact",
      fps = 5,
      level = 1,
      timeout = 1000,
    }
  },
  {
    "folke/noice.nvim",
    opts = function(_, config)
      config.lsp = {
        signature = {
          enabled = true,
        },
      }
      return config
    end,
  },
}
