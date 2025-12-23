return {
    "ywbrian/nvim-term",
    config = function()
        require("nvim-term").setup({
            shell_path = "bash",
            height = 10,
            profiles = {
                bash = {
                    shell_path = "/bin/bash",
                    args = { "--login" },
                    name = "bash",
                },
            },
        })
    end
}
