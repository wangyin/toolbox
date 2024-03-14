return {
  "echasnovski/mini.hipatterns",
  opts = {
    highlighters = {
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = require("mini.hipatterns").gen_highlighter.hex_color { priority = 2000 },
    },
  },
}
