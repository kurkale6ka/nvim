" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/workflows/reviewdog.yml	[[[1
22
name: reviewdog

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  vimlint:
    name: runner / vint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: vint
        uses: reviewdog/action-vint@v1
        with:
          github_token: ${{ secrets.github_token }}
          level: error
          reporter: github-pr-review
./LICENSE	[[[1
21
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
54
# 🎨 glyph-palette

![Support Vim 8.1 or above](https://img.shields.io/badge/support-Vim%208.1%20or%20above-yellowgreen.svg)
![Support Neovim 0.4 or above](https://img.shields.io/badge/support-Neovim%200.4%20or%20above-yellowgreen.svg)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20glyph--palette-orange.svg)](doc/glyph-palette.txt)

![glyph-palette](https://user-images.githubusercontent.com/546312/89098136-c442ac80-d41f-11ea-90ce-68f2df7ccb25.png)

glyph-palette (Glyph palette) is a plugin to universally apply colors on [Nerd Fonts][].

With this plugin, the following (and potentially more) Nerd Fonts integrations will be nicely highlighted.

- [vim-devicons][]
- [nerdfont.vim][]
- [fern-renderer-nerdfont.vim][]

[nerd fonts]: https://github.com/ryanoasis/nerd-fonts
[vim-devicons]: https://github.com/ryanoasis/vim-devicons
[nerdfont.vim]: https://github.com/lambdalisue/nerdfont.vim
[fern-renderer-nerdfont.vim]: https://github.com/lambdalisue/fern-renderer-nerdfont.vim

## Usage

First of all, make sure that you are using one of [Nerd Fonts][] patched fonts (e.g. Fonts in [Patched Fonts](https://github.com/ryanoasis/nerd-fonts#patched-fonts) or [Cica][] for Japanese).
Visit [Nerd Fonts][] homepage for more detail.

[cica]: https://github.com/miiton/Cica

After that, call `glyph_palette#apply()` function on a target buffer like:

```vim
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
```

Then glyphs in `g:glyph_palette#palette` on the buffer will be highlighted by predefined highlight groups.

See `:help glyph-palette-usage` for more details

## Screenshots

#### With nerdfont.vim + fern.vim + fern-renderer-nerdfont.vim

![With nerdfont.vim + fern.vim + fern-renderer-nerdfont.vim](https://user-images.githubusercontent.com/546312/88701008-6c1c5980-d144-11ea-8d6b-d4f4290274a6.png)

Provide us your nice screenshots!

## Special thanks

An initial implementation has written by @zeorin at https://github.com/ryanoasis/vim-devicons/issues/158
./autoload/glyph_palette/defaults.vim	[[[1
83
" The following palette has constructed based on defx-icons
" REF: https://github.com/kristijanhusak/defx-icons
" MIT: Copyright (c) 2018 Kristijan Husak
"
" NOTE:
" Use glyph_palette#tools#print_palette(palette) function to modify the following variable
let g:glyph_palette#defaults#palette = {
      \ 'GlyphPalette1': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
      \ 'GlyphPalette2': ['', '', '', '', '', '', '󰡄', '', '', '', '', '', ''],
      \ 'GlyphPalette3': ['λ', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
      \ 'GlyphPalette4': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
      \ 'GlyphPalette6': ['', '', '', '', '', '', '', '', '', '', '', '', '', ''],
      \ 'GlyphPalette7': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''] ,
      \ 'GlyphPalette9': ['', '', '', '', '', '', '', '', '', '', '', ''],
      \ 'GlyphPaletteDirectory': ['', '', '', '', '', ''],
      \}

" The following default colors are copied from iceberg.vim
" REF: https://github.com/cocopon/iceberg.vim
" MIT: Copyright (c) 2014 cocopon <cocopon@me.com>
"
" NOTE:
" Use glyph_palette#tools#print_colors(colors) function to modify the following variable
let g:glyph_palette#defaults#colors = {
      \ 'light': [
      \   '#dcdfe7',
      \   '#cc517a',
      \   '#668e3d',
      \   '#c57339',
      \   '#2d539e',
      \   '#7759b4',
      \   '#3f83a6',
      \   '#33374c',
      \   '#8389a3',
      \   '#cc3768',
      \   '#598030',
      \   '#b6662d',
      \   '#22478e',
      \   '#6845ad',
      \   '#327698',
      \   '#262a3f',
      \ ],
      \ 'dark': [
      \   '#1e2132',
      \   '#e27878',
      \   '#b4be82',
      \   '#e2a478',
      \   '#84a0c6',
      \   '#a093c7',
      \   '#89b8c2',
      \   '#c6c8d1',
      \   '#6b7089',
      \   '#e98989',
      \   '#c0ca8e',
      \   '#e9b189',
      \   '#91acd1',
      \   '#ada0d3',
      \   '#95c4ce',
      \   '#d2d4de',
      \ ],
      \}

function! glyph_palette#defaults#highlight() abort
  if exists('g:terminal_ansi_colors')
    call s:highlight(g:terminal_ansi_colors)
  elseif exists('g:terminal_color_0')
    call s:highlight(map(range(16), { i -> g:terminal_color_{i} }))
  else
    call s:highlight(g:glyph_palette#defaults#colors[&background])
  endif
  augroup glyph_palette_defaults_highlight_internal
    autocmd!
    autocmd ColorScheme * ++once call glyph_palette#defaults#highlight()
  augroup END
endfunction

function! s:highlight(colors) abort
  highlight default link GlyphPaletteDirectory Directory
  call map(range(len(a:colors)), { i -> execute(printf(
        \ 'highlight default GlyphPalette%d ctermfg=%d guifg=%s',
        \ i, i, a:colors[i],
        \)) })
endfunction
./autoload/glyph_palette/tools.vim	[[[1
97
function! glyph_palette#tools#palette_from(settings, glyph_map) abort
  let palette = {}
  for [group, names] in items(a:settings)
    if empty(names)
      continue
    endif
    let glyphs = uniq(sort(map(copy(names), { -> get(a:glyph_map, v:val, v:val) })))
    let palette[group] = glyphs
  endfor
  return palette
endfunction

function! glyph_palette#tools#palette_from_nerdfont(settings) abort
  let gm = {}
  call extend(gm, g:nerdfont#path#extension#defaults)
  call extend(gm, g:nerdfont#path#basename#defaults)
  return glyph_palette#tools#palette_from(a:settings, gm)
endfunction

function! glyph_palette#tools#palette_from_devicons(settings) abort
  let gm = {}
  call extend(gm, g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols)
  call extend(gm, g:WebDevIconsUnicodeDecorateFileNodesExactSymbols)
  return glyph_palette#tools#palette_from(a:settings, gm)
endfunction

function! glyph_palette#tools#print_colors(colors) abort
  new
  call append(0, split(execute('call s:print_colors(a:colors)'), '\n'))
  setlocal buftype=nofile bufhidden=wipe nobuflisted
  setlocal nomodified nomodifiable
  setlocal noswapfile nobackup
  setfiletype vim
endfunction

function! glyph_palette#tools#print_palette(palette) abort
  new
  call append(0, split(execute('call s:print_palette(a:palette)'), '\n'))
  setlocal buftype=nofile bufhidden=wipe nobuflisted
  setlocal nomodified nomodifiable
  setlocal noswapfile nobackup
  setfiletype vim
endfunction

function! glyph_palette#tools#show_palette(...) abort
  new
  let palette = a:0 ? a:1 : g:glyph_palette#palette
  call append(0, split(execute('call s:show_palette(palette)'), '\n'))
  call glyph_palette#apply(palette)
  setlocal buftype=nofile bufhidden=wipe nobuflisted
  setlocal nomodified nomodifiable
  setlocal noswapfile nobackup
  redraw
endfunction

function! s:print_colors(colors) abort
  let indent = repeat(' ', 6)
  echo 'let s:colors = {'
  echo indent . '\ ''__type__'': ['
  let ps = map(copy(a:colors), { k, v -> ['GlyphPalette' . k, k, v] })
  for color in a:colors
    echo indent . printf('\   ''%s'',', color)
  endfor
  echo indent . '\ ],'
  echo indent . '\}'
endfunction

function! s:print_palette(palette) abort
  let indent = repeat(' ', 6)
  echo 'let s:palette = {'
  for [group, glyphs] in sort(items(a:palette))
    echo indent . printf(
          \ '\ %s: [%s],',
          \ string(group),
          \ join(map(copy(glyphs), { -> string(v:val) }), ', '),
          \)
  endfor
  echo indent . '\}'
endfunction

function! s:show_palette(palette) abort
  let palette = items(map(copy(a:palette), { -> join(v:val, '  ') . ' ' }))
  call sort(map(palette, { _, v -> [printf('%s(%s)', v[0], s:get_meta(v[0])), v[1]] }))
  let longest = max(map(copy(palette), { -> len(v:val[0]) }))
  let trailing = repeat(' ', longest)
  for [prefix, glyphs] in palette
    let prefix = (prefix . trailing)[:longest]
    echo prefix . glyphs
  endfor
endfunction

function! s:get_meta(group) abort
  return matchstr(
        \ execute(printf('highlight %s', a:group)),
        \ printf('%s\s\+xxx\s\zs.*', a:group),
        \)
endfunction
./autoload/glyph_palette.vim	[[[1
78
let s:ESCAPE_PATTERN = '^$~.*[]\'

function! glyph_palette#apply(...) abort
  let palette = copy(a:0 ? a:1 : g:glyph_palette#palette)

  " Optimize palette
  call filter(palette, { -> !empty(v:val) })
  call map(palette, { -> map(v:val, { -> escape(v:val, s:ESCAPE_PATTERN) }) })
  call map(palette, { -> printf('\%%(%s\)', join(v:val, '\|')) })

  " Init the buffer
  let b:glyph_palette_palette = palette
  augroup glyph-palette-internal
    autocmd! * <buffer>
    autocmd BufEnter,WinEnter <buffer> call s:apply()
  augroup END

  call s:clear()
  call s:apply()

  " Backword compatibility
  let bufnr = bufnr('%')
  return { -> s:deprecated_clear(bufnr) }
endfunction

function! glyph_palette#clear() abort
  " Clear existing windows
  call s:clear()
  " Clear the buffer
  silent! unlet! b:glyph_palette_palette
  augroup glyph-palette-internal
    autocmd! * <buffer>
  augroup END
endfunction

function! s:apply() abort
  if !exists('b:glyph_palette_palette')
    call glyph_palette#clear()
    return
  endif
  if exists('w:glyph_palette_matches')
    silent! call map(w:glyph_palette_matches, { -> matchdelete(v:val) })
  endif
  let w:glyph_palette_matches = map(
        \ copy(b:glyph_palette_palette),
        \ { -> matchadd(v:key, v:val) },
        \)
endfunction

function! s:clear() abort
  let winid_saved = win_getid()
  let winids = win_findbuf(bufnr('%'))
  for winid in winids
    noautocmd keepjumps call win_gotoid(winid)
    silent! call map(w:glyph_palette_matches, { -> matchdelete(v:val) })
    silent! unlet! w:b:glyph_palette_palette
  endfor
  noautocmd keepjumps call win_gotoid(winid_saved)
endfunction

function! s:deprecated_clear(bufnr) abort
  echohl WarningMsg
  echomsg '[glyph-palette] Function returned from glyph_palette#apply() has deprecated.'
  echomsg '[glyph-palette] Use glyph_palette#clear() on the buffer instead to clear highlights.'
  echohl None
  let bufnr_saved = bufnr('%')
  let bufhidden_saved = &bufhidden
  try
    setlocal bufhidden=hide
    execute printf('noautocmd keepjumps keepalt %dbuffer', a:bufnr)
    call glyph_palette#clear()
  finally
    execute printf('noautocmd keepjumps keepalt %dbuffer', bufnr_saved)
    let &bufhidden = bufhidden_saved
  endtry
endfunction

let g:glyph_palette#palette = get(g:, 'glyph_palette#palette', copy(g:glyph_palette#defaults#palette))
./doc/.gitignore	[[[1
1
tags
./doc/glyph-palette.txt	[[[1
230
*glyph-palette.txt*		Universally apply colors on Nerd Fonts glyph

Author:  Alisue <lambdalisue@hashnote.net>
License: MIT license

=============================================================================
CONTENTS				*glyph-palette-contents*

INTRODUCTION				|glyph-palette-introduction|
USAGE					|glyph-palette-usage|
INTERFACE				|glyph-palette-interface|
  VARIABLE				|glyph-palette-variable|
  FUNCTION				|glyph-palette-function|
  HIGHLIGHT				|glyph-palette-highlight|
TOOLS					|glyph-palette-tools|


=============================================================================
INTRODUCTION				*glyph-palette-introduction*

*glyph-palette.vim* (Glyph palette) is a plugin to universally apply colors on
Nerd Fonts (https://github.com/ryanoasis/nerd-fonts).

With this plugin, the following (and potentially more) Nerd Fonts integrations
will be nicely highlighted.

- https://github.com/ryanoasis/vim-devicons
- https://github.com/lambdalisue/nerdfont.vim
- https://github.com/lambdalisue/fern-renderer-nerdfont.vim


=============================================================================
USAGE					*glyph-palette-usage*

First of all, make sure that you are using one of Nerd Fonts Patched Fonts. 
You will see nice Vim glyph on   if the current font is properly patched.
See https://github.com/ryanoasis/nerd-fonts for more detail.

After that, call |glyph_palette#apply()| on a target buffer like:
>
	augroup my-glyph-palette
	  autocmd!
	  autocmd FileType fern call glyph_palette#apply()
	  autocmd FileType nerdtree call glyph_palette#apply()
	  autocmd FileType startify call glyph_palette#apply()
	augroup END
<
Then glyphs in |g:glyph_palette#palette| on the buffer will be highlighted by
predefined highlight groups (|glyph-palette-highlight|).

To customize the palette, modify |g:glyph_palette#palette|.
To customize the color, change group name (key) in the palette or directly
overwrite highlgihts in |glyph-palette-highlight|.


=============================================================================
INTERFACE				*glyph-palette-interface*

-----------------------------------------------------------------------------
VARIABLE				*glyph-palette-variable*

*g:glyph_palette#palette*
	A palette |Dictionary| which key is a |highlight-group| and value is
	a |List| of glyphs.
	To produce palette from names in nerdfont.vim or vim-devicons, see
	|glyph-palette-tools|.
	Note that the variable does not exists so copy palette from
	|g:glyph_palette#defaults#palette| to extend the default palette like:
>
	let g:glyph_palette#palette = copy(g:glyph_palette#defaults#palette)
	let g:glyph_palette#palette['GlyphPalette0'] += ['']
<
*g:glyph_palette#defaults#palette*
	A default palette which is assigned to |g:glyph_palette#palette|.

	Note that the default value has constructed based defx-icons.
	https://github.com/kristijanhusak/defx-icons

-----------------------------------------------------------------------------
FUNCTION				*glyph-palette-function*

					*glyph_palette#apply()*
glyph_palette#apply([{palette}])
	Apply palette on the current buffer. Use |autocmd| to call this
	function automatically like:
>
	augroup my-glyph-palette
	  autocmd! *
	  autocmd FileType fern call glyph_palette#apply()
	  autocmd FileType nerdtree,startify call glyph_palette#apply()
	augroup END
<
	DEPRECATED~
	The clear function returned from this function has deprecated. Use
	|glyph_palette#clear()| on applied buffer instead to clear highlgihts.

					*glyph_palette#clear()*
glyph_palette#clear()
	Clear applied glyph palette highlight on the buffer.
	It also clear highlights on other windows which shows the buffer as
	well.

-----------------------------------------------------------------------------
HIGHLIGHT				*glyph-palette-highlight*

Overwrite the following predfeined |highlight| to change colorset.

GlyphPalette0	Black			*hl-GlyphPalette0*
GlyphPalette1	Red			*hl-GlyphPalette1*
GlyphPalette2	Green			*hl-GlyphPalette2*
GlyphPalette3	Yellow			*hl-GlyphPalette3*
GlyphPalette4	Blue			*hl-GlyphPalette4*
GlyphPalette5	Magenta			*hl-GlyphPalette5*
GlyphPalette6	Cyan			*hl-GlyphPalette6*
GlyphPalette7	White			*hl-GlyphPalette7*
GlyphPalette8	Bright Black		*hl-GlyphPalette8*
GlyphPalette9	Bright Red		*hl-GlyphPalette9*
GlyphPalette10	Bright Green		*hl-GlyphPalette10*
GlyphPalette11	Bright Yellow		*hl-GlyphPalette11*
GlyphPalette12	Bright Blue		*hl-GlyphPalette12*
GlyphPalette13	Bright Magenta		*hl-GlyphPalette13*
GlyphPalette14	Bright Cyan		*hl-GlyphPalette14*
GlyphPalette15	Bright White		*hl-GlyphPalette15*

Note that the default colorset was copied from iceberg.vim
https://github.com/cocopon/iceberg.vim


=============================================================================
TOOLS					*glyph-palette-tools*

Glyph palette provides the following tool functions


				*glyph_palette#tools#palette_from()*
glyph_palette#tools#palette_from({settings}, {glyph_map})
	Create a palette |Dictionary| from {settings} |Dictionary| through
	{glyph_map} |Dictionary|.
	The key of {settings} is a |highlight-group| and the value is a |List|
	of a glyph character itself or a key of {glyph_map}.
	When a key of {glyph_map} is specified, a corresponding value of
	{glyph_map} is used in a result palette.
	All duplicated characters in a result palette will be removed.
>
	echo glyph_palette#tools#palette_from({
	      \ 'Function': ['', '', 'vim', 'key'],
	      \}, {
	      \ 'key': ' ,
	      \	'vim': '',
	      \})
	" { 'Function': ['', '', ''] }
<
	Use this function to construct |g:glyph_palette#palette| from human
	readable names and glyph map or use this function with
	|glyph_pattern#tools#print_palette()| to avoid runtime construction.

				*glyph_palette#tools#palette_from_nerdfont()*
glyph_palette#tools#palette_from_nerdfont({settings})
	Create {glyph_map} of |glyph_palette#tools#palette_from()| from the
	following nerdfont.vim variables and return palette.

	- g:nerdfont#path#extension#defaults
	- g:nerdfont#path#basename#defaults

	https://github.com/lambdalisue/nerdfont.vim

				*glyph_palette#tools#palette_from_devicons()*
glyph_palette#tools#palette_from_devicons({settings})
	Create {glyph_map} of |glyph_palette#tools#palette_from()| from the
	following vim-devicons variables and return palette.

	- g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols
	- g:WebDevIconsUnicodeDecorateFileNodesExactSymbols

	https://github.com/ryanoasis/vim-devicons

				*glyph_palette#tools#print_colors()*
glyph_palette#tools#print_colors({index_colors})
	Create and open a non-file buffer to print |highlight| expressions
	from {index_colors} for copy-and-paste.
	The {index_colors} is a |List| which has 16 items and each item
	indicates terminal indexed colors.
	Users can use this function to create them original colorset from
	Vim/Neovim terminal color settings like:
>
	" Vim
	call glyph_palette#tools#print_colors(g:terminal_ansi_colors)

	" Neovim
	call glyph_palette#tools#print_colors([
	      \ g:terminal_color_0,
	      \ g:terminal_color_1,
	      \ g:terminal_color_2,
	      \ g:terminal_color_3,
	      \ g:terminal_color_4,
	      \ g:terminal_color_5,
	      \ g:terminal_color_6,
	      \ g:terminal_color_7,
	      \ g:terminal_color_8,
	      \ g:terminal_color_9,
	      \ g:terminal_color_10,
	      \ g:terminal_color_11,
	      \ g:terminal_color_12,
	      \ g:terminal_color_13,
	      \ g:terminal_color_14,
	      \ g:terminal_color_15,
	      \])
<
				*glyph_palette#tools#print_palette()*
glyph_palette#tools#print_palette({palette})
	Open a non-file buffer to print {palette} for copy-and-paste.
	Mainly to avoid runtime palette construction from settings.

				*glyph_palette#tools#show_palette()*
glyph_palette#tools#show_palette([{palette}])
	Open a non-file buffer to visualize {palette} for human. It shows the
	{palette} like:
>
	GlyphPalette1(ctermfg=1 guifg=#e27878)      
	GlyphPalette2(ctermfg=2 guifg=#b4be82)           󿵂 
	GlyphPalette3(ctermfg=3 guifg=#e2a478) λ               
	GlyphPalette4(ctermfg=4 guifg=#84a0c6)                  
	GlyphPalette6(ctermfg=6 guifg=#89b8c2)  
	GlyphPalette7(ctermfg=7 guifg=#c6c8d1)            
	GlyphPalette8(ctermfg=8 guifg=#6b7089)        
	GlyphPalette9(ctermfg=9 guifg=#e98989)                  
<

=============================================================================
vim:tw=78:fo=tcq2mM:ts=8:ft=help:norl
./plugin/glyph_palette.vim	[[[1
8
if exists('g:loaded_glyph_palette')
  finish
endif
let g:loaded_glyph_palette = 1

if !get(g:, 'glyph_palette_disable_default_colors')
  call glyph_palette#defaults#highlight()
endif
