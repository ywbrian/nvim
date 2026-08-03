return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      -- Shipped by kanagawa.nvim itself, so it tracks the wave palette.
      theme = "kanagawa",
      -- Matches laststatus=3 from config.options.
      globalstatus = true,
    },
    sections = {
      lualine_c = {
        { "filename", path = 1 },
      },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_lsp" },
        },
        "encoding",
        "filetype",
      },
    },
  },
}
