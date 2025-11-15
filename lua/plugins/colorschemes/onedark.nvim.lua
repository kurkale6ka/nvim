return {
    {
        'navarasu/onedark.nvim',
        lazy = true,
        priority = 1000,
        opts = {
            style = 'darker',
            ending_tildes = true,
            code_style = {
                comments = 'italic',
                keywords = 'bold,italic',
                functions = 'italic',
                strings = 'none',
                variables = 'none',
            },
        },
    },
}
