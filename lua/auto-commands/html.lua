local html = vim.api.nvim_create_augroup("HTML-family", { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'html', 'phtml', 'xhtml' },
    callback = function()
        -- Server side includes
        vim.bo.include = [[--\s*#\s*include\s*virtual=\|href=]]
        vim.bo.includeexpr = "substitute(v:fname,'^/','','')"

        vim.cmd([[
        let b:surround_{char2nr('1')} = "<h1>\r</h1>"
        let b:surround_{char2nr('2')} = "<h2>\r</h2>"
        let b:surround_{char2nr('3')} = "<h3>\r</h3>"
        let b:surround_{char2nr('4')} = "<h4>\r</h4>"
        let b:surround_{char2nr('5')} = "<h5>\r</h5>"
        let b:surround_{char2nr('6')} = "<h6>\r</h6>"
        let b:surround_{char2nr('a')} = "<a href=\"\" title=\"\">\r</a>"
        let b:surround_{char2nr('A')} = "<a href=\"\" title=\"\" class=\"\1Class: \1\">\r</a>"
        let b:surround_{char2nr('e')} = "<em>\r</em>"
        let b:surround_{char2nr('b')} = "<strong>\r</strong>"
        let b:surround_{char2nr('s')} = "<span>\r</span>"
        let b:surround_{char2nr('S')} = "<span class=\"\1Class: \1\">\r</span>"
        let b:surround_{char2nr('l')} = "<li>\r</li>"
        let b:surround_{char2nr('L')} = "<li class=\"\1Class: \1\">\r</li>"
        let b:surround_{char2nr('d')} = "<div>\r</div>"
        let b:surround_{char2nr('D')} = "<div class=\"\1Class: \1\">\r</div>"
        let b:surround_{char2nr('p')} = "<p>\r</p>"
        let b:surround_{char2nr('P')} = "<p class=\"\1Class: \1\">\r</p>"
        let b:surround_{char2nr('t')} = "<td>\r</td>"
        let b:surround_{char2nr('T')} = "<td class=\"\1Class: \1\">\r</td>"
        let b:surround_{char2nr('h')} = "<th>\r</th>"
        let b:surround_{char2nr('H')} = "<th class=\"\1Class: \1\">\r</th>"
        ]])
    end,
    group = html,
})

-- Tidy
vim.api.nvim_create_autocmd('Filetype', {
    pattern = { 'html', 'phtml', 'xhtml', 'xml', 'xsd' },
    -- TODO: fix the issue with ]]. Maybe I don't need this. There are better alternatives!
    -- command! -buffer DeleteTags %substitute:<[?%![:space:]]\@!/\=\_.\{-1,}[-?%]\@<!>::gc
    command = [[
        command! -buffer -range=% -nargs=* Tidy <line1>,<line2>! xmllint --format --recover - 2>/dev/null
    ]],
    group = html,
})
