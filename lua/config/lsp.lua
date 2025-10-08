local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Enable keybinds for available LSP server
local on_attach = function(client, bufnr)
    -- Keybind options
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- LSP Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)      -- go to definition
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)     -- go to declaration  
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)  -- go to implementation
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)      -- show references
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)            -- show documentation
    
    -- LSP Actions
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)    -- see available code actions
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)         -- rename
    
    -- Diagnostics
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)   -- show diagnostics for cursor
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)           -- jump to previous diagnostic
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)           -- jump to next diagnostic
    
    -- Additional useful bindings
    vim.keymap.set("n", "<leader>o", vim.lsp.buf.document_symbol, opts) -- see document symbols
end

-- Used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Configure C & C++ server
vim.lsp.config.clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    capabilities = capabilities,
    on_attach = on_attach,
}

-- Configure Lua server
vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
}

-- Configure Python server
vim.lsp.config.pylsp = {
    cmd = { "pylsp" },
    filetypes = { "python" },
    capabilities = capabilities,
    on_attach = on_attach,
}