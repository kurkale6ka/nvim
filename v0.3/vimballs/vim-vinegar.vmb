" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/FUNDING.yml	[[[1
2
github: tpope
custom: ["https://www.paypal.me/vimpope"]
./.gitignore	[[[1
1
/doc/tags
./CONTRIBUTING.markdown	[[[1
6
See the [contribution guidelines for pathogen.vim](https://github.com/tpope/vim-pathogen/blob/master/CONTRIBUTING.markdown).

Vinegar is roughly 130 lines of code.  Netrw is roughly 13,000 lines.  There's
literally a 99% chance the bug you're going to report is in Netrw, not
Vinegar.  Your issue needs to demonstrate beyond a shadow of a doubt that
you've ruled out Netrw as the source of your problem.
./README.markdown	[[[1
61
# vinegar.vim

> Split windows and the project drawer go together like oil and vinegar. I
> don't mean to say that you can combine them to create a delicious salad
> dressing. I mean that they don't mix well!
> - Drew Neil

You know what netrw is, right?  The built in directory browser?  Well,
vinegar.vim enhances netrw, partially in an attempt to mitigate the need for
more disruptive ["project drawer"][Oil and vinegar] style plugins.

[Oil and vinegar]: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/

Some of the behaviors added by vinegar.vim would make excellent upstream
additions.  Many, the author would probably reject.  Others are a bit too wild
to even consider.

* Press `-` in any buffer to hop up to the directory listing and seek to the
  file you just came from.  Keep bouncing to go up, up, up.  Having rapid
  directory access available changes everything.
* All that annoying crap at the top is turned off, leaving you with nothing
  but a list of files.  This is surprisingly disorienting, but ultimately
  very liberating.  Press `I` to toggle until you adapt.
* The oddly C-biased default sort order is replaced with a sensible application
  of `'suffixes'`.
* File hiding: files are not listed that match with one of the patterns in
  `'wildignore'`.  
  If you put `let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'`
  in your vimrc, vinegar will initialize with dot files hidden.
  Press `gh` to toggle dot file hiding.
* Press `.` on a file to pre-populate it at the end of a `:` command line.
  This is great, for example, to quickly initiate a `:grep` of the file or
  directory under the cursor.  Type `.!chmod +x` and
  get `:!chmod +x path/to/file`.
* Press `y.` to yank an absolute path for the file under the cursor.
* Press `~` to go home.
* Use Vim's built-in `CTRL-^` (`CTRL-6`) for switching back to the previous
  buffer from the netrw buffer.

## Installation

Install using your favourite package manager, or use Vim's built-in package support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://github.com/tpope/vim-vinegar.git

## Promotion

Like vinegar.vim?  Star the repository on
[GitHub](https://github.com/tpope/vim-vinegar) and vote for it on
[vim.org](https://www.vim.org/scripts/script.php?script_id=5671).

Love vinegar.vim?  Follow [tpope](http://tpo.pe/) on
[GitHub](https://github.com/tpope) and
[Twitter](http://twitter.com/tpope).

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
./doc/vinegar.txt	[[[1
40
*vinegar.txt*  Combine with netrw to create a delicious salad dressing

Author:  Tim Pope <http://tpo.pe/>
Repo:    https://github.com/tpope/vim-vinegar
License: Same terms as Vim itself (see |license|)

                                                *vinegar*
Vinegar extends netrw.  If you don't find what you are looking for here, check
|netrw.txt|.

MAPPINGS                                        *vinegar-mappings*

                                                *vinegar--*
-                       Open the parent directory of the current file.  This
                        is the only mapping available outside of netrw
                        buffers.

                                                *vinegar-~*
~                       Open $HOME.

                                                *vinegar-c_CTRL-R_CTRL-F*
                                                *vinegar-c_<C-R>_<C-F>*
CTRL-R CTRL-F           In command line mode, insert the path to the file
                        under the cursor.  Similar to the native
                        |c_CTRL-R_CTRL-F|, but resolves the path with respect
                        to the parent directory.

                                                *vinegar-.*
.                       Start a command line with the path to the file
                        under the cursor.  Provide a [count] to include
                        multiple files.

                                                *vinegar-!*
!                       As above, but use a |:!| command line.  Deprecated.

                                                *vinegar-y.*
y.                      Yank the current line or [count] lines as absolute
                        paths.

 vim:tw=78:et:ft=help:norl:
./plugin/vinegar.vim	[[[1
140
" Location:     plugin/vinegar.vim
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.0
" GetLatestVimScripts: 5671 1 :AutoInstall: vinegar.vim

if exists("g:loaded_vinegar") || v:version < 700 || &cp
  finish
endif
let g:loaded_vinegar = 1

function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file," \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction

let s:dotfiles = '\(^\|\s\s\)\zs\.\S\+'

let s:escape = 'substitute(escape(v:val, ".$~"), "*", ".*", "g")'
let g:netrw_list_hide =
      \ join(map(split(&wildignore, ','), '"^".' . s:escape . '. "/\\=$"'), ',') . ',^\.\.\=/\=$' .
      \ (get(g:, 'netrw_list_hide', '')[-strlen(s:dotfiles)-1:-1] ==# s:dotfiles ? ','.s:dotfiles : '')
if !exists("g:netrw_banner")
  let g:netrw_banner = 0
endif
unlet! s:netrw_up

nnoremap <silent> <Plug>VinegarUp :call <SID>opendir('edit')<CR>
if empty(maparg('-', 'n')) && !hasmapto('<Plug>VinegarUp')
  nmap - <Plug>VinegarUp
endif

nnoremap <silent> <Plug>VinegarTabUp :call <SID>opendir('tabedit')<CR>
nnoremap <silent> <Plug>VinegarSplitUp :call <SID>opendir('split')<CR>
nnoremap <silent> <Plug>VinegarVerticalSplitUp :call <SID>opendir('vsplit')<CR>

function! s:sort_sequence(suffixes) abort
  return '[\/]$,*' . (empty(a:suffixes) ? '' : ',\%(' .
        \ join(map(split(a:suffixes, ','), 'escape(v:val, ".*$~")'), '\|') . '\)[*@]\=$')
endfunction
let g:netrw_sort_sequence = s:sort_sequence(&suffixes)

function! s:opendir(cmd) abort
  let df = ','.s:dotfiles
  if expand('%:t')[0] ==# '.' && g:netrw_list_hide[-strlen(df):-1] ==# df
    let g:netrw_list_hide = g:netrw_list_hide[0 : -strlen(df)-1]
  endif
  if &filetype ==# 'netrw' && len(s:netrw_up)
    let basename = fnamemodify(b:netrw_curdir, ':t')
    execute s:netrw_up
    call s:seek(basename)
  elseif expand('%') =~# '^$\|^term:[\/][\/]'
    execute a:cmd '.'
  else
    execute a:cmd '%:h' . (expand('%:p') =~# '^\a\a\+:' ? s:slash() : '')
    call s:seek(expand('#:t'))
  endif
endfunction

function! s:seek(file) abort
  if get(b:, 'netrw_liststyle') == 2
    let pattern = '\%(^\|\s\+\)\zs'.escape(a:file, '.*[]~\').'[/*|@=]\=\%($\|\s\+\)'
  else
    let pattern = '^\%(| \)*'.escape(a:file, '.*[]~\').'[/*|@=]\=\%($\|\t\)'
  endif
  call search(pattern, 'wc')
  return pattern
endfunction

augroup vinegar
  autocmd!
  autocmd FileType netrw call s:setup_vinegar()
  if exists('##OptionSet')
    autocmd OptionSet suffixes
          \ if s:sort_sequence(v:option_old) ==# get(g:, 'netrw_sort_sequence') |
          \   let g:netrw_sort_sequence = s:sort_sequence(v:option_new) |
          \ endif
  endif
augroup END

function! s:slash() abort
  return !exists("+shellslash") || &shellslash ? '/' : '\'
endfunction

function! s:absolutes(first, ...) abort
  let files = getline(a:first, a:0 ? a:1 : a:first)
  call filter(files, 'v:val !~# "^\" "')
  call map(files, "substitute(v:val, '^\\(| \\)*', '', '')")
  call map(files, 'b:netrw_curdir . s:slash() . substitute(v:val, "[/*|@=]\\=\\%(\\t.*\\)\\=$", "", "")')
  return files
endfunction

function! s:relatives(first, ...) abort
  let files = s:absolutes(a:first, a:0 ? a:1 : a:first)
  call filter(files, 'v:val !~# "^\" "')
  for i in range(len(files))
    let relative = fnamemodify(files[i], ':.')
    if relative !=# files[i]
      let files[i] = '.' . s:slash() . relative
    endif
  endfor
  return files
endfunction

function! s:escaped(first, last) abort
  let files = s:relatives(a:first, a:last)
  return join(map(files, 's:fnameescape(v:val)'), ' ')
endfunction
" 97f3fbc9596f3997ebf8e30bfdd00ebb34597722

function! s:setup_vinegar() abort
  if !exists('s:netrw_up')
    let orig = maparg('-', 'n')
    if orig =~? '^<plug>' && orig !=# '<Plug>VinegarUp'
      let s:netrw_up = 'execute "normal \'.substitute(orig, ' *$', '', '').'"'
    elseif orig =~# '^:'
      " :exe "norm! 0"|call netrw#LocalBrowseCheck(<SNR>123_NetrwBrowseChgDir(1,'../'))<CR>
      let s:netrw_up = substitute(orig, '\c^:\%(<c-u>\)\=\|<cr>$', '', 'g')
    else
      let s:netrw_up = ''
    endif
  endif
  nmap <buffer> - <Plug>VinegarUp
  cnoremap <buffer><expr> <Plug><cfile> get(<SID>relatives('.'),0,"\022\006")
  if empty(maparg('<C-R><C-F>', 'c'))
    cmap <buffer> <C-R><C-F> <Plug><cfile>
  endif
  nnoremap <buffer> ~ :edit ~/<CR>
  nnoremap <buffer> . :<C-U> <C-R>=<SID>escaped(line('.'), line('.') - 1 + v:count1)<CR><Home>
  xnoremap <buffer> . <Esc>: <C-R>=<SID>escaped(line("'<"), line("'>"))<CR><Home>
  if empty(mapcheck('y.', 'n'))
    nnoremap <silent><buffer> y. :<C-U>call setreg(v:register, join(<SID>absolutes(line('.'), line('.') - 1 + v:count1), "\n")."\n")<CR>
  endif
  nmap <buffer> ! .!
  xmap <buffer> ! .!
  exe 'syn match netrwSuffixes =\%(\S\+ \)*\S\+\%('.join(map(split(&suffixes, ','), s:escape), '\|') . '\)[*@]\=\S\@!='
  hi def link netrwSuffixes SpecialKey
endfunction
