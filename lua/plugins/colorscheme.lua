return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Load before other plugins
  config = function()
    require("catppuccin").setup({
        auto_integrations = true,
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
