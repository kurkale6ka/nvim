" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.gitignore	[[[1
1
doc/tags
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
25
# 🌿 fern-renderer-nerdfont.vim

[![fern renderer](https://img.shields.io/badge/🌿%20fern-plugin-yellowgreen)](https://github.com/lambdalisue/fern.vim)

![Screenshot](https://user-images.githubusercontent.com/546312/92318275-83115f80-efbe-11ea-854e-78fe22ce2a35.png)

[fern.vim](https://github.com/lambdalisue/fern.vim) plugin which add file type icons through [lambdalisue/nerdfont.vim](https://github.com/lambdalisue/nerdfont.vim).

## Requirements

- [lambdalisue/nerdfont.vim](https://github.com/lambdalisue/nerdfont.vim)
- [Nerd Fonts](https://www.nerdfonts.com/)

## Usage

Set `"nerdfont"` to `g:fern#renderer` like:

```vim
let g:fern#renderer = "nerdfont"
```

## See also

- [lambdalisue/glyph-palette.vim](https://github.com/lambdalisue/glyph-palette.vim) - Apply individual colors on icons
- [lambdalisue/fern-renderer-devicons.vim](https://github.com/lambdalisue/fern-renderer-devicons.vim) - Use devicons instead
./autoload/fern/renderer/nerdfont.vim	[[[1
166
scriptencoding utf-8

let s:PATTERN = '^$~.*[]\'
let s:Config = vital#fern#import('Config')
let s:AsyncLambda = vital#fern#import('Async.Lambda')

let s:STATUS_NONE = g:fern#STATUS_NONE
let s:STATUS_COLLAPSED = g:fern#STATUS_COLLAPSED

function! fern#renderer#nerdfont#new() abort
  let default = fern#renderer#default#new()
  return extend(copy(default), {
        \ 'render': funcref('s:render'),
        \ 'syntax': funcref('s:syntax'),
        \ 'highlight': funcref('s:highlight'),
        \})
endfunction

function! s:render(nodes) abort
  let options = {
        \ 'leading': g:fern#renderer#nerdfont#leading,
        \ 'padding': g:fern#renderer#nerdfont#padding,
        \ 'root_symbol': g:fern#renderer#nerdfont#root_symbol,
        \ 'indent_markers': g:fern#renderer#nerdfont#indent_markers,
        \ 'root_leading': g:fern#renderer#nerdfont#root_leading,
        \}
  let base = len(a:nodes[0].__key)

  if options.indent_markers
    let length_nodes = len(a:nodes)
    let levels = {}

    for i in range(length_nodes - 1, 0, -1)
      let node = a:nodes[i]
      let node._renderer_nerdfont_level = len(node.__key) - base
      let node._renderer_nerdfont_last = get(levels, node._renderer_nerdfont_level, 0) isnot# 1 ? 1 : 0

      for key in keys(levels)
        if key > node._renderer_nerdfont_level
          let levels[key] = 0
        endif
      endfor

      let levels[node._renderer_nerdfont_level] = 1
    endfor

    for i in range(length_nodes)
      let node = a:nodes[i]
      let last_marker = i is# 0 ? [0] : a:nodes[i - 1]._renderer_nerdfont_marker
      let node._renderer_nerdfont_marker = [repeat([0], node._renderer_nerdfont_level)][0]
      let current_length = len(node._renderer_nerdfont_marker)

      for ii in range(min([len(last_marker), current_length]))
        let node._renderer_nerdfont_marker[ii] = last_marker[ii]
      endfor

      if node._renderer_nerdfont_last is# 1 && i isnot# 0
        let node._renderer_nerdfont_marker[current_length - 1] = 1
      endif
    endfor
  endif

  let Profile = fern#profile#start('fern#renderer#nerdfont#s:render')
  return s:AsyncLambda.map(copy(a:nodes), { v, -> s:render_node(v, base, options) })
        \.finally({ -> Profile() })
endfunction

function! s:syntax() abort
  syntax match FernLeaf   /\s*\zs.*[^/].*$/ transparent contains=FernLeafSymbol
  syntax match FernBranch /\s*\zs.*\/.*$/   transparent contains=FernBranchSymbol
  syntax match FernRoot   /\%1l.*/     transparent contains=FernRootSymbol
  execute printf(
        \ 'syntax match FernRootSymbol /%s/ contained nextgroup=FernRootText',
        \ escape(g:fern#renderer#nerdfont#root_symbol, s:PATTERN),
        \)

  syntax match FernLeafSymbol   /. / contained nextgroup=FernLeafText
  syntax match FernBranchSymbol /. / contained nextgroup=FernBranchText

  syntax match FernRootText   /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernLeafText   /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernBranchText /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernBadgeSep   //         contained conceal nextgroup=FernBadge
  syntax match FernBadge      /.*/         contained

  syntax match FernIndentMarkers /[│└]/
  setlocal concealcursor=nvic conceallevel=2
endfunction

function! s:highlight() abort
  highlight default link FernRootSymbol    Comment
  highlight default link FernRootText      Comment
  highlight default link FernLeafSymbol    Directory
  highlight default link FernLeafText      None
  highlight default link FernBranchSymbol  Statement
  highlight default link FernBranchText    Statement
  highlight default link FernIndentMarkers NonText
endfunction

function! s:render_node(node, base, options) abort
  let level = len(a:node.__key) - a:base
  if level is# 0
    let suffix = a:node.label =~# '/$' ? '' : '/'
    let padding = a:options.root_symbol ==# '' ? '' : a:options.padding
    return a:options.root_leading . a:options.root_symbol . padding . a:node.label . suffix . '' . a:node.badge
  endif
  let leading = ''

  if a:options.indent_markers
    let indent_length = len(a:node._renderer_nerdfont_marker)

    for i in range(indent_length)
      let indent = a:node._renderer_nerdfont_marker[i]

      if indent is# 0
        let leading = leading . '│ '
      elseif indent is# 1 && i is# indent_length - 1
        let leading = leading . '└ '
      else
        let leading = leading . '  '
      endif
    endfor
  else
    let leading = repeat(a:options.leading, level - 1)
  endif

  let symbol = s:get_node_symbol(a:node)
  let suffix = a:node.status ? '/' : ''
  return a:options.root_leading . leading . symbol . a:node.label . suffix . '' . a:node.badge
endfunction

function! s:get_node_symbol(node) abort
  if a:node.status is# s:STATUS_NONE
    let symbol = s:find(a:node.bufname, 0)
  elseif a:node.status is# s:STATUS_COLLAPSED
    let symbol = s:find(a:node.bufname, 'close')
  else
    let symbol = s:find(a:node.bufname, 'open')
  endif
  return symbol
endfunction

" Check if nerdfont has installed or not
try
  call nerdfont#find('')
  function! s:find(bufname, isdir) abort
    return nerdfont#find(a:bufname, a:isdir) . g:fern#renderer#nerdfont#padding
  endfunction
catch /^Vim\%((\a\+)\)\=:E117:/
  function! s:find(bufname, isdir) abort
    return a:isdir is# 0 ? '|  ' : a:isdir ==# 'open' ? '|- ' : '|+ '
  endfunction
  call fern#logger#error(
        \ 'nerdfont.vim is not installed. fern-renderer-nerdfont.vim requires nerdfont.vim',
        \)
endtry

call s:Config.config(expand('<sfile>:p'), {
      \ 'leading': ' ',
      \ 'padding': ' ',
      \ 'root_symbol': '',
      \ 'indent_markers': 0,
      \ 'root_leading': ' ',
      \})

let g:fern#renderer#nerdfont#root_leading = get(g:, 'fern#renderer#nerdfont#root_leading', g:fern#renderer#nerdfont#leading)
./doc/fern-renderer-nerdfont.txt	[[[1
91
*fern-renderer-nerdfont.txt*		fern plugin to render nerdfont

=============================================================================
CONTENTS				*fern-renderer-nerdfont-contents*

INTRODUCTION			|fern-renderer-nerdfont-introduction|
USAGE				|fern-renderer-nerdfont-usage|
INTERFACE			|fern-renderer-nerdfont-interface|
  VARIABLE			|fern-renderer-nerdfont-variable|
  COLORS			|fern-renderer-nerdfont-colors|


=============================================================================
INTRODUCTION				*fern-renderer-nerdfont-introduction*

*fern-renderer-nerdfont.vim* is a |fern.vim| plugin which add nerdfont
support.


=============================================================================
USAGE					*fern-renderer-nerdfont-usage*

Install https://github.com/lambdalisue/nerdfont.vim and set "nerdfont" to
|g:fern#renderer| like:
>
	let g:fern#renderer = "nerdfont"
<

=============================================================================
INTERFACE				*fern-renderer-nerdfont-interface*

-----------------------------------------------------------------------------
VARIABLE				*fern-renderer-nerdfont-variable*

*g:fern#renderer#nerdfont#leading*
	A |String| which is prepended to each node to indicates the nested
	level of the node.

	For example, when the value is "~~", the renderer output become:
>
	  root
	  |- deep
	  ~~|- alpha
	  ~~~~|- beta
	  ~~~~~~|  gamma
<
	Default: " "

*g:fern#renderer#nerdfont#padding*
	A |String| which is placed between the symobl and the label.
	Add more spaces to regulate the position of the label after the
	symbol.
	Default: " "

*g:fern#renderer#nerdfont#root_symbol*
	A |String| used as a symbol of root node.
	Default: ""

*g:fern#renderer#nerdfont#indent_markers*
	Set 1 to enable fern indent markers.
	Enabling this option may affect performance.
	Default: 0

*g:fern#renderer#nerdfont#root_leading*
	A |String| to add a lead (padding) in front
        of the root level nodes.
	Default: |g:fern#renderer#nerdfont#leading|

        Example, with root_leading set to "" (shown below with
        *number* set):
>
    1│root
    2│ file1.txt
    3│ file2.txt
<
        With root_leading set to "@  ":
>
    1│@  root
    2│@   file1.txt
    3│@   file2.txt
<

-----------------------------------------------------------------------------
COLORS				*fern-renderer-nerdfont-colors*

Use glyph-palette.vim to apply colors on Nerd Fonts.
https://github.com/lambdalisue/glyph-palette.vim


=============================================================================
vim:tw=78:fo=tcq2mM:ts=8:ft=help:norl
./plugin/fern_renderer_nerdfont.vim	[[[1
8
if exists('g:fern_renderer_nerdfont_loaded')
  finish
endif
let g:fern_renderer_nerdfont_loaded = 1

call extend(g:fern#renderers, {
      \ 'nerdfont': function('fern#renderer#nerdfont#new'),
      \})
