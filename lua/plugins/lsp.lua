return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip"
        },
        config = function()
            vim.api.nvim_create_autocmd(
                "LspAttach",
                {
                    callback = function(args)
                        local bufnr = args.buf
                        local opts = {noremap = true, silent = true, buffer = bufnr}

                        local opts = {noremap = true, silent = true, buffer = bufnr}

                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

                        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                        vim.keymap.set(
                            {"n", "v"},
                            "<leader>f",
                            function()
                                vim.lsp.buf.format({async = true})
                            end,
                            opts
                        )

                        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                    end
                }
            )

            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup(
                {
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end
                    },
                    mapping = cmp.mapping.preset.insert(
                        {
                            ["<Tab>"] = cmp.mapping.select_next_item(),
                            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                            ["<Enter>"] = cmp.mapping(
                                function(fallback)
                                    if cmp.visible() then
                                        cmp.confirm({select = true})
                                    elseif luasnip.expand_or_jumpable() then
                                        luasnip.expand_or_jump()
                                    else
                                        fallback()
                                    end
                                end,
                                {"i", "s"}
                            ),
                            ["<S-Enter>"] = cmp.mapping(
                                function(fallback)
                                    if cmp.visible() then
                                        cmp.select_prev_item()
                                    elseif luasnip.jumpable(-1) then
                                        luasnip.jump(-1)
                                    else
                                        fallback()
                                    end
                                end,
                                {"i", "s"}
                            ),
                        }
                    ),
                    sources = cmp.config.sources(
                        {
                            {name = "nvim_lsp"},
                            {name = "luasnip"}
                        },
                        {
                            {name = "buffer"}
                        }
                    )
                }
            )

            cmp.setup.cmdline(
                {"/", "?"},
                {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        {name = "buffer"}
                    }
                }
            )

            cmp.setup.cmdline(
                ":",
                {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources(
                        {
                            {name = "path"}
                        },
                        {
                            {name = "cmdline"}
                        }
                    ),
                    matching = {disallow_symbol_nonprefix_matching = false}
                }
            )

            local caps = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", {capabilities = caps})

            local servers = {
                "clangd",
                "basedpyright",
                "gopls",
                "textlab",
                "rust_analyzer"
            }

            for _, server in ipairs(servers) do
                vim.lsp.enable(server)
            end
        end
    }
}

