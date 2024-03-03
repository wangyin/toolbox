return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, config)
      local highlight = {
        "CursorColumn",
        "Whitespace",
      }

      config = require("astronvim.utils").extend_tbl(config, {
        indent = {
          highlight = highlight,
          char = "",
        },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
        },
      })
      return config
    end,
  },
  {
    "echasnovski/mini.indentscope",
    opts = function(_, config)
      config = require("astronvim.utils").extend_tbl(config, {
        symbol = "╎",
      })
      return config
    end,
  },
}
