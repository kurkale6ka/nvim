" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./LICENSE	[[[1
22
Copyright (c) 2013 Caleb Spare

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
./README.md	[[[1
40
# vim-toml

Vim syntax for [TOML](https://github.com/toml-lang/toml). As of Neovim 0.6 and
Vim 8.2.3519, these runtime files are included in the main (Neo)Vim
distribution.

## Installation

### Vim packages (recommended; Vim 8+ only)

Clone or submodule this repo into your Vim packages location. Example:

```
git clone https://github.com/cespare/vim-toml.git ~/.vim/pack/plugins/start/vim-toml
```

### Pathogen

Set up [Pathogen](https://github.com/tpope/vim-pathogen) then clone/submodule
this repo into `~/.vim/bundle/toml`, or wherever you've pointed your Pathogen.

### Vundle

Set up [Vundle](https://github.com/VundleVim/Vundle.vim) then add `Plugin
'cespare/vim-toml'` to your vimrc and run `:PluginInstall` from a fresh vim.

### vim-plug

Set up [vim-plug](https://github.com/junegunn/vim-plug). In your .vimrc, between
the lines for `call plug#begin()` and `call plug#end()`, add the line `Plug
'cespare/vim-toml', { 'branch': 'main' }`. Reload your .vimrc and then run `:PlugInstall`.

### Janus

Set up [Janus](https://github.com/carlhuda/janus) and then clone/submodule this
repo into `~/.janus` and restart vim.

## Contributing

Contributions are very welcome! Just open a PR.
./ftdetect/toml.vim	[[[1
2
" Go dep and Rust use several TOML config files that are not named with .toml.
autocmd BufNewFile,BufRead *.toml,pdm.lock,Gopkg.lock,Cargo.lock,*/.cargo/config,*/.cargo/credentials,Pipfile set filetype=toml
./ftplugin/toml.vim	[[[1
23
" Vim filetype plugin
" Language:    TOML
" Homepage:    https://github.com/cespare/vim-toml
" Maintainer:  Aman Verma
" Author:      Kevin Ballard <kevin@sb.org>
" Last Change: Sep 21, 2021

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim
let b:undo_ftplugin = 'setlocal commentstring< comments<'

setlocal commentstring=#\ %s
setlocal comments=:#

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: et sw=2 sts=2
./syntax/toml.vim	[[[1
81
" Vim syntax file
" Language:            TOML
" Homepage:            https://github.com/cespare/vim-toml
" Maintainer:          Aman Verma
" Previous Maintainer: Caleb Spare <cespare@gmail.com>
" Last Change:         Oct 8, 2021

if exists('b:current_syntax')
  finish
endif

syn match tomlEscape /\\[btnfr"/\\]/ display contained
syn match tomlEscape /\\u\x\{4}/ contained
syn match tomlEscape /\\U\x\{8}/ contained
syn match tomlLineEscape /\\$/ contained

" Basic strings
syn region tomlString oneline start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=tomlEscape
" Multi-line basic strings
syn region tomlString start=/"""/ end=/"""/ contains=tomlEscape,tomlLineEscape
" Literal strings
syn region tomlString oneline start=/'/ end=/'/
" Multi-line literal strings
syn region tomlString start=/'''/ end=/'''/

syn match tomlInteger /[+-]\=\<[1-9]\(_\=\d\)*\>/ display
syn match tomlInteger /[+-]\=\<0\>/ display
syn match tomlInteger /[+-]\=\<0x[[:xdigit:]]\(_\=[[:xdigit:]]\)*\>/ display
syn match tomlInteger /[+-]\=\<0o[0-7]\(_\=[0-7]\)*\>/ display
syn match tomlInteger /[+-]\=\<0b[01]\(_\=[01]\)*\>/ display
syn match tomlInteger /[+-]\=\<\(inf\|nan\)\>/ display

syn match tomlFloat /[+-]\=\<\d\(_\=\d\)*\.\d\+\>/ display
syn match tomlFloat /[+-]\=\<\d\(_\=\d\)*\(\.\d\(_\=\d\)*\)\=[eE][+-]\=\d\(_\=\d\)*\>/ display

syn match tomlBoolean /\<\%(true\|false\)\>/ display

" https://tools.ietf.org/html/rfc3339
syn match tomlDate /\d\{4\}-\d\{2\}-\d\{2\}/ display
syn match tomlDate /\d\{2\}:\d\{2\}:\d\{2\}\%(\.\d\+\)\?/ display
syn match tomlDate /\d\{4\}-\d\{2\}-\d\{2\}[T ]\d\{2\}:\d\{2\}:\d\{2\}\%(\.\d\+\)\?\%(Z\|[+-]\d\{2\}:\d\{2\}\)\?/ display

syn match tomlDotInKey /\v[^.]+\zs\./ contained display
syn match tomlKey /\v(^|[{,])\s*\zs[[:alnum:]._-]+\ze\s*\=/ contains=tomlDotInKey display
syn region tomlKeyDq oneline start=/\v(^|[{,])\s*\zs"/ end=/"\ze\s*=/ contains=tomlEscape
syn region tomlKeySq oneline start=/\v(^|[{,])\s*\zs'/ end=/'\ze\s*=/

syn region tomlTable oneline start=/^\s*\[[^\[]/ end=/\]/ contains=tomlKey,tomlKeyDq,tomlKeySq,tomlDotInKey

syn region tomlTableArray oneline start=/^\s*\[\[/ end=/\]\]/ contains=tomlKey,tomlKeyDq,tomlKeySq,tomlDotInKey

syn region tomlKeyValueArray start=/=\s*\[\zs/ end=/\]/ contains=@tomlValue

syn region tomlArray start=/\[/ end=/\]/ contains=@tomlValue contained

syn cluster tomlValue contains=tomlArray,tomlString,tomlInteger,tomlFloat,tomlBoolean,tomlDate,tomlComment

syn keyword tomlTodo TODO FIXME XXX BUG contained

syn match tomlComment /#.*/ contains=@Spell,tomlTodo

hi def link tomlComment Comment
hi def link tomlTodo Todo
hi def link tomlTableArray Title
hi def link tomlTable Title
hi def link tomlDotInKey Normal
hi def link tomlKeySq Identifier
hi def link tomlKeyDq Identifier
hi def link tomlKey Identifier
hi def link tomlDate Constant
hi def link tomlBoolean Boolean
hi def link tomlFloat Float
hi def link tomlInteger Number
hi def link tomlString String
hi def link tomlLineEscape SpecialChar
hi def link tomlEscape SpecialChar

syn sync minlines=500
let b:current_syntax = 'toml'

" vim: et sw=2 sts=2
./test/test.toml	[[[1
35
# Visual test file.
# You can run
#
#     nnoremap <F10> <cmd>echo synIDattr(synID(line('.'), col('.'), 1), 'name')<CR>
#
# and then press F10 to get the highlight group under the cursor.

# https://github.com/cespare/vim-toml/issues/9
issue9 = [
  ["a", "b", "c"]
]

# https://github.com/cespare/vim-toml/issues/10
issue10_1 = -12
issue10_2 = +200.3

# https://github.com/cespare/vim-toml/issues/11
issue11 = -210_000.0

# https://github.com/cespare/vim-toml/issues/13
issue13 = { version="1.0", features=["derive"] }

# https://github.com/cespare/vim-toml/pull/52
[foo.baz]
apple.type = "fruit"
3.14159 = "pi"
"127.0.0.1" = "value"

[[foo.quux]]
e = 2

# https://github.com/cespare/vim-toml/issues/58
site."google.com" = true

# vim: et sw=2 sts=2
