return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Not lazy: oil replaces netrw, so it has to be there when Nvim is opened
  -- on a directory (`nvim .`).
  lazy = false,
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    win_options = {
      signcolumn = "no",
    },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
}
