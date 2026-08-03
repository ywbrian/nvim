return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  event = "InsertEnter",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- <C-y> accepts, <C-n>/<C-p> cycle, <C-e> cancels.
    keymap = { preset = "default" },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 250 },
    },

    -- "lsp" is inert until language servers are configured; leaving it in
    -- means completion just starts working when they are.
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
