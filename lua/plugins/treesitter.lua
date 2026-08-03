-- nvim-treesitter `main` branch (requires Neovim 0.12+).
-- The rewrite dropped modules, so highlighting, on-demand installs, and
-- incremental selection are wired up by hand below.

local PARSERS = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "make",
  "python",
  "rust",
}

---Clamp a 0-indexed (row, col) to a position the cursor can actually occupy.
---@return integer row1, integer col0
local function clamp(row, col)
  local line_count = vim.api.nvim_buf_line_count(0)
  row = math.max(0, math.min(row, line_count - 1))
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1] or ""
  return row + 1, math.max(0, math.min(col, math.max(#line - 1, 0)))
end

---Visually select a treesitter range {srow, scol, erow, ecol} (end-exclusive).
local function select_range(range)
  local srow, scol, erow, ecol = range[1], range[2], range[3], range[4]

  -- An end column of 0 means the node stops at the start of that line.
  if ecol == 0 and erow > srow then
    erow = erow - 1
    ecol = #(vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1] or "")
  end

  if vim.fn.mode():match("[vV\22]") then
    vim.cmd("normal! \27")
  end

  local srow1, scol0 = clamp(srow, scol)
  vim.api.nvim_win_set_cursor(0, { srow1, scol0 })
  vim.cmd("normal! v")
  local erow1, ecol0 = clamp(erow, ecol - 1)
  vim.api.nvim_win_set_cursor(0, { erow1, ecol0 })
end

local function node_range(node)
  local srow, scol, erow, ecol = node:range()
  return { srow, scol, erow, ecol }
end

local function same_range(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

-- Per-buffer stack of selected ranges, so <BS> can walk back down.
local stacks = {}

local function grow()
  local buf = vim.api.nvim_get_current_buf()
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return
  end
  -- The highlighter only parses what it draws, so make sure a tree exists
  -- before asking for nodes.
  parser:parse(true)

  local stack = stacks[buf]
  local in_visual = vim.fn.mode():match("[vV\22]") ~= nil
  local current

  if in_visual and stack and #stack > 0 then
    current = stack[#stack]
  else
    -- Fresh selection: start from the node under the cursor.
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    current = { row - 1, col, row - 1, col + 1 }
    stack = {}
    stacks[buf] = stack
  end

  local node = parser:named_node_for_range(current)
  if not node then
    return
  end

  -- Already selecting a node: climb until we find a strictly larger one.
  if #stack > 0 then
    while node and same_range(node_range(node), current) do
      node = node:parent()
    end
    if not node then
      return
    end
  end

  stack[#stack + 1] = node_range(node)
  select_range(stack[#stack])
end

local function shrink()
  local buf = vim.api.nvim_get_current_buf()
  local stack = stacks[buf]
  if not stack or #stack < 2 then
    return
  end
  stack[#stack] = nil
  select_range(stack[#stack])
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    -- Idempotent: already-installed parsers are skipped, so this is a no-op
    -- after the first run. Async, so it never blocks startup.
    ts.install(PARSERS)

    local attempted = {}

    local function attach(buf, lang)
      if not pcall(vim.treesitter.start, buf, lang) then
        return false
      end
      vim.keymap.set({ "n", "x" }, "<Enter>", grow, { buffer = buf, desc = "Grow ts selection" })
      vim.keymap.set("x", "<BS>", shrink, { buffer = buf, desc = "Shrink ts selection" })
      return true
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(args.match) or args.match

        if attach(buf, lang) then
          return
        end

        -- Stands in for the old `auto_install`: fetch a known parser once,
        -- then attach when it lands.
        if attempted[lang] or not vim.list_contains(ts.get_available(), lang) then
          return
        end
        attempted[lang] = true

        ts.install(lang):await(function()
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              attach(buf, lang)
            end
          end)
        end)
      end,
    })

    vim.api.nvim_create_autocmd("BufDelete", {
      group = "treesitter_attach",
      callback = function(args)
        stacks[args.buf] = nil
      end,
    })
  end,
}
