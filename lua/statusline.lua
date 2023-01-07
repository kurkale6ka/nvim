vim.o.ruler = true

-- Wild menu & status line
vim.o.wildmenu = true
vim.o.wildmode = 'full'
vim.o.wildignorecase = true
vim.opt.wildignore:append('*~,*.swp,tags')
vim.o.wildcharm = '<c-z>' -- cmdline: <c-z> in a mapping acts like <tab>

-- Status line
vim.o.statusline = "%!statusline#init('❬', '❭')"
vim.o.laststatus = 2

-- Tabline
vim.o.showtabline = 1
vim.o.tabline = '%!tabs#MyTabLine()'
