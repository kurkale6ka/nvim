"" Editing

" alt + backspace
noremap! <a-bs> <c-w>

" alt + d
cnoremap <a-d> <c-\>ecmdline#alt_d()<cr>
inoremap <a-d> <c-o>de

" ctrl + k
cmap <c-k> <c-\>estrpart(getcmdline(), 0, getcmdpos() - 1)<cr>
imap <c-k> <c-o>D

" ctrl + u
inoremap <c-u> <c-g>u<c-u>

" ctrl + w (TODO: <c-w> <c-g>u<c-w>?)
cnoremap <c-w> <c-\>ecmdline#ctrl_w()<cr>
inoremap <c-w> <c-o>dB

"" Moving

" enhanced gm
nmap <silent> gm :call move#gm()<cr>
omap <silent> gm :call move#gm()<cr>

" alt + b,f to go left or right
cmap <a-b> <s-left>
imap <a-b> <c-o>B
cmap <a-f> <s-right>
imap <a-f> <c-o>W

" alt + h,j,k,l to navigate windows
inoremap <a-h> <c-\><c-n><c-w>h
inoremap <a-j> <c-\><c-n><c-w>j
inoremap <a-k> <c-\><c-n><c-w>k
inoremap <a-l> <c-\><c-n><c-w>l
nnoremap <a-h> <c-w>h
nnoremap <a-j> <c-w>j
nnoremap <a-k> <c-w>k
nnoremap <a-l> <c-w>l

" ctrl + a to go to '^'
cmap <c-a> <c-b>

" ctrl + w N to create a new window to the left
nmap <silent> <c-w>N :leftabove vnew<cr>

" ctrl + w twice to go to the last accessed window
nmap <silent> <c-w><c-w> :wincmd p<cr>

" ctrl + / to goto '^' and '$'
imap <c-left> <c-o>^
imap <c-right> <c-o>$
nmap <c-left> ^
nmap <c-right> $

" ctrl +  to go up by a paragraph
imap <c-up> <c-o>{
map  <c-up> {

" ctrl +  to go down by a paragraph
imap <c-down> <c-o>}
map  <c-down> }
