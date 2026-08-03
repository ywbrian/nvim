return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
    { "<leader>pb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
    { "<leader>vh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>pg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    {
      "<leader>ps",
      function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
      end,
      desc = "Grep for a prompted string",
    },
  },
  opts = {
    defaults = {
      layout_strategy = "flex",
      path_display = { "truncate" },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
