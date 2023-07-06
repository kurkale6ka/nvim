" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/workflows/neovim.yml	[[[1
42
name: neovim

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        os:
          - macos-latest
          - windows-latest
          - ubuntu-latest
        version:
          - stable
          - v0.4.4
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v3
      - uses: actions/checkout@v3
        with:
          repository: thinca/vim-themis
          path: vim-themis
      - uses: thinca/action-setup-vim@v1
        id: nvim
        with:
          vim_type: "Neovim"
          vim_version: "${{ matrix.version }}"
      - name: Run tests
        env:
          THEMIS_VIM: ${{ steps.nvim.outputs.executable }}
          # XXX:
          # Overwrite %TMP% to point a correct temp directory.
          # Note that %TMP% only affects value of 'tempname()' in Windows.
          # https://github.community/t5/GitHub-Actions/TEMP-is-broken-on-Windows/m-p/30432#M427
          TMP: 'C:\Users\runneradmin\AppData\Local\Temp'
        run: |
          ./vim-themis/bin/themis
./.github/workflows/reviewdog.yml	[[[1
20
name: reviewdog

on:
  push:
    branches:
      - main
  pull_request:

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
./.github/workflows/vim.yml	[[[1
47
name: vim

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        os:
          - macos-latest
          - windows-latest
          - ubuntu-latest
        version:
          - head
          - v8.2.0716 # Ubuntu 20.10 (2021/02/28)
          - v8.1.2269 # Ubuntu 20.04 (2021/02/28)
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v3
      - uses: actions/checkout@v3
        with:
          repository: thinca/vim-themis
          path: vim-themis
      - uses: thinca/action-setup-vim@v1
        id: vim
        with:
          vim_type: "Vim"
          vim_version: "${{ matrix.version }}"
          # NOTE:
          # On Linux, Vim must be built from source to fix `input` issue
          # https://github.com/thinca/action-setup-vim/issues/11
          download: "${{ (runner.OS == 'Linux' && 'never') || 'available' }}"
      - name: Run tests
        env:
          THEMIS_VIM: ${{ steps.vim.outputs.executable }}
          # XXX:
          # Overwrite %TMP% to point a correct temp directory.
          # Note that %TMP% only affects value of 'tempname()' in Windows.
          # https://github.community/t5/GitHub-Actions/TEMP-is-broken-on-Windows/m-p/30432#M427
          TMP: 'C:\Users\runneradmin\AppData\Local\Temp'
        run: |
          ./vim-themis/bin/themis
./.gitignore	[[[1
1
doc/tags
./LICENSE	[[[1
20
Copyright 2018 Alisue, hashnote.net

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
224
# 🌿 fern.vim

![Support Vim 8.1.2269 or above](https://img.shields.io/badge/support-Vim%208.1.2269%20or%20above-yellowgreen.svg)
![Support Neovim 0.4.4 or above](https://img.shields.io/badge/support-Neovim%200.4.4%20or%20above-yellowgreen.svg)
[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)
[![Powered by vital-Whisky](https://img.shields.io/badge/powered%20by-vital--Whisky-80273f.svg)](https://github.com/lambdalisue/vital-Whisky)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20fern-orange.svg)](doc/fern.txt)
[![Doc (dev)](https://img.shields.io/badge/doc-%3Ah%20fern--develop-orange.svg)](doc/fern-develop.txt)
[![reviewdog](https://github.com/lambdalisue/fern.vim/workflows/reviewdog/badge.svg)](https://github.com/lambdalisue/fern.vim/actions?query=workflow%3Areviewdog)
[![vim](https://github.com/lambdalisue/fern.vim/workflows/vim/badge.svg)](https://github.com/lambdalisue/fern.vim/actions?query=workflow%3Avim)
[![neovim](https://github.com/lambdalisue/fern.vim/workflows/neovim/badge.svg)](https://github.com/lambdalisue/fern.vim/actions?query=workflow%3Aneovim)

<p align="center">
<strong>Split windows (netrw style)</strong><br>
<sup>
<a href="https://github.com/lambdalisue/nerdfont.vim" target="_blank">nerdfont.vim</a>
/
<a href="https://github.com/lambdalisue/glyph-palette.vim" target="_blank">glyph-palette.vim</a>
/
<a href="https://github.com/lambdalisue/fern-renderer-nerdfont.vim" target="_blank">fern-renderer-nerdfont.vim</a>
/
<a href="https://github.com/lambdalisue/fern-git-status.vim" target="_blank">fern-git-status.vim</a>
</sup>
<img src="https://user-images.githubusercontent.com/546312/90719223-cdbc8780-e2ee-11ea-8a6e-ea837a194ffa.png">
</p>
<p align="center">
<strong>Project drawer (NERDTree style)</strong><br>
<sup>
<a href="https://github.com/lambdalisue/nerdfont.vim" target="_blank">nerdfont.vim</a>
/
<a href="https://github.com/lambdalisue/glyph-palette.vim" target="_blank">glyph-palette.vim</a>
/
<a href="https://github.com/lambdalisue/fern-renderer-nerdfont.vim" target="_blank">fern-renderer-nerdfont.vim</a>
/
<a href="https://github.com/lambdalisue/fern-git-status.vim" target="_blank">fern-git-status.vim</a>
</sup>
<img src="https://user-images.githubusercontent.com/546312/90719227-ceedb480-e2ee-11ea-98c5-0b7cbcb1bb6a.png">
</p>
<p align="right">
<sup>
See <a href="https://github.com/lambdalisue/fern.vim/wiki/Screenshots" target="_blank">Screenshots</a> for more screenshots.
</sup>
</p>

Fern ([furn](https://www.youtube.com/watch?v=SSYgr-_69mg)) is a general purpose asynchronous tree viewer written in pure Vim script.

---

<p align="center">
  <strong>🔍 <a href="https://github.com/topics/fern-vim-plugin">Click here to find fern plugins</a> 🔍</strong>
</p>

---

## Concept

- Supports both Vim and Neovim without any external dependencies
- Support _split windows_ and _project drawer_ explained in [this article](http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/)
- Provide features as actions so that user don't have to remember mappings
- Make operation asynchronous as much as possible to keep latency
- User experience is more important than simplicity (maintainability)
- Customizability is less important than simplicity (maintainability)
- Easy to create 3rd party plugins to support any kind of trees

## Installation

fern.vim has no extra dependencies so use your favorite Vim plugin manager or see [How to install](https://github.com/lambdalisue/fern.vim/wiki#how-to-install) page for detail.

- If you use Neovim < 0.8, you **SHOULD** add [antoinemadec/FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim) (See [#120](https://github.com/lambdalisue/fern.vim/issues/120))

## Usage

### Command (Split windows)

![Screencast of Split windows](https://user-images.githubusercontent.com/546312/73183457-29120700-415e-11ea-8d04-cb959659e369.gif)

Open fern on a current working directory by:

```vim
:Fern .
```

Or open fern on a parent directory of a current buffer by:

```vim
:Fern %:h
```

Or open fern on a current working directory with a current buffer focused by:

```vim
:Fern . -reveal=%
```

![](https://user-images.githubusercontent.com/546312/90720134-f3e32700-e2f0-11ea-82f7-c86512ad5854.png)

The following options are available for fern viewer.

| Option    | Default | Description                                                                         |
| --------- | ------- | ----------------------------------------------------------------------------------- |
| `-opener` | `edit`  | An opener to open the buffer. See `:help fern-opener` for detail.                   |
| `-reveal` |         | Recursively expand branches and focus the node. See `:help fern-reveal` for detail. |
| `-stay`   |         | Stay focus on the window where the command has called.                              |
| `-wait`   |         | Wait synchronously until the fern viewer become ready.                              |

```
:Fern {url} [-opener={opener}] [-reveal={reveal}] [-stay] [-wait]
```

### Command (Project drawer)

![Screencast of Project drawer](https://user-images.githubusercontent.com/546312/73184080-324fa380-415f-11ea-8280-e0b6c7a9989f.gif)

All usage above open fern as [*split windows style*][]. To open fern as [*project drawer style*][], use `-drawer` option like:

```vim
:Fern . -drawer
```

A fern window with _project drawer_ style always appeared to the most left side of Vim and behaviors of some mappings/actions are slightly modified (e.g. a buffer in the next window will be used as an anchor buffer in a project drawer style to open a new buffer.)

Note that additional to the all options available for _split windows_ style, _project drawer_ style enables the following options:

| Option    | Default | Description                                                      |
| --------- | ------- | ---------------------------------------------------------------- |
| `-width`  | `30`    | The width of the project drawer window                           |
| `-keep`   |         | Disable to quit Vim when there is only one project drawer buffer |
| `-toggle` |         | Close existing project drawer rather than focus                  |

```
:Fern {url} -drawer [-opener={opener}] [-reveal={reveal}] [-stay] [-wait] [-width=30] [-keep] [-toggle]
```

[*split windows style*]: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
[*project drawer style*]: http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/

### Actions

To execute actions, hit `a` on a fern buffer and input an action to perform.
To see all actions available, hit `?` or execute `help` action then all available actions will be listed.

![Actions](https://user-images.githubusercontent.com/546312/73184453-c91c6000-415f-11ea-8e6b-f1df4b9284de.gif)

### Window selector

The `open:select` action open a prompt to visually select window to open a node.
This feature is strongly inspired by [t9md/vim-choosewin][].

![Window selector](https://user-images.githubusercontent.com/546312/73605707-090e9780-45e5-11ea-864a-457dd785f1c4.gif)

[t9md/vim-choosewin]: https://github.com/t9md/vim-choosewin

### Renamer action (A.k.a exrename)

The `rename` action open a new buffer with path of selected nodes.
Users can edit that buffer and `:w` applies the changes.
This feature is strongly inspired by [shougo/vimfiler.vim][].

![Renamer](https://user-images.githubusercontent.com/546312/73184814-5d86c280-4160-11ea-9ed1-d5a8d66d1774.gif)

[shougo/vimfiler.vim]: https://github.com/Shougo/vimfiler.vim

# Plugins

## Users

Most of functionalities are provided as plugins in fern.
So visit [Github topics of `fern-vim-plugin`](https://github.com/topics/fern-vim-plugin) or [Plugins](https://github.com/lambdalisue/fern.vim/wiki/Plugins) page to find fern plugins to satisfy your wants.

For example, following features are provided as official plugins

- Netrw hijack (Use fern as a default file explorer)
- [Nerd Fonts](https://www.nerdfonts.com/) integration
- Git integration (show status, touch index, ...)
- Bookmark feature

And lot more!

## Developers

Please add `fern-vim-plugin` topic to your fern plugin. The topic is used to list up 3rd party fern plugins.
![](https://user-images.githubusercontent.com/546312/94343538-d160ce00-0053-11eb-9ec6-0dd2a4c3f4b0.png)

Then please add a following badge to indicate that your plugin is for fern.

```
[![fern plugin](https://img.shields.io/badge/🌿%20fern-plugin-yellowgreen)](https://github.com/lambdalisue/fern.vim)
```

## Customize

Use `FileType fern` autocmd to execute initialization scripts for fern buffer like:

```vim
function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END
```

The `FileType` autocmd will be invoked AFTER a fern buffer has initialized but BEFORE contents of a buffer become ready.
So avoid accessing actual contents in the above function.

See [Tips](https://github.com/lambdalisue/fern.vim/wiki/Tips) pages to find tips, or write pages to share your tips ;-)

# Contribution

Any contribution including documentations are welcome.

Contributors who change codes should install [thinca/vim-themis][] to run tests before complete a PR.
PRs which does not pass tests won't be accepted.

[thinca/vim-themis]: https://github.com/thinca/vim-themis

# License

The code in fern.vim follows MIT license texted in [LICENSE](./LICENSE).
Contributors need to agree that any modifications sent in this repository follow the license.
./autoload/fern/action.vim	[[[1
22
let s:Action = vital#fern#import('App.Action')
call s:Action.set_ignores([
      \ 'hidden-set',
      \ 'hidden-unset',
      \ 'hidden-toggle',
      \ 'mark-clear',
      \ 'mark-set',
      \ 'mark-unset',
      \ 'mark-toggle',
      \])

function! fern#action#_init() abort
  call s:Action.init()
endfunction

function! fern#action#call(...) abort
  call call(s:Action.call, a:000, s:Action)
endfunction

function! fern#action#list(...) abort
  return call(s:Action.list, a:000, s:Action)
endfunction
./autoload/fern/comparator/default.vim	[[[1
35
function! fern#comparator#default#new() abort
  return {
        \ 'compare': funcref('s:compare'),
        \}
endfunction

function! s:compare(n1, n2) abort
  let k1 = a:n1.__key
  let k2 = a:n2.__key
  let t1 = a:n1.status > 0
  let t2 = a:n2.status > 0
  let l1 = len(k1)
  let l2 = len(k2)
  for index in range(0, min([l1, l2]) - 1)
    if k1[index] ==# k2[index]
      continue
    endif
    let _t1 = index + 1 is# l1 ? t1 : 1
    let _t2 = index + 1 is# l2 ? t2 : 1
    if _t1 is# _t2
      " Lexical compare
      return k1[index] > k2[index] ? 1 : -1
    else
      " Directory first
      return _t1 ? -1 : 1
    endif
  endfor
  " Shorter first
  let r = fern#util#compare(l1, l2)
  if r isnot# 0
    return r
  endif
  " Leaf first
  return fern#util#compare(!a:n1.status, !a:n2.status)
endfunction
./autoload/fern/fri/from.vim	[[[1
21
function! fern#fri#from#filepath(path) abort
  if !fern#internal#filepath#is_absolute(a:path)
    throw printf('The "path" must be an absolute path but "%s" has specfied', a:path)
  endif
  let path = fern#internal#filepath#to_slash(a:path)
  return fern#fri#from#path(path)
endfunction

function! fern#fri#from#path(path) abort
  if a:path[:0] !=# '/'
    throw printf('The "path" must start from "/" but "%s" has specfied', a:path)
  endif
  let path = fern#internal#path#simplify(a:path)
  let path = fern#fri#encode(path)
  let path = fern#fri#encode(path, '[#\[\]; ]')
  " Remove leading '/' while 'path' sub-component does NOT include it.
  return fern#fri#new({
        \ 'scheme': 'file',
        \ 'path': path[1:],
        \})
endfunction
./autoload/fern/fri/to.vim	[[[1
14
function! fern#fri#to#filepath(fri) abort
  if a:fri.scheme !=# 'file'
    throw printf('The "scheme" must be "file" but "%s" has specified', a:fri.scheme)
  endif
  let path = fern#fri#to#path(a:fri)
  let path = fern#internal#filepath#from_slash(path)
  return path
endfunction

function! fern#fri#to#path(fri) abort
  let path = '/' . a:fri.path
  let path = fern#fri#decode(path)
  return path
endfunction
./autoload/fern/fri.vim	[[[1
145
let s:PATTERN = '^$~.*[]\'
let s:FRI = {
      \ 'scheme': '',
      \ 'authority': '',
      \ 'path': '',
      \ 'query': {},
      \ 'fragment': '',
      \}

function! fern#fri#new(partial) abort
  return extend(deepcopy(s:FRI), a:partial)
endfunction

function! fern#fri#parse(expr) abort
  let remains = a:expr =~# '^fern:'
        \ ? matchstr(a:expr, '.\{-}\ze\$\?$')
        \ : a:expr
  let [scheme, remains] = s:split1(remains, escape('://', s:PATTERN))
  if empty(remains)
    let remains = scheme
    let scheme = ''
  endif
  let [authority, remains] = s:split1(remains, escape('/', s:PATTERN))
  if empty(remains) && a:expr =~# printf('^%s:///', scheme)
    let remains = authority
    let authority = ''
  endif
  let [path, remains] = s:split1(remains, escape(';', s:PATTERN))
  if empty(remains)
    let query = ''
    let [path, fragment] = s:split1(path, escape('#', s:PATTERN))
  else
    let [query, fragment] = s:split1(remains, escape('#', s:PATTERN))
  endif
  return {
        \ 'scheme': scheme,
        \ 'authority': s:decode(authority),
        \ 'path': s:decode(path),
        \ 'query': s:parse_query(query),
        \ 'fragment': s:decode(fragment),
        \}
endfunction

function! fern#fri#format(fri) abort
  let expr = printf(
        \ '%s://%s/%s',
        \ a:fri.scheme,
        \ s:encode_authority(a:fri.authority),
        \ s:encode_path(a:fri.path),
        \)
  if !empty(a:fri.query)
    let expr .= ';' . s:format_query(a:fri.query)
  endif
  if !empty(a:fri.fragment)
    let expr .= '#' . s:encode_fragment(a:fri.fragment)
  endif
  return a:fri.scheme ==# 'fern'
        \ ? expr . '$'
        \ : expr
endfunction

function! fern#fri#encode(str, ...) abort
  let pattern = a:0 ? a:1 : '[%<>|?\*]'
  return s:encode(a:str, pattern)
endfunction

function! fern#fri#decode(str) abort
  return s:decode(a:str)
endfunction

function! s:parse_query(query) abort
  let obj = {}
  let terms = split(a:query, '&\%(\w\+;\)\@!')
  call map(terms, { _, v -> (split(v, '=', 1) + [v:true])[:1] })
  call map(terms, { _, v ->
        \ extend(obj, {
        \   s:decode(v[0]): type(v[1]) is# v:t_string ? s:decode(v[1]) : v[1],
        \ })
        \})
  return obj
endfunction

function! s:format_query(query) abort
  if empty(a:query)
    return ''
  endif
  let pattern = '[/;#\[\]= ]'
  let terms = []
  for [k, v] in items(a:query)
    if empty(v)
      continue
    elseif v is# v:true
      call add(terms, s:encode_query(k))
    else
      call add(terms, printf(
            \ '%s=%s',
            \ s:encode_query(k),
            \ s:encode_query(v),
            \))
    endif
  endfor
  return join(terms, '&')
endfunction

function! s:encode_authority(path) abort
  let pattern = '[%/;#\[\]= ]'
  return s:encode(a:path, pattern)
endfunction

function! s:encode_path(path) abort
  let pattern = '[%;#\[\]= ]'
  return s:encode(a:path, pattern)
endfunction

function! s:encode_query(pchar) abort
  let pattern = '[%#\[\]= ]'
  return s:encode(a:pchar, pattern)
endfunction

function! s:encode_fragment(pchar) abort
  let pattern = '[%#\[\]= ]'
  return s:encode(a:pchar, pattern)
endfunction

function! s:encode(str, pattern) abort
  let l:Sub = { m -> printf('%%%X', char2nr(m[0])) }
  return substitute(a:str, a:pattern, Sub, 'g')
endfunction

function! s:decode(str) abort
  let l:Sub = { m -> nr2char(str2nr(m[1], 16)) }
  return substitute(a:str, '%\([0-9a-fA-F]\{2}\)', Sub, 'g')
endfunction

function! s:split1(str, pattern) abort
  let [_, s, e] = matchstrpos(a:str, a:pattern)
  if s is# -1
    return [a:str, '']
  elseif s is# 0
    return ['', a:str[e :]]
  endif
  let lhs = a:str[:s - 1]
  let rhs = a:str[e :]
  return [lhs, rhs]
endfunction
./autoload/fern/helper/async.vim	[[[1
324
let s:Promise = vital#fern#import('Async.Promise')
let s:AsyncLambda = vital#fern#import('Async.Lambda')

function! fern#helper#async#new(helper) abort
  let async = extend({ 'helper': a:helper }, s:async)
  return async
endfunction

let s:async = {}

function! s:async_sleep(ms) abort dict
  return fern#util#sleep(a:ms)
endfunction
let s:async.sleep = funcref('s:async_sleep')

function! s:async_redraw() abort dict
  let l:Profile = fern#profile#start('fern#helper:helper.async.redraw')
  let helper = self.helper
  let fern = helper.fern
  return s:Promise.resolve()
        \.then({ -> fern.renderer.render(fern.visible_nodes) })
        \.then({ v -> fern#internal#buffer#replace(helper.bufnr, v) })
        \.then({ -> helper.async.remark() })
        \.then({ -> fern#hook#emit('viewer:redraw', helper) })
        \.finally({ -> Profile() })
endfunction
let s:async.redraw = funcref('s:async_redraw')

function! s:async_remark() abort dict
  let l:Profile = fern#profile#start('fern#helper:helper.async.remark')
  let helper = self.helper
  let fern = helper.fern
  let marks = fern.marks
  return s:Promise.resolve(fern.visible_nodes)
        \.then(s:AsyncLambda.map_f({ n, i -> index(marks, n.__key) isnot# -1 ? i + 1 : 0 }))
        \.then(s:AsyncLambda.filter_f({ v -> v isnot# 0 }))
        \.then({ v -> fern#internal#mark#replace(helper.bufnr, v) })
        \.then({ -> fern#hook#emit('viewer:remark', helper) })
        \.finally({ -> Profile() })
endfunction
let s:async.remark = funcref('s:async_remark')

function! s:async_get_child_nodes(key) abort dict
  let helper = self.helper
  let fern = helper.fern
  let node = fern#internal#node#find(a:key, fern.nodes)
  if empty(node)
    return s:Promise.reject(printf('failed to find a node %s', a:key))
  endif
  let l:Profile = fern#profile#start('fern#helper:helper.async.get_child_nodes')
  return s:Promise.resolve()
        \.then({ -> fern#internal#node#children(
        \   node,
        \   fern.provider,
        \   fern.source.token,
        \ )
        \})
        \.finally({ -> Profile() })
endfunction
let s:async.get_child_nodes = funcref('s:async_get_child_nodes')

function! s:async_set_mark(key, value) abort dict
  let helper = self.helper
  let fern = helper.fern
  let index = index(fern.marks, a:key)
  if !xor(index isnot# -1, a:value)
    return s:Promise.resolve()
  endif
  if a:value
    call add(fern.marks, a:key)
  elseif index isnot# -1
    call remove(fern.marks, index)
  endif
  return self.update_marks(fern.marks)
endfunction
let s:async.set_mark = funcref('s:async_set_mark')

function! s:async_set_hidden(value) abort dict
  let helper = self.helper
  let fern = helper.fern
  if !xor(fern.hidden, a:value)
    return s:Promise.resolve()
  endif
  let fern.hidden = a:value
  return self.update_nodes(fern.nodes)
endfunction
let s:async.set_hidden = funcref('s:async_set_hidden')

function! s:async_set_include(pattern) abort dict
  let helper = self.helper
  let fern = helper.fern
  if fern.include ==# a:pattern
    return s:Promise.resolve()
  endif
  let fern.include = a:pattern
  return self.update_nodes(fern.nodes)
endfunction
let s:async.set_include = funcref('s:async_set_include')

function! s:async_set_exclude(pattern) abort dict
  let helper = self.helper
  let fern = helper.fern
  if fern.exclude ==# a:pattern
    return s:Promise.resolve()
  endif
  let fern.exclude = a:pattern
  return self.update_nodes(fern.nodes)
endfunction
let s:async.set_exclude = funcref('s:async_set_exclude')

function! s:async_update_nodes(nodes) abort dict
  let l:Profile = fern#profile#start('fern#helper:helper.async.update_nodes')
  let helper = self.helper
  let fern = helper.fern
  return helper.sync.save_cursor()
        \.then({ -> fern#internal#core#update_nodes(fern, a:nodes) })
        \.then({ -> helper.sync.restore_cursor() })
        \.finally({ -> Profile() })
endfunction
let s:async.update_nodes = funcref('s:async_update_nodes')

function! s:async_update_marks(marks) abort dict
  let l:Profile = fern#profile#start('fern#helper:helper.async.update_marks')
  let helper = self.helper
  let fern = helper.fern
  return fern#internal#core#update_marks(fern, a:marks)
        \.finally({ -> Profile() })
endfunction
let s:async.update_marks = funcref('s:async_update_marks')

function! s:async_expand_node(key) abort dict
  let helper = self.helper
  let fern = helper.fern
  let node = fern#internal#node#find(a:key, fern.nodes)
  if empty(node)
    return s:Promise.reject(printf('failed to find a node %s', a:key))
  elseif node.status is# helper.STATUS_NONE
    " To improve UX, reload owner instead
    return self.reload_node(node.__owner.__key)
  elseif node.status is# helper.STATUS_EXPANDED
    " To improve UX, reload instead
    return self.reload_node(node.__key)
  endif
  let l:Profile = fern#profile#start('fern#helper:helper.async.expand_node')
  return s:Promise.resolve()
        \.then({ -> fern#internal#node#expand(
        \   node,
        \   fern.nodes,
        \   fern.provider,
        \   fern.comparator,
        \   fern.source.token,
        \ )
        \})
        \.then({ ns -> self.update_nodes(ns) })
        \.finally({ -> Profile() })
endfunction
let s:async.expand_node = funcref('s:async_expand_node')

function! s:async_collapse_node(key) abort dict
  let helper = self.helper
  let fern = helper.fern
  let node = fern#internal#node#find(a:key, fern.nodes)
  if empty(node)
    return s:Promise.reject(printf('failed to find a node %s', a:key))
  elseif node.__owner is# v:null
    " To improve UX, root node should NOT be collapsed and reload instead.
    return self.reload_node(node.__key)
  elseif node.status isnot# helper.STATUS_EXPANDED
    " To improve UX, collapse a owner node instead
    return self.collapse_node(node.__owner.__key)
  endif
  let l:Profile = fern#profile#start('fern#helper:helper.async.collapse_node')
  return s:Promise.resolve()
        \.then({ -> fern#internal#node#collapse(
        \   node,
        \   fern.nodes,
        \   fern.provider,
        \   fern.comparator,
        \   fern.source.token,
        \ )
        \})
        \.then({ ns -> self.update_nodes(ns) })
        \.finally({ -> Profile() })
endfunction
let s:async.collapse_node = funcref('s:async_collapse_node')

function! s:async_reload_node(key) abort dict
  let helper = self.helper
  let fern = helper.fern
  let node = fern#internal#node#find(a:key, fern.nodes)
  if empty(node)
    return s:Promise.reject(printf('failed to find a node %s', a:key))
  endif
  let l:Profile = fern#profile#start('fern#helper:helper.async.reload_node')
  return s:Promise.resolve()
        \.then({ -> fern#internal#node#reload(
        \   node,
        \   fern.nodes,
        \   fern.provider,
        \   fern.comparator,
        \   fern.source.token,
        \ )
        \})
        \.then({ ns -> self.update_nodes(ns) })
        \.finally({ -> Profile() })
endfunction
let s:async.reload_node = funcref('s:async_reload_node')

function! s:async_reveal_node(key) abort dict
  let helper = self.helper
  let fern = helper.fern
  let l:Profile = fern#profile#start('fern#helper:helper.async.reveal_node')
  return s:Promise.resolve()
        \.then({ -> fern#internal#node#reveal(
        \   a:key,
        \   fern.nodes,
        \   fern.provider,
        \   fern.comparator,
        \   fern.source.token,
        \ )
        \})
        \.then({ ns -> self.update_nodes(ns) })
        \.finally({ -> Profile() })
endfunction
let s:async.reveal_node = funcref('s:async_reveal_node')

function! s:async_enter_tree(node) abort dict
  let helper = self.helper
  let fern = helper.fern
  if a:node.status is# helper.STATUS_NONE
    return s:Promise.reject()
  endif
  let saved = {
        \ 'hidden': fern.hidden,
        \ 'include': fern.include,
        \ 'exclude': fern.exclude,
        \}
  return s:Promise.resolve(a:node)
        \.then({ n -> s:enter(fern, n) })
        \.then({ bufnr -> fern#helper#new(bufnr) })
        \.then({ helper -> s:async_enter_tree_post(helper, saved) })
endfunction
function! s:async_enter_tree_post(helper, saved) abort
  let fern = a:helper.fern
  let fern.hidden = a:saved.hidden
  let fern.include = a:saved.include
  let fern.exclude = a:saved.exclude
  return a:helper.async.update_nodes(fern.nodes)
        \.then({ -> a:helper.async.redraw() })
endfunction
let s:async.enter_tree = funcref('s:async_enter_tree')

function! s:async_leave_tree() abort dict
  let helper = self.helper
  let fern = helper.fern
  let root = helper.sync.get_root_node()
  let saved = {
        \ 'name': root.name,
        \ 'hidden': fern.hidden,
        \ 'include': fern.include,
        \ 'exclude': fern.exclude,
        \}
  return s:Promise.resolve()
        \.then({ -> fern#internal#node#parent(
        \   root,
        \   fern.provider,
        \   fern.source.token,
        \ )
        \})
        \.then({ n -> s:enter(fern, n) })
        \.then({ bufnr -> fern#helper#new(bufnr) })
        \.then({ helper -> s:async_leave_tree_post(helper, saved) })
endfunction
function! s:async_leave_tree_post(helper, saved) abort
  let fern = a:helper.fern
  let fern.hidden = a:saved.hidden
  let fern.include = a:saved.include
  let fern.exclude = a:saved.exclude
  return a:helper.async.update_nodes(fern.nodes)
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node([a:saved.name]) })
endfunction
let s:async.leave_tree = funcref('s:async_leave_tree')

function! s:async_collapse_modified_nodes(nodes) abort dict
  let helper = self.helper
  let fern = helper.fern
  let ps = []
  for node in a:nodes
    if node.__owner is# v:null || node.status isnot# helper.STATUS_EXPANDED
      continue
    endif
    let p = fern#internal#node#collapse(
          \ node,
          \ fern.nodes,
          \ fern.provider,
          \ fern.comparator,
          \ fern.source.token,
          \)
          \.then({ ns -> self.update_nodes(ns) })
    call add(ps, p)
  endfor
  let l:Profile = fern#profile#start('fern#helper:helper.async.collapse_modified_nodes')
  return s:Promise.all(ps)
        \.finally({ -> Profile() })
endfunction
let s:async.collapse_modified_nodes = funcref('s:async_collapse_modified_nodes')


" Private
function! s:enter(fern, node) abort
  if !has_key(a:node, 'bufname')
    return s:Promise.reject('the node does not have bufname attribute')
  endif
  try
    let cur = fern#fri#parse(bufname('%'))
    let fri = fern#fri#parse(a:node.bufname)
    let fri.authority = cur.authority
    let fri.query = cur.query
    return fern#internal#viewer#open(fri, {})
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction
./autoload/fern/helper/sync.vim	[[[1
188
let s:Promise = vital#fern#import('Async.Promise')
let s:WindowCursor = vital#fern#import('Vim.Window.Cursor')

function! fern#helper#sync#new(helper) abort
  let sync = extend({ 'helper': a:helper }, s:sync)
  let sync.__cache = {
        \ 'previous_cursor_node': v:null,
        \}
  return sync
endfunction

let s:sync = {}

function! s:sync_winid() abort dict
  let helper = self.helper
  if win_id2tabwin(helper.winid) != [0, 0]
    return helper.winid
  endif
  " Original window has disappeared
  let winids = win_findbuf(helper.bufnr)
  let helper.winid = len(winids) is# 0 ? -1 : winids[0]
  return helper.winid
endfunction
let s:sync.winid = funcref('s:sync_winid')

function! s:sync_echo(message, ...) abort dict
  let hl = a:0 ? a:1 : 'None'
  try
    execute printf('echohl %s', hl)
    echo a:message
  finally
    echohl None
  endtry
endfunction
let s:sync.echo = funcref('s:sync_echo')

function! s:sync_echomsg(message, ...) abort dict
  let hl = a:0 ? a:1 : 'None'
  try
    execute printf('echohl %s', hl)
    echomsg a:message
  finally
    echohl None
  endtry
endfunction
let s:sync.echomsg = funcref('s:sync_echomsg')

function! s:sync_get_root_node() abort dict
  let helper = self.helper
  let fern = helper.fern
  return fern.root
endfunction
let s:sync.get_root_node = funcref('s:sync_get_root_node')

function! s:sync_get_cursor_node() abort dict
  let helper = self.helper
  let fern = helper.fern
  let cursor = self.get_cursor()
  let index = fern.renderer.index(cursor[0])
  return get(fern.visible_nodes, index, v:null)
endfunction
let s:sync.get_cursor_node = funcref('s:sync_get_cursor_node')

function! s:sync_get_marked_nodes() abort dict
  let helper = self.helper
  let fern = helper.fern
  let ms = fern.marks
  return filter(
        \ copy(fern.visible_nodes),
        \ { _, v -> index(ms, v.__key) isnot# -1 },
        \)
endfunction
let s:sync.get_marked_nodes = funcref('s:sync_get_marked_nodes')

function! s:sync_get_selected_nodes() abort dict
  let helper = self.helper
  let fern = helper.fern
  if empty(fern.marks)
    return [self.get_cursor_node()]
  endif
  return self.get_marked_nodes()
endfunction
let s:sync.get_selected_nodes = funcref('s:sync_get_selected_nodes')

function! s:sync_get_cursor() abort dict
  let helper = self.helper
  let fern = helper.fern
  let winid = self.winid()
  if winid is# -1
    return [0, 0]
  endif
  return s:WindowCursor.get_cursor(winid)
endfunction
let s:sync.get_cursor = funcref('s:sync_get_cursor')

function! s:sync_set_cursor(cursor) abort dict
  let helper = self.helper
  let fern = helper.fern
  let winid = self.winid()
  if winid is# -1
    return
  endif
  call s:WindowCursor.set_cursor(winid, a:cursor)
  call setbufvar(helper.bufnr, 'fern_cursor', a:cursor)
endfunction
let s:sync.set_cursor = funcref('s:sync_set_cursor')

function! s:sync_save_cursor() abort dict
  let helper = self.helper
  let fern = helper.fern
  let self.__cache.previous_cursor_node = self.get_cursor_node()
  return s:Promise.resolve()
endfunction
let s:sync.save_cursor = funcref('s:sync_save_cursor')

function! s:sync_restore_cursor() abort dict
  let helper = self.helper
  let fern = helper.fern
  if empty(self.__cache.previous_cursor_node)
    return s:Promise.resolve()
  endif
  return self.focus_node(self.__cache.previous_cursor_node.__key)
endfunction
let s:sync.restore_cursor = funcref('s:sync_restore_cursor')

function! s:sync_cancel() abort dict
  let helper = self.helper
  let fern = helper.fern
  call fern#internal#core#cancel(fern)
endfunction
let s:sync.cancel = funcref('s:sync_cancel')

function! s:sync_is_drawer() abort dict
  let helper = self.helper
  let fern = helper.fern
  return fern#internal#drawer#is_drawer(bufname(helper.bufnr))
endfunction
let s:sync.is_drawer = funcref('s:sync_is_drawer')

function! s:sync_is_left_drawer() abort dict
  let helper = self.helper
  let fern = helper.fern
  return fern#internal#drawer#is_left_drawer(bufname(helper.bufnr))
endfunction
let s:sync.is_left_drawer = funcref('s:sync_is_left_drawer')

function! s:sync_is_right_drawer() abort dict
  let helper = self.helper
  let fern = helper.fern
  return fern#internal#drawer#is_right_drawer(bufname(helper.bufnr))
endfunction
let s:sync.is_right_drawer = funcref('s:sync_is_right_drawer')

function! s:sync_get_scheme() abort dict
  let helper = self.helper
  let fern = helper.fern
  let fri = fern#fri#parse(bufname(helper.bufnr))
  let fri = fern#fri#parse(fri.path)
  return fri.scheme
endfunction
let s:sync.get_scheme = funcref('s:sync_get_scheme')

function! s:sync_process_node(node) abort dict
  return fern#internal#node#process(a:node)
endfunction
let s:sync.process_node = funcref('s:sync_process_node')

function! s:sync_focus_node(key, ...) abort dict
  let helper = self.helper
  let fern = helper.fern
  let options = extend({
        \ 'offset': 0,
        \ 'previous': v:null
        \}, a:0 ? a:1 : {})
  let index = fern#internal#node#index(a:key, fern.visible_nodes)
  if index is# -1
    if !empty(a:key)
      return self.focus_node(a:key[:-2], options)
    endif
    throw printf('failed to find a node %s', a:key)
  endif
  let current = self.get_cursor_node()
  if options.previous is# v:null || options.previous == current
    let lnum = fern.renderer.lnum(index + options.offset)
    call self.set_cursor([lnum, 1])
  endif
endfunction
let s:sync.focus_node = funcref('s:sync_focus_node')
./autoload/fern/helper.vim	[[[1
25
function! fern#helper#new(...) abort
  let bufnr = a:0 ? a:1 : bufnr('%')
  let fern = getbufvar(bufnr, 'fern', v:null)
  if fern is# v:null
    throw printf('the buffer %s is not properly initialized for fern', bufnr)
  endif
  let helper = extend({
        \ 'fern': fern,
        \ 'bufnr': bufnr,
        \ 'winid': bufnr('%') == bufnr ? win_getid() : bufwinid(bufnr),
        \}, s:helper)
  let helper.sync = fern#helper#sync#new(helper)
  let helper.async = fern#helper#async#new(helper)
  return helper
endfunction

function! fern#helper#call(fn, ...) abort
  return call(a:fn, [fern#helper#new()] + a:000)
endfunction

let s:helper = {
      \ 'STATUS_NONE': g:fern#STATUS_NONE,
      \ 'STATUS_COLLAPSED': g:fern#STATUS_COLLAPSED,
      \ 'STATUS_EXPANDED': g:fern#STATUS_EXPANDED,
      \}
./autoload/fern/hook.vim	[[[1
51
let s:Promise = vital#fern#import('Async.Promise')
let s:hooks = {}

function! fern#hook#add(name, callback, ...) abort
  let options = extend({
        \ 'id': sha256(localtime()),
        \ 'once': v:false,
        \}, a:0 ? a:1 : {},
        \)
  let s:hooks[a:name] = add(get(s:hooks, a:name, []), {
        \ 'callback': a:callback,
        \ 'options': options,
        \})
endfunction

function! fern#hook#remove(name, ...) abort
  let id = a:0 ? a:1 : v:null
  if id is# v:null
    let s:hooks[a:name] = []
    return
  endif
  let hooks = get(s:hooks, a:name, [])
  let keeps = []
  for hook in hooks
    if hook.options.id !=# id
      call add(keeps, hook)
    endif
  endfor
  let s:hooks[a:name] = keeps
endfunction

function! fern#hook#emit(name, ...) abort
  let hooks = get(s:hooks, a:name, [])
  let keeps = []
  for hook in hooks
    try
      call call(hook.callback, a:000)
      if !hook.options.once
        call add(keeps, hook)
      endif
    catch
      call fern#logger#error(v:exception)
      call fern#logger#debug(v:throwpoint)
    endtry
  endfor
  let s:hooks[a:name] = keeps
endfunction

function! fern#hook#promise(name) abort
  return s:Promise.new({ r -> fern#hook#add(a:name, r, { 'once': v:true }) })
endfunction
./autoload/fern/internal/args.vim	[[[1
54
function! fern#internal#args#split(cmd) abort
  let sq = '''\zs[^'']\+\ze'''
  let dq = '"\zs[^"]\+\ze"'
  let bs = '\%(\\\s\|[^ ''"]\)\+'
  let pp = printf(
        \ '\%%(%s\)*\zs\%%(\s\+\|$\)\ze',
        \ join([sq, dq, bs], '\|')
        \)
  let np = '^\%("\zs.*\ze"\|''\zs.*\ze''\|.*\)$'
  return map(split(a:cmd, pp), { -> matchstr(v:val, np) })
endfunction

function! fern#internal#args#index(args, pattern) abort
  for index in range(len(a:args))
    if a:args[index] =~# a:pattern
      return index
    endif
  endfor
  return -1
endfunction

function! fern#internal#args#set(args, name, value) abort
  let pattern = printf('^-%s\%(=.*\)\?$', a:name)
  let index = fern#internal#args#index(a:args, pattern)
  let value = a:value is# v:true
        \ ? printf('-%s', a:name)
        \ : printf('-%s=%s', a:name, a:value)
  if index is# -1
    call add(a:args, value)
  else
    let a:args[index] = value
  endif
endfunction

function! fern#internal#args#pop(args, name, default) abort
  let pattern = printf('^-%s\%(=.*\)\?$', a:name)
  let index = fern#internal#args#index(a:args, pattern)
  if index is# -1
    return a:default
  else
    let value = remove(a:args, index)
    return value =~# '^-[^=]\+='
          \ ? matchstr(value, '=\zs.*$')
          \ : v:true
  endif
endfunction

function! fern#internal#args#throw_if_dirty(args) abort
  for arg in a:args
    if arg =~# '^-'
      throw printf('unknown option %s has specified', arg)
    endif
  endfor
endfunction
./autoload/fern/internal/buffer.vim	[[[1
132
let s:edit_or_opener_pattern = '\<edit/\zs\%(split\|vsplit\|tabedit\)\>'

function! fern#internal#buffer#replace(bufnr, content) abort
  let modified_saved = getbufvar(a:bufnr, '&modified')
  let modifiable_saved = getbufvar(a:bufnr, '&modifiable')
  try
    call setbufvar(a:bufnr, '&modifiable', 1)

    if g:fern#enable_textprop_support
      call s:replace_buffer_content(a:bufnr, a:content)
    else
      call setbufline(a:bufnr, 1, a:content)
      call deletebufline(a:bufnr, len(a:content) + 1, '$')
    endif
  finally
    call setbufvar(a:bufnr, '&modifiable', modifiable_saved)
    call setbufvar(a:bufnr, '&modified', modified_saved)
  endtry
endfunction

" Replace buffer content with lines of text with (optional) text properties.
function! s:replace_buffer_content(bufnr, content) abort
  for lnum in range(len(a:content))
    let line = a:content[lnum]
    let [text, props] = type(line) is# v:t_dict
      \ ? [line.text, get(line, 'props', [])]
      \ : [line, []]

    call setbufline(a:bufnr, lnum + 1, text)

    if exists('*prop_add')
      for prop in props
        let prop.bufnr = a:bufnr
        call prop_add(lnum + 1, prop.col, prop)
      endfor
    endif
  endfor

  call deletebufline(a:bufnr, len(a:content) + 1, '$')
endfunction

function! fern#internal#buffer#open(bufname, ...) abort
  let options = extend({
        \ 'opener': 'edit',
        \ 'mods': '',
        \ 'cmdarg': '',
        \ 'locator': 0,
        \ 'keepalt': 0,
        \ 'keepjumps': 0,
        \}, a:0 ? a:1 : {},
        \)
  if options.opener ==# 'select'
    let options.opener = 'edit'
    if fern#internal#window#select()
      return 1
    endif
  else
    if options.locator
      call fern#internal#locator#focus(winnr('#'))
    endif
  endif
  if options.opener =~# s:edit_or_opener_pattern
    let opener2 = matchstr(options.opener, s:edit_or_opener_pattern)
    let options.opener = &modified ? opener2 : 'edit'
  endif
  if options.keepalt && options.opener ==# 'edit'
    let options.mods .= ' keepalt'
  endif
  if options.keepjumps && options.opener ==# 'edit'
    let options.mods .= ' keepjumps'
  endif
  " Use user frindly path on a real path to fix #284
  let bufname = filereadable(a:bufname)
        \ ? fnamemodify(a:bufname, ':~:.')
        \ : a:bufname
  let args = [
        \ options.mods,
        \ options.cmdarg,
        \ options.opener,
        \ fnameescape(bufname),
        \]
  let cmdline = join(filter(args, { -> !empty(v:val) }), ' ')
  call fern#logger#debug('fern#internal#buffer#open', 'cmdline', cmdline)
  execute cmdline
endfunction

function! fern#internal#buffer#removes(paths) abort
  for path in a:paths
    let bufnr = bufnr(path)
    if bufnr is# -1 || getbufvar(bufnr, '&modified')
      continue
    endif
    execute printf('silent! noautocmd %dbwipeout', bufnr)
  endfor
endfunction

function! fern#internal#buffer#renames(pairs) abort
  let bufnr_saved = bufnr('%')
  let hidden_saved = &bufhidden
  set bufhidden=hide
  try
    for [src, dst] in a:pairs
      let bufnr = bufnr(src)
      if bufnr is# -1
        return
      endif
      execute printf('silent! noautocmd keepjumps keepalt %dbuffer', bufnr)
      execute printf('silent! noautocmd keepalt file %s', fnameescape(dst))
      call s:patch_to_avoid_e13()
    endfor
  finally
    execute printf('keepjumps keepalt %dbuffer!', bufnr_saved)
    let &bufhidden = hidden_saved
  endtry
endfunction

" NOTE: Perform pseudo 'write!' to avoid E13
function! s:patch_to_avoid_e13() abort
  augroup fern_internal_buffer_patch_to_avoid_e13
    autocmd! * <buffer>
    autocmd BufWriteCmd <buffer> ++once :
  augroup END
  let buftype = &buftype
  let modified = &modified
  try
    setlocal buftype=acwrite
    silent! write!
  finally
    let &buftype = buftype
    let &modified = modified
  endtry
endfunction
./autoload/fern/internal/command/do.vim	[[[1
51
function! fern#internal#command#do#command(mods, fargs) abort
  let winid_saved = win_getid()
  try
    let stay = fern#internal#args#pop(a:fargs, 'stay', v:false)
    let drawer = fern#internal#args#pop(a:fargs, 'drawer', v:false)
    let right = fern#internal#args#pop(a:fargs, 'right', v:false)

    if len(a:fargs) is# 0
          \ || type(stay) isnot# v:t_bool
          \ || type(drawer) isnot# v:t_bool
          \ || type(right) isnot# v:t_bool
      throw 'Usage: FernDo {expr...} [-drawer] [-right] [-stay]'
    endif

    " Does all options are handled?
    call fern#internal#args#throw_if_dirty(a:fargs)

    let found = fern#internal#window#find(
          \ funcref('s:predicator', [drawer, right]),
          \ winnr() + 1,
          \)
    if !found
      return
    endif
    call win_gotoid(win_getid(found))
    execute join([a:mods] + a:fargs, ' ')
  catch
    echohl ErrorMsg
    echo v:exception
    echohl None
    call fern#logger#debug(v:exception)
    call fern#logger#debug(v:throwpoint)
  finally
    if stay
      call win_gotoid(winid_saved)
    endif
  endtry
endfunction

function! fern#internal#command#do#complete(arglead, cmdline, cursorpos) abort
  return fern#internal#complete#options(a:arglead, a:cmdline, a:cursorpos)
endfunction

function! s:predicator(drawer, right, winnr) abort
  let bufname = bufname(winbufnr(a:winnr))
  let fri = fern#fri#parse(bufname)
  return fri.scheme ==# 'fern' && (!a:drawer
        \ || (!a:right && fri.authority =~# '^drawer:')
        \ || (a:right && fri.authority =~# '^drawer-right:')
        \)
endfunction
./autoload/fern/internal/command/fern.vim	[[[1
141
let s:Promise = vital#fern#import('Async.Promise')
let s:drawer_left_opener = 'topleft vsplit'
let s:drawer_right_opener = 'botright vsplit'

function! fern#internal#command#fern#command(mods, fargs) abort
  try
    let stay = fern#internal#args#pop(a:fargs, 'stay', v:false)
    let wait = fern#internal#args#pop(a:fargs, 'wait', v:false)
    let reveal = fern#internal#args#pop(a:fargs, 'reveal', '')
    let drawer = fern#internal#args#pop(a:fargs, 'drawer', v:false)
    if drawer
      let width = fern#internal#args#pop(a:fargs, 'width', '')
      let keep = fern#internal#args#pop(a:fargs, 'keep', v:false)
      let toggle = fern#internal#args#pop(a:fargs, 'toggle', v:false)
      let right = fern#internal#args#pop(a:fargs, 'right', v:false)
      let opener = right ? s:drawer_right_opener : s:drawer_left_opener
    else
      let opener = fern#internal#args#pop(a:fargs, 'opener', g:fern#opener)
      let width = ''
      let keep = v:false
      let toggle = v:false
      let right = v:false
    endif

    if len(a:fargs) isnot# 1
          \ || type(stay) isnot# v:t_bool
          \ || type(wait) isnot# v:t_bool
          \ || type(reveal) isnot# v:t_string
          \ || type(drawer) isnot# v:t_bool
          \ || type(opener) isnot# v:t_string
          \ || type(width) isnot# v:t_string
          \ || type(keep) isnot# v:t_bool
          \ || type(toggle) isnot# v:t_bool
          \ || type(right) isnot# v:t_bool
      if empty(drawer)
        throw 'Usage: Fern {url} [-opener={opener}] [-stay] [-wait] [-reveal={reveal}]'
      else
        throw 'Usage: Fern {url} -drawer [-right] [-toggle] [-keep] [-width={width}] [-stay] [-wait] [-reveal={reveal}]'
      endif
    endif

    " Does all options are handled?
    call fern#internal#args#throw_if_dirty(a:fargs)

    " Force project drawer style when
    " - The current buffer is project drawer style fern
    " - The 'opener' is 'edit'
    if opener ==# 'edit'
      if fern#internal#drawer#is_left_drawer()
        let drawer = v:true
        let opener = s:drawer_left_opener
      elseif right && fern#internal#drawer#is_right_drawer()
        let drawer = v:true
        let opener = s:drawer_right_opener
      endif
    endif

    let expr = fern#util#expand(a:fargs[0])
    let path = fern#fri#format(
          \ expr =~# '^[^:]\+://'
          \   ? fern#fri#parse(expr)
          \   : fern#fri#from#filepath(fnamemodify(expr, ':p'))
          \)
    " Build FRI for fern buffer from argument
    let fri = fern#fri#new({
          \ 'scheme': 'fern',
          \ 'path': path,
          \})
    let fri.authority = drawer
          \ ? right
          \   ? printf('drawer-right:%d', tabpagenr())
          \   : printf('drawer:%d', tabpagenr())
          \ : ''
    if drawer && g:fern#disable_drawer_tabpage_isolation
      let fri.authority = right ? 'drawer-right:0' : 'drawer:0'
    endif
    let fri.query = extend(fri.query, {
          \ 'width': width,
          \ 'keep': keep,
          \})
    call fern#logger#debug('expr:', expr)
    call fern#logger#debug('fri:', fri)

    " A promise which will be resolved once the viewer become ready
    let waiter = fern#hook#promise('viewer:ready')

    " Register callback to reveal node
    let reveal = fern#internal#command#reveal#normalize(fri, reveal)
    if reveal !=# ''
      let waiter = waiter.then({ h -> fern#internal#viewer#reveal(h, reveal) })
    endif

    let winid_saved = win_getid()
    if fri.authority =~# '^drawer\(-right\)\?:'
      call fern#internal#drawer#open(fri, {
            \ 'mods': a:mods,
            \ 'toggle': toggle,
            \ 'opener': opener,
            \ 'stay': stay ? win_getid() : 0,
            \ 'right': right,
            \})
    else
      call fern#internal#viewer#open(fri, {
            \ 'mods': a:mods,
            \ 'opener': opener,
            \ 'stay': stay ? win_getid() : 0,
            \})
    endif

    if stay
      call win_gotoid(winid_saved)
    endif

    if wait
      let [_, err] = s:Promise.wait(waiter, {
            \ 'interval': 100,
            \ 'timeout': 5000,
            \})
      if err isnot# v:null
        throw printf('[fern] Failed to wait: %s', err)
      endif
    endif
  catch
    echohl ErrorMsg
    echomsg v:exception
    echohl None
    call fern#logger#debug(v:exception)
    call fern#logger#debug(v:throwpoint)
  endtry
endfunction

function! fern#internal#command#fern#complete(arglead, cmdline, cursorpos) abort
  if a:arglead =~# '^-opener='
    return fern#internal#complete#opener(a:arglead, a:cmdline, a:cursorpos)
  elseif a:arglead =~# '^-reveal='
    return fern#internal#complete#reveal(a:arglead, a:cmdline, a:cursorpos)
  elseif a:arglead =~# '^-'
    return fern#internal#complete#options(a:arglead, a:cmdline, a:cursorpos)
  endif
  return fern#internal#complete#url(a:arglead, a:cmdline, a:cursorpos)
endfunction
./autoload/fern/internal/command/reveal.vim	[[[1
64
let s:Promise = vital#fern#import('Async.Promise')

function! fern#internal#command#reveal#command(modes, fargs) abort
  try
    let wait = fern#internal#args#pop(a:fargs, 'wait', v:false)
    if len(a:fargs) isnot# 1
          \ || type(wait) isnot# v:t_bool
      throw 'Usage: FernReveal {reveal} [-wait]'
    endif

    " Does all options are handled?
    call fern#internal#args#throw_if_dirty(a:fargs)

    let helper = fern#helper#new()
    let reveal = fern#internal#command#reveal#normalize(
          \ fern#fri#parse(bufname('%')),
          \ a:fargs[0],
          \)
    let promise = fern#internal#viewer#reveal(helper, reveal)
    call fern#logger#debug('reveal:', reveal)

    if wait
      let [_, err] = s:Promise.wait(promise, {
            \ 'interval': 100,
            \ 'timeout': 5000,
            \})
      if err isnot# v:null
        throw printf('[fern] Failed to wait: %s', err)
      endif
    endif
  catch
    echohl ErrorMsg
    echomsg v:exception
    echohl None
    call fern#logger#debug(v:exception)
    call fern#logger#debug(v:throwpoint)
  endtry
endfunction

function! fern#internal#command#reveal#complete(arglead, cmdline, cursorpos) abort
  if a:arglead =~# '^-'
    return fern#internal#complete#options(a:arglead, a:cmdline, a:cursorpos)
  endif
  let helper = fern#helper#new()
  let fri = fern#fri#parse(bufname('%'))
  let scheme = helper.fern.scheme
  let cmdline = fri.path
  let arglead = printf('-reveal=%s', a:arglead)
  let rs = fern#internal#complete#reveal(arglead, cmdline, a:cursorpos)
  return map(rs, { -> matchstr(v:val, '-reveal=\zs.*') })
endfunction

function! fern#internal#command#reveal#normalize(fri, reveal) abort
  let reveal = fern#util#expand(a:reveal)
  if empty(reveal) || !fern#internal#filepath#is_absolute(reveal)
    return reveal
  endif
  " reveal points a real filesystem
  let fri = fern#fri#parse(a:fri.path)
  let root = '/' . fri.path
  let reveal = fern#internal#filepath#to_slash(reveal)
  let reveal = fern#internal#path#relative(reveal, root)
  return reveal
endfunction
./autoload/fern/internal/complete.vim	[[[1
71
let s:ESCAPE_PATTERN = '^$~.*[]\'

let s:openers = [
      \ 'select',
      \ 'edit',
      \ 'edit/split',
      \ 'edit/vsplit',
      \ 'edit/tabedit',
      \ 'split',
      \ 'vsplit',
      \ 'tabedit',
      \ 'leftabove\ split',
      \ 'leftabove\ vsplit',
      \ 'rightbelow\ split',
      \ 'rightbelow\ vsplit',
      \ 'topleft\ split',
      \ 'topleft\ vsplit',
      \ 'botright\ split',
      \ 'botright\ vsplit',
      \]

let s:options = {
      \ 'Fern': [
      \   '-drawer',
      \   '-keep',
      \   '-opener=',
      \   '-reveal=',
      \   '-stay',
      \   '-toggle',
      \   '-wait',
      \   '-width=',
      \ ],
      \ 'FernDo': [
      \   '-drawer',
      \   '-stay',
      \ ],
      \ 'FernReveal': [
      \   '-wait',
      \ ],
      \}

function! fern#internal#complete#opener(arglead, cmdline, cursorpos) abort
  let pattern = '^' . escape(a:arglead, s:ESCAPE_PATTERN)
  let candidates = map(copy(s:openers), { _, v -> printf('-opener=%s', v) })
  return filter(candidates, { _, v -> v =~# pattern })
endfunction

function! fern#internal#complete#options(arglead, cmdline, cursorpos) abort
  let pattern = '^' . escape(a:arglead, s:ESCAPE_PATTERN)
  let command = matchstr(a:cmdline, '^\w\+')
  let candidates = get(s:options, command, [])
  return filter(copy(candidates), { _, v -> v =~# pattern })
endfunction

function! fern#internal#complete#url(arglead, cmdline, cursorpos) abort
  let scheme = matchstr(a:arglead, '^[^:]\+\ze://')
  if empty(scheme)
    return fern#scheme#file#complete#filepath(a:arglead, a:cmdline, a:cursorpos)
  endif
  let rs = fern#internal#scheme#complete_url(scheme, a:arglead, a:cmdline, a:cursorpos)
  return rs is# v:null ? [printf('%s:///', scheme)] : rs
endfunction

function! fern#internal#complete#reveal(arglead, cmdline, cursorpos) abort
  let scheme = matchstr(a:cmdline, '\<[^ :]\+\ze://')
  if empty(scheme)
    return fern#scheme#file#complete#filepath_reveal(a:arglead, a:cmdline, a:cursorpos)
  endif
  let rs = fern#internal#scheme#complete_reveal(scheme, a:arglead, a:cmdline, a:cursorpos)
  return rs is# v:null ? [] : rs
endfunction
./autoload/fern/internal/core.vim	[[[1
100
let s:Config = vital#fern#import('Config')
let s:Lambda = vital#fern#import('Lambda')
let s:AsyncLambda = vital#fern#import('Async.Lambda')
let s:Promise = vital#fern#import('Async.Promise')
let s:CancellationTokenSource = vital#fern#import('Async.CancellationTokenSource')

let s:STATUS_EXPANDED = g:fern#STATUS_EXPANDED
let s:default_renderer = function('fern#renderer#default#new')
let s:default_comparator = function('fern#comparator#default#new')

function! fern#internal#core#new(url, provider, ...) abort
  let options = extend({
        \ 'renderer': g:fern#renderer,
        \ 'comparator': g:fern#comparator,
        \}, a:0 ? a:1 : {},
        \)
  let scheme = fern#fri#parse(a:url).scheme
  let root = fern#internal#node#root(a:url, a:provider)
  let fern = {
        \ 'scheme': scheme,
        \ 'source': s:CancellationTokenSource.new(),
        \ 'provider': a:provider,
        \ 'renderer': s:get_renderer(options.renderer),
        \ 'comparator': s:get_comparator(options.comparator),
        \ 'root': root,
        \ 'nodes': [root],
        \ 'visible_nodes': [root],
        \ 'marks': [],
        \ 'hidden': g:fern#default_hidden,
        \ 'include': g:fern#default_include,
        \ 'exclude': g:fern#default_exclude,
        \}
  return fern
endfunction

function! fern#internal#core#cancel(fern) abort
  call a:fern.source.cancel()
  let a:fern.source = s:CancellationTokenSource.new()
endfunction

function! fern#internal#core#update_nodes(fern, nodes) abort
  let a:fern.nodes = a:nodes
  let include = a:fern.include
  let exclude = a:fern.exclude
  let l:Hidden = a:fern.hidden
       \ ? { -> 1 }
       \ : { n -> n.status is# s:STATUS_EXPANDED || !n.hidden }
  let l:Include = empty(include)
       \ ? { -> 1 }
       \ : { n -> n.status is# s:STATUS_EXPANDED || n.label =~ include }
  let l:Exclude  = empty(exclude)
       \ ? { -> 1 }
       \ : { n -> n.status is# s:STATUS_EXPANDED || n.label !~ exclude }
  let l:Profile = fern#profile#start('fern#internal#core#update_nodes')
  return s:Promise.resolve(a:fern.nodes)
        \.then(s:AsyncLambda.filter_f(Hidden))
        \.finally({ -> Profile('hidden') })
        \.then(s:AsyncLambda.filter_f(Include))
        \.finally({ -> Profile('include') })
        \.then(s:AsyncLambda.filter_f(Exclude))
        \.finally({ -> Profile('exclude') })
        \.then({ ns -> s:Lambda.let(a:fern, 'visible_nodes', ns) })
        \.finally({ -> Profile('let') })
        \.then({ -> fern#internal#core#update_marks(a:fern, a:fern.marks) })
        \.finally({ -> Profile() })
endfunction

function! fern#internal#core#update_marks(fern, marks) abort
  let l:Profile = fern#profile#start('fern#internal#core#update_marks')
  return s:Promise.resolve(a:fern.visible_nodes)
        \.finally({ -> Profile('resolve') })
        \.then(s:AsyncLambda.map_f({ n -> n.__key }))
        \.finally({ -> Profile('key') })
        \.then({ ks -> s:AsyncLambda.filter(a:marks, { m -> index(ks, m) isnot# -1 }) })
        \.finally({ -> Profile('filter') })
        \.then({ ms -> s:Lambda.let(a:fern, 'marks', ms) })
        \.finally({ -> Profile() })
endfunction

function! s:get_renderer(name) abort
  try
    let l:Renderer = get(g:fern#renderers, a:name, s:default_renderer)
    return Renderer()
  catch
    call fern#logger#error('fern#internal#core:get_renderer', v:exception)
    call fern#logger#debug(v:throwpoint)
    return s:default_renderer()
  endtry
endfunction

function! s:get_comparator(name) abort
  try
    let l:Comparator = get(g:fern#comparators, a:name, s:default_comparator)
    return Comparator()
  catch
    call fern#logger#error('fern#internal#core:get_comparator', v:exception)
    call fern#logger#debug(v:throwpoint)
    return s:default_comparator()
  endtry
endfunction
./autoload/fern/internal/cursor.vim	[[[1
50
let s:t_ve_saved = &t_ve
let s:guicursor_saved = &guicursor

function! fern#internal#cursor#hide() abort
  call s:hide()
endfunction

function! fern#internal#cursor#restore() abort
  call s:restore()
endfunction

if has('nvim-0.5.0')
  " https://github.com/neovim/neovim/issues/3688#issuecomment-574544618
  function! s:hide() abort
    set guicursor+=a:FernTransparentCursor/lCursor
  endfunction

  function! s:restore() abort
    set guicursor+=a:Cursor/lCursor
    let &guicursor = s:guicursor_saved
  endfunction

  function! s:highlight() abort
    highlight default FernTransparentCursor gui=strikethrough blend=100
  endfunction
  call s:highlight()

  augroup fern_internal_cursor
    autocmd!
    autocmd ColorScheme * call s:highlight()
  augroup END
elseif has('nvim') || has('gui_running')
  " No way thus use narrow cursor instead
  function! s:hide() abort
    set guicursor+=a:ver1
  endfunction

  function! s:restore() abort
    let &guicursor = s:guicursor_saved
  endfunction
else
  " Vim supports 't_ve'
  function! s:hide() abort
    set t_ve=
  endfunction

  function! s:restore() abort
    let &t_ve = s:t_ve_saved
  endfunction
endif
./autoload/fern/internal/drawer/auto_resize.vim	[[[1
72
function! fern#internal#drawer#auto_resize#init() abort
  if g:fern#disable_drawer_auto_resize
    return
  endif

  if fern#internal#drawer#is_right_drawer()
    augroup fern_internal_drawer_init_right
      autocmd! * <buffer>
      autocmd BufEnter,WinEnter <buffer> call s:load_width_right()
      autocmd WinLeave <buffer> call s:save_width_right()
    augroup END
  else
    augroup fern_internal_drawer_init
      autocmd! * <buffer>
      autocmd BufEnter,WinEnter <buffer> call s:load_width()
      autocmd WinLeave <buffer> call s:save_width()
    augroup END
  endif
endfunction

function! s:count_others() abort
  let bufnr = bufnr('%')
  let bufnrs = map(range(0, winnr('$')), { -> winbufnr(v:val) })
  call filter(bufnrs, { -> bufnr isnot# v:val })
  return len(bufnrs)
endfunction

if has('nvim')
  function! s:should_ignore() abort
    return nvim_win_get_config(win_getid()).relative !=# '' || s:count_others() is# 0
  endfunction
else
  function! s:should_ignore() abort
    return s:count_others() is# 0
  endfunction
endif

function! s:save_width() abort
  if s:should_ignore()
    return
  endif
  let t:fern_drawer_auto_resize_width = winwidth(0)
endfunction

function! s:load_width() abort
  if s:should_ignore()
    return
  endif
  if !exists('t:fern_drawer_auto_resize_width')
    call fern#internal#drawer#resize()
  else
    execute 'vertical resize' t:fern_drawer_auto_resize_width
  endif
endfunction

function! s:save_width_right() abort
  if s:should_ignore()
    return
  endif
  let t:fern_drawer_auto_resize_width_right = winwidth(0)
endfunction

function! s:load_width_right() abort
  if s:should_ignore()
    return
  endif
  if !exists('t:fern_drawer_auto_resize_width_right')
    call fern#internal#drawer#resize()
  else
    execute 'vertical resize' t:fern_drawer_auto_resize_width_right
  endif
endfunction
./autoload/fern/internal/drawer/auto_restore_focus.vim	[[[1
51
let s:info = v:null

function! fern#internal#drawer#auto_restore_focus#init() abort
  if g:fern#disable_drawer_auto_restore_focus
    return
  endif

  augroup fern_internal_drawer_auto_restore_focus_init
    autocmd! * <buffer>
    autocmd WinLeave <buffer> call s:auto_restore_focus_pre()
  augroup END
endfunction

function! s:auto_restore_focus_pre() abort
  let s:info = {
        \ 'nwin': s:nwin(),
        \ 'tabpage': tabpagenr(),
        \ 'prev': win_getid(winnr('#')),
        \}
  call timer_start(0, { -> extend(s:, {'info': v:null}) })
endfunction

function! s:auto_restore_focus() abort
  if s:info is# v:null
    return
  endif
  if s:info.tabpage is# tabpagenr() && s:info.nwin > s:nwin()
    call win_gotoid(s:info.prev)
  endif
  let s:info = v:null
endfunction

if exists('*nvim_win_get_config')
  " NOTE:
  " Remove Neovim flating window from the total count
  function! s:nwin() abort
    return len(filter(
          \ range(1, winnr('$')),
          \ { _, v -> nvim_win_get_config(win_getid(v)).relative ==# '' },
          \))
  endfunction
else
  function! s:nwin() abort
    return winnr('$')
  endfunction
endif

augroup fern_internal_drawer_auto_restore_focus
  autocmd!
  autocmd WinEnter * nested call s:auto_restore_focus()
augroup END
./autoload/fern/internal/drawer/auto_winfixwidth.vim	[[[1
14
function! fern#internal#drawer#auto_winfixwidth#init() abort
  if g:fern#disable_drawer_auto_winfixwidth
    return
  endif

  augroup fern_internal_drawer_auto_winfixwidth_init
    autocmd! * <buffer>
    autocmd BufEnter <buffer> call s:set_winfixwidth()
  augroup END
endfunction

function! s:set_winfixwidth() abort
  let &l:winfixwidth = winnr('$') isnot# 1
endfunction
./autoload/fern/internal/drawer/hover_popup.vim	[[[1
103
let s:win = v:null
let s:show_timer = 0

function! fern#internal#drawer#hover_popup#init() abort
  if g:fern#disable_drawer_hover_popup
    return
  endif

  if !s:available()
    call fern#logger#warn('hover popup is not supported, popup_create() or nvim environment
          \ does not exist. Disable this message
          \ with g:fern#disable_drawer_hover_popup.')
    return
  endif

  augroup fern_internal_drawer_hover_popup_init
    autocmd! * <buffer>
    autocmd CursorMoved <buffer> call s:delayed_show()
    autocmd BufLeave <buffer> call s:hide()
  augroup END
endfunction

function! s:available() abort
  let has_win = has('nvim') || exists('*popup_create')
  return has_win && exists('*win_execute')
endfunction

function! s:delayed_show() abort
  call s:hide()
  let s:show_timer = timer_start(g:fern#drawer_hover_popup_delay, { -> s:show() })
endfunction

function! s:show() abort
  if &filetype !=# 'fern'
    return
  endif
  call s:hide()

  " remove trailing unprintable characters
  let line = substitute(getline('.'), '[^[:print:]]*$', '', 'g')
  let line_width = strdisplaywidth(line)

  " don't show a popup if the line fits in the window
  if line_width < winwidth(0)
    return
  endif

  let helper = fern#helper#new()
  let node = helper.sync.get_cursor_node()
  if node is# v:null
    return
  endif

  if has('nvim')
    let s:win = nvim_open_win(nvim_create_buf(v:false, v:true), v:false, {
          \ 'relative': 'win',
          \ 'bufpos': [line('.') - 2, 0],
          \ 'width': line_width,
          \ 'height': 1,
          \ 'noautocmd': v:true,
          \ 'style': 'minimal',
          \})
  else
    " calculate position of popup
    let curpos = screenpos(win_getid(), getcurpos()[1], 1)
    let s:win = popup_create(line, {
          \ 'line': 'cursor',
          \ 'col': curpos['col'],
          \ 'maxwidth': line_width,
          \})
  endif

  function! s:apply() abort closure
    call setbufline('%', 1, line)
    call helper.fern.renderer.syntax()
    call helper.fern.renderer.highlight()
    syntax clear FernRootSymbol
    syntax clear FernRootText

    setlocal nowrap cursorline noswapfile nobuflisted buftype=nofile bufhidden=hide
    if has('nvim')
      setlocal winhighlight=NormalFloat:Normal
    endif
  endfunction
  call win_execute(s:win, 'call s:apply()', v:true)
endfunction

function! s:hide() abort
  call timer_stop(s:show_timer)

  if s:win is# v:null
    return
  endif
  if has('nvim')
    if nvim_win_is_valid(s:win)
      call nvim_win_close(s:win, v:true)
    endif
  else
    call popup_close(s:win)
  endif
  let s:win = v:null
endfunction

./autoload/fern/internal/drawer/smart_quit.vim	[[[1
58
let s:QuitPre_called = 0

function! fern#internal#drawer#smart_quit#init() abort
  if g:fern#disable_drawer_smart_quit
    return
  endif

  augroup fern_internal_drawer_smart_quit_init
    autocmd! * <buffer>
    autocmd BufEnter <buffer> nested call s:smart_quit()
  augroup END
endfunction

function! s:smart_quit_pre() abort
  let s:QuitPre_called = 1
  call timer_start(0, { -> extend(s:, {'QuitPre_called': 1}) })
endfunction

function! s:smart_quit() abort
  if !s:QuitPre_called
    return
  endif
  let s:QuitPre_called = 0
  let fri = fern#fri#parse(bufname('%'))
  let keep = get(fri.query, 'keep', g:fern#drawer_keep)
  let width = str2nr(get(fri.query, 'width', string(g:fern#drawer_width)))
  if winnr('$') isnot# 1
    " Not a last window
    return
  elseif keep
    " Add a new window to avoid being a last window
    let winid = win_getid()
    if has('patch-8.1.1756') || has('nvim-0.7.1')
      " Use timer to avoid E242 in Vim
      " https://github.com/lambdalisue/fern.vim/issues/435
      call timer_start(0, { -> s:complement(winid, width) })
    else
      call s:complement(winid, width)
    endif
  else
    " This window is a last window of a current tabpage
    quit
  endif
endfunction

function! s:complement(winid, width) abort
  keepjumps call win_gotoid(a:winid)
  vertical botright new
  let winid_saved = win_getid()
  keepjumps call win_gotoid(a:winid)
  execute 'vertical resize' a:width
  keepjumps call win_gotoid(winid_saved)
endfunction

augroup fern_internal_drawer_smart_quit
  autocmd!
  autocmd QuitPre * call s:smart_quit_pre()
augroup END
./autoload/fern/internal/drawer.vim	[[[1
72
function! fern#internal#drawer#is_drawer(...) abort
  let bufname = a:0 ? a:1 : bufname('%')
  let fri = fern#fri#parse(bufname)
  return fri.scheme ==# 'fern' && fri.authority =~# '^drawer\(-right\)\?:'
endfunction

function! fern#internal#drawer#is_left_drawer(...) abort
  let bufname = a:0 ? a:1 : bufname('%')
  let fri = fern#fri#parse(bufname)
  return fri.scheme ==# 'fern' && fri.authority =~# '^drawer:'
endfunction

function! fern#internal#drawer#is_right_drawer(...) abort
  let bufname = a:0 ? a:1 : bufname('%')
  let fri = fern#fri#parse(bufname)
  return fri.scheme ==# 'fern' && fri.authority =~# '^drawer-right:'
endfunction

function! fern#internal#drawer#resize() abort
  let fri = fern#fri#parse(bufname('%'))
  let width = str2nr(get(fri.query, 'width', string(g:fern#drawer_width)))
  execute 'vertical resize' width
endfunction

function! fern#internal#drawer#open(fri, ...) abort
  let options = extend({
        \ 'toggle': 0,
        \ 'right': 0,
        \}, a:0 ? a:1 : {},
        \)
  if s:focus_next(options.right)
    if winnr('$') > 1
      if options.toggle
        close
        return
      endif
      let options.opener = 'edit'
    endif
  endif
  " Force 'keepalt' to fix #249
  let options.mods = join(['keepalt', get(options, 'mods', '')])
  return fern#internal#viewer#open(a:fri, options)
endfunction

function! fern#internal#drawer#init() abort
  if !fern#internal#drawer#is_drawer()
    return
  endif

  call fern#internal#drawer#auto_resize#init()
  call fern#internal#drawer#auto_winfixwidth#init()
  call fern#internal#drawer#auto_restore_focus#init()
  call fern#internal#drawer#smart_quit#init()
  call fern#internal#drawer#hover_popup#init()
  call fern#internal#drawer#resize()

  setlocal winfixwidth
endfunction

function! s:focus_next(right) abort
  let l:Predicator = a:right
    \ ? function('fern#internal#drawer#is_right_drawer')
    \ : function('fern#internal#drawer#is_left_drawer')
  let winnr = fern#internal#window#find(
        \ { w -> l:Predicator(bufname(winbufnr(w))) },
        \)
  if winnr is# 0
    return
  endif
  call win_gotoid(win_getid(winnr))
  return 1
endfunction
./autoload/fern/internal/filepath.vim	[[[1
73
let s:Config = vital#fern#import('Config')

function! fern#internal#filepath#to_slash(path) abort
  return g:fern#internal#filepath#is_windows
        \ ? s:to_slash_windows(a:path)
        \ : s:to_slash_unix(a:path)
endfunction

function! fern#internal#filepath#from_slash(path) abort
  return g:fern#internal#filepath#is_windows
        \ ? s:from_slash_windows(a:path)
        \ : s:to_slash_unix(a:path)
endfunction

function! fern#internal#filepath#is_root(path) abort
  return g:fern#internal#filepath#is_windows
        \ ? a:path ==# ''
        \ : a:path ==# '/'
endfunction

function! fern#internal#filepath#is_drive_root(path) abort
  return g:fern#internal#filepath#is_windows
        \ ? a:path =~# '^\w:\\$'
        \ : a:path ==# '/'
endfunction

function! fern#internal#filepath#is_absolute(path) abort
  return g:fern#internal#filepath#is_windows
        \ ? s:is_absolute_windows(a:path)
        \ : s:is_absolute_unix(a:path)
endfunction

function! fern#internal#filepath#join(paths) abort
  let paths = map(
        \ copy(a:paths),
        \ 'fern#internal#filepath#to_slash(v:val)',
        \)
  return fern#internal#filepath#from_slash(join(paths, '/'))
endfunction

function! s:to_slash_windows(path) abort
  let prefix = s:is_absolute_windows(a:path) ? '/' : ''
  let terms = filter(split(a:path, '\\'), '!empty(v:val)')
  return prefix . join(terms, '/')
endfunction

function! s:to_slash_unix(path) abort
  if empty(a:path)
    return '/'
  endif
  let prefix = s:is_absolute_unix(a:path) ? '/' : ''
  let terms = filter(split(a:path, '/'), '!empty(v:val)')
  return prefix . join(terms, '/')
endfunction

function! s:from_slash_windows(path) abort
  let terms = filter(split(a:path, '/'), '!empty(v:val)')
  let path = join(terms, '\')
  return path[:2] =~# '^\w:$' ? path . '\' : path
endfunction

function! s:is_absolute_windows(path) abort
  return a:path ==# '' || a:path[:2] =~# '^\w:\\$'
endfunction

function! s:is_absolute_unix(path) abort
  return a:path ==# '' || a:path[:0] ==# '/'
endfunction


call s:Config.config(expand('<sfile>:p'), {
      \ 'is_windows': has('win32'),
      \})
./autoload/fern/internal/locator.vim	[[[1
25
let s:WindowLocator = vital#fern#import('App.WindowLocator')

function! fern#internal#locator#list(...) abort
  return call(s:WindowLocator.list, a:000, s:WindowLocator)
endfunction

function! fern#internal#locator#focus(...) abort
  return call(s:WindowLocator.focus, a:000, s:WindowLocator)
endfunction

function! fern#internal#locator#get_condition(...) abort
  return call(s:WindowLocator.get_condition, a:000, s:WindowLocator)
endfunction

function! fern#internal#locator#set_condition(...) abort
  return call(s:WindowLocator.set_condition, a:000, s:WindowLocator)
endfunction

function! fern#internal#locator#get_threshold(...) abort
  return call(s:WindowLocator.get_threshold, a:000, s:WindowLocator)
endfunction

function! fern#internal#locator#set_threshold(...) abort
  return call(s:WindowLocator.set_threshold, a:000, s:WindowLocator)
endfunction
./autoload/fern/internal/mark.vim	[[[1
29
function! fern#internal#mark#replace(bufnr, lnums) abort
  call execute(printf('sign unplace * group=fern-mark buffer=%d', a:bufnr))
  call map(a:lnums, { _, v -> execute(printf(
        \ 'sign place %d group=fern-mark line=%d name=FernSignMarked buffer=%d',
        \ v,
        \ v,
        \ a:bufnr,
        \))})
endfunction

function! s:define_signs() abort
  execute printf(
        \ 'sign define FernSignMarked text=%s linehl=FernMarkedLine texthl=FernMarkedText',
        \ g:fern#mark_symbol,
        \)
endfunction

function! s:define_highlight() abort
  highlight default link FernMarkedLine Title
  highlight default link FernMarkedText Title
endfunction

augroup fern_mark_internal
  autocmd!
  autocmd ColorScheme * call s:define_highlight()
augroup END

call s:define_signs()
call s:define_highlight()
./autoload/fern/internal/node.vim	[[[1
249
let s:Promise = vital#fern#import('Async.Promise')
let s:Lambda = vital#fern#import('Lambda')
let s:AsyncLambda = vital#fern#import('Async.Lambda')

let s:STATUS_NONE = g:fern#STATUS_NONE
let s:STATUS_COLLAPSED = g:fern#STATUS_COLLAPSED
let s:STATUS_EXPANDED = g:fern#STATUS_EXPANDED

function! fern#internal#node#debug(node) abort
  if a:node is# v:null
    return v:null
  endif
  let meta = extend(copy(a:node), {
        \ '__owner': a:node.__owner is# v:null ? '' : a:node.__owner.label,
        \ 'concealed': keys(a:node.concealed),
        \})
  let size = max(map(keys(meta), { -> len(v:val) }))
  let text = ''
  for name in sort(keys(meta))
    let prefix = name . ': ' . repeat(' ', size - len(name))
    let text .= printf("%s%s\n", prefix, meta[name])
  endfor
  return text
endfunction

function! fern#internal#node#process(node) abort
  let a:node.__processing += 1
  return { -> s:Lambda.let(a:node, '__processing', a:node.__processing - 1) }
endfunction

function! fern#internal#node#index(key, nodes) abort
  if type(a:key) isnot# v:t_list
    throw 'fern: "key" must be a list'
  endif
  for index in range(len(a:nodes))
    if a:nodes[index].__key == a:key
      return index
    endif
  endfor
  return -1
endfunction

function! fern#internal#node#find(key, nodes) abort
  let index = fern#internal#node#index(a:key, a:nodes)
  return index is# -1 ? v:null : a:nodes[index]
endfunction

function! fern#internal#node#root(url, provider) abort
  return s:new(a:provider.get_root(a:url))
endfunction

function! fern#internal#node#parent(node, provider, token, ...) abort
  let options = extend({
        \ 'cache': 1,
        \}, a:0 ? a:1 : {})
  if has_key(a:node.concealed, '__cache_parent') && options.cache
    return s:Promise.resolve(a:node.concealed.__cache_parent)
  elseif has_key(a:node.concealed, '__promise_parent')
    return a:node.concealed.__promise_parent
  endif
  let l:Profile = fern#profile#start('fern#internal#node#parent')
  let l:Done = fern#internal#node#process(a:node)
  let p = a:provider.get_parent(a:node, a:token)
        \.then({ n -> s:new(n, {
        \   '__key': [],
        \   '__owner': v:null,
        \ })
        \})
        \.then({ n -> s:Lambda.pass(n, s:Lambda.let(a:node.concealed, '__cache_parent', n)) })
        \.finally({ -> Done() })
        \.finally({ -> Profile() })
  let a:node.concealed.__promise_parent = p
        \.finally({ -> s:Lambda.unlet(a:node.concealed, '__promise_parent') })
  return p
endfunction

function! fern#internal#node#children(node, provider, token, ...) abort
  let options = extend({
        \ 'cache': 1,
        \}, a:0 ? a:1 : {})
  if a:node.status is# s:STATUS_NONE
    return s:Promise.reject('leaf node does not have children')
  elseif has_key(a:node.concealed, '__cache_children') && options.cache
    return s:AsyncLambda.map(
          \ a:node.concealed.__cache_children,
          \ { v -> extend(v, { 'status': v.status > 0 }) },
          \)
  elseif has_key(a:node.concealed, '__promise_children')
    return a:node.concealed.__promise_children
  endif
  let l:Profile = fern#profile#start('fern#internal#node#children')
  let l:Done = fern#internal#node#process(a:node)
  let p = a:provider.get_children(a:node, a:token)
        \.then(s:AsyncLambda.map_f({ n ->
        \   s:new(n, {
        \     '__key': a:node.__key + [n.name],
        \     '__owner': a:node,
        \   })
        \ }))
        \.then({ v -> s:Lambda.pass(v, s:Lambda.let(a:node.concealed, '__cache_children', v)) })
        \.finally({ -> Done() })
        \.finally({ -> Profile() })
  let a:node.concealed.__promise_children = p
        \.finally({ -> s:Lambda.unlet(a:node.concealed, '__promise_children') })
  return p
endfunction

function! fern#internal#node#expand(node, nodes, provider, comparator, token) abort
  if a:node.status is# s:STATUS_NONE
    return s:Promise.reject('cannot expand leaf node')
  elseif a:node.status is# s:STATUS_EXPANDED
    return s:Promise.resolve(a:nodes)
  elseif has_key(a:node.concealed, '__promise_expand')
    return a:node.concealed.__promise_expand
  elseif has_key(a:node, 'concealed.__promise_collapse')
    return a:node.concealed.__promise_collapse
  endif
  let l:Profile = fern#profile#start('fern#internal#node#expand')
  let l:Done = fern#internal#node#process(a:node)
  let p = fern#internal#node#children(a:node, a:provider, a:token)
        \.finally({ -> Profile('children') })
        \.then({ v -> s:sort(v, a:comparator.compare) })
        \.finally({ -> Profile('sort') })
        \.then({ v -> s:extend(a:node.__key, a:nodes, v) })
        \.finally({ -> Profile('extend') })
        \.finally({ -> Done() })
        \.finally({ -> Profile() })
  call p.then({ -> s:Lambda.let(a:node, 'status', s:STATUS_EXPANDED) })
  let a:node.concealed.__promise_expand = p
        \.finally({ -> s:Lambda.unlet(a:node.concealed, '__promise_expand') })
  return p
endfunction

function! fern#internal#node#collapse(node, nodes, provider, comparator, token) abort
  if a:node.status is# s:STATUS_NONE
    return s:Promise.reject('cannot collapse leaf node')
  elseif a:node.status is# s:STATUS_COLLAPSED
    return s:Promise.resolve(a:nodes)
  elseif has_key(a:node.concealed, '__promise_expand')
    return a:node.concealed.__promise_expand
  elseif has_key(a:node, 'concealed.__promise_collapse')
    return a:node.concealed.__promise_collapse
  endif
  let l:Profile = fern#profile#start('fern#internal#node#collapse')
  let k = a:node.__key
  let n = len(k) - 1
  let l:K = n < 0 ? { v -> [] } : { v -> v.__key[:n] }
  let l:Done = fern#internal#node#process(a:node)
  let p = s:Promise.resolve(a:nodes)
        \.then(s:AsyncLambda.filter_f({ v -> v.__key == k || K(v) != k  }))
        \.finally({ -> Done() })
        \.finally({ -> Profile() })
  call p.then({ -> s:Lambda.let(a:node, 'status', s:STATUS_COLLAPSED) })
  let a:node.concealed.__promise_collapse = p
        \.finally({ -> s:Lambda.unlet(a:node.concealed, '__promise_collapse') })
  return p
endfunction

function! fern#internal#node#reload(node, nodes, provider, comparator, token) abort
  if a:node.status is# s:STATUS_NONE || a:node.status is# s:STATUS_COLLAPSED
    return s:Promise.resolve(copy(a:nodes))
  elseif has_key(a:node.concealed, '__promise_expand')
    return a:node.concealed.__promise_expand
  elseif has_key(a:node.concealed, '__promise_collapse')
    return a:node.concealed.__promise_collapse
  endif
  let l:Profile = fern#profile#start('fern#internal#node#reload')
  let k = a:node.__key
  let n = len(k) - 1
  let l:K = n < 0 ? { v -> [] } : { v -> v.__key[:n] }
  let outer = s:Promise.resolve(copy(a:nodes))
        \.then(s:AsyncLambda.filter_f({ v -> K(v) != k  }))
  let inner = s:Promise.resolve(copy(a:nodes))
        \.then(s:AsyncLambda.filter_f({ v -> K(v) == k  }))
        \.then(s:AsyncLambda.filter_f({ v -> v.status is# s:STATUS_EXPANDED }))
        \.then(s:AsyncLambda.map_f({ v ->
        \   fern#internal#node#children(v, a:provider, a:token, {
        \    'cache': 0,
        \   }).then({ children ->
        \     s:Lambda.if(v.status is# s:STATUS_EXPANDED, { -> [v] + children }, { -> [v]})
        \   }).catch({ error ->
        \     s:Lambda.pass([], fern#logger#warn(error))
        \   })
        \ }))
        \.then({ v -> s:Promise.all(v) })
        \.then(s:AsyncLambda.reduce_f({ a, v -> a + v }, []))
        \.then({ v -> s:sort(v, { a, b -> fern#util#compare(b.status, a.status) }) })
  let l:Done = fern#internal#node#process(a:node)
  return s:Promise.all([outer, inner])
        \.finally({ -> Profile('all') })
        \.then(s:AsyncLambda.reduce_f({ a, v -> a + v }, []))
        \.finally({ -> Profile('reduce') })
        \.then({ v -> s:sort(v, a:comparator.compare) })
        \.finally({ -> Profile('sort') })
        \.then({ v -> s:uniq(v) })
        \.finally({ -> Profile('uniq') })
        \.finally({ -> Done() })
        \.finally({ -> Profile() })
endfunction

function! fern#internal#node#reveal(key, nodes, provider, comparator, token) abort
  if a:key == a:nodes[0].__key
    return s:Promise.resolve(a:nodes)
  endif
  let l:Profile = fern#profile#start('fern#internal#node#reveal')
  return s:expand_recursively(0, a:key, a:nodes, a:provider, a:comparator, a:token)
        \.finally({ -> Profile() })
endfunction

function! s:new(node, ...) abort
  let node = extend(a:node, {
        \ 'label': get(a:node, 'label', a:node.name),
        \ 'badge': get(a:node, 'badge', ''),
        \ 'hidden': get(a:node, 'hidden', 0),
        \ 'bufname': get(a:node, 'bufname', v:null),
        \ 'concealed': get(a:node, 'concealed', {}),
        \ '__processing': 0,
        \ '__key': [],
        \ '__owner': v:null,
        \})
  let node = extend(node, a:0 ? a:1 : {})
  return node
endfunction

function! s:uniq(nodes) abort
  return s:Promise.resolve(uniq(a:nodes, { a, b -> a.__key != b.__key }))
endfunction

function! s:sort(nodes, compare) abort
  return s:Promise.resolve(sort(a:nodes, a:compare))
endfunction

function! s:extend(key, nodes, new_nodes) abort
  let index = fern#internal#node#index(a:key, a:nodes)
  return index is# -1 ? a:nodes : extend(a:nodes, a:new_nodes, index + 1)
endfunction

function! s:expand_recursively(index, key, nodes, provider, comparator, token) abort
  let node = fern#internal#node#find(a:key[:a:index], a:nodes)
  if node is# v:null || node.status is# s:STATUS_NONE
    return s:Promise.resolve(a:nodes)
  endif
  return fern#internal#node#expand(node, a:nodes, a:provider, a:comparator, a:token)
        \.then({ ns -> s:Lambda.if(
        \   a:index < len(a:key) - 1,
        \   { -> s:expand_recursively(a:index + 1, a:key, ns, a:provider, a:comparator, a:token) },
        \   { -> ns },
        \ )})
endfunction
./autoload/fern/internal/path.vim	[[[1
109
function! fern#internal#path#simplify(path) abort
  let terms = s:split(a:path)
  let path = join(s:simplify(terms), '/')
  let prefix = a:path[:0] ==# '/' && path[:2] !=# '../' ? '/' : ''
  return prefix . path
endfunction

function! fern#internal#path#commonpath(paths) abort
  if !empty(filter(copy(a:paths), 'v:val[:0] !=# ''/'''))
    throw printf('fern: path in {paths} must be an absolute path: %s', a:paths)
  endif
  let path = s:commonpath(map(
        \ copy(a:paths),
        \ 's:split(v:val)'
        \))
  return '/' . join(path, '/')
endfunction

function! fern#internal#path#absolute(path, base) abort
  if a:base[:0] !=# '/'
    throw printf('fern: {base} ("%s") must be an absolute path', a:base)
  elseif a:path[:0] ==# '/'
    return a:path
  endif
  let path = s:split(a:path)
  let base = s:split(a:base)
  let abspath = join(s:simplify(base + path), '/')
  if abspath[:2] ==# '../'
    throw printf('fern: {path} (%s) beyonds {base} (%s)', a:path, a:base)
  endif
  return '/' . abspath
endfunction

function! fern#internal#path#relative(path, base) abort
  if a:base[:0] !=# '/'
    throw printf('fern: {base} ("%s") must be an absolute path', a:base)
  elseif a:path[:0] !=# '/'
    return a:path
  endif
  let path = s:split(a:path)
  let base = s:split(a:base)
  return join(s:relative(path, base), '/')
endfunction

function! fern#internal#path#basename(path) abort
  if empty(a:path) || a:path ==# '/'
    return a:path
  endif
  let terms = s:split(a:path)
  return terms[-1]
endfunction

function! fern#internal#path#dirname(path) abort
  if empty(a:path) || a:path ==# '/'
    return a:path
  endif
  let terms = s:split(a:path)[:-2]
  let path = join(s:simplify(terms), '/')
  let prefix = a:path[:0] ==# '/' && path[:2] !=# '../' ? '/' : ''
  return prefix . path
endfunction

function! s:split(path) abort
  return filter(split(a:path, '/'), '!empty(v:val)')
endfunction

function! s:simplify(path) abort
  let result = []
  for term in a:path
    if term ==# '..'
      if empty(result) || result[-1] == '..'
        call insert(result, '..', 0)
      else
        call remove(result, -1)
      endif
    elseif term ==# '.' || empty(term)
      continue
    else
      call add(result, term)
    endif
  endfor
  return result
endfunction

function! s:commonpath(paths) abort
  let paths = map(copy(a:paths), { -> s:simplify(v:val) })
  let common = []
  for index in range(min(map(copy(paths), { -> len(v:val) })))
    let term = paths[0][index]
    if empty(filter(paths[1:], { -> v:val[index] !=? term }))
      call add(common, term)
    endif
  endfor
  return common
endfunction

function! s:relative(path, base) abort
  let path = s:simplify(a:path)
  let base = s:simplify(a:base)
  for index in range(min([len(path), len(base)]))
    if path[0] !=? base[0]
      break
    endif
    call remove(path, 0)
    call remove(base, 0)
  endfor
  let prefix = repeat(['..'], len(base))
  return prefix + path
endfunction
./autoload/fern/internal/prompt.vim	[[[1
78
let s:ESCAPE_MARKER = sha256(expand('<sfile>'))

function! fern#internal#prompt#input(prompt, ...) abort
  let text = a:0 > 0 ? a:1 : ''
  let comp = a:0 > 1
        \ ? type(a:2) is# v:t_func ? 'customlist,' . get(a:2, 'name') : a:2
        \ : v:null
  let default = a:0 > 2 ? a:3 : v:null
  let args = comp is# v:null ? [text] : [text, comp]
  try
    execute printf(
          \ 'silent cnoremap <buffer><silent> <Esc> <C-u>%s<CR>',
          \ s:ESCAPE_MARKER,
          \)
    let result = call('input', [a:prompt] + args)
    return result ==# s:ESCAPE_MARKER ? default : result
  finally
    silent cunmap <buffer> <Esc>
  endtry
endfunction

function! fern#internal#prompt#ask(...) abort
  try
    echohl Question
    return call('fern#internal#prompt#input', a:000)
  finally
    echohl None
    redraw | echo
  endtry
endfunction

function! fern#internal#prompt#confirm(prompt, ...) abort
  let default = a:0 ? (a:1 ? 'yes' : 'no') : v:null
  echohl Question
  try
    let r = ''
    while r !~? '^\%(y\%[es]\|n\%[o]\)$'
      let r = fern#internal#prompt#input(a:prompt, '', funcref('s:_confirm_complete'))
      if r is# v:null
        return v:null
      endif
      let r = r ==# '' ? default : r
    endwhile
    return r =~? 'y\%[es]'
  finally
    echohl None
    redraw | echo
  endtry
endfunction

function! fern#internal#prompt#select(prompt, ...) abort
  let max = a:0 > 0 ? a:1 : 1
  let min = a:0 > 1 ? a:2 : 1
  let pat = a:0 > 2 ? a:3 : '\d'
  let buffer = ''
  echohl Question
  try
    while len(buffer) < max
      redraw | echo
      echo a:prompt . buffer
      let c = nr2char(getchar())
      if c ==# "\<Return>" && len(buffer) >= min
        return buffer
      elseif c ==# "\<Esc>"
        return v:null
      elseif c =~# pat
        let buffer .= c
      endif
    endwhile
    return buffer
  finally
    echohl None
  endtry
endfunction

function! s:_confirm_complete(arglead, cmdline, cursorpos) abort
  return filter(['yes', 'no'], { -> v:val =~? '^' . a:arglead })
endfunction
./autoload/fern/internal/rename_solver.vim	[[[1
107
let s:ESCAPE_PATTERN = '^$~.*[]\'

function! fern#internal#rename_solver#solve(pairs, ...) abort
  let options = extend({
        \ 'exist': { p -> getftype(p) !=# '' },
        \ 'tempname': { _ -> tempname() },
        \ 'isdirectory': { p -> isdirectory(p) },
        \}, a:0 ? a:1 : {},
        \)
  let l:Exist = options.exist
  let l:Tempname = options.tempname
  let l:IsDirectory = options.isdirectory
  " Sort by 'dst' depth
  let pairs = sort(copy(a:pairs), funcref('s:compare'))
  " Build steps from given pairs
  let steps = []
  let tears = []
  let src_map = s:dict(map(
        \ copy(a:pairs),
        \ { -> [v:val[0], 1] },
        \))
  for [src, dst] in pairs
    let rsrc_map = s:dict(map(
          \ copy(a:pairs),
          \ { -> [s:replace(v:val[0], steps), 1] },
          \))
    let rsrc = s:replace(src, steps)
    if rsrc ==# dst
      continue
    endif
    let rdst = s:replace_backword(dst, steps)
    if get(rsrc_map, dst)
      let tmp = Tempname(dst)
      call add(steps, [rsrc, tmp, '', ''])
      call add(tears, [tmp, dst, src, rdst])
    elseif !get(src_map, rdst) && Exist(rdst)
      throw printf('Destination "%s" already exist as "%s"', dst, rdst)
    else
      call add(steps, [rsrc, dst, src, rdst])
    endif
  endfor
  let steps += tears
  " Check 'dst' uniqueness
  let dup = s:find_duplication(map(copy(steps), { -> v:val[1] }))
  if !empty(dup)
    throw printf('Destination "%s" appears more than once', dup)
  endif
  " Check parent directories of 'dst'
  for [rsrc, dst, src, rdst] in steps
    let prv = rdst
    let cur = fern#internal#path#dirname(prv)
    while cur !=# '' && cur !=# prv
      if !Exist(cur)
        break
      elseif !IsDirectory(cur)
        throw printf(
              \ 'Destination "%s" in "%s" is not directory',
              \ s:replace(cur, steps),
              \ dst,
              \)
      endif
      let prv = cur
      let cur = fern#internal#path#dirname(cur)
    endwhile
  endfor
  return map(steps, { -> v:val[0:1] })
endfunction

function! s:dict(entries) abort
  let m = {}
  call map(copy(a:entries), { _, v -> extend(m, { v[0]: v[1] }) })
  return m
endfunction

function! s:compare(a, b) abort
  let a = len(split(a:a[1], '[/\\]'))
  let b = len(split(a:b[1], '[/\\]'))
  return a is# b ? 0 : a > b ? 1 : -1
endfunction

function! s:find_duplication(list) abort
  let seen = {}
  for item in a:list
    if has_key(seen, item)
      return item
    endif
    let seen[item] = 1
  endfor
endfunction

function! s:replace(text, applied) abort
  let text = a:text
  for item in a:applied
    let [src, dst] = item[0:1]
    let text = substitute(text, escape(src, s:ESCAPE_PATTERN), dst, '')
  endfor
  return text
endfunction

function! s:replace_backword(text, applied) abort
  let text = a:text
  for item in reverse(copy(a:applied))
    let [src, dst] = item[0:1]
    let text = substitute(text, escape(dst, s:ESCAPE_PATTERN), src, '')
  endfor
  return text
endfunction
./autoload/fern/internal/replacer.vim	[[[1
129
let s:Promise = vital#fern#import('Async.Promise')
let s:ESCAPE_PATTERN = '^$~.*[]\'

function! fern#internal#replacer#start(factory, ...) abort
  let options = extend({
        \ 'bufname': printf('fern-replacer:%s', sha256(localtime()))[:7],
        \ 'opener': 'vsplit',
        \ 'cursor': [1, 1],
        \ 'is_drawer': v:false,
        \ 'modifiers': [],
        \}, a:0 ? a:1 : {},
        \)
  return s:Promise.new(funcref('s:executor', [a:factory, options]))
endfunction

function! s:executor(factory, options, resolve, reject) abort
  call fern#internal#buffer#open(a:options.bufname, {
        \ 'opener': a:options.opener,
        \ 'locator': a:options.is_drawer,
        \ 'keepalt': !a:options.is_drawer && g:fern#keepalt_on_edit,
        \ 'keepjumps': !a:options.is_drawer && g:fern#keepjumps_on_edit,
        \})

  setlocal buftype=acwrite bufhidden=wipe
  setlocal noswapfile nobuflisted
  setlocal nowrap
  setlocal filetype=fern-replacer

  let b:fern_replacer_resolve = a:resolve
  let b:fern_replacer_factory = a:factory
  let b:fern_replacer_candidates = a:factory()
  let b:fern_replacer_modifiers = a:options.modifiers

  augroup fern_replacer_internal
    autocmd! * <buffer>
    autocmd BufReadCmd  <buffer> call s:BufReadCmd()
    autocmd BufWriteCmd <buffer> call s:BufWriteCmd()
    autocmd ColorScheme <buffer> call s:highlight()
  augroup END

  call s:highlight()
  call s:syntax()

  " Do NOT allow to add/remove lines
  nnoremap <buffer><silent> <Plug>(fern-replacer-p) :<C-u>call <SID>map_paste(0)<CR>
  nnoremap <buffer><silent> <Plug>(fern-replacer-P) :<C-u>call <SID>map_paste(-1)<CR>
  nnoremap <buffer><silent> <Plug>(fern-replacer-warn) :<C-u>call <SID>map_warn()<CR>
  inoremap <buffer><silent><expr> <Plug>(fern-replacer-warn) <SID>map_warn()
  nnoremap <buffer><silent> dd 0D
  nmap <buffer> p <Plug>(fern-replacer-p)
  nmap <buffer> P <Plug>(fern-replacer-P)
  nmap <buffer> o <Plug>(fern-replacer-warn)
  nmap <buffer> O <Plug>(fern-replacer-warn)
  imap <buffer> <C-m> <Plug>(fern-replacer-warn)
  imap <buffer> <Return> <Plug>(fern-replacer-warn)
  edit
  call cursor(a:options.cursor)
endfunction

function! s:map_warn() abort
  echohl WarningMsg
  echo 'Newline is prohibited in the replacer buffer'
  echohl None
  return ''
endfunction

function! s:map_paste(offset) abort
  let line = getline('.')
  let v = substitute(getreg(), '\r\?\n', '', 'g')
  let c = col('.') + a:offset - 1
  let l = line[:c]
  let r = line[c + 1:]
  call setline(line('.'), l . v . r)
endfunction

function! s:BufReadCmd() abort
  let b:fern_replacer_candidates = b:fern_replacer_factory()
  call s:syntax()
  call setline(1, b:fern_replacer_candidates)
endfunction

function! s:BufWriteCmd() abort
  if !&modifiable
    return
  endif
  let candidates = b:fern_replacer_candidates
  let result = []
  for index in range(len(candidates))
    let src = candidates[index]
    let dst = getline(index + 1)
    if empty(dst) || dst ==# src
      continue
    endif
    call add(result, [src, dst])
  endfor
  try
    for Modifier in b:fern_replacer_modifiers
      let result = Modifier(result)
    endfor
    let l:Resolve = b:fern_replacer_resolve
    set nomodified
    close
    call Resolve(result)
  catch
    echohl ErrorMsg
    echo '[fern] Please fix the following error first to continue or cancel with ":q!"'
    echo printf('[fern] %s', substitute(v:exception, '^Vim(.*):', '', ''))
    echohl None
  endtry
endfunction

function! s:syntax() abort
  syntax clear
  syntax match FernReplacerModified '^.\+$'

  for index in range(len(b:fern_replacer_candidates))
    let candidate = b:fern_replacer_candidates[index]
    execute printf(
          \ 'syntax match FernReplacerOriginal ''^\%%%dl%s$''',
          \ index + 1,
          \ escape(candidate, s:ESCAPE_PATTERN),
          \)
  endfor
endfunction

function! s:highlight() abort
  highlight default link FernReplacerOriginal Normal
  highlight default link FernReplacerModified Special
endfunction
./autoload/fern/internal/scheme.vim	[[[1
29
function! s:call(scheme, name, ...) abort
  try
    return call(printf('fern#scheme#%s#%s', a:scheme, a:name), a:000)
  catch /^Vim\%((\a\+)\)\=:E117: [^:]\+: fern#scheme#[^#]\+#.*/
    return v:null
  endtry
endfunction

function! fern#internal#scheme#provider_new(scheme) abort
  return call('s:call', [a:scheme, 'provider#new'])
endfunction

function! fern#internal#scheme#mapping_init(scheme, disable_default_mappings) abort
  call s:call(a:scheme, 'mapping#init', a:disable_default_mappings)
  try
    for name in g:fern#scheme#{a:scheme}#mapping#mappings
      call s:call(a:scheme, printf('mapping#%s#init', name), a:disable_default_mappings)
    endfor
  catch /^Vim\%((\a\+)\)\=:E121:/
  endtry
endfunction

function! fern#internal#scheme#complete_url(scheme, arglead, cmdline, cursorpos) abort
  return s:call(a:scheme, 'complete#url', a:arglead, a:cmdline, a:cursorpos)
endfunction

function! fern#internal#scheme#complete_reveal(scheme, arglead, cmdline, cursorpos) abort
  return s:call(a:scheme, 'complete#reveal', a:arglead, a:cmdline, a:cursorpos)
endfunction
./autoload/fern/internal/spinner.vim	[[[1
62
let s:Config = vital#fern#import('Config')
let s:Spinner = vital#fern#import('App.Spinner')

function! fern#internal#spinner#start(...) abort
  let bufnr = a:0 ? a:1 : bufnr('%')
  if getbufvar(bufnr, 'fern_spinner_timer' , v:null) isnot# v:null
    return
  endif
  let spinner = s:Spinner.new(map(
        \ copy(g:fern#internal#spinner#frames),
        \ { k -> printf('FernSignSpinner%d', k) },
        \))
  call setbufvar(bufnr, 'fern_spinner_timer', timer_start(
        \ 50,
        \ { t -> s:update(t, spinner, bufnr) },
        \ { 'repeat': -1 },
        \))
endfunction

function! s:update(timer, spinner, bufnr) abort
  let fern = getbufvar(a:bufnr, 'fern', v:null)
  let winid = bufnr('%') == a:bufnr ? win_getid() : bufwinid(a:bufnr)
  if fern is# v:null || winid is# -1
    call timer_stop(a:timer)
    return
  endif
  let frame = a:spinner.next()
  call execute(printf('sign unplace * group=fern-spinner buffer=%d', a:bufnr))
  let info = getwininfo(winid)[0]
  let rng = sort([info.topline, info.botline], 'n')
  for lnum in range(rng[0], rng[1])
    let node = get(fern.visible_nodes, lnum - 1, v:null)
    if node is# v:null
      return
    elseif node.__processing is# 0
      continue
    endif
    call execute(printf(
          \ 'sign place %d group=fern-spinner line=%d name=%s buffer=%d',
          \ lnum,
          \ lnum,
          \ frame,
          \ a:bufnr,
          \))
  endfor
endfunction

function! s:define_signs() abort
  let frames = g:fern#internal#spinner#frames
  for index in range(len(frames))
    call execute(printf(
          \ 'sign define FernSignSpinner%d text=%s texthl=FernSpinner',
          \ index,
          \ frames[index],
          \))
  endfor
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'frames': has('win32') ? s:Spinner.flip : s:Spinner.dots,
      \})
call s:define_signs()
./autoload/fern/internal/viewer/auto_duplication.vim	[[[1
42
function! fern#internal#viewer#auto_duplication#init() abort
  if g:fern#disable_viewer_auto_duplication ||
    \ (g:fern#disable_drawer_tabpage_isolation && fern#internal#drawer#is_drawer())
    return
  endif

  augroup fern_internal_viewer_auto_duplication_init
    autocmd! * <buffer>
    autocmd WinEnter <buffer> nested call s:duplicate()
  augroup END
endfunction

function! s:duplicate() abort
  if s:count_non_popup_windows('%') < 2
    return
  endif
  " Only one window is allowed to display one fern buffer.
  " So create a new fern buffer with same options
  let fri = fern#fri#parse(bufname('%'))
  let fri.authority = ''
  let bufname = fern#fri#format(fri)
  execute printf('silent! keepalt edit %s', fnameescape(bufname))
endfunction

function! s:count_non_popup_windows(expr) abort
  let winids = win_findbuf(bufnr(a:expr))
  return len(filter(winids, {_, v -> !s:is_popup_window(v)}))
endfunction

if exists('*win_gettype')
  function! s:is_popup_window(winid) abort
    return win_gettype(a:winid) ==# 'popup'
  endfunction
elseif exists('*nvim_win_get_config')
  function! s:is_popup_window(winid) abort
    return nvim_win_get_config(a:winid).relative !=# ''
  endfunction
else
  function! s:is_popup_window(winid) abort
    return getbufvar(winbufnr(a:winid), '&buftype') ==# 'popup'
  endfunction
endif
./autoload/fern/internal/viewer/hide_cursor.vim	[[[1
24
function! fern#internal#viewer#hide_cursor#init() abort
  if !g:fern#hide_cursor
    return
  endif
  call s:hide_cursor_init()
endfunction

function! s:hide_cursor_init() abort
  augroup fern_internal_viewer_smart_cursor_init
    autocmd! * <buffer>
    autocmd BufEnter,WinEnter,TabLeave,CmdwinLeave,CmdlineLeave <buffer> setlocal cursorline
    autocmd BufLeave,WinLeave,TabLeave,CmdwinEnter,CmdlineEnter <buffer> setlocal nocursorline
    autocmd BufEnter,WinEnter,TabLeave,CmdwinLeave,CmdlineLeave <buffer> call fern#internal#cursor#hide()
    autocmd BufLeave,WinLeave,TabLeave,CmdwinEnter,CmdlineEnter <buffer> call fern#internal#cursor#restore()
    autocmd VimLeave <buffer> call fern#internal#cursor#restore()
  augroup END

  " Do NOT allow cursorlineopt=number while the cursor is hidden (Fix #182)
  if exists('+cursorlineopt')
    " NOTE:
    " Default value is `number,line` (or `both` prior to patch-8.1.2029)
    setlocal cursorlineopt&
  endif
endfunction
./autoload/fern/internal/viewer.vim	[[[1
150
let s:Lambda = vital#fern#import('Lambda')
let s:Promise = vital#fern#import('Async.Promise')

function! fern#internal#viewer#open(fri, options) abort
  call fern#logger#debug('open:', a:fri)
  let bufname = fern#fri#format(a:fri)
  return s:Promise.new(funcref('s:open', [bufname, a:options]))
endfunction

function! fern#internal#viewer#init() abort
  try
    let bufnr = bufnr('%')
    return s:init()
          \.then({ -> s:notify(bufnr, v:null) })
          \.catch({ e -> s:Lambda.pass(s:Promise.reject(e), s:notify(bufnr, e)) })
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction

function! fern#internal#viewer#reveal(helper, path) abort
  let path = fern#internal#filepath#to_slash(a:path)
  let path = substitute(path, '^\./', '', '')
  let reveal = split(path, '/')
  let previous = a:helper.sync.get_cursor_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.reveal_node(reveal) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(reveal) })
endfunction

function! s:open(bufname, options, resolve, reject) abort
  if fern#internal#buffer#open(a:bufname, a:options)
    call a:reject('Cancelled')
    return
  endif
  let b:fern_notifier = {
        \ 'resolve': a:resolve,
        \ 'reject': a:reject,
        \}
endfunction

function! s:init() abort
  command! -buffer -bar -nargs=*
        \ -complete=customlist,fern#internal#command#reveal#complete
        \ FernReveal
        \ call fern#internal#command#reveal#command(<q-mods>, [<f-args>])

  setlocal buftype=nofile bufhidden=unload
  setlocal noswapfile nobuflisted nomodifiable
  setlocal signcolumn=yes
  " The 'foldmethod=manual' is required to avoid the following issue
  " https://github.com/lambdalisue/fern.vim/issues/331
  setlocal foldmethod=manual

  augroup fern_internal_viewer_init
    autocmd! * <buffer>
    autocmd BufEnter <buffer> setlocal nobuflisted
    autocmd BufReadCmd <buffer> nested call s:BufReadCmd()
    autocmd CursorMoved,CursorMovedI,BufLeave <buffer> let b:fern_cursor = getcurpos()[1:2]
  augroup END
  call fern#internal#viewer#auto_duplication#init()
  call fern#internal#viewer#hide_cursor#init()

  " Add unique fragment to make each buffer uniq
  let bufname = bufname('%')
  let fri = fern#fri#parse(bufname)
  if empty(fri.authority)
    let fri.authority = sha256(localtime())[:7]
    let previous = bufname
    let bufname = fern#fri#format(fri)
    execute printf('silent! keepalt file %s', fnameescape(bufname))
    execute printf('silent! bwipeout %s', previous)
  endif

  let resource_uri = fri.path
  let scheme = fern#fri#parse(resource_uri).scheme
  let provider = fern#internal#scheme#provider_new(scheme)
  if provider is# v:null
    throw printf('no such scheme %s exists', scheme)
  endif

  let b:fern = fern#internal#core#new(
        \ resource_uri,
        \ provider,
        \)
  let helper = fern#helper#new()
  let root = helper.sync.get_root_node()

  call fern#mapping#init(scheme)
  call fern#internal#drawer#init()
  if !g:fern#disable_viewer_spinner
    call fern#internal#spinner#start()
  endif

  " now the buffer is ready so set filetype to emit FileType
  setlocal filetype=fern
  call fern#action#_init()

  let l:Profile = fern#profile#start('fern#internal#viewer:init')
  return s:Promise.resolve()
        \.then({ -> helper.async.expand_node(root.__key) })
        \.finally({ -> Profile('expand') })
        \.then({ -> helper.async.redraw() })
        \.finally({ -> Profile('redraw') })
        \.finally({ -> Profile() })
        \.then({ -> fern#hook#emit('viewer:ready', helper) })
endfunction

function! s:notify(bufnr, error) abort
  let notifier = getbufvar(a:bufnr, 'fern_notifier', v:null)
  if notifier isnot# v:null
    call setbufvar(a:bufnr, 'fern_notifier', v:null)
    if a:error is# v:null
      call notifier.resolve(a:bufnr)
    else
      call notifier.reject([a:bufnr, a:error])
    endif
  endif
endfunction

function! s:BufReadCmd() abort
  let helper = fern#helper#new()
  setlocal filetype=fern
  setlocal modifiable
  call setline(1, get(b:, 'fern_viewer_cache_content', []))
  setlocal nomodifiable
  call helper.sync.set_cursor(get(b:, 'fern_cursor', getcurpos()[1:2]))
  let root = helper.sync.get_root_node()
  call s:Promise.resolve()
        \.then({ -> helper.async.reload_node(root.__key) })
        \.then({ -> helper.async.redraw() })
        \.then({ -> fern#hook#emit('viewer:ready', helper) })
        \.catch({ e -> fern#logger#error(e) })
endfunction

augroup fern_internal_viewer
  autocmd!
  autocmd User FernSyntax :
  autocmd User FernHighlight :
augroup END

" Cache content to accelerate rendering
call fern#hook#add('viewer:redraw', { h ->
      \ setbufvar(h.bufnr, 'fern_viewer_cache_content', getbufline(h.bufnr, 1, '$'))
      \})

" Deprecated:
call fern#hook#add('viewer:highlight', { h -> fern#hook#emit('renderer:highlight', h) })
call fern#hook#add('viewer:syntax', { h -> fern#hook#emit('renderer:syntax', h) })
./autoload/fern/internal/window.vim	[[[1
52
let s:Config = vital#fern#import('Config')
let s:WindowSelector = vital#fern#import('App.WindowSelector')

function! fern#internal#window#find(predicator, ...) abort
  let n = winnr('$')
  if n is# 1
    return a:predicator(winnr())
  endif
  let origin = (a:0 ? a:1 : winnr()) - 1
  let s = origin % n
  let e = (s - 1) % n
  let former = range(s < 0 ? s + n : s, n - 1)
  let latter = range(0, e < 0 ? e + n : e)
  for index in (former + latter)
    let winnr = index + 1
    if a:predicator(winnr)
      return winnr
    endif
  endfor
  return 0
endfunction

function! fern#internal#window#select() abort
  let ws = fern#internal#locator#list()
  let ws = empty(ws) ? range(1, winnr('$')) : ws
  return s:WindowSelector.select(ws, {
        \ 'auto_select': g:fern#internal#window#auto_select,
        \ 'select_chars': g:fern#internal#window#select_chars,
        \ 'statusline_hl': 'FernWindowSelectStatusLine',
        \ 'indicator_hl': 'FernWindowSelectIndicator',
        \ 'use_winbar': g:fern#internal#window#use_winbar,
        \ 'use_popup': g:fern#window_selector_use_popup,
        \})
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'auto_select': 1,
      \ 'select_chars': split('abcdefghijklmnopqrstuvwxyz', '\zs'),
      \ 'use_winbar': exists('&winbar') && &laststatus is# 3,
      \})

function! s:highlight() abort
  highlight default link FernWindowSelectStatusLine VitalWindowSelectorStatusLine
  highlight default link FernWindowSelectIndicator VitalWindowSelectorIndicator
endfunction

augroup fern_internal_window
  autocmd!
  autocmd ColorScheme * call s:highlight()
augroup END

call s:highlight()
./autoload/fern/logger.vim	[[[1
90
let s:Later = vital#fern#import('Async.Later')
let s:LEVEL_HIGHLIGHT = {
      \ 'DEBUG': 'Comment',
      \ 'INFO': 'Special',
      \ 'WARN': 'WarningMsg',
      \ 'ERROR': 'ErrorMsg',
      \}

function! fern#logger#tap(value, ...) abort
  call call('fern#logger#debug', [a:value] + a:000)
  return a:value
endfunction

function! fern#logger#debug(...) abort
  if g:fern#loglevel > g:fern#DEBUG
    return
  endif
  call call('s:log', ['DEBUG'] + a:000)
endfunction

function! fern#logger#info(...) abort
  if g:fern#loglevel > g:fern#INFO
    return
  endif
  call call('s:log', ['INFO'] + a:000)
endfunction

function! fern#logger#warn(...) abort
  if g:fern#loglevel > g:fern#WARN
    return
  endif
  call call('s:log', ['WARN'] + a:000)
endfunction

function! fern#logger#error(...) abort
  if g:fern#loglevel > g:fern#ERROR
    return
  endif
  call call('s:log', ['ERROR'] + a:000)
endfunction

function! s:log(level, ...) abort
  if g:fern#logfile is# v:null
    let hl = get(s:LEVEL_HIGHLIGHT, a:level, 'None')
    let content = s:format(a:level, a:000, ' ')
    call s:Later.call({ -> s:echomsg(hl, content) })
  else
    let content = s:format(a:level, a:000, "\t")
    call s:Later.call({ -> s:writefile(content) })
  endif
endfunction

function! s:echomsg(hl, content) abort
  let more = &more
  try
    set nomore
    execute printf('echohl %s', a:hl)
    for line in a:content
      echomsg '[fern] ' . line | redraw | echo
    endfor
  finally
    echohl None
    let &more = more
  endtry
endfunction

function! s:writefile(content) abort
  try
    let time = strftime('%H:%M:%S')
    let path = fnamemodify(fern#util#expand(g:fern#logfile), ':p')
    call mkdir(fnamemodify(path, ':h'), 'p')
    call writefile(map(copy(a:content), { -> join([time, v:val], "\t") }), path, 'a')
  catch
    echohl ErrorMsg
    echo v:exception
    echo v:throwpoint
    echohl None
  endtry
endfunction

function! s:format(level, args, sep) abort
  let m = join(map(copy(a:args), { _, v -> type(v) is# v:t_string ? v : string(v) }))
  return map(split(m, '\n'), { -> printf("%-5S:%s%s", a:level, a:sep, v:val) })
endfunction

" For backword compatibility
const g:fern#logger#DEBUG = g:fern#DEBUG
const g:fern#logger#INFO = g:fern#INFO
const g:fern#logger#WARN = g:fern#WARN
const g:fern#logger#ERROR = g:fern#ERROR
./autoload/fern/mapping/diff.vim	[[[1
144
let s:Promise = vital#fern#import('Async.Promise')
let s:timer_diffupdate = 0

function! fern#mapping#diff#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-diff:select)   :<C-u>call <SID>call('diff', 'select', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:split)    :<C-u>call <SID>call('diff', 'split', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:vsplit)   :<C-u>call <SID>call('diff', 'vsplit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:tabedit)  :<C-u>call <SID>call('diff', 'tabedit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:above)    :<C-u>call <SID>call('diff', 'leftabove split', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:left)     :<C-u>call <SID>call('diff', 'leftabove vsplit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:below)    :<C-u>call <SID>call('diff', 'rightbelow split', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:right)    :<C-u>call <SID>call('diff', 'rightbelow vsplit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:top)      :<C-u>call <SID>call('diff', 'topleft split', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:leftest)  :<C-u>call <SID>call('diff', 'topleft vsplit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:bottom)   :<C-u>call <SID>call('diff', 'botright split', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:rightest) :<C-u>call <SID>call('diff', 'botright vsplit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-error)   :<C-u>call <SID>call('diff', 'edit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-split)   :<C-u>call <SID>call('diff', 'edit/split', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-vsplit)  :<C-u>call <SID>call('diff', 'edit/vsplit', v:false)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-tabedit) :<C-u>call <SID>call('diff', 'edit/tabedit', v:false)<CR>

  nnoremap <buffer><silent> <Plug>(fern-action-diff:select:vert)   :<C-u>call <SID>call('diff', 'select', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:split:vert)    :<C-u>call <SID>call('diff', 'split', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:vsplit:vert)   :<C-u>call <SID>call('diff', 'vsplit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:tabedit:vert)  :<C-u>call <SID>call('diff', 'tabedit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:above:vert)    :<C-u>call <SID>call('diff', 'leftabove split', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:left:vert)     :<C-u>call <SID>call('diff', 'leftabove vsplit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:below:vert)    :<C-u>call <SID>call('diff', 'rightbelow split', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:right:vert)    :<C-u>call <SID>call('diff', 'rightbelow vsplit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:top:vert)      :<C-u>call <SID>call('diff', 'topleft split', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:leftest:vert)  :<C-u>call <SID>call('diff', 'topleft vsplit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:bottom:vert)   :<C-u>call <SID>call('diff', 'botright split', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:rightest:vert) :<C-u>call <SID>call('diff', 'botright vsplit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-error:vert)   :<C-u>call <SID>call('diff', 'edit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-split:vert)   :<C-u>call <SID>call('diff', 'edit/split', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-vsplit:vert)  :<C-u>call <SID>call('diff', 'edit/vsplit', v:true)<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-diff:edit-or-tabedit:vert) :<C-u>call <SID>call('diff', 'edit/tabedit', v:true)<CR>

  " Smart map
  nmap <buffer><silent><expr>
        \ <Plug>(fern-action-diff:side)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-action-diff:left)",
        \   "\<Plug>(fern-action-diff:right)",
        \ )
  nmap <buffer><silent><expr>
        \ <Plug>(fern-action-diff:side:vert)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-action-diff:left:vert)",
        \   "\<Plug>(fern-action-diff:right:vert)",
        \ )

  " Alias map
  nmap <buffer><silent> <Plug>(fern-action-diff:edit) <Plug>(fern-action-diff:edit-or-error)
  nmap <buffer><silent> <Plug>(fern-action-diff:edit:vert) <Plug>(fern-action-diff:edit-or-error:vert)
  nmap <buffer><silent> <Plug>(fern-action-diff) <Plug>(fern-action-diff:edit)
  nmap <buffer><silent> <Plug>(fern-action-diff:vert) <Plug>(fern-action-diff:edit:vert)
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_diff(helper, opener, vert) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let nodes = filter(copy(nodes), { -> v:val.bufname isnot# v:null })
  if empty(nodes)
    return s:Promise.reject('no node found which has bufname')
  elseif len(nodes) < 2
    return s:Promise.reject('at least two nodes are required to perform diff')
  endif
  try
    let is_drawer = a:helper.sync.is_drawer()
    let first = nodes[0]
    let nodes = nodes[1:]
    call fern#internal#buffer#open(first.bufname, {
          \ 'opener': a:opener,
          \ 'locator': is_drawer,
          \ 'keepalt': !is_drawer && g:fern#keepalt_on_edit,
          \ 'keepjumps': !is_drawer && g:fern#keepjumps_on_edit,
          \})
    call s:diffthis()
    let winid = win_getid()
    for node in nodes
      noautocmd call win_gotoid(winid)
      call fern#internal#buffer#open(node.bufname, {
            \ 'opener': a:vert ? 'vsplit' : 'split',
            \ 'locator': is_drawer,
            \ 'keepalt': !is_drawer && g:fern#keepalt_on_edit,
            \ 'keepjumps': !is_drawer && g:fern#keepjumps_on_edit,
            \})
      call s:diffthis()
    endfor
    call s:diffupdate()
    normal! zm
    " Fix <C-w><C-p> (#47)
    let winid_fern = win_getid()
    noautocmd call win_gotoid(winid)
    noautocmd call win_gotoid(winid_fern)
    return a:helper.async.update_marks([])
        \.then({ -> a:helper.async.remark() })
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction

function! s:diffthis() abort
  diffthis
  augroup fern_mapping_diff_internal
    autocmd! * <buffer>
    autocmd BufReadPost <buffer>
          \ if &diff && &foldmethod !=# 'diff' |
          \   setlocal foldmethod=diff |
          \ endif
  augroup END
endfunction

function! s:diffupdate() abort
  " NOTE:
  " 'diffupdate' does not work just after a buffer has opened
  " so use timer to delay the command.
  silent! call timer_stop(s:timer_diffupdate)
  let s:timer_diffupdate = timer_start(100, function('s:diffupdate_internal', [bufnr('%')]))
endfunction

function! s:diffupdate_internal(bufnr, ...) abort
  let winid = bufwinid(a:bufnr)
  if winid == -1
    return
  endif
  let winid_saved = win_getid()
  try
    if winid != winid_saved
      call win_gotoid(winid)
    endif
    diffupdate
    syncbind
  finally
    call win_gotoid(winid_saved)
  endtry
endfunction
./autoload/fern/mapping/drawer.vim	[[[1
58
function! fern#mapping#drawer#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-zoom) :<C-u>call <SID>call('zoom')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-zoom:reset) :<C-u>call <SID>call('zoom_reset')<CR>
  nmap <buffer><silent> <Plug>(fern-action-zoom:half) 4<Plug>(fern-action-zoom)
  nmap <buffer><silent> <Plug>(fern-action-zoom:full) 9<Plug>(fern-action-zoom)

  if !a:disable_default_mappings
    nmap <buffer><nowait> z <Plug>(fern-action-zoom)
    nmap <buffer><nowait> Z <Plug>(fern-action-zoom:reset)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_zoom(helper) abort
  if !fern#internal#drawer#is_drawer()
    call fern#warn('zoom is available only on drawer')
    return
  endif
  let alpha = v:count
  if alpha <= 0 || alpha > 10
    let current = float2nr(ceil(str2float(winwidth(0)) / &columns * 10))
    let alpha = s:input_alpha(printf('Width ratio [%d -> 1-10]: ', current))
    if alpha is# v:null
      return
    endif
  endif
  let alpha = str2float(alpha)
  let width = &columns * (alpha / 10)
  execute 'vertical resize' float2nr(width)
endfunction

function! s:map_zoom_reset(helper) abort
  if !fern#internal#drawer#is_drawer()
    call fern#warn('zoom:resize is available only on drawer')
    return
  endif
  call fern#internal#drawer#resize()
endfunction

function! s:input_alpha(prompt) abort
  while v:true
    let result = input(a:prompt)
    if result ==# ''
      redraw | echo ''
      return v:null
    elseif result =~# '^\%(10\|[1-9]\)$'
      redraw | echo ''
      return result
    endif
    redraw | echo 'Please input a digit from 1 to 10'
  endwhile
endfunction
./autoload/fern/mapping/filter.vim	[[[1
62
function! fern#mapping#filter#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-hidden:set)    :<C-u>call <SID>call('hidden_set')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-hidden:unset)  :<C-u>call <SID>call('hidden_unset')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-hidden:toggle) :<C-u>call <SID>call('hidden_toggle')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-include)       :<C-u>call <SID>call('include')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-exclude)       :<C-u>call <SID>call('exclude')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-include=)      :<C-u>call <SID>call_without_guard('include')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-exclude=)      :<C-u>call <SID>call_without_guard('exclude')<CR>

  " Alias
  nmap <buffer> <Plug>(fern-action-hidden) <Plug>(fern-action-hidden:toggle)

  if !a:disable_default_mappings
    nmap <buffer><nowait> !  <Plug>(fern-action-hidden)
    nmap <buffer><nowait> fi <Plug>(fern-action-include)
    nmap <buffer><nowait> fe <Plug>(fern-action-exclude)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:call_without_guard(name, ...) abort
  return call(
        \ 'fern#mapping#call_without_guard',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_hidden_set(helper) abort
  return a:helper.async.set_hidden(1)
        \.then({ -> a:helper.async.redraw() })
endfunction

function! s:map_hidden_unset(helper) abort
  return a:helper.async.set_hidden(0)
        \.then({ -> a:helper.async.redraw() })
endfunction

function! s:map_hidden_toggle(helper) abort
  if a:helper.fern.hidden
    return s:map_hidden_unset(a:helper)
  else
    return s:map_hidden_set(a:helper)
  endif
endfunction

function! s:map_include(helper) abort
  let pattern = input('Pattern: ', a:helper.fern.include)
  return a:helper.async.set_include(pattern)
        \.then({ -> a:helper.async.redraw() })
endfunction

function! s:map_exclude(helper) abort
  let pattern = input('Pattern: ', a:helper.fern.exclude)
  return a:helper.async.set_exclude(pattern)
        \.then({ -> a:helper.async.redraw() })
endfunction
./autoload/fern/mapping/mark.vim	[[[1
64
let s:Promise = vital#fern#import('Async.Promise')

function! fern#mapping#mark#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-mark:clear)  :<C-u>call <SID>call('mark_clear')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-mark:set)    :<C-u>call <SID>call('mark_set')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-mark:unset   :<C-u>call <SID>call('mark_unset')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-mark:toggle) :<C-u>call <SID>call('mark_toggle')<CR>
  vnoremap <buffer><silent> <Plug>(fern-action-mark:set)    :call <SID>call('mark_set')<CR>
  vnoremap <buffer><silent> <Plug>(fern-action-mark:unset)  :call <SID>call('mark_unset')<CR>
  vnoremap <buffer><silent> <Plug>(fern-action-mark:toggle) :call <SID>call('mark_toggle')<CR>

  " Alias
  nmap <buffer> <Plug>(fern-action-mark) <Plug>(fern-action-mark:toggle)
  vmap <buffer> <Plug>(fern-action-mark) <Plug>(fern-action-mark:toggle)

  if !a:disable_default_mappings
    nmap <buffer><nowait> <C-j> <Plug>(fern-action-mark)j
    nmap <buffer><nowait> <C-k> k<Plug>(fern-action-mark)
    nmap <buffer><nowait> -     <Plug>(fern-action-mark)
    vmap <buffer><nowait> -     <Plug>(fern-action-mark)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_mark_set(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  return a:helper.async.set_mark(node.__key, 1)
        \.then({ -> a:helper.async.remark() })
endfunction

function! s:map_mark_unset(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  return a:helper.async.set_mark(node.__key, 0)
        \.then({ -> a:helper.async.remark() })
endfunction

function! s:map_mark_toggle(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  if index(a:helper.fern.marks, node.__key) is# -1
    return s:map_mark_set(a:helper)
  else
    return s:map_mark_unset(a:helper)
  endif
endfunction

function! s:map_mark_clear(helper) abort
  return a:helper.async.update_marks([])
        \.then({ -> a:helper.async.remark() })
endfunction
./autoload/fern/mapping/node.vim	[[[1
157
let s:Promise = vital#fern#import('Async.Promise')
let s:Lambda = vital#fern#import('Lambda')

function! fern#mapping#node#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-debug)         :<C-u>call <SID>call('debug')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-reload:all)    :<C-u>call <SID>call('reload_all')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-reload:cursor) :<C-u>call <SID>call('reload_cursor')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-expand:stay)   :<C-u>call <SID>call('expand_stay')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-expand:in)     :<C-u>call <SID>call('expand_in')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-collapse)      :<C-u>call <SID>call('collapse')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-reveal)        :<C-u>call <SID>call('reveal')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-reveal=)       :<C-u>call <SID>call_without_guard('reveal')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-focus:parent)  :<C-u>call <SID>call('focus_parent')<CR>

  nnoremap <buffer><silent> <Plug>(fern-action-enter)         :<C-u>call <SID>call('enter')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-leave)         :<C-u>call <SID>call('leave')<CR>

  nmap <buffer> <Plug>(fern-action-reload) <Plug>(fern-action-reload:all)
  nmap <buffer> <Plug>(fern-action-expand) <Plug>(fern-action-expand:in)

  if !a:disable_default_mappings
    nmap <buffer><nowait> <F5> <Plug>(fern-action-reload)
    nmap <buffer><nowait> <C-m> <Plug>(fern-action-enter)
    nmap <buffer><nowait> <Return> <Plug>(fern-action-enter)
    nmap <buffer><nowait> <C-h> <Plug>(fern-action-leave)
    nmap <buffer><nowait> <Backspace> <Plug>(fern-action-leave)
    nmap <buffer><nowait> l <Plug>(fern-action-expand)
    nmap <buffer><nowait> h <Plug>(fern-action-collapse)
    nmap <buffer><nowait> i <Plug>(fern-action-reveal)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:call_without_guard(name, ...) abort
  return call(
        \ 'fern#mapping#call_without_guard',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_debug(helper) abort
  let node = a:helper.sync.get_cursor_node()
  redraw | echo fern#internal#node#debug(node)
endfunction

function! s:map_reload_all(helper) abort
  let node = a:helper.sync.get_root_node()
  return a:helper.async.reload_node(node.__key)
        \.then({ -> a:helper.async.redraw() })
endfunction

function! s:map_reload_cursor(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  return a:helper.async.reload_node(node.__key)
        \.then({ -> a:helper.async.redraw() })
endfunction

function! s:map_expand_stay(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  let previous = a:helper.sync.get_cursor_node()
  return a:helper.async.expand_node(node.__key)
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(
        \   node.__key,
        \   { 'previous': previous },
        \ )
        \})
endfunction

function! s:map_expand_in(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  let previous = a:helper.sync.get_cursor_node()
  let ns = {}
  return a:helper.async.expand_node(node.__key)
        \.then({ -> a:helper.async.get_child_nodes(node.__key) })
        \.then({ c -> s:Lambda.let(ns, 'offset', len(c) > 0) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(
        \   node.__key,
        \   { 'previous': previous, 'offset': ns.offset },
        \ )
        \})
endfunction

function! s:map_collapse(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  let previous = a:helper.sync.get_cursor_node()
  return a:helper.async.collapse_node(node.__key)
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(
        \   node.__key,
        \   { 'previous': previous },
        \ )
        \})
endfunction

function! s:map_reveal(helper) abort
  let path = input(
        \ 'Reveal: ',
        \ '',
        \ printf('customlist,%s', get(funcref('s:reveal_complete'), 'name')),
        \)
  if empty(path)
    return s:Promise.reject('Cancelled')
  endif
  return fern#internal#viewer#reveal(a:helper, path)
endfunction

function! s:map_focus_parent(helper) abort
  let owner = a:helper.sync.get_cursor_node().__owner

  if empty(owner)
    return
  endif

  call a:helper.sync.focus_node(owner.__key)
endfunction

function! s:map_enter(helper) abort
  let node = a:helper.sync.get_cursor_node()
  if node is# v:null
    return s:Promise.reject('no node found on a cursor line')
  endif
  return a:helper.async.enter_tree(node)
endfunction

function! s:map_leave(helper) abort
  return a:helper.async.leave_tree()
endfunction

function! s:reveal_complete(arglead, cmdline, cursorpos) abort
  let helper = fern#helper#new()
  let fri = fern#fri#parse(bufname('%'))
  let scheme = helper.fern.scheme
  let cmdline = fri.path
  let arglead = printf('-reveal=%s', a:arglead)
  let rs = fern#internal#complete#reveal(arglead, cmdline, a:cursorpos)
  return map(rs, { -> matchstr(v:val, '-reveal=\zs.*') })
endfunction
./autoload/fern/mapping/open.vim	[[[1
92
let s:Promise = vital#fern#import('Async.Promise')

function! fern#mapping#open#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-open:select)   :<C-u>call <SID>call('open', 'select')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:split)    :<C-u>call <SID>call('open', 'split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:vsplit)   :<C-u>call <SID>call('open', 'vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:tabedit)  :<C-u>call <SID>call('open', 'tabedit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:above)    :<C-u>call <SID>call('open', 'leftabove split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:left)     :<C-u>call <SID>call('open', 'leftabove vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:below)    :<C-u>call <SID>call('open', 'rightbelow split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:right)    :<C-u>call <SID>call('open', 'rightbelow vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:top)      :<C-u>call <SID>call('open', 'topleft split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:leftest)  :<C-u>call <SID>call('open', 'topleft vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:bottom)   :<C-u>call <SID>call('open', 'botright split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:rightest) :<C-u>call <SID>call('open', 'botright vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:drop)     :<C-u>call <SID>call('open', 'drop')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-error)   :<C-u>call <SID>call('open', 'edit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-split)   :<C-u>call <SID>call('open', 'edit/split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-vsplit)  :<C-u>call <SID>call('open', 'edit/vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-tabedit) :<C-u>call <SID>call('open', 'edit/tabedit')<CR>

  " Smart map
  nmap <buffer><silent><expr>
        \ <Plug>(fern-action-open:side)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-action-open:left)",
        \   "\<Plug>(fern-action-open:right)",
        \   "\<Plug>(fern-action-open:right)",
        \ )
  nmap <buffer><silent><expr>
        \ <Plug>(fern-action-open-or-enter)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-action-enter)",
        \ )
  nmap <buffer><silent><expr>
        \ <Plug>(fern-action-open-or-expand)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-action-expand)",
        \ )

  " Alias map
  nmap <buffer><silent> <Plug>(fern-action-open:edit) <Plug>(fern-action-open:edit-or-error)
  nmap <buffer><silent> <Plug>(fern-action-open) <Plug>(fern-action-open:edit)

  if !a:disable_default_mappings
    nmap <buffer><nowait> <C-m> <Plug>(fern-action-open-or-enter)
    nmap <buffer><nowait> <Return> <Plug>(fern-action-open-or-enter)
    nmap <buffer><nowait> l <Plug>(fern-action-open-or-expand)
    nmap <buffer><nowait> s <Plug>(fern-action-open:select)
    nmap <buffer><nowait> e <Plug>(fern-action-open)
    nmap <buffer><nowait> E <Plug>(fern-action-open:side)
    nmap <buffer><nowait> t <Plug>(fern-action-open:tabedit)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_open(helper, opener) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let nodes = filter(copy(nodes), { -> v:val.bufname isnot# v:null })
  if empty(nodes)
    return s:Promise.reject('no node found which has bufname')
  endif
  try
    let winid = win_getid()
    let is_drawer = a:helper.sync.is_drawer()
    for node in nodes
      noautocmd call win_gotoid(winid)
      call fern#internal#buffer#open(node.bufname, {
            \ 'opener': a:opener,
            \ 'locator': is_drawer,
            \ 'keepalt': !is_drawer && g:fern#keepalt_on_edit,
            \ 'keepjumps': !is_drawer && g:fern#keepjumps_on_edit,
            \})
    endfor
    " Fix <C-w><C-p> (#47)
    let winid_fern = win_getid()
    noautocmd call win_gotoid(winid)
    noautocmd call win_gotoid(winid_fern)
    return a:helper.async.update_marks([])
        \.then({ -> a:helper.async.remark() })
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction
./autoload/fern/mapping/tree.vim	[[[1
28
let s:Promise = vital#fern#import('Async.Promise')
let s:WindowCursor = vital#fern#import('Vim.Window.Cursor')

function! fern#mapping#tree#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-cancel) :<C-u>call <SID>call('cancel')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-redraw) :<C-u>call <SID>call('redraw')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> <C-c> <Plug>(fern-action-cancel)
    nmap <buffer><nowait> <C-l> <Plug>(fern-action-redraw)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_cancel(helper) abort
  call a:helper.sync.cancel()
  return a:helper.async.redraw()
endfunction

function! s:map_redraw(helper) abort
  return a:helper.async.redraw()
endfunction
./autoload/fern/mapping/wait.vim	[[[1
38
let s:Config = vital#fern#import('Config')
let s:Promise = vital#fern#import('Async.Promise')

function! fern#mapping#wait#init(disable_default_mappings) abort
  nnoremap <buffer><silent>
        \ <Plug>(fern-wait-viewer:ready)
        \ :<C-u>call <SID>call('hook', 'viewer:ready')<CR>
  nmap <buffer> <Plug>(fern-wait) <Plug>(fern-wait-viewer:ready)
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_hook(helper, hook) abort
  let [_, err] = s:Promise.wait(
        \ fern#hook#promise(a:hook),
        \ {
        \   'interval': g:fern#mapping#wait#interval,
        \   'timeout': g:fern#mapping#wait#timeout,
        \ },
        \)
  if err isnot# v:null
    throw printf(
          \ '[fern] Failed to wait hook "%s": %s',
          \ a:hook,
          \ err,
          \)
  endif
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'interval': 100,
      \ 'timeout': 1000,
      \})
./autoload/fern/mapping/yank.vim	[[[1
25
function! fern#mapping#yank#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-yank:label) :<C-u>call <SID>call('yank', 'label')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-yank:badge) :<C-u>call <SID>call('yank', 'badge')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-yank:bufname) :<C-u>call <SID>call('yank', 'bufname')<CR>

  nmap <buffer> <Plug>(fern-action-yank) <Plug>(fern-action-yank:bufname)

  if !a:disable_default_mappings
    nmap <buffer><nowait> y <Plug>(fern-action-yank)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_yank(helper, attr) abort
  let node = a:helper.sync.get_cursor_node()
  let value = get(node, a:attr, '')
  call setreg(v:register, value)
  redraw | echo printf("The node '%s' has yanked.", a:attr)
endfunction
./autoload/fern/mapping.vim	[[[1
56
let s:Config = vital#fern#import('Config')
let s:Promise = vital#fern#import('Async.Promise')

function! fern#mapping#call(fn, ...) abort
  try
    call inputsave()
    call s:Promise.resolve(call('fern#helper#call', [a:fn] + a:000))
          \.catch({ e -> fern#logger#error(e) })
  catch
    call fern#logger#error(v:exception)
  finally
    call inputrestore()
  endtry
endfunction

function! fern#mapping#call_without_guard(fn, ...) abort
  try
    call s:Promise.resolve(call('fern#helper#call', [a:fn] + a:000))
          \.catch({ e -> fern#logger#error(e) })
  catch
    call fern#logger#error(v:exception)
  endtry
endfunction

function! fern#mapping#init(scheme) abort
  let disable_default_mappings = g:fern#disable_default_mappings
  for name in g:fern#mapping#mappings
    call fern#mapping#{name}#init(disable_default_mappings)
  endfor
  call fern#internal#scheme#mapping_init(a:scheme, disable_default_mappings)
endfunction

function! fern#mapping#deprecated(old, new) abort
  call fern#util#deprecated(
        \ printf('<Plug>(%s)', a:old),
        \ printf('<Plug>(%s)', a:new),
        \)
  " Do NOT show the warning message more than once
  silent execute printf('nmap <buffer> <Plug>(%s) <Plug>(%s)', a:old, a:new)
  " Return new mapping
  return printf("\<Plug>(%s)", a:new)
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'mappings': [
      \   'diff',
      \   'drawer',
      \   'filter',
      \   'mark',
      \   'node',
      \   'open',
      \   'tree',
      \   'wait',
      \   'yank',
      \ ],
      \})
./autoload/fern/profile.vim	[[[1
42
let s:indent = 0

function! fern#profile#start(name) abort
  if !get(g:, 'fern#profile')
    return { -> 0 }
  endif
  let now = reltime()
  let ns = {
        \ 'start': now,
        \ 'previous': now,
        \}
  echomsg s:format(a:name, 'enter')
  let s:indent += 1
  return funcref('s:profile_leave', [ns, a:name])
endfunction

function! s:format(name, label, ...) abort
  return printf(
        \ '%s%s [%s] %s',
        \ repeat('| ', s:indent),
        \ a:name,
        \ a:label,
        \ join(a:000),
        \)
endfunction

function! s:profile_leave(ns, name, ...) abort
  let label = a:0 ? a:1 : 'leave'
  let now = reltime()
  let start = a:ns.start
  let previous = a:ns.previous
  let profile = printf(
        \ '%s [%s]',
        \ split(reltimestr(reltime(previous, now)))[0],
        \ split(reltimestr(reltime(start, now)))[0],
        \)
  let a:ns.previous = now
  if a:0 is# 0
    let s:indent -= 1
  endif
  echomsg s:format(a:name, label, profile)
endfunction
./autoload/fern/renderer/default.vim	[[[1
100
let s:Config = vital#fern#import('Config')
let s:AsyncLambda = vital#fern#import('Async.Lambda')

let s:ESCAPE_PATTERN = '^$~.*[]\'
let s:STATUS_NONE = g:fern#STATUS_NONE
let s:STATUS_COLLAPSED = g:fern#STATUS_COLLAPSED

function! fern#renderer#default#new() abort
  return {
        \ 'render': funcref('s:render'),
        \ 'index': funcref('s:index'),
        \ 'lnum': funcref('s:lnum'),
        \ 'syntax': funcref('s:syntax'),
        \ 'highlight': funcref('s:highlight'),
        \}
endfunction

function! s:render(nodes) abort
  let options = {
        \ 'leading': g:fern#renderer#default#leading,
        \ 'root_symbol': g:fern#renderer#default#root_symbol,
        \ 'leaf_symbol': g:fern#renderer#default#leaf_symbol,
        \ 'expanded_symbol': g:fern#renderer#default#expanded_symbol,
        \ 'collapsed_symbol': g:fern#renderer#default#collapsed_symbol,
        \}
  let base = len(a:nodes[0].__key)
  let l:Profile = fern#profile#start('fern#renderer#default#s:render')
  return s:AsyncLambda.map(copy(a:nodes), { v, -> s:render_node(v, base, options) })
        \.finally({ -> Profile() })
endfunction

function! s:index(lnum) abort
  return a:lnum - 1
endfunction

function! s:lnum(index) abort
  return a:index + 1
endfunction

function! s:syntax() abort
  syntax match FernLeaf   /^.*[^/].*$/ transparent contains=FernLeaderSymbol
  syntax match FernBranch /^.*\/.*$/   transparent contains=FernLeaderSymbol
  syntax match FernRoot   /\%1l.*/       transparent contains=FernRootSymbol
  execute printf(
        \ 'syntax match FernRootSymbol /%s/ contained nextgroup=FernRootText',
        \ escape(g:fern#renderer#default#root_symbol, s:ESCAPE_PATTERN),
        \)
  execute printf(
        \ 'syntax match FernLeafSymbol /%s/ contained nextgroup=FernLeafText',
        \ escape(g:fern#renderer#default#leaf_symbol, s:ESCAPE_PATTERN),
        \)
  execute printf(
        \ 'syntax match FernBranchSymbol /\%%(%s\|%s\)/ contained nextgroup=FernBranchText',
        \ escape(g:fern#renderer#default#collapsed_symbol, s:ESCAPE_PATTERN),
        \ escape(g:fern#renderer#default#expanded_symbol, s:ESCAPE_PATTERN),
        \)
  execute printf(
        \ 'syntax match FernLeaderSymbol /^\%%(%s\)*/ contained nextgroup=FernBranchSymbol,FernLeafSymbol',
        \ escape(g:fern#renderer#default#leading, s:ESCAPE_PATTERN),
        \)
  syntax match FernRootText   /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernLeafText   /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernBranchText /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernBadgeSep   //         contained conceal nextgroup=FernBadge
  syntax match FernBadge      /.*/         contained
  setlocal concealcursor=nvic conceallevel=2
endfunction

function! s:highlight() abort
  highlight default link FernRootSymbol   Directory
  highlight default link FernRootText     Directory
  highlight default link FernLeafSymbol   Directory
  highlight default link FernLeafText     None
  highlight default link FernBranchSymbol Directory
  highlight default link FernBranchText   Directory
  highlight default link FernLeaderSymbol Directory
endfunction

function! s:render_node(node, base, options) abort
  let level = len(a:node.__key) - a:base
  if level is# 0
    return a:options.root_symbol . a:node.label . '' . a:node.badge
  endif
  let leading = repeat(a:options.leading, level - 1)
  let symbol = a:node.status is# s:STATUS_NONE
        \ ? a:options.leaf_symbol
        \ : a:node.status is# s:STATUS_COLLAPSED
        \   ? a:options.collapsed_symbol
        \   : a:options.expanded_symbol
  let suffix = a:node.status ? '/' : ''
  return leading . symbol . a:node.label . suffix . '' . a:node.badge
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'leading': ' ',
      \ 'root_symbol': '',
      \ 'leaf_symbol': '|  ',
      \ 'collapsed_symbol': '|+ ',
      \ 'expanded_symbol': '|- ',
      \})
./autoload/fern/scheme/debug/provider.vim	[[[1
146
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#debug#provider#new(...) abort
  let tree = a:0 ? a:1 : s:tree
  return {
        \ 'get_root' : funcref('s:provider_get_root', [tree]),
        \ 'get_parent' : funcref('s:provider_get_parent', [tree]),
        \ 'get_children' : funcref('s:provider_get_children', [tree]),
        \}
endfunction

function! s:sleep(ms) abort
  return s:Promise.new({ resolve -> timer_start(a:ms, { -> resolve() }) })
endfunction

function! s:get_entry(tree, key) abort
  if !has_key(a:tree, a:key)
    return v:null
  endif
  let entry = extend({'key': a:key}, a:tree[a:key])
  return entry
endfunction

function! s:provider_get_root(tree, url) abort
  let url = matchstr(a:url, '^debug://\zs.*')
  let entry = s:get_entry(a:tree, url)
  if entry is# v:null
    throw printf('no such entry: %s', a:url)
  endif
  let node = {
        \ 'name': get(split(entry.key, '/'), -1, 'root'),
        \ 'status': has_key(entry, 'children'),
        \ '_uri': url,
        \}
  if node.status
    let node.bufname = 'fern:///debug://' . url
  endif
  return node
endfunction

function! s:provider_get_parent(tree, node, ...) abort
  let uri = matchstr(a:node._uri, '.*\ze/[^/]\{-}$')
  let uri = empty(uri) ? '/' : uri
  try
    let node = s:provider_get_root(a:tree, 'debug://' . uri)
    return s:Promise.resolve(node)
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction

function! s:provider_get_children(tree, node, ...) abort
  let uri = a:node._uri
  let entry = s:get_entry(a:tree, a:node._uri)
  if !has_key(entry, 'children')
    return s:Promise.reject(printf('no children exists for %s', entry.key))
  endif
  let base = split(uri, '/')
  try
    let children = map(
          \ copy(entry.children),
          \ { -> s:provider_get_root(a:tree, 'debug:///' . join(base + [v:val], '/')) },
          \)
    return s:sleep(get(entry, 'delay', 0)).then({ -> children })
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction


let s:tree = {
      \ '/': {
      \   'parent': v:null,
      \   'children': [
      \     'shallow',
      \     'deep',
      \     'heavy',
      \     'leaf',
      \   ],
      \ },
      \ '/shallow': {
      \   'parent': '/',
      \   'children': [
      \     'alpha',
      \     'beta',
      \     'gamma',
      \   ],
      \ },
      \ '/shallow/alpha': {
      \   'parent': '/shallow',
      \   'children': [],
      \ },
      \ '/shallow/beta': {
      \   'parent': '/shallow',
      \   'children': [],
      \ },
      \ '/shallow/gamma': {
      \   'parent': '/shallow',
      \ },
      \ '/deep': {
      \   'parent': '/',
      \   'children': [
      \     'alpha',
      \   ],
      \ },
      \ '/deep/alpha': {
      \   'parent': '/deep',
      \   'children': [
      \     'beta',
      \   ],
      \ },
      \ '/deep/alpha/beta': {
      \   'parent': '/deep/alpha',
      \   'children': [
      \     'gamma',
      \   ],
      \ },
      \ '/deep/alpha/beta/gamma': {
      \   'parent': '/deep/alpha/beta',
      \ },
      \ '/heavy': {
      \   'delay': 1000,
      \   'parent': '/',
      \   'children': [
      \     'alpha',
      \     'beta',
      \     'gamma',
      \   ],
      \ },
      \ '/heavy/alpha': {
      \   'delay': 2000,
      \   'parent': '/heavy',
      \   'children': [],
      \ },
      \ '/heavy/beta': {
      \   'delay': 3000,
      \   'parent': '/heavy',
      \   'children': [],
      \ },
      \ '/heavy/gamma': {
      \   'parent': '/heavy',
      \ },
      \ '/leaf': {
      \   'parent': '/',
      \ },
      \}
./autoload/fern/scheme/dict/mapping/clipboard.vim	[[[1
104
let s:Promise = vital#fern#import('Async.Promise')

let s:clipboard = {
      \ 'mode': 'copy',
      \ 'candidates': [],
      \}

function! fern#scheme#dict#mapping#clipboard#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-copy)  :<C-u>call <SID>call('clipboard_copy')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-move)  :<C-u>call <SID>call('clipboard_move')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-paste) :<C-u>call <SID>call('clipboard_paste')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-clear) :<C-u>call <SID>call('clipboard_clear')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> C <Plug>(fern-action-clipboard-copy)
    nmap <buffer><nowait> M <Plug>(fern-action-clipboard-move)
    nmap <buffer><nowait> P <Plug>(fern-action-clipboard-paste)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_clipboard_move(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let s:clipboard = {
        \ 'mode': 'move',
        \ 'candidates': copy(nodes),
        \}
  return s:Promise.resolve()
        \.then({ -> a:helper.async.update_marks([]) })
        \.then({ -> a:helper.async.remark() })
        \.then({ -> a:helper.sync.echo(printf('%d items are saved in clipboard to move', len(nodes))) })
endfunction

function! s:map_clipboard_copy(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let s:clipboard = {
        \ 'mode': 'copy',
        \ 'candidates': copy(nodes),
        \}
  return s:Promise.resolve()
        \.then({ -> a:helper.async.update_marks([]) })
        \.then({ -> a:helper.async.remark() })
        \.then({ -> a:helper.sync.echo(printf('%d items are saved in clipboard to copy', len(nodes))) })
endfunction

function! s:map_clipboard_paste(helper) abort
  if empty(s:clipboard)
    return s:Promise.reject('Nothing to paste')
  endif

  if s:clipboard.mode ==# 'move'
    let paths = map(copy(s:clipboard.candidates), { -> v:val._path })
    let prompt = printf('The following %d nodes will be moved', len(paths))
    for path in paths[:5]
      let prompt .= "\n" . path
    endfor
    if len(paths) > 5
      let prompt .= "\n..."
    endif
    let prompt .= "\nAre you sure to continue (Y[es]/no): "
    if !fern#internal#prompt#confirm(prompt)
      return s:Promise.reject('Cancelled')
    endif
  endif

  let provider = a:helper.fern.provider
  let tree = provider._tree

  let node = a:helper.sync.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node
  let processed = 0
  for src in s:clipboard.candidates
    let dst = '/' . join(split(node._path . '/' . matchstr(src._path, '[^/]\+$'), '/'), '/')
    if s:clipboard.mode ==# 'move'
      echo printf('Move %s -> %s', src._path, dst)
      call fern#scheme#dict#tree#move(tree, src._path, dst)
    else
      echo printf('Copy %s -> %s', src._path, dst)
      call fern#scheme#dict#tree#copy(tree, src._path, dst)
    endif
    let processed += 1
  endfor
  call provider._update_tree(tree)

  let root = a:helper.sync.get_root_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.collapse_modified_nodes(s:clipboard.candidates) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are proceeded', processed)) })
endfunction

function! s:map_clipboard_clear(helper) abort
  let s:clipboard = {
        \ 'mode': 'copy',
        \ 'candidates': [],
        \}
endfunction
./autoload/fern/scheme/dict/mapping/rename.vim	[[[1
75
let s:Lambda = vital#fern#import('Lambda')
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#dict#mapping#rename#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-rename:select)   :<C-u>call <SID>call('rename', 'select')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:split)    :<C-u>call <SID>call('rename', 'split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:vsplit)   :<C-u>call <SID>call('rename', 'vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:tabedit)  :<C-u>call <SID>call('rename', 'tabedit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:above)    :<C-u>call <SID>call('rename', 'leftabove split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:left)     :<C-u>call <SID>call('rename', 'leftabove vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:below)    :<C-u>call <SID>call('rename', 'rightbelow split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:right)    :<C-u>call <SID>call('rename', 'rightbelow vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:top)      :<C-u>call <SID>call('rename', 'topleft split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:leftest)  :<C-u>call <SID>call('rename', 'topleft vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:bottom)   :<C-u>call <SID>call('rename', 'botright split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:rightest) :<C-u>call <SID>call('rename', 'botright vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-error)   :<C-u>call <SID>call('rename', 'edit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-split)   :<C-u>call <SID>call('rename', 'edit/split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-vsplit)  :<C-u>call <SID>call('rename', 'edit/vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-tabedit) :<C-u>call <SID>call('rename', 'edit/tabedit')<CR>

  " Alias map
  nmap <buffer><silent> <Plug>(fern-action-rename:edit) <Plug>(fern-action-rename:edit-or-error)
  nmap <buffer><silent> <Plug>(fern-action-rename) <Plug>(fern-action-rename:split)

  if !a:disable_default_mappings
    nmap <buffer><nowait> R <Plug>(fern-action-rename)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_rename(helper, opener) abort
  let root = a:helper.sync.get_root_node()
  let nodes = a:helper.sync.get_selected_nodes()
  let tree = a:helper.fern.provider._tree
  let l:Factory = { -> map(copy(nodes), { -> v:val._path }) }
  let solver_options = {
        \ 'exist': { v -> fern#scheme#dict#tree#exists(tree, v) },
        \ 'tempname': { _ -> fern#scheme#dict#tree#tempname(tree) },
        \ 'isdirectory': { v -> type(fern#scheme#dict#tree#read(tree, v)) is# v:t_dict },
        \}
  let options = {
        \ 'opener': a:opener,
        \ 'cursor': [1, len(root._path) + 1],
        \ 'is_drawer': a:helper.sync.is_drawer(),
        \ 'modifiers': [
        \   { r -> fern#internal#rename_solver#solve(r, solver_options) },
        \ ],
        \}
  let ns = {}
  return fern#internal#replacer#start(Factory, options)
        \.then({ r -> s:_map_rename(a:helper, r) })
        \.then({ n -> s:Lambda.let(ns, 'n', n) })
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are renamed', ns.n)) })
endfunction

function! s:_map_rename(helper, result) abort
  let provider = a:helper.fern.provider
  let tree = provider._tree
  let fs = []
  for [src, dst] in a:result
    call fern#scheme#dict#tree#move(tree, src, dst)
  endfor
  call provider._update_tree(provider._tree)
  return s:Promise.resolve(len(fs))
endfunction
./autoload/fern/scheme/dict/mapping.vim	[[[1
207
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#dict#mapping#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-new-leaf)   :<C-u>call <SID>call('new_leaf')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-new-branch) :<C-u>call <SID>call('new_branch')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-copy)       :<C-u>call <SID>call('copy')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-move)       :<C-u>call <SID>call('move')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-remove)     :<C-u>call <SID>call('remove')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-edit-leaf)  :<C-u>call <SID>call('edit_leaf')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> N <Plug>(fern-action-new-leaf)
    nmap <buffer><nowait> K <Plug>(fern-action-new-branch)
    nmap <buffer><nowait> c <Plug>(fern-action-copy)
    nmap <buffer><nowait> m <Plug>(fern-action-move)
    nmap <buffer><nowait> D <Plug>(fern-action-remove)
    nmap <buffer><nowait> e <Plug>(fern-action-edit-leaf)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_new_leaf(helper) abort
  let provider = a:helper.fern.provider

  " Ask a new leaf path
  let path = provider._prompt_leaf(a:helper)

  " Get parent node of a new leaf
  let node = a:helper.sync.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node

  " Update tree
  call fern#scheme#dict#tree#create(
        \ node.concealed._value,
        \ path,
        \ provider._default_leaf(a:helper, node, path),
        \)
  call provider._update_tree(provider._tree)

  " Update UI
  let key = node.__key + split(path, '/')
  let previous = a:helper.sync.get_cursor_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.reload_node(node.__key) })
        \.then({ -> a:helper.async.reveal_node(key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(key, { 'previous': previous }) })
endfunction

function! s:map_new_branch(helper) abort
  let provider = a:helper.fern.provider

  " Ask a new branch path
  let path = provider._prompt_branch(a:helper)

  " Get parent node of a new branch
  let node = a:helper.sync.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node

  " Update tree
  call fern#scheme#dict#tree#create(
        \ node.concealed._value,
        \ path,
        \ provider._default_branch(a:helper, node, path),
        \)
  call provider._update_tree(provider._tree)

  " Update UI
  let key = node.__key + split(path, '/')
  let previous = a:helper.sync.get_cursor_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.reload_node(node.__key) })
        \.then({ -> a:helper.async.reveal_node(key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(key, { 'previous': previous }) })
endfunction

function! s:map_copy(helper) abort
  let provider = a:helper.fern.provider
  let tree = provider._tree

  let nodes = a:helper.sync.get_selected_nodes()
  let processed = 0
  for node in nodes
    let src = node._path
    let dst = input(
          \ printf('Copy: %s -> ', src),
          \ src,
          \ isdirectory(src) ? 'dir' : 'file',
          \)
    if empty(dst) || src ==# dst
      continue
    endif
    call fern#scheme#dict#tree#copy(tree, src, dst)
    let processed += 1
  endfor
  call provider._update_tree(tree)

  let root = a:helper.sync.get_root_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are copied', processed)) })
endfunction

function! s:map_move(helper) abort
  let provider = a:helper.fern.provider
  let tree = provider._tree

  let nodes = a:helper.sync.get_selected_nodes()
  let processed = 0
  for node in nodes
    let src = node._path
    let dst = input(
          \ printf('Move: %s -> ', src),
          \ src,
          \ isdirectory(src) ? 'dir' : 'file',
          \)
    if empty(dst) || src ==# dst
      continue
    endif
    call fern#scheme#dict#tree#move(tree, src, dst)
    let processed += 1
  endfor
  call provider._update_tree(tree)

  let root = a:helper.sync.get_root_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are moved', processed)) })
endfunction

function! s:map_remove(helper) abort
  let provider = a:helper.fern.provider

  let nodes = a:helper.sync.get_selected_nodes()
  let paths = map(copy(nodes), { _, v -> v._path })
  let prompt = printf('The follwoing %d entries will be removed', len(paths))
  for path in paths[:5]
    let prompt .= "\n" . path
  endfor
  if len(paths) > 5
    let prompt .= "\n..."
  endif
  let prompt .= "\nAre you sure to continue (Y[es]/no): "
  if !fern#internal#prompt#confirm(prompt)
    return s:Promise.reject('Cancelled')
  endif

  " Update tree
  let tree = provider._tree
  let ps = []
  for node in nodes
    echo printf('Delete %s', node._path)
    call fern#scheme#dict#tree#remove(tree, node._path)
  endfor
  call provider._update_tree(tree)
  let root = a:helper.sync.get_root_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are removed', len(nodes))) })
endfunction

function! s:map_edit_leaf(helper) abort
  let provider = a:helper.fern.provider

  let node = a:helper.sync.get_cursor_node()
  if node.status isnot# a:helper.STATUS_NONE
    return s:Promise.reject(printf('%s is not leaf', node.name))
  endif

  let value = input('New value: ', node.concealed._value)
  if value is# v:null
    return s:Promise.reject('Cancelled')
  endif

  " Update tree
  call fern#scheme#dict#tree#write(
        \ provider._tree,
        \ node._path,
        \ value,
        \ { 'overwrite': 1 },
        \)
  call provider._update_tree(provider._tree)

  let root = a:helper.sync.get_root_node()
  let previous = a:helper.sync.get_cursor_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
endfunction

let g:fern#scheme#dict#mapping#mappings = get(g:, 'fern#scheme#dict#mapping#mappings', [
      \ 'clipboard',
      \ 'rename',
      \])
./autoload/fern/scheme/dict/provider.vim	[[[1
102
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#dict#provider#new(...) abort
  return {
        \ 'get_root': funcref('s:get_root'),
        \ 'get_parent': funcref('s:get_parent'),
        \ 'get_children': funcref('s:get_children'),
        \ '_tree': a:0 ? a:1 : deepcopy(s:sample_tree),
        \ '_parse_url': { u -> split(matchstr(u, '^dict:\zs.*$'), '/') },
        \ '_update_tree': { -> 0 },
        \ '_extend_node': { n -> n },
        \ '_prompt_leaf': funcref('s:_prompt', ['leaf']),
        \ '_prompt_branch': funcref('s:_prompt', ['branch']),
        \ '_default_leaf': { -> '' },
        \ '_default_branch': { -> {} },
        \}
endfunction

function! s:get_root(url) abort dict
  let terms = self._parse_url(a:url)
  let path = []
  let cursor = self._tree
  let node = s:node(self, path, 'root', cursor, v:null)
  for term in terms
    if !has_key(cursor, term)
      throw printf('no %s exists: %s', term, a:url)
    endif
    call add(path, term)
    let cursor = cursor[term]
    let node = s:node(self, path, term, cursor, node)
  endfor
  return node
endfunction

function! s:get_parent(node, ...) abort
  let parent = a:node.concealed._parent
  let parent = parent is# v:null ? copy(a:node) : parent
  return s:Promise.resolve(parent)
endfunction

function! s:get_children(node, ...) abort dict
  try
    if a:node.status is# 0
      throw printf('%s node is leaf', a:node.name)
    endif
    let ref = a:node.concealed._value
    let base = split(a:node._path, '/')
    let children = map(
          \ keys(ref),
          \ { _, v -> s:node(self, base + [v], v, ref[v], a:node)},
          \)
    return s:Promise.resolve(children)
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction

function! s:node(provider, path, name, value, parent) abort
  let path = '/' . join(a:path, '/')
  let status = type(a:value) is# v:t_dict
  let bufname = status ? printf('dict://%s', path) : v:null
  let label = status
        \ ? a:name
        \ : printf('%s [%s]', a:name, a:value)
  let node = {
        \ 'name': a:name,
        \ 'label': label,
        \ 'status': status,
        \ 'bufname': bufname,
        \ 'concealed': {
        \   '_value': a:value,
        \   '_parent': a:parent,
        \ },
        \ '_path': path,
        \}
  return a:provider._extend_node(node)
endfunction

function! s:_prompt(label, helper) abort
  let path = input(printf('New %s: ', a:label), '')
  if empty(path)
    throw 'Cancelled'
  endif
  return path
endfunction


let s:sample_tree = {
      \ 'shallow': {
      \   'alpha': {},
      \   'beta': {},
      \   'gamma': 'value',
      \ },
      \ 'deep': {
      \   'alpha': {
      \     'beta': {
      \       'gamma': 'value',
      \     },
      \   },
      \ },
      \ 'leaf': 'value',
      \}
./autoload/fern/scheme/dict/tree.vim	[[[1
136
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#dict#tree#read(tree, path, ...) abort
  let terms = split(a:path, '/')
  let optional = s:dig(a:tree, terms, 0)
  if empty(optional) && a:0 is# 0
    throw printf("no node '%s' exists", a:path)
  endif
  return get(optional, 0, a:0 ? a:1 : v:null)
endfunction

function! fern#scheme#dict#tree#write(tree, path, value, ...) abort
  let options = extend({
        \ 'parents': 0,
        \ 'overwrite': 0,
        \}, a:0 ? a:1 : {},
        \)
  let terms = split(a:path, '/')
  let name = terms[-1]
  let terms = terms[:-2]
  let optional = s:dig(a:tree, terms, options.parents)
  let parent = get(optional, 0, v:null)
  if empty(optional)
    throw printf("one of parents of a node '%s' does not exist", a:path)
  elseif type(parent) isnot# v:t_dict
    throw printf("one of parents of a node '%s' is not branch", a:path)
  elseif has_key(parent, name) && !options.overwrite
    throw printf("a node '%s' has already exist", a:path)
  endif
  let parent[name] = a:value
  return parent[name]
endfunction

function! fern#scheme#dict#tree#exists(tree, path) abort
  return !empty(s:dig(a:tree, split(a:path, '/'), 0))
endfunction

function! fern#scheme#dict#tree#remove(tree, path, ...) abort
  let default = a:0 ? a:1 : v:null
  let terms = split(a:path, '/')
  let name = terms[-1]
  let terms = terms[:-2]
  let optional = s:dig(a:tree, terms, 0)
  let parent = get(optional, 0, v:null)
  if empty(optional) || type(parent) isnot# v:t_dict || !has_key(parent, name)
    return default
  endif
  return remove(parent, name)
endfunction

function! fern#scheme#dict#tree#create(tree, path, value) abort
  if fern#scheme#dict#tree#exists(a:tree, a:path)
    let r = s:select_overwrite_method(a:path)
    if empty(r)
      return s:Promise.reject('Cancelled')
    elseif r ==# 'r'
      let new_path = input(
            \ printf('New name: %s -> ', a:path),
            \ a:path,
            \)
      if empty(new_path)
        return s:Promise.reject('Cancelled')
      endif
      return fern#scheme#dict#tree#create(a:tree, new_path, a:value)
    endif
  endif
  call fern#scheme#dict#tree#write(a:tree, a:path, a:value, {
        \ 'parents': 1,
        \ 'overwrite': 1,
        \})
endfunction

function! fern#scheme#dict#tree#copy(tree, src, dst) abort
  let original = fern#scheme#dict#tree#read(a:tree, a:src)
  if fern#scheme#dict#tree#exists(a:tree, a:dst)
    let r = s:select_overwrite_method(a:dst)
    if empty(r)
      return s:Promise.reject('Cancelled')
    elseif r ==# 'r'
      let new_dst = input(
            \ printf('New name: %s -> ', a:src),
            \ a:dst,
            \)
      if empty(new_dst)
        return s:Promise.reject('Cancelled')
      endif
      return fern#scheme#dict#tree#copy(a:tree, a:src, new_dst)
    endif
  endif
  call fern#scheme#dict#tree#write(a:tree, a:dst, deepcopy(original), {
        \ 'parents': 1,
        \ 'overwrite': 1,
        \})
endfunction

function! fern#scheme#dict#tree#move(tree, src, dst) abort
  call fern#scheme#dict#tree#copy(a:tree, a:src, a:dst)
  call fern#scheme#dict#tree#remove(a:tree, a:src)
endfunction

function! fern#scheme#dict#tree#tempname(tree) abort
  let value = 0
  while 1
    let value += 1
    let path = '@temp:' . sha256(value)
    if !fern#scheme#dict#tree#exists(a:tree, path)
      return path
    endif
  endwhile
endfunction

function! s:select_overwrite_method(path) abort
  let prompt = join([
        \ printf(
        \   'Entry "%s" already exists or not writable',
        \   a:path,
        \ ),
        \ 'Please select an overwrite method (esc to cancel)',
        \ 'f[orce]/r[ename]: ',
        \], "\n")
  return fern#internal#prompt#select(prompt, 1, 1, '[fr]')
endfunction

function! s:dig(tree, terms, create) abort
  let cursor = a:tree
  for term in a:terms
    if !has_key(cursor, term)
      if !a:create
        return []
      endif
      let cursor[term] = {}
    endif
    let cursor = cursor[term]
  endfor
  return [cursor]
endfunction
./autoload/fern/scheme/file/complete.vim	[[[1
70
function! fern#scheme#file#complete#url(arglead, cmdline, cursorpos) abort
  let path = '/' . fern#fri#parse(a:arglead).path
  let path = fern#internal#filepath#to_slash(path)
  let suffix = a:arglead =~# '/$' ? '/' : ''
  let rs = getcompletion(fern#internal#filepath#from_slash(path) . suffix, 'dir')
  call map(rs, { -> fern#internal#filepath#to_slash(v:val) })
  call map(rs, { -> s:to_fri(v:val) })
  return rs
endfunction

function! fern#scheme#file#complete#reveal(arglead, cmdline, cursorpos) abort
  let base = '/' . fern#fri#parse(matchstr(a:cmdline, '\<file:///\S*')).path
  let path = matchstr(a:arglead, '^-reveal=\zs.*')
  let suffix = matchstr(path, '/$')
  let rs = s:complete_reveal(path, base, suffix)
  call map(rs, { -> printf('-reveal=%s', v:val) })
  return rs
endfunction

function! fern#scheme#file#complete#filepath(arglead, cmdline, cursorpos) abort
  return map(getcompletion(a:arglead, 'dir'), { -> escape(v:val, ' ') })
endfunction

function! fern#scheme#file#complete#filepath_reveal(arglead, cmdline, cursorpos) abort
  let base = fern#internal#filepath#to_slash(s:get_basepath(a:cmdline))
  let path = matchstr(a:arglead, '^-reveal=\zs.*')
  let suffix = matchstr(path, '[/\\]$')
  let path = path ==# '' ? '' : fern#internal#filepath#to_slash(path)
  let rs = s:complete_reveal(path, base, suffix)
  call map(rs, { -> v:val ==# '' ? '' : fern#internal#filepath#from_slash(v:val) })
  call map(rs, { -> printf('-reveal=%s', escape(v:val, ' ')) })
  return rs
endfunction

function! s:to_fri(path) abort
  return fern#fri#format({
        \ 'scheme': 'file',
        \ 'authority': '',
        \ 'path': a:path[1:],
        \ 'query': {},
        \ 'fragment': '',
        \})
endfunction

function! s:get_basepath(cmdline) abort
  let fargs = fern#internal#args#split(a:cmdline)
  let fargs = fargs[index(fargs, 'Fern') + 1:]
  let fargs = filter(fargs, { -> v:val[:0] !=# '-' })
  let base = len(fargs) ==# 1 ? fargs[0] : ''
  let base = base ==# '' ? '.' : base
  return fnamemodify(base, ':p')
endfunction

function! s:complete_reveal(path, base, suffix) abort
  let [path, base, suffix] = [a:path, a:base, a:suffix]
  if path ==# ''
    let path = a:base
    let suffix = '/'
  elseif path[:0] ==# '/'
    let base = ''
  else
    let path = fern#internal#path#absolute(path, a:base)
  endif
  let rs = getcompletion(fern#internal#filepath#from_slash(path) . suffix, 'file')
  call map(rs, { -> fern#internal#filepath#to_slash(v:val) })
  if base !=# ''
    call map(rs, { -> fern#internal#path#relative(v:val, base) })
  endif
  return rs
endfunction
./autoload/fern/scheme/file/mapping/cd.vim	[[[1
53
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#file#mapping#cd#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-cd:root)  :<C-u>call <SID>call('cd_root', 'cd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-lcd:root) :<C-u>call <SID>call('cd_root', 'lcd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-tcd:root) :<C-u>call <SID>call('cd_root', 'tcd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-cd:cursor)  :<C-u>call <SID>call('cd_cursor', 'cd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-lcd:cursor) :<C-u>call <SID>call('cd_cursor', 'lcd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-tcd:cursor) :<C-u>call <SID>call('cd_cursor', 'tcd')<CR>

  nmap <buffer> <Plug>(fern-action-cd) <Plug>(fern-action-cd:cursor)
  nmap <buffer> <Plug>(fern-action-lcd) <Plug>(fern-action-lcd:cursor)
  nmap <buffer> <Plug>(fern-action-tcd) <Plug>(fern-action-tcd:cursor)
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_cd_root(helper, command) abort
  if a:command ==# 'lcd'
    if fern#internal#window#select()
      return s:Promise.resolve()
    endif
  endif
  return s:cd(a:helper.sync.get_root_node(), a:helper, a:command)
endfunction

function! s:map_cd_cursor(helper, command) abort
  if a:command ==# 'lcd'
    if fern#internal#window#select()
      return s:Promise.resolve()
    endif
  endif
  return s:cd(a:helper.sync.get_cursor_node(), a:helper, a:command)
endfunction

function! s:cd(node, helper, command) abort
  if a:command ==# 'tcd' && !exists(':tcd')
    let winid = win_getid()
    silent execute printf(
          \ 'keepalt keepjumps %d,%dwindo lcd %s',
          \ 1, winnr('$'), fnameescape(a:node._path),
          \)
    call win_gotoid(winid)
  else
    execute a:command fnameescape(a:node._path)
  endif
  return s:Promise.resolve()
endfunction
./autoload/fern/scheme/file/mapping/clipboard.vim	[[[1
102
let s:Promise = vital#fern#import('Async.Promise')

let s:clipboard = {
      \ 'mode': 'copy',
      \ 'candidates': [],
      \}

function! fern#scheme#file#mapping#clipboard#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-copy)  :<C-u>call <SID>call('clipboard_copy')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-move)  :<C-u>call <SID>call('clipboard_move')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-paste) :<C-u>call <SID>call('clipboard_paste')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-clipboard-clear) :<C-u>call <SID>call('clipboard_clear')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> C <Plug>(fern-action-clipboard-copy)
    nmap <buffer><nowait> M <Plug>(fern-action-clipboard-move)
    nmap <buffer><nowait> P <Plug>(fern-action-clipboard-paste)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_clipboard_move(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let s:clipboard = {
        \ 'mode': 'move',
        \ 'candidates': copy(nodes),
        \}
  return s:Promise.resolve()
        \.then({ -> a:helper.async.update_marks([]) })
        \.then({ -> a:helper.async.remark() })
        \.then({ -> a:helper.sync.echo(printf('%d items are saved in clipboard to move', len(nodes))) })
endfunction

function! s:map_clipboard_copy(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let s:clipboard = {
        \ 'mode': 'copy',
        \ 'candidates': copy(nodes),
        \}
  return s:Promise.resolve()
        \.then({ -> a:helper.async.update_marks([]) })
        \.then({ -> a:helper.async.remark() })
        \.then({ -> a:helper.sync.echo(printf('%d items are saved in clipboard to copy', len(nodes))) })
endfunction

function! s:map_clipboard_paste(helper) abort
  if empty(s:clipboard)
    return s:Promise.reject('Nothing to paste')
  endif

  if s:clipboard.mode ==# 'move'
    let paths = map(copy(s:clipboard.candidates), { -> v:val._path })
    let prompt = printf('The following %d nodes will be moved', len(paths))
    for path in paths[:5]
      let prompt .= "\n" . path
    endfor
    if len(paths) > 5
      let prompt .= "\n..."
    endif
    let prompt .= "\nAre you sure to continue (y[es]/n[o]): "
    if !fern#internal#prompt#confirm(prompt)
      return s:Promise.reject('Cancelled')
    endif
  endif

  let node = a:helper.sync.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node
  let base = fern#internal#filepath#to_slash(node._path)
  let token = a:helper.fern.source.token
  let ps = []
  for src in s:clipboard.candidates
    let name = fern#internal#filepath#to_slash(src._path)
    let name = fern#internal#path#basename(name)
    let dst = fern#internal#filepath#from_slash(join([base, name], '/'))
    if s:clipboard.mode ==# 'move'
      echo printf('Move %s -> %s', src._path, dst)
      call add(ps, fern#scheme#file#shutil#move(src._path, dst, token))
    else
      echo printf('Copy %s -> %s', src._path, dst)
      call add(ps, fern#scheme#file#shutil#copy(src._path, dst, token))
    endif
  endfor
  let root = a:helper.sync.get_root_node()
  return s:Promise.all(ps)
        \.then({ -> a:helper.async.collapse_modified_nodes(s:clipboard.candidates) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are proceeded', len(ps))) })
endfunction

function! s:map_clipboard_clear(helper) abort
  let s:clipboard = {
        \ 'mode': 'copy',
        \ 'candidates': [],
        \}
endfunction
./autoload/fern/scheme/file/mapping/ex.vim	[[[1
38
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#file#mapping#ex#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-ex)  :<C-u>call <SID>call('ex')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-ex=) :<C-u>call <SID>call_without_guard('ex')<CR>
endfunction

function! s:call(name, ...) abort
  return call(
       \ 'fern#mapping#call',
       \ [funcref(printf('s:map_%s', a:name))] + a:000,
       \)
endfunction

function! s:call_without_guard(name, ...) abort
  return call(
       \ 'fern#mapping#call_without_guard',
       \ [funcref(printf('s:map_%s', a:name))] + a:000,
       \)
endfunction

function! s:map_ex(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let nodes = filter(copy(nodes), { -> v:val._path isnot# v:null })
  if empty(nodes)
    return
  endif
  call feedkeys("\<Home>", 'in')
  let expr = join(map(copy(nodes), { _, v -> fnameescape(fnamemodify(v._path, ':~:.')) }), ' ')
  let expr = input(':', ' ' . expr, 'command')
  if empty(expr)
    return
  endif
  if a:helper.sync.is_drawer()
    call fern#internal#locator#focus(winnr('#'))
  endif
  execute expr
endfunction
./autoload/fern/scheme/file/mapping/grep.vim	[[[1
61
let s:Config = vital#fern#import('Config')
let s:Promise = vital#fern#import('Async.Promise')
let s:Process = vital#fern#import('Async.Promise.Process')

function! fern#scheme#file#mapping#grep#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-grep)  :<C-u>call <SID>call('grep')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-grep=) :<C-u>call <SID>call_without_guard('grep')<CR>
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:call_without_guard(name, ...) abort
  return call(
        \ 'fern#mapping#call_without_guard',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_grep(helper) abort
  let pattern = input('Grep: ', '')
  if empty(pattern)
    return s:Promise.reject('Cancelled')
  endif
  let node = a:helper.sync.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node
  let args = s:grepargs([pattern, fern#internal#filepath#from_slash(node._path)])
  let efm = g:fern#scheme#file#mapping#grep#grepformat
  let title = printf('[fern] %s', join(map(copy(args), { _, v -> v =~# '\s' ? printf('"%s"', v) : v }), ' '))
  let token = a:helper.fern.source.token
  return s:Process.start(args, { 'token': token })
        \.then({ v -> v.stdout })
        \.then({ v -> setqflist([], 'a', { 'efm': efm, 'lines': v, 'title': title }) })
        \.then({ -> execute('copen') })
endfunction

function! s:grepargs(args) abort
  let args = fern#internal#args#split(g:fern#scheme#file#mapping#grep#grepprg)
  let args = map(args, { _, v -> v =~# '^[%#]\%(:.*\)\?$' ? fern#util#expand(v) : v })
  let index = index(args, '$*')
  return index is# -1
        \ ? args + a:args
        \ : args[:index - 1] + a:args + args[index + 1:]
endfunction

function! s:default_grepprg() abort
  if &grepprg =~# '^\%(grep -n \|grep -n $\* /dev/null\|internal\)$'
    return has('unix') ? 'grep -rn $* /dev/null' : 'gren -rn'
  endif
  return &grepprg
endfunction


call s:Config.config(expand('<sfile>:p'), {
      \ 'grepprg': s:default_grepprg(),
      \ 'grepformat': &grepformat,
      \})
./autoload/fern/scheme/file/mapping/rename.vim	[[[1
69
let s:Lambda = vital#fern#import('Lambda')
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#file#mapping#rename#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-rename:select)   :<C-u>call <SID>call('rename', 'select')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:split)    :<C-u>call <SID>call('rename', 'split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:vsplit)   :<C-u>call <SID>call('rename', 'vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:tabedit)  :<C-u>call <SID>call('rename', 'tabedit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:above)    :<C-u>call <SID>call('rename', 'leftabove split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:left)     :<C-u>call <SID>call('rename', 'leftabove vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:below)    :<C-u>call <SID>call('rename', 'rightbelow split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:right)    :<C-u>call <SID>call('rename', 'rightbelow vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:top)      :<C-u>call <SID>call('rename', 'topleft split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:leftest)  :<C-u>call <SID>call('rename', 'topleft vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:bottom)   :<C-u>call <SID>call('rename', 'botright split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:rightest) :<C-u>call <SID>call('rename', 'botright vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-error)   :<C-u>call <SID>call('rename', 'edit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-split)   :<C-u>call <SID>call('rename', 'edit/split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-vsplit)  :<C-u>call <SID>call('rename', 'edit/vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-rename:edit-or-tabedit) :<C-u>call <SID>call('rename', 'edit/tabedit')<CR>

  " Alias map
  nmap <buffer><silent> <Plug>(fern-action-rename:edit) <Plug>(fern-action-rename:edit-or-error)
  nmap <buffer><silent> <Plug>(fern-action-rename) <Plug>(fern-action-rename:split)

  if !a:disable_default_mappings
    nmap <buffer><nowait> R <Plug>(fern-action-rename)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_rename(helper, opener) abort
  let root = a:helper.sync.get_root_node()
  let nodes = a:helper.sync.get_selected_nodes()
  let l:Factory = { -> map(copy(nodes), { -> v:val._path }) }
  let options = {
        \ 'opener': a:opener,
        \ 'cursor': [1, len(root._path) + 1],
        \ 'is_drawer': a:helper.sync.is_drawer(),
        \ 'modifiers':[
        \   { r -> fern#internal#rename_solver#solve(r) },
        \ ],
        \}
  let ns = {}
  return fern#internal#replacer#start(Factory, options)
        \.then({ r -> s:_map_rename(a:helper, r) })
        \.then({ n -> s:Lambda.let(ns, 'n', n) })
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are renamed', ns.n)) })
endfunction

function! s:_map_rename(helper, result) abort
  let token = a:helper.fern.source.token
  let fs = []
  for [src, dst] in a:result
    call add(fs, function('fern#scheme#file#shutil#move', [src, dst, token]))
  endfor
  return s:Promise.chain(fs)
        \.then({ -> fern#internal#buffer#renames(a:result) })
        \.then({ -> len(fs) })
endfunction
./autoload/fern/scheme/file/mapping/system.vim	[[[1
24
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#file#mapping#system#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-open:system) :<C-u>call <SID>call('open_system')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> x <Plug>(fern-action-open:system)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_open_system(helper) abort
  let node = a:helper.sync.get_cursor_node()
  let l:Done = a:helper.sync.process_node(node)
  return fern#scheme#file#shutil#open(node._path, a:helper.fern.source.token)
        \.then({ -> a:helper.sync.echo(printf('%s has opened', node._path)) })
        \.finally({ -> Done() })
endfunction
./autoload/fern/scheme/file/mapping/terminal.vim	[[[1
77
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#file#mapping#terminal#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:select)   :<C-u>call <SID>call('terminal', 'select')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:split)    :<C-u>call <SID>call('terminal', 'split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:vsplit)   :<C-u>call <SID>call('terminal', 'vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:tabedit)  :<C-u>call <SID>call('terminal', 'tabedit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:above)    :<C-u>call <SID>call('terminal', 'leftabove split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:left)     :<C-u>call <SID>call('terminal', 'leftabove vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:below)    :<C-u>call <SID>call('terminal', 'rightbelow split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:right)    :<C-u>call <SID>call('terminal', 'rightbelow vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:top)      :<C-u>call <SID>call('terminal', 'topleft split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:leftest)  :<C-u>call <SID>call('terminal', 'topleft vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:bottom)   :<C-u>call <SID>call('terminal', 'botright split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:rightest) :<C-u>call <SID>call('terminal', 'botright vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:edit-or-error)   :<C-u>call <SID>call('terminal', 'edit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:edit-or-split)   :<C-u>call <SID>call('terminal', 'edit/split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:edit-or-vsplit)  :<C-u>call <SID>call('terminal', 'edit/vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-terminal:edit-or-tabedit) :<C-u>call <SID>call('terminal', 'edit/tabedit')<CR>

  " Smart map
  nmap <buffer><silent><expr>
        \ <Plug>(fern-action-terminal:side)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-action-terminal:left)",
        \   "\<Plug>(fern-action-terminal:right)",
        \ )

  " Alias map
  nmap <buffer><silent> <Plug>(fern-action-terminal:edit) <Plug>(fern-action-terminal:edit-or-error)
  nmap <buffer><silent> <Plug>(fern-action-terminal) <Plug>(fern-action-terminal:edit)
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_terminal(helper, opener) abort
  let STATUS_NONE = a:helper.STATUS_NONE
  let nodes = a:helper.sync.get_selected_nodes()
  let nodes = map(copy(nodes), { _, n -> n.status is# STATUS_NONE ? n.__owner : n })
  let winid = win_getid()
  try
    for node in nodes
      call win_gotoid(winid)
      try
        call fern#internal#buffer#open('', {
              \ 'opener': a:opener,
              \ 'locator': a:helper.sync.is_drawer(),
              \})
      catch /^Vim\%((\a\+)\)\=:E32:/
      endtry
      enew | call s:term(node._path)
    endfor
    return a:helper.async.update_marks([])
        \.then({ -> a:helper.async.remark() })
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction

if exists('*termopen')
  function! s:term(cwd) abort
    call termopen(&shell, { 'cwd': a:cwd })
  endfunction
elseif exists('*term_start')
  function! s:term(cwd) abort
    call term_start(&shell, { 'cwd': a:cwd, 'curwin': 1 })
  endfunction
else
  function! s:term(cwd) abort
    throw 'neither termopen nor term_start exist'
  endfunction
endif
./autoload/fern/scheme/file/mapping/yank.vim	[[[1
19
function! fern#scheme#file#mapping#yank#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-yank:path) :<C-u>call <SID>call('yank_path')<CR>

  nmap <buffer> <Plug>(fern-action-yank) <Plug>(fern-action-yank:path)
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_yank_path(helper) abort
  let node = a:helper.sync.get_cursor_node()
  let value = node._path
  call setreg(v:register, value)
  redraw | echo "The node 'path' has yanked."
endfunction
./autoload/fern/scheme/file/mapping.vim	[[[1
261
let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#file#mapping#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-new-path)  :<C-u>call <SID>call('new_path')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-new-file)  :<C-u>call <SID>call('new_file')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-new-dir)   :<C-u>call <SID>call('new_dir')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-new-path=) :<C-u>call <SID>call_without_guard('new_path')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-new-file=) :<C-u>call <SID>call_without_guard('new_file')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-new-dir=)  :<C-u>call <SID>call_without_guard('new_dir')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-copy)      :<C-u>call <SID>call('copy')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-move)      :<C-u>call <SID>call('move')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-trash)     :<C-u>call <SID>call('trash')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-trash=)    :<C-u>call <SID>call_without_guard('trash')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-remove)    :<C-u>call <SID>call('remove')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-remove=)   :<C-u>call <SID>call_without_guard('remove')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> N <Plug>(fern-action-new-file)
    nmap <buffer><nowait> K <Plug>(fern-action-new-dir)
    nmap <buffer><nowait> c <Plug>(fern-action-copy)
    nmap <buffer><nowait> m <Plug>(fern-action-move)
    nmap <buffer><nowait> D <Plug>(fern-action-trash)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:call_without_guard(name, ...) abort
  return call(
        \ 'fern#mapping#call_without_guard',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_cd(helper, command) abort
  let path = a:helper.sync.get_cursor_node()._path
  if a:command ==# 'tcd' && !exists(':tcd')
    let winid = win_getid()
    silent execute printf(
          \ 'keepalt keepjumps %d,%dwindo lcd %s',
          \ 1, winnr('$'), fnameescape(path),
          \)
    call win_gotoid(winid)
  else
    execute a:command fnameescape(path)
  endif
  return s:Promise.resolve()
endfunction

function! s:map_open_system(helper) abort
  let node = a:helper.sync.get_cursor_node()
  let l:Done = a:helper.sync.process_node(node)
  return fern#scheme#file#shutil#open(node._path, a:helper.fern.source.token)
        \.then({ -> a:helper.sync.echo(printf('%s has opened', node._path)) })
        \.finally({ -> Done() })
endfunction

function! s:map_new_path(helper) abort
  let name = input(
        \ "(Hint: Ends with '/' create a directory instead of a file)\nNew path: ",
        \ '',
        \ 'file',
        \)
  if empty(name)
    return s:Promise.reject('Cancelled')
  endif
  return name[-1:] ==# '/'
        \ ? s:new_dir(a:helper, name)
        \ : s:new_file(a:helper, name)
endfunction

function! s:map_new_file(helper) abort
  let name = input('New file: ', '', 'file')
  if empty(name)
    return s:Promise.reject('Cancelled')
  endif
  return s:new_file(a:helper, name)
endfunction

function! s:map_new_dir(helper) abort
  let name = input('New directory: ', '', 'dir')
  if empty(name)
    return s:Promise.reject('Cancelled')
  endif
  return s:new_dir(a:helper, name)
endfunction

function! s:map_copy(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let token = a:helper.fern.source.token
  let ps = []
  for node in nodes
    let src = node._path
    let dst = input(
          \ printf('Copy: %s -> ', src),
          \ src,
          \ isdirectory(src) ? 'dir' : 'file',
          \)
    if empty(dst) || src ==# dst
      continue
    endif
    call add(ps, fern#scheme#file#shutil#copy(src, dst, token))
  endfor
  let root = a:helper.sync.get_root_node()
  return s:Promise.all(ps)
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are copied', len(ps))) })
endfunction

function! s:map_move(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let token = a:helper.fern.source.token
  let ps = []
  let bufutil_pairs = []
  for node in nodes
    let src = node._path
    let dst = input(
          \ printf('Move: %s -> ', src),
          \ src,
          \ isdirectory(src) ? 'dir' : 'file',
          \)
    if empty(dst) || src ==# dst
      continue
    endif
    call add(ps, fern#scheme#file#shutil#move(src, dst, token))
    call add(bufutil_pairs, [src, dst])
  endfor
  let root = a:helper.sync.get_root_node()
  return s:Promise.all(ps)
        \.then({ -> s:auto_buffer_rename(bufutil_pairs) })
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are moved', len(ps))) })
endfunction

function! s:map_trash(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let paths = map(copy(nodes), { _, v -> v._path })
  let prompt = printf('The following %d files will be trashed', len(paths))
  for path in paths[:5]
    let prompt .= "\n" . path
  endfor
  if len(paths) > 5
    let prompt .= "\n..."
  endif
  let prompt .= "\nAre you sure to continue (Y[es]/no): "
  if !fern#internal#prompt#confirm(prompt)
    return s:Promise.reject('Cancelled')
  endif
  let token = a:helper.fern.source.token
  let ps = []
  let bufutil_paths = []
  for node in nodes
    let path = node._path
    echo printf('Trash %s', path)
    call add(ps, fern#scheme#file#shutil#trash(path, token))
    call add(bufutil_paths, path)
  endfor
  let root = a:helper.sync.get_root_node()
  return s:Promise.all(ps)
        \.then({ -> s:auto_buffer_delete(bufutil_paths) })
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are trashed', len(ps))) })
endfunction

function! s:map_remove(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  let paths = map(copy(nodes), { _, v -> v._path })
  let prompt = printf('The following %d files will be removed', len(paths))
  for path in paths[:5]
    let prompt .= "\n" . path
  endfor
  if len(paths) > 5
    let prompt .= "\n..."
  endif
  let prompt .= "\nAre you sure to continue (Y[es]/no): "
  if !fern#internal#prompt#confirm(prompt)
    return s:Promise.reject('Cancelled')
  endif
  let token = a:helper.fern.source.token
  let ps = []
  let bufutil_paths = []
  for node in nodes
    let path = node._path
    echo printf('Remove %s', path)
    call add(ps, fern#scheme#file#shutil#remove(path, token))
    call add(bufutil_paths, path)
  endfor
  let root = a:helper.sync.get_root_node()
  return s:Promise.all(ps)
        \.then({ -> s:auto_buffer_delete(bufutil_paths) })
        \.then({ -> a:helper.async.collapse_modified_nodes(nodes) })
        \.then({ -> a:helper.async.reload_node(root.__key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d items are removed', len(ps))) })
endfunction

function! s:new_file(helper, name) abort
  let node = a:helper.sync.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node
  let path = fern#internal#filepath#to_slash(node._path)
  let path = join([path, a:name], '/')
  let path = fern#internal#filepath#from_slash(path)
  let key = node.__key + [a:name]
  let token = a:helper.fern.source.token
  let previous = a:helper.sync.get_cursor_node()
  return fern#scheme#file#shutil#mkfile(path, token)
        \.then({ -> a:helper.async.reload_node(node.__key) })
        \.then({ -> a:helper.async.reveal_node(key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(key, { 'previous': previous }) })
endfunction

function! s:new_dir(helper, name) abort
  let node = a:helper.sync.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node
  let path = fern#internal#filepath#to_slash(node._path)
  let path = join([path, a:name], '/')
  let path = fern#internal#filepath#from_slash(path)
  let key = node.__key + [a:name]
  let token = a:helper.fern.source.token
  let previous = a:helper.sync.get_cursor_node()
  return fern#scheme#file#shutil#mkdir(path, token)
        \.then({ -> a:helper.async.reload_node(node.__key) })
        \.then({ -> a:helper.async.reveal_node(key) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.focus_node(key, { 'previous': previous }) })
endfunction

function! s:auto_buffer_rename(bufutil_pairs) abort
  if !g:fern#disable_auto_buffer_rename
    call fern#internal#buffer#renames(a:bufutil_pairs)
  endif
endfunction

function! s:auto_buffer_delete(bufutil_paths) abort
  if !g:fern#disable_auto_buffer_delete
    call fern#internal#buffer#removes(a:bufutil_paths)
  endif
endfunction

let g:fern#scheme#file#mapping#mappings = get(g:, 'fern#scheme#file#mapping#mappings', [
      \ 'cd',
      \ 'clipboard',
      \ 'ex',
      \ 'grep',
      \ 'rename',
      \ 'system',
      \ 'terminal',
      \ 'yank',
      \])
./autoload/fern/scheme/file/provider.vim	[[[1
139
let s:Config = vital#fern#import('Config')
let s:Lambda = vital#fern#import('Lambda')
let s:AsyncLambda = vital#fern#import('Async.Lambda')
let s:Promise = vital#fern#import('Async.Promise')
let s:Process = vital#fern#import('Async.Promise.Process')
let s:CancellationToken = vital#fern#import('Async.CancellationToken')
let s:is_windows = has('win32')
let s:windows_drive_nodes = s:Promise.resolve([])
let s:windows_drive_root = {
      \ 'name': '',
      \ 'label': 'Drives',
      \ 'status': 1,
      \ 'hidden': 0,
      \ 'bufname': 'fern:///file:///',
      \ '_path': '',
      \}

function! fern#scheme#file#provider#new() abort
  return {
        \ 'get_root': funcref('s:provider_get_root'),
        \ 'get_parent' : funcref('s:provider_get_parent'),
        \ 'get_children' : funcref('s:provider_get_children'),
        \}
endfunction

function! s:provider_get_root(uri) abort
  call fern#logger#debug('file:get_root:uri', a:uri)
  let fri = fern#fri#parse(a:uri)
  call fern#logger#debug('file:get_root:fri', fri)
  let path = fern#fri#to#filepath(fri)
  if s:is_windows && path ==# ''
    return s:windows_drive_root
  endif
  let root = s:node(path)
  if g:fern#scheme#file#show_absolute_path_on_root_label
    let root.label = fnamemodify(root._path, ':~')
  endif
  return root
endfunction

function! s:provider_get_parent(node, ...) abort
  if fern#internal#filepath#is_root(a:node._path)
    return s:Promise.reject('no parent node exists for the root')
  elseif s:is_windows && fern#internal#filepath#is_drive_root(a:node._path)
    return s:Promise.resolve(s:windows_drive_root)
  endif
  try
    let path = fern#internal#filepath#to_slash(a:node._path)
    let parent = fern#internal#path#dirname(path)
    let parent = fern#internal#filepath#from_slash(parent)
    return s:Promise.resolve(s:node(parent))
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction

function! s:provider_get_children(node, ...) abort
  if s:is_windows && a:node._path ==# ''
    return s:windows_drive_nodes
  endif
  let token = a:0 ? a:1 : s:CancellationToken.none
  if a:node.status is# 0
    return s:Promise.reject('no children exists for %s', a:node._path)
  endif
  let l:Profile = fern#profile#start('fern#scheme#file#provider:provider_get_children')
  return s:children(s:resolve(a:node._path), token)
        \.then(s:AsyncLambda.map_f({ v -> s:safe(funcref('s:node', [v])) }))
        \.then(s:AsyncLambda.filter_f({ v -> !empty(v) }))
        \.finally({ -> Profile() })
endfunction

function! s:node(path) abort
  if empty(getftype(a:path))
    throw printf('no such file or directory exists: %s', a:path)
  endif
  let status = isdirectory(a:path)
  let name = fern#internal#path#basename(fern#internal#filepath#to_slash(a:path))
  let bufname = status
        \ ? fern#fri#format(fern#fri#new({
        \     'scheme': 'fern',
        \     'path': fern#fri#format(fern#fri#from#filepath(a:path)),
        \   }))
        \ : a:path
  return {
        \ 'name': name,
        \ 'status': status,
        \ 'hidden': name[:0] ==# '.',
        \ 'bufname': bufname,
        \ '_path': a:path,
        \}
endfunction

function! s:safe(fn) abort
  try
    return a:fn()
  catch
    return v:null
  endtry
endfunction

function! s:children(path, token) abort
  return call(
        \ printf('fern#scheme#file#util#list_entries_%s', g:fern#scheme#file#provider#impl),
        \ [a:path, a:token],
        \)
endfunction

if has('patch-8.2.1804')
  let s:resolve = function('resolve')
else
  function! s:resolve(path) abort
    if a:path ==# '/'
      return a:path
    endif
    return resolve(a:path)
  endfunction
endif

if s:is_windows
  let s:windows_drive_nodes = fern#scheme#file#util#list_drives(s:CancellationToken.none)
          \.then(s:AsyncLambda.map_f({ v -> s:safe(funcref('s:node', [v])) }))
          \.then(s:AsyncLambda.filter_f({ v -> !empty(v) }))
endif

" NOTE:
" It is required while exists() does not invoke autoload
runtime autoload/fern/scheme/file/util.vim

" NOTE:
" Performance 'find' > 'ls' >> 'reddir' > 'glob'
call s:Config.config(expand('<sfile>:p'), {
      \ 'impl': exists('*fern#scheme#file#util#list_entries_find')
      \   ? 'find'
      \   : exists('*fern#scheme#file#util#list_entries_ls')
      \     ? 'ls'
      \     : exists('*fern#scheme#file#util#list_entries_readdir')
      \     ? 'readdir'
      \     : 'glob',
      \})
./autoload/fern/scheme/file/shutil.vim	[[[1
111
let s:File = vital#fern#import('Async.File')
let s:Promise = vital#fern#import('Async.Promise')
let s:CancellationToken = vital#fern#import('Async.CancellationToken')

function! fern#scheme#file#shutil#open(path, ...) abort
  let token = a:0 ? a:1 : s:CancellationToken.none
  return s:File.open(a:path, {
        \ 'token': token,
        \})
endfunction

function! fern#scheme#file#shutil#mkfile(path, ...) abort
  if filereadable(a:path) || isdirectory(a:path)
    return s:Promise.reject(printf("'%s' already exist", a:path))
  endif
  return s:Promise.resolve()
        \.then({ -> mkdir(fnamemodify(a:path, ':p:h'), 'p') })
        \.then({ -> writefile([], a:path) })
endfunction

function! fern#scheme#file#shutil#mkdir(path, ...) abort
  if filereadable(a:path) || isdirectory(a:path)
    return s:Promise.reject(printf("'%s' already exist", a:path))
  endif
  return s:Promise.resolve()
        \.then({ -> mkdir(a:path, 'p') })
endfunction

function! fern#scheme#file#shutil#copy(src, dst, ...) abort
  let token = a:0 ? a:1 : s:CancellationToken.none
  if filereadable(a:dst) || isdirectory(a:dst)
    let r = s:select_overwrite_method(a:dst)
    if empty(r)
      return s:Promise.reject('Cancelled')
    elseif r ==# 'r'
      let new_dst = input(
            \ printf('New name: %s -> ', a:src),
            \ a:dst,
            \ filereadable(a:src) ? 'file' : 'dir',
            \)
      if empty(new_dst)
        return s:Promise.reject('Cancelled')
      endif
      return fern#scheme#file#shutil#copy(a:src, new_dst, token)
    endif
  endif
  call mkdir(fnamemodify(a:dst, ':p:h'), 'p')
  if isdirectory(a:src)
    return s:File.copy_dir(a:src, a:dst, {
          \ 'token': token,
          \})
  else
    return s:File.copy(a:src, a:dst, {
          \ 'token': token,
          \})
  endif
endfunction

function! fern#scheme#file#shutil#move(src, dst, ...) abort
  let token = a:0 ? a:1 : s:CancellationToken.none
  if filereadable(a:dst) || isdirectory(a:dst)
    let r = s:select_overwrite_method(a:dst)
    if empty(r)
      return s:Promise.reject('Cancelled')
    elseif r ==# 'r'
      let new_dst = input(
            \ printf('New name: %s -> ', a:src),
            \ a:dst,
            \ filereadable(a:src) ? 'file' : 'dir',
            \)
      if empty(new_dst)
        return s:Promise.reject('Cancelled')
      endif
      return fern#scheme#file#shutil#move(a:src, new_dst, token)
    endif
  endif
  call mkdir(fnamemodify(a:dst, ':p:h'), 'p')
  return s:File.move(a:src, a:dst, {
        \ 'token': token,
        \})
endfunction

function! fern#scheme#file#shutil#trash(path, ...) abort
  let token = a:0 ? a:1 : s:CancellationToken.none
  try
    return s:File.trash(a:path, {
          \ 'token': token,
          \})
  catch /vital: Async\.File:/
    return s:Promise.reject('Dependencies not found. See :help fern-action-trash for detail.')
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction

function! fern#scheme#file#shutil#remove(path, ...) abort
  return s:Promise.resolve()
        \.then({ -> delete(a:path, 'rf') })
endfunction

function! s:select_overwrite_method(path) abort
  let prompt = join([
        \ printf(
        \   '"%s" exists or not writable',
        \   a:path,
        \ ),
        \ 'Please select an overwrite method (esc to cancel)',
        \ 'f[orce]/r[ename]: ',
        \], "\n")
  return fern#internal#prompt#select(prompt, 1, 1, '[fr]')
endfunction
./autoload/fern/scheme/file/util.vim	[[[1
68
let s:Promise = vital#fern#import('Async.Promise')
let s:Process = vital#fern#import('Async.Promise.Process')
let s:AsyncLambda = vital#fern#import('Async.Lambda')
let s:is_windows = has('win32')

if !s:is_windows && executable('ls')
  " NOTE:
  " The -U option means different between Linux and FreeBSD.
  " Linux   - do not sort; list entries in directory order
  " FreeBSD - Use time when file was created for sorting or printing.
  " But it improve performance in Linux and just noise in FreeBSD so
  " the option is applied.
  function! fern#scheme#file#util#list_entries_ls(path, token) abort
    let l:Profile = fern#profile#start('fern#scheme#file#util#list_entries_ls')
    return s:Process.start(['ls', '-1AU', a:path], { 'token': a:token, 'reject_on_failure': 1 })
          \.catch({ v -> s:Promise.reject(join(v.stderr, "\n")) })
          \.then({ v -> v.stdout })
          \.then(s:AsyncLambda.filter_f({ v -> !empty(v) }))
          \.then(s:AsyncLambda.map_f({ v -> a:path . '/' . v }))
          \.finally({ -> Profile() })
  endfunction
endif

if !s:is_windows && executable('find')
  function! fern#scheme#file#util#list_entries_find(path, token) abort
    let l:Profile = fern#profile#start('fern#scheme#file#util#list_entries_find')
    return s:Process.start(['find', '-H', a:path, '-maxdepth', '1'], { 'token': a:token, 'reject_on_failure': 1 })
          \.catch({ v -> s:Promise.reject(join(v.stderr, "\n")) })
          \.then({ v -> v.stdout })
          \.then(s:AsyncLambda.filter_f({ v -> !empty(v) && v !=# a:path }))
          \.finally({ -> Profile() })
  endfunction
endif

if exists('*readdir')
  function! fern#scheme#file#util#list_entries_readdir(path, ...) abort
    let l:Profile = fern#profile#start('fern#scheme#file#util#list_entries_readdir')
    let s = s:is_windows ? '\' : '/'
    let p = a:path[-1:] ==# s ? a:path : (a:path . s)
    return s:Promise.resolve(readdir(a:path))
          \.then(s:AsyncLambda.map_f({ v -> p . v }))
          \.finally({ -> Profile() })
  endfunction
endif

function! fern#scheme#file#util#list_entries_glob(path, ...) abort
  let l:Profile = fern#profile#start('fern#scheme#file#util#list_entries_glob')
  let s = s:is_windows ? '\' : '/'
  let p = a:path[-1:] ==# s ? a:path : (a:path . s)
  let a = s:Promise.resolve(glob(p . '*', 1, 1, 1))
  let b = s:Promise.resolve(glob(p . '.*', 1, 1, 1))
        \.then(s:AsyncLambda.filter_f({ v -> v[-2:] !=# s . '.' && v[-3:] !=# s . '..' }))
  return s:Promise.all([a, b])
        \.then(s:AsyncLambda.reduce_f({ a, v -> a + v }, []))
        \.finally({ -> Profile() })
endfunction

if s:is_windows
  function! fern#scheme#file#util#list_drives(token) abort
    let l:Profile = fern#profile#start('fern#scheme#file#util#list_drives')
    return s:Process.start(['wmic', 'logicaldisk', 'get', 'name'], { 'token': a:token, 'reject_on_failure': 1 })
          \.catch({ v -> s:Promise.reject(join(v.stderr, "\n")) })
          \.then({ v -> v.stdout })
          \.then(s:AsyncLambda.filter_f({ v -> v =~# '^\w:' }))
          \.then(s:AsyncLambda.map_f({ v -> v:val[:1] . '\' }))
          \.finally({ -> Profile() })
  endfunction
endif
./autoload/fern/scheme/file.vim	[[[1
5
let s:Config = vital#fern#import('Config')

call s:Config.config(expand('<sfile>:p'), {
      \ 'show_absolute_path_on_root_label': 0,
      \})
./autoload/fern/smart.vim	[[[1
38
function! fern#smart#leaf(leaf, branch, ...) abort
  let helper = fern#helper#new()
  let node = helper.sync.get_cursor_node()
  if node is# v:null
    return "\<Nop>"
  endif
  if node.status is# helper.STATUS_NONE
    return a:leaf
  elseif node.status is# helper.STATUS_COLLAPSED
    return a:branch
  else
    return get(a:000, 0, a:branch)
  endif
endfunction

function! fern#smart#drawer(drawer, viewer, ...) abort
  let helper = fern#helper#new()
  if a:0 is# 0
    return helper.sync.is_drawer()
          \ ? a:drawer
          \ : a:viewer
  else
    return helper.sync.is_drawer()
          \ ? helper.sync.is_right_drawer()
          \   ? a:viewer
          \   : a:drawer
          \ : a:1
  endif
endfunction

function! fern#smart#scheme(default, schemes) abort
  let helper = fern#helper#new()
  let scheme = helper.sync.get_scheme()
  if has_key(a:schemes, scheme)
    return a:schemes[scheme]
  endif
  return a:default
endfunction
./autoload/fern/util.vim	[[[1
59
let s:Promise = vital#fern#import('Async.Promise')

function! fern#util#compare(i1, i2) abort
  return a:i1 == a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
endfunction

function! fern#util#sleep(ms) abort
  return s:Promise.new({ resolve -> timer_start(a:ms, { -> resolve() }) })
endfunction

function! fern#util#deprecated(name, ...) abort
  if a:0
    call fern#logger#warn(printf(
          \ '%s has deprecated. Use %s instead.',
          \ a:name,
          \ a:1,
          \))
  else
    call fern#logger#warn(printf(
          \ '%s has deprecated. See :help %s.',
          \ a:name,
          \ a:name,
          \))
  endif
endfunction

function! fern#util#obsolete(name, ...) abort
  if a:0
    throw printf(
          \ '%s has obsolete. Use %s instead.',
          \ a:name,
          \ a:1,
          \)
  else
    throw printf(
          \ '%s has obsolete. See :help %s.',
          \ a:name,
          \ a:name,
          \)
  endif
endfunction

" Apply workaround to expand() issue of completeslash on Windows
" See https://github.com/lambdalisue/fern.vim/issues/226
if exists('+completeslash')
  function! fern#util#expand(expr) abort
    let completeslash_saved = &completeslash
    try
      set completeslash&
      return expand(a:expr)
    finally
      let &completeslash = completeslash_saved
    endtry
  endfunction
else
  function! fern#util#expand(expr) abort
    return expand(a:expr)
  endfunction
endif
./autoload/fern.vim	[[[1
58
let s:root = expand('<sfile>:p:h')
let s:Config = vital#fern#import('Config')

" Define Public constant
const g:fern#STATUS_NONE = 0
const g:fern#STATUS_COLLAPSED = 1
const g:fern#STATUS_EXPANDED = 2

const g:fern#DEBUG = 0
const g:fern#INFO = 1
const g:fern#WARN = 2
const g:fern#ERROR = 3

" Define Public variables
call s:Config.config(expand('<sfile>:p'), {
      \ 'profile': 0,
      \ 'logfile': v:null,
      \ 'loglevel': g:fern#INFO,
      \ 'opener': 'edit',
      \ 'hide_cursor': 0,
      \ 'keepalt_on_edit': 0,
      \ 'keepjumps_on_edit': 0,
      \ 'disable_auto_buffer_delete': 0,
      \ 'disable_auto_buffer_rename': 0,
      \ 'disable_default_mappings': 0,
      \ 'disable_viewer_spinner': has('win32') && !has('gui_running'),
      \ 'disable_viewer_auto_duplication': 0,
      \ 'disable_drawer_auto_winfixwidth': 0,
      \ 'disable_drawer_auto_resize': 0,
      \ 'disable_drawer_smart_quit': get(g:, 'disable_drawer_auto_quit', 0),
      \ 'disable_drawer_hover_popup': 0,
      \ 'disable_drawer_tabpage_isolation': 0,
      \ 'disable_drawer_auto_restore_focus': 0,
      \ 'default_hidden': 0,
      \ 'default_include': '',
      \ 'default_exclude': '',
      \ 'renderer': 'default',
      \ 'renderers': {},
      \ 'enable_textprop_support': 0,
      \ 'comparator': 'default',
      \ 'comparators': {},
      \ 'drawer_width': 30,
      \ 'drawer_keep': v:false,
      \ 'drawer_hover_popup_delay': 0,
      \ 'mark_symbol': '*',
      \ 'window_selector_use_popup': 0,
      \})

function! fern#version() abort
  if !executable('git')
    echohl ErrorMsg
    echo '[fern] "git" is not executable'
    echohl None
    return
  endif
  let r = system(printf('git -C %s describe --tags --always --dirty', s:root))
  echo printf('[fern] %s', r)
endfunction
./autoload/vital/_fern/App/Action.vim	[[[1
266
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#App#Action#import() abort', printf("return map({'list': '', 'get_prefix': '', 'get_hiddens': '', 'init': '', 'set_ignores': '', 'call': '', 'get_ignores': '', 'set_hiddens': '', 'set_prefix': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
let s:prefix = matchstr(
      \ fnamemodify(expand('<sfile>'), ':p:h:h:t'),
      \ '^\%(__\zs.*\ze__\|_\zs.*\)$',
      \)
let s:hiddens = []
let s:ignores = []

function! s:get_prefix() abort
  return s:prefix
endfunction

function! s:set_prefix(prefix) abort
  let s:prefix = a:prefix
endfunction

function! s:get_hiddens() abort
  return copy(s:hiddens)
endfunction

function! s:set_hiddens(hiddens) abort
  let s:hiddens = a:hiddens
endfunction

function! s:get_ignores() abort
  return copy(s:ignores)
endfunction

function! s:set_ignores(ignores) abort
  let s:ignores = a:ignores
endfunction

function! s:init() abort
  execute printf(
        \ 'nnoremap <buffer><silent> <Plug>(%s-action-choice) :<C-u>call <SID>_map_choice()<CR>',
        \ s:prefix,
        \)
  execute printf(
        \ 'nnoremap <buffer><silent> <Plug>(%s-action-repeat) :<C-u>call <SID>_map_repeat()<CR>',
        \ s:prefix,
        \)
  execute printf(
        \ 'nnoremap <buffer><silent> <Plug>(%s-action-help) :<C-u>call <SID>_map_help(0)<CR>',
        \ s:prefix,
        \)
  execute printf(
        \ 'nnoremap <buffer><silent> <Plug>(%s-action-help:all) :<C-u>call <SID>_map_help(1)<CR>',
        \ s:prefix,
        \)

  if !hasmapto(printf('<Plug>(%s-action-choice)', s:prefix), 'n')
    execute printf(
          \ 'nmap <buffer> a <Plug>(%s-action-choice)',
          \ s:prefix,
          \)
  endif
  if !hasmapto(printf('<Plug>(%s-action-repeat)', s:prefix), 'n')
    execute printf(
          \ 'nmap <buffer> . <Plug>(%s-action-repeat)',
          \ s:prefix,
          \)
  endif
  if !hasmapto(printf('<Plug>(%s-action-help)', s:prefix), 'n')
    execute printf(
          \ 'nmap <buffer> ? <Plug>(%s-action-help)',
          \ s:prefix,
          \)
  endif

  let b:{s:prefix}_action = {
        \ 'actions': s:_build_actions(),
        \ 'previous': '',
        \}
endfunction

function! s:call(name, ...) abort
  let options = extend({
        \ 'capture': 0,
        \ 'verbose': 0,
        \}, a:0 ? a:1 : {},
        \)
  if !exists(printf('b:%s_action', s:prefix))
    throw 'the buffer has not been initialized for actions'
  endif
  if index(b:{s:prefix}_action.actions, a:name) is# -1
    throw printf('no action %s found in the buffer', a:name)
  endif
  let b:{s:prefix}_action.previous = a:name
  let l:Fn = funcref('s:_call', [a:name])
  if options.verbose
    let l:Fn = funcref('s:_verbose', [Fn])
  endif
  if options.capture
    let l:Fn = funcref('s:_capture', [Fn])
  endif
  call Fn()
endfunction

function! s:list(...) abort
  let conceal = a:0 ? a:1 : v:true
  let l:Sort = { a, b -> s:_compare(a[1], b[1]) }
  let rs = split(execute('nmap'), '\n')
  call filter(rs, {_, v -> match(v, '^n') != -1})
  call map(rs, { _, v -> v[3:] })
  call map(rs, { _, v -> matchlist(v, '^\([^ ]\+\)\s*\*\?@\?\(.*\)$')[1:2] })

  " To action mapping
  let pattern1 = printf('^<Plug>(%s-action-\zs.*\ze)$', s:prefix)
  let pattern2 = printf('^<Plug>(%s-action-', s:prefix)
  let rs1 = map(copy(rs), { _, v -> v + [matchstr(v[1], pattern1)] })
  call filter(rs1, { _, v -> !empty(v[2]) })
  call filter(rs1, { _, v -> v[0] !~# '^<Plug>' || v[0] =~# pattern2 })
  call map(rs1, { _, v -> [v[0], v[2], v[1]] })

  " From action mapping
  let rs2 = map(copy(rs), { _, v -> v + [matchstr(v[0], pattern1)] })
  call filter(rs2, { _, v -> !empty(v[2]) })
  call map(rs2, { _, v -> ['', v[2], v[0]] })

  let rs = uniq(sort(rs1 + rs2, Sort), Sort)
  call filter(rs, { -> index(s:ignores, v:val[1]) is# -1 })
  if conceal
    call filter(rs, { -> v:val[1] !~# ':' || !empty(v:val[0]) })
    call filter(rs, { -> index(s:hiddens, v:val[1]) is# -1 })
  endif

  return rs
endfunction

function! s:_map_choice() abort
  if !exists(printf('b:%s_action', s:prefix))
    throw 'the buffer has not been initialized for actions'
  endif
  call inputsave()
  try
    let fn = get(function('s:_complete_choice'), 'name')
    let expr = input('action: ', '', printf('customlist,%s', fn))
  finally
    call inputrestore()
  endtry
  let r = s:_parse_expr(expr)
  let ns = copy(b:{s:prefix}_action.actions)
  let r.name = get(filter(ns, { -> v:val =~# '^' . r.name }), 0)
  if empty(r.name)
    return
  endif
  call s:call(r.name, {
       \ 'capture': r.capture,
       \ 'verbose': r.verbose,
       \})
endfunction

function! s:_map_repeat() abort
  if !exists(printf('b:%s_action', s:prefix))
    throw 'the buffer has not been initialized for actions'
  endif
  if empty(b:{s:prefix}_action.previous)
    return
  endif
  call s:call(b:{s:prefix}_action.previous)
endfunction

function! s:_map_help(all) abort
  let rs = s:list(!a:all)

  let len0 = max(map(copy(rs), { -> len(v:val[0]) }))
  let len1 = max(map(copy(rs), { -> len(v:val[1]) }))
  let len2 = max(map(copy(rs), { -> len(v:val[2]) }))
  call map(rs, { _, v -> [
       \   printf(printf('%%-%dS', len0), v[0]),
       \   printf(printf('%%-%dS', len1), v[1]),
       \   printf(printf('%%-%dS', len2), v[2]),
       \ ]
       \})

  call map(rs, { -> join(v:val, '  ') })
  if !a:all
    echohl Title
    echo "NOTE: Some actions are concealed. Use 'help:all' action to see all actions."
    echohl None
  endif
  echo join(rs, "\n")
endfunction

function! s:_parse_expr(expr) abort
  if empty(a:expr)
    return {'name' : '', 'capture': 0, 'verbose': 0}
  endif
  let terms = split(a:expr)
  let name = remove(terms, -1)
  let l:Has = { ns, n -> len(filter(copy(ns), { -> v:val ==# n })) }
  return {
        \ 'name': name,
        \ 'capture': Has(terms, 'capture'),
        \ 'verbose': Has(terms, 'verbose'),
        \}
endfunction

function! s:_build_actions() abort
  let n = len(printf('%s-action-', s:prefix))
  let ms = split(execute(printf('nmap <Plug>(%s-action-', s:prefix)), '\n')
  call map(ms, { _, v -> split(v)[1] })
  call map(ms, { _, v -> matchstr(v, '^<Plug>(\zs.*\ze)$') })
  call filter(ms, { _, v -> !empty(v) })
  call map(ms, { _, expr -> expr[n :] })
  return sort(ms)
endfunction

function! s:_complete_choice(arglead, cmdline, cursorpos) abort
  if !exists(printf('b:%s_action', s:prefix))
    return []
  endif
  let names = copy(b:{s:prefix}_action.actions)
  let names += ['capture', 'verbose']
  call filter(names, { -> index(s:ignores, v:val) is# -1 })
  if empty(a:arglead)
    call filter(names, { -> v:val !~# ':' })
    call filter(names, { -> index(s:hiddens, v:val) is# -1 })
  endif
  call filter(names, { -> v:val =~# '^' . a:arglead })
  return names
endfunction

function! s:_compare(i1, i2) abort
  return a:i1 == a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
endfunction

function! s:_call(name) abort
  execute printf(
        \ "normal \<Plug>(%s-action-%s)",
        \ s:prefix,
        \ a:name,
        \)
endfunction

function! s:_capture(fn) abort
  let output = execute('call a:fn()')
  let rs = split(output, '\r\?\n')
  execute printf('botright %dnew', len(rs))
  call setline(1, rs)
  setlocal buftype=nofile bufhidden=wipe
  setlocal noswapfile nobuflisted
  setlocal nomodifiable nomodified
  setlocal nolist signcolumn=no
  setlocal nonumber norelativenumber
  setlocal cursorline
  nnoremap <buffer><silent> q :<C-u>q<CR>
endfunction

function! s:_verbose(fn) abort
  let verbose_saved = &verbose
  try
    set verbose
    call a:fn()
  finally
    let &verbose = verbose_saved
  endtry
endfunction
./autoload/vital/_fern/App/Spinner.vim	[[[1
104
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#App#Spinner#import() abort', printf("return map({'_vital_created': '', 'new': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
scriptencoding utf-8

function! s:_vital_created(module) abort
  " https://github.com/sindresorhus/cli-spinners
  let a:module.dots = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']
  let a:module.dots2 = ['⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷']
  let a:module.dots3 = ['⠋', '⠙', '⠚', '⠞', '⠖', '⠦', '⠴', '⠲', '⠳', '⠓']
  let a:module.dots4 = ['⠄', '⠆', '⠇', '⠋', '⠙', '⠸', '⠰', '⠠', '⠰', '⠸', '⠙', '⠋', '⠇', '⠆']
  let a:module.dots5 = ['⠋', '⠙', '⠚', '⠒', '⠂', '⠂', '⠒', '⠲', '⠴', '⠦', '⠖', '⠒', '⠐', '⠐', '⠒', '⠓', '⠋']
  let a:module.dots6 = ['⠁', '⠉', '⠙', '⠚', '⠒', '⠂', '⠂', '⠒', '⠲', '⠴', '⠤', '⠄', '⠄', '⠤', '⠴', '⠲', '⠒', '⠂', '⠂', '⠒', '⠚', '⠙', '⠉', '⠁']
  let a:module.dots7 = ['⠈', '⠉', '⠋', '⠓', '⠒', '⠐', '⠐', '⠒', '⠖', '⠦', '⠤', '⠠', '⠠', '⠤', '⠦', '⠖', '⠒', '⠐', '⠐', '⠒', '⠓', '⠋', '⠉', '⠈']
  let a:module.dots8 = ['⠁', '⠁', '⠉', '⠙', '⠚', '⠒', '⠂', '⠂', '⠒', '⠲', '⠴', '⠤', '⠄', '⠄', '⠤', '⠠', '⠠', '⠤', '⠦', '⠖', '⠒', '⠐', '⠐', '⠒', '⠓', '⠋', '⠉', '⠈', '⠈']
  let a:module.dots9 = ['⢹', '⢺', '⢼', '⣸', '⣇', '⡧', '⡗', '⡏']
  let a:module.dots10 = ['⢄', '⢂', '⢁', '⡁', '⡈', '⡐', '⡠']
  let a:module.dots11 = ['⠁', '⠂', '⠄', '⡀', '⢀', '⠠', '⠐', '⠈']
  let a:module.dots12 = ['⢀⠀', '⡀⠀', '⠄⠀', '⢂⠀', '⡂⠀', '⠅⠀', '⢃⠀', '⡃⠀', '⠍⠀', '⢋⠀', '⡋⠀', '⠍⠁', '⢋⠁', '⡋⠁', '⠍⠉', '⠋⠉', '⠋⠉', '⠉⠙', '⠉⠙', '⠉⠩', '⠈⢙', '⠈⡙', '⢈⠩', '⡀⢙', '⠄⡙', '⢂⠩', '⡂⢘', '⠅⡘', '⢃⠨', '⡃⢐', '⠍⡐', '⢋⠠', '⡋⢀', '⠍⡁', '⢋⠁', '⡋⠁', '⠍⠉', '⠋⠉', '⠋⠉', '⠉⠙', '⠉⠙', '⠉⠩', '⠈⢙', '⠈⡙', '⠈⠩', '⠀⢙', '⠀⡙', '⠀⠩', '⠀⢘', '⠀⡘', '⠀⠨', '⠀⢐', '⠀⡐', '⠀⠠', '⠀⢀', '⠀⡀']
  let a:module.line = ['-', '\\', '|', '/']
  let a:module.line2 = ['⠂', '-', '–', '—', '–', '-']
  let a:module.pipe = ['┤', '┘', '┴', '└', '├', '┌', '┬', '┐']
  let a:module.simpleDots = ['.  ', '.. ', '...', '   ']
  let a:module.simpleDotsScrolling = ['.  ', '.. ', '...', ' ..', '  .', '   ']
  let a:module.star = ['✶', '✸', '✹', '✺', '✹', '✷']
  let a:module.star2 = ['+', 'x', '*']
  let a:module.flip = ['_', '_', '_', '-', '`', '`', "'", '´', '-', '_', '_', '_']
  let a:module.hamburger = ['☱', '☲', '☴']
  let a:module.growVertical = ['▁', '▃', '▄', '▅', '▆', '▇', '▆', '▅', '▄', '▃']
  let a:module.growHorizontal = ['▏', '▎', '▍', '▌', '▋', '▊', '▉', '▊', '▋', '▌', '▍', '▎']
  let a:module.balloon = [' ', '.', 'o', 'O', '@', '*', ' ']
  let a:module.balloon2 = ['.', 'o', 'O', '°', 'O', 'o', '.']
  let a:module.noise = ['▓', '▒', '░']
  let a:module.bounce = ['⠁', '⠂', '⠄', '⠂']
  let a:module.boxBounce = ['▖', '▘', '▝', '▗']
  let a:module.boxBounce2 = ['▌', '▀', '▐', '▄']
  let a:module.triangle = ['◢', '◣', '◤', '◥']
  let a:module.arc = ['◜', '◠', '◝', '◞', '◡', '◟']
  let a:module.circle = ['◡', '⊙', '◠']
  let a:module.squareCorners = ['◰', '◳', '◲', '◱']
  let a:module.circleQuarters = ['◴', '◷', '◶', '◵']
  let a:module.circleHalves = ['◐', '◓', '◑', '◒']
  let a:module.squish = ['╫', '╪']
  let a:module.toggle = ['⊶', '⊷']
  let a:module.toggle2 = ['▫', '▪']
  let a:module.toggle3 = ['□', '■']
  let a:module.toggle4 = ['■', '□', '▪', '▫']
  let a:module.toggle5 = ['▮', '▯']
  let a:module.toggle6 = ['ဝ', '၀']
  let a:module.toggle7 = ['⦾', '⦿']
  let a:module.toggle8 = ['◍', '◌']
  let a:module.toggle9 = ['◉', '◎']
  let a:module.toggle10 = ['㊂', '㊀', '㊁']
  let a:module.toggle11 = ['⧇', '⧆']
  let a:module.toggle12 = ['☗', '☖']
  let a:module.toggle13 = ['=', '*', '-']
  let a:module.arrow = ['←', '↖', '↑', '↗', '→', '↘', '↓', '↙']
  let a:module.arrow2 = ['⬆️ ', '↗️ ', '➡️ ', '↘️ ', '⬇️ ', '↙️ ', '⬅️ ', '↖️ ']
  let a:module.arrow3 = ['▹▹▹▹▹', '▸▹▹▹▹', '▹▸▹▹▹', '▹▹▸▹▹', '▹▹▹▸▹', '▹▹▹▹▸']
  let a:module.bouncingBar = ['[    ]', '[=   ]', '[==  ]', '[=== ]', '[ ===]', '[  ==]', '[   =]', '[    ]', '[   =]', '[  ==]', '[ ===]', '[====]', '[=== ]', '[==  ]', '[=   ]']
  let a:module.bouncingBall = ['( ●    )', '(  ●   )', '(   ●  )', '(    ● )', '(     ●)', '(    ● )', '(   ●  )', '(  ●   )', '( ●    )', '(●     )']
  let a:module.smiley = ['😄 ', '😝 ']
  let a:module.monkey = ['🙈 ', '🙈 ', '🙉 ', '🙊 ']
  let a:module.hearts = ['💛 ', '💙 ', '💜 ', '💚 ', '❤️ ']
  let a:module.clock = ['🕛 ', '🕐 ', '🕑 ', '🕒 ', '🕓 ', '🕔 ', '🕕 ', '🕖 ', '🕗 ', '🕘 ', '🕙 ', '🕚 ']
  let a:module.earth = ['🌍 ', '🌎 ', '🌏 ']
  let a:module.moon = ['🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ']
  let a:module.runner = ['🚶 ', '🏃 ']
  let a:module.pong = ['▐⠂       ▌', '▐⠈       ▌', '▐ ⠂      ▌', '▐ ⠠      ▌', '▐  ⡀     ▌', '▐  ⠠     ▌', '▐   ⠂    ▌', '▐   ⠈    ▌', '▐    ⠂   ▌', '▐    ⠠   ▌', '▐     ⡀  ▌', '▐     ⠠  ▌', '▐      ⠂ ▌', '▐      ⠈ ▌', '▐       ⠂▌', '▐       ⠠▌', '▐       ⡀▌', '▐      ⠠ ▌', '▐      ⠂ ▌', '▐     ⠈  ▌', '▐     ⠂  ▌', '▐    ⠠   ▌', '▐    ⡀   ▌', '▐   ⠠    ▌', '▐   ⠂    ▌', '▐  ⠈     ▌', '▐  ⠂     ▌', '▐ ⠠      ▌', '▐ ⡀      ▌', '▐⠠       ▌']
  let a:module.shark = ['▐|\\____________▌', '▐_|\\___________▌', '▐__|\\__________▌', '▐___|\\_________▌', '▐____|\\________▌', '▐_____|\\_______▌', '▐______|\\______▌', '▐_______|\\_____▌', '▐________|\\____▌', '▐_________|\\___▌', '▐__________|\\__▌', '▐___________|\\_▌', '▐____________|\\▌', '▐____________/|▌', '▐___________/|_▌', '▐__________/|__▌', '▐_________/|___▌', '▐________/|____▌', '▐_______/|_____▌', '▐______/|______▌', '▐_____/|_______▌', '▐____/|________▌', '▐___/|_________▌', '▐__/|__________▌', '▐_/|___________▌', '▐/|____________▌']
  let a:module.dqpb = ['d', 'q', 'p', 'b']
  let a:module.weather = ['☀️ ', '☀️ ', '☀️ ', '🌤 ', '⛅️ ', '🌥 ', '☁️ ', '🌧 ', '🌨 ', '🌧 ', '🌨 ', '🌧 ', '🌨 ', '⛈ ', '🌨 ', '🌧 ', '🌨 ', '☁️ ', '🌥 ', '⛅️ ', '🌤 ', '☀️ ', '☀️ ']
  let a:module.christmas = ['🌲', '🎄']
  let a:module.grenade = ['،   ', '′   ', ' ´ ', ' ‾ ', '  ⸌', '  ⸊', '  |', '  ⁎', '  ⁕', ' ෴ ', '  ⁓', '   ', '   ', '   ']
  let a:module.point = ['∙∙∙', '●∙∙', '∙●∙', '∙∙●', '∙∙∙']
  let a:module.layer = ['-', '=', '≡']
endfunction

function! s:new(frames) abort
  return {
        \ '_index': -1,
        \ '_length': len(a:frames),
        \ '_frames': a:frames,
        \ 'next': funcref('s:_spinner_next'),
        \ 'reset': funcref('s:_spinner_reset'),
        \}
endfunction


function! s:_spinner_next() abort dict
  let self._index += 1
  let self._index = self._index % self._length
  return self._frames[self._index]
endfunction

function! s:_spinner_reset() abort dict
  let self._index = -1
endfunction
./autoload/vital/_fern/App/WindowLocator.vim	[[[1
99
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#App#WindowLocator#import() abort', printf("return map({'focus': '', 'get_conditions': '', 'list': '', 'find': '', 'score': '', 'set_threshold': '', 'set_conditions': '', 'get_threshold': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
let s:threshold = 0
let s:conditions = [
      \ { wi -> !wi.loclist },
      \ { wi -> !wi.quickfix },
      \ { wi -> !getwinvar(wi.winid, '&winfixwidth', 0) },
      \ { wi -> !getwinvar(wi.winid, '&winfixheight', 0) },
      \ { wi -> !getbufvar(wi.bufnr, '&previewwindow', 0) },
      \]

" Add condition to make sure that the window is not floating
if exists('*nvim_win_get_config')
  call add(s:conditions, { wi -> nvim_win_get_config(wi.winid).relative ==# '' })
endif

function! s:score(winnr) abort
  let winid = win_getid(a:winnr)
  let wininfo = getwininfo(winid)
  if empty(wininfo)
    return 0
  endif
  let wi = wininfo[0]
  let score = 1
  for Condition in s:conditions
    let score += Condition(wi)
  endfor
  return score
endfunction

function! s:list() abort
  let nwinnr = winnr('$')
  if nwinnr == 1
    return 1
  endif
  let threshold = s:get_threshold()
  while threshold > 0
    let ws = filter(
          \ range(1, winnr('$')),
          \ { -> s:score(v:val) >= threshold }
          \)
    if !empty(ws)
      break
    endif
    let threshold -= 1
  endwhile
  return ws
endfunction

function! s:find(origin) abort
  let nwinnr = winnr('$')
  if nwinnr == 1
    return 1
  endif
  let origin = a:origin == 0 ? winnr() : a:origin
  let former = range(origin, winnr('$'))
  let latter = reverse(range(1, origin - 1))
  let threshold = s:get_threshold()
  while threshold > 0
    for winnr in (former + latter)
      if s:score(winnr) >= threshold
        return winnr
      endif
    endfor
    let threshold -= 1
  endwhile
  return 0
endfunction

function! s:focus(origin) abort
  let winnr = s:find(a:origin)
  if winnr == 0 || winnr == winnr()
    return 1
  endif
  call win_gotoid(win_getid(winnr))
endfunction

function! s:get_conditions() abort
  return copy(s:conditions)
endfunction

function! s:set_conditions(conditions) abort
  let s:conditions = copy(a:conditions)
endfunction

function! s:get_threshold() abort
  return s:threshold is# 0 ? len(s:conditions) + 1 : s:threshold
endfunction

function! s:set_threshold(threshold) abort
  let s:threshold = a:threshold
endfunction
./autoload/vital/_fern/App/WindowSelector.vim	[[[1
212
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#App#WindowSelector#import() abort', printf("return map({'select': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
function! s:select(winnrs, ...) abort
  let options = extend({
        \ 'auto_select': 0,
        \ 'select_chars': split('abcdefghijklmnopqrstuvwxyz', '\zs'),
        \ 'statusline_hl': 'VitalWindowSelectorStatusLine',
        \ 'indicator_hl': 'VitalWindowSelectorIndicator',
        \ 'winbar_hl': 'VitalWindowSelectorWinBar',
        \ 'use_winbar': &laststatus is# 3 && exists('&winbar'),
        \ 'use_popup': 0,
        \ 'popup_borderchars': ['╭', '─', '╮', '│', '╯', '─', '╰', '│'],
        \}, a:0 ? a:1 : {})
  if !options.use_winbar && &laststatus is# 3
    echohl WarningMsg
    echomsg 'vital: App.WindowSelector: The laststatus=3 on Neovim requires winbar feature to show window indicator'
    echohl None
  endif
  if options.auto_select && len(a:winnrs) <= 1
    call win_gotoid(len(a:winnrs) ? win_getid(a:winnrs[0]) : win_getid())
    return 0
  endif
  let length = len(a:winnrs)
  try
    let scs = options.select_chars
    let chars = map(
          \ range(length),
          \ { _, v -> get(scs, v, string(v)) },
          \)

    if options.use_popup
      if len(options.popup_borderchars) != 8
        echohl WarningMsg
        echomsg 'vital: App.WindowSelector: number of popup_borderchars must be eight'
        echohl None
        return
      endif

      let borderchars = s:_normalize_popup_borderchars(options.popup_borderchars)
      call s:_popup(a:winnrs, options.select_chars, borderchars)
      redraw
    else
      let target = options.use_winbar ? '&winbar' : '&statusline'
      let store = {}
      for winnr in a:winnrs
        let store[winnr] = getwinvar(winnr, target)
      endfor
      let l:S = funcref('s:_statusline', [
            \ options.use_winbar
            \   ? options.winbar_hl
            \   : options.statusline_hl,
            \ options.indicator_hl,
            \])
      call map(keys(store), { k, v -> setwinvar(v, target, S(v, chars[k])) })
      redrawstatus
    endif
    call s:_cnoremap_all(chars)
    let n = input('choose window: ')
    call s:_cunmap_all()
    redraw | echo
    if n is# v:null
      return 1
    endif
    let n = index(chars, n)
    if n is# -1
      return 1
    endif
    call win_gotoid(win_getid(a:winnrs[n]))
  finally
    if options.use_popup
      call s:_clear_popups()
    else
      call map(keys(store), { _, v -> setwinvar(v, target, store[v]) })
      redrawstatus
    endif
  endtry
endfunction

" Convert popup window border character order to float window border character order
function! s:_normalize_popup_borderchars(chars) abort
  if has('nvim')
    return a:chars
  endif

  let borderchars = repeat([''], 8)
  " this is index for convert to float window border characters
  let idx = [4, 0, 5, 3, 6, 2, 7, 1]
  for i in range(len(idx))
    let borderchars[idx[i]] = a:chars[i]
  endfor
  return borderchars
endfunction

let s:_popup_winids = []

if has('nvim')
  function! s:_clear_popups() abort
    for winid in s:_popup_winids
      call nvim_win_close(winid, 1)
    endfor
    let s:_popup_winids = []
  endfunction

  function! s:_popup(winnrs, chars, borderchars) abort
    for idx in range(len(a:winnrs))
      let winnr = a:winnrs[idx]
      let char = a:chars[idx]
      let text = printf(' %s ', char)
      let [col, row] = [(winwidth(winnr) - len(text))/2, (winheight(winnr) - 3)/2]

      let bufnr = nvim_create_buf(0, 1)
      call nvim_buf_set_lines(bufnr, 0, -1, 1, [text])

      let opt = {
            \ 'relative': 'win',
            \ 'win': win_getid(winnr),
            \ 'width': len(text),
            \ 'height': 1,
            \ 'col': col,
            \ 'row': row,
            \ 'anchor': 'NE',
            \ 'style': 'minimal',
            \ 'focusable': 0,
            \ 'border': map(copy(a:borderchars), { _, v -> [v, 'NormalFloat'] }),
            \ }
      let winid = nvim_open_win(bufnr, 1, opt)
      call add(s:_popup_winids, winid)
    endfor
  endfunction

else
  function! s:_clear_popups() abort
    for winid in s:_popup_winids
      call popup_close(winid)
    endfor
    let s:_popup_winids = []
  endfunction

  function! s:_popup(winnrs, chars, borderchars) abort
    for idx in range(len(a:winnrs))
      let winnr = a:winnrs[idx]
      let char = a:chars[idx]
      let text = printf(' %s ', char)

      let [width, height] = [(winwidth(winnr) - len(text))/2, (winheight(winnr) - 3)/2]
      let [winrow, wincol] = win_screenpos(winnr)
      let row = winrow + height
      let col = wincol + width

      let winid = popup_create([text], {
            \ 'col': col,
            \ 'line': row,
            \ 'border': [1, 1, 1, 1],
            \ 'borderchars': copy(a:borderchars),
            \ }) 
      call add(s:_popup_winids, winid)
    endfor
  endfunction

endif

function! s:_statusline(statusline_hl, indicator_hl, winnr, char) abort
  let width = winwidth(a:winnr) - len(a:winnr . '') - 6
  let leading = repeat(' ', width / 2)
  return printf(
        \ '%%#%s#%s%%#%s#   %s   %%#%s#',
        \ a:statusline_hl,
        \ leading,
        \ a:indicator_hl,
        \ a:char,
        \ a:statusline_hl,
        \)
endfunction

function! s:_cnoremap_all(chars) abort
  for nr in range(256)
    silent! execute printf("cnoremap \<buffer>\<silent> \<Char-%d> \<Nop>", nr)
  endfor
  for char in a:chars
    silent! execute printf("cnoremap \<buffer>\<silent> %s %s\<CR>", char, char)
  endfor
  silent! cunmap <buffer> <Return>
  silent! cunmap <buffer> <Esc>
endfunction

function! s:_cunmap_all() abort
  for nr in range(256)
    silent! execute printf("cunmap \<buffer> \<Char-%d>", nr)
  endfor
endfunction

function! s:_highlight() abort
  highlight default link VitalWindowSelectorStatusLine StatusLineNC
  highlight default link VitalWindowSelectorIndicator  DiffText
  if exists('&winbar')
    highlight default link VitalWindowSelectorWinBar WinBarNC
  endif
endfunction

augroup vital_app_window_selector_internal
  autocmd!
  autocmd ColorScheme * call s:_highlight()
augroup END

call s:_highlight()
./autoload/vital/_fern/Async/CancellationToken.vim	[[[1
90
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Async#CancellationToken#import() abort', printf("return map({'_vital_created': '', 'new': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
let s:STATE_OPEN = 0
let s:STATE_CLOSED = 1
let s:STATE_REQUESTED = 2

let s:CANCELLED_ERROR = 'vital: Async.CancellationToken: CancelledError'

function! s:_vital_created(module) abort
  " State
  call extend(a:module, {
        \ 'STATE_OPEN': s:STATE_OPEN,
        \ 'STATE_CLOSED': s:STATE_CLOSED,
        \ 'STATE_REQUESTED': s:STATE_REQUESTED,
        \})
  " A token which will never be canceled
  let a:module.none = s:new({
        \ '_state': s:STATE_CLOSED,
        \ '_registrations': [],
        \})
  " A token that is already canceled
  let a:module.canceled = s:new({
        \ '_state': s:STATE_REQUESTED,
        \ '_registrations': [],
        \})
  let a:module.CancelledError = s:CANCELLED_ERROR
  lockvar 3 a:module
endfunction

function! s:new(source) abort
  let token = {
        \ '_source': a:source,
        \ 'cancellation_requested': funcref('s:_cancellation_requested'),
        \ 'can_be_canceled': funcref('s:_can_be_canceled'),
        \ 'throw_if_cancellation_requested': funcref('s:_throw_if_cancellation_requested'),
        \ 'register': funcref('s:_register'),
        \}
  lockvar 1 token
  return token
endfunction

function! s:_cancellation_requested() abort dict
  return self._source._state is# s:STATE_REQUESTED
endfunction

function! s:_can_be_canceled() abort dict
  return self._source._state isnot# s:STATE_CLOSED
endfunction

function! s:_throw_if_cancellation_requested() abort dict
  if self.cancellation_requested()
    throw s:CANCELLED_ERROR
  endif
endfunction

function! s:_register(callback) abort dict
  if self._source._state is# s:STATE_REQUESTED
    call a:callback()
    return { 'unregister': { -> 0 } }
  elseif self._source._state is# s:STATE_CLOSED
    return { 'unregister': { -> 0 } }
  endif

  let registration = {
        \ '_source': self._source,
        \ '_target': a:callback,
        \ 'unregister': funcref('s:_unregister'),
        \}
  call add(self._source._registrations, registration)
  return registration
endfunction

function! s:_unregister() abort dict
  if self._source is# v:null
    return
  endif
  let index = index(self._source._registrations, self)
  if index isnot# -1
    call remove(self._source._registrations, index)
  endif
  let self._source = v:null
  let self._target = v:null
endfunction
./autoload/vital/_fern/Async/CancellationTokenSource.vim	[[[1
86
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Async#CancellationTokenSource#import() abort', printf("return map({'_vital_depends': '', 'new': '', '_vital_loaded': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
function! s:_vital_depends() abort
  return ['Async.CancellationToken']
endfunction

function! s:_vital_loaded(V) abort
  let s:CancellationToken = a:V.import('Async.CancellationToken')
endfunction

function! s:new(...) abort
  let source = {
        \ '_state': s:CancellationToken.STATE_OPEN,
        \ '_registrations': [],
        \ '_linking_registrations': [],
        \ 'cancel': funcref('s:_cancel'),
        \ 'close': funcref('s:_close'),
        \}
  " Link to given tokens
  for token in (a:0 ? a:1 : [])
    if token.cancellation_requested()
      let source._state = token._source._state
      call s:_unlink(source)
      break
    elseif token.can_be_canceled()
      call add(
            \ source._linking_registrations,
            \ token.register({ -> source.cancel() }),
            \)
    endif
  endfor
  " Assign token
  let source.token = s:CancellationToken.new(source)
  lockvar 1 source
  return source
endfunction

function! s:_cancel() abort dict
  if self._state isnot# s:CancellationToken.STATE_OPEN
    return
  endif

  let self._state = s:CancellationToken.STATE_REQUESTED
  call s:_unlink(self)

  let registrations = filter(
        \ self._registrations,
        \ { _, v -> v._target isnot# v:null }
        \)
  let self._registrations = []
  for registration in registrations
    try
      call registration._target()
    catch
      let exception = v:exception
      call timer_start(0, { -> s:_throw(exception) })
    endtry
  endfor
endfunction

function! s:_close() abort dict
  if self._state isnot# s:CancellationToken.STATE_OPEN
    return
  endif

  let self._state = s:CancellationToken.STATE_CLOSED
  call s:_unlink(self)
  let self._registrations = []
endfunction

function! s:_unlink(source) abort
  let linking_registrations = a:source._linking_registrations
  let a:source._linking_registrations = []
  call map(linking_registrations, { _, v -> v.unregister() })
endfunction

function! s:_throw(exception) abort
  throw substitute(a:exception, '^Vim(.*):', '', '')
endfunction
./autoload/vital/_fern/Async/File.vim	[[[1
299
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Async#File#import() abort', printf("return map({'_vital_depends': '', 'is_move_supported': '', 'is_copy_dir_supported': '', 'open': '', 'copy': '', 'move': '', 'is_open_supported': '', 'is_copy_supported': '', 'is_trash_supported': '', 'copy_dir': '', 'trash': '', '_vital_loaded': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
function! s:_vital_depends() abort
  return ['Async.Promise.Process', 'Async.CancellationToken']
endfunction

function! s:_vital_loaded(V) abort
  let s:Process = a:V.import('Async.Promise.Process')
  let s:CancellationToken = a:V.import('Async.CancellationToken')
endfunction

" open()
if executable('rundll32')
  function! s:is_open_supported() abort
    return 1
  endfunction
  function! s:open(filename, ...) abort
    let options = copy(a:0 ? a:1 : {})
    let filename = fnamemodify(substitute(a:filename, '[/\\]\+', '\', 'g'), ':p')
    return s:Process.start([
          \ 'rundll32',
          \ 'url.dll,FileProtocolHandler',
          \ filename,
          \], options)
          \.then({ r -> s:_iconv_result(r) })
          \.catch({ e -> s:_iconv_result(e) })
  endfunction
elseif executable('cygstart')
  function! s:is_open_supported() abort
    return 1
  endfunction
  function! s:open(filename, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'cygstart',
          \ a:filename,
          \], options)
          \.then({ r -> s:_iconv_result(r) })
          \.catch({ e -> s:_iconv_result(e) })
  endfunction
elseif executable('xdg-open')
  function! s:is_open_supported() abort
    return 1
  endfunction
  function! s:open(filename, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'xdg-open',
          \ a:filename,
          \], options)
  endfunction
elseif executable('gnome-open')
  function! s:is_open_supported() abort
    return 1
  endfunction
  function! s:open(filename, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'gnome-open',
          \ a:filename,
          \], options)
  endfunction
elseif executable('exo-open')
  function! s:is_open_supported() abort
    return 1
  endfunction
  function! s:open(filename, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'exo-open',
          \ a:filename,
          \], options)
  endfunction
elseif executable('open')
  function! s:is_open_supported() abort
    return 1
  endfunction
  function! s:open(filename, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'open',
          \ a:filename,
          \], options)
  endfunction
elseif executable('kioclient')
  function! s:is_open_supported() abort
    return 1
  endfunction
  function! s:open(filename, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'kioclient', 'exec',
          \ a:filename,
          \], options)
  endfunction
else
  function! s:is_open_supported() abort
    return 0
  endfunction
  function! s:open(filename, ...) abort
    throw 'vital: Async.File: open(): Not supported platform.'
  endfunction
endif

" move()
if has('win32') && executable('cmd')
  function! s:is_move_supported() abort
    return 1
  endfunction
  function! s:move(src, dst, ...) abort
    let options = copy(a:0 ? a:1 : {})
    " normalize successive slashes to one slash
    let src = substitute(a:src, '[/\\]\+', '\', 'g')
    let dst = substitute(a:dst, '[/\\]\+', '\', 'g')
    " src must NOT have trailing slush
    let src = substitute(src, '\\$', '', '')
    " apply shellescape on neovim
    let src = has('nvim') ? shellescape(src) : src
    let dst = has('nvim') ? shellescape(dst) : dst
    return s:Process.start([
          \ 'cmd.exe', '/c', 'move', '/y', src, dst,
          \], options)
          \.then({ r -> s:_iconv_result(r) })
          \.catch({ e -> s:_iconv_result(e) })
  endfunction
elseif executable('mv')
  function! s:is_move_supported() abort
    return 1
  endfunction
  function! s:move(src, dst, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start(['mv', a:src, a:dst], options)
  endfunction
else
  function! s:is_move_supported() abort
    return 0
  endfunction
  function! s:move(src, dst, ...) abort
    throw 'vital: Async.File: move(): Not supported platform.'
  endfunction
endif

" copy()
if has('win32') && executable('cmd')
  function! s:is_copy_supported() abort
    return 1
  endfunction
  function! s:copy(src, dst, ...) abort
    let options = copy(a:0 ? a:1 : {})
    " normalize successive slashes to one slash
    let src = substitute(a:src, '[/\\]\+', '\', 'g')
    let dst = substitute(a:dst, '[/\\]\+', '\', 'g')
    " src must NOT have trailing slush
    let src = substitute(src, '\\$', '', '')
    " apply shellescape on neovim
    let src = has('nvim') ? shellescape(src) : src
    let dst = has('nvim') ? shellescape(dst) : dst
    return s:Process.start([
          \ 'cmd', '/c', 'copy', '/y', src, dst,
          \], options)
          \.then({ r -> s:_iconv_result(r) })
          \.catch({ e -> s:_iconv_result(e) })
  endfunction
elseif executable('cp')
  function! s:is_copy_supported() abort
    return 1
  endfunction
  function! s:copy(src, dst, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'cp', a:src, a:dst,
          \], options)
  endfunction
else
  function! s:is_copy_supported() abort
    return 0
  endfunction
  function! s:copy(src, dst, ...) abort
    throw 'vital: Async.File: copy(): Not supported platform.'
  endfunction
endif

" copy_dir()
if has('win32') && executable('robocopy')
  function! s:is_copy_dir_supported() abort
    return 1
  endfunction
  function! s:copy_dir(src, dst, ...) abort
    let options = copy(a:0 ? a:1 : {})
    " normalize successive slashes to one slash
    let src = fnamemodify(substitute(a:src, '[/\\]\+', '\', 'g'), ':p')
    let dst = fnamemodify(substitute(a:dst, '[/\\]\+', '\', 'g'), ':p')
    " src must NOT have trailing slush
    let src = substitute(src, '\\$', '', '')
    return s:Process.start([
          \ 'robocopy', '/e', src, dst,
          \], options)
          \.then({ r -> s:_iconv_result(r) })
          \.catch({ e -> s:_iconv_result(e) })
  endfunction
elseif executable('cp')
  function! s:is_copy_dir_supported() abort
    return 1
  endfunction
  function! s:copy_dir(src, dst, ...) abort
    let options = copy(a:0 ? a:1 : {})
    return s:Process.start([
          \ 'cp', '-r', a:src, a:dst,
          \], options)
  endfunction
else
  function! s:is_copy_dir_supported() abort
    return 0
  endfunction
  function! s:copy_dir(src, dst, ...) abort
    throw 'vital: Async.File: copy_dir(): Not supported platform.'
  endfunction
endif

" trash()
if has('mac') && executable('osascript')
  function! s:is_trash_supported() abort
    return 1
  endfunction
  function! s:trash(path, ...) abort
    let options = copy(a:0 ? a:1 : {})
    let script = 'tell app "Finder" to move the POSIX file "%s" to trash'
    let abspath = fnamemodify(a:path, ':p')
    return s:Process.start([
          \ 'osascript', '-e', printf(script, escape(abspath, '"'))
          \], options)
  endfunction
elseif has('win32') && executable('powershell')
  function! s:is_trash_supported() abort
    return 1
  endfunction
  function! s:trash(path, ...) abort
    let options = copy(a:0 ? a:1 : {})
    let abspath = fnamemodify(substitute(a:path, '[/\\]\+', '\', 'g'), ':p')
    let script = [
          \ '$path = Get-Item ''%s''',
          \ '$shell = New-Object -ComObject ''Shell.Application''',
          \ '$shell.NameSpace(0).ParseName($path.FullName).InvokeVerb(''delete'')',
          \]
    return s:Process.start([
          \ 'powershell',
          \ '-ExecutionPolicy', 'Bypass',
          \ '-Command', printf(join(script, "\r\n"), abspath),
          \], options)
          \.then({ r -> s:_iconv_result(r) })
          \.catch({ e -> s:_iconv_result(e) })
  endfunction
elseif executable('trash-put')
  function! s:is_trash_supported() abort
    return 1
  endfunction
  " https://github.com/andreafrancia/trash-cli
  function! s:trash(path, ...) abort
    let options = copy(a:0 ? a:1 : {})
    let abspath = fnamemodify(a:path, ':p')
    return s:Process.start([
          \ 'trash-put', abspath,
          \], options)
  endfunction
elseif executable('gomi')
  function! s:is_trash_supported() abort
    return 1
  endfunction
  " https://github.com/b4b4r07/gomi
  function! s:trash(path, ...) abort
    let options = copy(a:0 ? a:1 : {})
    let abspath = fnamemodify(a:path, ':p')
    return s:Process.start([
          \ 'gomi', abspath,
          \], options)
  endfunction
else
  function! s:is_trash_supported() abort
    return 0
  endfunction
  " freedesktop
  " https://www.freedesktop.org/wiki/Specifications/trash-spec/
  function! s:trash(path, ...) abort
    throw 'vital: Async.File: trash(): Not supported platform.'
  endfunction
endif

function! s:_iconv_result(r) abort
  let a:r.stdout = map(a:r.stdout, { -> iconv(v:val, 'char', &encoding) })
  let a:r.stderr = map(a:r.stderr, { -> iconv(v:val, 'char', &encoding) })
  return a:r
endfunction
./autoload/vital/_fern/Async/Lambda.vim	[[[1
96
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Async#Lambda#import() abort', printf("return map({'_vital_depends': '', 'filter': '', 'filter_f': '', 'reduce': '', 'reduce_f': '', '_vital_created': '', 'map': '', 'map_f': '', '_vital_loaded': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
function! s:_vital_created(module) abort
  let a:module.chunk_size = 1000
endfunction

function! s:_vital_loaded(V) abort
  let s:Later = a:V.import('Async.Later')
  let s:Lambda = a:V.import('Lambda')
  let s:Promise = a:V.import('Async.Promise')
  let s:Chunker = a:V.import('Data.List.Chunker')
endfunction

function! s:_vital_depends() abort
  return ['Async.Later', 'Async.Promise', 'Data.List.Chunker', 'Lambda']
endfunction

function! s:map(list, fn) abort dict
  let t = self.chunk_size
  let c = s:Chunker.new(t, a:list)
  return s:Promise.new({ resolve -> s:_map(c, a:fn, [], 0, resolve)})
endfunction

function! s:filter(list, fn) abort dict
  let t = self.chunk_size
  let c = s:Chunker.new(t, a:list)
  return s:Promise.new({ resolve -> s:_filter(c, a:fn, [], 0, resolve)})
endfunction

function! s:reduce(list, fn, init) abort dict
  let t = self.chunk_size
  let c = s:Chunker.new(t, a:list)
  return s:Promise.new({ resolve -> s:_reduce(c, a:fn, a:init, 0, resolve)})
endfunction

function! s:map_f(fn) abort dict
  return { list -> self.map(list, a:fn) }
endfunction

function! s:filter_f(fn) abort dict
  return { list -> self.filter(list, a:fn) }
endfunction

function! s:reduce_f(fn, init) abort dict
  return { list -> self.reduce(list, a:fn, a:init) }
endfunction

function! s:_map(chunker, fn, result, offset, resolve) abort
  let chunk = a:chunker.next()
  let chunk_size = len(chunk)
  if chunk_size is# 0
    call a:resolve(a:result)
    return
  endif
  call extend(a:result, map(chunk, { k, v -> a:fn(v, a:offset + k) }))
  call s:Later.call({ ->
        \ s:_map(a:chunker, a:fn, a:result, a:offset + chunk_size, a:resolve)
        \})
endfunction

function! s:_filter(chunker, fn, result, offset, resolve) abort
  let chunk = a:chunker.next()
  let chunk_size = len(chunk)
  if chunk_size is# 0
    call a:resolve(a:result)
    return
  endif
  call extend(a:result, filter(chunk, { k, v -> a:fn(v, a:offset + k) }))
  call s:Later.call({ ->
        \ s:_filter(a:chunker, a:fn, a:result, a:offset + chunk_size, a:resolve)
        \})
endfunction

function! s:_reduce(chunker, fn, result, offset, resolve) abort
  let chunk = a:chunker.next()
  let chunk_size = len(chunk)
  if chunk_size is# 0
    call a:resolve(a:result)
    return
  endif
  let result = s:Lambda.reduce(
        \ chunk,
        \ { a, v, k -> a:fn(a, v, a:offset + k) },
        \ a:result,
        \)
  call s:Later.call({ ->
        \ s:_reduce(a:chunker, a:fn, result, a:offset + chunk_size, a:resolve)
        \})
endfunction
./autoload/vital/_fern/Async/Later.vim	[[[1
75
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Async#Later#import() abort', printf("return map({'set_max_workers': '', 'call': '', 'get_max_workers': '', 'set_error_handler': '', 'get_error_handler': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
let s:tasks = []
let s:workers = []
let s:max_workers = 50
let s:error_handler = v:null

function! s:call(fn, ...) abort
  call add(s:tasks, [a:fn, a:000])
  if empty(s:workers)
    call add(s:workers, timer_start(0, s:Worker, { 'repeat': -1 }))
  endif
endfunction

function! s:get_max_workers() abort
  return s:max_workers
endfunction

function! s:set_max_workers(n) abort
  if a:n <= 0
    throw 'vital: Async.Later: the n must be a positive integer'
  endif
  let s:max_workers = a:n
endfunction

function! s:get_error_handler() abort
  return s:error_handler
endfunction

function! s:set_error_handler(handler) abort
  let s:error_handler = a:handler
endfunction

function! s:_default_error_handler() abort
  let ms = split(v:exception . "\n" . v:throwpoint, '\n')
  echohl ErrorMsg
  for m in ms
    echomsg m
  endfor
  echohl None
endfunction

function! s:_worker(...) abort
  if v:dying
    return
  endif
  let n_workers = len(s:workers)
  if empty(s:tasks)
    if n_workers
      call timer_stop(remove(s:workers, 0))
    endif
    return
  endif
  try
    call call('call', remove(s:tasks, 0))
  catch
    if s:error_handler is# v:null
      call s:_default_error_handler()
    else
      call s:error_handler()
    endif
  endtry
  if n_workers < s:max_workers
    call add(s:workers, timer_start(0, s:Worker, { 'repeat': -1 }))
  endif
endfunction

let s:Worker = funcref('s:_worker')
./autoload/vital/_fern/Async/Promise/Process.vim	[[[1
108
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Async#Promise#Process#import() abort', printf("return map({'_vital_depends': '', 'is_available': '', 'start': '', '_vital_loaded': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
function! s:_vital_loaded(V) abort
  let s:Job = a:V.import('System.Job')
  let s:Promise = a:V.import('Async.Promise')
  let s:CancellationToken = a:V.import('Async.CancellationToken')
endfunction

function! s:_vital_depends() abort
  return ['System.Job', 'Async.Promise', 'Async.CancellationToken']
endfunction

function! s:start(args, ...) abort
  let options = extend({
        \ 'cwd': '.',
        \ 'raw': 0,
        \ 'stdin': s:Promise.reject(),
        \ 'token': s:CancellationToken.none,
        \ 'reject_on_failure': v:false,
        \}, a:0 ? a:1 : {},
        \)
  let p = s:Promise.new(funcref('s:_executor', [a:args, options]))
  if options.reject_on_failure
    let p = p.then(funcref('s:_reject_on_failure'))
  endif
  return p
endfunction

function! s:is_available() abort
  if !has('patch-8.0.0107') && !has('nvim-0.2.0')
    return 0
  endif
  return s:Promise.is_available() && s:Job.is_available()
endfunction

function! s:_reject_on_failure(result) abort
  if a:result.exitval
    return s:Promise.reject(a:result)
  endif
  return a:result
endfunction

function! s:_executor(args, options, resolve, reject) abort
  call a:options.token.throw_if_cancellation_requested()

  let ns = {
        \ 'args': a:args,
        \ 'stdout': [''],
        \ 'stderr': [''],
        \ 'resolve': a:resolve,
        \ 'reject': a:reject,
        \ 'token': a:options.token,
        \}
  let reg = ns.token.register(funcref('s:_on_cancel', [ns]))
  let ns.job = s:Job.start(a:args, {
        \ 'cwd': a:options.cwd,
        \ 'on_stdout': a:options.raw
        \   ? funcref('s:_on_receive_raw', [ns.stdout])
        \   : funcref('s:_on_receive', [ns.stdout]),
        \ 'on_stderr': a:options.raw
        \   ? funcref('s:_on_receive_raw', [ns.stderr])
        \   : funcref('s:_on_receive', [ns.stderr]),
        \ 'on_exit': funcref('s:_on_exit', [reg, ns]),
        \})
  call a:options.stdin
        \.then({ v -> ns.job.send(v) })
        \.then({ -> ns.job.close() })
  if has_key(a:options, 'abort')
    echohl WarningMsg
    echomsg 'vital: Async.Promise.Process: The "abort" has deprecated. Use "token" instead.'
    echohl None
    call a:options.abort
          \.then({ -> ns.job.stop() })
  endif
endfunction

function! s:_on_receive(buffer, data) abort
  call map(a:data, 'v:val[-1:] ==# "\r" ? v:val[:-2] : v:val')
  let a:buffer[-1] .= a:data[0]
  call extend(a:buffer, a:data[1:])
endfunction

function! s:_on_receive_raw(buffer, data) abort
  let a:buffer[-1] .= a:data[0]
  call extend(a:buffer, a:data[1:])
endfunction

function! s:_on_exit(reg, ns, data) abort
  call a:reg.unregister()
  call a:ns.resolve({
        \ 'args': a:ns.args,
        \ 'stdout': a:ns.stdout,
        \ 'stderr': a:ns.stderr,
        \ 'exitval': a:data,
        \})
endfunction

function! s:_on_cancel(ns, ...) abort
  call a:ns.job.stop()
  call a:ns.reject(s:CancellationToken.CancelledError)
endfunction
./autoload/vital/_fern/Async/Promise.vim	[[[1
359
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Async#Promise#import() abort', printf("return map({'resolve': '', '_vital_depends': '', 'race': '', 'wait': '', '_vital_created': '', 'all': '', 'noop': '', 'on_unhandled_rejection': '', 'is_promise': '', 'chain': '', 'is_available': '', 'reject': '', 'new': '', '_vital_loaded': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
" ECMAScript like Promise library for asynchronous operations.
"   Spec: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
" This implementation is based upon es6-promise npm package.
"   Repo: https://github.com/stefanpenner/es6-promise

" States of promise
let s:PENDING = 0
let s:FULFILLED = 1
let s:REJECTED = 2

let s:DICT_T = type({})

let s:TIMEOUT_ERROR = 'vital: Async.Promise: Timeout'
let s:DEFAULT_WAIT_INTERVAL = 30

function! s:_vital_created(module) abort
  let a:module.TimeoutError = s:TIMEOUT_ERROR
  lockvar a:module.TimeoutError
endfunction

function! s:_vital_loaded(V) abort
  let s:Later = a:V.import('Async.Later')
endfunction

function! s:_vital_depends() abort
  return ['Async.Later']
endfunction

function! s:noop(...) abort
endfunction
let s:NOOP = funcref('s:noop')

" Internal APIs

let s:PROMISE = {
    \   '_state': s:PENDING,
    \   '_has_floating_child': v:false,
    \   '_children': [],
    \   '_fulfillments': [],
    \   '_rejections': [],
    \   '_result': v:null,
    \ }

let s:id = -1
function! s:_next_id() abort
  let s:id += 1
  return s:id
endfunction

" ... is added to use this function as a callback of s:Later.call()
function! s:_invoke_callback(settled, promise, callback, result, ...) abort
  let has_callback = a:callback isnot v:null
  let success = 1
  let err = v:null
  if has_callback
    try
      let l:Result = a:callback(a:result)
    catch
      let err = {
      \   'exception' : v:exception,
      \   'throwpoint' : v:throwpoint,
      \ }
      let success = 0
    endtry
  else
    let l:Result = a:result
  endif

  if a:promise._state != s:PENDING
    " Do nothing
  elseif has_callback && success
    call s:_resolve(a:promise, Result)
  elseif !success
    call s:_reject(a:promise, err)
  elseif a:settled == s:FULFILLED
    call s:_fulfill(a:promise, Result)
  elseif a:settled == s:REJECTED
    call s:_reject(a:promise, Result)
  endif
endfunction

" ... is added to use this function as a callback of s:Later.call()
function! s:_publish(promise, ...) abort
  let settled = a:promise._state
  if settled == s:PENDING
    throw 'vital: Async.Promise: Cannot publish a pending promise'
  endif

  if empty(a:promise._children)
    if settled == s:REJECTED && !a:promise._has_floating_child
      call s:_on_unhandled_rejection(a:promise._result)
    endif
    return
  endif

  for i in range(len(a:promise._children))
    if settled == s:FULFILLED
      let l:CB = a:promise._fulfillments[i]
    else
      " When rejected
      let l:CB = a:promise._rejections[i]
    endif
    let child = a:promise._children[i]
    if child isnot v:null
      call s:_invoke_callback(settled, child, l:CB, a:promise._result)
    else
      call l:CB(a:promise._result)
    endif
  endfor

  let a:promise._children = []
  let a:promise._fulfillments = []
  let a:promise._rejections = []
endfunction

function! s:_subscribe(parent, child, on_fulfilled, on_rejected) abort
  let a:parent._children += [ a:child ]
  let a:parent._fulfillments += [ a:on_fulfilled ]
  let a:parent._rejections += [ a:on_rejected ]
endfunction

function! s:_handle_thenable(promise, thenable) abort
  if a:thenable._state == s:FULFILLED
    call s:_fulfill(a:promise, a:thenable._result)
  elseif a:thenable._state == s:REJECTED
    call s:_reject(a:promise, a:thenable._result)
  else
    call s:_subscribe(
         \   a:thenable,
         \   v:null,
         \   funcref('s:_resolve', [a:promise]),
         \   funcref('s:_reject', [a:promise]),
         \ )
  endif
endfunction

function! s:_resolve(promise, ...) abort
  let l:Result = a:0 > 0 ? a:1 : v:null
  if s:is_promise(Result)
    call s:_handle_thenable(a:promise, Result)
  else
    call s:_fulfill(a:promise, Result)
  endif
endfunction

function! s:_fulfill(promise, value) abort
  if a:promise._state != s:PENDING
    return
  endif
  let a:promise._result = a:value
  let a:promise._state = s:FULFILLED
  if !empty(a:promise._children)
    call s:Later.call(funcref('s:_publish', [a:promise]))
  endif
endfunction

function! s:_reject(promise, ...) abort
  if a:promise._state != s:PENDING
    return
  endif
  let a:promise._result = a:0 > 0 ? a:1 : v:null
  let a:promise._state = s:REJECTED
  call s:Later.call(funcref('s:_publish', [a:promise]))
endfunction

function! s:_notify_done(wg, index, value) abort
  let a:wg.results[a:index] = a:value
  let a:wg.remaining -= 1
  if a:wg.remaining == 0
    call a:wg.resolve(a:wg.results)
  endif
endfunction

function! s:_all(promises, resolve, reject) abort
  let total = len(a:promises)
  if total == 0
    call a:resolve([])
    return
  endif

  let wait_group = {
      \   'results': repeat([v:null], total),
      \   'resolve': a:resolve,
      \   'remaining': total,
      \ }

  " 'for' statement is not available here because iteration variable is captured into lambda
  " expression by **reference**.
  call map(
       \   copy(a:promises),
       \   {i, p -> p.then({v -> s:_notify_done(wait_group, i, v)}, a:reject)},
       \ )
endfunction

function! s:_race(promises, resolve, reject) abort
  for p in a:promises
    call p.then(a:resolve, a:reject)
  endfor
endfunction

" Public APIs

function! s:new(resolver) abort
  let promise = deepcopy(s:PROMISE)
  let promise._vital_promise = s:_next_id()
  try
    if a:resolver != s:NOOP
      call a:resolver(
      \   funcref('s:_resolve', [promise]),
      \   funcref('s:_reject', [promise]),
      \ )
    endif
  catch
    call s:_reject(promise, {
    \   'exception' : v:exception,
    \   'throwpoint' : v:throwpoint,
    \ })
  endtry
  return promise
endfunction

function! s:all(promises) abort
  return s:new(funcref('s:_all', [a:promises]))
endfunction

function! s:race(promises) abort
  return s:new(funcref('s:_race', [a:promises]))
endfunction

function! s:resolve(...) abort
  let promise = s:new(s:NOOP)
  call s:_resolve(promise, a:0 > 0 ? a:1 : v:null)
  return promise
endfunction

function! s:reject(...) abort
  let promise = s:new(s:NOOP)
  call s:_reject(promise, a:0 > 0 ? a:1 : v:null)
  return promise
endfunction

function! s:is_available() abort
  return has('lambda') && has('timers')
endfunction

function! s:is_promise(maybe_promise) abort
  return type(a:maybe_promise) == s:DICT_T && has_key(a:maybe_promise, '_vital_promise')
endfunction

function! s:wait(promise, ...) abort
  if a:0 && type(a:1) is# v:t_number
    let t = a:1
    let i = s:DEFAULT_WAIT_INTERVAL . 'm'
  else
    let o = a:0 ? a:1 : {}
    let t = get(o, 'timeout', v:null)
    let i = get(o, 'interval', s:DEFAULT_WAIT_INTERVAL) . 'm'
  endif
  let s = reltime()
  while a:promise._state is# s:PENDING
    if (t isnot# v:null && reltimefloat(reltime(s)) * 1000 > t)
      return [v:null, s:TIMEOUT_ERROR]
    endif
    execute 'sleep' i
  endwhile
  if a:promise._state is# s:FULFILLED
    return [a:promise._result, v:null]
  else
    return [v:null, a:promise._result]
  endif
endfunction

function! s:chain(promise_factories) abort
  return s:_chain(copy(a:promise_factories), [])
endfunction

function! s:_chain(promise_factories, results) abort
  if len(a:promise_factories) is# 0
    return s:resolve(a:results)
  endif
  let l:Factory = remove(a:promise_factories, 0)
  try
    return Factory()
          \.then({ v -> add(a:results, v) })
          \.then({ -> s:_chain(a:promise_factories, a:results) })
  catch
    return s:reject({
          \ 'exception': v:exception,
          \ 'throwpoint': v:throwpoint,
          \})
  endtry
endfunction

let s:_on_unhandled_rejection = s:NOOP
function! s:on_unhandled_rejection(on_unhandled_rejection) abort
  let s:_on_unhandled_rejection = a:on_unhandled_rejection
endfunction

function! s:_promise_then(...) dict abort
  let parent = self
  let state = parent._state
  let child = s:new(s:NOOP)
  let l:Res = a:0 > 0 ? a:1 : v:null
  let l:Rej = a:0 > 1 ? a:2 : v:null
  if state == s:FULFILLED
    let parent._has_floating_child = v:true
    call s:Later.call(funcref('s:_invoke_callback', [state, child, Res, parent._result]))
  elseif state == s:REJECTED
    let parent._has_floating_child = v:true
    call s:Later.call(funcref('s:_invoke_callback', [state, child, Rej, parent._result]))
  else
    call s:_subscribe(parent, child, Res, Rej)
  endif
  return child
endfunction
let s:PROMISE.then = funcref('s:_promise_then')

" .catch() is just a syntax sugar of .then()
function! s:_promise_catch(...) dict abort
  return self.then(v:null, a:0 > 0 ? a:1 : v:null)
endfunction
let s:PROMISE.catch = funcref('s:_promise_catch')

function! s:_on_finally(CB, parent, Result) abort
  call a:CB()
  if a:parent._state == s:FULFILLED
    return a:Result
  else " REJECTED
    return s:reject(a:Result)
  endif
endfunction
function! s:_promise_finally(...) dict abort
  let parent = self
  let state = parent._state
  let child = s:new(s:NOOP)
  if a:0 == 0
    let l:CB = v:null
  else
    let l:CB = funcref('s:_on_finally', [a:1, parent])
  endif
  if state != s:PENDING
    call s:Later.call(funcref('s:_invoke_callback', [state, child, CB, parent._result]))
  else
    call s:_subscribe(parent, child, CB, CB)
  endif
  return child
endfunction
let s:PROMISE.finally = funcref('s:_promise_finally')

" vim:set et ts=2 sts=2 sw=2 tw=0:
./autoload/vital/_fern/Config.vim	[[[1
44
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Config#import() abort', printf("return map({'define': '', 'translate': '', 'config': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
let s:plugin_name = expand('<sfile>:p:h:t')
let s:plugin_name = s:plugin_name =~# '^__.\+__$'
      \ ? s:plugin_name[2:-3]
      \ : s:plugin_name =~# '^_.\+$'
      \   ? s:plugin_name[1:]
      \   : s:plugin_name

function! s:define(prefix, default) abort
  let prefix = a:prefix =~# '^g:' ? a:prefix : 'g:' . a:prefix
  for [key, Value] in items(a:default)
    let name = prefix . '#' . key
    if !exists(name)
      execute 'let ' . name . ' = ' . string(Value)
    endif
    unlet Value
  endfor
endfunction

function! s:config(scriptfile, default) abort
  let prefix = s:translate(a:scriptfile)
  call s:define(prefix, a:default)
endfunction

function! s:translate(scriptfile) abort
  let path = fnamemodify(a:scriptfile, ':gs?\\?/?')
  let name = matchstr(path, printf(
        \ 'autoload/\zs\%%(%s\.vim\|%s/.*\)$',
        \ s:plugin_name,
        \ s:plugin_name,
        \))
  let name = substitute(name, '\.vim$', '', '')
  let name = substitute(name, '/', '#', 'g')
  let name = substitute(name, '\%(^#\|#$\)', '', 'g')
  return 'g:' . name
endfunction
./autoload/vital/_fern/Data/List/Chunker.vim	[[[1
21
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Data#List#Chunker#import() abort', printf("return map({'new': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
function! s:new(size, candidates) abort
  return {
        \ '__cursor': 0,
        \ 'next': function('s:_chunker_next', [a:size, a:candidates]),
        \}
endfunction

function! s:_chunker_next(size, candidates) abort dict
  let prev_cursor = self.__cursor
  let self.__cursor = self.__cursor + a:size
  return a:candidates[ prev_cursor : (self.__cursor - 1) ]
endfunction
./autoload/vital/_fern/Lambda.vim	[[[1
82
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Lambda#import() abort', printf("return map({'throw': '', 'filter_f': '', 'echomsg': '', 'echo': '', 'pass': '', 'reduce': '', 'unlet': '', 'void': '', 'let': '', 'map': '', 'map_f': '', 'filter': '', 'if': '', 'reduce_f': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
function! s:void(...) abort
endfunction

function! s:pass(value, ...) abort
  return a:value
endfunction

function! s:let(object, key, value) abort
  let a:object[a:key] = a:value
endfunction

function! s:unlet(object, key, ...) abort
  let force = a:0 ? a:1 : 0
  if (a:0 ? a:1 : 0) is# 1
    silent! unlet! a:object[a:key]
  else
    unlet a:object[a:key]
  endif
endfunction

function! s:throw(message) abort
  throw a:message
endfunction

function! s:echo(message) abort
  echo a:message
endfunction

function! s:echomsg(message) abort
  echomsg a:message
endfunction

function! s:if(condition, true, ...) abort
  if a:condition
    return a:true()
  elseif a:0
    return a:1()
  endif
endfunction

function! s:map(list, fn) abort
  return map(copy(a:list), { k, v -> a:fn(v, k) })
endfunction

function! s:filter(list, fn) abort
  return filter(copy(a:list), { k, v -> a:fn(v, k) })
endfunction

function! s:reduce(list, fn, ...) abort
  let accumulator = a:0 ? a:1 : a:list[0]
  let offset = a:0 ? 0 : 1
  for index in range(len(a:list) - offset)
    let accumulator = a:fn(
          \ accumulator,
          \ a:list[offset + index],
          \ offset + index,
          \)
  endfor
  return accumulator
endfunction

function! s:map_f(fn) abort
  return { list -> s:map(list, a:fn) }
endfunction

function! s:filter_f(fn) abort
  return { list -> s:filter(list, a:fn) }
endfunction

function! s:reduce_f(fn, ...) abort
  let args = a:000
  return { list -> call('s:reduce', [list, a:fn] + args) }
endfunction
./autoload/vital/_fern/System/Filepath.vim	[[[1
312
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#System#Filepath#import() abort', printf("return map({'path_separator': '', 'is_case_tolerant': '', 'dirname': '', 'abspath': '', 'relpath': '', 'realpath': '', 'unify_separator': '', 'to_slash': '', 'is_root_directory': '', 'separator': '', 'split': '', 'path_extensions': '', 'unixpath': '', 'which': '', 'winpath': '', 'from_slash': '', 'expand': '', 'expand_home': '', 'join': '', 'is_relative': '', 'basename': '', 'remove_last_separator': '', 'is_absolute': '', 'contains': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
" You should check the following related builtin functions.
" fnamemodify()
" resolve()
" simplify()

let s:save_cpo = &cpo
set cpo&vim

let s:path_sep_pattern = (exists('+shellslash') ? '[\\/]' : '/') . '\+'

" See https://github.com/vim-jp/vital.vim/wiki/Coding-Rule#how-to-check-if-the-runtime-os-is-windows
let s:is_windows = has('win32')

let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))

let s:is_case_tolerant = filereadable(expand('<sfile>:r') . '.VIM')

if s:is_windows
  function! s:to_slash(path) abort
    return tr(a:path, '\', '/')
  endfunction
else
  function! s:to_slash(path) abort
    return a:path
  endfunction
endif

if s:is_windows
  function! s:from_slash(path) abort
    return tr(a:path, '/', '\')
  endfunction
else
  function! s:from_slash(path) abort
    return a:path
  endfunction
endif


" Get the directory separator.
function! s:separator() abort
  return fnamemodify('.', ':p')[-1 :]
endfunction

" Get the path separator.
let s:path_separator = s:is_windows ? ';' : ':'
function! s:path_separator() abort
  return s:path_separator
endfunction

" Get the path extensions
function! s:path_extensions() abort
  if !exists('s:path_extensions')
    if s:is_windows
      if exists('$PATHEXT')
        let pathext = $PATHEXT
      else
        " get default PATHEXT
        let pathext = matchstr(system('set pathext'), '\C^pathext=\zs.*\ze\n', 'i')
      endif
      let s:path_extensions = map(split(pathext, s:path_separator), 'tolower(v:val)')
    elseif s:is_cygwin
      " cygwin is not use $PATHEXT
      let s:path_extensions = ['', '.exe']
    else
      let s:path_extensions = ['']
    endif
  endif
  return s:path_extensions
endfunction

" Convert all directory separators to "/".
function! s:unify_separator(path) abort
  return substitute(a:path, s:path_sep_pattern, '/', 'g')
endfunction

" Get the full path of command.
if exists('*exepath')
  function! s:which(str) abort
    return exepath(a:str)
  endfunction
else
  function! s:which(command, ...) abort
    let pathlist = a:command =~# s:path_sep_pattern ? [''] :
    \              !a:0                  ? split($PATH, s:path_separator) :
    \              type(a:1) == type([]) ? copy(a:1) :
    \                                      split(a:1, s:path_separator)

    let pathext = s:path_extensions()
    if index(pathext, '.' . tolower(fnamemodify(a:command, ':e'))) != -1
      let pathext = ['']
    endif

    let dirsep = s:separator()
    for dir in pathlist
      let head = dir ==# '' ? '' : dir . dirsep
      for ext in pathext
        let full = fnamemodify(head . a:command . ext, ':p')
        if filereadable(full)
          if s:is_case_tolerant()
            let full = glob(substitute(
            \               toupper(full), '\u:\@!', '[\0\L\0]', 'g'), 1)
          endif
          if full !=# ''
            return full
          endif
        endif
      endfor
    endfor

    return ''
  endfunction
endif

" Split the path with directory separator.
" Note that this includes the drive letter of MS Windows.
function! s:split(path) abort
  return split(a:path, s:path_sep_pattern)
endfunction

" Join the paths.
" join('foo', 'bar')            => 'foo/bar'
" join('foo/', 'bar')           => 'foo/bar'
" join('/foo/', ['bar', 'buz/']) => '/foo/bar/buz/'
function! s:join(...) abort
  let sep = s:separator()
  let path = ''
  for part in a:000
    let path .= sep .
    \ (type(part) is type([]) ? call('s:join', part) :
    \                           part)
    unlet part
  endfor
  return substitute(path[1 :], s:path_sep_pattern, sep, 'g')
endfunction

" Check if the path is absolute path.
if s:is_windows
  function! s:is_absolute(path) abort
    return a:path =~# '^[a-zA-Z]:[/\\]'
  endfunction
else
  function! s:is_absolute(path) abort
    return a:path[0] ==# '/'
  endfunction
endif

function! s:is_relative(path) abort
  return !s:is_absolute(a:path)
endfunction

" Return the parent directory of the path.
" NOTE: fnamemodify(path, ':h') does not return the parent directory
" when path[-1] is the separator.
function! s:dirname(path) abort
  let path = a:path
  let orig = a:path

  let path = s:remove_last_separator(path)
  if path ==# ''
    return orig    " root directory
  endif

  let path = fnamemodify(path, ':h')
  return path
endfunction

" Return the basename of the path.
" NOTE: fnamemodify(path, ':h') does not return basename
" when path[-1] is the separator.
function! s:basename(path) abort
  let path = a:path
  let orig = a:path

  let path = s:remove_last_separator(path)
  if path ==# ''
    return orig    " root directory
  endif

  let path = fnamemodify(path, ':t')
  return path
endfunction

" Remove the separator at the end of a:path.
function! s:remove_last_separator(path) abort
  let sep = s:separator()
  let pat = escape(sep, '\') . '\+$'
  return substitute(a:path, pat, '', '')
endfunction


" Return true if filesystem ignores alphabetic case of a filename.
" Return false otherwise.
function! s:is_case_tolerant() abort
  return s:is_case_tolerant
endfunction


function! s:expand_home(path) abort
  if a:path[:0] !=# '~'
    return a:path
  endif
  let post_home_idx = match(a:path, s:path_sep_pattern)
  return post_home_idx is# -1
        \ ? s:remove_last_separator(s:expand(a:path))
        \ : s:remove_last_separator(s:expand(a:path[0 : post_home_idx - 1]))
        \   . a:path[post_home_idx :]
endfunction

function! s:abspath(path) abort
  if s:is_absolute(a:path)
    return a:path
  endif
  " NOTE: The behavior of ':p' for a non existing file/directory path
  " is not defined.
  return (filereadable(a:path) || isdirectory(a:path))
        \ ? fnamemodify(a:path, ':p')
        \ : s:join(fnamemodify(getcwd(), ':p'), a:path)
endfunction

function! s:relpath(path) abort
  if s:is_relative(a:path)
    return a:path
  endif
  return fnamemodify(a:path, ':~:.')
endfunction

function! s:unixpath(path) abort
  return fnamemodify(a:path, ':gs?\\?/?')
endfunction

function! s:winpath(path) abort
  return fnamemodify(a:path, ':gs?/?\\?')
endfunction

if s:is_windows
  function! s:realpath(path) abort
    if exists('+shellslash') && &shellslash
      return s:unixpath(a:path)
    else
      return s:winpath(a:path)
    endif
  endfunction
else
  function! s:realpath(path) abort
    return s:unixpath(a:path)
  endfunction
endif

if s:is_windows
  function! s:is_root_directory(path) abort
    return a:path =~# '^[a-zA-Z]:[/\\]$'
  endfunction
else
  function! s:is_root_directory(path) abort
    return a:path ==# '/'
  endfunction
endif

function! s:contains(path, base) abort
  if a:path ==# '' || a:base ==# ''
    return 0
  endif
  let pathlist = s:split(a:path)
  let baselist = s:split(a:base)
  let pathlistlen = len(pathlist)
  let baselistlen = len(baselist)
  if pathlistlen < baselistlen
    return 0
  endif
  if baselistlen == 0
    return 1
  endif
  if s:is_case_tolerant
    call map(pathlist, 'tolower(v:val)')
    call map(baselist, 'tolower(v:val)')
  endif
  return pathlist[: baselistlen - 1] ==# baselist
endfunction

if exists('+completeslash')
  " completeslash bug in Windows and specific version range (Vim 8.1.1769 - Vim 8.2.1746)
  function! s:expand(path) abort
    let backup_completeslash = &completeslash
    try
      set completeslash&
      return expand(a:path)
    finally
      let &completeslash = backup_completeslash
    endtry
  endfunction
else
  function! s:expand(path) abort
    return expand(a:path)
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
./autoload/vital/_fern/System/Job/Neovim.vim	[[[1
168
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#System#Job#Neovim#import() abort', printf("return map({'is_available': '', 'start': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
" http://vim-jp.org/blog/2016/03/23/take-care-of-patch-1577.html
function! s:is_available() abort
  return has('nvim') && has('nvim-0.2.0')
endfunction

function! s:start(args, options) abort
  let job = extend(copy(s:job), a:options)
  let job_options = {}
  if has_key(a:options, 'cwd')
    let job_options.cwd = a:options.cwd
  endif
  if has_key(a:options, 'env')
    let job_options.env = a:options.env
  endif
  if has_key(job, 'on_stdout')
    let job_options.on_stdout = funcref('s:_on_stdout', [job])
  endif
  if has_key(job, 'on_stderr')
    let job_options.on_stderr = funcref('s:_on_stderr', [job])
  endif
  if has_key(job, 'on_exit')
    let job_options.on_exit = funcref('s:_on_exit', [job])
  else
    let job_options.on_exit = funcref('s:_on_exit_raw', [job])
  endif
  let job.__job = jobstart(a:args, job_options)
  let job.__pid = s:_jobpid_safe(job.__job)
  let job.__exitval = v:null
  let job.args = a:args
  return job
endfunction

if has('nvim-0.3.0')
  " Neovim 0.3.0 and over seems to invoke on_stdout/on_stderr with an empty
  " string data when the stdout/stderr channel has closed.
  " It is different behavior from Vim and Neovim prior to 0.3.0 so remove an
  " empty string list to keep compatibility.
  function! s:_on_stdout(job, job_id, data, event) abort
    if a:data == ['']
      return
    endif
    call a:job.on_stdout(a:data)
  endfunction

  function! s:_on_stderr(job, job_id, data, event) abort
    if a:data == ['']
      return
    endif
    call a:job.on_stderr(a:data)
  endfunction
else
  function! s:_on_stdout(job, job_id, data, event) abort
    call a:job.on_stdout(a:data)
  endfunction

  function! s:_on_stderr(job, job_id, data, event) abort
    call a:job.on_stderr(a:data)
  endfunction
endif

function! s:_on_exit(job, job_id, exitval, event) abort
  let a:job.__exitval = a:exitval
  call a:job.on_exit(a:exitval)
endfunction

function! s:_on_exit_raw(job, job_id, exitval, event) abort
  let a:job.__exitval = a:exitval
endfunction

function! s:_jobpid_safe(job) abort
  try
    return jobpid(a:job)
  catch /^Vim\%((\a\+)\)\=:E900/
    " NOTE:
    " Vim does not raise exception even the job has already closed so fail
    " silently for 'E900: Invalid job id' exception
    return 0
  endtry
endfunction

" Instance -------------------------------------------------------------------
function! s:_job_id() abort dict
  if &verbose
    echohl WarningMsg
    echo 'vital: System.Job: job.id() is deprecated. Use job.pid() instead.'
    echohl None
  endif
  return self.pid()
endfunction

function! s:_job_pid() abort dict
  return self.__pid
endfunction

function! s:_job_status() abort dict
  try
    sleep 1m
    call jobpid(self.__job)
    return 'run'
  catch /^Vim\%((\a\+)\)\=:E900/
    return 'dead'
  endtry
endfunction

if exists('*chansend') " Neovim 0.2.3
  function! s:_job_send(data) abort dict
    return chansend(self.__job, a:data)
  endfunction
else
  function! s:_job_send(data) abort dict
    return jobsend(self.__job, a:data)
  endfunction
endif

if exists('*chanclose') " Neovim 0.2.3
  function! s:_job_close() abort dict
    call chanclose(self.__job, 'stdin')
  endfunction
else
  function! s:_job_close() abort dict
    call jobclose(self.__job, 'stdin')
  endfunction
endif

function! s:_job_stop() abort dict
  try
    call jobstop(self.__job)
  catch /^Vim\%((\a\+)\)\=:E900/
    " NOTE:
    " Vim does not raise exception even the job has already closed so fail
    " silently for 'E900: Invalid job id' exception
  endtry
endfunction

function! s:_job_wait(...) abort dict
  let timeout = a:0 ? a:1 : v:null
  let exitval = timeout is# v:null
        \ ? jobwait([self.__job])[0]
        \ : jobwait([self.__job], timeout)[0]
  if exitval != -3
    return exitval
  endif
  " Wait until 'on_exit' callback is called
  while self.__exitval is# v:null
    sleep 1m
  endwhile
  return self.__exitval
endfunction

" To make debug easier, use funcref instead.
let s:job = {
      \ 'id': funcref('s:_job_id'),
      \ 'pid': funcref('s:_job_pid'),
      \ 'status': funcref('s:_job_status'),
      \ 'send': funcref('s:_job_send'),
      \ 'close': funcref('s:_job_close'),
      \ 'stop': funcref('s:_job_stop'),
      \ 'wait': funcref('s:_job_wait'),
      \}
./autoload/vital/_fern/System/Job/Vim.vim	[[[1
153
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#System#Job#Vim#import() abort', printf("return map({'is_available': '', 'start': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
" https://github.com/neovim/neovim/blob/f629f83/src/nvim/event/process.c#L24-L26
let s:KILL_TIMEOUT_MS = 2000

function! s:is_available() abort
  return !has('nvim') && has('patch-8.0.0027')
endfunction

function! s:start(args, options) abort
  let job = extend(copy(s:job), a:options)
  let job_options = {
        \ 'mode': 'raw',
        \ 'timeout': 0,
        \}
  if has('patch-8.1.889')
    let job_options['noblock'] = 1
  endif
  if has_key(job, 'on_stdout')
    let job_options.out_cb = funcref('s:_out_cb', [job])
  else
    let job_options.out_io = 'null'
  endif
  if has_key(job, 'on_stderr')
    let job_options.err_cb = funcref('s:_err_cb', [job])
  else
    let job_options.err_io = 'null'
  endif
  if has_key(job, 'on_exit')
    let job_options.exit_cb = funcref('s:_exit_cb', [job])
  endif
  if has_key(job, 'cwd') && has('patch-8.0.0902')
    let job_options.cwd = job.cwd
  endif
  if has_key(job, 'env') && has('patch-8.0.0902')
    let job_options.env = job.env
  endif
  let job.__job = job_start(a:args, job_options)
  let job.args = a:args
  return job
endfunction

function! s:_out_cb(job, channel, msg) abort
  call a:job.on_stdout(split(a:msg, "\n", 1))
endfunction

function! s:_err_cb(job, channel, msg) abort
  call a:job.on_stderr(split(a:msg, "\n", 1))
endfunction

function! s:_exit_cb(job, channel, exitval) abort
  " Make sure on_stdout/on_stderr are called prior to on_exit.
  if has_key(a:job, 'on_stdout')
    let options = {'part': 'out'}
    while ch_status(a:channel, options) ==# 'open'
      sleep 1m
    endwhile
    while ch_status(a:channel, options) ==# 'buffered'
      call s:_out_cb(a:job, a:channel, ch_readraw(a:channel, options))
    endwhile
  endif
  if has_key(a:job, 'on_stderr')
    let options = {'part': 'err'}
    while ch_status(a:channel, options) ==# 'open'
      sleep 1m
    endwhile
    while ch_status(a:channel, options) ==# 'buffered'
      call s:_err_cb(a:job, a:channel, ch_readraw(a:channel, options))
    endwhile
  endif
  call a:job.on_exit(a:exitval)
endfunction


" Instance -------------------------------------------------------------------
function! s:_job_id() abort dict
  if &verbose
    echohl WarningMsg
    echo 'vital: System.Job: job.id() is deprecated. Use job.pid() instead.'
    echohl None
  endif
  return self.pid()
endfunction

function! s:_job_pid() abort dict
  return job_info(self.__job).process
endfunction

" NOTE:
" On Unix a non-existing command results in "dead" instead
" So returns "dead" instead of "fail" even in non Unix.
function! s:_job_status() abort dict
  let status = job_status(self.__job)
  return status ==# 'fail' ? 'dead' : status
endfunction

" NOTE:
" A Null character (\0) is used as a terminator of a string in Vim.
" Neovim can send \0 by using \n splitted list but in Vim.
" So replace all \n in \n splitted list to ''
function! s:_job_send(data) abort dict
  let data = type(a:data) == v:t_list
        \ ? join(map(a:data, 'substitute(v:val, "\n", '''', ''g'')'), "\n")
        \ : a:data
  return ch_sendraw(self.__job, data)
endfunction

function! s:_job_close() abort dict
  call ch_close_in(self.__job)
endfunction

function! s:_job_stop() abort dict
  call job_stop(self.__job)
  call timer_start(s:KILL_TIMEOUT_MS, { -> job_stop(self.__job, 'kill') })
endfunction

function! s:_job_wait(...) abort dict
  let timeout = a:0 ? a:1 : v:null
  let timeout = timeout is# v:null ? v:null : timeout / 1000.0
  let start_time = reltime()
  let job = self.__job
  try
    while timeout is# v:null || timeout > reltimefloat(reltime(start_time))
      let status = job_status(job)
      if status !=# 'run'
        return status ==# 'dead' ? job_info(job).exitval : -3
      endif
      sleep 1m
    endwhile
  catch /^Vim:Interrupt$/
    call self.stop()
    return -2
  endtry
  return -1
endfunction

" To make debug easier, use funcref instead.
let s:job = {
      \ 'id': funcref('s:_job_id'),
      \ 'pid': funcref('s:_job_pid'),
      \ 'status': funcref('s:_job_status'),
      \ 'send': funcref('s:_job_send'),
      \ 'close': funcref('s:_job_close'),
      \ 'stop': funcref('s:_job_stop'),
      \ 'wait': funcref('s:_job_wait'),
      \}
./autoload/vital/_fern/System/Job.vim	[[[1
53
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#System#Job#import() abort', printf("return map({'_vital_depends': '', 'is_available': '', 'start': '', '_vital_loaded': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
let s:t_string = type('')
let s:t_list = type([])

function! s:_vital_loaded(V) abort
  if has('nvim')
    let s:Job = a:V.import('System.Job.Neovim')
  else
    let s:Job = a:V.import('System.Job.Vim')
  endif
endfunction

function! s:_vital_depends() abort
  return [
        \ 'System.Job.Vim',
        \ 'System.Job.Neovim',
        \]
endfunction

" Note:
" Vim does not raise E902 on Unix system even the prog is not found so use a
" custom exception instead to make the method compatible.
" Note:
" Vim/Neovim treat String a bit differently so prohibit String as well
function! s:_validate_args(args) abort
  if type(a:args) != s:t_list
    throw 'vital: System.Job: Argument requires to be a List instance.'
  endif
  if len(a:args) == 0
    throw 'vital: System.Job: Argument vector must have at least one item.'
  endif
  let prog = a:args[0]
  if !executable(prog)
    throw printf('vital: System.Job: "%s" is not an executable', prog)
  endif
endfunction

function! s:is_available() abort
  return s:Job.is_available()
endfunction

function! s:start(args, ...) abort
  call s:_validate_args(a:args)
  return s:Job.start(a:args, a:0 ? a:1 : {})
endfunction
./autoload/vital/_fern/Vim/Window/Cursor.vim	[[[1
54
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not modify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_fern#Vim#Window#Cursor#import() abort', printf("return map({'set_cursor': '', 'get_cursor': ''}, \"vital#_fern#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
if !exists('*nvim_win_get_cursor')
  function! s:get_cursor(winid) abort
    if win_getid() is# a:winid
      let cursor = getpos('.')
      return [cursor[1], cursor[2] - 1]
    else
      let winid_saved = win_getid()
      try
        call win_gotoid(a:winid)
        return s:get_cursor(a:winid)
      finally
        call win_gotoid(winid_saved)
      endtry
    endif
  endfunction
else
  function! s:get_cursor(winid) abort
    return nvim_win_get_cursor(a:winid)
  endfunction
endif

if !exists('*nvim_win_set_cursor')
  function! s:set_cursor(winid, pos) abort
    if win_getid() is# a:winid
      let cursor = [0, a:pos[0], a:pos[1] + 1, 0]
      call setpos('.', cursor)
    else
      let winid_saved = win_getid()
      try
        call win_gotoid(a:winid)
        call s:set_cursor(a:winid, a:pos)
      finally
        call win_gotoid(winid_saved)
      endtry
    endif
  endfunction
else
  function! s:set_cursor(winid, pos) abort
    try
      call nvim_win_set_cursor(a:winid, a:pos)
    catch /Cursor position outside buffer/
      " Do nothing
    endtry
  endfunction
endif
./autoload/vital/_fern.vim	[[[1
9
let s:_plugin_name = expand('<sfile>:t:r')

function! vital#{s:_plugin_name}#new() abort
  return vital#{s:_plugin_name[1:]}#new()
endfunction

function! vital#{s:_plugin_name}#function(funcname) abort
  silent! return function(a:funcname)
endfunction
./autoload/vital/fern.vim	[[[1
334
let s:plugin_name = expand('<sfile>:t:r')
let s:vital_base_dir = expand('<sfile>:h')
let s:project_root = expand('<sfile>:h:h:h')
let s:is_vital_vim = s:plugin_name is# 'vital'

let s:loaded = {}
let s:cache_sid = {}

function! vital#{s:plugin_name}#new() abort
  return s:new(s:plugin_name)
endfunction

function! vital#{s:plugin_name}#import(...) abort
  if !exists('s:V')
    let s:V = s:new(s:plugin_name)
  endif
  return call(s:V.import, a:000, s:V)
endfunction

let s:Vital = {}

function! s:new(plugin_name) abort
  let base = deepcopy(s:Vital)
  let base._plugin_name = a:plugin_name
  return base
endfunction

function! s:vital_files() abort
  if !exists('s:vital_files')
    let s:vital_files = map(
    \   s:is_vital_vim ? s:_global_vital_files() : s:_self_vital_files(),
    \   'fnamemodify(v:val, ":p:gs?[\\\\/]?/?")')
  endif
  return copy(s:vital_files)
endfunction
let s:Vital.vital_files = function('s:vital_files')

function! s:import(name, ...) abort dict
  let target = {}
  let functions = []
  for a in a:000
    if type(a) == type({})
      let target = a
    elseif type(a) == type([])
      let functions = a
    endif
    unlet a
  endfor
  let module = self._import(a:name)
  if empty(functions)
    call extend(target, module, 'keep')
  else
    for f in functions
      if has_key(module, f) && !has_key(target, f)
        let target[f] = module[f]
      endif
    endfor
  endif
  return target
endfunction
let s:Vital.import = function('s:import')

function! s:load(...) abort dict
  for arg in a:000
    let [name; as] = type(arg) == type([]) ? arg[: 1] : [arg, arg]
    let target = split(join(as, ''), '\W\+')
    let dict = self
    let dict_type = type({})
    while !empty(target)
      let ns = remove(target, 0)
      if !has_key(dict, ns)
        let dict[ns] = {}
      endif
      if type(dict[ns]) == dict_type
        let dict = dict[ns]
      else
        unlet dict
        break
      endif
    endwhile
    if exists('dict')
      call extend(dict, self._import(name))
    endif
    unlet arg
  endfor
  return self
endfunction
let s:Vital.load = function('s:load')

function! s:unload() abort dict
  let s:loaded = {}
  let s:cache_sid = {}
  unlet! s:vital_files
endfunction
let s:Vital.unload = function('s:unload')

function! s:exists(name) abort dict
  if a:name !~# '\v^\u\w*%(\.\u\w*)*$'
    throw 'vital: Invalid module name: ' . a:name
  endif
  return s:_module_path(a:name) isnot# ''
endfunction
let s:Vital.exists = function('s:exists')

function! s:search(pattern) abort dict
  let paths = s:_extract_files(a:pattern, self.vital_files())
  let modules = sort(map(paths, 's:_file2module(v:val)'))
  return uniq(modules)
endfunction
let s:Vital.search = function('s:search')

function! s:plugin_name() abort dict
  return self._plugin_name
endfunction
let s:Vital.plugin_name = function('s:plugin_name')

function! s:_self_vital_files() abort
  let builtin = printf('%s/__%s__/', s:vital_base_dir, s:plugin_name)
  let installed = printf('%s/_%s/', s:vital_base_dir, s:plugin_name)
  let base = builtin . ',' . installed
  return split(globpath(base, '**/*.vim', 1), "\n")
endfunction

function! s:_global_vital_files() abort
  let pattern = 'autoload/vital/__*__/**/*.vim'
  return split(globpath(&runtimepath, pattern, 1), "\n")
endfunction

function! s:_extract_files(pattern, files) abort
  let tr = {'.': '/', '*': '[^/]*', '**': '.*'}
  let target = substitute(a:pattern, '\.\|\*\*\?', '\=tr[submatch(0)]', 'g')
  let regexp = printf('autoload/vital/[^/]\+/%s.vim$', target)
  return filter(a:files, 'v:val =~# regexp')
endfunction

function! s:_file2module(file) abort
  let filename = fnamemodify(a:file, ':p:gs?[\\/]?/?')
  let tail = matchstr(filename, 'autoload/vital/_\w\+/\zs.*\ze\.vim$')
  return join(split(tail, '[\\/]\+'), '.')
endfunction

" @param {string} name e.g. Data.List
function! s:_import(name) abort dict
  if has_key(s:loaded, a:name)
    return copy(s:loaded[a:name])
  endif
  let module = self._get_module(a:name)
  if has_key(module, '_vital_created')
    call module._vital_created(module)
  endif
  let export_module = filter(copy(module), 'v:key =~# "^\\a"')
  " Cache module before calling module._vital_loaded() to avoid cyclic
  " dependences but remove the cache if module._vital_loaded() fails.
  " let s:loaded[a:name] = export_module
  let s:loaded[a:name] = export_module
  if has_key(module, '_vital_loaded')
    try
      call module._vital_loaded(vital#{s:plugin_name}#new())
    catch
      unlet s:loaded[a:name]
      throw 'vital: fail to call ._vital_loaded(): ' . v:exception . " from:\n" . s:_format_throwpoint(v:throwpoint)
    endtry
  endif
  return copy(s:loaded[a:name])
endfunction
let s:Vital._import = function('s:_import')

function! s:_format_throwpoint(throwpoint) abort
  let funcs = []
  let stack = matchstr(a:throwpoint, '^function \zs.*, .\{-} \d\+$')
  for line in split(stack, '\.\.')
    let m = matchlist(line, '^\(.\+\)\%(\[\(\d\+\)\]\|, .\{-} \(\d\+\)\)$')
    if !empty(m)
      let [name, lnum, lnum2] = m[1:3]
      if empty(lnum)
        let lnum = lnum2
      endif
      let info = s:_get_func_info(name)
      if !empty(info)
        let attrs = empty(info.attrs) ? '' : join([''] + info.attrs)
        let flnum = info.lnum == 0 ? '' : printf(' Line:%d', info.lnum + lnum)
        call add(funcs, printf('function %s(...)%s Line:%d (%s%s)',
        \        info.funcname, attrs, lnum, info.filename, flnum))
        continue
      endif
    endif
    " fallback when function information cannot be detected
    call add(funcs, line)
  endfor
  return join(funcs, "\n")
endfunction

" @vimlint(EVL102, 1, l:_)
" @vimlint(EVL102, 1, l:__)
function! s:_get_func_info(name) abort
  let name = a:name
  if a:name =~# '^\d\+$'  " is anonymous-function
    let name = printf('{%s}', a:name)
  elseif a:name =~# '^<lambda>\d\+$'  " is lambda-function
    let name = printf("{'%s'}", a:name)
  endif
  if !exists('*' . name)
    return {}
  endif
  let body = execute(printf('verbose function %s', name))
  let lines = split(body, "\n")
  let signature = matchstr(lines[0], '^\s*\zs.*')
  let [_, file, lnum; __] = matchlist(lines[1],
  \   '^\t\%(Last set from\|.\{-}:\)\s*\zs\(.\{-}\)\%( \S\+ \(\d\+\)\)\?$')
  return {
  \   'filename': substitute(file, '[/\\]\+', '/', 'g'),
  \   'lnum': 0 + lnum,
  \   'funcname': a:name,
  \   'arguments': split(matchstr(signature, '(\zs.*\ze)'), '\s*,\s*'),
  \   'attrs': filter(['dict', 'abort', 'range', 'closure'], 'signature =~# (").*" . v:val)'),
  \ }
endfunction
" @vimlint(EVL102, 0, l:__)
" @vimlint(EVL102, 0, l:_)

" s:_get_module() returns module object wihch has all script local functions.
function! s:_get_module(name) abort dict
  let funcname = s:_import_func_name(self.plugin_name(), a:name)
  try
    return call(funcname, [])
  catch /^Vim\%((\a\+)\)\?:E117:/
    return s:_get_builtin_module(a:name)
  endtry
endfunction

function! s:_get_builtin_module(name) abort
 return s:sid2sfuncs(s:_module_sid(a:name))
endfunction

if s:is_vital_vim
  " For vital.vim, we can use s:_get_builtin_module directly
  let s:Vital._get_module = function('s:_get_builtin_module')
else
  let s:Vital._get_module = function('s:_get_module')
endif

function! s:_import_func_name(plugin_name, module_name) abort
  return printf('vital#_%s#%s#import', a:plugin_name, s:_dot_to_sharp(a:module_name))
endfunction

function! s:_module_sid(name) abort
  let path = s:_module_path(a:name)
  if !filereadable(path)
    throw 'vital: module not found: ' . a:name
  endif
  let vital_dir = s:is_vital_vim ? '__\w\+__' : printf('_\{1,2}%s\%%(__\)\?', s:plugin_name)
  let base = join([vital_dir, ''], '[/\\]\+')
  let p = base . substitute('' . a:name, '\.', '[/\\\\]\\+', 'g')
  let sid = s:_sid(path, p)
  if !sid
    call s:_source(path)
    let sid = s:_sid(path, p)
    if !sid
      throw printf('vital: cannot get <SID> from path: %s', path)
    endif
  endif
  return sid
endfunction

function! s:_module_path(name) abort
  return get(s:_extract_files(a:name, s:vital_files()), 0, '')
endfunction

function! s:_module_sid_base_dir() abort
  return s:is_vital_vim ? &rtp : s:project_root
endfunction

function! s:_dot_to_sharp(name) abort
  return substitute(a:name, '\.', '#', 'g')
endfunction

function! s:_source(path) abort
  execute 'source' fnameescape(a:path)
endfunction

" @vimlint(EVL102, 1, l:_)
" @vimlint(EVL102, 1, l:__)
function! s:_sid(path, filter_pattern) abort
  let unified_path = s:_unify_path(a:path)
  if has_key(s:cache_sid, unified_path)
    return s:cache_sid[unified_path]
  endif
  for line in filter(split(execute(':scriptnames'), "\n"), 'v:val =~# a:filter_pattern')
    let [_, sid, path; __] = matchlist(line, '^\s*\(\d\+\):\s\+\(.\+\)\s*$')
    if s:_unify_path(path) is# unified_path
      let s:cache_sid[unified_path] = sid
      return s:cache_sid[unified_path]
    endif
  endfor
  return 0
endfunction

if filereadable(expand('<sfile>:r') . '.VIM') " is case-insensitive or not
  let s:_unify_path_cache = {}
  " resolve() is slow, so we cache results.
  " Note: On windows, vim can't expand path names from 8.3 formats.
  " So if getting full path via <sfile> and $HOME was set as 8.3 format,
  " vital load duplicated scripts. Below's :~ avoid this issue.
  function! s:_unify_path(path) abort
    if has_key(s:_unify_path_cache, a:path)
      return s:_unify_path_cache[a:path]
    endif
    let value = tolower(fnamemodify(resolve(fnamemodify(
    \                   a:path, ':p')), ':~:gs?[\\/]?/?'))
    let s:_unify_path_cache[a:path] = value
    return value
  endfunction
else
  function! s:_unify_path(path) abort
    return resolve(fnamemodify(a:path, ':p:gs?[\\/]?/?'))
  endfunction
endif

" copied and modified from Vim.ScriptLocal
let s:SNR = join(map(range(len("\<SNR>")), '"[\\x" . printf("%0x", char2nr("\<SNR>"[v:val])) . "]"'), '')
function! s:sid2sfuncs(sid) abort
  let fs = split(execute(printf(':function /^%s%s_', s:SNR, a:sid)), "\n")
  let r = {}
  let pattern = printf('\m^function\s<SNR>%d_\zs\w\{-}\ze(', a:sid)
  for fname in map(fs, 'matchstr(v:val, pattern)')
    let r[fname] = function(s:_sfuncname(a:sid, fname))
  endfor
  return r
endfunction

"" Return funcname of script local functions with SID
function! s:_sfuncname(sid, funcname) abort
  return printf('<SNR>%s_%s', a:sid, a:funcname)
endfunction
./autoload/vital/fern.vital	[[[1
17
fern
7fa44ef166bd9bb9ab6d2f9c3ec86c7b1d6b13ba

App.Spinner
Async.CancellationTokenSource
Async.File
Async.Lambda
Async.Later
Async.Promise
Async.Promise.Process
Config
Lambda
System.Filepath
Vim.Window.Cursor
App.Action
App.WindowSelector
App.WindowLocator
./doc/fern-develop.txt	[[[1
737
*fern-develop.txt*		Developer documentations for fern.vim

Author:  Alisue <lambdalisue@hashnote.net>
License: MIT license

=============================================================================
CONTENTS					*fern-develop-contents*

INTRODUCTION				|fern-develop-introduction|
FRI					|fern-develop-fri|
NODE					|fern-develop-node|
MAPPING					|fern-develop-mapping|
SCHEME					|fern-develop-scheme|
  PROVIDER				|fern-develop-scheme-provider|
  MAPPING				|fern-develop-scheme-provider|
HOOK					|fern-develop-hook|
HELPER					|fern-develop-helper|
RENDERER				|fern-develop-renderer|
COMPARATOR				|fern-develop-comparator|
LOGGER					|fern-develop-logger|
UTILITY					|fern-develop-utility|


=============================================================================
INTRODUCTION					*fern-develop-introduction*

This is documentation for |fern.vim| developer.


=============================================================================
FRI						*fern-develop-fri*

Fern Resource Identifier (FRI) is designed to be used in Vim's buffer name and
explained as the following:

  FRI = scheme "://" [ auth ] "/" path [ ";" query ][ "#" fragment ][$]

Where:

  scheme   = ALPHA { ALPHA | DIGIT | "_" }
  auth     = { pchar }
  path     = { segment "/" }
  query    = { pchar | "/" | ";" }
  fragment = { pchar | "/" | ";" }

And the definition of each sub-components are:

  pct-encoded = "%" HEXDIG HEXDIG
  reserved = gen-delims | sub-delims
  unreserved = ALPHA | DIGIT | "-" | "."| "_" | "~"
  gen-delims = ":" | "/" | ";" | "#" | "[" | "]" | "@"
  sub-delims = "!" | "$" | "&" | """ | "(" | ")" | "+" | "," | "="
  segment   = pchar { pchar }
  pchar     = { unreserved | pct-encoded | sub-delims | ":" | "@" }

FRI was desigend to remove the following characters which could not be used
in buffer names in Windows from URI definition:

  unusable   = "<" | ">" | "|" | "?" | "*"

Note that "fern" scheme may end with "$" to avoid unwilling filetype plugins.
For example, some filetype plugin add "BufRead *.vim ..." thus if the FRI ends
with ".vim", that autocmd is triggered without "$".

Developers can use the following function to parse/format FRIs.

							*fern#fri#new()*
fern#fri#new({partial})
	Create a FRI instance from {partial} |Dictionary|.
	Note that omitted fields in {partial} is filled with an empty string.

							*fern#fri#parse()*
fern#fri#parse({expr})
	Parse the {expr} (|String|) and return a FRI instance.
	The instance has the following attributes:

	"scheme"	A |String| scheme part
	"authority"	A |String| authority part
	"path"		A |String| path part
	"query"		A |Dict| query part
	"fragment"	A |String| fragment part

	Note that "fern" scheme always end with "$" thus the trailing "$" is
	removed from {expr} if scheme is "fern".

							*fern#fri#format()*
fern#fri#format({fri})
	Format a |String| representation of the {fri} instance.
	Note that "fern" scheme always end with "$" thus the trailing "$" is
	added to the result if scheme is "fern".
>
	echo fern#fri#format({
	      \ 'scheme': 'http',
	      \ 'authority': 'www.example.com',
	      \ 'path': 'foo/bar',
	      \ 'query': {},
	      \ 'fragment': '',
	      \})
	" -> https://www.example.com/foo/bar
<
							*fern#fri#encode()*
fern#fri#encode({str}[, {pattern}])
	Apply percent-encoding to characters which matches the {pattern} in
	the {str}. When the {pattern} is omitted, unusable characters and
	percent character itself in {str} are encoded.
	NOTE:
	The default {pattern} has changed from v1.16.0

							*fern#fri#decode()*
fern#fri#decode({str})
	Decode percent-encoding from the {str}.


=============================================================================
NODE						*fern-develop-node*

A node instance is a tree item which has the following attributes:

"name"		A |String| name of the node. This value is used in "__key"
		thus must be unique among nodes which has same "__owner".

"status"	A |Number| which indicates the node status. One of the
		followings:
		|g:fern#STATUS_NONE|	Leaf node
		|g:fern#STATUS_COLLAPSED|	Branch node (close)
		|g:fern#STATUS_EXPANDED|	Branch node (open)

"label"		A |String| used to display the node in a tree view.

"badge"		A |String| used to display the node badge in a tree view.
		Only first character is used in the default renderer.

"hidden"	A 1/0 to indicate if the node should be hidden. All hidden
		nodes become visible once fern enter hidden mode.

"bufname"	A |String| buffer name used to open the node or |v:null|.
		This value is used when users want to enter a branch node so
		scheme developers SHOULD assign a proper value to this
		attribute. Otherwise users cannot enter the branch node.

"concealed"	A |Dict| used as a namespace object to store complex objects
		which is not suitable to output.
		Developers MUST follow same convention of naming under this
		namespace as well.

"__processing"	A |Number| which indicate that the node is in processing.
		If the value is greater than 0, a spinner is displayed in sign
		area of the node to indicate that the node is processing.

"__key"		A |List| of |String| which represents the location of the
		node in the tree.
		This value is automatically assigned by fern and developers
		should NOT touch unless for debugging purpose.

"__owner"	An owner node instance of the node in the tree.
		This value is automatically assigned by fern and developers
		should NOT touch unless for debugging purpose.

"_{XXX}"	Any attribute starts from a single underscore (_) is opened
		for each scheme. Note that any complex value should be stored
		in "concealed" instead to avoid display error.

*g:fern#STATUS_NONE*
*g:fern#STATUS_COLLAPSED*
*g:fern#STATUS_EXPANDED*
	Constant |Number| which indicates a node status.
	STATUS_NONE means that the node is leaf and does not have any status.
	STATUS_COLLAPSED means that the node is branch and collapsed (closed).
	STATUS_EXPANDED means that the node is branch and expanded (opened).


=============================================================================
MAPPING						*fern-develop-mapping*

Fern provides global mappings under "autoload/fern/mapping" directory.
Mapping MUST provide an init function as "fern#mapping#{name}#init()" with
a boolean argument to disable default mappings.

Mappings under that directory are registered automatically when a filename has
listed in |g:fern#mapping#mappings| variable.

So 3rd party plugin MUST register mappings by add followings to plugin.vim
like:
>
	call add(g:fern#mapping#mappings, ['your_plugin'])
>
*g:fern#mapping#mappings*
	A |List| of globally available mapping names. 
	A target mapping MUST exist under "fern#mapping#" namespace.


=============================================================================
SCHEME						*fern-develop-scheme*

-----------------------------------------------------------------------------
PROVIDER				*fern-develop-scheme-provider*

Provider is a core instance to produce scheme plugin. The instance must has
the following methods.

				*fern-develop-scheme-provider.get_root()*
.get_root({url})		
	Return a (partial) node instance of the {url} (|String|).
	The node instance will be used as a root node of a tree.
	It throws error when no node is found for the {url}.

	The node instance MUST have the following attributes.

	"name"		The name of the node (required)
	"status"	1/0 to indicate if the node is branch (required)

	And may have the following attributes.

	"label"		Label to display the node in a tree view
	"hidden"	1/0 to indicate if the node should be hidden
	"bufname"	Buffer name used to open the node or |v:null|
	"concealed"	Namespace for storing complex object
	"_{ANY}"	Scheme specific variables (e.g. "_path" in file)

	The partial node will be filled by fern to become |fern-develop-node|.

				*fern-develop-scheme-provider.get_parent()*
.get_parent({node}, {token})
	Return a promise which is resolved to a parent node of the {node}.
	It resolves the {node} itself when the {node} does not have parent.

	The {token} is CancellationToken which can be used to cancel the
	internal process. Use ... to ignore that argument.

				*fern-develop-scheme-provider.get_children()*
.get_children({node}, {token})
	Return a promise which is resolved to a list of child nodes of the
	{node}. It rejects when the {node} is leaf node.

	The {token} is CancellationToken which can be used to cancel the
	internal process. Use ... to ignore that argument.

-----------------------------------------------------------------------------
MAPPING					*fern-develop-scheme-mapping*

Fern provides scheme mappings under "autoload/fern/scheme/{scheme}/mapping"
directory.  Mapping MUST provide an init function as 
"fern#scheme#{scheme}#mapping#{name}#init()" with a boolean argument to disable 
default mappings.

Mappings under that directory are registered automatically when a filename has
listed in |g:fern#scheme#{scheme}#mapping#mappings| variable.

So 3rd party plugin MUST register mappings by add followings to plugin.vim
like:
>
	call add(g:fern#scheme#file#mapping#mappings, ['your_plugin'])
>
*g:fern#scheme#{scheme}#mapping#mappings*
	A |List| of scheme available mapping names for {scheme}.
	A target mapping MUST exist under "fern#scheme#{scheme}#mapping#"
	namespace.


=============================================================================
HOOK						*fern-develop-hook*

Following hook will be emitted by |fern#hook#emit()| from fern itself.

"viewer:syntax" ({helper})
	Called when fern viewer has registered the syntax.
	The {helper} is a helper instance described in |fern-develop-helper|.

"viewer:highlight" ({helper})
	Called when fern viewer has registered the highlight.
	The {helper} is a helper instance described in |fern-develop-helper|.

"viewer:redraw" ({helper})
	Called when fern viewer has redrawed.
	The {helper} is a helper instance described in |fern-develop-helper|.

"viewer:remark" ({helper})
	Called when fern viewer has remarked.
	The {helper} is a helper instance described in |fern-develop-helper|.

"viewer:ready" ({helper})
	Called when fern viewer has ready, mean that the buffer has opened and
	all content has rendererd.
	The {helper} is a helper instance described in |fern-develop-helper|.


=============================================================================
HELPER						*fern-develop-helper*

A helper instance is used for writing features in mappings. Developers can
pass a helper instance to the first argument of functions by calling the
function with |fern#helper#call()| or create a new helper instance of the
current buffer by calling |fern#helper#new()|.

-----------------------------------------------------------------------------
VARIABLE				*fern-develop-helper-variable*

			*fern-develop-helper.fern*
.fern
	A fern instance which has the following attributes:

	"scheme"	A scheme name used to determine "provider"
	"source"	A cancellation token source to cancel requests
	"provider"	A provider instance for the fren tree
	"renderer"	A renderer instance to sort nodes
	"comparator"	A comparator instance to sort nodes
	"root"		A root node instance
	"nodes"		A |List| of nodes which is handled in the tree
	"visible_nodes"	A |List| of nodes which is displayed in the tree
	"marks"		A |List| of marks
	"hidden"	1/0 to indicate if hidden mode is on
	"include"	A |List| of |String| to include nodes
	"exclude"	A |List| of |String| to exclude nodes

	Develoeprs can refer each attributes but Do NOT modify.

			*fern-develop-helper.bufnr*
.bufnr
	A buffer number where the target fern instance is associated.

			*fern-develop-helper.winid*
.winid
	A window number where a target fern instance is associated.
	Use |fern-develop-helper.sync.winid()| to get proper value.

			*fern-develop-helper.STATUS_NONE*
			*fern-develop-helper.STATUS_COLLAPSED*
			*fern-develop-helper.STATUS_EXPANDED*
.STATUS_NONE
.STATUS_COLLAPSED
.STATUS_EXPANDED
	Constant variable for "status" of node instance.

-----------------------------------------------------------------------------
SYNC METHODS				*fern-develop-helper.sync*

Following methods are executed synchronously.

			*fern-develop-helper.sync.winid()*
.sync.winid()
	Return |winid| where a target fern instance is associated.

			*fern-develop-helper.sync.echo()*
.sync.echo({message})
	Display a temporary |String| {message}.

			*fern-develop-helper.sync.echomsg()*
.sync.echomsg({message})
	Display a permanent |String| {message}.

			*fern-develop-helper.sync.get_root_node()*
.sync.get_root_node()
	Return a root node instance.

			*fern-develop-helper.sync.get_cursor_node()*
.sync.get_cursor_node()
	Return a node under the cursor.

			*fern-develop-helper.sync.get_marked_nodes()*
.sync.get_marked_nodes()
	Return a list of nodes which has marked.

			*fern-develop-helper.sync.get_selected_nodes()*
.sync.get_selected_nodes()
	Return a list of nodes 1) which has marked when at least one marked
	node exists 2) a node under the cursor.
	This is equivalent to the following code
>
	function! s:get_selected_nodes(helper) abort
	  let nodes = a:helper.sync.get_selected_nodes()
	  return empty(nodes) ? [a:helper.sync.get_cursor_node()] : nodes
	endfunction
<
			*fern-develop-helper.sync.get_cursor()*
.sync.get_cursor()
	Return a list which indicates the cursor position of a binded window.
	Note that the value is slightly different from the value from
	|getcurpos()| or whatever.

			*fern-develop-helper.sync.set_cursor()*
.sync.set_cursor({cursor})
	Move cursor of a binded window to the {cursor}.

			*fern-develop-helper.sync.save_cursor()*
.sync.save_cursor()
	Save cursor position to restore. It saves the node under cursor to
	restore cursor even after the content changes.

			*fern-develop-helper.sync.restore_cursor()*
.sync.restore_cursor()
	Restore saved cursor position by searching a corresponding node.

			*fern-develop-helper.sync.cancel()*
.sync.cancel()
	Emit cancel request through cancellation token and assign a new
	cancellation token to the tree for later processes.

			*fern-develop-helper.sync.is_drawer()*
.sync.is_drawer()
	Returns 1 if the fern buffer is shown in a project drawer. Otherwise
	it returns 0.

			*fern-develop-helper.sync.is_left_drawer()*
.sync.is_left_drawer()
	Returns 1 if the fern buffer is shown in a project drawer (left).
	Otherwise it returns 0.

			*fern-develop-helper.sync.is_right_drawer()*
.sync.is_right_drawer()
	Returns 1 if the fern buffer is shown in a project drawer (right).
	Otherwise it returns 0.

			*fern-develop-helper.sync.get_scheme()*
.sync.get_scheme()
	Return |String| which represent the scheme name of the fern buffer.

			*fern-develop-helper.sync.process_node()*
.sync.process_node({node})
	Mark the {node} PROCESSING and return a function to restore.
	The PROCESSING nodes are displayed with a spinner |sign|.
>
	function! s:map_slow_operation(helper) abort
	  let node = a:helper.sync.get_cursor_node()
	  let l:Done = a:helper.sync.process_node(node)
	  return s:slow_operation(node).finally({ -> Done() })
	endfunction
<
			*fern-develop-helper.sync.focus_node()*
.sync.focus_node({key}[, {options}])
	Focus (move cursor on) a node identified by the {key}.
	The following options are available in the {options}.

	"offset"	A |Number| for line offset.
	"previous"	A node instance or |v:null|. If a node instance has
			specified, it focus node only when the current node
			has not changed from the specified previous one.

-----------------------------------------------------------------------------
ASYNC METHODS				*fern-develop-helper.async*

Following methods are executed asynchronously and return a promise.

			*fern-develop-helper.async.sleep()*
.async.sleep({ms})
	Return a promise which will resolves to 0 after {ms} milliseconds.

			*fern-develop-helper.async.redraw()*
.async.redraw()
	Return a promise to redraw the content.

			*fern-develop-helper.async.remark()*
.async.remark()
	Return a promise to remark the content.

			*fern-develop-helper.async.get_child_nodes()*
.async.get_child_nodes({key})
	Return a promise which will resolves to child nodes of the {key} node.

			*fern-develop-helper.async.set_mark()*
.async.set_mark({key}, {value})
	Return a promise to set mark to a node identified by the {key}.

			*fern-develop-helper.async.set_hidden()*
.async.set_hidden({value})
	Return a promise to set hidden.

			*fern-develop-helper.async.set_include()*
			*fern-develop-helper.async.set_exclude()*
.async.set_include({pattern})
.async.set_exclude({pattern})
	Return a promise to set include/exclude.

			*fern-develop-helper.async.update_nodes()*
.async.update_nodes({nodes})
	Return a promise to update nodes to the {nodes}.

			*fern-develop-helper.async.update_marks()*
.async.update_marks({marks})
	Return a promise to update marks to the {marks}.

			*fern-develop-helper.async.expand_node()*
.async.expand_node({key})
	Return a promise to expand a node identified by the {key}.
	It reloads the node instead when the node has expanded or leaf.

			*fern-develop-helper.async.collapse_node()*
.async.collapse_node({key})
	Return a promise to collapse a node identified by the {key}.
	It reloads the node instead when the node has collapsed or leaf.

			*fern-develop-helper.async.reload_node()*
.async.reload_node({key})
	Return a promise to reload a node identified by the {key} and it's
	descended.

			*fern-develop-helper.async.reveal_node()*
.async.reveal_node({key})
	Return a promise to reveal a node identified by the {key}.
	The term "reveal" here means "recursively expand nested nodes until
	reached to the target node."

			*fern-develop-helper.async.enter_tree()*
.async.enter_tree({node})
	Return a promise to enter a tree which root node become the {node}.
	Note that "bufname" of the {node} must be properly configured to use
	this feature.

			*fern-develop-helper.async.leave_tree()*
.async.leave_tree()
	Return a promise to enter a tree which root node become a parent node
	of the current root node.
	Note that "bufname" of the parent node must be properly configured to
	use this feature.

			*fern-develop-helper.async.collapse_modified_nodes()*
.async.collapse_modified_nodes({nodes})
	Return a promise to collapse {nodes}.
	It does NOT reload the node instead when the node has collapsed or
	leaf, not like |fern-develop-helper.async.collapse_node()|.
	It is used to collapse modified nodes to solve issue #103.


=============================================================================
COMPARATOR					*fern-develop-comparator*

Comparator is an instance which has the following methods to sort nodes in an
entire tree.

					*fern-develop-comparator.compare()*
.compare({lhs}, {rhs})
	Compare {lhs} and {rhs} nodes and return -1, 0, or 1.

*g:fern#comparators*
	comparator and the value is a function reference which return a
	comparator instance when called.
	Default: {}

A 3rd-party plugin MUST extend |g:fern#comparators| in plugin
directory to register a comparator itself like:
>
	if exists('g:loaded_fern_comparator_foo')
	  finish
	endif
	let g:loaded_fern_comparator_foo = 1

	call extend(g:fern#comparators, {
	      \ 'foo': function('fern#comparator#foo#new'),
	      \})
<
See https://github.com/lambdalisue/fern-comparator-lexical.vim as example.


=============================================================================
RENDERER					*fern-develop-renderer*

Renderer is an instance which has the following methods to render a list of
nodes as a tree.

					*fern-develop-renderer.render()*
.render({nodes})
	Return a promise which is resolved to:

	  a list of |String|, or
	  if |g:fern#enable_textprop_support| is 1, a list of |Dictionary|
		with the following entries:
	    text  |String| with the text to display.
	    props A list of text properties (|Dictionary|). Optional. Not supported
	          for Neovim. Each entry is a dictionary, like the third argument
	          of |prop_add()|, but specifying a column with a "col" entry.

	Change (v1.6.0):~
	Second argument ({marks}) has removed.

					*fern-develop-renderer.index()*
.index({lnum})
	Return a corresponding index (|Number|) of {lnum}. It is used to find
	a node under a cursor.

					*fern-develop-renderer.lnum()*
.lnum({index})
	Return a corresponding lnum (|Number|) of {index}. It is used to find
	a line number where a node has displayed.

					*fern-develop-renderer.syntax()*
.syntax()
	Define syntax on a current buffer. The function is called posterior to
	'filetype' specification and every after |BufReadCmd| has fired.

					*fern-develop-renderer.highlight()*
.highlight()
	Define highlight on a current buffer. The function is called prior to
	'filetype' specification and every after |ColorScheme| has fired.

*g:fern#renderers*
	A |Dict| to define external renderers. The key is a name of renderer
	and the value is a function reference which return a renderer instance
	when called.
	Default: {}

A 3rd-party plugin MUST extend |g:fern#renderers| to register a
renderer itself like:
>
	" plugin/fern_renderer_foo.vim
	if exists('g:loaded_fern_renderer_foo')
	  finish
	endif
	let g:loaded_fern_renderer_foo = 1

	call extend(g:fern#renderers, {
	      \ 'foo': function('fern#renderer#foo#new'),
	      \})
<
See https://github.com/lambdalisue/fern-renderer-nerdfont.vim as example.

=============================================================================
LOGGER						*fern-develop-logger*

Use following functions to log events.

The log will be saved in |g:fern#logfile| or displayed with |echomsg| if
|v:null| has specified to the variable.

						*fern#logger#tap()*
fern#logger#tap({value}, {object}...)
	Log |String| representation of {value} and {object}s when
	|g:fern#loglevel| beyonds |g:fern#logger#DEBUG| and return {value}.
	It is useful to used in Promise's "then()" like
>
	call s:Promise.resolve("foo")
	      \.then(function('fern#logger#tap')))
	      \.then({ v -> fern#logger#tap(v) })
	      \.then({ v -> fern#logger#tap(v, 'bar') })
	" 'foo'
	" 'foo'
	" 'foo bar'
<
						*fern#logger#debug()*
fern#logger#debug({object}...)
	Log |String| representation of {object}s when |g:fern#loglevel|
	beyonds |g:fern#logger#DEBUG|.

						*fern#logger#info()*
fern#logger#info({object}...)
	Log |String| representation of {object}s when |g:fern#loglevel|
	beyonds |g:fern#logger#INFO|.

						*fern#logger#warn()*
fern#logger#warn({object}...)
	Log |String| representation of {object}s when |g:fern#loglevel|
	beyonds |g:fern#logger#WARN|.

						*fern#logger#error()*
fern#logger#error({object}...)
	Log |String| representation of {object}s when |g:fern#loglevel|
	beyonds |g:fern#logger#ERROR|.


=============================================================================
UTILITY						*fern-develop-utility*

						*fern#action#call()*
fern#action#call({name}[, {options}])
	Call an action {name} of the current buffer.
	The following attributes are available in {options}

	"capture"	1 to enable capture mode which write output messages
			into a new empty buffer instead
	"verbose"	1 to execute action with 'verbose' (1) mode.

						*fern#action#list()*
fern#action#list([{conceal}])
	Return a |List| of available actions. Each item of the list is tuple
	like [{lhs}, {name}, {rhs}] where {lhs} is an actual mapping, {name}
	is an action name, and {rhs} is a <Plug> mapping like:
>
	assert_equal(fern#action#list(), [
	      \ ['a', 'choice', '<Plug>(fern-action-choice)'],
	      \ ['.', 'repeat', '<Plug>(fern-action-repeat)'],
	      \ ['?', 'help', '<Plug>(fern-action-help)'],
	      \ ['', 'help:all', '<Plug>(fern-action-help:all)'],
	      \])
<
	When {conceal} is truthy value, it remove items which contains ":" in
	it's name and no actual mapping (like "help:all" in above example.)

						*fern#hook#add()*
fern#hook#add({name}, {callback}[, {options}])
	Add the {callback} to the {name} hook.
	The {options} may contains the followings:

	"id"		A |String| which is used to remove the hook.
			Developer must specify this to remove a hook
			later.
	"once"		1 to remove the hook after initial call.
			Default: 0
>
	call fern#hook#add('BufRead', { -> execute('echomsg "Ready"', '') })
<
	See |fern-develop-hook| for available hook {name}.

						*fern#hook#remove()*
fern#hook#remove({name}[, {id}])
	Remove the {id} hook or all hooks when missing for the {name}.

						*fern#hook#emit()*
fern#hook#emit({name}[, {args}...])
	Emit the {name} hooks with the {args}.
>
	call fern#hook#add('t', { -> execute('echomsg string(a:000)', '') })
	call fern#hook#emit('t', 'Hello', 'World')
	" -> ['Hello', 'World']
<
						*fern#util#compare()*
fern#util#compare({i1}, {i2})
	Compare {i1} and {i2} and return -1, 0, or 1.
	This is equivalent to the following code
>
	i1 == i2 ? 0 : i1 > i2 ? 1 : -1
<

						*fern#util#sleep()*
fern#util#sleep({ms})
	Return a promise which will be resolved after {ms} milliseconds.

						*fern#util#deprecated()*
fern#util#deprecated({name}[, {alternative}])
	Log warning that {name} has deprecated. It tells users that they
	should use {alternative} if specified.

						*fern#util#obsolete()*
fern#util#obsolete({name}[, {alternative}])
	Throw error that {name} has obsolete. It tells users that they
	must use {alternative} if specified.


=============================================================================
vim:tw=78:fo=tcq2mM:ts=8:ft=help:norl
./doc/fern.txt	[[[1
1382
*fern.txt*			General purpose asynchronous tree explorer

Author:  Alisue <lambdalisue@hashnote.net>
License: MIT license

=============================================================================
CONTENTS						*fern-contents*

INTRODUCTION				|fern-introduction|
  FEATURES				|fern-features|
  PLUGINS				|fern-plugins|
USAGE					|fern-usage|
  ACTION				|fern-action|
  CUSTOM				|fern-custom|
COMPARATOR				|fern-comparator|
RENDERER				|fern-renderer|
INTERFACE				|fern-interface|
  VARIABLE				|fern-variable|
  COMMAND				|fern-command|
  FUNCTION				|fern-function|
  AUTOCMD				|fern-autocmd|
  HIGHLIGHT				|fern-highlight|
MAPPING					|fern-mapping|
  GLOBAL				|fern-mapping-global|
  FILE					|fern-mapping-file|
  DICT					|fern-mapping-dict|
GLOSSARY				|fern-glossary|
DEVELOPMENT				|fern-development|


=============================================================================
INTRODUCTION						*fern-introduction*

*fern.vim* (fern) is a general purpose asynchronous tree explorer written in
pure Vim script. It provides "file" scheme in default to use it as a file
explorer.

-----------------------------------------------------------------------------
FEATURES						*fern-features*

No external dependencies~
	Fern is written in pure Vim script without any external libraries
	(note that vim-jp/vital.vim is bundled, not external dependencies) so
	users do NOT need to install anything rather than fern.vim itself.
	Exception: "trash" feature in Linux.
	https://github.com/lambdalisue/vital-Whisky/issues/31

Asynchronous~
	Fern uses asynchronous technique to perform most of operations so Vim
	would not freeze during operations. It is probably obvious in Windows
	while file operations in Windows are relatively slow.

Split windows or project drawer~
	Fern supports both styles; split windows (e.g. netrw) and project
	drawer (e.g.  NERDTree); officially.

Buffer name base~
	Fern is developed based on |BufReadCmd| technique like netrw. Thus any
	buffer starts from "fern://" are handled by fern and required
	arguments and options are read from the buffer name. That's why fern
	integrate well with |session|.

Action~
	Fern provides operation as action. When user hit "?", all actions and
	corresponding mapping (if exist) are shown. When user hit "a", an
	action prompt will popped up and user can input an action to execute.
	So users don't have to remember complex mappings to execute operation
	which is not often required.

Window selector~
	Fern has an internal window selector which works like
	t9md/vim-choosewin.  Users can quickly select which window to open a
	selected node.
	See |hl-FernWindowSelectIndicator| and |hl-FernWindowSelectStatusLine|
	to customize the statusline when selecting a window.
	https://github.com/t9md/vim-choosewin

Renamer (A.k.a exrename)~
	Fern has an internal renamer which works like "exrename" in
	Shougo/vimfiler.  Users can edit multiple path of nodes in Vim's
	buffer and ":w" to apply changes to actual nodes (file, directory,
	bookmark, etc.)
	https://github.com/Shougo/vimfiler

System CRUD operations ("file" scheme)~
	Fern supports file system CRUD operations. Users can create, delete,
	rename files/directories through fern.

System program support ("file" scheme)~
	Fern supports to open a file/directory through a system default
	program. So it's quite easy to open a directory with Explorer
	(Windows), Finder (macOS), or whatever.

System trash-bin support ("file" scheme)~
	Fern supports system trash-bin by PowerShell (Windows), osascript
	(macOS), and 3rd party applications (Linux). Any files/directories
	deleted by "trash" action are sent to system trash-bin rather than
	actual delete.

-----------------------------------------------------------------------------
PLUGINS							*fern-plugins*

Most of functionalities are provided as plugins in fern.
So visit the following URL to find fern plugins.

https://github.com/topics/fern-vim-plugin

For example, following features are provided as official plugins

- Netrw hijack (Use fern as a default file explorer)
- Nerd Fonts integration (https://www.nerdfonts.com/)
- Git integration (show status, touch index, ...)
- Bookmark feature

And lot more!


=============================================================================
USAGE							*fern-usage*

Open fern at the current working directory by
>
	:Fern .
<
Or a parent directory of the current buffer by
>
	:Fern %:h
<
On a fern buffer, hit

	"?"	List mappings/actions available
	"a"	Open a prompt to input action to execute

-----------------------------------------------------------------------------
ACTION							*fern-action*

Action is a special mapping which is defined on a fern buffer and looks like:

	<Plug>(fern-action-{name})

where {name} is a name of the action.

Note that any mappings defined in user custom code (|fern-custom|) are
registered as action as well if the name of the mapping followed above rule.

							*fern-action-mapping*
Fern defines the following mappings for actions:

	"?"	List mappings/actions available
	"a"	Open a prompt to input action to execute
	"."	Repeat previous action which has executed from a prompt

Note that |g:fern#disable_default_mappings| does not affect mappings above.
Users have to define alternative mappings to disable default mappings like:
>
	" Use g? to show help instead of ?
	nmap <buffer> g? <Plug>(fern-action-help)
<
							*fern-action-capture*
Use "capture" to redirects an action output to a separate buffer like:
>
	action: capture help
<
							*fern-action-verbose*
Use "verbose" to execute an action in |verbose| mode like:
>
	action: verbose expand
<

-----------------------------------------------------------------------------
CUSTOM							*fern-custom*

Use |FileType| |autocmd| with "fern" like:
>
	function! s:init_fern() abort
	  " Write custom code here
	endfunction

	augroup my-fern
	  autocmd! *
	  autocmd FileType fern call s:init_fern()
	augroup END
<
The autocmd will be called AFTER fern buffer has initialized but BEFORE any
content had loaded.
							*fern-custom-alias*
Fern provides some features as mapping alias. For example, you may found
entries like below by "?":
>
	e                         open       <Plug>(fern-action-open)
	<Plug>(fern-action-open)  open:edit  <Plug>(fern-action-open:edit)
<
Above mean that when you hit "e", the "open" action is executed and the "open"
action execute "open:edit" action.
So if you want to use "open:split" action instead of "open:edit" when you
hit "e", add the following code:
>
	" Use 'open:split' instead of 'open:edit' for 'open' action
	nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:split)
<
							*fern-custom-wait*
Fern provide |<Plug>(fern-wait)| mapping as a helper.
For example, following execute "tcd:root" action every after "leave" action.
>
	nmap <buffer> <Plug>(fern-my-leave-and-tcd)
	      \ <Plug>(fern-action-leave)
	      \ <Plug>(fern-wait)
	      \ <Plug>(fern-action-tcd:root)
<
Without <Plug>(fern-wait), the "tcd:root" action will be invoked before actual
"leave" while "leave" action is asynchronous.

							*fern-custom-smart*
Fern provide following mapping helper functions:

	|fern#smart#leaf()|	Return a mapping expression determined by a
				status of a current cursor node

	|fern#smart#drawer()|	Return a mapping expression determined by a
				style of a current fern window

	|fern#smart#scheme()|	Return a mapping expression determined by a
				scheme of a current fern tree

For example, following execute "open" on leaf but "expand" on branch.
>
	nmap <buffer><expr> <Plug>(fern-my-open-or-expand)
	      \ fern#smart#leaf(
	      \   "<Plug>(fern-action-open)",
	      \   "<Plug>(fern-action-expand)",
	      \ )
<
See https://github.com/lambdalisue/fern.vim/wiki/ for custom tips.


=============================================================================
COMPARATOR						*fern-comparator*

Comparator is an object to sort nodes for making a tree.
Users can create user custom comparator to change the order of appearance of
nodes in the tree.
See |fern-develop-comparator| for more details.


=============================================================================
RENDERER						*fern-renderer*

Renderer is an object to render nodes as a tree like (default renderer):
>
	fern.vim
	|- autoload
	 |+ fern
	 |+ vital
	 |  fern.vim
	|- doc
	 |  fern-develop.txt
	 |  fern.txt
	 |  tags
	|+ ftplugin
	|+ plugin
	|+ test
	|  LICENSE
	|  README.md
<
Users can customize above appearance by the following variables.

*g:fern#renderer#default#leading*
	A |String| used as leading space unit (one indentation level.)
	Default: " "

*g:fern#renderer#default#root_symbol*
	A |String| used as a symbol of root node.
	Default: ""

*g:fern#renderer#default#leaf_symbol*
	A |String| used as a symbol of leaf node (non branch node like file).
	Default: "|  "

*g:fern#renderer#default#collapsed_symbol*
	A |String| used as a symbol of collapsed branch node.
	Default: "|+ "

*g:fern#renderer#default#expanded_symbol*
	A |String| used as a symbol of expanded branch node.
	Default: "|- "

See |FernHighlight| and |fern-highlight| to change pre-defeined |highlight|.

Or create user custom renderer to change the appearance completely.
See |fern-develop-renderer| for more details.


=============================================================================
INTERFACE						*fern-interface*

-----------------------------------------------------------------------------
VARIABLE						*fern-variable*

*g:fern_disable_startup_warnings*
	Set 1 to disable startup warning messages.
	Default: 0

*g:fern#profile*
	Set 1 to enable fern profiling mode.
	Default: 0

*g:fern#logfile*
	A path |String| to log messages or |v:null| to log messages via
	|echomsg|.
>
	let g:fern#logfile = "~/fern.tsv"
<
	Default: |v:null|

*g:fern#loglevel*
	A |Number| to indicate a current loglevel. Use the following constant
	variable to set loglevel.
	*g:fern#DEBUG*		Debug level
	*g:fern#INFO*		Info level
	*g:fern#WARN*		Warn level
	*g:fern#ERROR*		Error level
	Default: |g:fern#ERROR|

*g:fern#opener*
	A default |fern-opener| used to open a fern buffer itself in split
	windows style.
	Default: 'edit'

*g:fern#hide_cursor*
	Set 1 to hide cursor and forcedly enable |cursorline| to visualize the
	cursor node. The |cursorline| is automatically enabled when the focus
	is on the buffer and automatically disabled when the cursor is out of
	the buffer.
	Note that Neovim prior to 0.5.0 cannot hide the cursor thus faint
	vertical bar is used instead.

*g:fern#keepalt_on_edit*
	Set 1 to apply |keepalt| on the "open:edit" action to keep an
	|alternate-file| in a split windows style like:
>
        g:fern#keepalt_on_edit =      0            1
	                         +---------+  +---------+
	:edit A                  |  %:A    |  |  %:A    |
	                         |  #:     |  |  #:     |
	                         +---------+  +---------+
	                              v            v
	                         +---------+  +---------+
	:Fern .                  |  %:fern |  |  %:fern |
	                         |  #:A    |  |  #:A    |
	                         +---------+  +---------+
	                              v            v
	                         +---------+  +---------+
	open:edit                |  %:B    |  |  %:B    |
	on 'B'                   |  #:fern |  |  #:A    |
	                         +---------+  +---------+
<
	Default: 0

*g:fern#keepjumps_on_edit*
	Set 1 to apply |keepjumps| on the "open:edit" action to keep a
	|jumplist| in a split windows style like:
>
        g:fern#keepjumps_on_edit =      0            1
	                           +---------+  +---------+
	                           |  0:A    |  |  0:A    |
	:edit A                    |  1:     |  |  1:     |
	                           |  2:     |  |  2:     |
	                           +---------+  +---------+
	                                v            v
	                           +---------+  +---------+
	                           |  0:fern |  |  0:Fern |
	:Fern .                    |  1:A    |  |  1:A    |
	                           |  2:     |  |  2:     |
	                           +---------+  +---------+
	                                v            v
	                           +---------+  +---------+
	                           |  0:B    |  |  0:B    |
	open:edit                  |  1:fern |  |  1:A    |
	on 'B'                     |  2:A    |  |  2:     |
	                           +---------+  +---------+
<
	Note that even with this option, any |jump-motions| performed in a
	fern buffer updates |jumplist|. For example, if user move cursors by
	"G" in above situation, |CTRL-O| in last step jumps to the fern buffer
	rather than a buffer "A" because a jump for "G" has recoreded in
	|jumplist|.
	Default: 0

*g:fern#disable_default_mappings*
	Set 1 to disable default mappings
	Note that this variable does not affect mappings for actions.
	See |fern-action-mapping| for more detail.
	Default: 0

*g:fern#disable_viewer_spinner*
	Set 1 to disable viewer spinner shown on a sign column.
	Note that the default value will be 1 if CUI Vim is running on
	Windows. See https://github.com/lambdalisue/fern.vim/issues/256 for
	detail.

*g:fern#disable_viewer_auto_duplication*
	Set 1 to disable viewer auto duplication on |WinEnter| autocmd.
	The duplication is mainly occured when user execute |split| or
	|vsplit| command to duplicate window.

*g:fern#disable_drawer_auto_winfixwidth*
	Set 1 to disable automatically enable 'winfixwidth' to drawer on
	|BufEnter| autocmd. Note that it automatically set 'nowinfixwidth' on
	the autocmd when there is only one window.

	Default: 0

*g:fern#disable_drawer_auto_resize*
	Set 1 to disable automatically resize drawer on |BufEnter| autocmd.

	Note that this feature is automatically disabled on floating windows
	of Neovim to avoid unwilling resize reported as #294
	https://github.com/lambdalisue/fern.vim/issues/294

	Default: 0

*g:fern#disable_drawer_hover_popup*
	Set 1 to disable popups shown when the name of a node extends beyond
	the width of the drawer.

	Note that this feature is required the |win_execute| and
	popup/floatwin features.

	Default: 0

*g:fern#disable_drawer_tabpage_isolation*
	Set 1 to disable the drawer tabpage isolation.

        If disabled, there is only one left or right drawer across the all the
        windows and tabs for a given VIM instance.

        Default: 0

*g:fern#disable_drawer_smart_quit*
	Set 1 to disable smart quit behavior when there are only two buffer
	remains (one is for the drawer styled fern window.)
	The smart quit behavior is something like below (assume that #
	indicate the cursor position.)
>
	g:fern#disable_drawer_smart_quit = 0

	:Fern . -drawer -stay		+--+---------------+
					|FE|#              |
					|RN|               |
					+--+---------------+
	:q				Quit vim

	:Fern . -drawer -stay -keep	+--+---------------+
					|FE|#              |
					|RN|               |
					+--+---------------+
	:q				+------------------+
					|FE|# (new buffer) |
					|RN|               |
					+------------------+

	g:fern#disable_drawer_smart_quit = 1

	:Fern . -drawer -stay		+--+---------------+
					|FE|#              |
					|RN|               |
					+--+---------------+
	:q				+------------------+
					|FE                |
					|RN                |
					+------------------+
<
	Default: 0

*g:fern#disable_drawer_auto_restore_focus*
	Set 1 to disable automatic focus restore on drawer close.
	The behavior changes like: (# indicate the cursor)
>
	g:fern#disable_drawer_auto_restore_focus = 0
	                        +---------------+---------------+
	                        |               |#              |
	                        |               |               |
	                        +---------------+---------------+
	:Fern . -drawer -stay   +----+------------+-------------+
	                        |    |            |#            |
	                        |    |            |             |
	                        +----+------------+-------------+
	:Fern . -drawer -toggle +---------------+---------------+
	                        |               |#              |
	                        |               |               |
	                        +---------------+---------------+

	g:fern#disable_drawer_auto_restore_focus = 1
	                        +---------------+---------------+
	                        |               |#              |
	                        |               |               |
	                        +---------------+---------------+
	:Fern . -drawer -stay   +----+------------+-------------+
	                        |    |            |#            |
	                        |    |            |             |
	                        +----+------------+-------------+
	:Fern . -drawer -toggle +---------------+---------------+
	                        |#              |               |
	                        |               |               |
	                        +---------------+---------------+
<
	Default: 0

*g:fern#default_hidden*
	Set 1 to enter hidden mode (show hidden files) in default.
	Default: 0

*g:fern#default_include*
	A default |String| pattern used to filter nodes (include).
	Default: ''

*g:fern#default_exclude*
	A default |String| pattern used to filter nodes (exclude).
	Default: ''

*g:fern#renderer*
	A |String| name of renderer used to render tree items. Allowed value
	is a key of |g:fern#renderers|.
	Default: "default"

*g:fern#enable_textprop_support*
	If set to 1, renderers may return lines of text with text properties.
	May incur slight performance penalty. See |fern-develop-renderer|.
	Default: 0

*g:fern#comparator*
	A |String| name of comparator used to sort tree items. Allowed value
	is a key of |g:fern#comparators|.
	Default: "default"

*g:fern#drawer_width*
	A |Number|, the default width of the drawer window.
	Default: 30

*g:fern#drawer_keep*
	A |Boolean| which indicate whether the last fern window should be keep
	open or close.
	Default: |v:false|

*g:fern#drawer_hover_popup_delay*
	A |Number| value to specify the delay time to show the hover popup.
	See |g:fern#disable_drawer_hover_popup|
	Default: |0|

*g:fern#mark_symbol*
	A |String| which is used as a mark symbol text.
	Note that users must restart Vim to apply changes.
	Default: "*"

*g:fern#scheme#file#show_absolute_path_on_root_label*
	A |Boolean| to show an absolute path of the root node of "file" scheme
	as a label of the node.
	Default: 0

*g:fern#disable_auto_buffer_delete*
	A |Number| value that specifies whether to synchronize file removes to the buffer
	Default: 0

*g:fern#disable_auto_buffer_rename*
	A |Number| value that specifies whether to synchronize file renames to the buffer
	Default: 0

*g:fern#window_selector_use_popup*
	A |Boolean| which use popup/float window to select window.
	See |fern-glossary-window-selector|
	Default: 0

-----------------------------------------------------------------------------
COMMAND							*fern-command*

							*:Fern*
:Fern {url} [-opener={opener}] [-stay] [-wait] [-reveal={reveal}]
	Open a fern buffer in split windows style with the {opener}.
	If -stay options is specified, the focus stays on a window where the
	command has executed. If -wait option is specified, the command wait
	synchronously until the fern buffer become ready.

							*fern-reveal*
	If {reveal} is specified, parent nodes of the node which is identified
	by the {reveal} are expanded and the node will be focused.
	The {reveal} must be a relative path separated by "/" from the
	specfied {url}.
	Note that if the {url} is for "file" scheme, an absolute path can be
	specified to the {reveal}.
							*fern-opener*
	One of the following value is available for the {opener}:

	"select"	Select which window to open a buffer
	"split"		Open a buffer by |split|
	"vsplit"	Open a buffer by |vsplit|
	"tabedit"	Open a buffer by |tabedit|
	"edit"		Open a buffer by |edit| or fail when the buffer is
			|modified|
	"edit/split"	Open a buffer by |edit| or |split| when the buffer is
			|modified|
	"edit/vsplit"	Open a buffer by |edit| or |vsplit| when the buffer is
			|modified|
	"edit/tabedit"	Open a buffer by |edit| or |tabedit| when the buffer
			is |modified|

	Additionally, any modifiers (|mods|) are allowd to be prepend (e.g.
	"topleft split".)

	Note that the command can be followed by a '|' and another command.

							*:Fern-drawer*
:Fern {url} -drawer [-width={width}] [-keep] [-toggle] [-right]...
	Open a fern buffer in project drawer style with the {width}.

	If the {width} is specified, the width of the window is regulated to
	the specified value. (See |g:fern#drawer_width|)
	If "-keep" option is specified, the buffer won't close even if only
	this window exists. (See |g:fern#drawer_keep|)
	If "-toggle" option is specified, an existing fern buffer will be
	closed rather than opening a new one.
	If "-right" option is specified, the drawer is placed on the right
	side.

	See |:Fern| for other arguments and options. Note that -opener options
	is ignored for project drawer style.

							*:FernDo*
:FernDo {expr...} [-drawer] [-right] [-stay]
	Focus a next fern viewer and execute {expr...}. It does nothing if no
	next fern viewer is found.
	If "-drawer" option is specified, it focus and execute only a project
	drawer style fern.
	If "-right" option is specified, the drawer on the right side is used.
	If "-stay" option is specified, it stay focus after execution.
	Note that the command can be followed by a '|' and another command.

							*:FernReveal*
:FernReveal {reveal} [-wait]				BUFFER LOCAL
	Reveal {reveal} on a current fern viewer. Note that this command
	exists only in a fern viewer buffer.
	If "-wait" option is specified, the command wait synchronously until
	the node specified has revealed.
	Note that the command can be followed by a '|' and another command.

-----------------------------------------------------------------------------
FUNCTION						*fern-function*

							*fern#version()*
fern#version()
	Show fern version itself.

							*fern#smart#leaf()*
fern#smart#leaf({leaf}, {collapsed}[, {expanded}])
	Return one of a given mapping expression determined by a "status" of a
	current cursor node. If the node is leaf, the {leaf} is returned.
	If the node is branch and collapsed, the {collapsed} is returned. If
	the node is branch and expanded, the {expanded} or {collapsed} is
	returned.
>
	" Perform 'open' on leaf node and 'enter' on branch node
	nmap <buffer><expr>
	      \ <Plug>(fern-my-open-or-enter)
	      \ fern#smart#leaf(
	      \   "<Plug>(fern-action-open)",
	      \   "<Plug>(fern-action-enter)",
	      \ )

	" Perform 'open' on leaf node, 'expand' on collapsed node, and
	" 'collapse' on expanded node.
	nmap <buffer><expr>
	      \ <Plug>(fern-my-open-or-expand-or-collapse)
	      \ fern#smart#leaf(
	      \   "<Plug>(fern-action-open)",
	      \   "<Plug>(fern-action-expand)",
	      \   "<Plug>(fern-action-collapse)",
	      \ )
<
							*fern#smart#drawer()*
fern#smart#drawer({drawer}, {explorer})
fern#smart#drawer({drawer}, {drawer-right}, {explorer})
	Return one of a given mapping expression determined by the style of
	a current buffer. If the current buffer is drawer, the {drawer} is
	returned. Otherwise the {explorer} is returned.
>
	" Perform 'expand' on drawer and 'enter' on explorer
	nmap <buffer><expr>
	      \ <Plug>(fern-expand-or-enter)
	      \ fern#smart#drawer(
	      \   "<Plug>(fern-action-expand)",
	      \   "<Plug>(fern-action-enter)",
	      \ )
<
							*fern#smart#scheme()*
fern#smart#scheme({default}, {schemes})
	Return one of a given mapping expression determined by the scheme of
	a current buffer. The {schemes} is a |Dict| which key is a name of
	scheme and the value is mapping expression. If no corresponding
	key-value found in {schemes}, the value of {default} is returned.
>
	" Execute 'Fern bookmark:///' or back to a previous file if the
	" scheme is already 'bookmark'
	nmap <buffer><expr><silent>
	      \ <C-^>
	      \ fern#smart#scheme(
	      \   ":\<C-u>Fern bookmark:///\<CR>",
	      \   {
	      \     'bookmark': "\<C-^>",
	      \   },
	      \ )

-----------------------------------------------------------------------------
AUTOCMD							*fern-autocmd*

						*FernHighlight*
FernHighlight
	Invoked after a fern renderer and 3rd party plugins defined highlight.
	Use this autocmd to overwrite existing |highlight| like:
>
	function! s:on_highlight() abort
	  " Use brighter highlight on root node
	  highlight link FernRootSymbol Title
	  highlight link FernRootText   Title
	endfunction

	augroup my-fern-highlight
	  autocmd!
	  autocmd User FernHighlight call s:on_highlight()
	augroup END
<
	See |fern-highlight| for pre-defined |highlight|.

						*FernSyntax*
FernSyntax
	Invoked after a fern renderer and 3rd party plugins defined syntax.
	Use this |autocmd| to overwrite existing |syntax|.
	Note that if you'd like to change color/highlight, use |FernHighlight|
	autocmd instead. This autocmd exists for more complex (heavy) use.

-----------------------------------------------------------------------------
HIGHLIGHT						*fern-highlight*

FernSpinner					*hl-FernSpinner*
	A |highlight| group used as a text highlight of spinner |sign|.

FernMarkedLine					*hl-FernMarkedLine*
	A |highlight| group used as a line highlight of mark |sign|.

FernMarkedText					*hl-FernMarkedText*
	A |highlight| group used as a text highlight of mark |sign|.

FernRootSymbol					*hl-FernRootSymbol*
	A |highlight| group of renderer used for root node symbol.
	An actual appearance will be determined by the |fern-renderer| thus
	this highlight might not be referred.

FernRootText					*hl-FernRootText*
	A |highlight| group of renderer used for root node text.
	An actual appearance will be determined by the |fern-renderer| thus
	this highlight might not be referred.

FernLeafSymbol					*hl-FernLeafSymbol*
	A |highlight| group of renderer used for leaf node symbol.
	See |g:fern#renderer#default#leaf_symbol|.
	An actual appearance will be determined by the |fern-renderer| thus
	this highlight might not be referred.

FernLeafText					*hl-FernLeafText*
	A |highlight| group of renderer used for leaf node text.
	An actual appearance will be determined by the |fern-renderer| thus
	this highlight might not be referred.

FernBranchSymbol				*hl-FernBranchSymbol*
	A |highlight| group of renderer used for branch node symbol.
	See |g:fern#renderer#default#expanded_symbol| and
	|g:fern#renderer#default#collapsed_symbol|.
	An actual appearance will be determined by the |fern-renderer| thus
	this highlight might not be referred.

FernBranchText					*hl-FernBranchText*
	A |highlight| group of renderer used for branch node text.
	An actual appearance will be determined by the |fern-renderer| thus
	this highlight might not be referred.

FernLeaderSymbol				*hl-FernLeaderSymbol*
	A |highlight| group of renderer used for the node leading symbol.
	See |g:fern#renderer#default#leading|.
	An actual appearance will be determined by the |fern-renderer| thus
	this highlight might not be referred.

FernWindowSelectIndicator		*hl-FernWindowSelectIndicator*
	A |highlight| group used for an indicator when selecting a window
	through "open:select" action.

FernWindowSelectStatusLine		*hl-FernWindowSelectStatusLine*
	A |highlight| group used for |statusline| when selecting a window
	through "open:select" action.


=============================================================================
MAPPING							*fern-mapping*

As described in |fern-action|, some mappings in fern are used as action.
See |fern-action| for more detail.

-----------------------------------------------------------------------------
GLOBAL							*fern-mapping-global*

*<Plug>(fern-action-zoom)*
	Zoom width of the drawer style fern to the ratio of the global width.
	It prompt users to ask a desired ratio of the width if no |v:count| is
	given. Users can use 1 to 10 for the ratio.
	It only works on a drawer style fern window.

*<Plug>(fern-action-zoom:reset)*
	Reset the width of the drawer style fern to its original width.
	It only works on a drawer style fern window.

*<Plug>(fern-action-zoom:half)*
	This is an alias of "4<Plug>(fern-action-zoom)"

*<Plug>(fern-action-zoom:full)*
	This is an alias of "9<Plug>(fern-action-zoom)"

*<Plug>(fern-action-hidden:set)*
	Show hidden nodes. For example hidden nodes in file:// scheme is a
	file or directory starts from '.' character.

*<Plug>(fern-action-hidden:unset)*
	Hide hidden nodes. For example hidden nodes in file:// scheme is a
	file or directory starts from '.' character.

*<Plug>(fern-action-hidden:toggle)*
	Toggle hidden nodes. For example hidden nodes in file:// scheme is a
	file or directory starts from '.' character.

*<Plug>(fern-action-hidden)*
	An alias to "hidden:toggle" action. Users can overwrite this mapping
	to change the default behavior of "hidden" action.

*<Plug>(fern-action-include)*
*<Plug>(fern-action-include=)*
	Open a prompt to enter include filter. Users can type a |pattern| to
	filter nodes recursively.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-include)
	      \ <Plug>(fern-action-include=)foo<CR>
<
*<Plug>(fern-action-exclude)*
*<Plug>(fern-action-exclude=)*
	Open a prompt to enter exclude filter. Users can type a |pattern| to
	filter nodes recursively.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-exclude)
	      \ <Plug>(fern-action-exclude=)foo<CR>
<
*<Plug>(fern-action-mark:clear)*
	Clear existing marks.

*<Plug>(fern-action-mark:set)*
	Set marks on cursor node(s).

*<Plug>(fern-action-mark:unset)*
	Unset marks on cursor node(s).

*<Plug>(fern-action-mark:toggle)*
	Toggle marks on cursor node(s).

*<Plug>(fern-action-mark)*
	An alias to "mark:toggle" action. Users can overwrite this mapping to
	change the default behavior of "mark" action.

*<Plug>(fern-action-debug)*
	Echo debug information of a cursor node.

*<Plug>(fern-action-reload:all)*
	Reload on the root node and its children.

*<Plug>(fern-action-reload:cursor)*
	Reload on a cursor node and its children.

*<Plug>(fern-action-reload)*
	An alias to "reload:all" action. Users can overwrite this mapping to
	change the default behavior of "reload" action like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-reload)
	      \ <Plug>(fern-action-reload:cursor)
<
*<Plug>(fern-action-expand:stay)*
	Expand on a cursor node and stay the cursor on the node.

*<Plug>(fern-action-expand:in)*
	Expand on a cursor node and get in the cursor node (move on the first
	child node of the cursor node.)

*<Plug>(fern-action-expand)*
	An alias to "expand:in" action. Users can overwrite this mapping to
	change the default behavior of "expand" action like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-expand)
	      \ <Plug>(fern-action-expand:stay)
<

*<Plug>(fern-action-collapse)*
	Collapse on a cursor node.

*<Plug>(fern-action-reveal)*
*<Plug>(fern-action-reveal=)*
	Open a prompt to reveal a node in a tree.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-reveal)
	      \ <Plug>(fern-action-reveal=)foo<CR>
<
*<Plug>(fern-action-focus:parent)*
	Focus the parent of the cursor node.

*<Plug>(fern-action-enter)*
	Open a new fern buffer which root node is a cursor node. In other
	word, get enter the directory.

*<Plug>(fern-action-leave)*
	Open a new fern buffer which root node is a parent node of the current
	root node. In other word, go up directory.

*<Plug>(fern-action-open:select)*
	Open a cursor node or marked nodes through "window selector"
	(|fern-glossary-window-selector|.)

*<Plug>(fern-action-open:split)*
*<Plug>(fern-action-open:vsplit)*
*<Plug>(fern-action-open:tabedit)*
	Open a cursor node or marked nodes with a corresponding command.
	The command will be applied on an "anchor" window when invoked from a
	drawer style fern (|fern-glossary-anchor|.)

*<Plug>(fern-action-open:drop)*
	Open a cursor node or jump the window when it was already opend.
	Note See |drop| for more details.

*<Plug>(fern-action-open:edit-or-error)*
	Open a cursor node or marked nodes with |edit| command or fallback
	to print an error.
	Note that when 'hidden' has set or 'bufhidden' is "hide", the |edit|
	command will never fails.

*<Plug>(fern-action-open:edit-or-split)*
*<Plug>(fern-action-open:edit-or-vsplit)*
*<Plug>(fern-action-open:edit-or-tabedit)*
	Open a cursor node or marked nodes with |edit| command or fallback
	to a corresponding command.
	Note that when 'hidden' has set or 'bufhidden' is "hide", the |edit|
	command will never fails.

*<Plug>(fern-action-open:above)*
*<Plug>(fern-action-open:left)*
*<Plug>(fern-action-open:below)*
*<Plug>(fern-action-open:right)*
	Open a cursor node or marked nodes on a corresponding direction
	from an "anchor" window.
	The command will be applied on the anchor window when invoked from a
	drawer style fern (|fern-glossary-anchor|.)

*<Plug>(fern-action-open:top)*
*<Plug>(fern-action-open:leftest)*
*<Plug>(fern-action-open:bottom)*
*<Plug>(fern-action-open:rightest)*
	Open a cursor node or marked nodes on a edge of a corresponding
	direction from an "anchor" window.
	The command will be applied on the anchor window when invoked from a
	drawer style fern (|fern-glossary-anchor|.)

*<Plug>(fern-action-open:side)*
	Open a cursor node or marked nodes on the right side of the current
	window. The behavior is slightly different between a drawer style fern
	window and a split style fern window due to the presence of "anchor".

*<Plug>(fern-action-open-or-enter)*
	Invoke "open" action on a leaf node and "enter" action on a branch
	node.

*<Plug>(fern-action-open-or-expand)*
	Invoke "open" action on a leaf node and "expand" action on a branch
	node.

*<Plug>(fern-action-open:edit)*
	An alias to "open:edit-or-error" action. Users can overwrite this
	mapping to change the default behavior of "open:edit" action like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-open:edit)
	      \ <Plug>(fern-action-open:edit-or-tabedit)
<
*<Plug>(fern-action-open)*
	An alias to "open:edit" action. Users can overwrite this mapping to
	change the default behavior of "open" action like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-open)
	      \ <Plug>(fern-action-open:select)
<
*<Plug>(fern-action-diff:select)*
*<Plug>(fern-action-diff:select:vert)*
	Open a first marked node through "window selector"
	(|fern-glossary-window-selector|.) then open remains with |split| or
	|vsplit| (:vert) to compare content through |diff| feature.

*<Plug>(fern-action-diff:split)*
*<Plug>(fern-action-diff:split:vert)*
*<Plug>(fern-action-diff:vsplit)*
*<Plug>(fern-action-diff:vsplit:vert)*
*<Plug>(fern-action-diff:tabedit)*
*<Plug>(fern-action-diff:tabedit:vert)*
	Open a first marked node with a corresponding command then open remains
	with |split| or |vsplit| (:vert) to compare contents through |diff|
	feature.
	The command will be applied on an "anchor" window when invoked from a
	drawer style fern (|fern-glossary-anchor|.)

*<Plug>(fern-action-diff:edit-or-error)*
*<Plug>(fern-action-diff:edit-or-error:vert)*
	Open a first marked node with |edit| command or fallback to print an
	error then open remains with |split| or |vsplit| (:vert) to compare
	contents through |diff| feature.
	Note that when 'hidden' has set or 'bufhidden' is "hide", the |edit|
	command will never fails.

*<Plug>(fern-action-diff:edit-or-split)*
*<Plug>(fern-action-diff:edit-or-split:vert)*
*<Plug>(fern-action-diff:edit-or-vsplit)*
*<Plug>(fern-action-diff:edit-or-vsplit:vert)*
*<Plug>(fern-action-diff:edit-or-tabedit)*
*<Plug>(fern-action-diff:edit-or-tabedit:vert)*
	Open a first marked node with |edit| command or fallback to a
	corresponding command then .
	Note that when 'hidden' has set or 'bufhidden' is "hide", the |edit|
	command will never fails.

*<Plug>(fern-action-diff:above)*
*<Plug>(fern-action-diff:above:vert)*
*<Plug>(fern-action-diff:left)*
*<Plug>(fern-action-diff:left:vert)*
*<Plug>(fern-action-diff:below)*
*<Plug>(fern-action-diff:below:vert)*
*<Plug>(fern-action-diff:right)*
*<Plug>(fern-action-diff:right:vert)*
	Open a first marked node on a corresponding direction from an "anchor"
	window then open remains with |split| or |vsplit| (:vert) to compare
	contents through |diff| feature.
	The command will be applied on the anchor window when invoked from a
	drawer style fern (|fern-glossary-anchor|.)

*<Plug>(fern-action-diff:top)*
*<Plug>(fern-action-diff:top:vert)*
*<Plug>(fern-action-diff:leftest)*
*<Plug>(fern-action-diff:leftest:vert)*
*<Plug>(fern-action-diff:bottom)*
*<Plug>(fern-action-diff:bottom:vert)*
*<Plug>(fern-action-diff:rightest)*
*<Plug>(fern-action-diff:rightest:vert)*
	Open a first marked node on a edge of a corresponding direction from
	an "anchor" window then open remains with |split| or |vsplit| (:vert)
	to compare contents through |diff| feature.
	The command will be applied on the anchor window when invoked from a
	drawer style fern (|fern-glossary-anchor|.)

*<Plug>(fern-action-diff:side)*
*<Plug>(fern-action-diff:side:vert)*
	Open a first marked node on the right side of the current window then
	open remains with |split| or |vsplit| (:vert) to compare contents
	through |diff| feature.
	The behavior is slightly different between a drawer style fern
	window and a split style fern window due to the presence of "anchor".

*<Plug>(fern-action-diff:edit)*
	An alias to "diff:edit-or-error" action. Users can overwrite this
	mapping to change the default behavior of "diff:edit" action like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-diff:edit)
	      \ <Plug>(fern-action-diff:edit-or-tabedit)
<
*<Plug>(fern-action-diff)*
	An alias to "diff:edit" action. Users can overwrite this mapping to
	change the default behavior of "diff" action like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-diff)
	      \ <Plug>(fern-action-diff:select)
<
*<Plug>(fern-action-cancel)*
	Cancel tree rendering.

*<Plug>(fern-action-redraw)*
	Redraw tree.

*<Plug>(fern-action-yank:label)*
*<Plug>(fern-action-yank:badge)*
*<Plug>(fern-action-yank:bufname)*
	Yank the node label, badge, or bufname.

*<Plug>(fern-action-yank)*
	An alias to "yank:bufname" action. Users can overwrite this mapping to
	change the default behavior of "yank" action like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-yank)
	      \ <Plug>(fern-action-yank:label)
<
	Note that this mapping is overwritten in FILE scheme.

*<Plug>(fern-wait)*
	Wait until the fern buffer become ready which would opened just before
	this mapping. This is required while fern buffers are loaded
	asynchronously but mappings are inovked synchronously.
	Note this is not action.


-----------------------------------------------------------------------------
FILE							*fern-mapping-file*

The following mappings/actions are only available on file:// scheme.

*<Plug>(fern-action-ex)*
*<Plug>(fern-action-ex=)*
	Open a prompt to execute an Ex command with a path of cursor node or
	paths of marked nodes. The paths are |fnameescape()|ed.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-ex)
	      \ <Plug>(fern-action-ex=)foo<CR>
<
*<Plug>(fern-action-new-path)*
*<Plug>(fern-action-new-path=)*
	Open a prompt to ask a path and create a file/directory of the input
	path from the path of a cursor node.
	Any intermediate directories of the destination will be created.
	If the path ends with "/", it creates a directory. Otherwise it
	creates a file.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-new-path)
	      \ <Plug>(fern-action-new-path=)foo<CR>
<
*<Plug>(fern-action-new-file)*
*<Plug>(fern-action-new-file=)*
	Open a prompt to ask a path and create a file of the input path from
	the path of a cursor node.
	Any intermediate directories of the destination will be created.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-new-file)
	      \ <Plug>(fern-action-new-file=)foo<CR>
<
*<Plug>(fern-action-new-dir)*
*<Plug>(fern-action-new-dir=)*
	Open a prompt to ask a path and create a directory of the input path
	from the path of a cursor node.
	Any intermediate directories of the destination will be created.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-new-dir)
	      \ <Plug>(fern-action-new-dir=)foo<CR>
<
*<Plug>(fern-action-copy)*
	Open a prompt to ask a path and copy a file/directory of the cursor
	node or marked node path(s) to the input path(s).
	Any intermediate directories of the destination will be created.
	The prompt will repeatedly open if multiple nodes has marked.

*<Plug>(fern-action-move)*
	Open a prompt to ask a path and move a file/directory of the cursor
	node or marked node path(s) to the input path(s).
	Any intermediate directories of the destination will be created.
	The prompt will repeatedly open if multiple nodes has marked.

*<Plug>(fern-action-trash)*
*<Plug>(fern-action-trash=)*
	Open a prompt to ask if fern can send the cursor node or marked nodes
	to the system trash-bin. It uses the following implementations to send
	the node(s) into system trash-bin.
	OS		Requirement~
	macOS:		osascript (OS builtin)
	Windows:	PowerShell (OS builtin)
	Linux:		trash-cli or gomi (Users need to install)
			https://github.com/andreafrancia/trash-cli
			https://github.com/b4b4r07/gomi
	Note that the action fails without removing the files/directories if
	no requirement exists on Linux.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Immediately delete
	nmap <buffer>
	      \ <Plug>(my-trash)
	      \ <Plug>(fern-action-trash=)y<CR>

*<Plug>(fern-action-remove)*
*<Plug>(fern-action-remove=)*
	Open a prompt to ask if fern can DELETE the cursor node or marked
	nodes. BE CAREFUL with this action while it DELETE the file/direcoty
	and users cannot restore (like "rm" in terminal.)
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Immediately delete
	nmap <buffer>
	      \ <Plug>(my-trash)
	      \ <Plug>(fern-action-trash=)y<CR>

*<Plug>(fern-action-cd:root)*
*<Plug>(fern-action-lcd:root)*
*<Plug>(fern-action-tcd:root)*
	Invoke |:cd|, |:lcd|, or |:tcd| command on the path of the root node.

*<Plug>(fern-action-cd:cursor)*
*<Plug>(fern-action-lcd:cursor)*
*<Plug>(fern-action-tcd:cursor)*
	Invoke |:cd|, |:lcd|, or |:tcd| command on the path of a cursor node.

*<Plug>(fern-action-cd)*
*<Plug>(fern-action-lcd)*
*<Plug>(fern-action-tcd)*
	An alias to "cd:cursor", "lcd:cursor", and "tcd:cursor" action.
	Users can overwrite this mapping to change the default behavior like:
>
	nmap <buffer>
	      \ <Plug>(fern-action-cd)
	      \ <Plug>(fern-action-cd:root)
<
*<Plug>(fern-action-clipboard-copy)*
	Copy a cursor node or marked nodes into an internal clipboard.
	Actual copy happens when users paste the nodes with "clipboard-paste"
	action.
	Note that this action has NO-relation with the system clipboard.

*<Plug>(fern-action-clipboard-move)*
	Move a cursor node or marked nodes into an internal clipboard.
	Actual move happens when users paste the nodes with "clipboard-paste"
	action.
	Note that this action has NO-relation with the system clipboard.

*<Plug>(fern-action-clipboard-paste)*
	Paste copied/moved nodes on a cursor node. It does not clear the
	internal clipboard so users can copy -> paste -> paste -> ...
	Note that this action has NO-relation with the system clipboard.

*<Plug>(fern-action-clipboard-clear)*
	Clear the internal clipboard.
	Note that this action has NO-relation with the system clipboard.

*<Plug>(fern-action-grep)*
*<Plug>(fern-action-grep=)*
	Open a prompt to ask a grep pattern and execute grep command under the
	cursor node. It respects the value of 'grepprg' and 'grepformat'.
	You can use a "=" variant to apply values to the prompt and/or submit
	a value like:
>
	" Automatically apply "foo" to the prompt and submit.
	nmap <buffer>
	      \ <Plug>(my-grep)
	      \ <Plug>(fern-action-grep=)foo<CR>
<
*<Plug>(fern-action-rename:select)*
*<Plug>(fern-action-rename:split)*
*<Plug>(fern-action-rename:vsplit)*
*<Plug>(fern-action-rename:tabedit)*
*<Plug>(fern-action-rename:above)*
*<Plug>(fern-action-rename:left)*
*<Plug>(fern-action-rename:below)*
*<Plug>(fern-action-rename:right)*
*<Plug>(fern-action-rename:top)*
*<Plug>(fern-action-rename:leftest)*
*<Plug>(fern-action-rename:bottom)*
*<Plug>(fern-action-rename:rightest)*
*<Plug>(fern-action-rename:edit-or-error)*
*<Plug>(fern-action-rename:edit-or-split)*
*<Plug>(fern-action-rename:edit-or-vsplit)*
*<Plug>(fern-action-rename:edit-or-tabedit)*
*<Plug>(fern-action-rename:edit)*
*<Plug>(fern-action-rename:side)*
*<Plug>(fern-action-rename)*
	Open "renamer" (|fern-glossary-renamer|) for a cursor node or marked
	nodes in similar manners of global "open" actions.

*<Plug>(fern-action-open:system)*
	Open a cursor node or marked nodes on a default program of the system.
	For example, a cursor node points a PDF file, an application "Preview"
	will open that file in macOS.

*<Plug>(fern-action-terminal:select)*
*<Plug>(fern-action-terminal:split)*
*<Plug>(fern-action-terminal:vsplit)*
*<Plug>(fern-action-terminal:tabedit)*
*<Plug>(fern-action-terminal:above)*
*<Plug>(fern-action-terminal:left)*
*<Plug>(fern-action-terminal:below)*
*<Plug>(fern-action-terminal:right)*
*<Plug>(fern-action-terminal:top)*
*<Plug>(fern-action-terminal:leftest)*
*<Plug>(fern-action-terminal:bottom)*
*<Plug>(fern-action-terminal:rightest)*
*<Plug>(fern-action-terminal:edit-or-error)*
*<Plug>(fern-action-terminal:edit-or-split)*
*<Plug>(fern-action-terminal:edit-or-vsplit)*
*<Plug>(fern-action-terminal:edit-or-tabedit)*
*<Plug>(fern-action-terminal:edit)*
*<Plug>(fern-action-terminal:side)*
*<Plug>(fern-action-terminal)*
	Open terminal window(s) on or on parent of a cursor node or marked
	nodes in similar manners of global "open" actions.

*<Plug>(fern-action-yank:path)*
	Yank the node path. In FILE scheme, |<Plug>(fern-action-yank)| is
	aliased to this mapping.

-----------------------------------------------------------------------------
DICT							*fern-mapping-dict*

The following mappings/actions are only available on dict:// scheme.

TBW


=============================================================================
GLOSSARY						*fern-glossary*

					*fern-glossary-anchor*
"anchor"		A nearest suitable window from a drawer style fern
			window. "suitable" window is a window which is
			1. not quickfix window
			2. not location-list window
			3. not 'winfixwidth'
			4. not 'winfixheight'
			5. not 'previewwindow'
			Usually a right window by the drawer become "anchor".

					*fern-glossary-renamer*
"renamer"		A special buffer which lists paths. Users can modify
			the paths and save. Once user save the content with
			|:write| command, corresponding rename process will
			invokes (e.g. file/directory rename on file:// scheme)

					*fern-glossary-window-selector*
"window selector"	A special prompt to select window to open a node.
			Once user hit a window indicator displayed under each
			window, a content of the node will be opened at that
			window.


=============================================================================
DEVELOPMENT						*fern-development*

There is |fern-develop.txt| as an API documentation for fern plugin developer.


=============================================================================
vim:tw=78:fo=tcq2mM:ts=8:ft=help:norl
./ftplugin/fern.vim	[[[1
7
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal cursorline
setlocal nolist nowrap nospell
./plugin/fern.vim	[[[1
66
if exists('g:loaded_fern')
  finish
endif
let g:loaded_fern = 1

function! s:warn(message) abort
  if get(g:, 'fern_disable_startup_warnings')
    return
  endif
  echohl ErrorMsg
  echo printf('[fern] %s', a:message)
  echo '[fern] Disable this warning message by adding "let g:fern_disable_startup_warnings = 1" on your vimrc.'
  echohl None
endfunction

if !has('nvim') && !has('patch-8.1.0994')
  " NOTE:
  " At least https://github.com/vim/vim/releases/tag/v8.1.0994 is required
  " thus minimum working version is 8.1.0994. Remember that minimum support
  " version is not equal to this.
  call s:warn('Vim prior to 8.1.0994 does not have required feature thus fern is disabled.')
  finish
elseif exists('+shellslash') && &shellslash
  call s:warn('"shellslash" option is not supported thus fern is disabled.')
  finish
elseif !has('nvim') && !has('patch-8.1.2269')
  call s:warn('Vim prior to 8.1.2269 is not supported and fern might not work properly.')
elseif has('nvim') && !has('nvim-0.4.4')
  call s:warn('Neovim prior to 0.4.4 is not supported and fern might not work properly.')
endif


command! -bar -nargs=*
      \ -complete=customlist,fern#internal#command#fern#complete
      \ Fern
      \ call fern#internal#command#fern#command(<q-mods>, [<f-args>])

command! -bar -nargs=*
      \ -complete=customlist,fern#internal#command#do#complete
      \ FernDo
      \ call fern#internal#command#do#command(<q-mods>, [<f-args>])

function! s:BufReadCmd() abort
  if exists('b:fern')
    return
  endif
  call fern#internal#viewer#init()
        \.catch({ e -> fern#logger#error(e) })
endfunction

function! s:SessionLoadPost() abort
  let bufnr = bufnr()
  call s:BufReadCmd()
  " Re-apply required window options
  for winid in win_findbuf(bufnr)
    let [tabnr, winnr] = win_id2tabwin(winid)
    call settabwinvar(tabnr, winnr, '&concealcursor', 'nvic')
    call settabwinvar(tabnr, winnr, '&conceallevel', 2)
  endfor
endfunction

augroup fern_internal
  autocmd! *
  autocmd BufReadCmd fern://* nested call s:BufReadCmd()
  autocmd SessionLoadPost fern://* nested call s:SessionLoadPost()
augroup END
./syntax/fern.vim	[[[1
28
if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 'fern'

syntax clear

function! s:ColorScheme() abort
  let helper = fern#helper#new()
  call helper.fern.renderer.highlight()
  call fern#hook#emit('viewer:highlight', helper)
  doautocmd <nomodeline> User FernHighlight
endfunction

function! s:Syntax() abort
  let helper = fern#helper#new()
  call helper.fern.renderer.syntax()
  call fern#hook#emit('viewer:syntax', helper)
  doautocmd <nomodeline> User FernSyntax
endfunction

augroup fern_syntax_internal
  autocmd! * <buffer>
  autocmd ColorScheme <buffer> call s:ColorScheme()
augroup END

call s:ColorScheme()
call s:Syntax()
./test/.themisrc	[[[1
39
if &encoding ==# 'latin1'
  set encoding=utf-8
endif

" Profile ------------------------------------------------------------------
if $PROFILE !=# ''
  execute 'profile start' $PROFILE
  profile! file ./autoload/fern/*
  profile! file ./autoload/vital/__fern__/*
endif

" Force English interface
try
  language message C
catch
endtry
set helplang=en

let s:assert = themis#helper('assert')
call themis#option('recursive', 1)
call themis#option('reporter', 'dot')
call themis#helper('command').with(s:assert)

call themis#log(substitute(execute('version'), '^\%(\r\?\n\)*', '', ''))
call themis#log('-----------------------------------------------------------')
call themis#log('$LANG:          ' . $LANG)
call themis#log('&encoding:      ' . &encoding)
call themis#log('&termencoding:  ' . &termencoding)
call themis#log('&fileencodings: ' . &fileencodings)
call themis#log('&fileformats:   ' . &fileformats)
call themis#log('&shellslash:    ' . (exists('&shellslash') ? &shellslash : 'DISABLED'))
call themis#log('&runtimepath:')
for s:runtimepath in split(&runtimepath, ',')
  call themis#log('  ' . s:runtimepath)
endfor
call themis#log('-----------------------------------------------------------')

" Add test utilities
set runtimepath+=./test/util
./test/behavior/Fern.vimspec	[[[1
121
Describe Fern
  Before all
    let l:Join = function('fern#internal#filepath#join')
    const workdir = tempname()
    call mkdir(Join([workdir, 'deep', 'alpha', 'beta']), 'p')
    call mkdir(Join([workdir, 'shallow', 'alpha']), 'p')
    call mkdir(Join([workdir, 'shallow', 'beta']), 'p')
    call writefile([], Join([workdir, 'deep', 'alpha', 'beta', 'gamma']))
    call writefile([], Join([workdir, 'shallow', 'gamma']))
    call writefile([], Join([workdir, 'leaf']))
  End

  After all
    %bwipeout!
    call delete(workdir, 'rf')
  End

  Before
    %bwipeout!
  End

  Context debug scheme
    It Fern debug:/// opens a fern buffer on a current window
      Fern debug:/// -wait
      Assert Equals(winnr('$'), 1)
      Assert Equals(getline(1, '$'), [
            \ 'root',
            \ '|+ deep/',
            \ '|+ heavy/',
            \ '|+ shallow/',
            \ '|  leaf',
            \])
    End

    It Fern debug:/// -reveal=deep/alpha/beta reveals to 'deep/alpha/beta'
      Fern debug:/// -reveal=deep/alpha/beta -wait
      Assert Equals(getline(1, '$'), [
            \ 'root',
            \ '|- deep/',
            \ ' |- alpha/',
            \ '  |- beta/',
            \ '   |  gamma',
            \ '|+ heavy/',
            \ '|+ shallow/',
            \ '|  leaf',
            \])
    End

    It Fern debug:/// -reveal=deep/alpha/zeta reveals to 'deep/alpha'
      Fern debug:/// -reveal=deep/alpha/zeta -wait
      Assert Equals(getline(1, '$'), [
            \ 'root',
            \ '|- deep/',
            \ ' |- alpha/',
            \ '  |+ beta/',
            \ '|+ heavy/',
            \ '|+ shallow/',
            \ '|  leaf',
            \])
    End
  End

  Context file scheme
    It Fern {workdir} opens a fern buffer on a current window
      execute printf('Fern %s -wait', fnameescape(workdir))
      Assert Equals(winnr('$'), 1)
      Assert Equals(getline(2, '$'), [
            \ '|+ deep/',
            \ '|+ shallow/',
            \ '|  leaf',
            \])
    End

    It Fern {workdir} -reveal=deep/alpha/beta reveals to 'deep/alpha/beta'
      execute printf('Fern %s -reveal=deep/alpha/beta -wait', fnameescape(workdir))
      Assert Equals(winnr('$'), 1)
      Assert Equals(getline(2, '$'), [
            \ '|- deep/',
            \ ' |- alpha/',
            \ '  |- beta/',
            \ '   |  gamma',
            \ '|+ shallow/',
            \ '|  leaf',
            \])
    End

    It Fern {workdir} -reveal={deep/alpha/beta} reveals to 'deep/alpha/beta'
      execute printf(
            \ 'Fern %s -reveal=%s -wait',
            \ fnameescape(workdir),
            \ fnameescape(Join(['deep', 'alpha', 'beta']))
            \)
      Assert Equals(winnr('$'), 1)
      Assert Equals(getline(2, '$'), [
            \ '|- deep/',
            \ ' |- alpha/',
            \ '  |- beta/',
            \ '   |  gamma',
            \ '|+ shallow/',
            \ '|  leaf',
            \])
    End

    It Fern {workdir} -reveal={workdir/deep/alpha/beta} reveals to 'deep/alpha/beta'
      execute printf(
            \ 'Fern %s -reveal=%s -wait',
            \ fnameescape(workdir),
            \ fnameescape(Join([workdir, 'deep', 'alpha', 'beta']))
            \)
      Assert Equals(winnr('$'), 1)
      Assert Equals(getline(2, '$'), [
            \ '|- deep/',
            \ ' |- alpha/',
            \ '  |- beta/',
            \ '   |  gamma',
            \ '|+ shallow/',
            \ '|  leaf',
            \])
    End
  End
End
./test/behavior/alternate-file.vimspec	[[[1
47
Describe alternate-file
  Before all
    let fern_keepalt_on_edit = g:fern#keepalt_on_edit
    const workdir = tempname()
    call mkdir(workdir, 'p')
    call writefile([], fern#internal#filepath#join([workdir, 'alpha']))
    call writefile([], fern#internal#filepath#join([workdir, 'beta']))
    call writefile([], fern#internal#filepath#join([workdir, 'gamma']))
  End

  After all
    %bwipeout!
    let g:fern#keepalt_on_edit = fern_keepalt_on_edit
    call delete(workdir, 'rf')
  End

  Before
    %bwipeout!
    let g:fern#keepalt_on_edit = fern_keepalt_on_edit
  End

  It Fern command keeps 'alternate-file' correctly
    edit alpha
    Fern . -wait
    Assert Equals(bufname('#'), 'alpha')
  End

  It Fern updates 'alternate-file' after 'open:edit' action in split windows style if g:fern#keepalt_on_edit is 0
    let g:fern#keepalt_on_edit = 0

    edit alpha
    execute printf('Fern %s -wait', fnameescape(workdir))
    execute "normal G\<Plug>(fern-action-open:edit)"
    Assert Equals(expand('%:t'), 'gamma')
    Assert Match(bufname('#'), '^fern://.*/file:///.*$')
  End

  It Fern keeps 'alternate-file' after 'open:edit' action in split windows style if g:fern#keepalt_on_edit is 1
    let g:fern#keepalt_on_edit = 1

    edit alpha
    execute printf('Fern %s -wait', fnameescape(workdir))
    execute "normal G\<Plug>(fern-action-open:edit)"
    Assert Equals(expand('%:t'), 'gamma')
    Assert Equals(bufname('#'), 'alpha')
  End
End
./test/behavior/buffer-list.vimspec	[[[1
36
Describe buffer-list
  After all
    %bwipeout!
  End

  Before
    %bwipeout!
  End

  It 'Fern debug:///' keeps 'ls' (visible buffer list)
    edit hello
    Fern debug:/// -wait
    let output = split(execute('ls'), '\n')
    Assert Match(output[0], '^\s*\d\+\s\+\#h\?\s\+"hello"\s\+line 1$')
    Assert Equals(len(output), 1)
  End

  It 'Fern debug:///' keeps 'ls!' (all buffer list)
    edit hello
    Fern debug:/// -wait
    let output = split(execute('ls!'), '\n')
    Assert Match(output[0], '^\s*\d\+\s\+\#h\?\s\+"hello"\s\+line 1$')
    Assert Match(output[1], '^\s*\d\+u%a-\s\+"fern://.*"\s\+line 1$')
    Assert Equals(len(output), 2)
  End

  It 'Fern debug:/// -reveal=deep/alpha/beta' keeps 'ls!'
    edit hello
    Fern debug:/// -reveal=deep/alpha/beta -wait
    let output = split(execute('ls!'), '\n')
    Assert Match(output[0], '^\s*\d\+\s\+\#h\?\s\+"hello"\s\+line 1$')
    Assert Match(output[1], '^\s*\d\+u%a-\s\+"fern://.*"\s\+line \d\+$')
    Assert Equals(len(output), 2)
  End
End

./test/behavior/buffer-rename.vimspec	[[[1
65
Describe buffer-rename
  Before
    const workdir = tempname()
    call mkdir(workdir, 'p')
    call writefile([], fern#internal#filepath#join([workdir, 'alpha']))
    call writefile([], fern#internal#filepath#join([workdir, 'beta']))
    call writefile([], fern#internal#filepath#join([workdir, 'gamma']))
    %bwipeout!
  End

  After
    %bwipeout!
    call delete(workdir, 'rf')
    set hidden&
  End

  It "move" action will update bufname of a corresponding opened buffer
    execute printf('edit %s', fnameescape(fern#internal#filepath#join([workdir, 'alpha'])))
    execute printf('Fern %s -wait', fnameescape(workdir))
    Assert Match(execute('ls'), '\<alpha\>')
    call test#feedkeys("\<C-w>OMEGA\<CR>")
    call feedkeys("ggj\<Plug>(fern-action-move)")
    call feedkeys("\<Plug>(fern-wait)", 'x')
    Assert Equals(getline(1, '$'), [
          \ printf('%s', fnamemodify(workdir, ':t')),
          \ '|  OMEGA',
          \ '|  beta',
          \ '|  gamma',
          \])
    Assert NotMatch(execute('ls'), '\<alpha\>')
    Assert Match(execute('ls'), '\<OMEGA\>')
  End

  It "remove" action will remove a corresponding opened buffer
    execute printf('edit %s', fnameescape(fern#internal#filepath#join([workdir, 'alpha'])))
    execute printf('Fern %s -wait', fnameescape(workdir))
    Assert Match(execute('ls'), '\<alpha\>')
    call test#feedkeys("y\<CR>")
    call feedkeys("ggj\<Plug>(fern-action-remove)")
    call feedkeys("\<Plug>(fern-wait)", 'x')
    Assert Equals(getline(1, '$'), [
          \ printf('%s', fnamemodify(workdir, ':t')),
          \ '|  beta',
          \ '|  gamma',
          \])
    Assert NotMatch(execute('ls'), '\<alpha\>')
  End

  It "remove" action does NOT remove a corresponding opened buffer if modified
    set hidden
    execute printf('edit %s', fnameescape(fern#internal#filepath#join([workdir, 'alpha'])))
    call append(0, ["Hello World"])
    execute printf('Fern %s -wait', fnameescape(workdir))
    Assert Match(execute('ls'), '\<alpha\>')
    call test#feedkeys("y\<CR>")
    call feedkeys("ggj\<Plug>(fern-action-remove)")
    call feedkeys("\<Plug>(fern-wait)", 'x')
    Assert Equals(getline(1, '$'), [
          \ printf('%s', fnamemodify(workdir, ':t')),
          \ '|  beta',
          \ '|  gamma',
          \])
    Assert Match(execute('ls'), '\<alpha\>')
  End
End
./test/behavior/drawer-smart-quit.vimspec	[[[1
36
if has('win32')
  command! Relax sleep 100m
else
  command! Relax sleep 1m
endif

Describe drawer-smart-quit
  After all
    %bwipeout!
    let g:fern#disable_drawer_smart_quit = 0
  End

  Before
    %bwipeout!
    let g:fern#disable_drawer_smart_quit = 0
  End

  Describe keep
    It creates a new buffer to keep the number of windows on 'quit'
      Fern . -drawer -keep -stay
      Assert Equals(winnr('$'), 2)
      quit
      Relax
      Assert Equals(winnr('$'), 2)
    End

    It does nothing when g:fern#disable_drawer_smart_quit = 1
      let g:fern#disable_drawer_smart_quit = 1
      Fern . -drawer -keep -stay
      Assert Equals(winnr('$'), 2)
      quit
      Relax
      Assert Equals(winnr('$'), 1)
    End
  End
End
./test/behavior/jumplist.vimspec	[[[1
67
Describe jumplist
  Before all
    let fern_keepjumps_on_edit = g:fern#keepjumps_on_edit
    const workdir = tempname()
    call mkdir(workdir, 'p')
    call writefile([], fern#internal#filepath#join([workdir, 'alpha']))
    call writefile([], fern#internal#filepath#join([workdir, 'beta']))
    call writefile([], fern#internal#filepath#join([workdir, 'gamma']))
  End

  After all
    %bwipeout!
    let g:fern#keepjumps_on_edit = fern_keepjumps_on_edit
    call delete(workdir, 'rf')
  End

  Before
    clearjumps
    %bwipeout!
    let g:fern#keepjumps_on_edit = fern_keepjumps_on_edit
  End

  It Fern command keeps jumps correctly
    edit alpha
    edit beta
    edit gamma
    Fern . -wait
    let output = split(execute('jumps'), '\n')
    Assert Match(output[1], '^\s\+3\s\+1\s\+\d\+ alpha$')
    Assert Match(output[2], '^\s\+2\s\+1\s\+\d\+ beta$')
    Assert Match(output[3], '^\s\+1\s\+1\s\+\d\+ gamma$')
    Assert Match(output[4], '^>$')
    Assert Equals(len(output), 5)
  End

  It Fern updates jumps after 'open:edit' action in split windows style if g:fern#keepjumps_on_edit is 0
    let g:fern#keepjumps_on_edit = 0

    edit alpha
    execute printf('Fern %s -wait', fnameescape(workdir))
    execute "normal G\<Plug>(fern-action-open:edit)"
    let output = split(execute('jumps'), '\n')
    " NOTE:
    " It seems '-wait' affects 'jumps' somehow
    Assert Match(output[1], '^\s\+3\s\+1\s\+\d\+ alpha$', output)
    Assert Match(output[2], '^\s\+2\s\+1\s\+\d\+ fern://.*/file:///.*$', output)
    Assert Match(output[3], '^\s\+1\s\+4\s\+\d\+ fern://.*/file:///.*$', output)
    Assert Match(output[4], '^>$', output)
    Assert Equals(len(output), 5)
  End

  It Fern keeps jumps after 'open:edit' action in split windows style if g:fern#keepjumps_on_edit is 1
    let g:fern#keepjumps_on_edit = 1

    edit alpha
    execute printf('Fern %s -wait', fnameescape(workdir))
    execute "normal G\<Plug>(fern-action-open:edit)"
    let output = split(execute('jumps'), '\n')
    " NOTE:
    " It seems '-wait' affects 'jumps' somehow
    Assert Match(output[1], '^\s\+2\s\+1\s\+\d\+ alpha$', output)
    Assert Match(output[2], '^\s\+1\s\+1\s\+\d\+ fern://.*/file:///.*$', output)
    Assert Match(output[3], '^>$', output)
    Assert Equals(len(output), 4)
  End
End

./test/behavior/keepalt.vimspec	[[[1
15
Describe Behavior keepalt
  After all
    %bwipeout!
  End

  Before
    %bwipeout!
  End

  It Fern command keeps 'alternate-file' correctly
    edit hello
    Fern .
    Assert Equals(bufname('#'), 'hello')
  End
End
./test/behavior/special-characters.vimspec	[[[1
64
Describe special-characters
  Before all
    let l:Join = function('fern#internal#filepath#join')
    const workdir = tempname()
    let candidates = [
          \ ';',
          \ '#',
          \ '$',
          \ '%',
          \ '%20',
          \]
    for candidate in candidates
      call mkdir(Join([workdir, candidate, 'hello']), 'p')
      call writefile([], Join([workdir, candidate, 'hello', 'world']))
    endfor
  End

  After all
    %bwipeout!
    call delete(workdir, 'rf')
  End

  Before
    %bwipeout!
  End

  It Fern {workdir}/; opens the directory
    if has('win32')
      Skip It seems a directory ";" does not work on Windows for now. Not sure if it's an issue or not.
    endif
    execute printf('Fern %s -wait', fnameescape(Join([workdir, ';'])))
    Assert Equals(getline(2, '$'), [
          \ '|+ hello/',
          \])
  End

  It Fern {workdir}/# opens the directory
    execute printf('Fern %s -wait', fnameescape(Join([workdir, '#'])))
    Assert Equals(getline(2, '$'), [
          \ '|+ hello/',
          \])
  End

  It Fern {workdir}/$ opens the directory
    execute printf('Fern %s -wait', fnameescape(Join([workdir, '$'])))
    Assert Equals(getline(2, '$'), [
          \ '|+ hello/',
          \])
  End

  It Fern {workdir}/% opens the directory
    execute printf('Fern %s -wait', fnameescape(Join([workdir, '%'])))
    Assert Equals(getline(2, '$'), [
          \ '|+ hello/',
          \])
  End

  It Fern {workdir}/%20 opens the directory
    execute printf('Fern %s -wait', fnameescape(Join([workdir, '%20'])))
    Assert Equals(getline(2, '$'), [
          \ '|+ hello/',
          \])
  End
End
./test/behavior/test.vimspec	[[[1
31
function! s:input() abort
  try
    call inputsave()
    echo input("Hello")
  finally
    call inputrestore()
  endtry
endfunction

Describe input/feedkeys technique
  It accepts "feedkeys" technique to complete "input()"
    call test#feedkeys("Hello World\<CR>")
    let value = execute("echo input('This is a test prompt')")
    Assert Equals(value, "\nHello World")
  End

  It accepts "feedkeys" technique to complete "input()" with "inputsave()/inputrestore()"
    call test#feedkeys("Hello World\<CR>")
    let value = execute('call s:input()')
    Assert Equals(value, "\nHello World")
  End

  It accepts "feedkeys" technique to complete "input()" through mapping
    nnoremap <buffer>
          \ <Plug>(test-input)
          \ :<C-u>call <SID>input()<CR>
    call test#feedkeys("Hello World\<CR>")
    let value = execute("normal \<Plug>(test-input)")
    Assert Equals(value, "\nHello World")
  End
End
./test/fern/comparator/default.vimspec	[[[1
138
Describe fern#comparator#default
  Before
    let provider = fern#scheme#debug#provider#new()
  End

  Describe comparator instance
    Before
      let comparator = fern#comparator#default#new()
      let l:Compare = comparator.compare
    End

    Describe .compare()
      It returns 0 when n1.__key is equal to n2.__key
        let n1 = fern#internal#node#root('debug:///shallow', provider)
        let n1.__key = ['shallow']
        let n2 = fern#internal#node#root('debug:///shallow', provider)
        let n2.__key = ['shallow']
        Assert Equals(Compare(n1, n2), 0)
      End

      It returns -1 when n1.__key is shorter than n2.__key
        let n1 = fern#internal#node#root('debug:///shallow', provider)
        let n1.__key = ['shallow']
        let n2 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n2.__key = ['shallow', 'alpha']
        Assert Equals(Compare(n1, n2), -1)
      End

      It returns 1 when n1.__key is longer than n2.__key
        let n1 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n1.__key = ['shallow', 'alpha']
        let n2 = fern#internal#node#root('debug:///shallow', provider)
        let n2.__key = ['shallow']
        Assert Equals(Compare(n1, n2), 1)
      End

      It returns -1 when a term in n1.__key is smaller than a term in n2.__key when n1 and n2 are leaf
        let n1 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n1.__key = ['shallow', 'alpha']
        let n1.status = 0
        let n2 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n2.__key = ['shallow', 'beta']
        let n2.status = 0
        Assert Equals(Compare(n1, n2), -1)
      End

      It returns -1 when a term in n1.__key is smaller than a term in n2.__key when n1 and n2 are branch
        let n1 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n1.__key = ['shallow', 'alpha']
        let n1.status = 0
        let n2 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n2.__key = ['shallow', 'beta']
        let n2.status = 0
        Assert Equals(Compare(n1, n2), -1)
      End

      It returns 1 when a term in n1.__key is smaller than a term in n2.__key when n1 is leaf and n2 is branch
        let n1 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n1.__key = ['shallow', 'alpha']
        let n1.status = 0
        let n2 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n2.__key = ['shallow', 'beta']
        let n2.status = 1
        Assert Equals(Compare(n1, n2), 1)
      End

      It returns -1 when a term in n1.__key is smaller than a term in n2.__key when n1 is branch and n2 is leaf
        let n1 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n1.__key = ['shallow', 'alpha']
        let n1.status = 1
        let n2 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n2.__key = ['shallow', 'beta']
        let n2.status = 0
        Assert Equals(Compare(n1, n2), -1)
      End

      It returns 1 when a term in n1.__key is larger than a term in n2.__key when n1 and n2 are leaf
        let n1 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n1.__key = ['shallow', 'beta']
        let n1.status = 0
        let n2 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n2.__key = ['shallow', 'alpha']
        let n2.status = 0
        Assert Equals(Compare(n1, n2), 1)
      End

      It returns 1 when a term in n1.__key is larger than a term in n2.__key when n1 and n2 are branch
        let n1 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n1.__key = ['shallow', 'beta']
        let n1.status = 1
        let n2 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n2.__key = ['shallow', 'alpha']
        let n2.status = 1
        Assert Equals(Compare(n1, n2), 1)
      End

      It returns -1 when a term in n1.__key is larger than a term in n2.__key but n1 is leaf and n2 is branch
        let n1 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n1.__key = ['shallow', 'beta']
        let n1.status = 0
        let n2 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n2.__key = ['shallow', 'alpha']
        let n2.status = 1
        Assert Equals(Compare(n1, n2), 1)
      End

      It returns -1 when a term in n1.__key is larger than a term in n2.__key but n1 is branch and n2 is leaf
        let n1 = fern#internal#node#root('debug:///shallow/beta', provider)
        let n1.__key = ['shallow', 'beta']
        let n1.status = 1
        let n2 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n2.__key = ['shallow', 'alpha']
        let n2.status = 0
        Assert Equals(Compare(n1, n2), -1)
      End

      It returns -1 when n1 is branch but n2 is leaf
        let n1 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n1.__key = ['shallow', 'alpha']
        let n1.status = 1
        let n2 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n2.__key = ['shallow', 'alpha']
        let n2.status = 0
        Assert Equals(Compare(n1, n2), -1)
      End

      It returns 1 when n1 is leaf but n2 is branch
        let n1 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n1.__key = ['shallow', 'alpha']
        let n1.status = 0
        let n2 = fern#internal#node#root('debug:///shallow/alpha', provider)
        let n2.__key = ['shallow', 'alpha']
        let n2.status = 1
        Assert Equals(Compare(n1, n2), 1)
      End
    End
  End
End
./test/fern/fri/from.vimspec	[[[1
266
Describe fern#fri#from
  Before all
    let fern_internal_filepath_is_windows = g:fern#internal#filepath#is_windows
  End

  After all
    let g:fern#internal#filepath#is_windows = fern_internal_filepath_is_windows
  End

  Describe #path()
    It throws an error if the path does not start from "/"
      Throws /The "path" must start from "\/"/ fern#fri#from#path('foo/bar')
    End

    It returns FRI of file:///foo/bar from /foo/bar
      let expr = '/foo/bar'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#from#path(expr), want)
    End

    It returns FRI of file:///foo/bar from /foo/bar/hoge/hoge/../../
      let expr = '/foo/bar/hoge/hoge/../../'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#from#path(expr), want)
    End

    It returns FRI of file:///foo/bar/%25 from /foo/bar/% (percent character)
      let expr = '/foo/bar/%'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar/%25',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#from#path(expr), want)
    End

    It returns FRI of file:///foo/bar/%3C%3E%7C%3F%2A from /foo/bar/<>|?* (unusable characters)
      let expr = '/foo/bar/<>|?*'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar/%3C%3E%7C%3F%2A',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#from#path(expr), want)
    End

    It returns FRI of file:///foo/bar/%23%5B%5D%3B%20 from /foo/bar/#[];  (non pchar)
      let expr = '/foo/bar/#[]; '
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar/%23%5B%5D%3B%20',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#from#path(expr), want)
    End
  End

  Describe #filepath()
    Context Windows
      Before
        let g:fern#internal#filepath#is_windows = 1
      End

      It throws an error if the path is not an absolute path
        Throws /The "path" must be an absolute path/ fern#fri#from#filepath('foo\bar')
      End

      It returns FRI from C:\
        let expr = 'C:\'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'C:',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from C:\foo\bar
        let expr = 'C:\foo\bar'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'C:/foo/bar',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from C:\foo\bar?a&b=c
        let expr = 'C:\foo\bar?a&b=c'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'C:/foo/bar%3Fa&b=c',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from C:\foo\bar;a&b=c
        let expr = 'C:\foo\bar;a&b=c'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'C:/foo/bar%3Ba&b=c',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from C:\foo\bar#foo\bar\hoge
        let expr = 'C:\foo\bar#foo\bar\hoge'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'C:/foo/bar%23foo/bar/hoge',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from C:\foo\bar?a&b=c#foo\bar\hoge
        let expr = 'C:\foo\bar?a&b=c#foo\bar\hoge'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'C:/foo/bar%3Fa&b=c%23foo/bar/hoge',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from C:\foo\bar;a&b=c#foo\bar\hoge
        let expr = 'C:\foo\bar;a&b=c#foo\bar\hoge'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'C:/foo/bar%3Ba&b=c%23foo/bar/hoge',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End
    End

    Context Unix
      Before
        let g:fern#internal#filepath#is_windows = 0
      End

      It throws an error if the path is not an absolute path
        Throws /The "path" must be an absolute path/ fern#fri#from#filepath('foo/bar')
      End

      It returns FRI from /
        let expr = '/'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': '',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from /foo/bar
        let expr = '/foo/bar'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'foo/bar',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from /foo/bar?a&b=c
        let expr = '/foo/bar?a&b=c'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'foo/bar%3Fa&b=c',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from /foo/bar;a&b=c
        let expr = '/foo/bar;a&b=c'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'foo/bar%3Ba&b=c',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from /foo/bar#foo/bar/hoge
        let expr = '/foo/bar#foo/bar/hoge'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'foo/bar%23foo/bar/hoge',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from /foo/bar?a&b=c#foo/bar/hoge
        let expr = '/foo/bar?a&b=c#foo/bar/hoge'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'foo/bar%3Fa&b=c%23foo/bar/hoge',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End

      It returns FRI from /foo/bar;a&b=c#foo/bar/hoge
        let expr = '/foo/bar;a&b=c#foo/bar/hoge'
        let want = {
              \ 'scheme': 'file',
              \ 'authority': '',
              \ 'path': 'foo/bar%3Ba&b=c%23foo/bar/hoge',
              \ 'query': {},
              \ 'fragment': '',
              \}
        Assert Equals(fern#fri#from#filepath(expr), want)
      End
    End
  End
End

./test/fern/fri.vimspec	[[[1
346
Describe fern#fri
  Describe #new()
    It returns FRI from a full FRI
      let want = {
            \ 'scheme': 'ssh',
            \ 'authority': 'user:pass@example.com',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \   'width': '50',
            \ },
            \ 'fragment': 'fragment',
            \}
      let full = copy(want)
      Assert Equals(fern#fri#new(full), want)
    End

    It returns FRI from a partial FRI
      Assert Equals(fern#fri#new({ 'scheme': 'hello' }), {
            \ 'scheme': 'hello',
            \ 'authority': '',
            \ 'path': '',
            \ 'query': {},
            \ 'fragment': '',
            \})
      Assert Equals(fern#fri#new({ 'authority': 'hello' }), {
            \ 'scheme': '',
            \ 'authority': 'hello',
            \ 'path': '',
            \ 'query': {},
            \ 'fragment': '',
            \})
      Assert Equals(fern#fri#new({ 'path': 'hello' }), {
            \ 'scheme': '',
            \ 'authority': '',
            \ 'path': 'hello',
            \ 'query': {},
            \ 'fragment': '',
            \})
      Assert Equals(fern#fri#new({ 'query': { 'hello': 'world' } }), {
            \ 'scheme': '',
            \ 'authority': '',
            \ 'path': '',
            \ 'query': {
            \   'hello': 'world',
            \ },
            \ 'fragment': '',
            \})
      Assert Equals(fern#fri#new({ 'fragment': 'hello' }), {
            \ 'scheme': '',
            \ 'authority': '',
            \ 'path': '',
            \ 'query': {},
            \ 'fragment': 'hello',
            \})
    End
  End

  Describe #parse()
    It returns FRI for 'file:///foo/bar'
      let expr = 'file:///foo/bar'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'file:///foo/bar;drawer'
      let expr = 'file:///foo/bar;drawer'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \ },
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'file:///foo/bar;width=50&drawer'
      let expr = 'file:///foo/bar;width=50&drawer'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \   'width': '50',
            \ },
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'file:///foo/bar;width=50&drawer#fragment'
      let expr = 'file:///foo/bar;width=50&drawer#fragment'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \   'width': '50',
            \ },
            \ 'fragment': 'fragment',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'ssh://user:pass@example.com/foo/bar;width=50&drawer#fragment'
      let expr = 'ssh://user:pass@example.com/foo/bar;width=50&drawer#fragment'
      let want = {
            \ 'scheme': 'ssh',
            \ 'authority': 'user:pass@example.com',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \   'width': '50',
            \ },
            \ 'fragment': 'fragment',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'file:///foo%20bar%20baz'
      let expr = 'file:///foo%20bar%20baz'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo bar baz',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'fri://qux/file:///foo%252520bar%252520baz'
      let expr = 'fri://qux/file:///foo%252520bar%252520baz'
      let want = {
            \ 'scheme': 'fri',
            \ 'authority': 'qux',
            \ 'path': 'file:///foo%2520bar%2520baz',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'file:///foobar'
      let expr = 'file:///foobar'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foobar',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End

    It returns FRI for 'ssh://localhost/'
      let expr = 'ssh://localhost/'
      let want = {
            \ 'scheme': 'ssh',
            \ 'authority': 'localhost',
            \ 'path': '',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#parse(expr), want)
    End
  End

  Describe #format()
    It formats FRI to 'file:///foo/bar'
      let expr = 'file:///foo/bar'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#format(want), expr)
    End

    It formats FRI to 'file:///foo/bar;drawer'
      let expr = 'file:///foo/bar;drawer'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \ },
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#format(want), expr)
    End

    It formats FRI to 'file:///foo/bar;width=50&drawer'
      let expr = 'file:///foo/bar;width=50&drawer'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \   'width': '50',
            \ },
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#format(want), expr)
    End

    It formats FRI to 'file:///foo/bar;width=50&drawer#fragment'
      let expr = 'file:///foo/bar;width=50&drawer#fragment'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \   'width': '50',
            \ },
            \ 'fragment': 'fragment',
            \}
      Assert Equals(fern#fri#format(want), expr)
    End

    It formats FRI to 'ssh://user:pass@example.com/foo/bar;drawer&width=50#fragment'
      let expr = 'ssh://user:pass@example.com/foo/bar;width=50&drawer#fragment'
      let want = {
            \ 'scheme': 'ssh',
            \ 'authority': 'user:pass@example.com',
            \ 'path': 'foo/bar',
            \ 'query': {
            \   'drawer': v:true,
            \   'width': '50',
            \ },
            \ 'fragment': 'fragment',
            \}
      Assert Equals(fern#fri#format(want), expr)
    End

    It formats FRI to 'file:///foo%20bar%20baz'
      let expr = 'file:///foo%20bar%20baz'
      let want = {
            \ 'scheme': 'file',
            \ 'authority': '',
            \ 'path': 'foo bar baz',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#format(want), expr)
    End

    It formats FRI to 'fri://qux/file:///foo%252520bar%252520baz'
      let expr = 'fri://qux/file:///foo%252520bar%252520baz'
      let want = {
            \ 'scheme': 'fri',
            \ 'authority': 'qux',
            \ 'path': 'file:///foo%2520bar%2520baz',
            \ 'query': {},
            \ 'fragment': '',
            \}
      Assert Equals(fern#fri#format(want), expr)
    End
  End

  Describe #encode()
    It encodes percent character (%)
      Assert Equals(fern#fri#encode('%'), '%25')
    End

    It encodes unusable characters (< > | ? *)
      Assert Equals(fern#fri#encode('<'), '%3C')
      Assert Equals(fern#fri#encode('>'), '%3E')
      Assert Equals(fern#fri#encode('|'), '%7C')
      Assert Equals(fern#fri#encode('?'), '%3F')
      Assert Equals(fern#fri#encode('*'), '%2A')
    End

    It encodes characters matches the {pattern}
      let pattern = '[#\[\]= ]'
      Assert Equals(fern#fri#encode('#'), '#')
      Assert Equals(fern#fri#encode('['), '[')
      Assert Equals(fern#fri#encode(']'), ']')
      Assert Equals(fern#fri#encode('='), '=')
      Assert Equals(fern#fri#encode(' '), ' ')
      Assert Equals(fern#fri#encode('#', pattern), '%23')
      Assert Equals(fern#fri#encode('[', pattern), '%5B')
      Assert Equals(fern#fri#encode(']', pattern), '%5D')
      Assert Equals(fern#fri#encode('=', pattern), '%3D')
      Assert Equals(fern#fri#encode(' ', pattern), '%20')
    End

    It encodes all percent character (%)
      Assert Equals(fern#fri#encode('%%'), '%25%25')
    End
  End

  Describe #decode()
    It decodes percent-encoded percent character (%)
      Assert Equals(fern#fri#decode('%25'), '%')
    End

    It decodes percent-encoded unusable characters (< > | ? *)
      Assert Equals(fern#fri#decode('%3C'), '<')
      Assert Equals(fern#fri#decode('%3E'), '>')
      Assert Equals(fern#fri#decode('%7C'), '|')
      Assert Equals(fern#fri#decode('%3F'), '?')
      Assert Equals(fern#fri#decode('%2A'), '*')
    End

    It decodes any percent-encoded characters (# [ ] = )
      Assert Equals(fern#fri#decode('%23'), '#')
      Assert Equals(fern#fri#decode('%5B'), '[')
      Assert Equals(fern#fri#decode('%5D'), ']')
      Assert Equals(fern#fri#decode('%3D'), '=')
      Assert Equals(fern#fri#decode('%20'), ' ')
    End

    It decodes only one depth
      Assert Equals(fern#fri#decode('%252523'), '%2523')
      Assert Equals(fern#fri#decode('%2523'), '%23')
      Assert Equals(fern#fri#decode('%23'), '#')
    End

    It decodes all percent character (%)
      Assert Equals(fern#fri#decode('%23%23'), '##')
    End

    It decodes all percent character (%) only one depth
      Assert Equals(fern#fri#decode('%252523%252523'), '%2523%2523')
      Assert Equals(fern#fri#decode('%2523%2523'), '%23%23')
      Assert Equals(fern#fri#decode('%23%23'), '##')
    End
  End
End
./test/fern/helper.vimspec	[[[1
273
Describe fern#helper
  After all
    noautocmd %bwipeout!
  End

  Before
    noautocmd %bwipeout!
    let TIMEOUT = 5000
    let STATUS_EXPANDED = g:fern#STATUS_EXPANDED
    let Promise = vital#fern#import('Async.Promise')

    noautocmd edit fern:///debug:///
    let [_, e] = Promise.wait(
         \ fern#internal#viewer#init(),
         \ { 'timeout': TIMEOUT },
         \)
    Assert Equals(e, v:null)

    let sync_methods = [
          \ 'echo',
          \ 'echomsg',
          \ 'get_root_node',
          \ 'get_cursor_node',
          \ 'get_marked_nodes',
          \ 'get_selected_nodes',
          \ 'get_cursor',
          \ 'set_cursor',
          \ 'save_cursor',
          \ 'restore_cursor',
          \ 'cancel',
          \ 'is_drawer',
          \ 'get_scheme',
          \ 'process_node',
          \ 'focus_node',
          \]

    let async_methods = [
          \ 'sleep',
          \ 'redraw',
          \ 'remark',
          \ 'get_child_nodes',
          \ 'set_mark',
          \ 'set_hidden',
          \ 'set_include',
          \ 'set_exclude',
          \ 'update_nodes',
          \ 'update_marks',
          \ 'expand_node',
          \ 'collapse_node',
          \ 'reload_node',
          \ 'reveal_node',
          \ 'enter_tree',
          \ 'leave_tree',
          \]
  End

  Describe #new()
    It returns a new helper instance
      let helper = fern#helper#new()
      Assert KeyExists(helper, 'fern')
      Assert KeyExists(helper, 'bufnr')
      Assert KeyExists(helper, 'winid')
      Assert KeyExists(helper, 'STATUS_NONE')
      Assert KeyExists(helper, 'STATUS_COLLAPSED')
      Assert KeyExists(helper, 'STATUS_EXPANDED')
      Assert KeyExists(helper, 'sync')
      Assert KeyExists(helper, 'async')

      for sync_method in sync_methods
        Assert KeyExists(helper.sync, sync_method)
        Assert IsFunction(helper.sync[sync_method])
      endfor

      for async_method in async_methods
        Assert KeyExists(helper.async, async_method)
        Assert IsFunction(helper.async[async_method])
      endfor
    End
  End

  Describe a helper instance
    Before
      let helper = fern#helper#new()
    End

    Describe .sync
      Describe .echo
        It echos message
          let output = execute("call helper.sync.echo('Hello')")
          Assert Equals(output, "\nHello")
        End
      End

      Describe .echomsg
        It echos message
          let output = execute("call helper.sync.echomsg('Hello')")
          Assert Equals(output, "\nHello")
        End
      End

      Describe .get_root_node()
        It returns a root node
          Assert Equals(helper.sync.get_root_node(), helper.fern.root)
        End
      End

      Describe .get_cursor_node()
        It returns a cursor node
          call setpos('.', [0, 1, 1, 0, 1])
          Assert Equals(helper.sync.get_cursor_node(), helper.fern.nodes[0])
          call setpos('.', [0, 3, 1, 0, 1])
          Assert Equals(helper.sync.get_cursor_node(), helper.fern.nodes[2])
        End
      End

      Describe .get_marked_nodes()
        It returns marked nodes
          Assert Equals(helper.sync.get_marked_nodes(), [])

          let helper.async.set_mark(['deep'], 1)
          let helper.async.set_mark(['shallow'], 1)
          Assert Equals(helper.sync.get_marked_nodes(), [
                \ helper.fern.nodes[1],
                \ helper.fern.nodes[3],
                \])
        End
      End

      Describe .get_selected_nodes()
        It returns marked nodes if at least one node has marked
          let helper.async.set_mark([], 1)
          Assert Equals(helper.sync.get_selected_nodes(), helper.sync.get_marked_nodes())
        End

        It returns a cursor node in list if no node has marked
          Assert Equals(helper.sync.get_selected_nodes(), [helper.sync.get_cursor_node()])
        End
      End

      Describe .get_cursor()
        It returns a [line, col - 1] list
          Assert Equals(helper.sync.get_cursor(), [line('.'), col('.') - 1])
        End
      End

      Describe .set_cursor()
        It move cursor position
          call helper.sync.set_cursor([2, 4])
          Assert Equals(line('.'), 2)
          Assert Equals(col('.'), 5)
        End
      End

      Describe .save_cursor()
        It does not raise exception
          call helper.sync.save_cursor()
        End
      End

      Describe .restore_cursor()
        It does not raise exception
          call helper.sync.restore_cursor()
        End
      End

      Describe .cancel()
        It does not raise exception
          call helper.sync.cancel()
        End
      End

      Describe .is_drawer()
        It does not raise exception
          call helper.sync.is_drawer()
        End

        It returns a boolean
          Assert IsNumber(helper.sync.is_drawer())
        End

        It returns 1 if the fern is shown in a project drawer
          vsplit
          Fern debug:/// -drawer -wait
          let helper = fern#helper#new()
          Assert True(helper.sync.is_drawer())
        End

        It returns 0 if the fern is NOT shown in a project drawer
          Fern debug:/// -wait
          let helper = fern#helper#new()
          Assert False(helper.sync.is_drawer())
        End
      End

      Describe .get_scheme()
        It does not raise exception
          call helper.sync.get_scheme()
        End

        It returns a string
          Assert IsString(helper.sync.get_scheme())
        End

        It returns a scheme name of a fern buffer
          Fern debug:/// -wait
          let helper = fern#helper#new()
          Assert Equals(helper.sync.get_scheme(), 'debug')

          Fern dict:/// -wait
          let helper = fern#helper#new()
          Assert Equals(helper.sync.get_scheme(), 'dict')

          Fern file:/// -wait
          let helper = fern#helper#new()
          Assert Equals(helper.sync.get_scheme(), 'file')
        End
      End

      Describe .process_node()
        It does not raise exception
          let root = helper.sync.get_root_node()
          call helper.sync.process_node(root)
        End

        It returns a function
          let root = helper.sync.get_root_node()
          Assert IsFunction(helper.sync.process_node(root))
        End
      End

      Describe .focus_node()
        It does not raise exception
          let root = helper.sync.get_root_node()
          call helper.sync.focus_node(root.__key)
        End
      End
    End

    Describe .async
      Describe .sleep()
        It returns a promise
          let p = helper.async.sleep(1)
          Assert True(Promise.is_promise(p))
        End

        It does not reject the promise
          let [r, e] = Promise.wait(
               \ helper.async.sleep(1),
               \ { 'timoeut': TIMEOUT },
               \)
          Assert Equals(e, v:null)
        End
      End

      Describe .redraw()
        It returns a promise
          let p = helper.async.redraw()
          Assert True(Promise.is_promise(p))
        End

        It does not reject the promise
          let [r, e] = Promise.wait(
               \ helper.async.redraw(),
               \ { 'timoeut': TIMEOUT },
               \)
          Assert Equals(e, v:null)
        End
      End

      " TODO Write tests
    End
  End
End
./test/fern/hook.vimspec	[[[1
57
Describe fern#hook
  Describe #emit()
    It emits hooks added by #add()
      let ns1 = []
      let ns2 = []
      call fern#hook#add('t', { -> extend(ns1, a:000) })
      call fern#hook#add('t', { -> extend(ns2, a:000) })
      call fern#hook#emit('t', 'hello', 'world')
      Assert Equals(ns1, ['hello', 'world'])
      Assert Equals(ns2, ['hello', 'world'])
    End

    It emits hooks added by #add() and remove 'once' hooks
      let ns1 = []
      let ns2 = []
      call fern#hook#add('t', { -> extend(ns1, a:000) })
      call fern#hook#add('t', { -> extend(ns2, a:000) }, {
            \ 'once': 1,
            \})
      call fern#hook#emit('t', 'hello', 'world')
      Assert Equals(ns1, ['hello', 'world'])
      Assert Equals(ns2, ['hello', 'world'])

      call fern#hook#emit('t', 'hello', 'world')
      Assert Equals(ns1, ['hello', 'world', 'hello', 'world'])
      Assert Equals(ns2, ['hello', 'world'])
    End
  End

  Describe #remove()
    It removes a specfied hook
      let ns1 = []
      let ns2 = []
      call fern#hook#add('t', { -> extend(ns1, a:000) })
      call fern#hook#add('t', { -> extend(ns2, a:000) }, {
            \ 'id': 'remove this'
            \})
      call fern#hook#remove('t', 'remove this')
      call fern#hook#emit('t', 'hello', 'world')
      Assert Equals(ns1, ['hello', 'world'])
      Assert Equals(ns2, [])
    End

    It removes all hooks if no {id} has specified
      let ns1 = []
      let ns2 = []
      call fern#hook#add('t', { -> extend(ns1, a:000) })
      call fern#hook#add('t', { -> extend(ns2, a:000) }, {
            \ 'id': 'remove this'
            \})
      call fern#hook#remove('t')
      call fern#hook#emit('t', 'hello', 'world')
      Assert Equals(ns1, [])
      Assert Equals(ns2, [])
    End
  End
End
./test/fern/internal/buffer.vimspec	[[[1
205
Describe fern#internal#buffer
  After all
    %bwipeout!
  End

  Before
    %bwipeout!
    if !has('nvim')
      call prop_type_add('test_prop', { 'highlight': 'Question' })
    endif
  End

  After
    let g:fern#enable_textprop_support = 0
    if !has('nvim')
      call prop_type_delete('test_prop')
    endif
  End

  Describe #replace()
    It replaces a content of a given buffer to a given content
      let bufnr = bufnr('%')
      call setline(1, [
            \ "Hello",
            \ "Darkness",
            \ "My",
            \ "Old",
            \ "Friend",
            \])
      new
      call fern#internal#buffer#replace(bufnr, [
            \ "Hello",
            \ "World",
            \])
      Assert Equals(getbufline(bufnr, 1, '$'), [
            \ "Hello",
            \ "World",
            \])

      let bufnr = bufnr('%')
      call setline(1, [
            \ "Hello",
            \ "Darkness",
            \ "My",
            \ "Old",
            \ "Friend",
            \])
      new
      call fern#internal#buffer#replace(bufnr, [
            \ "hello",
            \ "darkness",
            \ "my",
            \ "old",
            \ "friend",
            \])
      Assert Equals(getbufline(bufnr, 1, '$'), [
            \ "hello",
            \ "darkness",
            \ "my",
            \ "old",
            \ "friend",
            \])
    End

    It success with 'nomodifiable'
      let bufnr = bufnr('%')
      call setline(1, [
            \ "Hello",
            \ "Darkness",
            \ "My",
            \ "Old",
            \ "Friend",
            \])
      setlocal nomodifiable
      new
      call fern#internal#buffer#replace(bufnr, [
            \ "Hello",
            \ "World",
            \])
      Assert Equals(getbufline(bufnr, 1, '$'), [
            \ "Hello",
            \ "World",
            \])
      Assert Equals(getbufvar(bufnr, '&modifiable'), 0)
    End

    It does not touch 'modified'
      let bufnr = bufnr('%')
      call setline(1, [
            \ "Hello",
            \ "Darkness",
            \ "My",
            \ "Old",
            \ "Friend",
            \])
      setlocal nomodified
      new
      call fern#internal#buffer#replace(bufnr, [
            \ "Hello",
            \ "World",
            \])
      Assert Equals(getbufline(bufnr, 1, '$'), [
            \ "Hello",
            \ "World",
            \])
      Assert Equals(getbufvar(bufnr, '&modified'), 0)

      let bufnr = bufnr('%')
      call setline(1, [
            \ "Hello",
            \ "Darkness",
            \ "My",
            \ "Old",
            \ "Friend",
            \])
      setlocal modified
      new
      call fern#internal#buffer#replace(bufnr, [
            \ "Hello",
            \ "World",
            \])
      Assert Equals(getbufline(bufnr, 1, '$'), [
            \ "Hello",
            \ "World",
            \])
      Assert Equals(getbufvar(bufnr, '&modified'), 1)
    End

    It should replace buffer content with text and properties
      if has('nvim')
        Assert Skip('text properties are only supported in vim')
      endif

      let g:fern#enable_textprop_support = 1

      let bufnr = bufnr('%')
      call setline(1, [
            \ "Hello",
            \ "Darkness",
            \ "My",
            \ "Old",
            \ "Friend",
            \])
      new
      call fern#internal#buffer#replace(bufnr, [
            \ { 'text': 'Empty Props', 'props': [] },
            \ { 'text': 'Undefined Props' },
            \ { 'text': 'With Properties!', 'props':
            \   [{ 'col': 1, 'length': 4, 'type': 'test_prop' }]
            \ },
            \])
      Assert Equals(getbufline(bufnr, 1, '$'), [
            \ "Empty Props",
            \ "Undefined Props",
            \ "With Properties!",
            \])

      Assert True(empty(prop_list(1, { 'bufnr': bufnr })))
      Assert True(empty(prop_list(2, { 'bufnr': bufnr })))

      let result_props = prop_list(3, { 'bufnr': bufnr })
      Assert Equal(len(result_props), 1)
      Assert Equal(result_props[0].col, 1)
      Assert Equal(result_props[0].length, 4)
      Assert Equal(result_props[0].type, 'test_prop')
    End
  End

  Describe #open()
    It opens a new buffer with opener
      call fern#internal#buffer#open('hello', {
            \ 'opener': 'edit',
            \})
      Assert Equals(winnr('$'), 1)
      %bwipeout!

      call fern#internal#buffer#open('hello', {
            \ 'opener': 'split',
            \})
      Assert Equals(winnr('$'), 2)
      %bwipeout!

      call fern#internal#buffer#open('hello', {
            \ 'opener': 'vsplit',
            \})
      Assert Equals(winnr('$'), 2)
      %bwipeout!

      call fern#internal#buffer#open('hello1', {
            \ 'opener': 'edit',
            \})
      call fern#internal#buffer#open('hello2', {
            \ 'opener': 'vsplit',
            \})
      call fern#internal#buffer#open('hello1', {
            \ 'opener': 'drop',
            \})
      Assert Equals(winnr(), 2)
      call fern#internal#buffer#open('hello2', {
            \ 'opener': 'drop',
            \})
      Assert Equals(winnr(), 1)
    End
  End
End
./test/fern/internal/complete.vimspec	[[[1
454
Describe fern#internal#complete
  Before all
    if exists('+shellslash')
      let [saved_shellslash, &shellslash] = [&shellslash, 0]
    endif
    let pathsep = fnamemodify('.', ':p')[-1 :]
    let saved_dir = getcwd()
    let temp_dir = fnamemodify(tempname(), ':p')
    let test_dir = fnamemodify(temp_dir . pathsep . 'test', ':p')
    let other_dir = fnamemodify(temp_dir . pathsep . 'other', ':p')
    call mkdir(test_dir, 'p')
    call mkdir(other_dir, 'p')
    execute 'cd' fnameescape(test_dir)
    call map(['foo', 'bar', 'baz'], { -> mkdir(v:val) })
    call writefile([], 'qux')
  End

  After all
    execute 'cd' fnameescape(saved_dir)
    call delete(temp_dir, 'rf')
    if exists('+shellslash')
      let &shellslash = saved_shellslash
    endif
  End

  Before
    execute 'cd' fnameescape(test_dir)
  End

  After
    execute 'cd' fnameescape(saved_dir)
  End

  Describe #opener()
    It returns all openers
      let arglead = '-opener='
      let cmdline = 'Fern -opener='
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-opener=select',
            \ '-opener=edit',
            \ '-opener=edit/split',
            \ '-opener=edit/vsplit',
            \ '-opener=edit/tabedit',
            \ '-opener=split',
            \ '-opener=vsplit',
            \ '-opener=tabedit',
            \ '-opener=leftabove\ split',
            \ '-opener=leftabove\ vsplit',
            \ '-opener=rightbelow\ split',
            \ '-opener=rightbelow\ vsplit',
            \ '-opener=topleft\ split',
            \ '-opener=topleft\ vsplit',
            \ '-opener=botright\ split',
            \ '-opener=botright\ vsplit',
            \]
      let got = fern#internal#complete#opener(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns openers whose name starts with 'e'
      let arglead = '-opener=e'
      let cmdline = 'Fern -opener=e'
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-opener=edit',
            \ '-opener=edit/split',
            \ '-opener=edit/vsplit',
            \ '-opener=edit/tabedit',
            \]
      let got = fern#internal#complete#opener(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns openers whose name ends with backslash
      let arglead = '-opener=leftabove\'
      let cmdline = 'Fern -opener=leftabove\'
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-opener=leftabove\ split',
            \ '-opener=leftabove\ vsplit',
            \]
      let got = fern#internal#complete#opener(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns openers whose name ends with space
      let arglead = '-opener=leftabove\ '
      let cmdline = 'Fern -opener=leftabove\ '
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-opener=leftabove\ split',
            \ '-opener=leftabove\ vsplit',
            \]
      let got = fern#internal#complete#opener(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no openers, if opener is unknown
      let arglead = '-opener=x'
      let cmdline = 'Fern -opener=x'
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#opener(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no openers, if arglead is invalid
      let invalid_argleads = ['opener=', '^', '$', '.', '[o]']
      for arglead in invalid_argleads
        let cmdline = 'Fern ' . arglead
        let cursorpos = strlen(cmdline)
        let want = []
        let got = fern#internal#complete#opener(arglead, cmdline, cursorpos)
        Assert Equals(got, want, 'arglead pattern: ' . string(arglead))
      endfor
    End
  End

  Describe #options()
    It returns all options of ':Fern'
      let arglead = '-'
      let cmdline = 'Fern -'
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-drawer',
            \ '-keep',
            \ '-opener=',
            \ '-reveal=',
            \ '-stay',
            \ '-toggle',
            \ '-wait',
            \ '-width=',
            \]
      let got = fern#internal#complete#options(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns all options of ':FernDo'
      let arglead = '-'
      let cmdline = 'FernDo -'
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-drawer',
            \ '-stay',
            \]
      let got = fern#internal#complete#options(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns all options of ':FernReveal'
      let arglead = '-'
      let cmdline = 'FernReveal -'
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-wait',
            \]
      let got = fern#internal#complete#options(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns options of ':Fern' whose name starts with 'w'
      let arglead = '-w'
      let cmdline = 'Fern -w'
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-wait',
            \ '-width=',
            \]
      let got = fern#internal#complete#options(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no options, if arglead is unknown
      let arglead = '-xxx'
      let cmdline = 'Fern -xxx'
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#options(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no options, if arglead is invalid
      let invalid_argleads = ['opener', '^', '$', '.', '[o]']
      for arglead in invalid_argleads
        let cmdline = 'Fern ' . arglead
        let cursorpos = strlen(cmdline)
        let want = []
        let got = fern#internal#complete#options(arglead, cmdline, cursorpos)
        Assert Equals(got, want, 'arglead pattern: ' . string(arglead))
      endfor
    End
  End

  Describe #url()
    It returns directories within the current directory
      let arglead = ''
      let cmdline = 'Fern '
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo'], { -> v:val . pathsep })
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns directories within an absolute directory
      let path = test_dir . pathsep
      let arglead = path
      let cmdline = 'Fern ' . path
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo'], { -> path . v:val . pathsep })
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns directories within a relative directory
      execute 'cd' fnameescape('..')
      let path = fnamemodify(test_dir, ':t') . pathsep
      let arglead = path
      let cmdline = 'Fern ' . path
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo'], { -> path . v:val . pathsep })
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns directories within a parent directory
      execute 'cd' fnameescape('foo')
      let path = '..' . pathsep
      let arglead = path
      let cmdline = 'Fern ' . path
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo'], { -> path . v:val . pathsep })
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns only a directory with exact name matches
      let arglead = 'foo'
      let cmdline = 'Fern foo'
      let cursorpos = strlen(cmdline)
      let want = map(['foo'], { -> v:val . pathsep })
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns only directories with matching names
      let arglead = 'ba'
      let cmdline = 'Fern ba'
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz'], { -> v:val . pathsep })
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no directories if no sub-directories
      let arglead = 'foo' . pathsep
      let cmdline = 'Fern foo' . pathsep
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no directories if the specified path does not exist
      let arglead = 'foobar' . pathsep
      let cmdline = 'Fern foobar' . pathsep
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no directories if the specified path is not a directory
      let arglead = 'qux' . pathsep
      let cmdline = 'Fern qux' . pathsep
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns directories in the file scheme URL
      execute 'cd' fnameescape(other_dir)
      let url = fern#fri#format(fern#fri#from#filepath(test_dir)) . '/'
      let arglead = url
      let cmdline = 'Fern ' . url
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo'], { -> url . v:val })
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns only scheme URL if the specified URL has invalid scheme
      execute 'cd' fnameescape(other_dir)
      let fri = extend(fern#fri#from#filepath(test_dir), {'scheme': 'xxx'})
      let url = fern#fri#format(fri) . '/'
      let arglead = url
      let cmdline = 'Fern ' . url
      let cursorpos = strlen(cmdline)
      let want = ['xxx:///']
      let got = fern#internal#complete#url(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End
  End

  Describe #reveal()
    It returns files and directories within the current directory if no base path
      let arglead = '-reveal='
      let cmdline = printf('Fern %s', arglead)
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo', 'qux'], { -> arglead . v:val })
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns files and directories within the absolute base path
      execute 'cd' fnameescape(other_dir)
      let arglead = '-reveal='
      let cmdline = printf('Fern %s %s', test_dir, arglead)
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo', 'qux'], { -> arglead . v:val })
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns files and directories within the relative base path
      execute 'cd' fnameescape('..')
      let base = fnamemodify(test_dir, ':t')
      let arglead = '-reveal='
      let cmdline = printf('Fern %s %s', fnameescape(base), arglead)
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo', 'qux'], { -> arglead . v:val })
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns files and directories within a relative directory
      execute 'cd' fnameescape(other_dir)
      let base = fnamemodify(test_dir, ':h')
      let arglead = fnameescape('-reveal=' . fnamemodify(test_dir, ':t') . pathsep)
      let cmdline = printf('Fern %s %s', fnameescape(base), arglead)
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo', 'qux'], { -> arglead . v:val })
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns files and directories within an absolute directory (ignore base path)
      execute 'cd' fnameescape(other_dir)
      let base = fnamemodify(test_dir, ':h')
      let arglead = fnameescape('-reveal=' . test_dir . pathsep)
      let cmdline = printf('Fern %s %s', fnameescape(base), arglead)
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo', 'qux'], { -> arglead . v:val })
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns files and directories within a parent directory (relative paths are normalized)
      execute 'cd' fnameescape(other_dir)
      let base = test_dir . pathsep . 'foo'
      let arglead = '-reveal=..' . pathsep
      let cmdline = printf('Fern %s %s', fnameescape(base), arglead)
      let cursorpos = strlen(cmdline)
      let want = [
            \ '-reveal=..' . pathsep . 'bar',
            \ '-reveal=..' . pathsep . 'baz',
            \ '-reveal=',
            \ '-reveal=..' . pathsep . 'qux',
            \]
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns only a file or directory with exact name matches
      let arglead = '-reveal=foo'
      let cmdline = 'Fern . ' . arglead
      let cursorpos = strlen(cmdline)
      let want = ['-reveal=foo']
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns only files or directories with matching names
      let arglead = '-reveal=ba'
      let cmdline = 'Fern . ' . arglead
      let cursorpos = strlen(cmdline)
      let want = ['-reveal=bar', '-reveal=baz']
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no files or directories if no sub-directories
      let arglead = '-reveal=foo' . pathsep
      let cmdline = 'Fern . ' . arglead
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no files or directories if the specified path does not exist
      let arglead = '-reveal=foobar' . pathsep
      let cmdline = 'Fern . ' . arglead
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no files or directories if the specified path is not a directory
      let arglead = '-reveal=qux' . pathsep
      let cmdline = 'Fern . ' . arglead
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns files and directories in the file scheme URL
      execute 'cd' fnameescape(other_dir)
      let base_url = fern#fri#format(fern#fri#from#filepath(test_dir)) . '/'
      let arglead = '-reveal='
      let cmdline = printf('Fern %s %s', base_url, arglead)
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo', 'qux'], { -> arglead . v:val })
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns files and directories within a relative path of the file scheme URL
      let base = fnamemodify(test_dir, ':h:p')
      let base_url = fern#fri#format(fern#fri#from#filepath(base)) . '/'
      let arglead = '-reveal=' . fnamemodify(test_dir, ':t') . '/'
      let cmdline = printf('Fern %s %s', base_url, arglead)
      let cursorpos = strlen(cmdline)
      let want = map(['bar', 'baz', 'foo', 'qux'], { -> arglead . v:val })
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End

    It returns no directories if the base URL has invalid scheme
      execute 'cd' fnameescape(other_dir)
      let fri = extend(fern#fri#from#filepath(test_dir), {'scheme': 'xxx'})
      let base_url = fern#fri#format(fri) . '/'
      let arglead = '-reveal='
      let cmdline = printf('Fern %s %s', base_url, arglead)
      let cursorpos = strlen(cmdline)
      let want = []
      let got = fern#internal#complete#reveal(arglead, cmdline, cursorpos)
      Assert Equals(got, want)
    End
  End
End
./test/fern/internal/core.vimspec	[[[1
304
Describe fern#internal#core
  Before
    let TIMEOUT = 5000
    let STATUS_EXPANDED = g:fern#STATUS_EXPANDED
    let Promise = vital#fern#import('Async.Promise')
    let provider = fern#scheme#debug#provider#new()
  End

  Describe #new()
    It returns a fern instance of given url and provider
      let fern = fern#internal#core#new('debug:///', provider)
      Assert KeyExists(fern, 'scheme')
      Assert KeyExists(fern, 'source')
      Assert KeyExists(fern, 'provider')
      Assert KeyExists(fern, 'comparator')
      Assert KeyExists(fern, 'root')
      Assert KeyExists(fern, 'nodes')
      Assert KeyExists(fern, 'visible_nodes')
      Assert KeyExists(fern, 'marks')
      Assert KeyExists(fern, 'hidden')
      Assert KeyExists(fern, 'include')
      Assert KeyExists(fern, 'exclude')
    End
  End

  Describe #cancel()
    Before
      let fern = fern#internal#core#new('debug:///', provider)
    End

    It cancels the source and assign new CancellationTokenSource instance
      let fern = fern#internal#core#new('debug:///', provider)
      let source = fern.source
      let token = source.token
      call fern#internal#core#cancel(fern)
      Assert True(token.cancellation_requested())
      Assert NotEqual(source, fern.source)
    End
  End

  Describe #update_nodes()
    Before
      let fern = fern#internal#core#new('debug:///', provider)
      let [children, _] = Promise.wait(
            \ fern#internal#node#children(fern.root, provider, fern.source.token),
            \ { 'timeout': TIMEOUT },
            \)
    End

    It returns a promise
      let p = fern#internal#core#update_nodes(fern, [fern.root] + children)
      Assert True(Promise.is_promise(p))
    End

    It updates 'nodes'
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
    End

    It updates 'visible_nodes'
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
    End

    It removes HIDDEN nodes from 'visible_nodes'
      let children[1].hidden = 1
      let children[3].hidden = 1
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/heavy',
            \])
    End

    It does NOT remove HIDDEN nodes from 'visible_nodes' if the nodes are expanded
      let children[1].hidden = 1
      let children[1].status = STATUS_EXPANDED
      let children[3].hidden = 1
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \])
    End

    It does NOT remove HIDDEN nodes from 'visible_nodes' when fern.hidden is TRUE
      let children[1].hidden = 1
      let children[3].hidden = 1
      let fern.hidden = 1
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
    End

    It removes non INCLUDE nodes from 'visible_nodes' by fern.include
      let fern.include = '^\%(root\|shallow\|heavy\)$'
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/heavy',
            \])
    End

    It does NOT removes non INCLUDE nodes from 'visible_nodes' if the nodes are expanded
      let children[1].status = STATUS_EXPANDED
      let fern.include = '^\%(root\|shallow\|heavy\)$'
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \])
    End

    It removes EXCLUDE nodes from 'visible_nodes' by fern.exclude
      let fern.exclude = '^\%(deep\|leaf\)$'
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/heavy',
            \])
    End

    It does NOT removes EXCLUDE nodes from 'visible_nodes' if the nodes are expanded
      let children[1].status = STATUS_EXPANDED
      let fern.exclude = '^\%(deep\|leaf\)$'
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(map(copy(fern.nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \ '/leaf',
            \])
      Assert Equals(map(copy(fern.visible_nodes), { -> v:val._uri }), [
            \ '/',
            \ '/shallow',
            \ '/deep',
            \ '/heavy',
            \])
    End
  End

  Describe #update_marks()
    Before
      let fern = fern#internal#core#new('debug:///', provider)
      let [children, _] = Promise.wait(
            \ fern#internal#node#children(fern.root, provider, fern.source.token),
            \ { 'timeout': TIMEOUT },
            \)
      let [_, _] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
    End

    It returns a promise
      let p = fern#internal#core#update_marks(fern, [['shallow'], ['deep'], ['leaf']])
      Assert True(Promise.is_promise(p))
    End

    It updates 'marks'
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_marks(fern, [['shallow'], ['deep'], ['leaf']]),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(fern.marks, [
            \ ['shallow'],
            \ ['deep'],
            \ ['leaf'],
            \])
    End

    It removes marks for HIDDEN nodes
      let children[1].hidden = 1
      let children[3].hidden = 1
      let [_, _] = Promise.wait(
            \ fern#internal#core#update_nodes(fern, [fern.root] + children),
            \ { 'timeout': TIMEOUT },
            \)
      let [r, e] = Promise.wait(
            \ fern#internal#core#update_marks(fern, [['shallow'], ['deep'], ['leaf']]),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r, 0)
      Assert Equals(fern.marks, [
            \ ['shallow'],
            \])
    End
  End
End
./test/fern/internal/filepath.vimspec	[[[1
378
Describe fern#internal#filepath
  Before all
    let fern_internal_filepath_is_windows = g:fern#internal#filepath#is_windows
  End

  After all
    let g:fern#internal#filepath#is_windows = fern_internal_filepath_is_windows
  End

  Context Unix
    Before
      let g:fern#internal#filepath#is_windows = 0
    End

    Describe #to_slash()
      It returns an absolute path ('/usr/local' -> '/usr/local')
        let path = '/usr/local'
        let want = '/usr/local'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It returns a relative path ('usr/local' -> 'usr/local')
        let path = 'usr/local'
        let want = 'usr/local'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It removes duplicate slashes ('/usr//local' -> '/usr/local')
        let path = '/usr//local'
        let want = '/usr/local'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)

        let path = '/usr///local'
        let want = '/usr/local'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It removes trailing slashes ('/usr/local/' -> '/usr/local')
        let path = '/usr/local/'
        let want = '/usr/local'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)

        let path = '/usr/local//'
        let want = '/usr/local'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It does not remove a root slash ('/' -> '/')
        let path = '/'
        let want = '/'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It return a root for an empty string ('' -> '/')
        let path = ''
        let want = '/'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End
    End

    Describe #from_slash()
      It returns an absolute path ('/usr/local' -> '/usr/local')
        let path = '/usr/local'
        let want = '/usr/local'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It returns a relative path ('usr/local' -> 'usr/local')
        let path = 'usr/local'
        let want = 'usr/local'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It removes duplicate slashes ('/usr//local' -> '/usr/local')
        let path = '/usr//local'
        let want = '/usr/local'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)

        let path = '/usr///local'
        let want = '/usr/local'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It removes trailing slashes ('/usr/local/' -> '/usr/local')
        let path = '/usr/local/'
        let want = '/usr/local'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)

        let path = '/usr/local//'
        let want = '/usr/local'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It does not remove a root slash ('/' -> '/')
        let path = '/'
        let want = '/'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It return a root for an empty string ('' -> '/')
        let path = ''
        let want = '/'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End
    End

    Describe #is_root()
      It returns 1 for '/'
        let path = '/'
        Assert True(fern#internal#filepath#is_root(path))
      End

      It returns 0 for ''
        let path = ''
        Assert False(fern#internal#filepath#is_root(path))
      End

      It returns 0 for '/usr/local'
        let path = '/usr/local'
        Assert False(fern#internal#filepath#is_root(path))
      End
    End

    Describe #is_drive_root()
      It returns 1 for '/'
        let path = '/'
        Assert True(fern#internal#filepath#is_drive_root(path))
      End

      It returns 0 for ''
        let path = ''
        Assert False(fern#internal#filepath#is_drive_root(path))
      End

      It returns 0 for '/usr/local'
        let path = '/usr/local'
        Assert False(fern#internal#filepath#is_drive_root(path))
      End
    End

    Describe #is_absolute()
      It returns 1 for '/usr/local'
        Assert True(fern#internal#filepath#is_absolute('/usr/local'))
      End

      It returns 1 for '/'
        Assert True(fern#internal#filepath#is_absolute('/'))
      End

      It returns 1 for '' (to keep behavior consistency to Windows)
        Assert True(fern#internal#filepath#is_absolute(''))
      End

      It returns 0 for 'usr/local'
        Assert False(fern#internal#filepath#is_absolute('usr/local'))
      End

      It returns 0 for 'usr'
        Assert False(fern#internal#filepath#is_absolute('usr'))
      End
    End

    Describe #join()
      It returns a joined path
        let paths = [
              \ '/usr/local',
              \ 'bin',
              \]
        let want = '/usr/local/bin'
        let got = fern#internal#filepath#join(paths)
        Assert Equals(got, want)
      End
    End
  End

  Context Windows
    Before
      let g:fern#internal#filepath#is_windows = 1
    End

    Describe #to_slash()
      It returns a slash separated absolute path ('C:\Windows\System32' -> '/C:/Windows/System32')
        let path = 'C:\Windows\System32'
        let want = '/C:/Windows/System32'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It returns a slash separated relative path ('Windows\System32' for 'Windows/System32')
        let path = 'Windows\System32'
        let want = 'Windows/System32'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It removes duplicate baskslashes ('C:\Windows\\System32' -> '/C:/Windows/System32')
        let path = 'C:\Windows\\System32'
        let want = '/C:/Windows/System32'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)

        let path = 'C:\Windows\\\System32'
        let want = '/C:/Windows/System32'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It removes trailing baskslashes ('C:\Windows\System32\' -> '/C:/Windows/System32')
        let path = 'C:\Windows\System32\'
        let want = '/C:/Windows/System32'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)

        let path = 'C:\Windows\System32\\'
        let want = '/C:/Windows/System32'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It removes a backslash of a drive root ('C:\' -> '/C:')
        let path = 'C:\'
        let want = '/C:'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)

        let path = ''
        let want = '/'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End

      It returns a root for an empty string ('' -> '/')
        let path = ''
        let want = '/'
        let got = fern#internal#filepath#to_slash(path)
        Assert Equals(got, want)
      End
    End

    Describe #from_slash()
      It returns a baskslash separated absolute path ('/C:/Windows/System32' -> 'C:\Windows\System32')
        let path = '/C:/Windows/System32'
        let want = 'C:\Windows\System32'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It returns a backslash separated relative path ('Windows/System32' -> 'Windows\System32')
        let path = 'Windows/System32'
        let want = 'Windows\System32'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It removes duplicate slashes ('/C:/Windows//System32' -> 'C:\Windows\System32')
        let path = '/C:/Windows//System32'
        let want = 'C:\Windows\System32'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)

        let path = '/C:/Windows///System32'
        let want = 'C:\Windows\System32'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It removes trailing baskslashes ('/C:/Windows/System32/' -> 'C:\Windows\System32')
        let path = '/C:/Windows/System32/'
        let want = 'C:\Windows\System32'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)

        let path = '/C:/Windows/System32//'
        let want = 'C:\Windows\System32'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It does not remove a trailing baskslash of a drive root ('/C:/' -> 'C:\')
        let path = '/C:/'
        let want = 'C:\'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)

        let path = '/C:'
        let want = 'C:\'
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End

      It returns an empty string for a root ('/' -> '')
        let path = '/'
        let want = ''
        let got = fern#internal#filepath#from_slash(path)
        Assert Equals(got, want)
      End
    End

    Describe #is_root()
      It returns 1 for ''
        let path = ''
        Assert True(fern#internal#filepath#is_root(path))
      End

      It returns 0 for 'C:\Windows\System32'
        let path = 'C:\Windows\System32'
        Assert False(fern#internal#filepath#is_root(path))
      End
    End

    Describe #is_drive_root()
      It returns 1 for 'C:\'
        let path = 'C:\'
        Assert True(fern#internal#filepath#is_drive_root(path))
      End

      It returns 0 for ''
        let path = ''
        Assert False(fern#internal#filepath#is_drive_root(path))
      End

      It returns 0 for 'C:\Windows\System32'
        let path = 'C:\Windows\System32'
        Assert False(fern#internal#filepath#is_drive_root(path))
      End
    End

    Describe #is_absolute()
      It returns 1 for 'C:\Windows\System32'
        Assert True(fern#internal#filepath#is_absolute('C:\Windows\System32'))
      End

      It returns 1 for 'C:\' (a drive root)
        Assert True(fern#internal#filepath#is_absolute('C:\'))
      End

      It returns 1 for '' (a root)
        Assert True(fern#internal#filepath#is_absolute(''))
      End

      It returns 0 for 'Windows\System32'
        Assert False(fern#internal#filepath#is_absolute('Windows\System32'))
      End

      It returns 0 for 'Windows'
        Assert False(fern#internal#filepath#is_absolute('Windows'))
      End
    End

    Describe #join()
      It returns a joined path
        let paths = [
              \ 'C:\Windows\System32',
              \ 'Foo',
              \]
        let want = 'C:\Windows\System32\Foo'
        let got = fern#internal#filepath#join(paths)
        Assert Equals(got, want)
      End
    End
  End
End
./test/fern/internal/node.vimspec	[[[1
489
Describe fern#internal#node
  Before
    let TIMEOUT = 5000
    let Promise = vital#fern#import('Async.Promise')
    let CancellationToken = vital#fern#import('Async.CancellationToken')
    let token = CancellationToken.none
    let provider = fern#scheme#debug#provider#new()
    let l:Comparator = fern#comparator#default#new()
  End

  Describe #debug()
    It returns a debug information of a given node as string
      let node = fern#internal#node#root('debug:///shallow', provider)
      Assert IsString(fern#internal#node#debug(node))
    End
  End

  Describe #index()
    Before
      let root = fern#internal#node#root('debug:///', provider)
      let [children, _] = Promise.wait(
            \ fern#internal#node#children(root, provider, token),
            \ { 'timeout': TIMEOUT },
            \)
      let nodes = [root] + children
    End

    It returns an index of node which has a given key
      Assert Equals(fern#internal#node#index([], nodes), 0)
      Assert Equals(fern#internal#node#index(['shallow'], nodes), 1)
      Assert Equals(fern#internal#node#index(['deep'], nodes), 2)
      Assert Equals(fern#internal#node#index(['heavy'], nodes), 3)
      Assert Equals(fern#internal#node#index(['leaf'], nodes), 4)
    End

    It returns -1 when no node exists for a given key
      Assert Equals(fern#internal#node#index(['missing'], nodes), -1)
    End
  End

  Describe #find()
    Before
      let root = fern#internal#node#root('debug:///', provider)
      let [children, _] = Promise.wait(
            \ fern#internal#node#children(root, provider, token),
            \ { 'timeout': TIMEOUT },
            \)
      let nodes = [root] + children
    End

    It returns an index of node which has a given key
      Assert Equals(fern#internal#node#find([], nodes), nodes[0])
      Assert Equals(fern#internal#node#find(['shallow'], nodes), nodes[1])
      Assert Equals(fern#internal#node#find(['deep'], nodes), nodes[2])
      Assert Equals(fern#internal#node#find(['heavy'], nodes), nodes[3])
      Assert Equals(fern#internal#node#find(['leaf'], nodes), nodes[4])
    End

    It returns v:null when no node exists for a given key
      Assert Equals(fern#internal#node#find(['missing'], nodes), v:null)
    End
  End

  Describe #root()
    It returns a node instance of a given URL and provider
      let node = fern#internal#node#root('debug:///shallow', provider)
      Assert KeyExists(node, 'name')
      Assert KeyExists(node, 'status')
      Assert KeyExists(node, 'label')
      Assert KeyExists(node, 'hidden')
      Assert KeyExists(node, 'bufname')
      Assert KeyExists(node, '__key')
      Assert KeyExists(node, '__owner')
      Assert KeyExists(node, '__processing')
      Assert KeyExists(node, 'concealed')
      Assert KeyExists(node, 'concealed')
    End
  End

  Describe #parent()
    Before
      let node = fern#internal#node#root('debug:///shallow/alpha', provider)
    End

    It returns a promise
      let p = fern#internal#node#parent(node, provider, token)
      Assert True(Promise.is_promise(p))
    End

    It resolves to a parent node of a given node
      let [r, e] = Promise.wait(
            \ fern#internal#node#parent(node, provider, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r._uri, '/shallow')

      let [r, e] = Promise.wait(
            \ fern#internal#node#parent(r, provider, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(r._uri, '/')
    End
  End

  Describe #children()
    Before
      let node = fern#internal#node#root('debug:///shallow', provider)
    End

    It returns a promise
      let p = fern#internal#node#children(node, provider, token)
      Assert True(Promise.is_promise(p))
    End

    It resolves to a list of child nodes of a given node
      let [r, e] = Promise.wait(
            \ fern#internal#node#children(node, provider, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 3)
      Assert Equals(r[0]._uri, '/shallow/alpha')
      Assert Equals(r[1]._uri, '/shallow/beta')
      Assert Equals(r[2]._uri, '/shallow/gamma')
    End
  End

  Describe #expand()
    Before
      let root = fern#internal#node#root('debug:///', provider)
    End

    It returns a promise
      let p = fern#internal#node#expand(root, [root], provider, Comparator, token)
      Assert True(Promise.is_promise(p))
    End

    It resolves to a list of nodes
      let [r, e] = Promise.wait(
            \ fern#internal#node#expand(root, [root], provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 5)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/heavy')
      Assert Equals(r[3]._uri, '/shallow')
      Assert Equals(r[4]._uri, '/leaf')

      let node = r[3]
      let [r, e] = Promise.wait(
            \ fern#internal#node#expand(node, r, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/heavy')
      Assert Equals(r[3]._uri, '/shallow')
      Assert Equals(r[4]._uri, '/shallow/alpha')
      Assert Equals(r[5]._uri, '/shallow/beta')
      Assert Equals(r[6]._uri, '/shallow/gamma')
      Assert Equals(r[7]._uri, '/leaf')
    End
  End

  Describe #collapse()
    Before
      let root = fern#internal#node#root('debug:///', provider)
      let [nodes, e] = Promise.wait(
            \ fern#internal#node#expand(root, [root], provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      let node = nodes[3]
      let [nodes, e] = Promise.wait(
            \ fern#internal#node#expand(node, nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
    End

    It returns a promise
      let p = fern#internal#node#collapse(node, nodes, provider, Comparator, token)
      Assert True(Promise.is_promise(p))
    End

    It resolves to a list of nodes
      let [r, e] = Promise.wait(
            \ fern#internal#node#collapse(node, nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 5)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/heavy')
      Assert Equals(r[3]._uri, '/shallow')
      Assert Equals(r[4]._uri, '/leaf')
    End
  End

  Describe #reload()
    Before
      let root = fern#internal#node#root('debug:///', provider)
      let [nodes, e] = Promise.wait(
            \ fern#internal#node#expand(root, [root], provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      let node = nodes[3]
      let [nodes, e] = Promise.wait(
            \ fern#internal#node#expand(node, nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
    End

    It returns a promise
      let p = fern#internal#node#reload(node, nodes, provider, Comparator, token)
      Assert True(Promise.is_promise(p))
    End

    It resolves to a list of nodes
      let [r, e] = Promise.wait(
            \ fern#internal#node#reload(node, nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/heavy')
      Assert Equals(r[3]._uri, '/shallow')
      Assert Equals(r[4]._uri, '/shallow/alpha')
      Assert Equals(r[5]._uri, '/shallow/beta')
      Assert Equals(r[6]._uri, '/shallow/gamma')
      Assert Equals(r[7]._uri, '/leaf')
    End

    It keeps status of nodes
      let [r, e] = Promise.wait(
            \ fern#internal#node#reload(node, nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0].status, g:fern#STATUS_EXPANDED)
      Assert Equals(r[1].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[2].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[3].status, g:fern#STATUS_EXPANDED)
      Assert Equals(r[4].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[5].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[6].status, g:fern#STATUS_NONE)
      Assert Equals(r[7].status, g:fern#STATUS_NONE)
    End

    It resolves to a list of nodes (root)
      let [r, e] = Promise.wait(
            \ fern#internal#node#reload(nodes[0], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/heavy')
      Assert Equals(r[3]._uri, '/shallow')
      Assert Equals(r[4]._uri, '/shallow/alpha')
      Assert Equals(r[5]._uri, '/shallow/beta')
      Assert Equals(r[6]._uri, '/shallow/gamma')
      Assert Equals(r[7]._uri, '/leaf')
    End

    It keeps status of nodes (root)
      let [r, e] = Promise.wait(
            \ fern#internal#node#reload(nodes[0], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0].status, g:fern#STATUS_EXPANDED)
      Assert Equals(r[1].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[2].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[3].status, g:fern#STATUS_EXPANDED)
      Assert Equals(r[4].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[5].status, g:fern#STATUS_COLLAPSED)
      Assert Equals(r[6].status, g:fern#STATUS_NONE)
      Assert Equals(r[7].status, g:fern#STATUS_NONE)
    End
  End

  Describe #reveal()
    Before
      let root = fern#internal#node#root('debug:///', provider)
      let [nodes, e] = Promise.wait(
            \ fern#internal#node#expand(root, [root], provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
    End

    It returns a promise
      let p = fern#internal#node#reveal([], nodes, provider, Comparator, token)
      Assert True(Promise.is_promise(p))
    End

    It recursively expand nodes to focus specified nodes (1 step)
      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta', 'gamma'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')
    End

    It recursively expand nodes to focus specified nodes (step by step)
      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 6)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/heavy')
      Assert Equals(r[4]._uri, '/shallow')
      Assert Equals(r[5]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 7)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/heavy')
      Assert Equals(r[5]._uri, '/shallow')
      Assert Equals(r[6]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta', 'gamma'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta', 'gamma', 'UNKNOWN'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')
    End

    It recursively expand nodes to focus specified nodes (1 step to UNKNOWN)
      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta', 'gamma', 'UNKNOWN'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')
    End

    It recursively expand nodes to focus specified nodes (step by step to UNKNOWN)
      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 6)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/heavy')
      Assert Equals(r[4]._uri, '/shallow')
      Assert Equals(r[5]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 7)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/heavy')
      Assert Equals(r[5]._uri, '/shallow')
      Assert Equals(r[6]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta', 'gamma'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')

      let [r, e] = Promise.wait(
            \ fern#internal#node#reveal(['deep', 'alpha', 'beta', 'gamma', 'UNKNOWN'], nodes, provider, Comparator, token),
            \ { 'timeout': TIMEOUT },
            \)
      Assert Equals(e, v:null)
      Assert Equals(len(r), 8)
      Assert Equals(r[0]._uri, '/')
      Assert Equals(r[1]._uri, '/deep')
      Assert Equals(r[2]._uri, '/deep/alpha')
      Assert Equals(r[3]._uri, '/deep/alpha/beta')
      Assert Equals(r[4]._uri, '/deep/alpha/beta/gamma')
      Assert Equals(r[5]._uri, '/heavy')
      Assert Equals(r[6]._uri, '/shallow')
      Assert Equals(r[7]._uri, '/leaf')
    End
  End
End
./test/fern/internal/path.vimspec	[[[1
246
Describe fern#internal#path
  Describe #simplify()
    It returns an absolute path (/usr/local -> /usr/local)
      let path = '/usr/local'
      let want = '/usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)
    End

    It returns a relative path (usr/local -> usr/local)
      let path = 'usr/local'
      let want = 'usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)
    End

    It removes duplicate slashes (/usr//local -> /usr/local)
      let path = '/usr//local'
      let want = '/usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)

      let path = '/usr///local'
      let want = '/usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)
    End

    It removes trailing slashes (/usr/local/ -> /usr/local)
      let path = '/usr/local/'
      let want = '/usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)

      let path = '/usr/local//'
      let want = '/usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)
    End

    It removes '.' (/usr/./local -> /usr/local)
      let path = '/usr/./local'
      let want = '/usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)

      let path = '/usr/././local'
      let want = '/usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)

      let path = './usr/local'
      let want = 'usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)
    End

    It removes '..' and corresponding components (/usr/../local -> /local)
      let path = '/usr/../local'
      let want = '/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)

      let path = '../usr/local'
      let want = '../usr/local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)

      let path = '/usr/../../local'
      let want = '../local'
      let got = fern#internal#path#simplify(path)
      Assert Equals(got, want)
    End
  End

  Describe #commonpath()
    It throws an error when {paths} contains non absolute paths
      let paths = [
            \ 'usr/local',
            \]
      Throws /must be an absolute path/ fern#internal#path#commonpath(paths)
    End

    It returns a common path of among given {paths}
      let paths = [
            \ '/usr/local/bin/vim',
            \ '/usr/local/openssh',
            \ '/usr/bin/vim',
            \]
      let want = '/usr'
      let got = fern#internal#path#commonpath(paths)
      Assert Equals(got, want)
    End

    It returns '/' if no common path exists
      let paths = [
            \ '/usr/local/bin/vim',
            \ '/usr/local/openssh',
            \ '/vim',
            \]
      let want = '/'
      let got = fern#internal#path#commonpath(paths)
      Assert Equals(got, want)
    End
  End

  Describe #absolute()
    It throws an error when {base} is not absolute path
      let base = 'home/fern'
      let path = '/usr/local'
      Throws /must be an absolute path/ fern#internal#path#absolute(path, base)
    End

    It returns an absolute path (/usr/local,/home/fern -> /usr/local)
      let base = '/home/fern'
      let path = '/usr/local'
      let want = '/usr/local'
      let got = fern#internal#path#absolute(path, base)
      Assert Equals(got, want)
    End

    It returns an absolute path from the base (usr/local,/home/fern -> /home/fern/usr/local)
      let base = '/home/fern'
      let path = 'usr/local'
      let want = '/home/fern/usr/local'
      let got = fern#internal#path#absolute(path, base)
      Assert Equals(got, want)
    End

    It returns a simplified absolute path from the base (../../usr/local,/home/fern -> /usr/local)
      let base = '/home/fern'
      let path = '../../usr/local'
      let want = '/usr/local'
      let got = fern#internal#path#absolute(path, base)
      Assert Equals(got, want)
    End

    It throws an error when the path beyonds the base
      let base = '/home/fern'
      let path = '../../../usr/local'
      Throws /beyonds/ fern#internal#path#absolute(path, base)
    End
  End

  Describe #relative()
    It throws an error when {base} is not absolute path
      let base = 'home/fern'
      let path = '/usr/local'
      Throws /must be an absolute path/ fern#internal#path#relative(path, base)
    End

    It returns a relative path (usr/local,/home/fern -> usr/local)
      let base = '/home/fern'
      let path = 'usr/local'
      let want = 'usr/local'
      let got = fern#internal#path#relative(path, base)
      Assert Equals(got, want)
    End

    It returns a relative path from the base (/home/fern/usr/local,/home/fern -> /usr/local)
      let base = '/home/fern'
      let path = '/home/fern/usr/local'
      let want = 'usr/local'
      let got = fern#internal#path#relative(path, base)
      Assert Equals(got, want)
    End

    It returns a simplified relative path from the base (/usr/local,/home/fern -> ../../usr/local)
      let base = '/home/fern'
      let path = '/usr/local'
      let want = '../../usr/local'
      let got = fern#internal#path#relative(path, base)
      Assert Equals(got, want)
    End
  End

  Describe #basename()
    It returns '' if path is an empty string ('' -> '')
      let path = ''
      let want = ''
      let got = fern#internal#path#basename(path)
      Assert Equals(got, want)
    End

    It returns '/' if path is a root ('/' -> '/')
      let path = '/'
      let want = '/'
      let got = fern#internal#path#basename(path)
      Assert Equals(got, want)
    End

    It returns a last component of a {path} ('/usr/local' -> 'local')
      let path = '/usr/local'
      let want = 'local'
      let got = fern#internal#path#basename(path)
      Assert Equals(got, want)
    End

    It removes trailing slashes prior to get a last component of a {path} ('/usr/local/' -> 'local')
      let path = '/usr/local/'
      let want = 'local'
      let got = fern#internal#path#basename(path)
      Assert Equals(got, want)

      let path = '/usr/local//'
      let want = 'local'
      let got = fern#internal#path#basename(path)
      Assert Equals(got, want)
    End
  End

  Describe #dirname()
    It returns '' if path is an empty string ('' -> '')
      let path = ''
      let want = ''
      let got = fern#internal#path#dirname(path)
      Assert Equals(got, want)
    End

    It returns '/' if path is a root ('/' -> '/')
      let path = '/'
      let want = '/'
      let got = fern#internal#path#dirname(path)
      Assert Equals(got, want)
    End

    It removes a last component of a {path} ('/usr/local' -> '/usr')
      let path = '/usr/local'
      let want = '/usr'
      let got = fern#internal#path#dirname(path)
      Assert Equals(got, want)
    End

    It removes trailing slashes prior to remove a last component of a {path} ('/usr/local/' -> '/usr')
      let path = '/usr/local/'
      let want = '/usr'
      let got = fern#internal#path#dirname(path)
      Assert Equals(got, want)

      let path = '/usr/local//'
      let want = '/usr'
      let got = fern#internal#path#dirname(path)
      Assert Equals(got, want)
    End
  End
End
./test/fern/internal/rename_solver.vimspec	[[[1
130
Describe fern#internal#rename_solver
  Before all
    let l:Exist = { -> 0 }
    let l:Tempname = { p -> '@temp/' . p }
    let l:IsDirectory = { -> 1 }
  End

  Describe #solve()
    It solves "Simple renames"
      let in = [
            \ ['foo', 'a'],
            \ ['bar', 'b'],
            \]
      let out = fern#internal#rename_solver#solve(in, {
            \ 'exist': { p -> index(['foo', 'bar'], p) isnot# -1 },
            \ 'tempname': Tempname,
            \ 'isdirectory': IsDirectory,
            \})
      Assert Equals(out, [
            \ ['foo', 'a'],
            \ ['bar', 'b'],
            \])
    End

    It solves "Nested renames"
      let in = [
            \ ['foo', 'bar'],
            \ ['foo/a', 'bar/a'],
            \ ['foo/b', 'bar/c'],
            \]
      let out = fern#internal#rename_solver#solve(in, {
            \ 'exist': { p -> index(['foo', 'foo/a', 'foo/b'], p) isnot# -1 },
            \ 'tempname': Tempname,
            \ 'isdirectory': IsDirectory,
            \})
      Assert Equals(out, [
            \ ['foo', 'bar'],
            \ ['bar/b', 'bar/c'],
            \])
    End

    It solves "Cross renames"
      let in = [
            \ ['foo', 'a/foo'],
            \ ['foo/a', 'a'],
            \]
      let out = fern#internal#rename_solver#solve(in, {
            \ 'exist': { p -> index(['foo', 'foo/a'], p) isnot# -1 },
            \ 'tempname': Tempname,
            \ 'isdirectory': IsDirectory,
            \})
      Assert Equals(out, [
            \ ['foo/a', 'a'],
            \ ['foo', 'a/foo'],
            \])
    End

    It solves "Cyclic renames"
      let in = [
            \ ['foo', 'bar'],
            \ ['bar', 'foo'],
            \]
      let out = fern#internal#rename_solver#solve(in, {
            \ 'exist': { p -> index(['foo', 'bar'], p) isnot# -1 },
            \ 'tempname': Tempname,
            \ 'isdirectory': IsDirectory,
            \})
      Assert Equals(out, [
            \ ['foo', '@temp/bar'],
            \ ['bar', 'foo'],
            \ ['@temp/bar', 'bar'],
            \])
    End

    It solves "Nested cyclic renames"
      let in = [
            \ ['a', 'b'],
            \ ['a/b', 'b/c'],
            \ ['a/c', 'b/b'],
            \]
      let out = fern#internal#rename_solver#solve(in, {
            \ 'exist': { p -> index(['a', 'a/b', 'a/c'], p) isnot# -1 },
            \ 'tempname': Tempname,
            \ 'isdirectory': IsDirectory,
            \})
      Assert Equals(out, [
            \ ['a', 'b'],
            \ ['b/b', '@temp/b/c'],
            \ ['b/c', 'b/b'],
            \ ['@temp/b/c', 'b/c'],
            \])
    End

    It throws an error when destinations are not unique
      let in = [
            \ ['foo', 'baz'],
            \ ['bar', 'baz'],
            \]
      Throws /more than once/ fern#internal#rename_solver#solve(in, {
            \ 'exist': Exist,
            \ 'tempname': Tempname,
            \ 'isdirectory': IsDirectory,
            \})
    End

    It throws an error on "Confclits with existing file"
      let in = [
            \ ['foo', 'bar'],
            \ ['foo/a', 'bar/b'],
            \]
      Throws /already exist/ fern#internal#rename_solver#solve(in, {
            \ 'exist': { p -> index(['foo', 'foo/a', 'foo/b'], p) isnot# -1 },
            \ 'tempname': Tempname,
            \ 'isdirectory': IsDirectory,
            \})
    End

    It throws an error on "Rename into files"
      let in = [
            \ ['foo', 'a/foo'],
            \ ['foo/a', 'a'],
            \]
      Throws /is not directory/ fern#internal#rename_solver#solve(in, {
            \ 'exist': { p -> index(['foo', 'foo/a'], p) isnot# -1 },
            \ 'tempname': Tempname,
            \ 'isdirectory': { p -> index(['foo'], p) isnot# -1 },
            \})
    End
  End
End
./test/fern/internal/window.vimspec	[[[1
22
Describe fern#internal#window
  After all
    %bwipeout!
  End

  Before
    %bwipeout!
  End

  Describe #find()
    It returns a first winnr where the given predicator returns True
      new foo1
      new foo2
      new foo3
      new foo4
      new foo5
      let l:Predicator = { n -> bufname(winbufnr(n)) ==# 'foo3' }
      let winnr = fern#internal#window#find(Predicator)
      Assert Equals(bufname(winbufnr(winnr)), 'foo3')
    End
  End
End
./test/fern/renderer/default.vimspec	[[[1
82
Describe fern#renderer#default
  Before
    let TIMEOUT = 5000
    let STATUS_EXPANDED = g:fern#STATUS_EXPANDED
    let Promise = vital#fern#import('Async.Promise')
    let provider = fern#scheme#debug#provider#new()
  End

  Describe renderer instance
    Before
      let renderer = fern#renderer#default#new()
    End

    Describe #render()
      Before
        let nodes = [
              \ fern#internal#node#root('debug:///', provider),
              \ fern#internal#node#root('debug:///shallow', provider),
              \ fern#internal#node#root('debug:///shallow/alpha', provider),
              \ fern#internal#node#root('debug:///shallow/beta', provider),
              \ fern#internal#node#root('debug:///shallow/gamma', provider),
              \]
        let nodes[1].__key = ['shallow']
        let nodes[1].status = STATUS_EXPANDED
        let nodes[2].__key = ['shallow', 'alpha']
        let nodes[3].__key = ['shallow', 'beta']
        let nodes[4].__key = ['shallow', 'gamma']
      End

      It returns a promise
        let p = renderer.render(nodes)
        Assert True(Promise.is_promise(p))
      End

      It resolves to a string list for a buffer content
        let [r, e] = Promise.wait(
              \ renderer.render(nodes),
              \ { 'timeout': TIMEOUT },
              \)
        Assert Equals(e, v:null)
        Assert Equals(r, [
              \ 'root',
              \ '|- shallow/',
              \ ' |+ alpha/',
              \ ' |+ beta/',
              \ ' |  gamma',
              \])
      End

      It prepend marked symbol for marked nodes
        let marks = [
              \ ['shallow', 'alpha'],
              \ ['shallow', 'gamma'],
              \]
        let [r, e] = Promise.wait(
              \ renderer.render(nodes),
              \ { 'timeout': TIMEOUT },
              \)
        Assert Equals(e, v:null)
        Assert Equals(r, [
              \ 'root',
              \ '|- shallow/',
              \ ' |+ alpha/',
              \ ' |+ beta/',
              \ ' |  gamma',
              \])
      End
    End

    Describe #syntax()
      It does not raise exception
        call renderer.syntax()
      End
    End

    Describe #highlight()
      It does not raise exception
        call renderer.highlight()
      End
    End
  End
End
./test/fern/scheme/debug/provider.vimspec	[[[1
114
Describe fern#scheme#debug#provider
  Before
    let Promise = vital#fern#import('Async.Promise')
    let TIMEOUT = 5000
  End

  Describe #new()
    It returns a provider instance
      let provider = fern#scheme#debug#provider#new()
      Assert KeyExists(provider, 'get_root')
      Assert KeyExists(provider, 'get_parent')
      Assert KeyExists(provider, 'get_children')
    End
  End

  Describe a provider instance
    Before
      let provider = fern#scheme#debug#provider#new()
    End

    Describe .get_root()
      It returns a node instance
        let n = provider.get_root('debug:///')
        Assert KeyExists(n, 'name')
        Assert KeyExists(n, 'status')
      End

      It returns a node of given URL (debug:///...)
        let n = provider.get_root('debug:///')
        Assert Equals(n._uri, '/')

        let n = provider.get_root('debug:///shallow')
        Assert Equals(n._uri, '/shallow')

        let n = provider.get_root('debug:///shallow/gamma')
        Assert Equals(n._uri, '/shallow/gamma')
      End

      It throws error when no node of given URL exist
        Throws /no such entry/ provider.get_root('debug:///missing')
      End
    End

    Describe .get_parent()
      Before
        let node = provider.get_root('debug:///shallow/alpha')
        let root = provider.get_root('debug:///')
      End

      It returns a promise
        let p = provider.get_parent(node)
        Assert True(Promise.is_promise(p))
      End

      It resolves to a parent node of given node
        let [r, e] = Promise.wait(
              \ provider.get_parent(node),
              \ { 'timeout': TIMEOUT },
              \)
        Assert Equals(e, v:null)
        Assert Equals(r._uri, '/shallow')

        let [r, e] = Promise.wait(
              \ provider.get_parent(r),
              \ { 'timeout': TIMEOUT },
              \)
        Assert Equals(e, v:null)
        Assert Equals(r._uri, '/')
      End

      It resolves to a node itself if the node does not have parent
        let [r, e] = Promise.wait(
              \ provider.get_parent(root),
              \ { 'timeout': TIMEOUT },
              \)
        Assert Equals(e, v:null)
        Assert Equals(r._uri, '/')
      End
    End

    Describe .get_children()
      Before
        let node = provider.get_root('debug:///shallow')
        let leaf = provider.get_root('debug:///shallow/gamma')
      End

      It returns a promise
        let p = provider.get_children(node)
        Assert True(Promise.is_promise(p))
      End

      It resolves to child nodes of given node
        let [r, e] = Promise.wait(
              \ provider.get_children(node),
              \ { 'timeout': TIMEOUT },
              \)
        Assert Equals(e, v:null)
        Assert Equals(len(r), 3)
        Assert Equals(r[0]._uri, '/shallow/alpha')
        Assert Equals(r[1]._uri, '/shallow/beta')
        Assert Equals(r[2]._uri, '/shallow/gamma')
      End

      It rejects when the node is a leaf node (no children)
        let [r, e] = Promise.wait(
              \ provider.get_children(leaf),
              \ { 'timeout': TIMEOUT },
              \)
        Assert Equals(e, "no children exists for /shallow/gamma")
        Assert Equals(r, v:null)
      End
    End
  End
End
./test/util/autoload/test.vim	[[[1
13
function! test#feedkeys(keys) abort
  return s:feedkeys(a:keys)
endfunction

if exists('*nvim_input')
  function! s:feedkeys(keys) abort
    return nvim_input(a:keys)
  endfunction
else
  function! s:feedkeys(keys) abort
    return timer_start(0, { -> feedkeys(a:keys) })
  endfunction
endif
./test/util/test/test.vimspec	[[[1
39
Describe test
  Before all
    function! Input() abort
      try
        call inputsave()
        echo input("Hello")
      finally
        call inputrestore()
      endtry
    endfunction
  End

  After all
    delfunction! Input
  End

  Describe #feedkeys()
    It provides user inputs to input()
      call test#feedkeys("Hello World\<CR>")
      let value = execute("echo input('This is a test prompt')")
      Assert Equals(value, "\nHello World")
    End

    It provides user inputs to inputsave()/input()/inputrestore()
      call test#feedkeys("Hello World\<CR>")
      let value = execute('call Input()')
      Assert Equals(value, "\nHello World")
    End

    It provides user inputs to inputsave()/input()/inputrestore() through mappings
      nnoremap <buffer>
            \ <Plug>(test-input)
            \ :<C-u>call Input()<CR>
      call test#feedkeys("Hello World\<CR>")
      let value = execute("normal \<Plug>(test-input)")
      Assert Equals(value, "\nHello World")
    End
  End
End
