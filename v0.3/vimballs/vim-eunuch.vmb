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
./README.markdown	[[[1
52
# eunuch.vim

Vim sugar for the UNIX shell commands that need it the most.  Features
include:

* `:Remove`: Delete a file on disk without `E211: File no longer available`.
* `:Delete`: Delete a file on disk and the buffer too.
* `:Move`: Rename a buffer and the file on disk simultaneously.  See also
  `:Rename`, `:Copy`, and `:Duplicate`.
* `:Chmod`: Change the permissions of the current file.
* `:Mkdir`: Create a directory, defaulting to the parent of the current file.
* `:Cfind`: Run `find` and load the results into the quickfix list.
* `:Clocate`: Run `locate` and load the results into the quickfix list.
* `:Lfind`/`:Llocate`: Like above, but use the location list.
* `:Wall`: Write every open window.  Handy for kicking off tools like
  [guard][].
* `:SudoWrite`: Write a privileged file with `sudo`.
* `:SudoEdit`: Edit a privileged file with `sudo`.
* Typing a shebang line causes the file type to be re-detected.  Additionally
  the file will be automically made executable (`chmod +x`) after the next
  write.

[guard]: https://github.com/guard/guard

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/eunuch.git
    vim -u NONE -c "helptags eunuch/doc" -c q

## Contributing

See the contribution guidelines for
[pathogen.vim](https://github.com/tpope/vim-pathogen#readme).

## Self-Promotion

Like eunuch.vim? Follow the repository on
[GitHub](https://github.com/tpope/vim-eunuch) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=4300).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

## License

Copyright (c) Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
./doc/eunuch.txt	[[[1
129
*eunuch.txt*  File manipulation
Author:  Tim Pope <http://tpo.pe/>
License: Same terms as Vim itself (see |license|)

This plugin is only available if 'compatible' is not set.

INTRODUCTION                                    *eunuch*

Vim sugar for the UNIX shell commands that need it the most.  Delete or rename
a buffer and the underlying file at the same time.  Load a `find` or a
`locate` into the quickfix list.  And so on.

COMMANDS                                        *eunuch-commands*

                                        *eunuch-:Remove* *eunuch-:Unlink*
:Remove[!]              Delete the file from disk and reload the buffer.  If
:Unlink[!]              you change your mind, the contents of the buffer can
                        be restored with |u| (see 'undoreload').

                                                *eunuch-:Delete*
:Delete[!]              Delete the file from disk and |:bdelete| the buffer.
                        This cannot be undone, and thus a `!` is required to
                        delete non-empty files.

                                                *eunuch-:Copy*
:Copy[!] {file}         Small wrapper around |:saveas|.  Parent directories
                        are automatically created.  If the argument itself is
                        a directory, a file with the same basename will be
                        created inside that directory.

                                                *eunuch-:Duplicate*
:Duplicate[!] {file}    Like |:Copy|, but the argument is taken as relative to
                        the current file's parent directory.

                                                *eunuch-:Move*
:Move[!] {file}         Like |:Copy|, but delete the old file and |:bwipe| the
                        old buffer afterwards.

                                                *eunuch-:Rename*
:Rename[!] {file}       Like |:Move|, but the argument is taken as relative to
                        the current file's parent directory.

                                                *eunuch-:Chmod*
:Chmod {mode}           Change the permissions of the current file.

                                                *eunuch-:Mkdir*
:Mkdir {dir}            Create directory {dir} and all parent directories,
                        like `mkdir -p`.

:Mkdir                  With no argument, create the containing directory for
                        the current file.

                                                *eunuch-:Cfind*
:Cfind[!] {args}        Run `find` and load the results into the quickfix
                        list.  Jump to the first result unless ! is given.

                                                *eunuch-:Lfind*
:Lfind[!] {args}        Run `find` and load the results into the location
                        list.  Jump to the first result unless ! is given.

                                                *eunuch-:Clocate*
:Clocate[!] {args}      Run `locate` and load the results into the quickfix
                        list.  Jump to the first result unless ! is given.

                                                *eunuch-:Llocate*
:Llocate[!] {args}      Run `locate` and load the results into the location
                        list.  Jump to the first result unless ! is given.

                                                *eunuch-:SudoEdit*
:SudoEdit [file]        Edit a file using sudo.  This overrides any read
                        permission issues, plus allows you to write the file
                        with :w!.

                                                *eunuch-:SudoWrite*
:SudoWrite              Use sudo to write the file to disk.  Handy when you
                        forgot to use sudo to invoke Vim.  This uses :SudoEdit
                        internally, so after the first invocation you can
                        subsequently use :w!.

                        Both sudo commands are implemented using `sudo -e`,
                        also known as sudoedit.  This has the advantage of
                        respecting sudoedit permissions in /etc/sudoers, and
                        the constraint of not allowing edits to symlinks or
                        files in writable directories, both of which can be
                        abused in some circumstances to write to files that
                        were not intended.  These restrictions can be lifted
                        with the sudoedit_follow and sudoedit_checkdir sudo
                        options, respectively.

                                                *eunuch-:Wall* *eunuch-:W*
:Wall                   Like |:wall|, but for windows rather than buffers.
:W                      It also writes files that haven't changed, which is
                        useful for kicking off build and test suites (such as
                        with watchr or guard).  Furthermore, it handily
                        doubles as a safe fallback for people who, like me,
                        accidentally type :W instead of :w a lot.

PASSIVE BEHAVIORS                               *eunuch-passive*

If you type a line at the beginning of a file that starts with #! and press
<CR>, The current file type will be re-detected.  This is implemented using a
<CR> map.  If you already have a <CR> map, Eunuch will attempt to combine with
it.  For best results, use an <expr> map.

Additionally, if the shebang line lacks a path (e.g., `#!bash`), it will be
normalized by adding `/usr/bin/env` (e.g., `#!/usr/bin/env bash`).  If it
lacks a command entirely (just `#!`), Eunuch will invert the process and pick
a command appropriate for the current file type.  For example, if the file
type is "python", the shebang will become `#!/usr/bin/env python3` .

Finally, adding a shebang line to a new or existing file will cause `chmod +x`
to be invoked on the file on the next write.

                                                *g:eunuch_interpreters*
You can customize the generated shebang with g:eunuch_interpreters, a
dictionary that maps between file types and shell commands:
>
        let g:eunuch_interpreters = {
                \ 'lua': '/usr/bin/lua5.1'}
<
This example is a joke.  Do not use Lua.

ABOUT                                           *eunuch-about*

Grab the latest version or report a bug on GitHub:

http://github.com/tpope/vim-eunuch

 vim:tw=78:et:ft=help:norl:
./plugin/eunuch.vim	[[[1
508
" eunuch.vim - Helpers for UNIX
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.3

if exists('g:loaded_eunuch') || &cp || v:version < 704
  finish
endif
let g:loaded_eunuch = 1

let s:slash_pat = exists('+shellslash') ? '[\/]' : '/'

function! s:separator() abort
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction

function! s:ffn(fn, path) abort
  return get(get(g:, 'io_' . matchstr(a:path, '^\a\a\+\ze:'), {}), a:fn, a:fn)
endfunction

function! s:fcall(fn, path, ...) abort
  return call(s:ffn(a:fn, a:path), [a:path] + a:000)
endfunction

function! s:AbortOnError(cmd) abort
  try
    exe a:cmd
  catch '^Vim(\w\+):E\d'
    return 'return ' . string('echoerr ' . string(matchstr(v:exception, ':\zsE\d.*')))
  endtry
  return ''
endfunction

function! s:MinusOne(...) abort
  return -1
endfunction

function! EunuchRename(src, dst) abort
  if a:src !~# '^\a\a\+:' && a:dst !~# '^\a\a\+:'
    return rename(a:src, a:dst)
  endif
  try
    let fn = s:ffn('writefile', a:dst)
    let copy = call(fn, [s:fcall('readfile', a:src, 'b'), a:dst])
    if copy == 0
      let delete = s:fcall('delete', a:src)
      if delete == 0
        return 0
      else
        call s:fcall('delete', a:dst)
        return -1
      endif
    endif
  catch
    return -1
  endtry
endfunction

function! s:MkdirCallable(name) abort
  let ns = matchstr(a:name, '^\a\a\+\ze:')
  if !s:fcall('isdirectory', a:name) && s:fcall('filewritable', a:name) !=# 2
    if exists('g:io_' . ns . '.mkdir')
      return [g:io_{ns}.mkdir, [a:name, 'p']]
    elseif empty(ns)
      return ['mkdir', [a:name, 'p']]
    endif
  endif
  return ['s:MinusOne', []]
endfunction

function! s:Delete(path) abort
  if has('patch-7.4.1107') && isdirectory(a:path)
    return delete(a:path, 'd')
  else
    return s:fcall('delete', a:path)
  endif
endfunction

command! -bar -bang -nargs=? -complete=dir Mkdir
      \ let s:dst = empty(<q-args>) ? expand('%:h') : <q-args> |
      \ if call('call', s:MkdirCallable(s:dst)) == -1 |
      \   echohl WarningMsg |
      \   echo "Directory already exists: " . s:dst |
      \   echohl NONE |
      \ elseif empty(<q-args>) |
      \    silent keepalt execute 'file' fnameescape(@%) |
      \ endif |
      \ unlet s:dst

function! s:DeleteError(file) abort
  if empty(s:fcall('getftype', a:file))
    return 'Could not find "' . a:file . '" on disk'
  else
    return 'Failed to delete "' . a:file . '"'
  endif
endfunction

command! -bar -bang Unlink
      \ if <bang>1 && &undoreload >= 0 && line('$') >= &undoreload |
      \   echoerr "Buffer too big for 'undoreload' (add ! to override)" |
      \ elseif s:Delete(@%) |
      \   echoerr s:DeleteError(@%) |
      \ else |
      \   edit! |
      \   silent exe 'doautocmd <nomodeline> User FileUnlinkPost' |
      \ endif

command! -bar -bang Remove Unlink<bang>

command! -bar -bang Delete
      \ if <bang>1 && !(line('$') == 1 && empty(getline(1)) || s:fcall('getftype', @%) !=# 'file') |
      \   echoerr "File not empty (add ! to override)" |
      \ else |
      \   let s:file = expand('%:p') |
      \   execute 'bdelete<bang>' |
      \   if !bufloaded(s:file) && s:Delete(s:file) |
      \     echoerr s:DeleteError(s:sfile) |
      \   endif |
      \   unlet s:file |
      \ endif

function! s:FileDest(q_args) abort
  let file = a:q_args
  if file =~# s:slash_pat . '$'
    let file .=  expand('%:t')
  elseif s:fcall('isdirectory', file)
    let file .= s:separator() .  expand('%:t')
  endif
  return substitute(file, '^\.' . s:slash_pat, '', '')
endfunction

command! -bar -nargs=1 -bang -complete=file Copy
      \ let s:dst = s:FileDest(<q-args>) |
      \ call call('call', s:MkdirCallable(fnamemodify(s:dst, ':h'))) |
      \ let s:dst = s:fcall('simplify', s:dst) |
      \ exe expand('<mods>') 'saveas<bang>' fnameescape(remove(s:, 'dst')) |
      \ filetype detect

function! s:Move(bang, arg) abort
  let dst = s:FileDest(a:arg)
  exe s:AbortOnError('call call("call", s:MkdirCallable(' . string(fnamemodify(dst, ':h')) . '))')
  let dst = s:fcall('simplify', dst)
  if !a:bang && s:fcall('filereadable', dst)
    let confirm = &confirm
    try
      if confirm | set noconfirm | endif
      exe s:AbortOnError('keepalt saveas ' . fnameescape(dst))
    finally
      if confirm | set confirm | endif
    endtry
  endif
  if s:fcall('filereadable', @%) && EunuchRename(@%, dst)
    return 'echoerr ' . string('Failed to rename "'.@%.'" to "'.dst.'"')
  else
    let last_bufnr = bufnr('$')
    exe s:AbortOnError('silent keepalt file ' . fnameescape(dst))
    if bufnr('$') != last_bufnr
      exe bufnr('$') . 'bwipe'
    endif
    setlocal modified
    return 'write!|filetype detect'
  endif
endfunction

command! -bar -nargs=1 -bang -complete=file Move exe s:Move(<bang>0, <q-args>)

" ~/f, $VAR/f, /f, C:/f, url://f, ./f, ../f
let s:absolute_pat = '^[~$]\|^' . s:slash_pat . '\|^\a\+:\|^\.\.\=\%(' . s:slash_pat . '\|$\)'

function! s:RenameComplete(A, L, P) abort
  let sep = s:separator()
  if a:A =~# s:absolute_pat
    let prefix = ''
  else
    let prefix = expand('%:h') . sep
  endif
  let files = split(glob(prefix.a:A.'*'), "\n")
  call map(files, 'fnameescape(strpart(v:val, len(prefix))) . (isdirectory(v:val) ? sep : "")')
  return files
endfunction

function! s:RenameArg(arg) abort
  if a:arg =~# s:absolute_pat
    return a:arg
  else
    return '%:h/' . a:arg
  endif
endfunction

command! -bar -nargs=1 -bang -complete=customlist,s:RenameComplete Duplicate
      \ exe 'Copy<bang>' escape(s:RenameArg(<q-args>), '"|')

command! -bar -nargs=1 -bang -complete=customlist,s:RenameComplete Rename
      \ exe 'Move<bang>' escape(s:RenameArg(<q-args>), '"|')

let s:permlookup = ['---','--x','-w-','-wx','r--','r-x','rw-','rwx']
function! s:Chmod(bang, perm, ...) abort
  let autocmd = 'silent doautocmd <nomodeline> User FileChmodPost'
  let file = a:0 ? expand(join(a:000, ' ')) : @%
  if !a:bang && exists('*setfperm')
    let perm = ''
    if a:perm =~# '^\0*[0-7]\{3\}$'
      let perm = substitute(a:perm[-3:-1], '.', '\=s:permlookup[submatch(0)]', 'g')
    elseif a:perm ==# '+x'
      let perm = substitute(s:fcall('getfperm', file), '\(..\).', '\1x', 'g')
    elseif a:perm ==# '-x'
      let perm = substitute(s:fcall('getfperm', file), '\(..\).', '\1-', 'g')
    endif
    if len(perm) && file =~# '^\a\a\+:' && !s:fcall('setfperm', file, perm)
      return autocmd
    endif
  endif
  if !executable('chmod')
    return 'echoerr "No chmod command in path"'
  endif
  let out = get(split(system('chmod '.(a:bang ? '-R ' : '').a:perm.' '.shellescape(file)), "\n"), 0, '')
  return len(out) ? 'echoerr ' . string(out) : autocmd
endfunction

command! -bar -bang -nargs=+ Chmod
      \ exe s:Chmod(<bang>0, <f-args>)

command! -bang -complete=file -nargs=+ Cfind   exe s:Grep(<q-bang>, <q-args>, 'find', '')
command! -bang -complete=file -nargs=+ Clocate exe s:Grep(<q-bang>, <q-args>, 'locate', '')
command! -bang -complete=file -nargs=+ Lfind   exe s:Grep(<q-bang>, <q-args>, 'find', 'l')
command! -bang -complete=file -nargs=+ Llocate exe s:Grep(<q-bang>, <q-args>, 'locate', 'l')
function! s:Grep(bang, args, prg, type) abort
  let grepprg = &l:grepprg
  let grepformat = &l:grepformat
  let shellpipe = &shellpipe
  try
    let &l:grepprg = a:prg
    setlocal grepformat=%f
    if &shellpipe ==# '2>&1| tee' || &shellpipe ==# '|& tee'
      let &shellpipe = "| tee"
    endif
    execute a:type.'grep! '.a:args
    if empty(a:bang) && !empty(getqflist())
      return 'cfirst'
    else
      return ''
    endif
  finally
    let &l:grepprg = grepprg
    let &l:grepformat = grepformat
    let &shellpipe = shellpipe
  endtry
endfunction

function! s:SilentSudoCmd(editor) abort
  let cmd = 'env SUDO_EDITOR=' . a:editor . ' VISUAL=' . a:editor . ' sudo -e'
  let local_nvim = has('nvim') && len($DISPLAY . $SECURITYSESSIONID . $TERM_PROGRAM)
  if !local_nvim && (!has('gui_running') || &guioptions =~# '!')
    redraw
    echo
    return ['silent', cmd]
  elseif !empty($SUDO_ASKPASS) ||
        \ filereadable('/etc/sudo.conf') &&
        \ len(filter(readfile('/etc/sudo.conf', '', 50), 'v:val =~# "^Path askpass "'))
    return ['silent', cmd . ' -A']
  else
    return [local_nvim ? 'silent' : '', cmd]
  endif
endfunction

augroup eunuch_sudo
augroup END

function! s:SudoSetup(file, resolve_symlink) abort
  let file = a:file
  if a:resolve_symlink && getftype(file) ==# 'link'
    let file = resolve(file)
    if file !=# a:file
      silent keepalt exe 'file' fnameescape(file)
    endif
  endif
  let file = substitute(file, s:slash_pat, '/', 'g')
  if file !~# '^\a\+:\|^/'
    let file = substitute(getcwd(), s:slash_pat, '/', 'g') . '/' . file
  endif
  if !filereadable(file) && !exists('#eunuch_sudo#BufReadCmd#'.fnameescape(file))
    execute 'autocmd eunuch_sudo BufReadCmd ' fnameescape(file) 'exe s:SudoReadCmd()'
  endif
  if !filewritable(file) && !exists('#eunuch_sudo#BufWriteCmd#'.fnameescape(file))
    execute 'autocmd eunuch_sudo BufReadPost' fnameescape(file) 'set noreadonly'
    execute 'autocmd eunuch_sudo BufWriteCmd' fnameescape(file) 'exe s:SudoWriteCmd()'
  endif
endfunction

let s:error_file = tempname()

function! s:SudoError() abort
  let error = join(readfile(s:error_file), " | ")
  if error =~# '^sudo' || v:shell_error
    return len(error) ? error : 'Error invoking sudo'
  else
    return error
  endif
endfunction

function! s:SudoReadCmd() abort
  if &shellpipe =~ '|&'
    return 'echoerr ' . string('eunuch.vim: no sudo read support for csh')
  endif
  silent %delete_
  silent doautocmd <nomodeline> BufReadPre
  let [silent, cmd] = s:SilentSudoCmd('cat')
  execute silent 'read !' . cmd . ' "%" 2> ' . s:error_file
  let exit_status = v:shell_error
  silent 1delete_
  setlocal nomodified
  if exit_status
    return 'echoerr ' . string(s:SudoError())
  else
    return 'silent doautocmd BufReadPost'
  endif
endfunction

function! s:SudoWriteCmd() abort
  silent doautocmd <nomodeline> BufWritePre
  let [silent, cmd] = s:SilentSudoCmd(shellescape('sh -c cat>"$0"'))
  execute silent 'write !' . cmd . ' "%" 2> ' . s:error_file
  let error = s:SudoError()
  if !empty(error)
    return 'echoerr ' . string(error)
  else
    setlocal nomodified
    return 'silent doautocmd <nomodeline> BufWritePost'
  endif
endfunction

command! -bar -bang -complete=file -nargs=? SudoEdit
      \ let s:arg = resolve(<q-args>) |
      \ call s:SudoSetup(fnamemodify(empty(s:arg) ? @% : s:arg, ':p'), empty(s:arg) && <bang>0) |
      \ if !&modified || !empty(s:arg) || <bang>0 |
      \   exe 'edit<bang>' fnameescape(s:arg) |
      \ endif |
      \ if empty(<q-args>) || expand('%:p') ==# fnamemodify(s:arg, ':p') |
      \   set noreadonly |
      \ endif |
      \ unlet s:arg

if exists(':SudoWrite') != 2
command! -bar -bang SudoWrite
      \ call s:SudoSetup(expand('%:p'), <bang>0) |
      \ setlocal noreadonly |
      \ write!
endif

command! -bar -nargs=? Wall
      \ if empty(<q-args>) |
      \   call s:Wall() |
      \ else |
      \   call system('wall', <q-args>) |
      \ endif
if exists(':W') !=# 2
  command! -bar W Wall
endif
function! s:Wall() abort
  let tab = tabpagenr()
  let win = winnr()
  let seen = {}
  if !&readonly && &buftype =~# '^\%(acwrite\)\=$' && expand('%') !=# ''
    let seen[bufnr('')] = 1
    write
  endif
  tabdo windo if !&readonly && &buftype =~# '^\%(acwrite\)\=$' && expand('%') !=# '' && !has_key(seen, bufnr('')) | silent write | let seen[bufnr('')] = 1 | endif
  execute 'tabnext '.tab
  execute win.'wincmd w'
endfunction

" Adapted from autoload/dist/script.vim.
let s:interpreters = {
      \ '.': '/bin/sh',
      \ 'sh': '/bin/sh',
      \ 'bash': 'bash',
      \ 'csh': 'csh',
      \ 'tcsh': 'tcsh',
      \ 'zsh': 'zsh',
      \ 'tcl': 'tclsh',
      \ 'expect': 'expect',
      \ 'gnuplot': 'gnuplot',
      \ 'make': 'make -f',
      \ 'pike': 'pike',
      \ 'lua': 'lua',
      \ 'perl': 'perl',
      \ 'php': 'php',
      \ 'python': 'python3',
      \ 'groovy': 'groovy',
      \ 'raku': 'raku',
      \ 'ruby': 'ruby',
      \ 'javascript': 'node',
      \ 'bc': 'bc',
      \ 'sed': 'sed',
      \ 'ocaml': 'ocaml',
      \ 'awk': 'awk',
      \ 'wml': 'wml',
      \ 'scheme': 'scheme',
      \ 'cfengine': 'cfengine',
      \ 'erlang': 'escript',
      \ 'haskell': 'haskell',
      \ 'scala': 'scala',
      \ 'clojure': 'clojure',
      \ 'pascal': 'instantfpc',
      \ 'fennel': 'fennel',
      \ 'routeros': 'rsc',
      \ 'fish': 'fish',
      \ 'forth': 'gforth',
      \ }

function! s:NormalizeInterpreter(str) abort
  if empty(a:str) || a:str =~# '^[ /]'
    return a:str
  elseif a:str =~# '[ \''"#]'
    return '/usr/bin/env -S ' . a:str
  else
    return '/usr/bin/env ' . a:str
  endif
endfunction

function! s:FileTypeInterpreter() abort
  try
    let ft = get(split(&filetype, '\.'), 0, '.')
    let configured = get(g:, 'eunuch_interpreters', {})
    if type(get(configured, ft)) == type(function('tr'))
      return call(configured[ft], [])
    elseif get(configured, ft) is# 1 || get(configured, ft) is# get(v:, 'true', 1)
      return ft ==# '.' ? s:interpreters['.'] : '/usr/bin/env ' . ft
    elseif empty(get(configured, ft, 1))
      return ''
    elseif type(get(configured, ft)) == type('')
      return s:NormalizeInterpreter(get(configured, ft))
    endif
    return s:NormalizeInterpreter(get(s:interpreters, ft, ''))
  endtry
endfunction

let s:shebang_pat = '^#!\s*[/[:alnum:]_-]'

function! EunuchNewLine(...) abort
  if a:0 && type(a:1) == type('')
    return a:1 . (a:1 =~# "\r" && empty(&buftype) ? "\<C-R>=EunuchNewLine()\r" : "")
  endif
  if !empty(&buftype) || getline(1) !~# '^#!$\|' . s:shebang_pat || line('.') != 2 || getline(2) !~# '^#\=$'
    return ""
  endif
  let b:eunuch_chmod_shebang = 1
  let inject = ''
  let detect = 0
  let ret = empty(getline(2)) ? "" : "\<C-U>"
  if getline(1) ==# '#!'
    let inject = s:FileTypeInterpreter()
    let detect = !empty(inject) && empty(&filetype)
  else
    filetype detect
    if getline(1) =~# '^#![^ /].\{-\}[ \''"#]'
      let inject = '/usr/bin/env -S '
    elseif getline(1) =~# '^#![^ /]'
      let inject = '/usr/bin/env '
    endif
  endif
  if len(inject)
    let ret .= "\<Up>\<Right>\<Right>" . inject . "\<Home>\<Down>"
  endif
  if detect
    let ret .= "\<C-\>\<C-O>:filetype detect\r"
  endif
  return ret
endfunction

function! s:MapCR() abort
  imap <silent><script> <SID>EunuchNewLine <C-R>=EunuchNewLine()<CR>
  let map = maparg('<CR>', 'i', 0, 1)
  let rhs = substitute(get(map, 'rhs', ''), '\c<sid>', '<SNR>' . get(map, 'sid') . '_', 'g')
  if get(g:, 'eunuch_no_maps') || rhs =~# 'Eunuch' || get(map, 'buffer')
    return
  endif
  if get(map, 'expr')
    exe 'imap <script><silent><expr> <CR> EunuchNewLine(' . rhs . ')'
  elseif rhs =~? '^<cr>' && rhs !~? '<plug>'
    exe 'imap <silent><script> <CR>' rhs . '<SID>EunuchNewLine'
  elseif rhs =~? '^<cr>'
    exe 'imap <silent> <CR>' rhs . '<SID>EunuchNewLine'
  elseif empty(rhs)
    imap <script><silent><expr> <CR> EunuchNewLine("<Bslash>r")
  endif
endfunction
call s:MapCR()

augroup eunuch
  autocmd!
  autocmd BufNewFile  * let b:eunuch_chmod_shebang = 1
  autocmd BufReadPost * if getline(1) !~# '^#!\s*\S' | let b:eunuch_chmod_shebang = 1 | endif
  autocmd BufWritePost,FileWritePost * nested
        \ if exists('b:eunuch_chmod_shebang') && getline(1) =~# s:shebang_pat |
        \   call s:Chmod(0, '+x', '<afile>') |
        \   edit |
        \ endif |
        \ unlet! b:eunuch_chmod_shebang
  autocmd InsertLeave * nested if line('.') == 1 && getline(1) ==# @. && @. =~# s:shebang_pat |
        \ filetype detect | endif
  autocmd User FileChmodPost,FileUnlinkPost "
  autocmd VimEnter * call s:MapCR() |
        \ if has('patch-8.1.1113') || has('nvim-0.4') |
        \   exe 'autocmd eunuch InsertEnter * ++once call s:MapCR()' |
        \ endif
augroup END

" vim:set sw=2 sts=2:
