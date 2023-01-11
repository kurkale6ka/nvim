require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }

vim.keymap.set('n', 'gl', ':HopWord<cr>', { desc = 'Go to a random word' })
