" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./LICENSE	[[[1
20
Copyright 2020 Alisue, hashnote.net

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
27
# 🌿 fern-hijack.vim

[![fern plugin](https://img.shields.io/badge/🌿%20fern-plugin-yellowgreen)](https://github.com/lambdalisue/fern.vim)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20fern--hijack-orange.svg)](doc/fern-hijack.txt)

A plugin for [fern.vim](https://github.com/lambdalisue/fern.vim) to make the fern.vim as a default file explorer instead of Netrw.

## Usage

Just install the plugin then the default file explorer become fern.vim.
Uses can confirm that by:

```
:e .
```

Or from terminal:

```
vim .
```

## License

The code in fern-hijack.vim follows MIT license texted in [LICENSE](./LICENSE).
Contributors need to agree that any modifications sent in this repository follow the license.
./doc/.gitignore	[[[1
1
tags
./doc/fern-hijack.txt	[[[1
26
*fern-hijack.txt*	Use fern.vim as a default explorer instead of Netrw

Author:  Alisue <lambdalisue@hashnote.net>
License: MIT license

=============================================================================
CONTENTS					*fern-hijack-contents*

INTRODUCTION				|fern-hijack-introduction|

=============================================================================
INTRODUCTION					*fern-hijack-introduction*

*fern-hijack.vim* (fern-hijack) is a plugin to use fern.vim as a default
explorer instead of Netrw.

Installing this plugin automatically overwrite the default explorer. To
disable the feature, write the following code somewhere in your |vimrc|:
>
	let g:loaded_fern_hijack = 1
<
Or just uninstall the plugin.


=============================================================================
vim:tw=78:fo=tcq2mM:ts=8:ft=help:norl
./plugin/fern_hijack.vim	[[[1
34
if exists('g:loaded_fern_hijack') || ( !has('nvim') && v:version < 801 )
  finish
endif
let g:loaded_fern_hijack = 1

function! s:hijack_directory() abort
  let path = s:expand('%:p')
  if !isdirectory(path)
    return
  endif
  let bufnr = bufnr()
  execute printf('keepjumps keepalt Fern %s', fnameescape(path))
  execute printf('silent! bwipeout %d', bufnr)
endfunction

function! s:suppress_netrw() abort
  if exists('#FileExplorer')
    autocmd! FileExplorer *
  endif
endfunction

function! s:expand(expr) abort
  try
    return fern#util#expand(a:expr)
  catch /^Vim\%((\a\+)\)\=:E117:/
    return expand(a:expr)
  endtry
endfunction

augroup fern-hijack
  autocmd!
  autocmd VimEnter * call s:suppress_netrw()
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END
