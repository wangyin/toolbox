return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = function(lang, buf)
          if vim.tbl_contains({ "json" }, lang) then
            print("Json file -- disable treesitter")
            return true
          end
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            print("Large file -- disable treesitter")
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      }
    }
  }

}
