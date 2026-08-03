-- Since 0.11 the LSP "framework" lives in core (vim.lsp.config / vim.lsp.enable).
-- nvim-lspconfig is now only a repository of server config data -- cmd, filetypes,
-- root markers -- which core reads from its `lsp/` directory. So this file just
-- layers per-server overrides on top and enables what we want.

local SERVERS = {
  "clangd", -- C / C++
  "basedpyright", -- Python
  "rust_analyzer", -- Rust
}

return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Rounded floats for hover, signature help and diagnostics, to sit better
    -- with kanagawa. 0.12 applies this to every float that doesn't set its own.
    vim.o.winborder = "rounded"

    -- Tell every server what blink can actually do with the results.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities({}, true),
    })

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--completion-style=detailed",
      },
    })

    vim.lsp.config("basedpyright", {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = true,
          check = { command = "clippy" },
          cargo = { allFeatures = true },
        },
      },
    })

    vim.lsp.enable(SERVERS)

    vim.diagnostic.config({
      severity_sort = true,
      virtual_text = { spacing = 2, prefix = "●" },
      float = { source = true },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        -- 0.12 already provides grn (rename), gra (code action), grr
        -- (references), gri (implementation), grt (type definition), gO
        -- (document symbols), [d / ]d and i_<C-s>. These fill the gaps.
        map("n", "gd", vim.lsp.buf.definition, "Goto definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
        map("n", "K", vim.lsp.buf.hover, "Hover docs")

        -- Aliases for the muscle memory from the old config.
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
        map({ "n", "x" }, "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
          map("n", "<leader>ih", function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
          end, "Toggle inlay hints")
        end
      end,
    })
  end,
}
