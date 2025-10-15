return {
    {
        'folke/trouble.nvim',
        opts = {},
        cmd = "Trouble",
        keys = {
            {
                "<leader>d",
                "<cmd>Trouble diagnostics toggle filter.buf=0 win.position=left<cr>",
                desc = "Buffer Diagnostics (Trouble)",
                silent = true
            },
            {
                "<leader>T",
                "<cmd>Trouble symbols toggle focus=false win.position=left<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cq",
                "<cmd>Trouble qflist toggle win.position=left<cr>",
                desc = "Quickfix List (Trouble)",
            }
        }
    }
}
