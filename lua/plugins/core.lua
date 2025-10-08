return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { 
                    "c", "cpp", "python",
                    -- "latex", "bibtex", 
                    "lua", "vim", "vimdoc", "query" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
        })
    end
  },

    -- Fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { 
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        config = function()
            require("telescope").setup()
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim", 
        build = "make"
    },

    -- Surround
    "tpope/vim-surround",

    -- Commenting
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },

    -- Auto-closing brackets/pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
          require("nvim-autopairs").setup()
        end
    },


}
