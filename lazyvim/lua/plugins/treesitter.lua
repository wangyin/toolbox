return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = function (_, buf)
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.leap.fs_stat, vim.api.nvim_buf_get_name(buf))
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
