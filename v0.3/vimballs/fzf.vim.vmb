" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.gitattributes	[[[1
1
*.sh text eol=lf
./.github/FUNDING.yml	[[[1
1
github: junegunn
./.github/ISSUE_TEMPLATE.md	[[[1
25
<!-- ISSUES NOT FOLLOWING THIS TEMPLATE WILL BE CLOSED AND DELETED -->

<!-- Check all that apply [x] -->

- [ ] I have fzf 0.30.0 or above
- [ ] I have read through https://github.com/junegunn/fzf.vim/blob/master/README.md
- [ ] I have read through https://github.com/junegunn/fzf/blob/master/README-VIM.md
- [ ] I have read through the manual page of fzf (`man fzf`)
- [ ] I have searched through the existing issues

<!--

Before submitting
=================

- Make sure that you have the latest version of fzf and fzf.vim
- Check if your problem is reproducible with a minimal configuration

Start Vim with a minimal configuration
======================================

vim -Nu <(curl https://gist.githubusercontent.com/junegunn/6936bf79fedd3a079aeb1dd2f3c81ef5/raw)

-->

./.gitignore	[[[1
1
doc/tags
./LICENSE	[[[1
21
MIT License

Copyright (c) 2021 Junegunn Choi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
./README.md	[[[1
393
fzf :heart: vim
===============

Things you can do with [fzf][fzf] and Vim.

Rationale
---------

[fzf][fzf] itself is not a Vim plugin, and the official repository only
provides the [basic wrapper function][run] for Vim. It's up to the users to
write their own Vim commands with it. However, I've learned that many users of
fzf are not familiar with Vimscript and are looking for the "default"
implementation of the features they can find in the alternative Vim plugins.

This repository is a bundle of fzf-based commands and mappings extracted from
my [.vimrc][vimrc] to address such needs. They are *not* designed to be
flexible or configurable, and there's no guarantee of backward-compatibility.

Why you should use fzf on Vim
-----------------------------

Because you can and you love fzf.

fzf runs asynchronously and can be orders of magnitude faster than similar Vim
plugins. However, the benefit may not be noticeable if the size of the input
is small, which is the case for many of the commands provided here.
Nevertheless I wrote them anyway since it's really easy to implement custom
selector with fzf.

Installation
------------

fzf.vim depends on the basic Vim plugin of [the main fzf
repository][fzf-main], which means you need to **set up both "fzf" and
"fzf.vim" on Vim**. To learn more about fzf/Vim integration, see
[README-VIM][README-VIM].

[fzf-main]: https://github.com/junegunn/fzf
[README-VIM]: https://github.com/junegunn/fzf/blob/master/README-VIM.md

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
```

`fzf#install()` makes sure that you have the latest binary, but it's optional,
so you can omit it if you use a plugin manager that doesn't support hooks.

### Dependencies

- [fzf][fzf-main] 0.41.1 or above
- For syntax-highlighted preview, install [bat](https://github.com/sharkdp/bat)
- If [delta](https://github.com/dandavison/delta) is available, `GF?`,
  `Commits` and `BCommits` will use it to format `git diff` output.
- `Ag` requires [The Silver Searcher (ag)][ag]
- `Rg` requires [ripgrep (rg)][rg]
- `Tags` and `Helptags` require Perl

Commands
--------

| Command                | List                                                                                  |
| ---                    | ---                                                                                   |
| `:Files [PATH]`        | Files (runs `$FZF_DEFAULT_COMMAND` if defined)                                        |
| `:GFiles [OPTS]`       | Git files (`git ls-files`)                                                            |
| `:GFiles?`             | Git files (`git status`)                                                              |
| `:Buffers`             | Open buffers                                                                          |
| `:Colors`              | Color schemes                                                                         |
| `:Ag [PATTERN]`        | [ag][ag] search result (`ALT-A` to select all, `ALT-D` to deselect all)               |
| `:Rg [PATTERN]`        | [rg][rg] search result (`ALT-A` to select all, `ALT-D` to deselect all)               |
| `:RG [PATTERN]`        | [rg][rg] search result; relaunch ripgrep on every keystroke                           |
| `:Lines [QUERY]`       | Lines in loaded buffers                                                               |
| `:BLines [QUERY]`      | Lines in the current buffer                                                           |
| `:Tags [QUERY]`        | Tags in the project (`ctags -R`)                                                      |
| `:BTags [QUERY]`       | Tags in the current buffer                                                            |
| `:Marks`               | Marks                                                                                 |
| `:Jumps`               | Jumps                                                                                 |
| `:Windows`             | Windows                                                                               |
| `:Locate PATTERN`      | `locate` command output                                                               |
| `:History`             | `v:oldfiles` and open buffers                                                         |
| `:History:`            | Command history                                                                       |
| `:History/`            | Search history                                                                        |
| `:Snippets`            | Snippets ([UltiSnips][us])                                                            |
| `:Commits [LOG_OPTS]`  | Git commits (requires [fugitive.vim][f])                                              |
| `:BCommits [LOG_OPTS]` | Git commits for the current buffer; visual-select lines to track changes in the range |
| `:Commands`            | Commands                                                                              |
| `:Maps`                | Normal mode mappings                                                                  |
| `:Helptags`            | Help tags <sup id="a1">[1](#helptags)</sup>                                           |
| `:Filetypes`           | File types

- Most commands support `CTRL-T` / `CTRL-X` / `CTRL-V` key
  bindings to open in a new tab, a new split, or in a new vertical split
- Bang-versions of the commands (e.g. `Ag!`) will open fzf in fullscreen
- You can set `g:fzf_command_prefix` to give the same prefix to the commands
    - e.g. `let g:fzf_command_prefix = 'Fzf'` and you have `FzfFiles`, etc.

(<a name="helptags">1</a>: `Helptags` will shadow the command of the same name
from [pathogen][pat]. But its functionality is still available via `call
pathogen#helptags()`. [↩](#a1))

[pat]: https://github.com/tpope/vim-pathogen
[f]:   https://github.com/tpope/vim-fugitive

Customization
-------------

### Global options

Every command in fzf.vim internally calls `fzf#wrap` function of the main
repository which supports a set of global option variables. So please read
through [README-VIM][README-VIM] to learn more about them.

#### Preview window

Some commands will show the preview window on the right. You can customize the
behavior with `g:fzf_preview_window`. Here are some examples:

```vim
" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_preview_window = ['right,50%', 'ctrl-/']

" Preview window is hidden by default. You can toggle it with ctrl-/.
" It will show on the right with 50% width, but if the width is smaller
" than 70 columns, it will show above the candidate list
let g:fzf_preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

" fzf.vim needs bash to display the preview window.
" On Windows, fzf.vim will first see if bash is in $PATH, then if
" Git bash (C:\Program Files\Git\bin\bash.exe) is available.
" If you want it to use a different bash, set this variable.
" let g:fzf_preview_bash = 'C:\Git\bin\bash.exe'
```

### Command-local options

A few commands in fzf.vim can be customized with global option variables shown
below.

```vim
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'
```

### Advanced customization

#### Vim functions

Each command in fzf.vim is backed by a Vim function. You can override
a command or define a variation of it by calling its corresponding function.

| Command   | Vim function                                                           |
| ---       | ---                                                                    |
| `Files`   | `fzf#vim#files(dir, [spec dict], [fullscreen bool])`                   |
| `GFiles`  | `fzf#vim#gitfiles(git_options, [spec dict], [fullscreen bool])`        |
| `GFiles?` | `fzf#vim#gitfiles('?', [spec dict], [fullscreen bool])`                |
| `Buffers` | `fzf#vim#buffers([spec dict], [fullscreen bool])`                      |
| `Colors`  | `fzf#vim#colors([spec dict], [fullscreen bool])`                       |
| `Rg`      | `fzf#vim#grep(command, [spec dict], [fullscreen bool])`                |
| `RG`      | `fzf#vim#grep2(command_prefix, query, [spec dict], [fullscreen bool])` |
| ...       | ...                                                                    |

(We can see that the last two optional arguments of each function are
identical. They are directly passed to `fzf#wrap` function. If you haven't
read [README-VIM][README-VIM] already, please read it before proceeding.)

#### Example: Customizing `Files` command

This is the default definition of `Files` command:

```vim
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, <bang>0)
```

Let's say you want to a variation of it called `ProjectFiles` that only
searches inside `~/projects` directory. Then you can do it like this:

```vim
command! -bang ProjectFiles call fzf#vim#files('~/projects', <bang>0)
```

Or, if you want to override the command with different fzf options, just pass
a custom spec to the function.

```vim
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline']}, <bang>0)
```

Want a preview window?

```vim
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']}, <bang>0)
```

It kind of works, but you probably want a nicer previewer program than `cat`.
fzf.vim ships [a versatile preview script](bin/preview.sh) you can readily
use. It internally executes [bat](https://github.com/sharkdp/bat) for syntax
highlighting, so make sure to install it.

```vim
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
```

However, it's not ideal to hard-code the path to the script which can be
different in different circumstances. So in order to make it easier to set up
the previewer, fzf.vim provides `fzf#vim#with_preview` helper function.
Similarly to `fzf#wrap`, it takes a spec dictionary and returns a copy of it
with additional preview options.

```vim
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
```

You can just omit the spec argument if you only want the previewer.

```vim
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
```

#### Example: `git grep` wrapper

The following example implements `GGrep` command that works similarly to
predefined `Ag` or `Rg` using `fzf#vim#grep`.

- We set the base directory to git root by setting `dir` attribute in spec
  dictionary.
- [The preview script](bin/preview.sh) supports `grep` format
  (`FILE_PATH:LINE_NO:...`), so we can just wrap the spec with
  `fzf#vim#with_preview` as before to enable previewer.

```vim
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>),
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
```

Mappings
--------

| Mapping                            | Description                               |
| ---                                | ---                                       |
| `<plug>(fzf-maps-n)`               | Normal mode mappings                      |
| `<plug>(fzf-maps-i)`               | Insert mode mappings                      |
| `<plug>(fzf-maps-x)`               | Visual mode mappings                      |
| `<plug>(fzf-maps-o)`               | Operator-pending mappings                 |
| `<plug>(fzf-complete-word)`        | `cat /usr/share/dict/words`               |
| `<plug>(fzf-complete-path)`        | Path completion using `find` (file + dir) |
| `<plug>(fzf-complete-file)`        | File completion using `find`              |
| `<plug>(fzf-complete-line)`        | Line completion (all open buffers)        |
| `<plug>(fzf-complete-buffer-line)` | Line completion (current buffer only)     |

```vim
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
```

Completion functions
--------------------

| Function                                 | Description                           |
| ---                                      | ---                                   |
| `fzf#vim#complete#path(command, [spec])` | Path completion                       |
| `fzf#vim#complete#word([spec])`          | Word completion                       |
| `fzf#vim#complete#line([spec])`          | Line completion (all open buffers)    |
| `fzf#vim#complete#buffer_line([spec])`   | Line completion (current buffer only) |

```vim
" Path completion with custom source command
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" Word completion with custom spec with popup layout option
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
```

Custom completion
-----------------

`fzf#vim#complete` is a helper function for creating custom fuzzy completion
using fzf. If the first parameter is a command string or a Vim list, it will
be used as the source.

```vim
" Replace the default dictionary completion with fzf-based fuzzy completion
inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
```

For advanced uses, you can pass an options dictionary to the function. The set
of options is pretty much identical to that for `fzf#run` only with the
following exceptions:

- `reducer` (funcref)
    - Reducer transforms the output lines of fzf into a single string value
- `prefix` (string or funcref; default: `\k*$`)
    - Regular expression pattern to extract the completion prefix
    - Or a function to extract completion prefix
- Both `source` and `options` can be given as funcrefs that take the
  completion prefix as the argument and return the final value
- `sink` or `sink*` are ignored

```vim
" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))
```

### Reducer example

```vim
function! s:make_sentence(lines)
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

inoremap <expr> <c-x><c-s> fzf#vim#complete({
  \ 'source':  'cat /usr/share/dict/words',
  \ 'reducer': function('<sid>make_sentence'),
  \ 'options': '--multi --reverse --margin 15%,0',
  \ 'left':    20})
```

Status line of terminal buffer
------------------------------

When fzf starts in a terminal buffer (see [fzf/README-VIM.md][termbuf]), you
may want to customize the statusline of the containing buffer.

[termbuf]: https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf-inside-terminal-buffer

### Hide statusline

```vim
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
```

### Custom statusline

```vim
function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()
```

License
-------

MIT

[fzf]:   https://github.com/junegunn/fzf
[run]:   https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzfrun
[vimrc]: https://github.com/junegunn/dotfiles/blob/master/vimrc
[ag]:    https://github.com/ggreer/the_silver_searcher
[rg]:    https://github.com/BurntSushi/ripgrep
[us]:    https://github.com/SirVer/ultisnips
./autoload/fzf/vim/complete.vim	[[[1
164
" Copyright (c) 2015 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

let s:cpo_save = &cpo
set cpo&vim
let s:is_win = has('win32') || has('win64')

function! s:extend(base, extra)
  let base = copy(a:base)
  if has_key(a:extra, 'options')
    let extra = copy(a:extra)
    let extra.extra_options = remove(extra, 'options')
    return extend(base, extra)
  endif
  return extend(base, a:extra)
endfunction

if v:version >= 704
  function! s:function(name)
    return function(a:name)
  endfunction
else
  function! s:function(name)
    " By Ingo Karkat
    return function(substitute(a:name, '^s:', matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunction$'), ''))
  endfunction
endif

function! fzf#vim#complete#word(...)
  let sources = empty(&dictionary) ? ['/usr/share/dict/words'] : split(&dictionary, ',')
  return fzf#vim#complete(s:extend({
    \ 'source': 'cat ' . join(map(sources, 'shellescape(v:val)'))},
    \ get(a:000, 0, fzf#wrap())))
endfunction

" ----------------------------------------------------------------------------
" <plug>(fzf-complete-path)
" <plug>(fzf-complete-file)
" <plug>(fzf-complete-file-ag)
" ----------------------------------------------------------------------------
function! s:file_split_prefix(prefix)
  let expanded = expand(a:prefix)
  let slash = (s:is_win && !&shellslash) ? '\\' : '/'
  return isdirectory(expanded) ?
    \ [expanded,
    \  substitute(a:prefix, '[/\\]*$', slash, ''),
    \  ''] :
    \ [fnamemodify(expanded, ':h'),
    \  substitute(fnamemodify(a:prefix, ':h'), '[/\\]*$', slash, ''),
    \  fnamemodify(expanded, ':t')]
endfunction

function! s:file_source(prefix)
  let [dir, head, tail] = s:file_split_prefix(a:prefix)
  return printf(
    \ "cd %s && ".s:file_cmd." | sed %s",
    \ fzf#shellescape(dir), fzf#shellescape('s:^:'.(empty(a:prefix) || a:prefix == tail ? '' : head).':'))
endfunction

function! s:file_options(prefix)
  let [_, head, tail] = s:file_split_prefix(a:prefix)
  return ['--prompt', head, '--query', tail]
endfunction

function! s:fname_prefix(str)
  let isf = &isfname
  let white = []
  let black = []
  if isf =~ ',,,'
    call add(white, ',')
    let isf = substitute(isf, ',,,', ',', 'g')
  endif
  if isf =~ ',^,,'
    call add(black, ',')
    let isf = substitute(isf, ',^,,', ',', 'g')
  endif

  for token in split(isf, ',')
    let target = white
    if token[0] == '^'
      let target = black
      let token = token[1:]
    endif

    let ends = matchlist(token, '\(.\+\)-\(.\+\)')
    if empty(ends)
      call add(target, token)
    else
      let ends = map(ends[1:2], "len(v:val) == 1 ? char2nr(v:val) : str2nr(v:val)")
      for i in range(ends[0], ends[1])
        call add(target, nr2char(i))
      endfor
    endif
  endfor

  let prefix = a:str
  for offset in range(1, len(a:str))
    let char = a:str[len(a:str) - offset]
    if (char =~ '\w' || index(white, char) >= 0) && index(black, char) < 0
      continue
    endif
    let prefix = strpart(a:str, len(a:str) - offset + 1)
    break
  endfor

  return prefix
endfunction

function! fzf#vim#complete#path(command, ...)
  let s:file_cmd = a:command
  return fzf#vim#complete(s:extend({
  \ 'prefix':  s:function('s:fname_prefix'),
  \ 'source':  s:function('s:file_source'),
  \ 'options': s:function('s:file_options')}, get(a:000, 0, fzf#wrap())))
endfunction

" ----------------------------------------------------------------------------
" <plug>(fzf-complete-line)
" <plug>(fzf-complete-buffer-line)
" ----------------------------------------------------------------------------
function! s:reduce_line(lines)
  return join(split(a:lines[0], '\t\zs')[3:], '')
endfunction


function! fzf#vim#complete#line(...)
  let [display_bufnames, lines] = fzf#vim#_lines(0)
  let nth = display_bufnames ? 4 : 3
  return fzf#vim#complete(s:extend({
  \ 'prefix':  '^.*$',
  \ 'source':  lines,
  \ 'options': '--tiebreak=index --ansi --nth '.nth.'.. --tabstop=1',
  \ 'reducer': s:function('s:reduce_line')}, get(a:000, 0, fzf#wrap())))
endfunction

function! fzf#vim#complete#buffer_line(...)
  return fzf#vim#complete(s:extend({
  \ 'prefix': '^.*$',
  \ 'source': fzf#vim#_uniq(getline(1, '$'))}, get(a:000, 0, fzf#wrap())))
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

./autoload/fzf/vim.vim	[[[1
1599
" Copyright (c) 2017 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

let s:cpo_save = &cpo
set cpo&vim

" ------------------------------------------------------------------
" Common
" ------------------------------------------------------------------

let s:winpath = {}
function! s:winpath(path)
  if has_key(s:winpath, a:path)
    return s:winpath[a:path]
  endif

  let winpath = split(system('for %A in ("'.a:path.'") do @echo %~sA'), "\n")[0]
  let s:winpath[a:path] = winpath

  return winpath
endfunction

let s:warned = 0
function! s:bash()
  if exists('s:bash')
    return s:bash
  endif

  let custom_bash = get(g:, 'fzf_preview_bash', '')
  let git_bash = 'C:\Program Files\Git\bin\bash.exe'
  let candidates = filter(s:is_win ? [custom_bash, 'bash', git_bash] : [custom_bash, 'bash'], 'len(v:val)')

  let found = filter(map(copy(candidates), 'exepath(v:val)'), 'len(v:val)')
  if empty(found)
    if !s:warned
      call s:warn(printf('Preview window not supported (%s not found)', join(candidates, ', ')))
      let s:warned = 1
    endif
    let s:bash = ''
    return s:bash
  endif

  let s:bash = found[0]

  " Make 8.3 filename via cmd.exe
  if s:is_win
    let s:bash = s:winpath(s:bash)
  endif

  return s:bash
endfunction

function! s:escape_for_bash(path)
  if !s:is_win
    return fzf#shellescape(a:path)
  endif

  if !exists('s:is_linux_like_bash')
    call system(s:bash . ' -c "ls /mnt/[A-Za-z]"')
    let s:is_linux_like_bash = v:shell_error == 0
  endif

  let path = substitute(a:path, '\', '/', 'g')
  if s:is_linux_like_bash
    let path = substitute(path, '^\([A-Z]\):', '/mnt/\L\1', '')
  endif

  return escape(path, ' ')
endfunction

let s:min_version = '0.23.0'
let s:is_win = has('win32') || has('win64')
let s:is_wsl_bash = s:is_win && (exepath('bash') =~? 'Windows[/\\]system32[/\\]bash.exe$')
let s:layout_keys = ['window', 'up', 'down', 'left', 'right']
let s:bin_dir = expand('<sfile>:p:h:h:h').'/bin/'
let s:bin = {
\ 'preview': s:bin_dir.'preview.sh',
\ 'tags':    s:bin_dir.'tags.pl' }
let s:TYPE = {'bool': type(0), 'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([])}

let s:wide = 120
let s:checked = 0

function! s:check_requirements()
  if s:checked
    return
  endif

  if !exists('*fzf#run')
    throw "fzf#run function not found. You also need Vim plugin from the main fzf repository (i.e. junegunn/fzf *and* junegunn/fzf.vim)"
  endif
  if !exists('*fzf#exec')
    throw "fzf#exec function not found. You need to upgrade Vim plugin from the main fzf repository ('junegunn/fzf')"
  endif
  let s:checked = !empty(fzf#exec(s:min_version))
endfunction

function! s:extend_opts(dict, eopts, prepend)
  if empty(a:eopts)
    return
  endif
  if has_key(a:dict, 'options')
    if type(a:dict.options) == s:TYPE.list && type(a:eopts) == s:TYPE.list
      if a:prepend
        let a:dict.options = extend(copy(a:eopts), a:dict.options)
      else
        call extend(a:dict.options, a:eopts)
      endif
    else
      let all_opts = a:prepend ? [a:eopts, a:dict.options] : [a:dict.options, a:eopts]
      let a:dict.options = join(map(all_opts, 'type(v:val) == s:TYPE.list ? join(map(copy(v:val), "fzf#shellescape(v:val)")) : v:val'))
    endif
  else
    let a:dict.options = a:eopts
  endif
endfunction

function! s:merge_opts(dict, eopts)
  return s:extend_opts(a:dict, a:eopts, 0)
endfunction

function! s:prepend_opts(dict, eopts)
  return s:extend_opts(a:dict, a:eopts, 1)
endfunction

" [spec to wrap], [preview window expression], [toggle-preview keys...]
function! fzf#vim#with_preview(...)
  " Default spec
  let spec = {}
  let window = ''

  let args = copy(a:000)

  " Spec to wrap
  if len(args) && type(args[0]) == s:TYPE.dict
    let spec = copy(args[0])
    call remove(args, 0)
  endif

  if !executable(s:bash())
    return spec
  endif

  " Placeholder expression (TODO/TBD: undocumented)
  let placeholder = get(spec, 'placeholder', '{}')

  " g:fzf_preview_window
  if empty(args)
    let preview_args = get(g:, 'fzf_preview_window', ['', 'ctrl-/'])
    if empty(preview_args)
      let args = ['hidden']
    else
      " For backward-compatiblity
      let args = type(preview_args) == type('') ? [preview_args] : copy(preview_args)
    endif
  endif

  if len(args) && type(args[0]) == s:TYPE.string
    if len(args[0]) && args[0] !~# '^\(up\|down\|left\|right\|hidden\)'
      throw 'invalid preview window: '.args[0]
    endif
    let window = args[0]
    call remove(args, 0)
  endif

  let preview = []
  if len(window)
    let preview += ['--preview-window', window]
  endif
  if s:is_win
    if empty($MSWINHOME)
      let $MSWINHOME = $HOME
    endif
    if s:is_wsl_bash && $WSLENV !~# '[:]\?MSWINHOME\(\/[^:]*\)\?\(:\|$\)'
      let $WSLENV = 'MSWINHOME/u:'.$WSLENV
    endif
  endif
  let preview_cmd = s:bash() . ' ' . s:escape_for_bash(s:bin.preview)
  if len(placeholder)
    let preview += ['--preview', preview_cmd.' '.placeholder]
  end
  if &ambiwidth ==# 'double'
    let preview += ['--no-unicode']
  end

  if len(args)
    call extend(preview, ['--bind', join(map(args, 'v:val.":toggle-preview"'), ',')])
  endif
  call s:merge_opts(spec, preview)
  return spec
endfunction

function! s:remove_layout(opts)
  for key in s:layout_keys
    if has_key(a:opts, key)
      call remove(a:opts, key)
    endif
  endfor
  return a:opts
endfunction

function! s:reverse_list(opts)
  let tokens = map(split($FZF_DEFAULT_OPTS, '[^a-z-]'), 'substitute(v:val, "^--", "", "")')
  if index(tokens, 'reverse') < 0
    return extend(['--layout=reverse-list'], a:opts)
  endif
  return a:opts
endfunction

function! s:wrap(name, opts, bang)
  " fzf#wrap does not append --expect if sink or sink* is found
  let opts = copy(a:opts)
  let options = ''
  if has_key(opts, 'options')
    let options = type(opts.options) == s:TYPE.list ? join(opts.options) : opts.options
  endif
  if options !~ '--expect' && has_key(opts, 'sink*')
    let Sink = remove(opts, 'sink*')
    let wrapped = fzf#wrap(a:name, opts, a:bang)
    let wrapped['sink*'] = Sink
  else
    let wrapped = fzf#wrap(a:name, opts, a:bang)
  endif
  return wrapped
endfunction

function! s:strip(str)
  return substitute(a:str, '^\s*\|\s*$', '', 'g')
endfunction

function! s:chomp(str)
  return substitute(a:str, '\n*$', '', 'g')
endfunction

function! s:escape(path)
  let path = fnameescape(a:path)
  return s:is_win ? escape(path, '$') : path
endfunction

if v:version >= 704
  function! s:function(name)
    return function(a:name)
  endfunction
else
  function! s:function(name)
    " By Ingo Karkat
    return function(substitute(a:name, '^s:', matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunction$'), ''))
  endfunction
endif

function! s:get_color(attr, ...)
  let gui = has('termguicolors') && &termguicolors
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction

let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36}

function! s:csi(color, fg)
  let prefix = a:fg ? '38;' : '48;'
  if a:color[0] == '#'
    return prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
  endif
  return prefix.'5;'.a:color
endfunction

function! s:ansi(str, group, default, ...)
  let fg = s:get_color('fg', a:group)
  let bg = s:get_color('bg', a:group)
  let color = (empty(fg) ? s:ansi[a:default] : s:csi(fg, 1)) .
        \ (empty(bg) ? '' : ';'.s:csi(bg, 0))
  return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction

for s:color_name in keys(s:ansi)
  execute "function! s:".s:color_name."(str, ...)\n"
        \ "  return s:ansi(a:str, get(a:, 1, ''), '".s:color_name."')\n"
        \ "endfunction"
endfor

function! s:buflisted()
  return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
endfunction

function! s:fzf(name, opts, extra)
  call s:check_requirements()

  let [extra, bang] = [{}, 0]
  if len(a:extra) <= 1
    let first = get(a:extra, 0, 0)
    if type(first) == s:TYPE.dict
      let extra = first
    else
      let bang = first
    endif
  elseif len(a:extra) == 2
    let [extra, bang] = a:extra
  else
    throw 'invalid number of arguments'
  endif

  let extra  = copy(extra)
  let eopts  = has_key(extra, 'options') ? remove(extra, 'options') : ''
  let merged = extend(copy(a:opts), extra)
  call s:merge_opts(merged, eopts)
  return fzf#run(s:wrap(a:name, merged, bang))
endfunction

let s:default_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:action_for(key, ...)
  let default = a:0 ? a:1 : ''
  let Cmd = get(get(g:, 'fzf_action', s:default_action), a:key, default)
  return type(Cmd) == s:TYPE.string ? Cmd : default
endfunction

function! s:open(cmd, target)
  if stridx('edit', a:cmd) == 0 && fnamemodify(a:target, ':p') ==# expand('%:p')
    normal! m'
    return
  endif
  execute a:cmd s:escape(a:target)
endfunction

function! s:align_lists(lists)
  let maxes = {}
  for list in a:lists
    let i = 0
    while i < len(list)
      let maxes[i] = max([get(maxes, i, 0), len(list[i])])
      let i += 1
    endwhile
  endfor
  for list in a:lists
    call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
  endfor
  return a:lists
endfunction

function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction

function! s:fill_quickfix(list, ...)
  if len(a:list) > 1
    call setqflist(a:list)
    copen
    wincmd p
    if a:0
      execute a:1
    endif
  endif
endfunction

function! fzf#vim#_uniq(list)
  let visited = {}
  let ret = []
  for l in a:list
    if !empty(l) && !has_key(visited, l)
      call add(ret, l)
      let visited[l] = 1
    endif
  endfor
  return ret
endfunction

" ------------------------------------------------------------------
" Files
" ------------------------------------------------------------------
function! s:shortpath()
  let short = fnamemodify(getcwd(), ':~:.')
  if !has('win32unix')
    let short = pathshorten(short)
  endif
  let slash = (s:is_win && !&shellslash) ? '\' : '/'
  return empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
endfunction

function! fzf#vim#files(dir, ...)
  let args = {}
  if !empty(a:dir)
    if !isdirectory(expand(a:dir))
      return s:warn('Invalid directory')
    endif
    let slash = (s:is_win && !&shellslash) ? '\\' : '/'
    let dir = substitute(a:dir, '[/\\]*$', slash, '')
    let args.dir = dir
  else
    let dir = s:shortpath()
  endif

  let args.options = ['-m', '--prompt', strwidth(dir) < &columns / 2 - 20 ? dir : '> ']
  call s:merge_opts(args, get(g:, 'fzf_files_options', []))
  return s:fzf('files', args, a:000)
endfunction

" ------------------------------------------------------------------
" Lines
" ------------------------------------------------------------------
function! s:line_handler(lines)
  if len(a:lines) < 2
    return
  endif
  normal! m'
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd) && stridx('edit', cmd) < 0
    execute 'silent' cmd
  endif

  let keys = split(a:lines[1], '\t')
  execute 'buffer' keys[0]
  execute keys[2]
  normal! ^zvzz
endfunction

function! fzf#vim#_lines(all)
  let cur = []
  let rest = []
  let buf = bufnr('')
  let longest_name = 0
  let display_bufnames = &columns > s:wide
  if display_bufnames
    let bufnames = {}
    for b in s:buflisted()
      let bufnames[b] = pathshorten(fnamemodify(bufname(b), ":~:."))
      let longest_name = max([longest_name, len(bufnames[b])])
    endfor
  endif
  let len_bufnames = min([15, longest_name])
  for b in s:buflisted()
    let lines = getbufline(b, 1, "$")
    if empty(lines)
      let path = fnamemodify(bufname(b), ':p')
      let lines = filereadable(path) ? readfile(path) : []
    endif
    if display_bufnames
      let bufname = bufnames[b]
      if len(bufname) > len_bufnames + 1
        let bufname = '…' . bufname[-len_bufnames+1:]
      endif
      let bufname = printf(s:green("%".len_bufnames."s", "Directory"), bufname)
    else
      let bufname = ''
    endif
    let linefmt = s:blue("%2d\t", "TabLine")."%s".s:yellow("\t%4d ", "LineNr")."\t%s"
    call extend(b == buf ? cur : rest,
    \ filter(
    \   map(lines,
    \       '(!a:all && empty(v:val)) ? "" : printf(linefmt, b, bufname, v:key + 1, v:val)'),
    \   'a:all || !empty(v:val)'))
  endfor
  return [display_bufnames, extend(cur, rest)]
endfunction

function! fzf#vim#lines(...)
  let [display_bufnames, lines] = fzf#vim#_lines(1)
  let nth = display_bufnames ? 3 : 2
  let [query, args] = (a:0 && type(a:1) == type('')) ?
        \ [a:1, a:000[1:]] : ['', a:000]
  return s:fzf('lines', {
  \ 'source':  lines,
  \ 'sink*':   s:function('s:line_handler'),
  \ 'options': s:reverse_list(['+m', '--tiebreak=index', '--prompt', 'Lines> ', '--ansi', '--extended', '--nth='.nth.'..', '--tabstop=1', '--query', query])
  \}, args)
endfunction

" ------------------------------------------------------------------
" BLines
" ------------------------------------------------------------------
function! s:buffer_line_handler(lines)
  if len(a:lines) < 2
    return
  endif
  let qfl = []
  for line in a:lines[1:]
    let chunks = split(line, "\t", 1)
    let ln = chunks[0]
    let ltxt = join(chunks[1:], "\t")
    call add(qfl, {'filename': expand('%'), 'lnum': str2nr(ln), 'text': ltxt})
  endfor
  call s:fill_quickfix(qfl, 'cfirst')
  normal! m'
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd)
    execute 'silent' cmd
  endif

  execute split(a:lines[1], '\t')[0]
  normal! ^zvzz
endfunction

function! s:buffer_lines(query)
  let linefmt = s:yellow(" %4d ", "LineNr")."\t%s"
  let fmtexpr = 'printf(linefmt, v:key + 1, v:val)'
  let lines = getline(1, '$')
  if empty(a:query)
    return map(lines, fmtexpr)
  end
  return filter(map(lines, 'v:val =~ a:query ? '.fmtexpr.' : ""'), 'len(v:val)')
endfunction

function! fzf#vim#buffer_lines(...)
  let [query, args] = (a:0 && type(a:1) == type('')) ?
        \ [a:1, a:000[1:]] : ['', a:000]
  return s:fzf('blines', {
  \ 'source':  s:buffer_lines(query),
  \ 'sink*':   s:function('s:buffer_line_handler'),
  \ 'options': s:reverse_list(['+m', '--tiebreak=index', '--multi', '--prompt', 'BLines> ', '--ansi', '--extended', '--nth=2..', '--tabstop=1'])
  \}, args)
endfunction

" ------------------------------------------------------------------
" Colors
" ------------------------------------------------------------------
function! fzf#vim#colors(...)
  let colors = split(globpath(&rtp, "colors/*.vim"), "\n")
  if has('packages')
    let colors += split(globpath(&packpath, "pack/*/opt/*/colors/*.vim"), "\n")
  endif
  return s:fzf('colors', {
  \ 'source':  fzf#vim#_uniq(map(colors, "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')")),
  \ 'sink':    'colo',
  \ 'options': '+m --prompt="Colors> "'
  \}, a:000)
endfunction

" ------------------------------------------------------------------
" Locate
" ------------------------------------------------------------------
function! fzf#vim#locate(query, ...)
  return s:fzf('locate', {
  \ 'source':  'locate '.a:query,
  \ 'options': '-m --prompt "Locate> "'
  \}, a:000)
endfunction

" ------------------------------------------------------------------
" History[:/]
" ------------------------------------------------------------------
function! fzf#vim#_recent_files()
  return fzf#vim#_uniq(map(
    \ filter([expand('%')], 'len(v:val)')
    \   + filter(map(fzf#vim#_buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)')
    \   + filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"),
    \ 'fnamemodify(v:val, ":~:.")'))
endfunction

function! s:history_source(type)
  let max  = histnr(a:type)
  let fmt  = s:yellow(' %'.len(string(max)).'d ', 'Number')
  let list = filter(map(range(1, max), 'histget(a:type, - v:val)'), '!empty(v:val)')
  return extend([' :: Press '.s:magenta('CTRL-E', 'Special').' to edit'],
    \ map(list, 'printf(fmt, len(list) - v:key)." ".v:val'))
endfunction

nnoremap <plug>(-fzf-vim-do) :execute g:__fzf_command<cr>
nnoremap <plug>(-fzf-/) /
nnoremap <plug>(-fzf-:) :

function! s:history_sink(type, lines)
  if len(a:lines) < 2
    return
  endif

  let prefix = "\<plug>(-fzf-".a:type.')'
  let key  = a:lines[0]
  let item = matchstr(a:lines[1], ' *[0-9]\+ *\zs.*')
  if key == 'ctrl-e'
    call histadd(a:type, item)
    redraw
    call feedkeys(a:type."\<up>", 'n')
  else
    if a:type == ':'
      call histadd(a:type, item)
    endif
    let g:__fzf_command = "normal ".prefix.item."\<cr>"
    call feedkeys("\<plug>(-fzf-vim-do)")
  endif
endfunction

function! s:cmd_history_sink(lines)
  call s:history_sink(':', a:lines)
endfunction

function! fzf#vim#command_history(...)
  return s:fzf('history-command', {
  \ 'source':  s:history_source(':'),
  \ 'sink*':   s:function('s:cmd_history_sink'),
  \ 'options': '+m --ansi --prompt="Hist:> " --header-lines=1 --expect=ctrl-e --tiebreak=index'}, a:000)
endfunction

function! s:search_history_sink(lines)
  call s:history_sink('/', a:lines)
endfunction

function! fzf#vim#search_history(...)
  return s:fzf('history-search', {
  \ 'source':  s:history_source('/'),
  \ 'sink*':   s:function('s:search_history_sink'),
  \ 'options': '+m --ansi --prompt="Hist/> " --header-lines=1 --expect=ctrl-e --tiebreak=index'}, a:000)
endfunction

function! fzf#vim#history(...)
  return s:fzf('history-files', {
  \ 'source':  fzf#vim#_recent_files(),
  \ 'options': ['-m', '--header-lines', !empty(expand('%')), '--prompt', 'Hist> ']
  \}, a:000)
endfunction

" ------------------------------------------------------------------
" GFiles[?]
" ------------------------------------------------------------------

function! s:get_git_root(dir)
  let dir = len(a:dir) ? a:dir : substitute(split(expand('%:p:h'), '[/\\]\.git\([/\\]\|$\)')[0], '^fugitive://', '', '')
  let root = systemlist('git -C ' . fzf#shellescape(dir) . ' rev-parse --show-toplevel')[0]
  return v:shell_error ? '' : (len(a:dir) ? fnamemodify(a:dir, ':p') : root)
endfunction

function! s:version_requirement(val, min)
  for idx in range(0, len(a:min) - 1)
    let v = get(a:val, idx, 0)
    if     v < a:min[idx] | return 0
    elseif v > a:min[idx] | return 1
    endif
  endfor
  return 1
endfunction

function! s:git_version_requirement(...)
  if !exists('s:git_version')
    let s:git_version = map(split(split(system('git --version'))[2], '\.'), 'str2nr(v:val)')
  endif
  return s:version_requirement(s:git_version, a:000)
endfunction

function! fzf#vim#gitfiles(args, ...)
  let dir = get(get(a:, 1, {}), 'dir', '')
  let root = s:get_git_root(dir)
  if empty(root)
    return s:warn('Not in git repo')
  endif
  let prefix = 'git -C ' . fzf#shellescape(root) . ' '
  if a:args != '?'
    let source = prefix . 'ls-files -z ' . a:args
    if s:git_version_requirement(2, 31)
      let source .= ' --deduplicate'
    endif
    return s:fzf('gfiles', {
    \ 'source':  source,
    \ 'dir':     root,
    \ 'options': '-m --read0 --prompt "GitFiles> "'
    \}, a:000)
  endif

  " Here be dragons!
  " We're trying to access the common sink function that fzf#wrap injects to
  " the options dictionary.
  let bar = s:is_win ? '^|' : '|'
  let diff_prefix = 'git -C ' . s:escape_for_bash(root) . ' '
  let preview = printf(
    \ s:bash() . ' -c "if [[ {1} =~ M ]]; then %s; else %s {-1}; fi"',
    \ executable('delta')
      \ ? diff_prefix . 'diff -- {-1} ' . bar . ' delta --width $FZF_PREVIEW_COLUMNS --file-style=omit ' . bar . ' sed 1d'
      \ : diff_prefix . 'diff --color=always -- {-1} ' . bar . ' sed 1,4d',
    \ s:escape_for_bash(s:bin.preview))
  let wrapped = fzf#wrap({
  \ 'source':  prefix . '-c color.status=always status --short --untracked-files=all',
  \ 'dir':     root,
  \ 'options': ['--ansi', '--multi', '--nth', '2..,..', '--tiebreak=index', '--prompt', 'GitFiles?> ', '--preview', preview]
  \})
  call s:remove_layout(wrapped)
  let wrapped.common_sink = remove(wrapped, 'sink*')
  function! wrapped.newsink(lines)
    let lines = extend(a:lines[0:0], map(a:lines[1:], 'substitute(v:val[3:], ".* -> ", "", "")'))
    return self.common_sink(lines)
  endfunction
  let wrapped['sink*'] = remove(wrapped, 'newsink')
  return s:fzf('gfiles-diff', wrapped, a:000)
endfunction

" ------------------------------------------------------------------
" Buffers
" ------------------------------------------------------------------
function! s:find_open_window(b)
  let [tcur, tcnt] = [tabpagenr() - 1, tabpagenr('$')]
  for toff in range(0, tabpagenr('$') - 1)
    let t = (tcur + toff) % tcnt + 1
    let buffers = tabpagebuflist(t)
    for w in range(1, len(buffers))
      let b = buffers[w - 1]
      if b == a:b
        return [t, w]
      endif
    endfor
  endfor
  return [0, 0]
endfunction

function! s:jump(t, w)
  execute a:t.'tabnext'
  execute a:w.'wincmd w'
endfunction

function! s:bufopen(lines)
  if len(a:lines) < 2
    return
  endif
  let b = matchstr(a:lines[1], '\[\zs[0-9]*\ze\]')
  if empty(a:lines[0]) && get(g:, 'fzf_buffers_jump')
    let [t, w] = s:find_open_window(b)
    if t
      call s:jump(t, w)
      return
    endif
  endif
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd)
    execute 'silent' cmd
  endif
  execute 'buffer' b
endfunction

function! fzf#vim#_format_buffer(b)
  let name = bufname(a:b)
  let line = exists('*getbufinfo') ? getbufinfo(a:b)[0]['lnum'] : 0
  let name = empty(name) ? '[No Name]' : fnamemodify(name, ":p:~:.")
  let flag = a:b == bufnr('')  ? s:blue('%', 'Conditional') :
          \ (a:b == bufnr('#') ? s:magenta('#', 'Special') : ' ')
  let modified = getbufvar(a:b, '&modified') ? s:red(' [+]', 'Exception') : ''
  let readonly = getbufvar(a:b, '&modifiable') ? '' : s:green(' [RO]', 'Constant')
  let extra = join(filter([modified, readonly], '!empty(v:val)'), '')
  let target = line == 0 ? name : name.':'.line
  return s:strip(printf("%s\t%d\t[%s] %s\t%s\t%s", target, line, s:yellow(a:b, 'Number'), flag, name, extra))
endfunction

function! s:sort_buffers(...)
  let [b1, b2] = map(copy(a:000), 'get(g:fzf#vim#buffers, v:val, v:val)')
  " Using minus between a float and a number in a sort function causes an error
  return b1 < b2 ? 1 : -1
endfunction

function! fzf#vim#_buflisted_sorted()
  return sort(s:buflisted(), 's:sort_buffers')
endfunction

function! fzf#vim#buffers(...)
  let [query, args] = (a:0 && type(a:1) == type('')) ?
        \ [a:1, a:000[1:]] : ['', a:000]
  let sorted = fzf#vim#_buflisted_sorted()
  let header_lines = '--header-lines=' . (bufnr('') == get(sorted, 0, 0) ? 1 : 0)
  let tabstop = len(max(sorted)) >= 4 ? 9 : 8
  return s:fzf('buffers', {
  \ 'source':  map(sorted, 'fzf#vim#_format_buffer(v:val)'),
  \ 'sink*':   s:function('s:bufopen'),
  \ 'options': ['+m', '-x', '--tiebreak=index', header_lines, '--ansi', '-d', '\t', '--with-nth', '3..', '-n', '2,1..2', '--prompt', 'Buf> ', '--query', query, '--preview-window', '+{2}-/2', '--tabstop', tabstop]
  \}, args)
endfunction

" ------------------------------------------------------------------
" Ag / Rg
" ------------------------------------------------------------------
function! s:ag_to_qf(line)
  let parts = matchlist(a:line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
  let dict = {'filename': &acd ? fnamemodify(parts[1], ':p') : parts[1], 'lnum': parts[2], 'text': parts[4]}
  if len(parts[3])
    let dict.col = parts[3]
  endif
  return dict
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2
    return
  endif

  let cmd = s:action_for(a:lines[0], 'e')
  let list = map(filter(a:lines[1:], 'len(v:val)'), 's:ag_to_qf(v:val)')
  if empty(list)
    return
  endif

  let first = list[0]
  try
    call s:open(cmd, first.filename)
    execute first.lnum
    if has_key(first, 'col')
      call cursor(0, first.col)
    endif
    normal! zvzz
  catch
  endtry

  call s:fill_quickfix(list)
endfunction

" query, [ag options], [spec (dict)], [fullscreen (bool)]
function! fzf#vim#ag(query, ...)
  if type(a:query) != s:TYPE.string
    return s:warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  let ag_opts = len(args) > 1 && type(args[0]) == s:TYPE.string ? remove(args, 0) : ''
  let command = ag_opts . ' -- ' . fzf#shellescape(query)
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction

" ag command suffix, [spec (dict)], [fullscreen (bool)]
function! fzf#vim#ag_raw(command_suffix, ...)
  if !executable('ag')
    return s:warn('ag is not found')
  endif
  return call('fzf#vim#grep', extend(['ag --nogroup --column --color '.a:command_suffix, 1], a:000))
endfunction

" command (string), [spec (dict)], [fullscreen (bool)]
function! fzf#vim#grep(grep_command, ...)
  let args = copy(a:000)
  let words = []
  for word in split(a:grep_command)
    if word !~# '^[a-z]'
      break
    endif
    call add(words, word)
  endfor
  let words   = empty(words) ? ['grep'] : words
  let name    = join(words, '-')
  let capname = join(map(words, 'toupper(v:val[0]).v:val[1:]'), '')
  let opts = {
  \ 'options': ['--ansi', '--prompt', capname.'> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--delimiter', ':', '--preview-window', '+{2}-/2']
  \}
  if len(args) && type(args[0]) == s:TYPE.bool
    call remove(args, 0)
  endif

  function! opts.sink(lines)
    return s:ag_handler(a:lines)
  endfunction
  let opts['sink*'] = remove(opts, 'sink')
  try
    let prev_default_command = $FZF_DEFAULT_COMMAND
    let $FZF_DEFAULT_COMMAND = a:grep_command
    return s:fzf(name, opts, args)
  finally
    let $FZF_DEFAULT_COMMAND = prev_default_command
  endtry
endfunction


" command_prefix (string), initial_query (string), [spec (dict)], [fullscreen (bool)]
function! fzf#vim#grep2(command_prefix, query, ...)
  let args = copy(a:000)
  let words = []
  for word in split(a:command_prefix)
    if word !~# '^[a-z]'
      break
    endif
    call add(words, word)
  endfor
  let words = empty(words) ? ['grep'] : words
  let name = join(words, '-')
  let opts = {
  \ 'source': ':',
  \ 'options': ['--ansi', '--prompt', toupper(name).'> ', '--query', a:query,
  \             '--disabled',
  \             '--bind', 'start:reload:'.a:command_prefix.' '.shellescape(a:query),
  \             '--bind', 'change:reload:'.a:command_prefix.' {q} || :',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--delimiter', ':', '--preview-window', '+{2}-/2']
  \}
  if len(args) && type(args[0]) == s:TYPE.bool
    call remove(args, 0)
  endif
  function! opts.sink(lines)
    return s:ag_handler(a:lines)
  endfunction
  let opts['sink*'] = remove(opts, 'sink')
  return s:fzf(name, opts, args)
endfunction

" ------------------------------------------------------------------
" BTags
" ------------------------------------------------------------------
function! s:btags_source(tag_cmds)
  if !filereadable(expand('%'))
    throw 'Save the file first'
  endif

  for cmd in a:tag_cmds
    let lines = split(system(cmd), "\n")
    if !v:shell_error && len(lines)
      break
    endif
  endfor
  if v:shell_error
    throw get(lines, 0, 'Failed to extract tags')
  elseif empty(lines)
    throw 'No tags found'
  endif
  return map(s:align_lists(map(lines, 'split(v:val, "\t")')), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(lines)
  if len(a:lines) < 2
    return
  endif
  normal! m'
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd)
    execute 'silent' cmd '%'
  endif
  let qfl = []
  for line in a:lines[1:]
    execute split(line, "\t")[2]
    call add(qfl, {'filename': expand('%'), 'lnum': line('.'), 'text': getline('.')})
  endfor
  call s:fill_quickfix(qfl, 'cfirst')
  normal! zvzz
endfunction

" query, [tag commands], [spec (dict)], [fullscreen (bool)]
function! fzf#vim#buffer_tags(query, ...)
  let args = copy(a:000)
  let escaped = fzf#shellescape(expand('%'))
  let null = s:is_win ? 'nul' : '/dev/null'
  let sort = has('unix') && !has('win32unix') && executable('sort') ? '| sort -s -k 5' : ''
  let tag_cmds = (len(args) > 1 && type(args[0]) != type({})) ? remove(args, 0) : [
    \ printf('ctags -f - --sort=yes --excmd=number --language-force=%s %s 2> %s %s', get({ 'cpp': 'c++' }, &filetype, &filetype), escaped, null, sort),
    \ printf('ctags -f - --sort=yes --excmd=number %s 2> %s %s', escaped, null, sort)]
  if type(tag_cmds) != type([])
    let tag_cmds = [tag_cmds]
  endif
  try
    return s:fzf('btags', {
    \ 'source':  s:btags_source(tag_cmds),
    \ 'sink*':   s:function('s:btags_sink'),
    \ 'options': s:reverse_list(['-m', '-d', '\t', '--with-nth', '1,4..', '-n', '1', '--prompt', 'BTags> ', '--query', a:query, '--preview-window', '+{3}-/2'])}, args)
  catch
    return s:warn(v:exception)
  endtry
endfunction

" ------------------------------------------------------------------
" Tags
" ------------------------------------------------------------------
function! s:tags_sink(lines)
  if len(a:lines) < 2
    return
  endif
  normal! m'
  let qfl = []
  let cmd = s:action_for(a:lines[0], 'e')
  try
    let [magic, &magic, wrapscan, &wrapscan, acd, &acd] = [&magic, 0, &wrapscan, 1, &acd, 0]
    for line in a:lines[1:]
      try
        let parts   = split(line, '\t\zs')
        let excmd   = matchstr(join(parts[2:-2], '')[:-2], '^.\{-}\ze;\?"\t')
        let base    = fnamemodify(parts[-1], ':h')
        let relpath = parts[1][:-2]
        let abspath = relpath =~ (s:is_win ? '^[A-Z]:\' : '^/') ? relpath : join([base, relpath], '/')
        call s:open(cmd, expand(abspath, 1))
        silent execute excmd
        call add(qfl, {'filename': expand('%'), 'lnum': line('.'), 'text': getline('.')})
      catch /^Vim:Interrupt$/
        break
      catch
        call s:warn(v:exception)
      endtry
    endfor
  finally
    let [&magic, &wrapscan, &acd] = [magic, wrapscan, acd]
  endtry
  call s:fill_quickfix(qfl, 'clast')
  normal! zvzz
endfunction

function! fzf#vim#tags(query, ...)
  if !executable('perl')
    return s:warn('Tags command requires perl')
  endif
  if empty(tagfiles())
    call inputsave()
    echohl WarningMsg
    let gen = input('tags not found. Generate? (y/N) ')
    echohl None
    call inputrestore()
    redraw
    if gen =~? '^y'
      call s:warn('Preparing tags')
      call system(get(g:, 'fzf_tags_command', 'ctags -R'.(s:is_win ? ' --output-format=e-ctags' : '')))
      if empty(tagfiles())
        return s:warn('Failed to create tags')
      endif
    else
      return s:warn('No tags found')
    endif
  endif

  let tagfiles = tagfiles()
  let v2_limit = 1024 * 1024 * 200
  for tagfile in tagfiles
    let v2_limit -= getfsize(tagfile)
    if v2_limit < 0
      break
    endif
  endfor
  let opts = v2_limit < 0 ? ['--algo=v1'] : []

  return s:fzf('tags', {
  \ 'source':  'perl '.fzf#shellescape(s:bin.tags).' '.join(map(tagfiles, 'fzf#shellescape(fnamemodify(v:val, ":p"))')),
  \ 'sink*':   s:function('s:tags_sink'),
  \ 'options': extend(opts, ['--nth', '1..2', '-m', '-d', '\t', '--tiebreak=begin', '--prompt', 'Tags> ', '--query', a:query])}, a:000)
endfunction

" ------------------------------------------------------------------
" Snippets (UltiSnips)
" ------------------------------------------------------------------
function! s:inject_snippet(line)
  let snip = split(a:line, "\t")[0]
  execute 'normal! a'.s:strip(snip)."\<c-r>=UltiSnips#ExpandSnippet()\<cr>"
endfunction

function! fzf#vim#snippets(...)
  if !exists(':UltiSnipsEdit')
    return s:warn('UltiSnips not found')
  endif
  let list = UltiSnips#SnippetsInCurrentScope()
  if empty(list)
    return s:warn('No snippets available here')
  endif
  let aligned = sort(s:align_lists(items(list)))
  let colored = map(aligned, 's:yellow(v:val[0])."\t".v:val[1]')
  return s:fzf('snippets', {
  \ 'source':  colored,
  \ 'options': '--ansi --tiebreak=index +m -n 1,.. -d "\t"',
  \ 'sink':    s:function('s:inject_snippet')}, a:000)
endfunction

" ------------------------------------------------------------------
" Commands
" ------------------------------------------------------------------
let s:nbs = nr2char(0xa0)

function! s:format_cmd(line)
  return substitute(a:line, '\C \([A-Z]\S*\) ',
        \ '\=s:nbs.s:yellow(submatch(1), "Function").s:nbs', '')
endfunction

function! s:command_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = matchstr(a:lines[1], s:nbs.'\zs\S*\ze'.s:nbs)
  if empty(a:lines[0])
    call feedkeys(':'.cmd.(a:lines[1][0] == '!' ? '' : ' '), 'n')
  else
    call feedkeys(':'.cmd."\<cr>", 'n')
  endif
endfunction

let s:fmt_excmd = '   '.s:blue('%-38s', 'Statement').'%s'

function! s:format_excmd(ex)
  let match = matchlist(a:ex, '^|:\(\S\+\)|\s*\S*\(.*\)')
  return printf(s:fmt_excmd, s:nbs.match[1].s:nbs, s:strip(match[2]))
endfunction

function! s:excmds()
  let help = globpath($VIMRUNTIME, 'doc/index.txt')
  if empty(help)
    return []
  endif

  let commands = []
  let command = ''
  for line in readfile(help)
    if line =~ '^|:[^|]'
      if !empty(command)
        call add(commands, s:format_excmd(command))
      endif
      let command = line
    elseif line =~ '^\s\+\S' && !empty(command)
      let command .= substitute(line, '^\s*', ' ', '')
    elseif !empty(commands) && line =~ '^\s*$'
      break
    endif
  endfor
  if !empty(command)
    call add(commands, s:format_excmd(command))
  endif
  return commands
endfunction

function! fzf#vim#commands(...)
  redir => cout
  silent command
  redir END
  let list = split(cout, "\n")
  return s:fzf('commands', {
  \ 'source':  extend(extend(list[0:0], map(list[1:], 's:format_cmd(v:val)')), s:excmds()),
  \ 'sink*':   s:function('s:command_sink'),
  \ 'options': '--ansi --expect '.get(g:, 'fzf_commands_expect', 'ctrl-x').
  \            ' --tiebreak=index --header-lines 1 -x --prompt "Commands> " -n2,3,2..3 -d'.s:nbs}, a:000)
endfunction

" ------------------------------------------------------------------
" Marks
" ------------------------------------------------------------------
function! s:format_mark(line)
  return substitute(a:line, '\S', '\=s:yellow(submatch(0), "Number")', '')
endfunction

function! s:mark_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd)
    execute 'silent' cmd
  endif
  execute 'normal! `'.matchstr(a:lines[1], '\S').'zz'
endfunction

function! fzf#vim#marks(...)
  redir => cout
  silent marks
  redir END
  let list = split(cout, "\n")
  return s:fzf('marks', {
  \ 'source':  extend(list[0:0], map(list[1:], 's:format_mark(v:val)')),
  \ 'sink*':   s:function('s:mark_sink'),
  \ 'options': '+m -x --ansi --tiebreak=index --header-lines 1 --tiebreak=begin --prompt "Marks> "'}, a:000)
endfunction

" ------------------------------------------------------------------
" Jumps
" ------------------------------------------------------------------
function! s:jump_format(line)
  return substitute(a:line, '[0-9]\+', '\=s:yellow(submatch(0), "Number")', '')
endfunction

function! s:jump_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd)
    execute 'silent' cmd
  endif
  let idx = index(s:jumplist, a:lines[1])
  if idx == -1
    return
  endif
  let current = match(s:jumplist, '\v^\s*\>')
  let delta = idx - current
  if delta < 0
    execute 'normal! ' . -delta . "\<C-O>"
  else
    execute 'normal! ' . delta . "\<C-I>"
  endif
endfunction

function! fzf#vim#jumps(...)
  redir => cout
  silent jumps
  redir END
  let s:jumplist = split(cout, '\n')
  let current = -match(s:jumplist, '\v^\s*\>')
  return s:fzf('jumps', {
  \ 'source'  : extend(s:jumplist[0:0], map(s:jumplist[1:], 's:jump_format(v:val)')),
  \ 'sink*'   : s:function('s:jump_sink'),
  \ 'options' : '+m -x --ansi --tiebreak=index --cycle --scroll-off 999 --sync --bind start:pos:'.current.' --tac --header-lines 1 --tiebreak=begin --prompt "Jumps> "',
  \ }, a:000)
endfunction

" ------------------------------------------------------------------
" Help tags
" ------------------------------------------------------------------
function! s:helptag_sink(line)
  let [tag, file, path] = split(a:line, "\t")[0:2]
  let rtp = fnamemodify(path, ':p:h:h')
  if stridx(&rtp, rtp) < 0
    execute 'set rtp+='.s:escape(rtp)
  endif
  execute 'help' tag
endfunction

function! fzf#vim#helptags(...)
  if !executable('perl')
    return s:warn('Helptags command requires perl')
  endif
  let sorted = sort(split(globpath(&runtimepath, 'doc/tags', 1), '\n'))
  let tags = exists('*uniq') ? uniq(sorted) : fzf#vim#_uniq(sorted)

  if exists('s:helptags_script')
    silent! call delete(s:helptags_script)
  endif
  let s:helptags_script = tempname()

  call writefile(['use Fatal qw(open close); for my $filename (@ARGV) { open(my $file,q(<),$filename); while (<$file>) { /(.*?)\t(.*?)\t(.*)/; push @lines, sprintf(qq('.s:green('%-40s', 'Label').'\t%s\t%s\t%s\n), $1, $2, $filename, $3); } close($file); } print for sort @lines;'], s:helptags_script)
  return s:fzf('helptags', {
  \ 'source': 'perl '.fzf#shellescape(s:helptags_script).' '.join(map(tags, 'fzf#shellescape(v:val)')),
  \ 'sink':    s:function('s:helptag_sink'),
  \ 'options': ['--ansi', '+m', '--tiebreak=begin', '--with-nth', '..3']}, a:000)
endfunction

" ------------------------------------------------------------------
" File types
" ------------------------------------------------------------------
function! fzf#vim#filetypes(...)
  return s:fzf('filetypes', {
  \ 'source':  fzf#vim#_uniq(sort(map(split(globpath(&rtp, 'syntax/*.vim'), '\n'),
  \            'fnamemodify(v:val, ":t:r")'))),
  \ 'sink':    'setf',
  \ 'options': '+m --prompt="File types> "'
  \}, a:000)
endfunction

" ------------------------------------------------------------------
" Windows
" ------------------------------------------------------------------
function! s:format_win(tab, win, buf)
  let modified = getbufvar(a:buf, '&modified')
  let name = bufname(a:buf)
  let name = empty(name) ? '[No Name]' : name
  let active = tabpagewinnr(a:tab) == a:win
  return (active? s:blue('> ', 'Operator') : '  ') . name . (modified? s:red(' [+]', 'Exception') : '')
endfunction

function! s:windows_sink(line)
  let list = matchlist(a:line, '^ *\([0-9]\+\) *\([0-9]\+\)')
  call s:jump(list[1], list[2])
endfunction

function! fzf#vim#windows(...)
  let lines = []
  for t in range(1, tabpagenr('$'))
    let buffers = tabpagebuflist(t)
    for w in range(1, len(buffers))
      call add(lines,
        \ printf('%s %s  %s',
            \ s:yellow(printf('%3d', t), 'Number'),
            \ s:cyan(printf('%3d', w), 'String'),
            \ s:format_win(t, w, buffers[w-1])))
    endfor
  endfor
  return s:fzf('windows', {
  \ 'source':  extend(['Tab Win    Name'], lines),
  \ 'sink':    s:function('s:windows_sink'),
  \ 'options': '+m --ansi --tiebreak=begin --header-lines=1'}, a:000)
endfunction

" ------------------------------------------------------------------
" Commits / BCommits
" ------------------------------------------------------------------
function! s:yank_to_register(data)
  let @" = a:data
  silent! let @* = a:data
  silent! let @+ = a:data
endfunction

function! s:commits_sink(lines)
  if len(a:lines) < 2
    return
  endif

  let pat = '[0-9a-f]\{7,9}'

  if a:lines[0] == 'ctrl-y'
    let hashes = join(filter(map(a:lines[1:], 'matchstr(v:val, pat)'), 'len(v:val)'))
    return s:yank_to_register(hashes)
  end

  let diff = a:lines[0] == 'ctrl-d'
  let cmd = s:action_for(a:lines[0], 'e')
  let buf = bufnr('')
  for idx in range(1, len(a:lines) - 1)
    let sha = matchstr(a:lines[idx], pat)
    if !empty(sha)
      if diff
        if idx > 1
          execute 'tab sb' buf
        endif
        execute 'Gdiff' sha
      else
        " Since fugitive buffers are unlisted, we can't keep using 'e'
        let c = (cmd == 'e' && idx > 1) ? 'tab split' : cmd
        execute c FugitiveFind(sha)
      endif
    endif
  endfor
endfunction

function! s:commits(range, buffer_local, args)
  let s:git_root = s:get_git_root('')
  if empty(s:git_root)
    return s:warn('Not in git repository')
  endif

  let prefix = 'git -C ' . fzf#shellescape(s:git_root) . ' '
  let source = prefix . 'log '.get(g:, 'fzf_commits_log_options', '--color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr'))
  let current = expand('%:p')
  let managed = 0
  if !empty(current)
    call system(prefix . 'show '.fzf#shellescape(current).' 2> '.(s:is_win ? 'nul' : '/dev/null'))
    let managed = !v:shell_error
  endif

  let args = copy(a:args)
  let log_opts = len(args) && type(args[0]) == type('') ? remove(args, 0) : ''

  if len(a:range) || a:buffer_local
    if !managed
      return s:warn('The current buffer is not in the working tree')
    endif
    let source .= len(a:range)
      \ ? join([printf(' -L %d,%d:%s --no-patch', a:range[0], a:range[1], fzf#shellescape(current)), log_opts])
      \ : join([' --follow', log_opts, fzf#shellescape(current)])
    let command = 'BCommits'
  else
    let source .= join([' --graph', log_opts])
    let command = 'Commits'
  endif

  let expect_keys = join(keys(get(g:, 'fzf_action', s:default_action)), ',')
  let options = {
  \ 'source':  source,
  \ 'sink*':   s:function('s:commits_sink'),
  \ 'options': s:reverse_list(['--ansi', '--multi', '--tiebreak=index',
  \   '--inline-info', '--prompt', command.'> ', '--bind=ctrl-s:toggle-sort',
  \   '--header', ':: Press '.s:magenta('CTRL-S', 'Special').' to toggle sort, '.s:magenta('CTRL-Y', 'Special').' to yank commit hashes',
  \   '--expect=ctrl-y,'.expect_keys])
  \ }

  if a:buffer_local
    let options.options[-2] .= ', '.s:magenta('CTRL-D', 'Special').' to diff'
    let options.options[-1] .= ',ctrl-d'
  endif

  if !s:is_win && &columns > s:wide
    let suffix = executable('delta') ? '| delta --width $FZF_PREVIEW_COLUMNS' : ''
    let orderfile = tempname()
    call writefile([current[len(s:git_root)+1:]], orderfile)
    call extend(options.options,
    \ ['--preview', 'echo {} | grep -o "[a-f0-9]\{7,\}" | head -1 | xargs ' . prefix . 'show -O'.fzf#shellescape(orderfile).' --format=format: --color=always ' . suffix])
  endif

  return s:fzf(a:buffer_local ? 'bcommits' : 'commits', options, args)
endfunction

" Heuristically determine if the user specified a range
function! s:given_range(line1, line2)
  " 1. From visual mode
  "   :'<,'>Commits
  " 2. From command-line
  "   :10,20Commits
  if a:line1 == line("'<") && a:line2 == line("'>") ||
        \ (a:line1 != 1 || a:line2 != line('$'))
    return [a:line1, a:line2]
  endif

  return []
endfunction

" [git-log-args], [spec (dict)], [fullscreen (bool)]
function! fzf#vim#commits(...) range
  if exists('b:fzf_winview')
    call winrestview(b:fzf_winview)
    unlet b:fzf_winview
  endif
  return s:commits(s:given_range(a:firstline, a:lastline), 0, a:000)
endfunction

" [git-log-args], [spec (dict)], [fullscreen (bool)]
function! fzf#vim#buffer_commits(...) range
  if exists('b:fzf_winview')
    call winrestview(b:fzf_winview)
    unlet b:fzf_winview
  endif
  return s:commits(s:given_range(a:firstline, a:lastline), 1, a:000)
endfunction

" ------------------------------------------------------------------
" fzf#vim#maps(mode, opts[with count and op])
" ------------------------------------------------------------------
function! s:align_pairs(list)
  let maxlen = 0
  let pairs = []
  for elem in a:list
    let match = matchlist(elem, '^\(\S*\)\s*\(.*\)$')
    let [_, k, v] = match[0:2]
    let maxlen = max([maxlen, len(k)])
    call add(pairs, [k, substitute(v, '^\*\?[@ ]\?', '', '')])
  endfor
  let maxlen = min([maxlen, 35])
  return map(pairs, "printf('%-'.maxlen.'s', v:val[0]).' '.v:val[1]")
endfunction

function! s:highlight_keys(str)
  return substitute(
        \ substitute(a:str, '<[^ >]\+>', s:yellow('\0', 'Special'), 'g'),
        \ '<Plug>', s:blue('<Plug>', 'SpecialKey'), 'g')
endfunction

function! s:key_sink(line)
  let key = matchstr(a:line, '^\S*')
  redraw
  call feedkeys(s:map_gv.s:map_cnt.s:map_reg, 'n')
  call feedkeys(s:map_op.
        \ substitute(key, '<[^ >]\+>', '\=eval("\"\\".submatch(0)."\"")', 'g'))
endfunction

function! fzf#vim#maps(mode, ...)
  let s:map_gv  = a:mode == 'x' ? 'gv' : ''
  let s:map_cnt = v:count == 0 ? '' : v:count
  let s:map_reg = empty(v:register) ? '' : ('"'.v:register)
  let s:map_op  = a:mode == 'o' ? v:operator : ''

  redir => cout
  silent execute 'verbose' a:mode.'map'
  redir END
  let list = []
  let curr = ''
  for line in split(cout, "\n")
    if line =~ "^\t"
      let src = "\t".substitute(matchstr(line, '/\zs[^/\\]*\ze$'), ' [^ ]* ', ':', '')
      call add(list, printf('%s %s', curr, s:green(src, 'Comment')))
      let curr = ''
    else
      if !empty(curr)
        call add(list, curr)
      endif
      let curr = line[3:]
    endif
  endfor
  if !empty(curr)
    call add(list, curr)
  endif
  let aligned = s:align_pairs(list)
  let sorted  = sort(aligned)
  let colored = map(sorted, 's:highlight_keys(v:val)')
  let pcolor  = a:mode == 'x' ? 9 : a:mode == 'o' ? 10 : 12
  return s:fzf('maps', {
  \ 'source':  colored,
  \ 'sink':    s:function('s:key_sink'),
  \ 'options': '--prompt "Maps ('.a:mode.')> " --ansi --no-hscroll --nth 1,.. --color prompt:'.pcolor}, a:000)
endfunction

" ----------------------------------------------------------------------------
" fzf#vim#complete - completion helper
" ----------------------------------------------------------------------------
inoremap <silent> <Plug>(-fzf-complete-trigger) <c-o>:call <sid>complete_trigger()<cr>

function! s:pluck(dict, key, default)
  return has_key(a:dict, a:key) ? remove(a:dict, a:key) : a:default
endfunction

function! s:complete_trigger()
  let opts = copy(s:opts)
  call s:prepend_opts(opts, ['+m', '-q', s:query])
  let opts['sink*'] = s:function('s:complete_insert')
  let s:reducer = s:pluck(opts, 'reducer', s:function('s:first_line'))
  call fzf#run(opts)
endfunction

" The default reducer
function! s:first_line(lines)
  return a:lines[0]
endfunction

function! s:complete_insert(lines)
  if empty(a:lines)
    return
  endif

  let chars = strchars(s:query)
  if     chars == 0 | let del = ''
  elseif chars == 1 | let del = '"_x'
  else              | let del = (chars - 1).'"_dvh'
  endif

  let data = call(s:reducer, [a:lines])
  let ve = &ve
  set ve=
  execute 'normal!' ((s:eol || empty(chars)) ? '' : 'h').del.(s:eol ? 'a': 'i').data
  let &ve = ve
  if mode() =~ 't'
    call feedkeys('a', 'n')
  elseif has('nvim')
    execute "normal! \<esc>la"
  else
    call feedkeys("\<Plug>(-fzf-complete-finish)")
  endif
endfunction

nnoremap <silent> <Plug>(-fzf-complete-finish) a
inoremap <silent> <Plug>(-fzf-complete-finish) <c-o>l

function! s:eval(dict, key, arg)
  if has_key(a:dict, a:key) && type(a:dict[a:key]) == s:TYPE.funcref
    let ret = copy(a:dict)
    let ret[a:key] = call(a:dict[a:key], [a:arg])
    return ret
  endif
  return a:dict
endfunction

function! fzf#vim#complete(...)
  if a:0 == 0
    let s:opts = fzf#wrap()
  elseif type(a:1) == s:TYPE.dict
    let s:opts = copy(a:1)
  elseif type(a:1) == s:TYPE.string
    let s:opts = extend({'source': a:1}, get(a:000, 1, fzf#wrap()))
  else
    echoerr 'Invalid argument: '.string(a:000)
    return ''
  endif
  for s in ['sink', 'sink*']
    if has_key(s:opts, s)
      call remove(s:opts, s)
    endif
  endfor

  let eol = col('$')
  let ve = &ve
  set ve=all
  let s:eol = col('.') == eol
  let &ve = ve

  let Prefix = s:pluck(s:opts, 'prefix', '\k*$')
  if col('.') == 1
    let s:query = ''
  else
    let full_prefix = getline('.')[0 : col('.')-2]
    if type(Prefix) == s:TYPE.funcref
      let s:query = call(Prefix, [full_prefix])
    else
      let s:query = matchstr(full_prefix, Prefix)
    endif
  endif
  let s:opts = s:eval(s:opts, 'source', s:query)
  let s:opts = s:eval(s:opts, 'options', s:query)
  let s:opts = s:eval(s:opts, 'extra_options', s:query)
  if has_key(s:opts, 'extra_options')
    call s:merge_opts(s:opts, remove(s:opts, 'extra_options'))
  endif
  if has_key(s:opts, 'options')
    if type(s:opts.options) == s:TYPE.list
      call add(s:opts.options, '--no-expect')
    else
      let s:opts.options .= ' --no-expect'
    endif
  endif

  call feedkeys("\<Plug>(-fzf-complete-trigger)")
  return ''
endfunction

" ------------------------------------------------------------------
let &cpo = s:cpo_save
unlet s:cpo_save
./bin/preview.rb	[[[1
3
#!/usr/bin/env ruby

puts 'preview.rb is deprecated. Use preview.sh instead.'
./bin/preview.sh	[[[1
83
#!/usr/bin/env bash

REVERSE="\x1b[7m"
RESET="\x1b[m"

if [ -z "$1" ]; then
  echo "usage: $0 [--tag] FILENAME[:LINENO][:IGNORED]"
  exit 1
fi

if [ "$1" = --tag ]; then
  shift
  "$(dirname "${BASH_SOURCE[0]}")/tagpreview.sh" "$@"
  exit $?
fi

IFS=':' read -r -a INPUT <<< "$1"
FILE=${INPUT[0]}
CENTER=${INPUT[1]}

if [[ "$1" =~ ^[A-Za-z]:\\ ]]; then
  FILE=$FILE:${INPUT[1]}
  CENTER=${INPUT[2]}
fi

if [[ -n "$CENTER" && ! "$CENTER" =~ ^[0-9] ]]; then
  exit 1
fi
CENTER=${CENTER/[^0-9]*/}

# MS Win support
if [[ "$FILE" =~ '\' ]]; then
  if [ -z "$MSWINHOME" ]; then
    MSWINHOME="$HOMEDRIVE$HOMEPATH"
  fi
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    MSWINHOME="${MSWINHOME//\\/\\\\}"
    FILE="${FILE/#\~\\/$MSWINHOME\\}"
    FILE=$(wslpath -u "$FILE")
  elif [ -n "$MSWINHOME" ]; then
    FILE="${FILE/#\~\\/$MSWINHOME\\}"
  fi
fi

FILE="${FILE/#\~\//$HOME/}"
if [ ! -r "$FILE" ]; then
  echo "File not found ${FILE}"
  exit 1
fi

if [ -z "$CENTER" ]; then
  CENTER=0
fi

# Sometimes bat is installed as batcat.
if command -v batcat > /dev/null; then
  BATNAME="batcat"
elif command -v bat > /dev/null; then
  BATNAME="bat"
fi

if [ -z "$FZF_PREVIEW_COMMAND" ] && [ "${BATNAME:+x}" ]; then
  ${BATNAME} --style="${BAT_STYLE:-numbers}" --color=always --pager=never \
      --highlight-line=$CENTER -- "$FILE"
  exit $?
fi

FILE_LENGTH=${#FILE}
MIME=$(file --dereference --mime -- "$FILE")
if [[ "${MIME:FILE_LENGTH}" =~ binary ]]; then
  echo "$MIME"
  exit 0
fi

DEFAULT_COMMAND="highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
CMD=${FZF_PREVIEW_COMMAND:-$DEFAULT_COMMAND}
CMD=${CMD//{\}/$(printf %q "$FILE")}

eval "$CMD" 2> /dev/null | awk "{ \
    if (NR == $CENTER) \
        { gsub(/\x1b[[0-9;]*m/, \"&$REVERSE\"); printf(\"$REVERSE%s\n$RESET\", \$0); } \
    else printf(\"$RESET%s\n\", \$0); \
    }"
./bin/tagpreview.sh	[[[1
73
#!/usr/bin/env bash

REVERSE="\x1b[7m"
RESET="\x1b[m"

if [ -z "$1" ]; then
  echo "usage: $0 FILENAME:TAGFILE:EXCMD"
  exit 1
fi

IFS=':' read -r FILE TAGFILE EXCMD <<< "$*"

# Complete file paths which are relative to the given tag file
if [ "${FILE:0:1}" != "/" ]; then
  FILE="$(dirname "${TAGFILE}")/${FILE}"
fi

if [ ! -r "$FILE" ]; then
  echo "File not found ${FILE}"
  exit 1
fi

# If users aren't using vim, they are probably using neovim
if command -v vim > /dev/null; then
  VIMNAME="vim"
elif command -v nvim > /dev/null; then
  VIMNAME="nvim"
else
  echo "Cannot preview tag: vim or nvim unavailable"
  exit 1
fi

CENTER="$("${VIMNAME}" -i NONE -u NONE -e -m -s "${FILE}" \
              -c "set nomagic" \
              -c "${EXCMD}" \
              -c 'let l=line(".") | new | put =l | print | qa!')" || return

START_LINE="$(( CENTER - FZF_PREVIEW_LINES / 2 ))"
if (( START_LINE <= 0 )); then
    START_LINE=1
fi
END_LINE="$(( START_LINE + FZF_PREVIEW_LINES - 1 ))"

# Sometimes bat is installed as batcat.
if command -v batcat > /dev/null; then
  BATNAME="batcat"
elif command -v bat > /dev/null; then
  BATNAME="bat"
fi

if [ -z "$FZF_PREVIEW_COMMAND" ] && [ "${BATNAME:+x}" ]; then
  ${BATNAME} --style="${BAT_STYLE:-numbers}" \
             --color=always \
             --pager=never \
             --wrap=never \
             --terminal-width="${FZF_PREVIEW_COLUMNS}" \
             --line-range="${START_LINE}:${END_LINE}" \
             --highlight-line="${CENTER}" \
             "$FILE"
  exit $?
fi

DEFAULT_COMMAND="highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
CMD=${FZF_PREVIEW_COMMAND:-$DEFAULT_COMMAND}
CMD=${CMD//{\}/$(printf %q "$FILE")}

eval "$CMD" 2> /dev/null | awk "{ \
    if (NR >= $START_LINE && NR <= $END_LINE) { \
        if (NR == $CENTER) \
            { gsub(/\x1b[[0-9;]*m/, \"&$REVERSE\"); printf(\"$REVERSE%s\n$RESET\", \$0); } \
        else printf(\"$RESET%s\n\", \$0); \
        } \
    }"
./bin/tags.pl	[[[1
15
#!/usr/bin/env perl

use strict;

foreach my $file (@ARGV) {
  open my $lines, $file;
  while (<$lines>) {
    unless (/^\!/) {
      s/^[^\t]*/sprintf("%-24s", $&)/e;
      s/$/\t$file/;
      print;
    }
  }
  close $lines;
}
./doc/fzf-vim.txt	[[[1
462
fzf-vim.txt	fzf-vim	Last change: June 4 2023
FZF-VIM - TABLE OF CONTENTS                                *fzf-vim* *fzf-vim-toc*
==============================================================================

  fzf :heart: vim                           |fzf-vim-fzfheart-vim|
    Rationale                               |fzf-vim-rationale|
    Why you should use fzf on Vim           |fzf-vim-why-you-should-use-fzf-on-vim|
    Installation                            |fzf-vim-installation|
      Using vim-plug                        |fzf-vim-using-vim-plug|
      Dependencies                          |fzf-vim-dependencies|
    Commands                                |fzf-vim-commands|
    Customization                           |fzf-vim-customization|
      Global options                        |fzf-vim-global-options|
        Preview window                      |fzf-vim-preview-window|
      Command-local options                 |fzf-vim-command-local-options|
      Advanced customization                |fzf-vim-advanced-customization|
        Vim functions                       |fzf-vim-vim-functions|
        Example: Customizing Files command  |fzf-vim-example-customizing-files-command|
        Example: git grep wrapper           |fzf-vim-example-git-grep-wrapper|
    Mappings                                |fzf-vim-mappings|
    Completion functions                    |fzf-vim-completion-functions|
    Custom completion                       |fzf-vim-custom-completion|
      Reducer example                       |fzf-vim-reducer-example|
    Status line of terminal buffer          |fzf-vim-status-line-of-terminal-buffer|
      Hide statusline                       |fzf-vim-hide-statusline|
      Custom statusline                     |fzf-vim-custom-statusline|
    License                                 |fzf-vim-license|

FZF :HEART: VIM                                           *fzf-vim-fzfheart-vim*
==============================================================================

Things you can do with {fzf}{1} and Vim.

                                           {1} https://github.com/junegunn/fzf


RATIONALE                                                    *fzf-vim-rationale*
==============================================================================

{fzf}{1} itself is not a Vim plugin, and the official repository only provides
the {basic wrapper function}{2} for Vim. It's up to the users to write their
own Vim commands with it. However, I've learned that many users of fzf are not
familiar with Vimscript and are looking for the "default" implementation of
the features they can find in the alternative Vim plugins.

This repository is a bundle of fzf-based commands and mappings extracted from
my {.vimrc}{3} to address such needs. They are not designed to be flexible or
configurable, and there's no guarantee of backward-compatibility.

          {1} https://github.com/junegunn/fzf
          {2} https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzfrun
          {3} https://github.com/junegunn/dotfiles/blob/master/vimrc


WHY YOU SHOULD USE FZF ON VIM            *fzf-vim-why-you-should-use-fzf-on-vim*
==============================================================================

Because you can and you love fzf.

fzf runs asynchronously and can be orders of magnitude faster than similar Vim
plugins. However, the benefit may not be noticeable if the size of the input
is small, which is the case for many of the commands provided here.
Nevertheless I wrote them anyway since it's really easy to implement custom
selector with fzf.


INSTALLATION                                              *fzf-vim-installation*
==============================================================================

fzf.vim depends on the basic Vim plugin of {the main fzf repository}{1}, which
means you need to set up both "fzf" and "fzf.vim" on Vim. To learn more about
fzf/Vim integration, see {README-VIM}{4}.

                 {1} https://github.com/junegunn/fzf
                 {4} https://github.com/junegunn/fzf/blob/master/README-VIM.md


< Using vim-plug >____________________________________________________________~
                                                        *fzf-vim-using-vim-plug*
>
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
<
`fzf#install()` makes sure that you have the latest binary, but it's optional,
so you can omit it if you use a plugin manager that doesn't support hooks.


< Dependencies >______________________________________________________________~
                                                          *fzf-vim-dependencies*

 - {fzf}{1} 0.41.1 or above
 - For syntax-highlighted preview, install {bat}{5}
 - If {delta}{6} is available, `GF?`, `Commits` and `BCommits` will use it to
   format `git diff` output.
 - `Ag` requires {The Silver Searcher (ag)}{7}
 - `Rg` requires {ripgrep (rg)}{8}
 - `Tags` and `Helptags` require Perl

                             {1} https://github.com/junegunn/fzf
                             {5} https://github.com/sharkdp/bat
                             {6} https://github.com/dandavison/delta
                             {7} https://github.com/ggreer/the_silver_searcher
                             {8} https://github.com/BurntSushi/ripgrep


COMMANDS                                                      *fzf-vim-commands*
==============================================================================

*:Files* *:GFiles* *:Buffers* *:Colors* *:Ag* *:Rg* *:RG* *:Lines* *:BLines* *:Tags* *:BTags* *:Marks*
 *:Jumps* *:Windows* *:Locate* *:History* *:Snippets* *:Commits* *:BCommits* *:Commands* *:Maps*
                                                          *:Helptags* *:Filetypes*

 -----------------------+--------------------------------------------------------------------------------------
 Command                | List                                                                                 ~
 -----------------------+--------------------------------------------------------------------------------------
  `:Files [PATH]`         | Files (runs  `$FZF_DEFAULT_COMMAND`  if defined)
  `:GFiles [OPTS]`        | Git files ( `git ls-files` )
  `:GFiles?`              | Git files ( `git status` )
  `:Buffers`              | Open buffers
  `:Colors`               | Color schemes
  `:Ag [PATTERN]`         | {ag}{7} search result ( `ALT-A`  to select all,  `ALT-D`  to deselect all)
  `:Rg [PATTERN]`         | {rg}{8} search result ( `ALT-A`  to select all,  `ALT-D`  to deselect all)
  `:RG [PATTERN]`         | {rg}{8} search result; relaunch ripgrep on every keystroke
  `:Lines [QUERY]`        | Lines in loaded buffers
  `:BLines [QUERY]`       | Lines in the current buffer
  `:Tags [QUERY]`         | Tags in the project ( `ctags -R` )
  `:BTags [QUERY]`        | Tags in the current buffer
  `:Marks`                | Marks
  `:Jumps`                | Jumps
  `:Windows`              | Windows
  `:Locate PATTERN`       |  `locate`  command output
  `:History`              |  `v:oldfiles`  and open buffers
  `:History:`             | Command history
  `:History/`             | Search history
  `:Snippets`             | Snippets ({UltiSnips}{9})
  `:Commits [LOG_OPTS]`   | Git commits (requires {fugitive.vim}{10})
  `:BCommits [LOG_OPTS]`  | Git commits for the current buffer; visual-select lines to track changes in the range
  `:Commands`             | Commands
  `:Maps`                 | Normal mode mappings
  `:Helptags`             | Help tags [1]
  `:Filetypes`            | File types
 -----------------------+--------------------------------------------------------------------------------------

                                                          *g:fzf_command_prefix*

 - Most commands support CTRL-T / CTRL-X / CTRL-V key bindings to open in a new
   tab, a new split, or in a new vertical split
 - Bang-versions of the commands (e.g. `Ag!`) will open fzf in fullscreen
 - You can set `g:fzf_command_prefix` to give the same prefix to the commands
   - e.g. `let g:fzf_command_prefix = 'Fzf'` and you have `FzfFiles`, etc.

(1: `Helptags` will shadow the command of the same name from {pathogen}{11}.
But its functionality is still available via `call pathogen#helptags()`. [↩])

                             {7} https://github.com/ggreer/the_silver_searcher
                             {8} https://github.com/BurntSushi/ripgrep
                             {8} https://github.com/BurntSushi/ripgrep
                             {9} https://github.com/SirVer/ultisnips
                             {10} https://github.com/tpope/vim-fugitive
                             {11} https://github.com/tpope/vim-pathogen


CUSTOMIZATION                                            *fzf-vim-customization*
==============================================================================


< Global options >____________________________________________________________~
                                                        *fzf-vim-global-options*

Every command in fzf.vim internally calls `fzf#wrap` function of the main
repository which supports a set of global option variables. So please read
through {README-VIM}{4} to learn more about them.

                 {4} https://github.com/junegunn/fzf/blob/master/README-VIM.md


Preview window~
                                                        *fzf-vim-preview-window*

                                                          *g:fzf_preview_window*

Some commands will show the preview window on the right. You can customize the
behavior with `g:fzf_preview_window`. Here are some examples:

                                                            *g:fzf_preview_bash*
>
    " This is the default option:
    "   - Preview window on the right with 50% width
    "   - CTRL-/ will toggle preview window.
    " - Note that this array is passed as arguments to fzf#vim#with_preview function.
    " - To learn more about preview window options, see `--preview-window` section of `man fzf`.
    let g:fzf_preview_window = ['right,50%', 'ctrl-/']

    " Preview window is hidden by default. You can toggle it with ctrl-/.
    " It will show on the right with 50% width, but if the width is smaller
    " than 70 columns, it will show above the candidate list
    let g:fzf_preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']

    " Empty value to disable preview window altogether
    let g:fzf_preview_window = []

    " fzf.vim needs bash to display the preview window.
    " On Windows, fzf.vim will first see if bash is in $PATH, then if
    " Git bash (C:\Program Files\Git\bin\bash.exe) is available.
    " If you want it to use a different bash, set this variable.
    " let g:fzf_preview_bash = 'C:\Git\bin\bash.exe'
<

< Command-local options >_____________________________________________________~
                                                 *fzf-vim-command-local-options*

A few commands in fzf.vim can be customized with global option variables shown
below.

            *g:fzf_commands_expect* *g:fzf_tags_command* *g:fzf_commits_log_options*
                                                            *g:fzf_buffers_jump*
>
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1

    " [[B]Commits] Customize the options used by 'git log':
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

    " [Tags] Command to generate tags file
    let g:fzf_tags_command = 'ctags -R'

    " [Commands] --expect expression for directly executing the command
    let g:fzf_commands_expect = 'alt-enter,ctrl-x'
<

< Advanced customization >____________________________________________________~
                                                *fzf-vim-advanced-customization*


Vim functions~
                                                         *fzf-vim-vim-functions*

Each command in fzf.vim is backed by a Vim function. You can override a
command or define a variation of it by calling its corresponding function.

 ----------+-----------------------------------------------------------------------
 Command   | Vim function                                                          ~
 ----------+-----------------------------------------------------------------------
  `Files`    |  `fzf#vim#files(dir, [spec dict], [fullscreen bool])`
  `GFiles`   |  `fzf#vim#gitfiles(git_options, [spec dict], [fullscreen bool])`
  `GFiles?`  |  `fzf#vim#gitfiles('?', [spec dict], [fullscreen bool])`
  `Buffers`  |  `fzf#vim#buffers([spec dict], [fullscreen bool])`
  `Colors`   |  `fzf#vim#colors([spec dict], [fullscreen bool])`
  `Rg`       |  `fzf#vim#grep(command, [spec dict], [fullscreen bool])`
  `RG`       |  `fzf#vim#grep2(command_prefix, query, [spec dict], [fullscreen bool])`
 ...       | ...
 ----------+-----------------------------------------------------------------------

(We can see that the last two optional arguments of each function are
identical. They are directly passed to `fzf#wrap` function. If you haven't
read {README-VIM}{4} already, please read it before proceeding.)

                 {4} https://github.com/junegunn/fzf/blob/master/README-VIM.md


Example: Customizing Files command~
                                     *fzf-vim-example-customizing-files-command*

This is the default definition of `Files` command:
>
    command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, <bang>0)
<
Let's say you want to a variation of it called `ProjectFiles` that only
searches inside `~/projects` directory. Then you can do it like this:
>
    command! -bang ProjectFiles call fzf#vim#files('~/projects', <bang>0)
<
Or, if you want to override the command with different fzf options, just pass
a custom spec to the function.
>
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline']}, <bang>0)
<
Want a preview window?
>
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']}, <bang>0)
<
It kind of works, but you probably want a nicer previewer program than `cat`.
fzf.vim ships {a versatile preview script}{12} you can readily use. It
internally executes {bat}{5} for syntax highlighting, so make sure to install
it.
>
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
<
However, it's not ideal to hard-code the path to the script which can be
different in different circumstances. So in order to make it easier to set up
the previewer, fzf.vim provides `fzf#vim#with_preview` helper function.
Similarly to `fzf#wrap`, it takes a spec dictionary and returns a copy of it
with additional preview options.
>
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
<
You can just omit the spec argument if you only want the previewer.
>
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
<
                                            {12} bin/preview.sh
                                            {5} https://github.com/sharkdp/bat


Example: git grep wrapper~
                                              *fzf-vim-example-git-grep-wrapper*

The following example implements `GGrep` command that works similarly to
predefined `Ag` or `Rg` using `fzf#vim#grep`.

                                                                         *:LINE*

 - We set the base directory to git root by setting `dir` attribute in spec
   dictionary.
 - {The preview script}{12} supports `grep` format (`FILE_PATH:LINE_NO:...`), so
   we can just wrap the spec with `fzf#vim#with_preview` as before to enable
   previewer.
>
    command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number -- '.shellescape(<q-args>),
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
<
                                                           {12} bin/preview.sh


MAPPINGS                                                      *fzf-vim-mappings*
==============================================================================

 ---------------------------------+------------------------------------------
 Mapping                          | Description                              ~
 ---------------------------------+------------------------------------------
 <plug>(fzf-maps-n)               | Normal mode mappings
 <plug>(fzf-maps-i)               | Insert mode mappings
 <plug>(fzf-maps-x)               | Visual mode mappings
 <plug>(fzf-maps-o)               | Operator-pending mappings
 <plug>(fzf-complete-word)        |  `cat /usr/share/dict/words`
 <plug>(fzf-complete-path)        | Path completion using  `find`  (file + dir)
 <plug>(fzf-complete-file)        | File completion using  `find`
 <plug>(fzf-complete-line)        | Line completion (all open buffers)
 <plug>(fzf-complete-buffer-line) | Line completion (current buffer only)
 ---------------------------------+------------------------------------------
>
    " Mapping selecting mappings
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)

    " Insert mode completion
    imap <c-x><c-k> <plug>(fzf-complete-word)
    imap <c-x><c-f> <plug>(fzf-complete-path)
    imap <c-x><c-l> <plug>(fzf-complete-line)
<

COMPLETION FUNCTIONS                              *fzf-vim-completion-functions*
==============================================================================

 -----------------------------------------+--------------------------------------
 Function                                 | Description                          ~
 -----------------------------------------+--------------------------------------
  `fzf#vim#complete#path(command, [spec])`  | Path completion
  `fzf#vim#complete#word([spec])`           | Word completion
  `fzf#vim#complete#line([spec])`           | Line completion (all open buffers)
  `fzf#vim#complete#buffer_line([spec])`    | Line completion (current buffer only)
 -----------------------------------------+--------------------------------------
>
    " Path completion with custom source command
    inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
    inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

    " Word completion with custom spec with popup layout option
    inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
<

CUSTOM COMPLETION                                    *fzf-vim-custom-completion*
==============================================================================

`fzf#vim#complete` is a helper function for creating custom fuzzy completion
using fzf. If the first parameter is a command string or a Vim list, it will
be used as the source.
>
    " Replace the default dictionary completion with fzf-based fuzzy completion
    inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
<
For advanced uses, you can pass an options dictionary to the function. The set
of options is pretty much identical to that for `fzf#run` only with the
following exceptions:

 - `reducer` (funcref)
   - Reducer transforms the output lines of fzf into a single string value
 - `prefix` (string or funcref; default: `\k*$`)
   - Regular expression pattern to extract the completion prefix
   - Or a function to extract completion prefix
 - Both `source` and `options` can be given as funcrefs that take the completion
   prefix as the argument and return the final value
 - `sink` or `sink*` are ignored
>
    " Global line completion (not just open buffers. ripgrep required.)
    inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
      \ 'prefix': '^.*$',
      \ 'source': 'rg -n ^ --color always',
      \ 'options': '--ansi --delimiter : --nth 3..',
      \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))
<

< Reducer example >___________________________________________________________~
                                                       *fzf-vim-reducer-example*
>
    function! s:make_sentence(lines)
      return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
    endfunction

    inoremap <expr> <c-x><c-s> fzf#vim#complete({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    20})
<

STATUS LINE OF TERMINAL BUFFER          *fzf-vim-status-line-of-terminal-buffer*
==============================================================================

When fzf starts in a terminal buffer (see {fzf/README-VIM.md}{13}), you may
want to customize the statusline of the containing buffer.

{13} https://github.com/junegunn/fzf/blob/master/README-VIM.md#fzf-inside-terminal-buffer


< Hide statusline >___________________________________________________________~
                                                       *fzf-vim-hide-statusline*
>
    autocmd! FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
<

< Custom statusline >_________________________________________________________~
                                                     *fzf-vim-custom-statusline*
>
    function! s:fzf_statusline()
      " Override statusline as you like
      highlight fzf1 ctermfg=161 ctermbg=251
      highlight fzf2 ctermfg=23 ctermbg=251
      highlight fzf3 ctermfg=237 ctermbg=251
      setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    endfunction

    autocmd! User FzfStatusLine call <SID>fzf_statusline()
<

LICENSE                                                        *fzf-vim-license*
==============================================================================

MIT


==============================================================================
vim:tw=78:sw=2:ts=2:ft=help:norl:nowrap:
./plugin/fzf.vim	[[[1
156
" Copyright (c) 2015 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists('g:loaded_fzf_vim')
  finish
endif
let g:loaded_fzf_vim = 1

let s:cpo_save = &cpo
set cpo&vim
let s:is_win = has('win32') || has('win64')

function! s:defs(commands)
  let prefix = get(g:, 'fzf_command_prefix', '')
  if prefix =~# '^[^A-Z]'
    echoerr 'g:fzf_command_prefix must start with an uppercase letter'
    return
  endif
  for command in a:commands
    let name = ':'.prefix.matchstr(command, '\C[A-Z]\S\+')
    if 2 != exists(name)
      execute substitute(command, '\ze\C[A-Z]', prefix, '')
    endif
  endfor
endfunction

call s:defs([
\'command!      -bang -nargs=? -complete=dir Files              call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)',
\'command!      -bang -nargs=? GitFiles                         call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == "?" ? { "placeholder": "" } : {}), <bang>0)',
\'command!      -bang -nargs=? GFiles                           call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == "?" ? { "placeholder": "" } : {}), <bang>0)',
\'command! -bar -bang -nargs=? -complete=buffer Buffers         call fzf#vim#buffers(<q-args>, fzf#vim#with_preview({ "placeholder": "{1}" }), <bang>0)',
\'command!      -bang -nargs=* Lines                            call fzf#vim#lines(<q-args>, <bang>0)',
\'command!      -bang -nargs=* BLines                           call fzf#vim#buffer_lines(<q-args>, <bang>0)',
\'command! -bar -bang Colors                                    call fzf#vim#colors(<bang>0)',
\'command!      -bang -nargs=+ -complete=dir Locate             call fzf#vim#locate(<q-args>, fzf#vim#with_preview(), <bang>0)',
\'command!      -bang -nargs=* Ag                               call fzf#vim#ag(<q-args>, fzf#vim#with_preview(), <bang>0)',
\'command!      -bang -nargs=* Rg                               call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)',
\'command!      -bang -nargs=* RG                               call fzf#vim#grep2("rg --column --line-number --no-heading --color=always --smart-case -- ", <q-args>, fzf#vim#with_preview(), <bang>0)',
\'command!      -bang -nargs=* Tags                             call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ "placeholder": "--tag {2}:{-1}:{3..}" }), <bang>0)',
\'command!      -bang -nargs=* BTags                            call fzf#vim#buffer_tags(<q-args>, fzf#vim#with_preview({ "placeholder": "{2}:{3..}" }), <bang>0)',
\'command! -bar -bang Snippets                                  call fzf#vim#snippets(<bang>0)',
\'command! -bar -bang Commands                                  call fzf#vim#commands(<bang>0)',
\'command! -bar -bang Jumps                                     call fzf#vim#jumps(<bang>0)',
\'command! -bar -bang Marks                                     call fzf#vim#marks(<bang>0)',
\'command! -bar -bang Helptags                                  call fzf#vim#helptags(fzf#vim#with_preview({ "placeholder": "--tag {2}:{3}:{4}" }), <bang>0)',
\'command! -bar -bang Windows                                   call fzf#vim#windows(<bang>0)',
\'command! -bar -bang -nargs=* -range=% -complete=file Commits  let b:fzf_winview = winsaveview() | <line1>,<line2>call fzf#vim#commits(<q-args>, fzf#vim#with_preview({ "placeholder": "" }), <bang>0)',
\'command! -bar -bang -nargs=* -range=% BCommits                let b:fzf_winview = winsaveview() | <line1>,<line2>call fzf#vim#buffer_commits(<q-args>, fzf#vim#with_preview({ "placeholder": "" }), <bang>0)',
\'command! -bar -bang Maps                                      call fzf#vim#maps("n", <bang>0)',
\'command! -bar -bang Filetypes                                 call fzf#vim#filetypes(<bang>0)',
\'command!      -bang -nargs=* History                          call s:history(<q-args>, fzf#vim#with_preview(), <bang>0)'])

function! s:history(arg, extra, bang)
  let bang = a:bang || a:arg[len(a:arg)-1] == '!'
  if a:arg[0] == ':'
    call fzf#vim#command_history(bang)
  elseif a:arg[0] == '/'
    call fzf#vim#search_history(bang)
  else
    call fzf#vim#history(a:extra, bang)
  endif
endfunction

function! fzf#complete(...)
  return call('fzf#vim#complete', a:000)
endfunction

if (has('nvim') || has('terminal') && has('patch-8.0.995')) && (get(g:, 'fzf_statusline', 1) || get(g:, 'fzf_nvim_statusline', 1))
  function! s:fzf_restore_colors()
    if exists('#User#FzfStatusLine')
      doautocmd User FzfStatusLine
    else
      if $TERM !~ "256color"
        highlight default fzf1 ctermfg=1 ctermbg=8 guifg=#E12672 guibg=#565656
        highlight default fzf2 ctermfg=2 ctermbg=8 guifg=#BCDDBD guibg=#565656
        highlight default fzf3 ctermfg=7 ctermbg=8 guifg=#D9D9D9 guibg=#565656
      else
        highlight default fzf1 ctermfg=161 ctermbg=238 guifg=#E12672 guibg=#565656
        highlight default fzf2 ctermfg=151 ctermbg=238 guifg=#BCDDBD guibg=#565656
        highlight default fzf3 ctermfg=252 ctermbg=238 guifg=#D9D9D9 guibg=#565656
      endif
      setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    endif
  endfunction

  function! s:fzf_vim_term()
    if get(w:, 'airline_active', 0)
      let w:airline_disabled = 1
      autocmd BufWinLeave <buffer> let w:airline_disabled = 0
    endif
    autocmd WinEnter,ColorScheme <buffer> call s:fzf_restore_colors()

    setlocal nospell
    call s:fzf_restore_colors()
  endfunction

  augroup _fzf_statusline
    autocmd!
    autocmd FileType fzf call s:fzf_vim_term()
  augroup END
endif

if !exists('g:fzf#vim#buffers')
  let g:fzf#vim#buffers = {}
endif

augroup fzf_buffers
  autocmd!
  if exists('*reltimefloat')
    autocmd BufWinEnter,WinEnter * let g:fzf#vim#buffers[bufnr('')] = reltimefloat(reltime())
  else
    autocmd BufWinEnter,WinEnter * let g:fzf#vim#buffers[bufnr('')] = localtime()
  endif
  autocmd BufDelete * silent! call remove(g:fzf#vim#buffers, expand('<abuf>'))
augroup END

inoremap <expr> <plug>(fzf-complete-word)        fzf#vim#complete#word()
if s:is_win
  inoremap <expr> <plug>(fzf-complete-path)      fzf#vim#complete#path('dir /s/b')
  inoremap <expr> <plug>(fzf-complete-file)      fzf#vim#complete#path('dir /s/b/a:-d')
else
  inoremap <expr> <plug>(fzf-complete-path)      fzf#vim#complete#path("find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'")
  inoremap <expr> <plug>(fzf-complete-file)      fzf#vim#complete#path("find . -path '*/\.*' -prune -o -type f -print -o -type l -print \| sed 's:^..::'")
endif
inoremap <expr> <plug>(fzf-complete-file-ag)     fzf#vim#complete#path('ag -l -g ""')
inoremap <expr> <plug>(fzf-complete-line)        fzf#vim#complete#line()
inoremap <expr> <plug>(fzf-complete-buffer-line) fzf#vim#complete#buffer_line()

nnoremap <silent> <plug>(fzf-maps-n) :<c-u>call fzf#vim#maps('n', 0)<cr>
inoremap <silent> <plug>(fzf-maps-i) <c-o>:call fzf#vim#maps('i', 0)<cr>
xnoremap <silent> <plug>(fzf-maps-x) :<c-u>call fzf#vim#maps('x', 0)<cr>
onoremap <silent> <plug>(fzf-maps-o) <c-c>:<c-u>call fzf#vim#maps('o', 0)<cr>

let &cpo = s:cpo_save
unlet s:cpo_save

