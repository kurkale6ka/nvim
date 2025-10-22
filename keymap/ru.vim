lmapclear <buffer>

source $XDG_CONFIG_HOME/nvim/keymap/bg.vim

setlocal spelllang=ru
let b:keymap_name = "ру"

inoreabbrev абв Аа  Бб  Вв  Гг  Дд  Ее  Ёё  Жж  Зз  Ии  Йй<cr>Кк  Лл  Мм  Нн  Оо  Пп  Рр  Сс  Тт  Уу  Фф<cr>Хх  Цц  Чч  Шш  Щщ  Ъъ  Ыы  Ьь  Ээ  Юю  Яя

" Note: I used [ for ь in the bulgarian keymap so [] feels appropriate
" ~ is used to switch case
lnoremap <buffer> []  ы
lnoremap <buffer> ~[] Ы
lnoremap <buffer> :e  ё
lnoremap <buffer> :E  Ё
lnoremap <buffer> )e  э
lnoremap <buffer> )E  Э
