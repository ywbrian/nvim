return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    -- Instant for plugin popups (registers, marks), otherwise wait a beat.
    delay = function(ctx)
      return ctx.plugin and 0 or 300
    end,
    win = {
      border = "rounded",
    },
    spec = {
      { "<leader>p", group = "pickers" },
      { "<leader>v", group = "vim" },
      { "<leader>g", group = "git" },
      { "g", group = "goto" },
      { "gr", group = "lsp" },
      { "]", group = "next" },
      { "[", group = "prev" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer-local keymaps",
    },
  },
}
