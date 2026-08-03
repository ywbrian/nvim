-- blink.cmp adds its own brackets when accepting a function completion, so no
-- completion-engine bridge is needed here.
return {
  "echasnovski/mini.pairs",
  version = "*",
  event = "InsertEnter",
  opts = {},
}
