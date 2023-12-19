vim.o.ruler = true

-- Wild menu & status line
vim.o.wildmenu = true
vim.o.wildmode = 'full'
vim.o.wildignorecase = true
vim.opt.wildignore:append { '*~', '*.swp', 'tags' }
-- cmdline: <c-z> in a mapping acts like <tab>
vim.o.wildcharm = 26 -- :lua print((""):byte())

-- Status line
vim.o.laststatus = 2
