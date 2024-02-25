return {
  "folke/which-key.nvim",
  opts = {
    defaults = {
      mode = { "n", "v" },
      ["gs"] = { name = "+surround" },
    }
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.register(opts.defaults)
  end
}
