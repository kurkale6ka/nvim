vim.keymap.set('ia', '_dn', [[Dimitar Dimitrov<c-r>=abbreviations#eat_char('\s')<cr>]])
vim.keymap.set('ia', '_de', [[kurkale6ka@gmail.com<c-r>=abbreviations#eat_char('\s')<cr>]])
vim.keymap.set('ia', '_dd', [[Dimitar Dimitrov<cr>kurkale6ka@gmail.com<c-r>=abbreviations#eat_char('\s')<cr>]])

vim.keymap.set('ia', '_date', [[<c-r>=strftime('%a, %d %b %Y')<cr><c-r>=abbreviations#eat_char('\s')<cr>]])
vim.keymap.set('ia', 'todo', 'TODO')
vim.keymap.set('ia', 'fixme', 'FIXME')

-- 3 letter words
vim.keymap.set('ia', 'adn', 'and')
vim.keymap.set('ia', 'teh', 'the')
vim.keymap.set('ia', 'hte', 'the')
vim.keymap.set('ia', 'nad', 'and')
vim.keymap.set('ia', 'nwe', 'new')

-- 4 letter words
vim.keymap.set('ia', 'amny', 'many')
vim.keymap.set('ia', 'iwth', 'with')
vim.keymap.set('ia', 'olny', 'only')
vim.keymap.set('ia', 'onyl', 'only')
vim.keymap.set('ia', 'tihs', 'this')

-- 5 letter words
vim.keymap.set('ia', 'ascci', 'ascii')
vim.keymap.set('ia', 'spcae', 'space')
vim.keymap.set('ia', 'whcih', 'which')

-- >= 6 letter words
vim.keymap.set('ia', 'awlays', 'always')
vim.keymap.set('ia', 'beneat', 'beneath')
vim.keymap.set('ia', 'developper', 'developer')

-- Command line abbreviations
vim.keymap.set('ca', 'waq', 'wqa')
