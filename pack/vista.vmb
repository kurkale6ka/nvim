" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/FUNDING.yml	[[[1
4
# These are supported funding model platforms

github: [liuchengxu]
custom: https://www.paypal.me/liuchengxu
./.github/ISSUE_TEMPLATE/bug_report.md	[[[1
65
---
name: Bug report
about: Create a report to help us improve
---

<!--
    Hello, thanks for reporting a bug.

    Please understand, that without clear explanations and useful info
    the issue may be closed as unreproducible.

    Thanks.
-->

**Describe the bug**
A clear and concise description of what the bug is.

**Environment:**
- OS: <!-- e.g. macOS, Ubuntu 18.04, Windows 10 -->
- Vim/Neovim version: <!-- first two lines of `:version` command output -->
- This plugin version: <!-- output of `git rev-parse origin/master` command -->
- I'm using universal-ctags: <!-- exuberant-ctags is unsupported -->
    - Ctags version: <!-- output of `ctags --version` command -->
- I'm using some LSP client:
    - Related Vim LSP client: <!-- ale,coc,lcn,nvim_lsp,vim_lsc,vim_lsp -->
    - The Vim LSP client version:
    - Have you tried updated to the latest version of this LSP client: Yes/No

**Vista info**

<!-- Paste the output of :Vista info here, or try :Vista info+. -->

```
```

**Steps to reproduce given the above info**
<!-- If this issue is related to ctags, please also provide the source file you run Vista on. -->

source file for reproduce the ctags issue:

<!-- If this issue is related to some LSP plugin, please also provide the minimal vimrc to help reproduce -->

minimal vimrc (neccessary when this issue is about some Vim LSP client):

```vim
set nocompatible
set runtimepath^=/path/to/vista.vim
syntax on
filetype plugin indent on
```

<!-- short descriptions of actions, which lead towards the issue -->
1.
2.
3.
4.

**Expected behavior**
A clear and concise description of what you expected to happen.

**Actual behavior**
A clear and concise description of what actually happens.

**Screenshot or gif** (if possible)
If applicable, add screenshots to help explain your problem.
./.github/ISSUE_TEMPLATE/feature_request.md	[[[1
16
---
name: Feature request
about: Suggest an idea for this project
---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
./.github/workflows/ci.yml	[[[1
19
name: ci

on: [push, pull_request]

jobs:
  vint:
    strategy:
      fail-fast: false

    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@master
    - name: Run vint with reviewdog
      uses: reviewdog/action-vint@v1
      with:
        github_token: ${{ secrets.github_token }}
        reporter: github-pr-review
./CHANGELOG.md	[[[1
4
# CHANGELOG

- Impl logging feature and fix some auto update disorders. #319
- Change `t:vista` to `g:vista` as `t:vista` causes too many issues and I don't have time to make it work as initially designed. #269
./Dockerfile	[[[1
8
FROM tweekmonster/vim-testbed:latest

ENV PACKAGES="bash git python py-pip"

RUN apk --update add $PACKAGES && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN pip install vim-vint==0.3.15
./LICENSE	[[[1
21
MIT License

Copyright (c) 2019 Liu-Cheng Xu

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
274
# Vista.vim

[![CI](https://github.com/liuchengxu/vista.vim/workflows/ci/badge.svg)](https://github.com/liuchengxu/vista.vim/actions?workflow=ci)

View and search LSP symbols, tags in Vim/NeoVim.

<p align="center">
    <img width="600px" src="https://user-images.githubusercontent.com/8850248/56469894-14d40780-6472-11e9-802f-729ac53bd4d5.gif">
    <p align="center">Vista ctags</p>
</p>

[>>>> More screenshots](https://github.com/liuchengxu/vista.vim/issues/257)

**caveat: There is a major flaw about the tree view renderer of ctags at the moment, see [#320](https://github.com/liuchengxu/vista.vim/issues/320) for more details.**

## Table Of Contents

<!-- TOC GFM -->

* [Introduction](#introduction)
* [Features](#features)
* [Requirement](#requirement)
* [Installation](#installation)
    * [Plugin Manager](#plugin-manager)
    * [Package management](#package-management)
        * [Vim 8](#vim-8)
        * [NeoVim](#neovim)
* [Usage](#usage)
    * [Show the nearest method/function in the statusline](#show-the-nearest-methodfunction-in-the-statusline)
        * [lightline.vim](#lightlinevim)
    * [Commands](#commands)
    * [Options](#options)
    * [Other tips](#other-tips)
        * [Compile ctags with JSON format support](#compile-ctags-with-json-format-support)
* [Contributing](#contributing)
* [License](#license)

<!-- /TOC -->

## Introduction

I initially started [vista.vim](https://github.com/liuchengxu/vista.vim) with an intention of replacing [tagbar](https://github.com/majutsushi/tagbar) as it seemingly doesn't have a plan to support the promising [Language Server Protocol](https://github.com/Microsoft/language-server-protocol) and async processing.

In addition to being a tags viewer, vista.vim can also be a symbol navigator similar to [ctrlp-funky](https://github.com/tacahiroy/ctrlp-funky). Last but not least, one important goal of [vista.vim](https://github.com/liuchengxu/vista.vim) is to support LSP symbols, which understands the semantics instead of the regex only.

## Features

- [x] View tags and LSP symbols in a sidebar.
  - [x] [universal-ctags](https://github.com/universal-ctags/ctags)
  - [x] [ale](https://github.com/w0rp/ale)
  - [x] [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
  - [x] [coc.nvim](https://github.com/neoclide/coc.nvim)
  - [x] [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)
  - [x] [vim-lsc](https://github.com/natebosch/vim-lsc)
  - [x] [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [x] Finder for tags and LSP symbols.
  - [x] [fzf](https://github.com/junegunn/fzf)
  - [x] [skim](https://github.com/lotabout/skim)
  - [x] [vim-clap](https://github.com/liuchengxu/vim-clap)
- [x] Nested display for ctags, list display for LSP symbols.
- [x] Highlight the nearby tag in the vista sidebar.
- [x] Builtin support for displaying markdown's TOC.
- [x] Update automatically when switching between buffers.
- [x] Jump to the tag/symbol from vista sidebar with a blink.
- [x] Update asynchonously in the background when `+job` avaliable.
- [x] Find the nearest method or function to the cursor, which could be integrated into the statusline.
- [x] Display decent detailed symbol info in cmdline, also supports previewing the tag via neovim's floating window.

Notes:

- Exuberant Ctags is unsupported, ensure you are using [universal-ctags](https://github.com/universal-ctags/ctags).
- The feature of finder in vista.vim `:Vista finder [EXECUTIVE]` is a bit like `:BTags` or `:Tags` in [fzf.vim](https://github.com/junegunn/fzf.vim), `:CocList` in [coc.nvim](https://github.com/neoclide/coc.nvim), `:LeaderfBufTag` in [leaderf.vim](https://github.com/Yggdroot/LeaderF), etc. You can choose whatever you like.
- ~~Due to limitations of the Language Server Protocol, a tree view of nested tags is currently only available for the ctags executive. Other executives will have symbols grouped by modules, classes, functions and variables~~. The tree view support for LSP executives are limited at present, and only `:Vista coc` provider is supported.

## Requirement

I don't know the mimimal supported version. But if you only care about the ctags related feature, vim 7.4.1154+ should be enough. If you want to ctags to run asynchonously, Vim 8.0.27+ should be enough.

Otherwise, if you want to try any LSP related features, then you certainly need some plugins to retrive the LSP symbols, e.g., [coc.nvim](https://github.com/neoclide/coc.nvim). When you have these LSP plugins set up, vista.vim should be ok to go as well.

In addition, if you want to search the symbols via [fzf](https://github.com/junegunn/fzf), you will have to install it first. Note that fzf 0.22.0 or above is required.

## Installation

### Plugin Manager

- [vim-plug](https://github.com/junegunn/vim-plug)

  ```vim
  Plug 'liuchengxu/vista.vim'
  ```

For other plugin managers please follow their instructions accordingly.

### Package management

#### Vim 8

```bash
$ mkdir -p ~/.vim/pack/git-plugins/start
$ git clone https://github.com/liuchengxu/vista.vim.git --depth=1 ~/.vim/pack/git-plugins/start/vista.vim
```

#### NeoVim

```bash
$ mkdir -p ~/.local/share/nvim/site/pack/git-plugins/start
$ git clone https://github.com/liuchengxu/vista.vim.git --depth=1 ~/.local/share/nvim/site/pack/git-plugins/start/vista.vim
```

## Usage

### Show the nearest method/function in the statusline

Note: This is only supported for ctags and coc executive for now.

You can do the following to show the nearest method/function in your statusline:

```vim
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
```

Also refer to [liuchengxu/eleline#18](https://github.com/liuchengxu/eleline.vim/pull/18).

<p align="center">
    <img width="800px" src="https://user-images.githubusercontent.com/8850248/55477900-da363680-564c-11e9-8e71-845260f3d44b.png">
</p>

#### [lightline.vim](https://github.com/itchyny/lightline.vim)

```vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method' ] ]
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }
```

### Commands

| Command   | Description                                             |
| :-------- | :------------------------------------------------------ |
| `Vista`   | Open/Close vista window for viewing tags or LSP symbols |
| `Vista!`  | Close vista view window if already opened               |
| `Vista!!` | Toggle vista view window                                |

`:Vista [EXECUTIVE]`: open vista window powered by EXECUTIVE.

`:Vista finder [EXECUTIVE]`: search tags/symbols generated from EXECUTIVE.

See `:help vista-commands` for more information.

### Options

```vim
" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works for the kind renderer, not the tree renderer.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'ctags'

" Set the executive for some filetypes explicitly. Use the explicit executive
" instead of the default one for these filetypes when using `:Vista` without
" specifying the executive.
let g:vista_executive_for = {
  \ 'cpp': 'vim_lsp',
  \ 'php': 'vim_lsp',
  \ }

" Declare the command including the executable and options used to generate ctags output
" for some certain filetypes.The file path will be appened to your custom command.
" For example:
let g:vista_ctags_cmd = {
      \ 'haskell': 'hasktags -x -o - -c',
      \ }

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['right:50%']
```

```vim
" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
```

<p align="center">
    <img width="300px" src="https://user-images.githubusercontent.com/8850248/55805524-2b449f80-5b11-11e9-85d4-018c305a5ecb.png">
</p>

See `:help vista-options` for more information.

### Other tips

#### Compile ctags with JSON format support

First of all, check if your [universal-ctags](https://github.com/universal-ctags/ctags) supports JSON format via `ctags --list-features`. If not, I recommend you to install ctags with JSON format support that would make vista's parser easier and more reliable. And we are able to reduce some overhead in JSON mode by [disabling the fixed fields](https://github.com/universal-ctags/ctags/pull/2080).

The JSON support for ctags is avaliable if u-ctags is linked to libjansson when compiling.

- macOS, [included by default since February 23 2021](https://github.com/universal-ctags/homebrew-universal-ctags/commit/82db2cf9cb0cdecf62ca9405e767ec025b5ba8ed)

  ```bash
  $ brew tap universal-ctags/universal-ctags
  $ brew install --HEAD universal-ctags/universal-ctags/universal-ctags
  ```

- Ubuntu

  ```bash
  # install libjansson first
  $ sudo apt-get install libjansson-dev

  # then compile and install universal-ctags.
  #
  # NOTE: Don't use `sudo apt install ctags`, which will install exuberant-ctags and it's not guaranteed to work with vista.vim.
  #
  $ git clone https://github.com/universal-ctags/ctags.git --depth=1
  $ cd ctags
  $ ./autogen.sh
  $ ./configure
  $ make
  $ sudo make install
  ```

- Fedora

  ```bash
  $ sudo dnf install jansson-devel autoconf automake
  $ git clone https://github.com/universal-ctags/ctags.git --depth=1
  $ cd ctags
  $ ./autogen.sh
  $ ./configure
  $ make
  $ sudo make install
  ```

Refer to [Compiling and Installing Jansson](https://jansson.readthedocs.io/en/latest/gettingstarted.html#compiling-and-installing-jansson) as well.

## Contributing

Vista.vim is still in beta, please [file an issue](https://github.com/liuchengxu/vista.vim/issues/new) if you run into any trouble or have any sugguestions.

## License

MIT

Copyright (c) 2019 Liu-Cheng Xu
./_config.yml	[[[1
1
theme: jekyll-theme-midnight
./autoload/vista/autocmd.vim	[[[1
156
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:registered = []
let s:update_timer = -1
let s:did_open = []
let s:last_event = []
let s:did_buf_enter = []

function! s:ClearOtherEvents(group) abort
  for augroup in s:registered
    if augroup != a:group && exists('#'.augroup)
      execute 'autocmd!' augroup
    endif
  endfor
endfunction

function! s:OnBufEnter(bufnr, fpath) abort
  if index(s:did_buf_enter, a:bufnr) == -1
    call add(s:did_buf_enter, a:bufnr)
    " Only ignore the first BufEnter event for a new buffer
    "
    " When reading a new buffer, BufReadPost and BufEnter will both be
    " triggered for the same buffer, therefore BufEnter is needless and might
    " be problematic.
    if s:last_event == ['BufReadPost', a:bufnr]
      call vista#Debug('ignored the first event.BufEnter for bufnr '.a:bufnr.' because event.BufReadPost was just triggered for the same buffer')
      return
    endif
  endif

  call vista#Debug('event.BufEnter', a:bufnr, a:fpath)
  call s:GenericAutoUpdate('BufEnter', a:bufnr, a:fpath)
endfunction

function! s:OnBufDelete(bufnr) abort
  let idx = index(s:did_open, a:bufnr)
  if idx != -1
    unlet s:did_open[idx]
  endif
  let idx = index(s:did_buf_enter, a:bufnr)
  if idx != -1
    unlet s:did_buf_enter[idx]
  endif
endfunction

function! s:GenericAutoUpdate(event, bufnr, fpath) abort
  if vista#ShouldSkip()
    return
  endif

  call vista#Debug('event.'.a:event. ' processing auto update for buffer '. a:bufnr)
  let [bufnr, winnr, fname] = [a:bufnr, winnr(), expand('%')]

  call vista#source#Update(bufnr, winnr, fname, a:fpath)

  call s:ApplyAutoUpdate(a:fpath)
endfunction

function! s:TriggerUpdate(event, bufnr, fpath) abort
  if s:last_event == [a:event, a:bufnr]
    call vista#Debug('same event for bufnr '.a:bufnr.' was just triggered, ignored for this one')
    return
  endif

  let s:last_event = [a:event, a:bufnr]

  call vista#Debug('new last_event:', s:last_event)

  if index(s:did_open, a:bufnr) == -1
    call vista#Debug('tracking new buffer '.a:bufnr)
    call add(s:did_open, a:bufnr)
  endif

  call s:GenericAutoUpdate(a:event, a:bufnr, a:fpath)
endfunction

function! s:AutoUpdateWithDelay(bufnr, fpath) abort
  if !exists('g:vista')
    return
  endif

  if s:update_timer != -1
    call timer_stop(s:update_timer)
    let s:update_timer = -1
  endif

  let g:vista.on_text_changed = 1
  let s:update_timer = timer_start(
        \ g:vista_update_on_text_changed_delay,
        \ { -> s:GenericAutoUpdate('TextChanged|TextChangedI', a:bufnr, a:fpath)}
        \ )
endfunction

function! s:ClearTempData() abort
  for tmp in g:vista.tmps
    if filereadable(tmp)
      call delete(tmp)
    endif
  endfor
endfunction

" Every time we call :Vista foo, we should clear other autocmd events and only
" keep the current one, otherwise there will be multiple autoupdate events
" interacting with other.
function! vista#autocmd#Init(group_name, AUF) abort

  call s:ClearOtherEvents(a:group_name)

  if index(s:registered, a:group_name) == -1
    call add(s:registered, a:group_name)
  endif

  let s:ApplyAutoUpdate = a:AUF

  if exists('#'.a:group_name)
    if len(split(execute('autocmd '.a:group_name), '\n')) > 1
      return
    endif
  endif

  execute 'augroup' a:group_name
    autocmd!

    " vint: -ProhibitAutocmdWithNoGroup
    autocmd WinEnter,WinLeave __vista__ call vista#statusline#RenderOnWinEvent()

    " BufReadPost is needed for reloading the current buffer if the file
    " was changed by an external command;
    "
    " CursorHold and CursorHoldI event have been removed in order to
    " highlight the nearest tag automatically.

    autocmd BufReadPost  * call s:TriggerUpdate('BufReadPost', +expand('<abuf>'), fnamemodify(expand('<afile>'), ':p'))
    autocmd BufWritePost * call s:TriggerUpdate('BufWritePost', +expand('<abuf>'), fnamemodify(expand('<afile>'), ':p'))
    autocmd BufEnter     * call s:OnBufEnter(+expand('<abuf>'), fnamemodify(expand('<afile>'), ':p'))

    autocmd BufDelete,BufWipeout * call s:OnBufDelete(+expand('<abuf>'))

    autocmd VimLeavePre * call s:ClearTempData()

    if g:vista_update_on_text_changed
      autocmd TextChanged,TextChangedI *
            \ call s:AutoUpdateWithDelay(+expand('<abuf>'), fnamemodify(expand('<afile>'), ':p'))
    endif
  augroup END
endfunction


function! vista#autocmd#InitMOF() abort
  augroup VistaMOF
    autocmd!
    autocmd CursorMoved * call vista#cursor#FindNearestMethodOrFunction()
  augroup END
endfunction
./autoload/vista/cursor/ctags.vim	[[[1
69
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" Try matching the exact tag given the trimmed line in the vista window.
function! s:MatchTag(trimmed_line) abort
  " Since we include the space ` `, we need to trim the result later.
  " / --> github.com/golang/dep/gps:11
  if g:vista.provider ==# 'markdown'
    let matched = matchlist(a:trimmed_line, '\([a-zA-Z:#_.,/<> ]\-\+\)\(H\d:\d\+\)$')
  else
    let matched = matchlist(a:trimmed_line, '\([a-zA-Z:#_.,/<> ]\-\+\):\(\d\+\)$')
  endif

  return get(matched, 1, '')
endfunction

function! s:RemoveVisibility(tag) abort
  if index(['+', '~', '-'], a:tag[0]) > -1
    return a:tag[1:]
  else
    return a:tag
  endif
endfunction

function! vista#cursor#ctags#GetInfo() abort
  let raw_cur_line = getline('.')

  if empty(raw_cur_line)
    return [v:null, v:null]
  endif

  " tag like s:StopCursorTimer has `:`, so we can't simply use split(tag, ':')
  let last_semicoln_idx = strridx(raw_cur_line, ':')
  let lnum = raw_cur_line[last_semicoln_idx+1:]

  let source_line = g:vista.source.line_trimmed(lnum)
  if empty(source_line)
    return [v:null, v:null]
  endif

  " For scoped tag
  " Currently vlnum_cache is ctags provider only.
  if has_key(g:vista, 'vlnum_cache') && g:vista.provider ==# 'ctags'
    let tagline = g:vista.get_tagline_under_cursor()
    if !empty(tagline)
      return [tagline.name, source_line]
    endif
  endif

  " For scopeless tag
  " peer_ilog(PEER,FORMAT,...):90
  let trimmed_line = vista#util#Trim(raw_cur_line)
  let left_parenthsis_idx = stridx(trimmed_line, '(')
  if left_parenthsis_idx > -1
    " Ignore the visibility symbol, e.g., +test2()
    let tag = s:RemoveVisibility(trimmed_line[0 : left_parenthsis_idx-1])
    return [tag, source_line]
  endif

  let tag = s:MatchTag(trimmed_line)
  if empty(tag)
    let tag = raw_cur_line[:last_semicoln_idx-1]
  endif

  let tag = s:RemoveVisibility(vista#util#Trim(tag))

  return [tag, source_line]
endfunction
./autoload/vista/cursor/lsp.vim	[[[1
61
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:GetInfoFromLSPAndExtension() abort
  let raw_cur_line = getline('.')

  " TODO use range info of LSP symbols?
  if g:vista.provider ==# 'coc'
    if !has_key(g:vista, 'vlnum2tagname')
      return v:null
    endif
    if has_key(g:vista.vlnum2tagname, line('.'))
      return g:vista.vlnum2tagname[line('.')]
    else
      let items = split(raw_cur_line)
      if g:vista#renderer#enable_icon
        return join(items[1:-2], ' ')
      else
        return join(items[:-2], ' ')
      endif
    endif
  elseif g:vista.provider ==# 'nvim_lsp'
    return substitute(raw_cur_line, '\v.*\s(.*):.*', '\1', '')
  elseif g:vista.provider ==# 'markdown' || g:vista.provider ==# 'rst'
    if line('.') < 3
      return v:null
    endif
    " The first two lines are for displaying fpath. the lnum is 1-based, while
    " idex is 0-based.
    " So it's line('.') - 3 instead of line('.').
    let tag = vista#extension#{g:vista.provider}#GetHeader(line('.')-3)
    if tag is# v:null
      return v:null
    endif
    return tag
  endif

  return v:null
endfunction

function! vista#cursor#lsp#GetInfo() abort
  let raw_cur_line = getline('.')

  if empty(raw_cur_line)
    return [v:null, v:null]
  endif

  " tag like s:StopCursorTimer has `:`, so we can't simply use split(tag, ':')
  let last_semicoln_idx = strridx(raw_cur_line, ':')
  let lnum = raw_cur_line[last_semicoln_idx+1:]

  let source_line = g:vista.source.line_trimmed(lnum)
  if empty(source_line)
    return [v:null, v:null]
  endif

  let tag = s:GetInfoFromLSPAndExtension()

  return [tag, source_line]
endfunction
./autoload/vista/cursor.vim	[[[1
280
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf8

let s:find_timer = -1
let s:cursor_timer = -1
let s:highlight_timer = -1

let s:echo_cursor_opts = ['echo', 'floating_win', 'scroll', 'both']
let s:echo_strategy = get(g:, 'vista_echo_cursor_strategy', 'echo')

let s:last_vlnum = v:null

function! s:GenericStopTimer(timer) abort
  execute 'if '.a:timer.' != -1 |'.
        \ '  call timer_stop('.a:timer.') |'.
        \ '  let 'a:timer.' = -1 |'.
        \ 'endif'
endfunction

function! s:StopFindTimer() abort
  call s:GenericStopTimer('s:find_timer')
endfunction

function! s:StopCursorTimer() abort
  call s:GenericStopTimer('s:cursor_timer')
endfunction

function! s:StopHighlightTimer() abort
  call s:GenericStopTimer('s:highlight_timer')
endfunction

" Get tag and corresponding source line at current cursor position.
"
" Return: [tag, source_line]
function! s:GetInfoUnderCursor() abort
  if g:vista.provider ==# 'ctags'
    return vista#cursor#ctags#GetInfo()
  else
    return vista#cursor#lsp#GetInfo()
  endif
endfunction

function! s:Compare(s1, s2) abort
  return a:s1.lnum - a:s2.lnum
endfunction

function! s:FindNearestMethodOrFunction(_timer) abort
  if !exists('g:vista')
        \ || !has_key(g:vista, 'functions')
        \ || !has_key(g:vista, 'source')
    return
  endif
  call sort(g:vista.functions, function('s:Compare'))
  let result = vista#util#BinarySearch(g:vista.functions, line('.'), 'lnum', 'text')
  if empty(result)
    let result = ''
  endif
  call setbufvar(g:vista.source.bufnr, 'vista_nearest_method_or_function', result)

  call s:StopHighlightTimer()

  if vista#sidebar#IsOpen()
    let s:highlight_timer = timer_start(200, function('s:HighlightNearestTag'))
  endif
endfunction

function! s:HasVlnum() abort
  return exists('g:vista')
        \ && has_key(g:vista, 'raw')
        \ && !empty(g:vista.raw)
        \ && has_key(g:vista.raw[0], 'vlnum')
endfunction

" Highlight the nearest tag in the vista window.
function! s:HighlightNearestTag(_timer) abort
  if !exists('g:vista')
    return
  endif
  let winnr = g:vista.winnr()

  if winnr == -1
        \ || vista#ShouldSkip()
        \ || !s:HasVlnum()
        \ || mode() !=# 'n'
    return
  endif

  let found = vista#util#BinarySearch(g:vista.raw, line('.'), 'line', '')
  if empty(found)
    return
  endif

  let s:vlnum = get(found, 'vlnum', v:null)
  " Skip if the vlnum is same with previous one
  if empty(s:vlnum) || s:last_vlnum == s:vlnum
    return
  endif

  let s:last_vlnum = s:vlnum

  let tag = get(found, 'name', v:null)
  call vista#win#Execute(winnr, function('vista#highlight#Add'), s:vlnum, v:true, tag)
endfunction

" Fold or unfold when meets the top level tag line
function! s:TryFoldIsOk() abort
  if indent('.') == 0
    if !empty(getline('.'))
      if foldclosed('.') != -1
        normal! zo
        return v:true
      elseif foldlevel('.') != 0
        normal! zc
        return v:true
      endif
    endif
  endif
  return v:false
endfunction

" Fold scope based on the indent.
" Jump to the target source line or source file.
function! vista#cursor#FoldOrJump() abort
  if line('.') == 1
    call vista#source#GotoWin()
    return
  elseif s:TryFoldIsOk()
    return
  endif

  let tag_under_cursor = s:GetInfoUnderCursor()[0]
  call vista#jump#TagLine(tag_under_cursor)
endfunction

" This happens when you are in the window of source file
function! vista#cursor#FindNearestMethodOrFunction() abort
  if !exists('g:vista')
        \ || !has_key(g:vista, 'functions')
        \ || bufnr('') != g:vista.source.bufnr
    return
  endif

  call s:StopFindTimer()

  if empty(g:vista.functions)
    call setbufvar(g:vista.source.bufnr, 'vista_nearest_method_or_function', '')
    return
  endif

  let s:find_timer = timer_start(
        \ g:vista_find_nearest_method_or_function_delay,
        \ function('s:FindNearestMethodOrFunction'),
        \ )
endfunction

function! vista#cursor#NearestSymbol() abort
  return vista#util#BinarySearch(g:vista.raw, line('.'), 'line', 'name')
endfunction

" Show the detail of current tag/symbol under cursor.
function! vista#cursor#ShowDetail(_timer) abort
  " Skip if in visual mode
  if mode() ==? 'v' || mode() ==# "\<C-V>"
    return
  endif

  if empty(getline('.'))
        \ || vista#echo#EchoScopeInCmdlineIsOk()
        \ || vista#win#ShowFoldedDetailInFloatingIsOk()
    return
  endif

  let [tag, source_line] = s:GetInfoUnderCursor()

  if empty(tag) || empty(source_line)
    echo "\r"
    return
  endif

  let msg = vista#util#Truncate(source_line)
  let lnum = s:GetTrailingLnum()

  if s:echo_strategy ==# s:echo_cursor_opts[0]
    call vista#echo#EchoInCmdline(msg, tag)
  elseif s:echo_strategy ==# s:echo_cursor_opts[1]
    call vista#win#FloatingDisplay(lnum, tag)
  elseif s:echo_strategy ==# s:echo_cursor_opts[2]
    call vista#source#PeekSymbol(lnum, tag)
  elseif s:echo_strategy ==# s:echo_cursor_opts[3]
    call vista#echo#EchoInCmdline(msg, tag)
    call vista#win#FloatingDisplayOrPeek(lnum, tag)
  else
    call vista#error#InvalidOption('g:vista_echo_cursor_strategy', s:echo_cursor_opts)
  endif

  call vista#highlight#Add(line('.'), v:false, tag)
endfunction

function! vista#cursor#ShowDetailWithDelay() abort
  call s:StopCursorTimer()

  let s:cursor_timer = timer_start(
        \ g:vista_cursor_delay,
        \ function('vista#cursor#ShowDetail'),
        \ )
endfunction

" This happens on calling `:Vista show` but the vista window is still invisible.
function! vista#cursor#ShowTagFor(lnum) abort
  if !s:HasVlnum()
    return
  endif

  let found = vista#util#BinarySearch(g:vista.raw, a:lnum, 'line', '')
  if empty(found)
    return
  endif
  let s:vlnum = get(found, 'vlnum', v:null)
  if empty(s:vlnum)
    return
  endif

  let tag = get(found, 'name', v:null)
  call vista#highlight#Add(s:vlnum, v:true, tag)
endfunction

function! vista#cursor#ShowTag() abort
  if !s:HasVlnum()
    return
  endif

  let s:vlnum = vista#util#BinarySearch(g:vista.raw, line('.'), 'line', 'vlnum')

  if empty(s:vlnum)
    return
  endif

  let winnr = g:vista.winnr()

  if winnr() != winnr
    execute winnr.'wincmd w'
  endif

  call cursor(s:vlnum, 1)
  normal! zz
endfunction

" Extract the line number from last section of cursor line in the vista window
function! s:GetTrailingLnum() abort
  return str2nr(matchstr(getline('.'), '\d\+$'))
endfunction

function! vista#cursor#TogglePreview() abort
  if get(g:vista, 'floating_visible', v:false)
        \ || get(g:vista, 'popup_visible', v:false)
    call vista#win#CloseFloating()
    return
  endif

  let [tag, source_line] = s:GetInfoUnderCursor()

  if empty(tag) || empty(source_line)
    echo "\r"
    return
  endif

  let lnum = s:GetTrailingLnum()

  call vista#win#FloatingDisplay(lnum, tag)
endfunction

function! vista#cursor#TryInitialRun() abort
  if exists('g:__vista_initial_run_find_nearest_method')
    call vista#cursor#FindNearestMethodOrFunction()
    unlet g:__vista_initial_run_find_nearest_method
  endif
endfunction
./autoload/vista/debugging.vim	[[[1
75
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:GetAvaliableExecutives() abort
  let avaliable = []

  if exists('*ale#lsp_linter#SendRequest')
    call add(avaliable, 'ale')
  endif

  if exists('*CocAction')
    call add(avaliable, 'coc')
  endif

  if executable('ctags')
    call add(avaliable, 'ctags')
  endif

  if exists('*LanguageClient#textDocument_documentSymbol')
    call add(avaliable, 'lcn')
  endif

  if exists('*lsc#server#userCall')
    call add(avaliable, 'vim_lsc')
  endif

  if exists('*lsp#get_whitelisted_servers')
    call add(avaliable, 'vim_lsp')
  endif

  return avaliable
endfunction

function! s:GetGlobalVariables() abort
  let variable_list = []

  for key in keys(g:)
    if key =~# '^vista'
      call add(variable_list, key)
    endif
  endfor

  " Ignore the variables of types
  call filter(variable_list, 'v:val !~# ''vista#types#''')

  call sort(variable_list)

  return variable_list
endfunction

function! vista#debugging#Info() abort
  let avaliable_executives = string(s:GetAvaliableExecutives())
  let global_variables = s:GetGlobalVariables()

  echohl Type   | echo '    Current FileType: ' | echohl NONE
  echohl Normal | echon &filetype               | echohl NONE
  echohl Type   | echo 'Avaliable Executives: ' | echohl NONE
  echohl Normal | echon avaliable_executives    | echohl NONE
  echohl Type   | echo '    Global Variables:'  | echohl NONE
  for variable in global_variables
    echo '    let g:'.variable.' = '. string(g:[variable])
  endfor
endfunction

function! vista#debugging#InfoToClipboard() abort
  redir => l:output
    silent call vista#debugging#Info()
  redir END

  let @+ = l:output
  echohl Type     | echo '[vista.vim] '               | echohl NONE
  echohl Function | echon 'Vista info'                | echohl NONE
  echohl Normal   | echon ' copied to your clipboard' | echohl NONE
endfunction
./autoload/vista/echo.vim	[[[1
98
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf8

function! s:EchoScope(scope) abort
  if g:vista#renderer#enable_icon
    echohl Function | echo ' '.a:scope.': ' | echohl NONE
  else
    echohl Function  | echo '['.a:scope.'] '  | echohl NONE
  endif
endfunction

function! s:TryParseAndEchoScope() abort
  let linenr = vista#util#LowerIndentLineNr()

  " Echo the scope of current tag if found
  if linenr != 0
    let scope = matchstr(getline(linenr), '\a\+$')
    if !empty(scope)
      call s:EchoScope(scope)
    else
      " For the kind renderer
      let pieces = split(getline(linenr), ' ')
      if !empty(pieces)
        let scope = pieces[1]
        call s:EchoScope(scope)
      endif
    endif
  endif
endfunction

function! vista#echo#EchoScopeInCmdlineIsOk() abort
  let cur_line = getline('.')
  if cur_line[-1:] ==# ']'
    let splitted = split(cur_line)
    " Join the scope parts in case of they contains spaces, e.g., structure names
    let scope = join(splitted[1:-2], ' ')
    let cnt = matchstr(splitted[-1], '\d\+')
    call s:EchoScope(scope)
    echohl Keyword | echon cnt | echohl NONE
    return v:true
  endif
  return v:false
endfunction

function! s:EchoScopeFromCacheIsOk() abort
  if has_key(g:vista, 'vlnum_cache')
    " should exclude the first two lines and keep in mind that the 1-based and
    " 0-based.
    " This is really error prone.
    let tagline = get(g:vista.vlnum_cache, line('.') - 3, '')
    if !empty(tagline)
      if has_key(tagline, 'scope')
        call s:EchoScope(tagline.scope)
      else
        call s:EchoScope(tagline.kind)
      endif
      return v:true
    endif
  endif
  return v:false
endfunction

" Echo the tag with detailed info in the cmdline
" Try to echo the scope and then the tag.
function! vista#echo#EchoInCmdline(msg, tag) abort
  let [msg, tag] = [a:msg, a:tag]

  " Case II:\@ $R^2 \geq Q^3$ :  paragraph:175
  try
    let start = stridx(msg, tag)

    " If couldn't find the tag in the msg
    if start == -1
      echohl Function | echo msg | echohl NONE
      return
    endif
  catch /^Vim\%((\a\+)\)\=:E869/
    echohl Function | echo msg | echohl NONE
    return
  endtry

  " Try highlighting the scope of current tag
  if !s:EchoScopeFromCacheIsOk()
    call s:TryParseAndEchoScope()
  endif

  " if start is 0, msg[0:-1] will display the redundant whole msg.
  if start != 0
    echohl Statement | echon msg[0 : start-1] | echohl NONE
  endif

  let end = start + strlen(tag)
  echohl Search    | echon msg[start : end-1] | echohl NONE
  echohl Statement | echon msg[end : ]        | echohl NONE
endfunction
./autoload/vista/error.vim	[[[1
71
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:Echo(group, msg) abort
  execute 'echohl' a:group
  echo a:msg
  echohl NONE
endfunction

function! s:Echon(group, msg) abort
  execute 'echohl' a:group
  echon a:msg
  echohl NONE
endfunction

function! vista#error#Expect(expected) abort
  call s:Echo('ErrorMsg', '[vista.vim]')
  call s:Echon('Normal', ' Invalid args. expected: ')
  call s:Echon('Underlined', a:expected)
endfunction

function! vista#error#Need(needed) abort
  call s:Echo('ErrorMsg', '[vista.vim]')
  call s:Echon('Normal', ' You must have ')
  call s:Echon('Underlined', a:needed)
  call s:Echon('Normal', ' installed to continue.')
endfunction

function! vista#error#RunCtags(cmd) abort
  call s:Echo('ErrorMsg', '[vista.vim]')
  call s:Echon('Normal', 'Fail to run ctags given the command: ')
  call s:Echon('Underlined', a:cmd)
endfunction

function! vista#error#For(cmd, filetype) abort
  call s:Echo('ErrorMsg', '[vista.vim]')
  call s:Echon('Underlined', ' '.a:cmd)
  call s:Echon('Normal', ' does not support '.a:filetype.' filetype.')
endfunction

function! vista#error#InvalidExecutive(exe) abort
  call s:Echo('ErrorMsg', '[vista.vim]')
  call s:Echon('Normal', ' The executive')
  call s:Echon('Underlined', ' '.a:exe.' ')
  call s:Echon('Normal', 'does not exist. Avaliable: ')
  call s:Echon('Underlined', string(g:vista#executives))
endfunction

function! vista#error#InvalidOption(opt, ...) abort
  call s:Echo('ErrorMsg', '[vista.vim]')
  call s:Echon('Normal', ' Invalid option '.a:opt.'. Avaliable: ')
  call s:Echon('Underlined', a:0 > 0 ? string(a:1) : '')
endfunction

function! vista#error#InvalidFinderArgument() abort
  call vista#error#Expect('Vista finder [FINDER|EXECUTIVE|FINDER:EXECUTIVE]')
endfunction

" Notify the error message when required.
function! vista#error#Notify(msg) abort
  if !get(g:vista, 'silent', v:true)
    call vista#error#(a:msg)
    let g:vista.silent = v:true
  endif
endfunction

function! vista#error#(msg) abort
  call s:Echo('ErrorMsg', '[vista.vim]')
  call s:Echon('Normal', ' '.a:msg)
endfunction
./autoload/vista/executive/ale.vim	[[[1
102
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

function! s:HandleLSPResponse(resp) abort
  let s:fetching = v:false
  if type(a:resp) != v:t_dict
        \ || has_key(a:resp, 'error')
        \ || !has_key(a:resp, 'result')
        \ || empty(get(a:resp, 'result', {}))
    return
  endif

  let s:data = vista#renderer#LSPPreprocess(a:resp.result)

  if !empty(s:data)
    let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

    " Update cache when new data comes.
    let s:cache = get(s:, 'cache', {})
    let s:cache[s:fpath] = s:data
    let s:cache.ftime = getftime(s:fpath)
    let s:cache.bufnr = bufnr('')
  endif

  call vista#cursor#TryInitialRun()
endfunction

function! s:AutoUpdate(fpath) abort
  let s:reload_only = v:true
  let s:fpath = a:fpath
  call s:RunAsync()
endfunction

function! s:Run() abort
  let s:fetching = v:false
  call s:RunAsync()
  while s:fetching
    sleep 100m
  endwhile
  return get(s:, 'data', {})
endfunction

function! s:RunAsync() abort
  let linters = map(filter(ale#linter#Get(&filetype), '!empty(v:val.lsp)'), 'v:val.name')
  if empty(linters)
    return
  endif

  let method = 'textDocument/documentSymbol'
  let bufnr = g:vista.source.bufnr
  let params = {
    \   'textDocument': {
    \       'uri': ale#path#ToFileURI(expand('#' . bufnr . ':p')),
    \   }
    \}
  let message = [0, method, params]
  let Callback = function('s:HandleLSPResponse')

  for linter in linters
    call ale#lsp_linter#SendRequest(bufnr, linter, message, Callback)
    let s:fetching = v:true
  endfor
endfunction

function! vista#executive#ale#Run(fpath) abort
  if exists('g:loaded_ale_dont_use_this_in_other_plugins_please')
    let s:fpath = a:fpath
    return s:Run()
  endif
endfunction

function! vista#executive#ale#RunAsync() abort
  if exists('g:loaded_ale_dont_use_this_in_other_plugins_please')
    call s:RunAsync()
  endif
endfunction

function! vista#executive#ale#Execute(bang, should_display, ...) abort
  call vista#source#Update(bufnr('%'), winnr(), expand('%'), expand('%:p'))
  let s:fpath = expand('%:p')

  let g:vista.silent = v:false
  let s:should_display = a:should_display

  call vista#OnExecute(s:provider, function('s:AutoUpdate'))

  if a:bang
    call s:Run()
  else
    call s:RunAsync()
  endif
endfunction

function! vista#executive#ale#Cache() abort
  return get(s:, 'cache', {})
endfunction
./autoload/vista/executive/coc.vim	[[[1
119
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

" Extract fruitful infomation from raw symbols
function! s:DoHandleResponse(symbols) abort
  let s:data = []

  if empty(a:symbols)
    return
  endif

  let g:vista.functions = []
  let g:vista.raw = []
  call map(a:symbols, 'vista#parser#lsp#CocSymbols(v:val, s:data)')

  if !empty(s:data)
    let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

    " Update cache when new data comes.
    let s:cache = get(s:, 'cache', {})
    let s:cache[s:fpath] = s:data
    let s:cache.ftime = getftime(s:fpath)
    let s:cache.bufnr = bufnr('')
  endif

  return s:data
endfunction

" Deprecated as a lot of people complain the error message.
function! s:HandleLSPResponse(error, response) abort
  if empty(a:error)
    " Refer to coc.nvim 79cb11e
    " No document symbol provider exists when response is null.
    if a:response isnot v:null
      call s:DoHandleResponse(a:response)
      call vista#cursor#TryInitialRun()
    endif
  else
    call vista#error#Notify("Error when calling CocActionAsync('documentSymbols'): ".string(a:error))
  endif
endfunction

function! s:HandleLSPResponseInSilence(error, response) abort
  if empty(a:error) && a:response isnot v:null
    call s:DoHandleResponse(a:response)
  endif
endfunction

function! s:AutoUpdate(_fpath) abort
  let s:reload_only = v:true
  call vista#AutoUpdateWithDelay(function('CocActionAsync'), ['documentSymbols', function('s:HandleLSPResponseInSilence')])
endfunction

function! s:Run() abort
  return s:DoHandleResponse(CocAction('documentSymbols'))
endfunction

function! s:RunAsync() abort
  call CocActionAsync('documentSymbols', function('s:HandleLSPResponseInSilence'))
endfunction

function! s:Execute(bang, should_display) abort
  call vista#source#Update(bufnr('%'), winnr(), expand('%'), expand('%:p'))
  let s:fpath = expand('%:p')

  if a:bang
    call s:DoHandleResponse(CocAction('documentSymbols'))
    if a:should_display
      call vista#renderer#RenderAndDisplay(s:data)
    endif
  else
    let s:should_display = a:should_display
    call s:RunAsync()
  endif
endfunction

function! s:Dispatch(F, ...) abort
  if !exists('*CocActionAsync')
    call vista#error#Need('coc.nvim')
    return
  endif

  call vista#SetProvider(s:provider)
  return call(function(a:F), a:000)
endfunction

function! vista#executive#coc#Cache() abort
  return get(s:, 'cache', {})
endfunction

" Internal public APIs
"
" Run and RunAsync is for internal use.
function! vista#executive#coc#Run(fpath) abort
  if exists('*CocAction')
    call vista#SetProvider(s:provider)
    let s:fpath = a:fpath
    call vista#win#Execute(g:vista.source.get_winnr(), function('s:Run'))
    return s:data
  endif
endfunction

function! vista#executive#coc#RunAsync() abort
  call s:Dispatch('s:RunAsync')
endfunction

" The public Execute function is used for interacting with this plugin from
" outside, where sets the provider and auto update events.
function! vista#executive#coc#Execute(bang, should_display, ...) abort
  call vista#OnExecute(s:provider, function('s:AutoUpdate'))
  let g:vista.silent = v:false
  return s:Dispatch('s:Execute', a:bang, a:should_display)
endfunction
./autoload/vista/executive/ctags.vim	[[[1
440
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:ctags = get(g:, 'vista_ctags_executable', 'ctags')
let s:support_json_format =
      \ len(filter(systemlist(s:ctags.' --list-features'), 'v:val =~# ''^json''')) > 0

" Expose this variable for debugging
let g:vista#executive#ctags#support_json_format = s:support_json_format

let s:ctags_project_opts = get(g:, 'vista_ctags_project_opts', '')

if s:support_json_format
  let s:default_cmd_fmt = '%s %s %s --output-format=json --fields=-PF -f- %s'
  let s:DefaultTagParser = function('vista#parser#ctags#FromJSON')
else
  let s:default_cmd_fmt = '%s %s %s -f- %s'
  let s:DefaultTagParser = function('vista#parser#ctags#FromExtendedRaw')
endif

let s:is_mac = has('macunix')
let s:is_linux = has('unix') && !has('macunix') && !has('win32unix')
let s:can_async = has('patch-8.0.0027')

function! s:GetCustomCmd(filetype) abort
  if exists('g:vista_ctags_cmd')
        \ && has_key(g:vista_ctags_cmd, a:filetype)
    return g:vista_ctags_cmd[a:filetype]
  endif
  return v:null
endfunction

function! s:GetDefaultCmd(file) abort
  " Refer to tagbar
  let common_opt = '--format=2 --excmd=pattern --fields=+nksSaf --extras=+F --sort=no --append=no'

  " Do not pass --extras for C/CPP in order to let uctags handle the tags for anonymous
  " entities correctly.
  if g:vista.source.filetype() !=# 'c' && g:vista.source.filetype() !=# 'cpp'
    let common_opt .= ' --extras= '
  endif

  let language_specific_opt = s:GetLanguageSpecificOptition(&filetype)
  let cmd = printf(s:default_cmd_fmt, s:ctags, common_opt, language_specific_opt, a:file)

  return cmd
endfunction

function! s:GetLanguageSpecificOptition(filetype) abort
  let opt = ''

  try
    let types = g:vista#types#uctags#{a:filetype}#
    let lang = types.lang
    let kinds = join(keys(types.kinds), '')
    let opt = printf('--language-force=%s --%s-kinds=%s', lang, lang, kinds)
  " Ignore Vim(let):E121: Undefined variable
  catch /^Vim\%((\a\+)\)\=:E121/
  endtry

  return opt
endfunction

function! s:NoteTemp() abort
  if exists('s:tmp_file')
    call add(g:vista.tmps, s:tmp_file)
    unlet s:tmp_file
  endif
endfunction

" FIXME support all languages that ctags does
function! s:BuildCmd(origin_fpath) abort
  let s:tmp_file = s:IntoTemp(a:origin_fpath)
  if empty(s:tmp_file)
    return ''
  endif

  call vista#Debug('executive::ctags::s:BuildCmd origin_fpath:'.a:origin_fpath)
  let s:fpath = a:origin_fpath

  let custom_cmd = s:GetCustomCmd(&filetype)

  if custom_cmd isnot v:null
    let cmd = printf('%s %s', custom_cmd, s:tmp_file)
    if stridx(custom_cmd, '--output-format=json') > -1
      let s:TagParser = function('vista#parser#ctags#FromJSON')
    else
      let s:TagParser = function('vista#parser#ctags#FromExtendedRaw')
    endif
  else
    let cmd = s:GetDefaultCmd(s:tmp_file)
    let s:TagParser = s:DefaultTagParser
  endif

  let g:vista.ctags_cmd = cmd

  return cmd
endfunction

function! s:PrepareContainer() abort
  let s:data = {}
  let g:vista = get(g:, 'vista', {})
  let g:vista.functions = []
  let g:vista.raw = []
  let g:vista.kinds = []
  let g:vista.raw_by_kind = {}
  let g:vista.with_scope = []
  let g:vista.without_scope = []
  let g:vista.tree = {}
endfunction

" Process the preprocessed output by ctags and remove s:jodid.
function! s:ApplyExtracted() abort
  " Update cache when new data comes.
  let s:cache = get(s:, 'cache', {})
  let s:cache[s:fpath] = s:data
  let s:cache.ftime = getftime(s:fpath)
  let s:cache.bufnr = bufnr('')

  call vista#Debug('executive::ctags::s:ApplyExtracted s:fpath:'.s:fpath.', s:reload_only:'.s:reload_only.', s:should_display:'.s:should_display)
  let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

  if exists('s:jodid')
    unlet s:jodid
  endif

  call s:NoteTemp()
  call vista#cursor#TryInitialRun()
endfunction

function! s:ExtractLinewise(raw_data) abort
  call s:PrepareContainer()
  call map(a:raw_data, 's:TagParser(v:val, s:data)')
endfunction

function! s:AutoUpdate(fpath) abort
  call vista#Debug('executive::ctags::s:AutoUpdate '.a:fpath)
  if g:vista.source.filetype() ==# 'markdown'
        \ && get(g:, 'vista_enable'.&filetype.'_extension', 1)
    call vista#extension#{&ft}#AutoUpdate(a:fpath)
  else
    call vista#OnExecute(s:provider, function('s:AutoUpdate'))
    let s:reload_only = v:true
    call vista#Debug('executive::ctags::s:AutoUpdate calling s:ApplyExecute '.a:fpath)
    call s:ApplyExecute(v:false, a:fpath)
  endif
endfunction

function! vista#executive#ctags#AutoUpdate(fpath) abort
  call vista#OnExecute(s:provider, function('s:AutoUpdate'))
  call s:AutoUpdate(a:fpath)
endfunction

" Run ctags synchronously given the cmd
function! s:ApplyRun(cmd) abort
  call vista#Debug('executive::ctags::s:ApplyRun:'.a:cmd)
  let output = system(a:cmd)
  if v:shell_error
    return vista#error#('Fail to run ctags: '.a:cmd)
  endif

  let s:cache = get(s:, 'cache', {})
  let s:cache.fpath = s:fpath

  call s:ExtractLinewise(split(output, "\n"))
endfunction

if has('nvim')
  function! s:on_exit(_job, _data, _event) abort dict
    if !exists('g:vista') || v:dying || !has_key(self, 'stdout')
      return
    endif

    if self.stderr != ['']
      call vista#error#(join(self.stderr, "\n"))
      return
    endif

    if self.stdout == ['']
      return
    endif

    call vista#Debug('ctags::s:on_exit '.string(self.stdout))
    " Second last line is the real last one in neovim
    call s:ExtractLinewise(self.stdout[:-2])

    call s:ApplyExtracted()
  endfunction

  " Run ctags asynchronously given the cmd
  function! s:ApplyRunAsync(cmd) abort
      " job is job id in neovim
      let jobid = jobstart(a:cmd, {
              \ 'stdout_buffered': 1,
              \ 'stderr_buffered': 1,
              \ 'on_exit': function('s:on_exit')
              \ })
    return jobid > 0 ? jobid : 0
  endfunction
else

  function! s:close_cb(channel) abort
    call s:PrepareContainer()

    if ch_status(a:channel, {'part': 'err'}) ==# 'buffered'
      let line = ch_read(a:channel, {'part': 'err'})
      call vista#error#(line)
      return
    endif

    while ch_status(a:channel, {'part': 'out'}) ==# 'buffered'
      let line = ch_read(a:channel)
      call s:TagParser(line, s:data)
    endwhile

    call s:ApplyExtracted()
  endfunction

  if has('win32')
    function! s:WrapCmd(cmd) abort
      return &shell . ' ' . &shellcmdflag . ' ' . a:cmd
    endfunction
  else
    function! s:WrapCmd(cmd) abort
      return split(&shell) + split(&shellcmdflag) + [a:cmd]
    endfunction
  endif

  function! s:ApplyRunAsync(cmd) abort
    let job = job_start(s:WrapCmd(a:cmd), {
          \ 'close_cb':function('s:close_cb')
          \ })
    let jobid = matchstr(job, '\d\+') + 0
    return jobid > 0 ? jobid : 0
  endfunction
endif

function! s:TryAppendExtension(tempname) abort
  let ext = g:vista.source.extension()
  if !empty(ext)
    return join([a:tempname, ext], '.')
  else
    return a:tempname
  endif
endfunction

function! s:BuiltinTempname() abort
  let tempname = tempname()
  return s:TryAppendExtension(tempname)
endfunction

function! s:TempnameBasedOnSourceBufname() abort
  let tempname = sha256(fnamemodify(bufname(g:vista.source.bufnr), ':p'))
  return s:TryAppendExtension(tempname)
endfunction

function! s:FromTMPDIR() abort
  let tmpdir = $TMPDIR
  if empty(tmpdir)
    let tmpdir = '/tmp/'
  elseif tmpdir !~# '/$'
    let tmpdir .= '/'
  endif
  return tmpdir
endfunction

function! s:GetTempDirectory() abort
  if exists('s:tmpdir')
    return s:tmpdir
  else
    if exists('$TMPDIR')
      let s:tmpdir = s:FromTMPDIR()
    else
      let s:tmpdir = vista#util#CacheDirectory()
    endif
    return s:tmpdir
  endif
endfunction

" Use a temporary files for ctags processing instead of the original one.
" This allows using Tagbar for files accessed with netrw, and also doesn't
" slow down Tagbar for files that sit on slow network drives.
" This idea comes from tagbar.
function! s:IntoTemp(...) abort
  " Don't use tempname() if possible since it would cause the changing of the anonymous tag name.
  "
  " Ref: https://github.com/liuchengxu/vista.vim/issues/122#issuecomment-511115932
  try
    let tmp = s:GetTempDirectory().s:TempnameBasedOnSourceBufname()
  catch
    let tmp = s:BuiltinTempname()
  endtry

  if get(g:vista, 'on_text_changed', 0)
    let lines = g:vista.source.lines()
    let g:vista.on_text_changed = 0
  else
    if empty(a:1)
      let lines = g:vista.source.lines()
    else
      try
        let lines = readfile(a:1)
      " Vim cannot read a temporary file, this may happen when you open vim with
      " a file which does not exist yet, e.g., 'vim does_exist_yet.txt'
      catch
        " catch all readfile exception
        return
      endtry
    endif
  endif

  if writefile(lines, tmp) == 0
    return tmp
  else
    return vista#error#('Fail to write into a temp file.')
  endif
endfunction

function! s:ApplyExecute(bang, fpath) abort
  let cmd = s:BuildCmd(a:fpath)
  if empty(cmd)
    return
  endif

  if a:bang || !s:can_async
    call s:ApplyRun(cmd)
  else
    call vista#Debug('executive::ctags::s:ApplyExecute calling s:RunAsyncCommon('.cmd.')')
    call s:RunAsyncCommon(cmd)
  endif
endfunction

function! s:Run(fpath) abort
  let cmd = s:BuildCmd(a:fpath)
  if empty(cmd)
    return
  endif

  call s:ApplyRun(cmd)

  return s:data
endfunction

function! s:RunAsyncCommon(cmd) abort
  if exists('s:jodid')
    call vista#util#JobStop(s:jodid)
    call s:NoteTemp()
  endif

  let s:jodid = s:ApplyRunAsync(a:cmd)

  if !s:jodid
    call vista#error#RunCtags(a:cmd)
  endif
endfunction

function! s:RunAsync(fpath) abort
  if s:can_async
    let cmd = s:BuildCmd(a:fpath)
    if empty(cmd)
      return
    endif

    call s:RunAsyncCommon(cmd)
  endif
endfunction

function! s:Execute(bang, should_display) abort
  let s:should_display = a:should_display
  let s:fpath = expand('%:p')
  call s:ApplyExecute(a:bang, s:fpath)
endfunction

function! s:Dispatch(F, ...) abort
  let custom_cmd = s:GetCustomCmd(&filetype)

  let exe = custom_cmd isnot v:null ? split(custom_cmd)[0] : s:ctags

  if !executable(exe)
    call vista#error#Need(exe)
    return
  endif

  call vista#SetProvider(s:provider)
  return call(function(a:F), a:000)
endfunction

function! vista#executive#ctags#Cache() abort
  return get(s:, 'data', {})
endfunction

" Run ctags given the cmd synchronously
function! vista#executive#ctags#Run(fpath) abort
  return s:Dispatch('s:Run', a:fpath)
endfunction

" Run ctags given the cmd asynchronously
function! vista#executive#ctags#RunAsync(fpath) abort
  call s:Dispatch('s:RunAsync', a:fpath)
endfunction

function! vista#executive#ctags#Execute(bang, should_display, ...) abort
  call vista#OnExecute(s:provider, function('s:AutoUpdate'))
  return s:Dispatch('s:Execute', a:bang, a:should_display)
endfunction

" Run ctags recursively.
function! vista#executive#ctags#ProjectRun() abort
  if !exists('s:recursive_ctags_cmd')
    " https://github.com/universal-ctags/ctags/issues/2042
    "
    " If ctags has the json format feature, we should use the
    " `--output-format=json` option, which is easier to parse and more reliable.
    " Otherwise we will use the `--_xformat` option.
    if s:support_json_format
      let s:recursive_ctags_cmd = s:ctags.' '.s:ctags_project_opts.' -R -x --output-format=json --fields=+n'
      let s:RecursiveParser = function('vista#parser#ctags#RecursiveFromJSON')
    else
      let s:recursive_ctags_cmd = s:ctags.' '.s:ctags_project_opts." -R -x --_xformat='TAGNAME:%N ++++ KIND:%K ++++ LINE:%n ++++ INPUT-FILE:%F ++++ PATTERN:%P'"
      let s:RecursiveParser = function('vista#parser#ctags#RecursiveFromXformat')
    endif
  endif

  let output = system(s:recursive_ctags_cmd)
  if v:shell_error
    return vista#error#RunCtags(s:recursive_ctags_cmd)
  endif

  let s:data = {}

  call map(split(output, "\n"), 's:RecursiveParser(v:val, s:data)')

  return s:data
endfunction
./autoload/vista/executive/lcn.vim	[[[1
88
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:fetching = v:true

function! s:HandleLSPResponse(output) abort
  let s:fetching = v:false
  if !has_key(a:output, 'result')
    call vista#error#Notify('No result via LanguageClient#textDocument_documentSymbol()')
    return
  endif

  let s:data = vista#renderer#LSPPreprocess(a:output.result)
  let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

  " Update cache when new data comes.
  let s:cache = get(s:, 'cache', {})
  let s:cache[s:fpath] = s:data
  let s:cache.ftime = getftime(s:fpath)
  let s:cache.bufnr = bufnr('')

  call vista#cursor#TryInitialRun()
endfunction

function! s:AutoUpdate(fpath) abort
  let s:reload_only = v:true
  let s:fpath = a:fpath
  call s:RunAsync()
endfunction

function! s:Run() abort
  if !exists('*LanguageClient#textDocument_documentSymbol')
    return
  endif
  call s:RunAsync()
  let s:fetching = v:true
  while s:fetching
    sleep 100m
  endwhile
  return get(s:, 'data', {})
endfunction

function! s:RunAsync() abort
  if exists('*LanguageClient#textDocument_documentSymbol')
    call vista#SetProvider(s:provider)
    call vista#win#Execute(
          \ g:vista.source.get_winnr(),
          \ function('LanguageClient#textDocument_documentSymbol'),
          \ {'handle': v:false},
          \ function('s:HandleLSPResponse')
          \ )
  endif
endfunction

function! vista#executive#lcn#Run(fpath) abort
  let s:fpath = a:fpath
  return s:Run()
endfunction

function! vista#executive#lcn#RunAsync() abort
  call s:RunAsync()
endfunction

function! vista#executive#lcn#Execute(bang, should_display, ...) abort
  call vista#source#Update(bufnr('%'), winnr(), expand('%'), expand('%:p'))
  let s:fpath = expand('%:p')

  call vista#OnExecute(s:provider, function('s:AutoUpdate'))

  let g:vista.silent = v:false
  let s:should_display = a:should_display

  if a:bang
    return s:Run()
  else
    call s:RunAsync()
  endif
endfunction

function! vista#executive#lcn#Cache() abort
  return get(s:, 'cache', {})
endfunction
./autoload/vista/executive/nvim_lsp.vim	[[[1
101
" Copyright (c) 2019 Alvaro Muñoz
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let g:vista_executive_nvim_lsp_reload_only = v:false
let g:vista_executive_nvim_lsp_should_display = v:false
let g:vista_executive_nvim_lsp_fetching = v:true

function! s:AutoUpdate(fpath) abort
  let g:vista_executive_nvim_lsp_reload_only = v:true
  let s:fpath = a:fpath
  call s:RunAsync()
endfunction

function! s:Run() abort
  if !has('nvim-0.5')
    return
  endif
  let g:vista_executive_nvim_lsp_fetching = v:true
  call s:RunAsync()
  while g:vista_executive_nvim_lsp_fetching
    sleep 100m
  endwhile
  return get(s:, 'data', {})
endfunction

function! vista#executive#nvim_lsp#SetData(data) abort
  let s:data = a:data
  " Update cache when new data comes.
  let s:cache = get(s:, 'cache', {})
  let s:cache[s:fpath] = s:data
  let s:cache.ftime = getftime(s:fpath)
  let s:cache.bufnr = bufnr('')
endfunction

function! s:RunAsync() abort
  if !has('nvim-0.5')
    return
  endif
  call vista#SetProvider(s:provider)
  lua << EOF
    local params = vim.lsp.util.make_position_params()
    local callback = function(err, method_or_result, result_or_context)
        -- signature for the handler changed in neovim 0.6/master. The block
        -- below allows users to check the compatibility.
        local result
        if type(method_or_result) == 'string' then
          -- neovim 0.5.x
          result = result_or_context
        else
          -- neovim 0.6+
          result = method_or_result
        end

        if err then print(tostring(err)) return end
        if not result then return end
        data = vim.fn['vista#renderer#LSPPreprocess'](result)
        vim.fn['vista#executive#nvim_lsp#SetData'](data)
        vim.g.vista_executive_nvim_lsp_fetching = false
        if next(data) ~= nil then
          res = vim.fn['vista#renderer#LSPProcess'](data, vim.g.vista_executive_nvim_lsp_reload_only, vim.g.vista_executive_nvim_lsp_should_display)
          vim.g.vista_executive_nvim_lsp_reload_only = res[1]
          vim.g.vista_executive_nvim_lsp_should_display = res[2]
          vim.fn['vista#cursor#TryInitialRun']()
        end
    end
    vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, callback)
EOF
endfunction

function! vista#executive#nvim_lsp#Run(fpath) abort
  " TODO: check if the LSP service is registered for fpath.
  let s:fpath = a:fpath
  return s:Run()
endfunction

function! vista#executive#nvim_lsp#RunAsync() abort
  call s:RunAsync()
endfunction

function! vista#executive#nvim_lsp#Execute(bang, should_display, ...) abort
  call vista#source#Update(bufnr('%'), winnr(), expand('%'), expand('%:p'))
  let s:fpath = expand('%:p')

  call vista#OnExecute(s:provider, function('s:AutoUpdate'))

  let g:vista.silent = v:false
  let g:vista_executive_nvim_lsp_should_display = a:should_display

  if a:bang
    return s:Run()
  else
    call s:RunAsync()
  endif
endfunction

function! vista#executive#nvim_lsp#Cache() abort
  return get(s:, 'cache', {})
endfunction
./autoload/vista/executive/vim_lsc.vim	[[[1
89
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:fetching = v:true

function! s:HandleLSPResponse(results) abort
  let s:fetching = v:false
  if empty(a:results)
    return []
  endif

  let s:data = vista#renderer#LSPPreprocess(a:results)

  if !empty(s:data)
    let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

    " Update cache when new data comes.
    let s:cache = get(s:, 'cache', {})
    let s:cache[s:fpath] = s:data
    let s:cache.ftime = getftime(s:fpath)
    let s:cache.bufnr = bufnr('')
  endif

  call vista#cursor#TryInitialRun()
endfunction

function! s:AutoUpdate(fpath) abort
  let s:reload_only = v:true
  let s:fpath = a:fpath
  call s:RunAsync()
endfunction

function! s:Run() abort
  if !exists('*lsc#server#userCall')
    return
  endif
  call s:RunAsync()
  while s:fetching
    sleep 100m
  endwhile
  return get(s:, 'data', {})
endfunction

function! s:RunAsync() abort
  if exists('*lsc#server#userCall')
    call vista#SetProvider(s:provider)

    " vim-lsc
    call lsc#file#flushChanges()
    call lsc#server#userCall('textDocument/documentSymbol',
        \ lsc#params#textDocument(),
        \ function('s:HandleLSPResponse'))
  endif
endfunction

function! vista#executive#vim_lsc#Run(fpath) abort
  let s:fpath = a:fpath
  return s:Run()
endfunction

function! vista#executive#vim_lsc#RunAsync() abort
  call s:RunAsync()
endfunction

function! vista#executive#vim_lsc#Execute(bang, should_display, ...) abort
  call vista#source#Update(bufnr('%'), winnr(), expand('%'), expand('%:p'))
  let s:fpath = expand('%:p')

  call vista#OnExecute(s:provider, function('s:AutoUpdate'))

  let g:vista.silent = v:false
  let s:should_display = a:should_display

  if a:bang
    return s:Run()
  else
    call s:RunAsync()
  endif
endfunction

function! vista#executive#vim_lsc#Cache() abort
  return get(s:, 'cache', {})
endfunction
./autoload/vista/executive/vim_lsp.vim	[[[1
116
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:last_req_id = 0

function! s:HandleLSPResponse(_server, _req_id, _type, data) abort
  let s:fetching = v:false
  if !has_key(a:data.response, 'result')
    return []
  endif

  let result = a:data.response.result

  let s:data = vista#renderer#LSPPreprocess(result)

  if !empty(s:data)
    let s:ever_done = v:true
    let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

    " Update cache when new data comes.
    let s:cache = get(s:, 'cache', {})
    let s:cache[s:fpath] = s:data
    let s:cache.ftime = getftime(s:fpath)
    let s:cache.bufnr = bufnr('')
  endif

  call vista#cursor#TryInitialRun()
endfunction

function! s:AutoUpdate(fpath) abort
  let s:reload_only = v:true
  let s:fpath = a:fpath
  if s:HasAvaliableServers()
    call s:RunAsync()
  endif
endfunction

function! s:HasAvaliableServers() abort
  if !exists('*lsp#get_whitelisted_servers')
    return 0
  endif
  let s:servers = filter(lsp#get_whitelisted_servers(),
        \ 'lsp#capabilities#has_document_symbol_provider(v:val)')
  return len(s:servers)
endfunction

function! s:Run() abort
  call s:RunAsync()
  while s:fetching
    sleep 100m
  endwhile
  return get(s:, 'data', {})
endfunction

function! s:RunAsync() abort
  call vista#SetProvider(s:provider)
  for server in s:servers
    call lsp#send_request(server, {
        \ 'method': 'textDocument/documentSymbol',
        \ 'params': {
        \   'textDocument': lsp#get_text_document_identifier(),
        \ },
        \ 'on_notification': function('s:HandleLSPResponse', [server, s:last_req_id, 'documentSymbol']),
        \ })
    let s:fetching = v:true
  endfor
endfunction

function! vista#executive#vim_lsp#Run(fpath) abort
  if s:HasAvaliableServers()
    let s:fpath = a:fpath
    return s:Run()
  endif
endfunction

function! vista#executive#vim_lsp#RunAsync() abort
  if s:HasAvaliableServers()
    call s:RunAsync()
  endif
endfunction

function! vista#executive#vim_lsp#Execute(bang, should_display, ...) abort
  if !s:HasAvaliableServers()
    if get(a:000, 0, v:true)
      return vista#error#('Retrieving symbols is not avaliable')
    endif
    return
  endif

  call vista#source#Update(bufnr('%'), winnr(), expand('%'), expand('%:p'))
  let s:fpath = expand('%:p')

  call vista#OnExecute(s:provider, function('s:AutoUpdate'))

  let g:vista.silent = v:false
  let s:should_display = a:should_display

  if a:bang
    call s:Run()
  else
    if !exists('s:ever_done')
      call vista#util#Retriving(s:provider)
    endif
    call s:RunAsync()
  endif
endfunction

function! vista#executive#vim_lsp#Cache() abort
  return get(s:, 'cache', {})
endfunction
./autoload/vista/extension/markdown.vim	[[[1
93
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

function! s:IsHeader(cur_line, next_line) abort
  return a:cur_line =~# '^#\+' ||
        \ a:cur_line =~# '^\S' && (a:next_line =~# '^=\+\s*$' || a:next_line =~# '^-\+\s*$')
endfunction

function! s:GatherHeaderMetadata() abort
  let is_fenced_block = 0

  let s:lnum2tag = {}

  let headers = []

  let idx = 0
  let lines = g:vista.source.lines()

  for line in lines
    let line = substitute(line, '#', "\\\#", 'g')
    let next_line = get(lines, idx + 1, '')

    if l:line =~# '````*' || l:line =~# '\~\~\~\~*'
      let is_fenced_block = !is_fenced_block
    endif

    let is_header = s:IsHeader(l:line, l:next_line)

    if is_header && !is_fenced_block
        let matched = matchlist(l:line, '\(\#*\)\(.*\)')
        let text = vista#util#Trim(matched[2])
        let s:lnum2tag[len(headers)] = text
        call add(headers, {'lnum': idx+1, 'text': text, 'level': strlen(matched[1])})
    endif

    let idx += 1
  endfor

  return headers
endfunction

" Use s:lnum2tag so that we don't have to extract the header from the rendered line.
function! vista#extension#markdown#GetHeader(lnum) abort
  return get(s:lnum2tag, a:lnum, v:null)
endfunction

function! s:ApplyAutoUpdate() abort
  if has_key(g:vista, 'bufnr') && g:vista.winnr() != -1
    call vista#SetProvider(s:provider)
    let rendered = vista#renderer#markdown_like#MD(s:GatherHeaderMetadata())
    call vista#util#SetBufline(g:vista.bufnr, rendered)
  endif
endfunction

function! vista#extension#markdown#AutoUpdate(fpath) abort
  call s:AutoUpdate(a:fpath)
endfunction

function! s:ShouldUseMarkdownExtension(source_filetype) abort
  if a:source_filetype ==# 'markdown'
    return v:true
  " vimwiki can reuse the markdown extension.
  elseif a:source_filetype ==# 'vimwiki'
        \ && vista#GetExplicitExecutive(a:source_filetype) ==# 'markdown'
    return v:true
  else
    return v:false
  endif
endfunction

function! s:AutoUpdate(fpath) abort
  let source_filetype = g:vista.source.filetype()
  if s:ShouldUseMarkdownExtension(source_filetype)
    call s:ApplyAutoUpdate()
  elseif source_filetype ==# 'rst'
    call vista#extension#rst#AutoUpdate(a:fpath)
  else
    call vista#executive#ctags#AutoUpdate(a:fpath)
  endif
endfunction

" Credit: originally from `:Toc` of vim-markdown
function! vista#extension#markdown#Execute(_bang, should_display) abort
  call vista#OnExecute(s:provider, function('s:AutoUpdate'))

  if a:should_display
    let rendered = vista#renderer#markdown_like#MD(s:GatherHeaderMetadata())
    call vista#sidebar#OpenOrUpdate(rendered)
  endif
endfunction
./autoload/vista/extension/rst.vim	[[[1
81
" Copyright (c) 2019 Mathieu Clabaut
" MIT License
" vim: ts=2 sw=2 sts=2 et
"
" Heavily inspired  from https://raw.githubusercontent.com/Shougo/unite-outline/master/autoload/unite/sources/outline/defaults/rst.vim

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

function! s:GatherHeaderMetadata() abort
  let headers = []

  let s:lnum2tag = {}

  let idx = 0
  let adornment_levels = {}
  let adornment_id = 2

  let lines = g:vista.source.lines()
  while idx < len(lines)
    let line = lines[idx]
    let matched_line = get(lines, idx + 1, '')
    " Check the matching strictly.
    if matched_line =~# '^\([[:punct:]]\)\1\{3,}$' && line !~# '^\s*$'
      let text = vista#util#Trim(l:line)
      if idx > 1 && lines[idx - 1] == matched_line
        " Title
        let item = {'lnum': idx+1, 'text': text, 'level': 1}
      else
        " Sections
        let item = {'lnum': idx+1, 'text': text}
        let adchar = matched_line[0]
        if !has_key(l:adornment_levels, adchar)
          let l:adornment_levels[adchar] = l:adornment_id
          let l:adornment_id += 1
        endif
        let item['level'] = l:adornment_levels[adchar]
      endif
      let s:lnum2tag[len(headers)] = text
      call add(headers, l:item)
      let idx += 1
    endif
    let idx += 1
 endwhile

  return headers
endfunction

function! vista#extension#rst#GetHeader(lnum) abort
  return get(s:lnum2tag, a:lnum, v:null)
endfunction

function! s:ApplyAutoUpdate() abort
  if has_key(g:vista, 'bufnr') && g:vista.winnr() != -1
    call vista#SetProvider(s:provider)
    let rendered = vista#renderer#markdown_like#RST(s:GatherHeaderMetadata())
    call vista#util#SetBufline(g:vista.bufnr, rendered)
  endif
endfunction

function! vista#extension#rst#AutoUpdate(fpath) abort
  call s:AutoUpdate(a:fpath)
endfunction

function! s:AutoUpdate(fpath) abort
  if g:vista.source.filetype() ==# 'rst'
    call s:ApplyAutoUpdate()
  elseif g:vista.source.filetype() ==# 'markdown'
    call vista#extension#markdown#AutoUpdate(a:fpath)
  else
    call vista#executive#ctags#AutoUpdate(a:fpath)
  endif
endfunction

function! vista#extension#rst#Execute(_bang, should_display) abort
  call vista#OnExecute(s:provider, function('s:AutoUpdate'))

  if a:should_display
    let rendered = vista#renderer#markdown_like#RST(s:GatherHeaderMetadata())
    call vista#sidebar#OpenOrUpdate(rendered)
  endif
endfunction
./autoload/vista/finder/clap.vim	[[[1
10
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! vista#finder#clap#Run(...) abort
  if !exists('g:loaded_clap')
    return vista#error#Need('https://github.com/liuchengxu/vim-clap')
  endif
  Clap tags
endfunction
./autoload/vista/finder/fzf.vim	[[[1
215
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf-8

let s:finder = fnamemodify(expand('<sfile>'), ':t:r')

let s:cols_layout = {}
let s:aligner = {}

function! s:cols_layout.project_ctags() abort
  let [max_len_scope, max_len_lnum_and_text, max_len_relpath] = [-1, -1, -1]

  for [kind, v] in items(s:data)
    let scope_len = strwidth(kind)
    if scope_len > max_len_scope
      let max_len_scope = scope_len
    endif

    for item in v
      let lnum_and_text = printf('%s:%s', item.lnum, item.text)
      let len_lnum_and_text = strwidth(lnum_and_text)
      if len_lnum_and_text > max_len_lnum_and_text
        let max_len_lnum_and_text = len_lnum_and_text
      endif

      let relpath = item.tagfile
      let len_relpath = strwidth(relpath)
      if len_relpath > max_len_relpath
        let max_len_relpath = len_relpath
      endif
    endfor
  endfor

  return [max_len_scope, max_len_lnum_and_text, max_len_relpath]
endfunction

function! s:aligner.project_ctags() abort
  let source = []

  let [max_len_scope, max_len_lnum_and_text, max_len_relpath] = s:cols_layout.project_ctags()

  for [kind, v] in items(s:data)
    let icon = vista#renderer#IconFor(kind)
    for item in v
      " FIXME handle ctags -R better
      let lnum_and_text = printf('%s:%s', item.lnum, item.text)
      let relpath = item.tagfile
      let row = printf('%s %s%s  [%s]%s  %s%s  %s',
            \ icon,
            \ lnum_and_text, repeat(' ', max_len_lnum_and_text- strwidth(lnum_and_text)),
            \ kind, repeat(' ', max_len_scope - strwidth(kind)),
            \ relpath, repeat(' ', max_len_relpath - strwidth(relpath)),
            \ item.taginfo)
      call add(source, row)
    endfor
  endfor

  return source
endfunction

function! vista#finder#fzf#extract(line) abort
  if g:vista#renderer#enable_icon
    " icon tag:lnum
    let icon_stripped = join(split(a:line)[1:], ' ')
  else
    let icon_stripped = a:line
  end

  " [a-zA-Z:#_.,<>]
  " matching tag can't contain whitespace, but a tag does have a chance to contain whitespace?
  let items = matchlist(icon_stripped, '\([a-zA-Z:#_.,<>]*\):\(\d\+\)')
  let tag = items[1]
  let lnum = items[2]

  return [lnum, tag]
endfunction

" Optional argument: winid for the origin tags window
function! vista#finder#fzf#sink(line, ...) abort
  let [lnum, tag] = vista#finder#fzf#extract(a:line)
  let col = stridx(g:vista.source.line(lnum), tag)
  let col = col == -1 ? 1 : col + 1
  if a:0 > 0
    if win_getid() != a:1
      noautocmd call win_gotoid(a:1)
    endif
  else
    call vista#source#GotoWin()
  endif
  call vista#util#Cursor(lnum, col)
  normal! zz
  call call('vista#util#Blink', get(g:, 'vista_blink', [2, 100]))
endfunction

" Actually call fzf#run() with a highlighter given the opts
function! s:ApplyRun() abort
  try
    " fzf_colors may interfere custom syntax.
    " Unlet and restore it later.
    if exists('g:fzf_colors') && !get(g:, 'vista_keep_fzf_colors', 0)
      let l:old_fzf_colors = g:fzf_colors
      unlet g:fzf_colors
    endif

    call fzf#run(fzf#wrap(s:opts))
  finally
    if exists('l:old_fzf_colors')
      let g:fzf_colors = old_fzf_colors
    endif
  endtry
endfunction

function! s:Run(...) abort
  let source  = vista#finder#PrepareSource(s:data)
  let using_alternative = get(s:, 'using_alternative', v:false) ? '*' : ''
  let prompt = using_alternative.s:finder.':'.s:cur_executive.'> '

  let s:opts = vista#finder#PrepareOpts(source, prompt)

  call vista#finder#RunFZFOrSkim(function('s:ApplyRun'))
endfunction

function! s:project_sink(line) abort
  let parts = split(a:line)
  let lnum = split(parts[1], ':')[0]
  let relpath = parts[3]
  execute 'edit' relpath
  call vista#util#Cursor(lnum, 1)
  normal! zz
endfunction

function! s:ProjectRun(...) abort
  let source = s:aligner.project_ctags()
  let prompt = (get(s:, 'using_alternative', v:false) ? '*' : '').s:cur_executive.'> '
  let s:opts = {
          \ 'source': source,
          \ 'sink': function('s:project_sink'),
          \ 'options': ['--prompt', prompt] + get(g:, 'vista_fzf_opt', []),
          \ }

  call s:ApplyRun()
  if has('nvim')
    call vista#finder#fzf#Highlight()
  endif
endfunction

function! vista#finder#fzf#Highlight() abort
  let groups = ['Character', 'Float', 'Identifier', 'Statement', 'Label', 'Boolean', 'Delimiter', 'Constant', 'String', 'Operator', 'PreCondit', 'Include', 'Conditional', 'PreProc', 'TypeDef',]
  let len_groups = len(groups)

  let icons = values(g:vista#renderer#icons)

  let idx = 0
  let hi_idx = 0

  let icon_groups = []
  for icon in icons
    let cur_group = 'FZFVistaIcon'.idx
    call add(icon_groups, cur_group)
    execute 'syntax match' cur_group '/'.icon.'/' 'contained'
    execute 'hi default link' cur_group groups[hi_idx]
    let hi_idx += 1
    let hi_idx = hi_idx % len_groups
    let idx += 1
  endfor

  execute 'syntax match FZFVistaTag    /\s*.*\(:\d\+\s\)\@=/' 'contains=FZFVistaIcon,'.join(icon_groups, ',')
  execute 'syntax match FZFVistaNumber /^.*\(\s\s\[\)\@=/' 'contains=FZFVistaTag,FZFVistaIcon,'.join(icon_groups, ',')
  syntax match FZFVistaScope  /^.*\]\s\s/ contains=FZFVistaNumber,FZFVistaBracket
  syntax match FZFVista /^[^│┌└]*/ contains=FZFVistaBracket,FZFVistaTag,FZFVistaNumber,FZFVistaScope
  syntax match FZFVistaBracket /\s\s\[\|\]\s\s/ contained

  hi default link FZFVistaBracket  SpecialKey
  hi default link FZFVistaNumber   Number
  hi default link FZFVistaTag      Tag
  hi default link FZFVistaScope    Function
  hi default link FZFVista         Type
endfunction

" Optional argument: executive, coc or ctags
" Ctags is the default.
function! vista#finder#fzf#Run(...) abort
  if g:vista_close_on_fzf_select
    call vista#sidebar#Close()
  endif
  if !exists('*fzf#run')
    return vista#error#Need('https://github.com/junegunn/fzf')
  endif

  let [s:data, s:cur_executive, s:using_alternative] = call('vista#finder#GetSymbols', a:000)

  if s:data is# v:null
    return vista#util#Warning('Empty data for fzf finder')
  endif

  call s:Run()
endfunction

" TODO workspace symbols
function! vista#finder#fzf#ProjectRun(executive) abort
  if a:executive !=? 'ctags'
    return vista#error#('Only ctags supports Vista finder!')
  endif

  let s:data = vista#executive#{a:executive}#ProjectRun()
  let s:cur_executive = a:executive

  if empty(s:data)
    return vista#util#Warning('Empty data for finder')
  endif

  call s:ProjectRun()
endfunction
./autoload/vista/finder/skim.vim	[[[1
49
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:finder = fnamemodify(expand('<sfile>'), ':t:r')

" Actually call skim#run()
function! s:ApplyRun() abort
  try
    " skim_colors may interfere custom syntax.
    " Unlet and restore it later.
    if exists('g:skim_colors')
      let old_skim_colors = g:skim_colors
      unlet g:skim_colors
    endif

    call skim#run(skim#wrap(s:opts))
  finally
    if exists('l:old_skim_colors')
      let g:skim_colors = old_skim_colors
    endif
  endtry
endfunction

function! s:Run(...) abort
  let source = vista#finder#PrepareSource(s:data)
  let using_alternative = get(s:, 'using_alternative', v:false) ? '*' : ''
  let prompt = using_alternative.s:finder.':'.s:cur_executive.'> '

  let s:opts = vista#finder#PrepareOpts(source, prompt)

  call vista#finder#RunFZFOrSkim(function('s:ApplyRun'))
endfunction

" Optional argument: executive, coc or ctags
" Ctags is the default.
function! vista#finder#skim#Run(...) abort
  if !exists('*skim#run')
    return vista#error#Need('https://github.com/lotabout/skim')
  endif

  let [s:data, s:cur_executive, s:using_alternative] = call('vista#finder#GetSymbols', a:000)

  if s:data is# v:null
    return vista#util#Warning('Empty data for skim finder')
  endif

  call s:Run()
endfunction
./autoload/vista/finder.vim	[[[1
228
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:is_nvim = has('nvim')

" Could use the cached data?
function! s:IsUsable(cache, fpath) abort
  return !empty(a:cache)
        \ && has_key(a:cache, a:fpath)
        \ && getftime(a:fpath) == a:cache.ftime
        \ && !getbufvar(a:cache.bufnr, '&mod')
endfunction

" Try other alternative executives when the data given by the specified one is empty.
" Return v:true if some alternative brings us some data, or else v:false.
function! s:TryAlternatives(tried, fpath) abort
  " TODO when more executives added allow configuring this list
  let executives = get(g:, 'vista_finder_alternative_executives', g:vista#executives)

  if empty(executives)
    return v:false
  endif

  let alternatives = filter(copy(executives), 'v:val != a:tried')

  for alternative in alternatives
    " Do not try nvim_lsp until the related LSP service is registed for nvim_lsp
    " otherwise it may cause the neovim hangs.
    if s:is_nvim && alternative ==# 'nvim_lsp'
      continue
    endif
    let s:data = vista#executive#{alternative}#Run(a:fpath)
    if !empty(s:data)
      let s:cur_executive = alternative
      let s:using_alternative = v:true
      return v:true
    endif
  endfor

  return v:false
endfunction

function! vista#finder#GetSymbols(...) abort
  let executive = a:0 > 0 ? a:1 : g:vista_default_executive

  " 'toc' is a special executive supported by extension, we should use ctags
  " instead for the finder case, ref #255.
  if executive ==# 'toc'
    let executive = 'ctags'
  endif

  if index(g:vista#executives, executive) == -1
    call vista#error#InvalidExecutive(executive)
    return
  endif

  let should_skip = vista#ShouldSkip()
  if should_skip
    let fpath = g:vista.source.fpath
  else
    let fpath = expand('%:p')
  endif

  let cache = vista#executive#{executive}#Cache()
  " FIXME s:IsUsable is actually useless as provider gives s:data.
  if type(cache) == v:t_dict && s:IsUsable(cache, fpath)
    let s:data = cache[fpath]
  else
    if !should_skip
      let [bufnr, winnr, fname] = [bufnr('%'), winnr(), expand('%')]
      call vista#source#Update(bufnr, winnr, fname, fpath)
    endif
    let g:vista.skip_set_provider = v:true
    " In this case, we normally want to run synchronously IMO.
    let s:data = vista#executive#{executive}#Run(fpath)
  endif

  let s:cur_executive = executive
  let s:using_alternative = v:false

  if empty(s:data) && !s:TryAlternatives(executive, fpath)
    return [v:null, s:cur_executive, s:using_alternative]
  endif

  return [s:data, s:cur_executive, s:using_alternative]
endfunction

function! s:GroupByKindForLSPData(lsp_items) abort
  let s:grouped = {}

  for item in a:lsp_items
    let s:max_len_kind = max([s:max_len_kind, strwidth(item.kind)])

    let lnum_and_text = printf('%s:%s', item.text, item.lnum)
    let s:max_len_lnum_and_text = max([s:max_len_lnum_and_text, strwidth(lnum_and_text)])

    if has_key(s:grouped, item.kind)
      call add(s:grouped[item.kind], item)
    else
      let s:grouped[item.kind] = [item]
    endif
  endfor
endfunction

" Find the maximum length of each column of items to be displayed
function! s:FindColumnBoundary(grouped_data) abort
  for [kind, vals] in items(a:grouped_data)
    let s:max_len_kind = max([s:max_len_kind, strwidth(kind)])

    let sub_max = max(map(copy(vals), 'strwidth(printf(''%s:%s'', v:val.text, v:val.lnum))'))
    let s:max_len_lnum_and_text = max([s:max_len_lnum_and_text, sub_max])
  endfor
endfunction

function! s:IntoRow(icon, kind, item) abort
  let line = g:vista.source.line_trimmed(a:item.lnum)
  let lnum_and_text = printf('%s:%s', a:item.text, a:item.lnum)
  let row = printf('%s%s  [%s]%s  %s',
        \ lnum_and_text, repeat(' ', s:max_len_lnum_and_text- strwidth(lnum_and_text)),
        \ a:kind, repeat(' ', s:max_len_kind - strwidth(a:kind)),
        \ line)

  if a:icon !=# ''
    let row = printf('%s %s', a:icon, row)
  endif

  return row
endfunction

function! s:RenderGroupedData(grouped_data) abort
  let source = []
  for [kind, vals] in items(a:grouped_data)
    let icon = vista#renderer#IconFor(kind)
    let rows = []
    for val in vals
      call add(rows, s:IntoRow(icon, kind, val))
    endfor
    call extend(source, rows)
  endfor
  return source
endfunction

" Prepare source for fzf, skim finder
function! vista#finder#PrepareSource(raw_items) abort
  let [s:max_len_kind, s:max_len_lnum_and_text] = [-1, -1]

  if type(a:raw_items) == v:t_list
    call s:GroupByKindForLSPData(a:raw_items)
    return s:RenderGroupedData(s:grouped)
  else
    call s:FindColumnBoundary(a:raw_items)
    return s:RenderGroupedData(a:raw_items)
  endif
endfunction

" Prepare opts for fzf#run(fzf#wrap(opts))
function! vista#finder#PrepareOpts(source, prompt) abort
  let opts = {
          \ 'source': a:source,
          \ 'sink': function('vista#finder#fzf#sink'),
          \ 'options': ['--prompt', a:prompt, '--nth', '..-2', '--delimiter', ':'] + get(g:, 'vista_fzf_opt', []),
          \ }

  if len(g:vista_fzf_preview) > 0
    let idx = 0
    let opt_preview_window_processed = v:false
    while idx < len(g:vista_fzf_preview)
      if g:vista_fzf_preview[idx] =~# '^\(left\|up\|right\|down\)'
        let g:vista_fzf_preview[idx] = g:vista_fzf_preview[idx] . ':+{-1}-5'
        let opt_preview_window_processed = v:true
      endif
      let idx = idx + 1
    endwhile
    if !opt_preview_window_processed
      call extend(g:vista_fzf_preview, ['right:+{-1}-5'])
    endif
    let preview_opts = call('fzf#vim#with_preview', g:vista_fzf_preview).options

    if has('win32')
      " keeping old code around since we are not sure if / how preview works on windows
      let preview_opts[-1] = preview_opts[-1][0:-3] . g:vista.source.fpath . (g:vista#renderer#enable_icon ? ':{2}' : ':{1}')
    else
      let object_name_index = g:vista#renderer#enable_icon ? '3' : '2'
      let extract_line_number = printf(':$(echo {%s})', object_name_index)
      let preview_opts[-1] = preview_opts[-1][0:-3] . fnameescape(g:vista.source.fpath) . extract_line_number
    endif

    call extend(opts.options, preview_opts)
  endif

  return opts
endfunction

" Actually call fzf#run() with a highlighter given the opts
function! vista#finder#RunFZFOrSkim(apply_run) abort
  echo "\r"

  call a:apply_run()

  " Only add highlights when using nvim, since vim has an issue with the highlight.
  " Ref #139
  if has('nvim')
    call vista#finder#fzf#Highlight()

    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim
    " Vim Highlight does not work at times
    "
    "  &modifiable is to avoid error in MacVim - E948: Job still running (add ! to end the job)
    " if !has('nvim') && &modifiable
      " edit
    " endif
  endif
endfunction

function! vista#finder#Dispatch(bang, finder, executive) abort
  let finder = empty(a:finder) ? 'fzf' : a:finder
  if empty(a:executive)
    let executive = vista#GetExplicitExecutiveOrDefault()
  else
    let executive = a:executive
  endif
  if a:bang
    call vista#finder#{finder}#ProjectRun(executive)
  else
    call vista#finder#{finder}#Run(executive)
  endif
endfunction
./autoload/vista/floating.vim	[[[1
228
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:floating_timer = -1
let s:last_lnum = -1

let s:floating_delay = get(g:, 'vista_floating_delay', 100)

" Vista sidebar window usually sits at the right side.
" TODO improve me!
function! s:CalculatePosition(lines) abort
  let lines = a:lines
  let pos = s:floating_opened_pos

  let width = max(map(copy(a:lines), 'strdisplaywidth(v:val)'))

  let width = max([width, 40])
  let width = min([width, float2nr(&columns * 0.6) ])
  let height = len(lines)

  " Calculate anchor
  " North first, fallback to South if there is no enough space.
  let bottom_line = line('w0') + winheight(0) - 1
  if pos[1] + height <= bottom_line
    let vert = 'N'
    let row = 1
  else
    let vert = 'S'
    let row = 0
  endif

  " TODO should be tweaked accroding to the position of vista sidebar
  let hors = ['E', 'W']

  let [_, _, cur_col, _, _] = getcurpos()

  " West first, fallback into East if there is no enough space.
  if pos[2] + width <= &columns
    let hor = hors[0]
    let col = 0
  else
    let hor = hors[1]
    let col = 1
  endif

  return [width, height, vert.hor, row-1, col+4-cur_col]
endfunction

function! s:ApplyClose() abort
  if !exists('g:vista')
    return
  endif

  if exists('#VistaFloatingWin')
    autocmd! VistaFloatingWin
  endif

  if exists('s:floating_win_id')
    let winnr = win_id2win(s:floating_win_id)

    if winnr > 0
      execute winnr.'wincmd c'
    endif
  endif

  let g:vista.floating_visible = v:false
endfunction

function! s:CloseOnCursorMoved() abort
  " To avoid closing floating window immediately, check the cursor
  " was really moved.
  if getpos('.') == s:floating_opened_pos
    return
  endif

  call s:ApplyClose()
endfunction

function! s:CloseOnWinEnter() abort
  let winnr = win_id2win(s:floating_win_id)

  " Floating window has been closed already.
  if winnr == 0
    autocmd! VistaFloatingWin
    return
  endif

  " We are just in the floating window. Do not close it
  if winnr == winnr()
    return
  endif

  autocmd! VistaFloatingWin
  execute winnr.'wincmd c'

  let g:vista.floating_visible = v:false
endfunction

function! s:HighlightTagInFloatinWin() abort
  if !nvim_win_is_valid(s:floating_win_id)
    return
  endif

  if exists('s:floating_lnum')
    let target_line = getbufline(s:floating_bufnr, s:floating_lnum)
    if empty(target_line)
      return
    endif
    let target_line = target_line[0]
    try
      let [_, start, end] = matchstrpos(target_line, '\C'.s:cur_tag)
      if start != -1
        " {line} is zero-based.
        call nvim_buf_add_highlight(s:floating_bufnr, -1, 'Search', s:floating_lnum-1, start, end)
      endif
    catch /^Vim\%((\a\+)\)\=:E869/
      " If we meet the E869 error, just highlight the whole line.
      call nvim_buf_add_highlight(s:floating_bufnr, -1, 'Search', s:floating_lnum-1, 0, -1)
    endtry

    unlet s:floating_lnum
  endif
endfunction

function! s:Display(msg, win_id) abort
  if a:win_id !=# win_getid()
    return
  endif

  if !exists('s:floating_bufnr') || !bufexists(s:floating_bufnr)
    let s:floating_bufnr = nvim_create_buf(v:false, v:false)
  endif

  let s:floating_opened_pos = getpos('.')
  let [width, height, anchor, row, col] = s:CalculatePosition(a:msg)

  let border = g:vista_floating_border

  " silent is neccessary for the both strategy!
  silent let s:floating_win_id = nvim_open_win(
        \ s:floating_bufnr, v:true, {
        \   'width': width,
        \   'height': height,
        \   'relative': 'cursor',
        \   'anchor': anchor,
        \   'row': row + 0.4,
        \   'col': col - 5,
        \   'focusable': v:false,
        \   'border': border,
        \ })

  call nvim_buf_set_lines(s:floating_bufnr, 0, -1, 0, a:msg)

  call s:HighlightTagInFloatinWin()

  let &l:filetype = getbufvar(g:vista.source.bufnr, '&ft')
  setlocal
        \ winhl=Normal:VistaFloat
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
        \ nofoldenable
        \ nospell
        \ wrap

  wincmd p

  augroup VistaFloatingWin
    autocmd!
    autocmd CursorMoved <buffer> call s:CloseOnCursorMoved()
    autocmd BufEnter,WinEnter,WinLeave  * call s:CloseOnWinEnter()
  augroup END

  let g:vista.floating_visible = v:true
endfunction

function! vista#floating#Close() abort
  call s:ApplyClose()
endfunction

" See if it's identical to the last lnum to avoid blink. Ref #55
"
" No need to display again when it's already visible.
function! s:ShouldSkipDisplay(lnum) abort
  silent! call timer_stop(s:floating_timer)

  if a:lnum == s:last_lnum
        \ && get(g:vista, 'floating_visible', v:false)
    return 1
  else
    let s:last_lnum = a:lnum
    return 0
  endif
endfunction

function! s:DisplayWithDelay(lines) abort
  let win_id = win_getid()
  let s:floating_timer = timer_start(s:floating_delay, { -> s:Display(a:lines, win_id)})
endfunction

" Display in floating_win given the lnum of source buffer and current tag.
function! vista#floating#DisplayAt(lnum, tag) abort
  if s:ShouldSkipDisplay(a:lnum)
    return
  endif

  " We save the tag info so that it could be used later for adding the tag highlight.
  "
  " It's problematic when calculating the highlight position here, leading to
  " the displacement of current tag highlighting position.
  let s:cur_tag = a:tag

  let [lines, s:floating_lnum] = vista#preview#GetLines(a:lnum)
  call s:DisplayWithDelay(lines)
endfunction

" Display in floating_win given the lnum of source buffer and raw lines.
function! vista#floating#DisplayRawAt(lnum, lines) abort
  if s:ShouldSkipDisplay(a:lnum)
    return
  endif

  call s:DisplayWithDelay(a:lines)
endfunction
./autoload/vista/fold.vim	[[[1
35
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" Treat the number of heading whitespaces as indent level
function! s:HeadingWhitespaces(line) abort
  return strlen(matchstr(a:line,'\v^\s+'))
endfunction

function! vista#fold#Expr() abort
  if getline(v:lnum) =~# '^$'
    return 0
  endif

  let cur_indent = s:HeadingWhitespaces(getline(v:lnum))
  let next_indent = s:HeadingWhitespaces(getline(v:lnum+1))

  if cur_indent < next_indent
    return '>'.next_indent
  else
    return cur_indent
  endif
endfunction

function! vista#fold#Text() abort
  let line = getline(v:foldstart)

  " Foldtext ignores tabstop and shows tabs as one space,
  " so convert tabs to 'tabstop' spaces, then text lines up.
  let spaces = repeat(' ', &tabstop)
  let line = substitute(line, '\t', spaces, 'g')
  let line = substitute(line, g:vista_fold_toggle_icons[0], g:vista_fold_toggle_icons[1], '')

  return line
endfunction
./autoload/vista/ftplugin.vim	[[[1
64
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" If we use ftplugin/vista.vim, ftplugin/vista_kind.vim, etc, everytime we'll
" need this:
"
" No usual did_ftplugin check here
"
" So we could just use a function to set the buffer local settings.

function! vista#ftplugin#Set() abort
  setlocal
    \ nonumber
    \ norelativenumber
    \ nopaste
    \ nomodeline
    \ noswapfile
    \ nocursorline
    \ nocursorcolumn
    \ colorcolumn=
    \ nobuflisted
    \ buftype=nofile
    \ bufhidden=hide
    \ nomodifiable
    \ signcolumn=no
    \ textwidth=0
    \ nolist
    \ winfixwidth
    \ winfixheight
    \ nospell
    \ nofoldenable
    \ foldcolumn=0
    \ nowrap

  setlocal foldmethod=expr
  setlocal foldexpr=vista#fold#Expr()
  setlocal foldtext=vista#fold#Text()

  if !vista#statusline#ShouldDisable()
    let &l:statusline = vista#statusline#()
  endif

  if !g:vista_no_mappings
    nnoremap <buffer> <silent> q    :close<CR>
    nnoremap <buffer> <silent> <CR> :<c-u>call vista#cursor#FoldOrJump()<CR>
    nnoremap <buffer> <silent> <2-LeftMouse>
                                  \ :<c-u>call vista#cursor#FoldOrJump()<CR>
    nnoremap <buffer> <silent> s    :<c-u>call vista#Sort()<CR>
    nnoremap <buffer> <silent> p    :<c-u>call vista#cursor#TogglePreview()<CR>
  endif

  augroup VistaCursor
    autocmd!
    if g:vista_echo_cursor
      autocmd CursorMoved <buffer> call vista#cursor#ShowDetailWithDelay()
    endif
    autocmd BufLeave <buffer> call vista#floating#Close()
  augroup END

  if !exists('#VistaMOF')
    call vista#autocmd#InitMOF()
  endif
endfunction
./autoload/vista/highlight.vim	[[[1
45
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" Highlight the line given the line number and ensure it's visible if required.
"
" lnum - current line number in vista window
" ensure_visible - kepp this line visible
" optional: tag - accurate tag
function! vista#highlight#Add(lnum, ensure_visible, tag) abort
  if exists('w:vista_highlight_id')
    try
      call matchdelete(w:vista_highlight_id)
    catch /E803/
      " ignore E803 error: ID not found
    endtry
    unlet w:vista_highlight_id
  endif

  if get(g:, 'vista_highlight_whole_line', 0)
    let hi_pos = a:lnum
  else
    let cur_line = getline(a:lnum)
    " Current line may contains +,-,~, use `\S` is incorrect to find the right
    " starting postion.
    let [_, start, _] = matchstrpos(cur_line, '[a-zA-Z0-9_,#:]')

    " If we know the tag, then what we have to do is to use the length of tag
    " based on the starting point.
    "
    " start is 0-based, while the column used in matchstrpos is 1-based.
    if !empty(a:tag)
      let hi_pos = [a:lnum, start+1, strlen(a:tag)]
    else
      let [_, end, _] = matchstrpos(cur_line, ':\d\+$')
      let hi_pos = [a:lnum, start+1, end - start]
    endif
  endif

  let w:vista_highlight_id = matchaddpos('IncSearch', [hi_pos])

  if a:ensure_visible
    execute 'normal!' a:lnum.'z.'
  endif
endfunction
./autoload/vista/init.vim	[[[1
87
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! vista#init#Api() abort
  let g:vista = {}
  let g:vista.tmps = []

  " =========================================
  " Api for manipulating the vista buffer.
  " =========================================
  function! g:vista.winnr() abort
    return bufwinnr('__vista__')
  endfunction

  function! g:vista.winid() abort
    return bufwinid('__vista__')
  endfunction

  " Get original tagline given the lnum in vista sidebar
  "
  " Mind the offset
  function! g:vista.get_tagline_under_cursor() abort
    return get(g:vista.vlnum_cache, line('.') - g:vista#renderer#default#vlnum_offset, '')
  endfunction

  " =========================================
  " Api for manipulating the source buffer.
  " =========================================
  let source_handle = {}

  function! source_handle.get_winnr() abort
    return bufwinnr(self.bufnr)
  endfunction

  function! source_handle.get_winid() abort
    if has_key(self, 'winid')
      return self.winid
    else
      " A buffer can exist in two windows at the same time, this could be inaccurate.
      return bufwinid(self.bufnr)
    endif
  endfunction

  function! source_handle.filetype() abort
    return getbufvar(self.bufnr, '&filetype')
  endfunction

  function! source_handle.lines() abort
    return getbufline(self.bufnr, 1, '$')
  endfunction

  function! source_handle.line(lnum) abort
    let bufline = getbufline(self.bufnr, a:lnum)
    return empty(bufline) ? '' : bufline[0]
  endfunction

  function! source_handle.line_trimmed(lnum) abort
    let bufline = getbufline(self.bufnr, a:lnum)
    return empty(bufline) ? '' : vista#util#Trim(bufline[0])
  endfunction

  function! source_handle.extension() abort
    " Try the extension first, and then the filetype, for ctags relys on the extension name.
    let e = fnamemodify(self.fpath, ':e')
    return empty(e) ? getbufvar(self.bufnr, '&ft') : e
  endfunction

  function! source_handle.scope_seperator() abort
    let filetype = self.filetype()
    try
      let type = g:vista#types#uctags#{filetype}#
    catch /^Vim\%((\a\+)\)\=:E121/
      let type = {}
    endtry

    " FIXME use a default value maybe inappropriate.
    return get(type, 'sro', '.')
  endfunction

  let g:vista.source = source_handle

  " Skip an update once with this flag
  let g:vista.skip_once_flag = v:false

  hi default link VistaFloat Pmenu
endfunction
./autoload/vista/jump.vim	[[[1
96
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:EscapeForVimRegexp(str) abort
  return escape(a:str, '^$.*?/\[]')
endfunction

" Jump to the source line containing the given tag
function! vista#jump#TagLine(tag) abort
  let cur_line = split(getline('.'), ':')

  " Skip if the current line or the target line is empty
  if empty(cur_line)
    return
  endif

  let lnum = cur_line[-1]
  let line = getbufline(g:vista.source.bufnr, lnum)

  if empty(line)
    return
  endif

  try
    let [_, start, _] = matchstrpos(line[0], s:EscapeForVimRegexp(a:tag))
  catch /^Vim\%((\a\+)\)\=:E869/
    let start  = -1
  endtry

  call vista#source#GotoWin()
  " Move cursor to the column of tag located, otherwise the first column
  call vista#util#Cursor(lnum, start > -1 ? start+1 : 1)

  if g:vista_enable_centering_jump
    normal! zz
  endif

  call call('vista#util#Blink', g:vista_blink)

  call vista#win#CloseFloating()

  if g:vista_close_on_jump
    call vista#sidebar#Close()
  endif
endfunction

function! s:NextTopLevelLnum() abort
  let cur_lnum = line('.')
  let ending = line('$')

  while cur_lnum < ending
    let cur_lnum += 1
    if indent(cur_lnum) == 0 && !empty(getline(cur_lnum))
      return cur_lnum
    endif
  endwhile

  return 0
endfunction

function! s:PrevTopLevelLnum() abort
  let cur_lnum = line('.')

  " The first two lines contain no tags.
  while cur_lnum > 2
    let cur_lnum -= 1
    if indent(cur_lnum) == 0 && !empty(getline(cur_lnum))
      return cur_lnum
    endif
  endwhile

  if cur_lnum == 3
    return 3
  endif

  return 0
endfunction

function! s:ApplyJump(lnum) abort
  if a:lnum > 0
    call vista#util#Cursor(a:lnum, 1)
    normal! zz
    call call('vista#util#Blink', g:vista_top_level_blink)
  endif
endfunction

function! vista#jump#NextTopLevel() abort
  call vista#win#CloseFloating()
  call s:ApplyJump(s:NextTopLevelLnum())
endfunction

function! vista#jump#PrevTopLevel() abort
  call vista#win#CloseFloating()
  call s:ApplyJump(s:PrevTopLevelLnum())
endfunction
./autoload/vista/parser/ctags.vim	[[[1
216
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:LoadData(container, line) abort
  let line = a:line

  let kind = line.kind

  call vista#util#TryAdd(g:vista.raw_by_kind, kind, line)

  call add(g:vista.raw, line)

  if has_key(line, 'scope')
    call add(g:vista.with_scope, line)
  else
    call add(g:vista.without_scope, line)
  endif

  let picked = {'lnum': line.line, 'text': get(line, 'name', '') }

  if kind =~# '^f' || kind =~# '^m'
    if has_key(line, 'signature')
      let picked.signature = line.signature
    endif
    call add(g:vista.functions, picked)
  endif

  if index(g:vista.kinds, kind) == -1
    call add(g:vista.kinds, kind)
  endif

  call vista#util#TryAdd(a:container, kind, picked)
endfunction

" Parse the output from ctags linewise and feed them into the container
" The parsed result should be compatible with the LSP output.
"
" Currently we only use these fields:
"
" {
"   'lnum': 12,
"   'col': 8,
"   'kind': 'Function',
"   'text': 'testnet_genesis',
" }

function! s:ShortToLong(short) abort
  let ft = getbufvar(g:vista.source.bufnr, '&filetype')

  try

    let types = g:vista#types#uctags#{ft}#
    if has_key(types.kinds, a:short)
      return types.kinds[a:short]['long']
    endif

  catch /^Vim\%((\a\+)\)\=:E121/
  endtry

  return a:short
endfunction

function! s:ParseTagfield(tagfields) abort
  let fields = {}

  if stridx(a:tagfields[0], ':') > -1
    let colon = stridx(a:tagfields[0], ':')
    let value = a:tagfields[0][colon+1:]
    let fields.kind = value
  else
    let kind = s:ShortToLong(a:tagfields[0])
    let fields.kind = kind
    if index(g:vista.kinds, kind) == -1
      call add(g:vista.kinds, kind)
    endif
  endif

  if len(a:tagfields) > 1
    for tagfield in a:tagfields[1:]
      let colon = stridx(tagfield, ':')
      let name = tagfield[0:colon-1]
      let value = tagfield[colon+1:]
      let fields[name] = value
    endfor
  endif

  return fields
endfunction

" {tagname}<Tab>{tagfile}<Tab>{tagaddress}[;"<Tab>{tagfield}..]
" {tagname}<Tab>{tagfile}<Tab>{tagaddress};"<Tab>{kind}<Tab>{scope}
" ['vista#executive#ctags#Execute', '/Users/xlc/.vim/plugged/vista.vim/autoload/vista/executive/ctags.vim', '84;"', 'function']
function! vista#parser#ctags#FromExtendedRaw(line, container) abort
  if a:line =~# '^!_TAG'
    return
  endif
  " Prevent bugs when a:line is all whitespace or doesn't contain any tabs
  " (can't be parsed).
  if a:line =~# '^\s*$' || stridx(a:line, "\t") == -1
    " Useful for debugging
    " echom "Vista.vim: Error parsing ctags output: '" . a:line . "'"
    return
  endif

  let items = split(a:line, '\t')

  let line = {}

  let line.name = items[0]
  let line.tagfile = items[1]

  " tagaddress itself possibly contains <Tab>, so we have to restore the
  " original content and then split by `;"` to get the tagaddress and other
  " fields.
  " tagaddress may also contains `;"`, so we join all the splits except the
  " last one as the tagaddress and keep the last split as the other fields.
  let rejoined = join(items[2:], "\t")
  let resplitted = split(rejoined, ';"')
  let splits = len(resplitted)
  let line.tagaddress = join(resplitted[:splits-2], ';"')

  let fields = split(resplitted[splits-1], '\t')
  let tagfields = s:ParseTagfield(fields)

  call extend(line, tagfields)

  if vista#ShouldIgnore(line.kind)
    return
  endif

  call s:LoadData(a:container, line)

endfunction

function! vista#parser#ctags#FromJSON(line, container) abort
  if a:line =~# '^ctags'
    return
  endif

  try
    let line = json_decode(a:line)
  catch
    call vista#error#('Fail to decode from JSON: '.a:line.', error: '.v:exception)
    return
  endtry

  if vista#ShouldIgnore(line.kind)
    return
  endif

  call s:LoadData(a:container, line)

endfunction

" ctags -R -x --_xformat='TAGNAME:%N ++++ KIND:%K ++++ LINE:%n ++++ INPUT-FILE:%F ++++ PATTERN:%P'"
"
function! vista#parser#ctags#RecursiveFromXformat(line, container) abort

  if a:line =~# '^ctags: Warning:'
    return
  endif

  let items = split(a:line, '++++')

  if len(items) != 5
    call vista#error#('Splitted items is not expected: '.string(items))
    return
  endif

  call map(items, 'vista#util#Trim(v:val)')

  " TAGNAME:
  let tagname = items[0][8:]
  " KIND:
  let kind = items[1][5:]
  if vista#ShouldIgnore(kind)
    return
  endif
  " LINE:
  let lnum = items[2][5:]
  " INPUT-FILE:
  let relpath = items[3][11:]
  " PATTERN:
  let pattern = items[4][8:]

  let picked = {'lnum': lnum, 'text': tagname, 'tagfile': relpath, 'taginfo': pattern[2:-3]}

  call vista#util#TryAdd(a:container, kind, picked)
endfunction

function! vista#parser#ctags#RecursiveFromJSON(line, container) abort
  " {
  "  "_type":"tag",
  "  "name":"vista#source#Update",
  "  "path":"autoload/vista/source.vim",
  "  "pattern":"/^function! vista#source#Update(bufnr, winnr, ...) abort$/",
  "  "line":29,
  "  "kind":"function"
  " }
  if a:line =~# '^ctags: Warning: ignoring null tag'
    return
  endif

  let line = json_decode(a:line)

  let kind = line.kind

  if vista#ShouldIgnore(kind)
    return
  endif

  let picked = {'lnum': line.line, 'text': line.name, 'tagfile': line.path, 'taginfo': line.pattern[2:-3]}

  call vista#util#TryAdd(a:container, kind, picked)
endfunction
./autoload/vista/parser/lsp.vim	[[[1
120
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" https://microsoft.github.io/language-server-protocol/specification#textDocument_documentSymbol
" This should be updated periodically according the latest LSP specification.
let s:symbol_kind = {
    \ '1': 'File',
    \ '2': 'Module',
    \ '3': 'Namespace',
    \ '4': 'Package',
    \ '5': 'Class',
    \ '6': 'Method',
    \ '7': 'Property',
    \ '8': 'Field',
    \ '9': 'Constructor',
    \ '10': 'Enum',
    \ '11': 'Interface',
    \ '12': 'Function',
    \ '13': 'Variable',
    \ '14': 'Constant',
    \ '15': 'String',
    \ '16': 'Number',
    \ '17': 'Boolean',
    \ '18': 'Array',
    \ '19': 'Object',
    \ '20': 'Key',
    \ '21': 'Null',
    \ '22': 'EnumMember',
    \ '23': 'Struct',
    \ '24': 'Event',
    \ '25': 'Operator',
    \ '26': 'TypeParameter',
    \ }

function! s:Kind2Symbol(kind) abort
  return has_key(s:symbol_kind, a:kind) ? s:symbol_kind[a:kind] : 'Unknown kind '.a:kind
endfunction

function! s:IsFileUri(uri) abort
  return stridx(a:uri, 'file:///') == 0
endfunction

" The kind field in the result is a number instead of a readable text, we
" should transform the number to the symbol text first.
function! vista#parser#lsp#KindToSymbol(line, container) abort
  let line = a:line
  " SymbolInformation interface
  if has_key(line, 'location')
    let location = line.location
    if s:IsFileUri(location.uri)
      let lnum = location.range.start.line + 1
      let col = location.range.start.character + 1
      call add(a:container, {
         \ 'lnum': lnum,
         \ 'col': col,
         \ 'kind': s:Kind2Symbol(line.kind),
         \ 'text': line.name,
         \ })
    endif
  " DocumentSymbol class
  elseif has_key(line, 'range')
    let range = line.range
    let lnum = range.start.line + 1
    let col = range.start.character + 1
    call add(a:container, {
          \ 'lnum': lnum,
          \ 'col': col,
          \ 'kind': s:Kind2Symbol(line.kind),
          \ 'text': line.name,
          \ })
    if has_key(line, 'children')
      for child in line.children
        call vista#parser#lsp#KindToSymbol(child, a:container)
      endfor
    endif
  endif
endfunction

function! vista#parser#lsp#CocSymbols(symbol, container) abort
  if vista#ShouldIgnore(a:symbol.kind)
    return
  endif

  let raw = { 'line': a:symbol.lnum, 'kind': a:symbol.kind, 'name': a:symbol.text }
  call add(g:vista.raw, raw)

  if a:symbol.kind ==? 'Method' || a:symbol.kind ==? 'Function'
    call add(g:vista.functions, a:symbol)
  endif

  call add(a:container, {
        \ 'lnum': a:symbol.lnum,
        \ 'col': a:symbol.col,
        \ 'text': a:symbol.text,
        \ 'kind': a:symbol.kind,
        \ 'level': a:symbol.level
        \ })
endfunction

" https://microsoft.github.io/language-server-protocol/specification#textDocument_documentSymbol
function! vista#parser#lsp#ExtractSymbol(symbol, container) abort
  let symbol = a:symbol

  if vista#ShouldIgnore(symbol.kind)
    return
  endif

  if symbol.kind ==? 'Method' || symbol.kind ==? 'Function'
    call add(g:vista.functions, symbol)
  endif

  let picked = {'lnum': symbol.lnum, 'col': symbol.col, 'text': symbol.text}

  if has_key(a:container, symbol.kind)
    call add(a:container[symbol.kind], picked)
  else
    let a:container[symbol.kind] = [picked]
  endif
endfunction
./autoload/vista/popup.vim	[[[1
133
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:last_lnum = -1
let s:popup_timer = -1
let s:popup_delay = get(g:, 'vista_floating_delay', 100)

function! s:ClosePopup() abort
  if exists('s:popup_winid')
    call popup_close(s:popup_winid)
    unlet s:popup_winid
    autocmd! VistaPopup
  endif
  let g:vista.popup_visible = v:false
endfunction

call prop_type_delete('VistaMatch')
call prop_type_add('VistaMatch', { 'highlight': 'Search' })

function! s:HiTag() abort
  call prop_add(s:popup_lnum, s:popup_start+1, { 'length': s:popup_end - s:popup_start, 'type': 'VistaMatch' })
endfunction

function! s:HiTagLine() abort
  if exists('w:vista_hi_cur_tag_id')
    call matchdelete(w:vista_hi_cur_tag_id)
  endif
  let w:vista_hi_cur_tag_id = matchaddpos('Search', [s:popup_lnum])
endfunction

function! s:OpenPopup(lines) abort
  if g:vista_sidebar_position =~# 'right'
    let max_length = max(map(copy(a:lines), 'strlen(v:val)')) + 2
    let pos_opts = {
          \ 'pos': 'botleft',
          \ 'line': 'cursor-2',
          \ 'col': 'cursor-'.max_length,
          \ 'moved': 'WORD',
          \ }
  else
    let winwidth = winwidth(0)
    let cur_length = strlen(getline('.'))
    let offset = min([cur_length + 4, winwidth])
    let col = 'cursor+'.offset
    let pos_opts = {
          \ 'pos': 'botleft',
          \ 'line': 'cursor-2',
          \ 'col': col,
          \ 'moved': 'WORD',
          \ }
  endif

  if !exists('s:popup_winid')
    let s:popup_winid = popup_create(a:lines, pos_opts)
    let s:popup_bufnr = winbufnr(s:popup_winid)

    let filetype = getbufvar(g:vista.source.bufnr, '&ft')
    call win_execute(s:popup_winid, 'setlocal filetype='.filetype.' nofoldenable nospell')
  else
    silent call deletebufline(s:popup_bufnr, 1, '$')
    call setbufline(s:popup_bufnr, 1, a:lines)
    call popup_show(s:popup_winid)
    call popup_move(s:popup_winid, pos_opts)
  endif

  augroup VistaPopup
    autocmd!
    autocmd CursorMoved <buffer> call s:ClosePopup()
    autocmd BufEnter,WinEnter,WinLeave * call s:ClosePopup()
  augroup END

  let g:vista.popup_visible = v:true
endfunction

function! s:DisplayRawAt(lnum, lines, vista_winid) abort
  if win_getid() != a:vista_winid
    return
  endif

  call s:OpenPopup(a:lines)
endfunction

function! s:DisplayAt(lnum, tag, vista_winid) abort
  if win_getid() != a:vista_winid
    return
  endif

  let [lines, s:popup_lnum] = vista#preview#GetLines(a:lnum)

  call s:OpenPopup(lines)

  let target_line = lines[s:popup_lnum - 1]
  try
    let [_, s:popup_start, s:popup_end] = matchstrpos(target_line, '\C'.a:tag)

    " Highlight the tag in the popup window if found.
    if s:popup_start > -1
      call win_execute(s:popup_winid, 'call s:HiTag()')
    endif
  catch /^Vim\%((\a\+)\)\=:E869/
    call win_execute(s:popup_winid, 'call s:HiTagLine()')
  endtry
endfunction

function! vista#popup#Close() abort
  call s:ClosePopup()
endfunction

function! s:DispatchDisplayer(Displayer, lnum, tag_or_raw_lines) abort
  if a:lnum == s:last_lnum
        \ || get(g:vista, 'popup_visible', v:false)
    return
  endif

  silent! call timer_stop(s:popup_timer)

  let s:last_lnum = a:lnum

  let win_id = win_getid()
  let s:popup_timer = timer_start(
        \ s:popup_delay,
        \ { -> a:Displayer(a:lnum, a:tag_or_raw_lines, win_id) }
        \ )
endfunction

function! vista#popup#DisplayAt(lnum, tag) abort
  call s:DispatchDisplayer(function('s:DisplayAt'), a:lnum, a:tag)
endfunction

function! vista#popup#DisplayRawAt(lnum, lines) abort
  call s:DispatchDisplayer(function('s:DisplayRawAt'), a:lnum, a:lines)
endfunction
./autoload/vista/preview.vim	[[[1
20
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" Return the lines to preview and the target line number in the preview buffer.
function! vista#preview#GetLines(lnum) abort
  " Show 5 lines around the tag source line [lnum-5, lnum+5]
  let range = 5

  if a:lnum - range > 0
    let preview_lnum = range + 1
  else
    let preview_lnum = a:lnum
  endif

  let begin = max([a:lnum - range, 1])
  let end = begin + range * 2

  return [getbufline(g:vista.source.bufnr, begin, end), preview_lnum]
endfunction
./autoload/vista/renderer/hir/ctags.vim	[[[1
301
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf-8

let s:scope_icon = ['⊕', '⊖']

let s:visibility_icon = {
      \ 'public': '+',
      \ 'protected': '~',
      \ 'private': '-',
      \ }

let g:vista#renderer#default#vlnum_offset = 3

let s:indent_size = g:vista#renderer#enable_icon ? 2 : 4

" Return the rendered row to be displayed given the depth
function! s:Assemble(line, depth) abort
  let line = a:line

  let kind = get(line, 'kind', '')
  let kind_icon = vista#renderer#IconFor(kind)
  let kind_icon = empty(kind_icon) ? '' : kind_icon.' '
  let kind_text = vista#renderer#KindFor(kind)
  let kind_text = empty(kind_text) ? '' : ' '.kind_text

  let row = vista#util#Join(
        \ repeat(' ', a:depth * s:indent_size),
        \ s:GetVisibility(line),
        \ kind_icon,
        \ get(line, 'name'),
        \ get(line, 'signature', ''),
        \ kind_text,
        \ ':'.get(line, 'line', '')
        \ )

  return row
endfunction

" Actually append to the rows
function! s:Append(line, rows, depth) abort
  let line = a:line
  let rows = a:rows

  let row = s:Assemble(line, a:depth)

  call add(rows, row)
  call add(s:vlnum_cache, line)
endfunction

function! s:ApplyAppend(line, row, rows) abort
  let line = a:line
  let rows = a:rows

  call add(rows, a:row)
  call add(s:vlnum_cache, line)
endfunction

" Return the next root name and line after appending to the rows.
function! s:AppendChild(line, rows, depth) abort
  if has_key(a:line, 'scope')
    call s:Append(a:line, a:rows, a:depth)
    let parent_name = a:line.scope
    let next_root_name = parent_name . s:scope_seperator . a:line.name
    return [next_root_name, a:line]
  endif

  return [v:null, v:null]
endfunction

function! s:Compare(s1, s2) abort
  return a:s1.line - a:s2.line
endfunction

" This way is more of heuristic.
"
" the line of child should larger than parent's, which partially fixes this issue comment:
" https://github.com/universal-ctags/ctags/issues/2065#issuecomment-485117935
"
" The previous nearest one should be the exact one.
function! s:RealParentOf(candidate) abort
  let candidate = a:candidate

  let name = candidate.scope
  let kind = candidate.scopeKind

  let parent_candidates = []
  for pc in g:vista.without_scope
    if pc.name ==# name && pc.kind ==# kind && pc.line <= candidate.line
      call add(parent_candidates, pc)
    endif
  endfor

  if !empty(parent_candidates)
    call sort(parent_candidates, function('s:Compare'))
    return parent_candidates[-1]
  endif

  return {}
endfunction

" Previously we use the regexp to see if the scope of candidate is matched:
"
" \ ' && v:val.scope =~# ''^''.l:scope'.
"
" but it runs into the error like NFA E869 '\@ ' in some cases, so we use this
" now. Ref #161
function! s:StartWith(candidate_scope, root_scope) abort
  return a:candidate_scope[:len(a:root_scope)] == a:root_scope
endfunction

" Find all descendants of the root
function! s:DescendantsOf(candidates, root_line, scope) abort
  let candidates = filter(copy(a:candidates),
        \ 'has_key(v:val, ''scope'')'.
        \ ' && s:StartWith(v:val.scope, a:scope)'.
        \ ' && v:val.scopeKind ==# a:root_line.kind'.
        \ ' && v:val.line >= a:root_line.line'
        \ )

  return candidates
  " The real parent problem seemingly has been solved?
  " return filter(candidates, 's:RealParentOf(v:val) ==# a:root_line')
endfunction

function! s:DescendantsOfRoot(candidates, root_line) abort
  let candidates = filter(copy(a:candidates),
        \ 'has_key(v:val, ''scope'')'.
        \ ' && s:StartWith(v:val.scope, a:root_line.name)'.
        \ ' && v:val.scopeKind ==# a:root_line.kind'.
        \ ' && v:val.line >= a:root_line.line'
        \ )

  return filter(candidates, 's:RealParentOf(v:val) ==# a:root_line')
endfunction

function! s:RenderDescendants(parent_name, parent_line, descendants, rows, depth) abort
  let depth = a:depth
  let rows = a:rows

  " Clear the previous duplicate parent line that is about to be added.
  "
  " This is a little bit stupid actually :(.
  let about_to_append = s:Assemble(a:parent_line, depth)
  let idx = 0
  while idx < len(rows)
    if rows[idx] ==# about_to_append
      unlet rows[idx]
      unlet s:vlnum_cache[idx]
    endif
    let idx += 1
  endwhile

  " Append the root actually
  call s:ApplyAppend(a:parent_line, about_to_append, rows)

  let depth += 1

  " find all the children
  let children = filter(copy(a:descendants), 'v:val.scope ==# a:parent_name')

  let grandchildren = []
  let grandchildren_line = []

  for child in children
    let [next_potentioal_root, next_potentioal_root_line] = s:AppendChild(child, rows, depth)
    if !empty(next_potentioal_root)
      call add(grandchildren, next_potentioal_root)
      call add(grandchildren_line, next_potentioal_root_line)
    endif
  endfor

  let idx = 0
  while idx < len(grandchildren)
    let child_name = grandchildren[idx]
    let child_line = grandchildren_line[idx]

    let descendants = s:DescendantsOf(g:vista.with_scope, child_line, child_name)

    if !empty(descendants)
      call s:RenderDescendants(child_name, child_line, descendants, a:rows, depth)
    endif

    let idx += 1
  endwhile
endfunction

function! s:GetVisibility(line) abort
  return has_key(a:line, 'access') ? get(s:visibility_icon, a:line.access, '?') : ''
endfunction

function! s:SortCompare(i1, i2) abort
  return a:i1.name > a:i2.name
endfunction

function! s:RenderScopeless(scope_less, rows) abort
  let rows = a:rows
  let scope_less = a:scope_less

  for kind in keys(scope_less)
    let kind_line = vista#renderer#Decorate(kind)
    call add(rows, g:vista_fold_toggle_icons[0].' '.kind_line)

    let lines = scope_less[kind]

    if get(g:vista, 'sort', v:false)
      let lines = sort(copy(lines), function('s:SortCompare'))
    endif

    for line in lines
      let row = vista#util#Join(
            \ '  '.s:GetVisibility(line),
            \ get(line, 'name'),
            \ get(line, 'signature', ''),
            \ ':'.line.line
            \ )

      call add(rows, row)

      let line.vlnum = len(rows) + 2
    endfor

    call add(rows, '')
    call add(s:vlnum_cache, '')
  endfor

  " Remove the last line if it's empty, i.e., ''
  if !empty(rows) && empty(rows[-1])
    unlet rows[-1]
  endif
endfunction

function! s:Render() abort
  let s:scope_seperator = g:vista.source.scope_seperator()

  let rows = []

  " s:vlnum_cache is a cache for recording which original tagline
  " is related to the line in the vista sidebar, for we have to
  " remove the duplicate parents which leads to reassign the lnum
  " to the original tagline.
  "
  " The item of s:vlnum_cache is some original tagline dict with
  " `vlnum` field added later.
  let s:vlnum_cache = []

  let scope_less = {}

  let without_scope = g:vista.without_scope

  " The root of hierarchy structure doesn't have scope field.
  for potential_root_line in without_scope

    let root_name = potential_root_line.name

    let descendants = s:DescendantsOfRoot(g:vista.with_scope, potential_root_line)

    if !empty(descendants)

      call s:RenderDescendants(root_name, potential_root_line, descendants, rows, 0)

      call add(rows, '')
      call add(s:vlnum_cache, '')

    else

      if has_key(potential_root_line, 'kind')
        call vista#util#TryAdd(scope_less, potential_root_line.kind, potential_root_line)
      endif

    endif

  endfor

  call s:RenderScopeless(scope_less, rows)

  " The original tagline is positioned in which line in the vista sidebar.
  let idx = 0
  while idx < len(s:vlnum_cache)
    if !empty(s:vlnum_cache[idx])
      " idx is 0-based, while the line number is 1-based, and we prepend the
      " two lines first, so the final offset is 1+2=3
      let s:vlnum_cache[idx].vlnum = idx + g:vista#renderer#default#vlnum_offset
    endif
    let idx += 1
  endwhile

  let g:vista.vlnum_cache = s:vlnum_cache

  return rows
endfunction

function! vista#renderer#hir#ctags#Render() abort
  if empty(g:vista.raw)
    return []
  endif

  return s:Render()
endfunction
./autoload/vista/renderer/hir/lsp.vim	[[[1
101
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:indent_size = g:vista#renderer#enable_icon ? 2 : 4

function! s:IntoLSPHirRow(row) abort
  let indent = repeat(' ', a:row.level * s:indent_size)
  let kind_icon = vista#renderer#IconFor(a:row.kind)
  let kind_text = vista#renderer#KindFor(a:row.kind)

  " indent + kind_icon? + name + kind_text? + lnum
  let line = indent
  if !empty(kind_icon)
    let line = line.kind_icon.' '
  endif
  let line = line.a:row.text
  if !empty(kind_text)
    let line = line.' '.kind_text
  endif
  return line.':'.a:row.lnum
endfunction

function! s:IntoLSPNonHirRow(row) abort
  let indented = repeat(' ', s:indent_size).a:row.text
  let lnum = ':'.a:row.lnum
  return indented.lnum
endfunction

function! s:RenderNonHirRow(vs, rendered) abort
  call add(a:rendered, s:IntoLSPNonHirRow(a:vs.row))
  let vlnum = len(a:rendered) + 2
  let g:vista.raw[a:vs.idx].vlnum = vlnum
  if has_key(a:vs.row, 'text')
    let g:vista.vlnum2tagname[vlnum] = a:vs.row.text
  endif
endfunction

function! s:RenderLSPHirAndThenGroupByKind(data) abort
  let rendered = []
  let level0 = {}

  let idx = 0
  let len = len(a:data)

  for row in a:data
    if (row.level == 0 && idx+1 < len && a:data[idx+1].level > 0)
          \ || row.level > 0
      call add(rendered, s:IntoLSPHirRow(row))
      let g:vista.raw[idx].vlnum = len(rendered) + 2
      if has_key(row, 'text')
        let g:vista.vlnum2tagname[len(rendered)+2] = row.text
      endif
    endif
    if row.level > 0
      if idx+1 < len && a:data[idx+1].level == 0
        call add(rendered, '')
      endif
    else
      if idx < len && a:data[idx].level == 0
        if has_key(level0, row.kind)
          call add(level0[row.kind], { 'row': row, 'idx': idx })
        else
          let level0[row.kind] = [{ 'row': row, 'idx': idx }]
        endif
      endif
    endif
    let idx += 1
  endfor

  if len(level0) > 0 && !empty(rendered) && rendered[-1] !=# ''
    call add(rendered, '')
  endif

  for [kind, vs] in items(level0)
    call add(rendered, vista#renderer#Decorate(kind))
    call map(vs, 's:RenderNonHirRow(v:val, rendered)')
    call add(rendered, '')
  endfor

  if empty(rendered[-1])
    unlet rendered[-1]
  endif

  return rendered
endfunction

" Render the content linewise.
function! s:TransformDirectly(row) abort
  let icon = vista#renderer#IconFor(a:row.kind)
  let indented = repeat(' ', a:row.level * s:indent_size).icon.a:row.text
  let lnum = ':'.a:row.lnum
  return indented.kind.lnum
endfunction

" data is a list of items with the level info for the hierarchy purpose.
function! vista#renderer#hir#lsp#Coc(data) abort
  let g:vista.vlnum2tagname = {}
  " return map(a:data, 's:Transform(v:val)')
  return s:RenderLSPHirAndThenGroupByKind(a:data)
endfunction
./autoload/vista/renderer/kind.vim	[[[1
90
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et
"
" Render the content by the kind of tag.
scriptencoding utf8

let s:viewer = {}

function! s:viewer.init(data) abort
  let self.rows = []
  let self.data = a:data

  let self.prefixes = g:vista_icon_indent

  " TODO improve me!
  let up_gap = strwidth(self.prefixes[0])
  " By default the gap is half of the second prefix.
  " at least one
  if up_gap >= 2 && up_gap < 4
    let self.gap = up_gap
  elseif up_gap >= 4
    let self.gap = up_gap / 2
  else
    let self.gap = up_gap + strwidth(self.prefixes[1])/2
  endif
endfunction

function! s:ContainWhitespaceOnly(str) abort
  return a:str !~# '\S'
endfunction

function! s:Compare(i1, i2) abort
  return a:i1.text > a:i2.text
endfunction

function! s:viewer.render() abort
  let try_adjust = self.prefixes[0] != self.prefixes[1]

  " prefixes[0] scope [children_num]
  "   prefixes[1] tag:num
  for [kind, v] in items(self.data)
    let parent = self.prefixes[0] .vista#renderer#Decorate(kind).' ['.len(v).']'
    " Parent
    call add(self.rows, parent)

    if !empty(v) && type(v) == type([])

      if get(g:vista, 'sort', v:false)
        let v = sort(copy(v), function('s:Compare'))
      endif

      " Children
      for i in v
        if len(i) > 0
          let row = vista#util#Join(
                \ repeat(' ', self.gap),
                \ self.prefixes[1],
                \ i.text,
                \ ':'.i.lnum
                \ )
          call add(self.rows, row)
        endif
      endfor

      if !s:ContainWhitespaceOnly(self.prefixes[1]) && try_adjust
        " Adjust the prefix of last item in each scope
        let tag_colon_num = split(self.rows[-1], ' ')[1:]
        let self.rows[-1] = repeat(' ', self.gap)
              \ .self.prefixes[0]
              \ .join(tag_colon_num, ' ')
      endif
    endif

    call add(self.rows, '')
  endfor

  " Remove the needless last empty line
  unlet self.rows[-1]

  return self.rows
endfunction

function! vista#renderer#kind#Render(data) abort
  if empty(a:data)
    return []
  endif
  call s:viewer.init(a:data)
  return s:viewer.render()
endfunction
./autoload/vista/renderer/line.vim	[[[1
64
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:scope_icon = ['⊕', '⊖']

let s:visibility_icon = {
      \ 'public': '+',
      \ 'protected': '#',
      \ 'private': '-',
      \ }

function! s:RenderLinewise() abort
  let rows = []

  " FIXME the same kind tags could be in serveral sections
  let idx = 0
  let raw_len = len(g:vista.raw)

  while idx < raw_len
    let line = g:vista.raw[idx]

    if has_key(line, 'access')
      let access = get(s:visibility_icon, line.access, '?')
    else
      let access = ''
    endif

    if !exists('s:last_kind') || has_key(line, 'kind') && s:last_kind != line.kind
      call add(rows, vista#renderer#Decorate(line.kind))
      let s:last_kind = get(line, 'kind')
      continue
    endif

    let row = vista#util#Join('  '.access, get(line, 'name'), get(line, 'signature', ''), ':'.line.line)

    call add(rows, row)

    " Inject vlnum.
    " Since we prepend the fpath and a blank line, the vlnum should plus 2.
    let line.vlnum = len(rows) + 2

    " Append a blank line in the last of a section.
    if has_key(line, 'kind') && idx < raw_len - 1
      if line.kind != get(g:vista.raw[idx+1], 'kind')
        call add(rows, '')
      endif
    endif

    let idx += 1
  endwhile

  unlet s:last_kind

  return rows
endfunction

function! vista#renderer#line#Render() abort
  if empty(g:vista.raw)
    return []
  endif

  return s:RenderLinewise()
endfunction
./autoload/vista/renderer/markdown_like.vim	[[[1
52
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf-8

function! s:Join(line, icon) abort
  let line = a:line

  let text = line.text
  let lnum = line.lnum
  let level = line.level
  let row = repeat(' ', 2 * (level - 1)).a:icon.text.' H'.level.':'.lnum

  return row
endfunction

function! s:BuildRow(idx, line) abort
  if a:idx+1 == len(s:data) || s:data[a:idx+1].level != a:line.level
    return s:Join(a:line, g:vista_icon_indent[0])
  else
    return s:Join(a:line, g:vista_icon_indent[1])
  endif
endfunction

" Given the metadata of headers of markdown, return the rendered lines to display.
"
" line.lnum is 1-based.
"
" The metadata of markdown headers is a List of Dict:
" {'lnum': 1, 'level': '4', 'text': 'Vista.vim'}
function! s:MD(idx, line) abort
  return s:BuildRow(a:idx, a:line)
endfunction

" The metadata of rst headers is a List of Dict:
" {'lnum': 1, 'level': '4', 'text': 'Vista.vim'}
function! s:RST(idx, line) abort
  return s:BuildRow(a:idx, a:line)
endfunction

" markdown
function! vista#renderer#markdown_like#MD(data) abort
  let s:data = a:data
  return map(a:data, 's:MD(v:key, v:val)')
endfunction

" restructuredText
function! vista#renderer#markdown_like#RST(data) abort
  let s:data = a:data
  return map(a:data, 's:RST(v:key, v:val)')
endfunction
./autoload/vista/renderer.vim	[[[1
128
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf-8

let s:icons = {
\    'func': "\Uf0295",
\    'function': "\Uf0295",
\    'functions': "\Uf0295",
\    'var': "\uea88",
\    'variable': "\uea88",
\    'variables': "\uea88",
\    'const': "\ueb5d",
\    'constant': "\ueb5d",
\    'constructor': "\uf976",
\    'method': "\uea8c",
\    'package': "\ueb29",
\    'packages': "\ueb29",
\    'enum': "\uea95",
\    'enummember': "\ueb5e",
\    'enumerator': "\uea95",
\    'module': "\ueaec",
\    'modules': "\ueaec",
\    'type': "\uebb9",
\    'typedef': "\uebb9",
\    'types': "\uebb9",
\    'field': "\ueb5f",
\    'fields': "\ueb5f",
\    'macro': "\Uf03a4",
\    'macros': "\Uf03a4",
\    'map': "\Uf0645",
\    'class': "\ueb5b",
\    'augroup': "\Uf0645",
\    'struct': "\uea91",
\    'union': "\Uf0564",
\    'member': "\uf02b",
\    'target': "\Uf0394",
\    'property': "\ueb65",
\    'interface': "\ueb61",
\    'namespace': "\uea8b",
\    'subroutine': "\Uf04b0",
\    'implementation': "\uebba",
\    'typeParameter': "\uea92",
\    'default': "\uf29c"
\}

let g:vista#renderer#ctags = get(g:, 'vista#renderer#ctags', 'default')
let g:vista#renderer#icons = map(extend(s:icons, get(g:, 'vista#renderer#icons', {})), 'tolower(v:val)')
let g:vista#renderer#enable_icon = get(g:, 'vista#renderer#enable_icon',
      \ exists('g:vista#renderer#icons') || exists('g:airline_powerline_fonts'))
let g:vista#renderer#enable_kind = get(g:, 'vista#renderer#enable_kind', !g:vista#renderer#enable_icon)

function! vista#renderer#IconFor(kind) abort
  if g:vista#renderer#enable_icon
    let key = tolower(a:kind)
    if has_key(g:vista#renderer#icons, key)
      return g:vista#renderer#icons[key]
    else
      return get(g:vista#renderer#icons, 'default', '?')
    endif
  else
    return ''
  endif
endfunction

function! vista#renderer#KindFor(kind) abort
  if g:vista#renderer#enable_kind
    return a:kind
  else
    return ''
  endif
endfunction

function! vista#renderer#Decorate(kind) abort
  if g:vista#renderer#enable_icon
    return vista#renderer#IconFor(a:kind).' '.a:kind
  else
    return a:kind
  endif
endfunction

function! s:Render(data) abort
  if g:vista.provider ==# 'coc' && type(a:data) == v:t_list
    return vista#renderer#hir#lsp#Coc(a:data)
  elseif g:vista.provider ==# 'ctags' && g:vista#renderer#ctags ==# 'default'
    return vista#renderer#hir#ctags#Render()
  else
    " The kind renderer applys to the LSP provider.
    return vista#renderer#kind#Render(a:data)
  endif
endfunction

" Render the extracted data to rows
function! vista#renderer#Render(data) abort
  return s:Render(a:data)
endfunction

function! vista#renderer#RenderAndDisplay(data) abort
  call vista#sidebar#OpenOrUpdate(s:Render(a:data))
endfunction

" Convert the number kind to the text kind, and then
" extract the neccessary info from the raw LSP response.
function! vista#renderer#LSPPreprocess(lsp_result) abort
  let lines = []
  call map(a:lsp_result, 'vista#parser#lsp#KindToSymbol(v:val, lines)')

  let processed_data = {}
  let g:vista.functions = []
  call map(lines, 'vista#parser#lsp#ExtractSymbol(v:val, processed_data)')

  return processed_data
endfunction

" React on the preprocessed LSP data
function! vista#renderer#LSPProcess(processed_data, reload_only, should_display) abort
  " Always reload the data, display the processed data on demand.
  if a:should_display
    call vista#Debug('[LSPProcess]should_display, processed_data:'.string(a:processed_data))
    call vista#renderer#RenderAndDisplay(a:processed_data)
    return [a:reload_only, v:false]
  else
    call vista#Debug('[LSPProcess]reload_only, processed_data:'.string(a:processed_data))
    call vista#sidebar#Reload(a:processed_data)
    return [v:true, a:should_display]
  endif
endfunction
./autoload/vista/sidebar.vim	[[[1
155
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" Which filetype the current sidebar should be.
function! vista#sidebar#WhichFileType() abort
  if g:vista.provider ==# 'coc'
        \ || (g:vista.provider ==# 'ctags' && g:vista#renderer#ctags ==# 'default')
    return 'vista'
  elseif g:vista.provider ==# 'markdown'
    return 'vista_markdown'
  else
    return 'vista_kind'
  endif
endfunction

function! s:NewWindow() abort
  if exists('g:vista_sidebar_open_cmd')
    let open = g:vista_sidebar_open_cmd
  else
    let open = g:vista_sidebar_position.' '.g:vista_sidebar_width.'new'
  endif

  if get(g:, 'vista_sidebar_keepalt', 0)
    silent execute 'keepalt '.open '__vista__'
  else
    silent execute open '__vista__'
  endif

  execute 'setlocal filetype='.vista#sidebar#WhichFileType()

  " FIXME when to delete?
  if has_key(g:vista.source, 'fpath')
    let w:vista_first_line_hi_id = matchaddpos('MoreMsg', [1])
  endif
endfunction

" Reload vista buffer given the unrendered data
function! vista#sidebar#Reload(data) abort
  " empty(a:data):
  "   May be triggered by autocmd event sometimes
  "   e.g., unsupported filetypes for ctags or no related language servers.
  "
  " !has_key(g:vista, 'bufnr'):
  "   May opening a new tab if bufnr does not exist in g:vista.
  "
  " g:vista.winnr() == -1:
  "   vista window is not visible.
  if empty(a:data)
        \ || !has_key(g:vista, 'bufnr')
        \ || g:vista.winnr() == -1
    return
  endif

  let rendered = vista#renderer#Render(a:data)
  call vista#util#SetBufline(g:vista.bufnr, rendered)
endfunction

" Open or update vista buffer given the rendered rows.
function! vista#sidebar#OpenOrUpdate(rows) abort
  " (Re)open a window and move to it
  if !exists('g:vista.bufnr')
    call s:NewWindow()
    let g:vista = get(g:, 'vista', {})
    let g:vista.bufnr = bufnr('%')
    let g:vista.winid = win_getid()
    let g:vista.pos = [winsaveview(), winnr(), winrestcmd()]
  else
    let winnr = g:vista.winnr()
    if winnr == -1
      call s:NewWindow()
    elseif winnr() != winnr
      noautocmd execute winnr.'wincmd w'
    endif
  endif

  call vista#util#SetBufline(g:vista.bufnr, a:rows)

  if has_key(g:vista, 'lnum')
    call vista#cursor#ShowTagFor(g:vista.lnum)
    unlet g:vista.lnum
  endif

  if !g:vista_stay_on_open
    wincmd p
  endif
endfunction

function! vista#sidebar#Close() abort
  if exists('g:vista.bufnr')
    let winnr = g:vista.winnr()

    " Jump back to the previous window if we are in the vista sidebar atm.
    if winnr == winnr()
      wincmd p
    endif

    if winnr != -1
      noautocmd execute winnr.'wincmd c'
    endif

    silent execute  g:vista.bufnr.'bwipe!'
    unlet g:vista.bufnr
  endif

  call s:ClearAugroups('VistaCoc', 'VistaCtags')

  call vista#win#CloseFloating()
endfunction

function! s:ClearAugroups(...) abort
  for aug in a:000
    if exists('#'.aug)
      execute 'autocmd!' aug
    endif
  endfor
endfunction

function! vista#sidebar#Open() abort
  let [bufnr, winnr, fname, fpath] = [bufnr('%'), winnr(), expand('%'), expand('%:p')]
  call vista#source#Update(bufnr, winnr, fname, fpath)

  " Support the builtin markdown toc extension as an executive
  if vista#toc#IsSupported(&filetype)
    call vista#toc#Run()
  else
    let executive = vista#GetExplicitExecutiveOrDefault()
    call vista#executive#{executive}#Execute(v:false, v:true, v:false)
  endif
endfunction

function! vista#sidebar#IsOpen() abort
  return bufwinnr('__vista__') != -1
endfunction

function! vista#sidebar#ToggleFocus() abort
  if !exists('g:vista') || g:vista.winnr() == -1
    call vista#sidebar#Open()
    return
  endif
  let winnr = g:vista.winnr()
  if winnr != winnr()
    execute winnr.'wincmd w'
  else
    call vista#source#GotoWin()
  endif
endfunction

function! vista#sidebar#Toggle() abort
  if vista#sidebar#IsOpen()
    call vista#sidebar#Close()
  else
    call vista#sidebar#Open()
  endif
endfunction
./autoload/vista/source.vim	[[[1
72
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

if exists('*bufwinid')
  function! s:GotoSourceWindow() abort
    let bufid = g:vista.source.bufnr
    let winid = bufwinid(bufid)
    if winid != -1
      if win_getid() != winid
        " No use noautocmd here. Ref #362
        call win_gotoid(winid)
      endif
    else
      return vista#error#('Cannot find the source window id')
    endif
  endfunction
else
  function! s:GotoSourceWindow() abort
    " g:vista.source.winnr is not always correct.
    let winnr = g:vista.source.get_winnr()
    if winnr != -1
      execute winnr.'wincmd w'
    else
      return vista#error#('Cannot find the target window')
    endif
  endfunction
endif

function! vista#source#GotoWin() abort
  let g:vista.skip_once_flag = v:true
  call s:GotoSourceWindow()

  " Floating window relys on BufEnter event to be closed automatically.
  if exists('#VistaFloatingWin')
    doautocmd BufEnter VistaFloatingWin
  endif
endfunction

" Update the infomation of source file to be processed,
" including whose bufnr, winnr, fname, fpath
function! vista#source#Update(bufnr, winnr, ...) abort
  if !exists('g:vista')
    call vista#init#Api()
  endif

  let g:vista.source.bufnr = a:bufnr
  let g:vista.source.winnr = a:winnr

  if a:0 == 1
    let g:vista.source.fname = a:1
  elseif a:0 == 2
    let g:vista.source.fname = a:1
    let g:vista.source.fpath = a:2
  endif
endfunction

function! s:ApplyPeek(lnum, tag) abort
  silent execute 'normal!' a:lnum.'z.'
  let [_, start, _] = matchstrpos(getline('.'), a:tag)
  call vista#util#Blink(1, 100, [a:lnum, start+1, strlen(a:tag)])
endfunction

if exists('*win_execute')
  function! vista#source#PeekSymbol(lnum, tag) abort
    call win_execute(g:vista.source.winid, 'noautocmd call s:ApplyPeek(a:lnum, a:tag)')
  endfunction
else
  function! vista#source#PeekSymbol(lnum, tag) abort
    call vista#win#Execute(g:vista.source.get_winnr(), function('s:ApplyPeek'), a:lnum, a:tag)
  endfunction
endif
./autoload/vista/statusline.vim	[[[1
35
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! vista#statusline#ShouldDisable() abort
  return g:vista_disable_statusline
endfunction

function! vista#statusline#Render() abort
  if vista#statusline#ShouldDisable()
    return
  endif

  if has_key(g:vista, 'bufnr')
    call setbufvar(g:vista.bufnr, '&statusline', vista#statusline#())
  endif
endfunction

function! vista#statusline#RenderOnWinEvent() abort
  if !exists('g:vista') || vista#statusline#ShouldDisable()
    return
  endif

  let &l:statusline = vista#statusline#()
endfunction

function! vista#statusline#() abort
  let fname = get(g:vista.source, 'fname', '')
  let provider = get(g:vista, 'provider', '')
  if !empty(provider)
    return '[Vista] '.provider.' %<'.fname
  else
    return '[Vista] %<'.fname
  endif
endfunction
./autoload/vista/toc.vim	[[[1
46
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" vimwiki supports the standard markdown syntax.
" pandoc supports the basic markdown format.
" API Blueprint is a set of semantic assumptions on top of markdown.
let s:toc_supported = ['markdown', 'rst', 'vimwiki', 'pandoc', 'apiblueprint', 'pandoc.markdown', 'markdown.pandoc']

" These filestypes all can use the markdown extension.
let s:markdown_common = ['markdown', 'vimwiki', 'pandoc', 'apiblueprint', 'pandoc.markdown', 'markdown.pandoc']

function! vista#toc#IsSupported(filetype) abort
  return index(s:toc_supported, a:filetype) > -1
endfunction

function! s:TryRunExtension(...) abort
  if a:0 > 0
    let extension = a:1
  elseif index(s:markdown_common, &filetype) > -1
    let extension = 'markdown'
  else
    let extension = &filetype
  endif
  if index(g:vista#extensions, extension) > -1
    call vista#extension#{extension}#Execute(v:false, v:true)
  else
    call vista#error#('Cannot find vista extension: '.extension)
  endif
endfunction

" toc is the synonym of markdown like extensions.
function! vista#toc#Run() abort
  let explicit_executive = vista#GetExplicitExecutive(&filetype)
  if explicit_executive isnot v:null
    if index(s:markdown_common, explicit_executive) > -1
      call s:TryRunExtension('markdown')
    elseif explicit_executive !=# 'toc'
      call vista#executive#{explicit_executive}#Execute(v:false, v:true, v:false)
    else
      call s:TryRunExtension()
    endif
  else
    call s:TryRunExtension()
  endif
endfunction
./autoload/vista/types/uctags/ada.vim	[[[1
40
" Ada
let s:types = {}

let s:types.lang = 'ada'

let s:types.kinds = {
    \ 'P': {'long' : 'package specifications',        'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'packages',                      'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'types',                         'fold' : 0, 'stl' : 1},
    \ 'u': {'long' : 'subtypes',                      'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'record type components',        'fold' : 0, 'stl' : 1},
    \ 'l': {'long' : 'enum type literals',            'fold' : 0, 'stl' : 0},
    \ 'v': {'long' : 'variables',                     'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'generic formal parameters',     'fold' : 0, 'stl' : 0},
    \ 'n': {'long' : 'constants',                     'fold' : 0, 'stl' : 0},
    \ 'x': {'long' : 'user defined exceptions',       'fold' : 0, 'stl' : 1},
    \ 'R': {'long' : 'subprogram specifications',     'fold' : 0, 'stl' : 1},
    \ 'r': {'long' : 'subprograms',                   'fold' : 0, 'stl' : 1},
    \ 'K': {'long' : 'task specifications',           'fold' : 0, 'stl' : 1},
    \ 'k': {'long' : 'tasks',                         'fold' : 0, 'stl' : 1},
    \ 'O': {'long' : 'protected data specifications', 'fold' : 0, 'stl' : 1},
    \ 'o': {'long' : 'protected data',                'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'task/protected data entries',   'fold' : 0, 'stl' : 1},
    \ 'b': {'long' : 'labels',                        'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'loop/declare identifiers',      'fold' : 0, 'stl' : 1},
    \ }

let s:types.sro = '.' " Not sure if possible

let s:types.kind2scope = {
    \ 'P' : 'packspec',
    \ 't' : 'type',
    \ }

let s:types.scope2kind = {
    \ 'packspec' : 'P',
    \ 'type'     : 't',
    \ }

let g:vista#types#uctags#ada# = s:types
./autoload/vista/types/uctags/ant.vim	[[[1
13
" Ant {{{1
let s:types = {}

let s:types.lang = 'ant'

let s:types.kinds = {
    \ 'p': {'long' : 'projects',   'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'antfiles',   'fold' : 0, 'stl' : 0},
    \ 'P': {'long' : 'properties', 'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'targets',    'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#ant# = s:types
./autoload/vista/types/uctags/asm.vim	[[[1
14
" Asm {{{1
let s:types = {}

let s:types.lang = 'asm'

let s:types.kinds = {
    \ 'm': {'long' : 'macros',    'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'types',     'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'sections',  'fold' : 0, 'stl' : 1},
    \ 'd': {'long' : 'defines',   'fold' : 0, 'stl' : 1},
    \ 'l': {'long' : 'labels',    'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#asm# = s:types
./autoload/vista/types/uctags/aspvbs.vim	[[[1
15
" ASP {{{1
let s:types = {}

let s:types.lang = 'asp'

let s:types.kinds = {
    \ 'd': {'long' : 'constants',   'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',     'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',   'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'subroutines', 'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',   'fold' : 0, 'stl' : 1}
    \ }

" aspperl aspvbs
let g:vista#types#uctags#aspvbs# = s:types
./autoload/vista/types/uctags/asy.vim	[[[1
34
" Asymptote {{{1
" Asymptote gets parsed well using filetype = c
let s:types = {}

let s:types.lang = 'c'

let s:types.kinds = {
    \ 'd': {'long' : 'macros',      'fold' : 1, 'stl' : 0},
    \ 'p': {'long' : 'prototypes',  'fold' : 1, 'stl' : 0},
    \ 'g': {'long' : 'enums',       'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerators', 'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'typedefs',    'fold' : 0, 'stl' : 0},
    \ 's': {'long' : 'structs',     'fold' : 0, 'stl' : 1},
    \ 'u': {'long' : 'unions',      'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'members',     'fold' : 0, 'stl' : 0},
    \ 'v': {'long' : 'variables',   'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'functions',   'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '::'

let s:types.kind2scope = {
    \ 'g' : 'enum',
    \ 's' : 'struct',
    \ 'u' : 'union'
    \ }

let s:types.scope2kind = {
    \ 'enum'   : 'g',
    \ 'struct' : 's',
    \ 'union'  : 'u'
    \ }

let g:vista#types#uctags#asy# = s:types
./autoload/vista/types/uctags/automake.vim	[[[1
20
" Automake {{{1
let s:types = {}

let s:types.lang = 'automake'

let s:types.kinds = {
    \ 'I': {'long' : 'makefiles',   'fold' : 0, 'stl' : 1},
    \ 'd': {'long' : 'directories', 'fold' : 0, 'stl' : 1},
    \ 'P': {'long' : 'programs',    'fold' : 0, 'stl' : 1},
    \ 'M': {'long' : 'manuals',     'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'macros',      'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'targets',     'fold' : 0, 'stl' : 1},
    \ 'T': {'long' : 'ltlibraries', 'fold' : 0, 'stl' : 1},
    \ 'L': {'long' : 'libraries',   'fold' : 0, 'stl' : 1},
    \ 'S': {'long' : 'scripts',     'fold' : 0, 'stl' : 1},
    \ 'D': {'long' : 'datum',       'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'conditions',  'fold' : 0, 'stl' : 1},
    \ }

let g:vista#types#uctags#automake# = s:types
./autoload/vista/types/uctags/awk.vim	[[[1
10
" Awk {{{1
let s:types = {}

let s:types.lang = 'awk'

let s:types.kinds = {
  \ 'f': {'long' : 'functions', 'fold' : 0, 'stl' : 1}
  \ }

let g:vista#types#uctags#awk# = s:types
./autoload/vista/types/uctags/basic.vim	[[[1
15
" Basic {{{1
let s:types = {}

let s:types.lang = 'basic'

let s:types.kinds = {
    \ 'c': {'long' : 'constants',    'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'enumerations', 'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',    'fold' : 0, 'stl' : 1},
    \ 'l': {'long' : 'labels',       'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'types',        'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',    'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#basic# = s:types
./autoload/vista/types/uctags/beta.vim	[[[1
12
" BETA {{{1
let s:types = {}

let s:types.lang = 'beta'

let s:types.kinds = {
    \ 'f': {'long' : 'fragments', 'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'slots',     'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'patterns',  'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#beta# = s:types
./autoload/vista/types/uctags/c.vim	[[[1
34
" C {{{1
let s:types = {}

let s:types.lang = 'c'

let s:types.kinds = {
    \ 'h': {'long' : 'header files', 'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'macros',       'fold' : 1, 'stl' : 0},
    \ 'p': {'long' : 'prototypes',   'fold' : 1, 'stl' : 0},
    \ 'g': {'long' : 'enums',        'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerators',  'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'typedefs',     'fold' : 0, 'stl' : 0},
    \ 's': {'long' : 'structs',      'fold' : 0, 'stl' : 1},
    \ 'u': {'long' : 'unions',       'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'members',      'fold' : 0, 'stl' : 0},
    \ 'v': {'long' : 'variables',    'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'functions',    'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '::'

let s:types.kind2scope = {
    \ 'g' : 'enum',
    \ 's' : 'struct',
    \ 'u' : 'union'
    \ }

let s:types.scope2kind = {
    \ 'enum'   : 'g',
    \ 'struct' : 's',
    \ 'union'  : 'u'
    \ }

let g:vista#types#uctags#c# = s:types
./autoload/vista/types/uctags/clojure.vim	[[[1
21
" Clojure {{{1
let s:types = {}

let s:types.lang = 'clojure'

let s:types.kinds = {
    \ 'n': {'long': 'namespace', 'fold': 0, 'stl': 1},
    \ 'f': {'long': 'function',  'fold': 0, 'stl': 1},
    \ }

let s:types.sro = '.'

let s:types.kind2scope = {
    \ 'n' : 'namespace',
    \ }

let s:types.scope2kind = {
    \ 'namespace'  : 'n'
    \ }

let g:vista#types#uctags#clojure# = s:types
./autoload/vista/types/uctags/cobol.vim	[[[1
17
" COBOL {{{1
let s:types = {}

let s:types.lang = 'cobol'

let s:types.kinds = {
    \ 'd': {'long' : 'data items',        'fold' : 0, 'stl' : 1},
    \ 'D': {'long' : 'divisions',         'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'file descriptions', 'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'group items',       'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'paragraphs',        'fold' : 0, 'stl' : 1},
    \ 'P': {'long' : 'program ids',       'fold' : 0, 'stl' : 1},
    \ 'S': {'long' : 'source code file',  'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'sections',          'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#cobol# = s:types
./autoload/vista/types/uctags/config.vim	[[[1
17
" Autoconf {{{1
let s:types = {}

let s:types.lang = 'autoconf'

let s:types.kinds = {
    \ 'p': {'long': 'packages',            'fold': 0, 'stl': 1},
    \ 't': {'long': 'templates',           'fold': 0, 'stl': 1},
    \ 'm': {'long': 'autoconf macros',     'fold': 0, 'stl': 1},
    \ 'w': {'long': '"with" options',      'fold': 0, 'stl': 1},
    \ 'e': {'long': '"enable" options',    'fold': 0, 'stl': 1},
    \ 's': {'long': 'substitution keys',   'fold': 0, 'stl': 1},
    \ 'c': {'long': 'automake conditions', 'fold': 0, 'stl': 1},
    \ 'd': {'long': 'definitions',         'fold': 0, 'stl': 1}
    \ }

let g:vista#types#uctags#config# = s:types
./autoload/vista/types/uctags/cpp.vim	[[[1
42

" C++ {{{1
let s:types = {}

let s:types.lang = 'c++'

let s:types.kinds = {
    \ 'h': {'long' : 'header files', 'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'macros',       'fold' : 1, 'stl' : 0},
    \ 'p': {'long' : 'prototypes',   'fold' : 1, 'stl' : 0},
    \ 'g': {'long' : 'enums',        'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerators',  'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'typedefs',     'fold' : 0, 'stl' : 0},
    \ 'n': {'long' : 'namespaces',   'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',      'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'structs',      'fold' : 0, 'stl' : 1},
    \ 'u': {'long' : 'unions',       'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',    'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'members',      'fold' : 0, 'stl' : 0},
    \ 'v': {'long' : 'variables',    'fold' : 0, 'stl' : 0}
    \ }

let s:types.sro = '::'

let s:types.kind2scope = {
    \ 'g' : 'enum',
    \ 'n' : 'namespace',
    \ 'c' : 'class',
    \ 's' : 'struct',
    \ 'u' : 'union'
    \ }

let s:types.scope2kind = {
    \ 'enum'      : 'g',
    \ 'namespace' : 'n',
    \ 'class'     : 'c',
    \ 'struct'    : 's',
    \ 'union'     : 'u'
    \ }

" cpp cuda
let g:vista#types#uctags#cpp# = s:types
./autoload/vista/types/uctags/cs.vim	[[[1
40

" C# {{{1
let s:types = {}

let s:types.lang = 'c#'

let s:types.kinds = {
    \ 'd': {'long' : 'macros',      'fold' : 1, 'stl' : 0},
    \ 'f': {'long' : 'fields',      'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'enums',       'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerators', 'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'typedefs',    'fold' : 0, 'stl' : 1},
    \ 'n': {'long' : 'namespaces',  'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'interfaces',  'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',     'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'structs',     'fold' : 0, 'stl' : 1},
    \ 'E': {'long' : 'events',      'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'methods',     'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'properties',  'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '.'

let s:types.kind2scope = {
    \ 'n' : 'namespace',
    \ 'i' : 'interface',
    \ 'c' : 'class',
    \ 's' : 'struct',
    \ 'g' : 'enum'
    \ }

let s:types.scope2kind = {
    \ 'namespace' : 'n',
    \ 'interface' : 'i',
    \ 'class'     : 'c',
    \ 'struct'    : 's',
    \ 'enum'      : 'g'
    \ }

let g:vista#types#uctags#cs# = s:types
./autoload/vista/types/uctags/css.vim	[[[1
13

" CSS {{{1
let s:types = {}

let s:types.lang = 'css'

let s:types.kinds = {
    \ 's': {'long' : 'selector',   'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'identities', 'fold' : 1, 'stl' : 0},
    \ 'c': {'long' : 'classes',    'fold' : 1, 'stl' : 0}
    \ }

let g:vista#types#uctags#css# = s:types
./autoload/vista/types/uctags/ctags.vim	[[[1
22

" Ctags config {{{1
let s:types = {}

let s:types.lang = 'ctags'

let s:types.kinds = {
    \ 'l': {'long' : 'language definitions', 'fold' : 0, 'stl' : 1},
    \ 'k': {'long' : 'kind definitions',     'fold' : 0, 'stl' : 1},
    \ }

let s:types.sro = '.' " Not actually possible

let s:types.kind2scope = {
    \ 'l' : 'langdef',
    \ }

let s:types.scope2kind = {
    \ 'langdef' : 'l',
    \ }

let g:vista#types#uctags#ctags# = s:types
./autoload/vista/types/uctags/d.vim	[[[1
46

" D {{{1
let s:types = {}

let s:types.lang = 'D'

let s:types.kinds = {
    \ 'M': {'long' : 'modules',              'fold' : 0, 'stl' : 1},
    \ 'V': {'long' : 'version statements',   'fold' : 1, 'stl' : 0},
    \ 'n': {'long' : 'namespaces',           'fold' : 0, 'stl' : 1},
    \ 'T': {'long' : 'templates',            'fold' : 0, 'stl' : 0},
    \ 'c': {'long' : 'classes',              'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'interfaces',           'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'structure names',      'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'enumeration names',    'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerators',          'fold' : 0, 'stl' : 0},
    \ 'u': {'long' : 'union names',          'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'function prototypes',  'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'function definitions', 'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'members',              'fold' : 0, 'stl' : 1},
    \ 'a': {'long' : 'aliases',              'fold' : 1, 'stl' : 0},
    \ 'X': {'long' : 'mixins',               'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variable definitions', 'fold' : 0, 'stl' : 0},
    \ }

let s:types.sro = '.'

let s:types.kind2scope = {
    \ 'g' : 'enum',
    \ 'n' : 'namespace',
    \ 'i' : 'interface',
    \ 'c' : 'class',
    \ 's' : 'struct',
    \ 'u' : 'union'
    \ }

let s:types.scope2kind = {
    \ 'enum'      : 'g',
    \ 'namespace' : 'n',
    \ 'interface' : 'i',
    \ 'class'     : 'c',
    \ 'struct'    : 's',
    \ 'union'     : 'u'
    \ }

let g:vista#types#uctags#d# = s:types
./autoload/vista/types/uctags/dosbatch.vim	[[[1
12

" DOS Batch {{{1
let s:types = {}

let s:types.lang = 'dosbatch'

let s:types.kinds = {
    \ 'l': {'long' : 'labels',    'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#dosbatch# = s:types
./autoload/vista/types/uctags/eiffel.vim	[[[1
24

" Eiffel {{{1
let s:types = {}

let s:types.lang = 'eiffel'

let s:types.kinds = {
    \ 'c': {'long' : 'classes',  'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'features', 'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '.' " Not sure, is nesting even possible?

let s:types.kind2scope = {
    \ 'c' : 'class',
    \ 'f' : 'feature'
    \ }

let s:types.scope2kind = {
    \ 'class'   : 'c',
    \ 'feature' : 'f'
    \ }

let g:vista#types#uctags#eiffel# = s:types
./autoload/vista/types/uctags/elm.vim	[[[1
32

" Elm {{{1
" based on https://github.com/bitterjug/vim-tagbar-ctags-elm/blob/master/ftplugin/elm/tagbar-elm.vim
let s:types = {}

let s:types.lang = 'elm'

let s:types.kinds = {
    \ 'm': {'long' : 'modules',           'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'imports',           'fold' : 1, 'stl' : 0},
    \ 't': {'long' : 'types',             'fold' : 1, 'stl' : 0},
    \ 'a': {'long' : 'type aliases',      'fold' : 0, 'stl' : 0},
    \ 'c': {'long' : 'type constructors', 'fold' : 0, 'stl' : 0},
    \ 'p': {'long' : 'ports',             'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'functions',         'fold' : 1, 'stl' : 0},
    \ }

let s:types.sro = ':'

let s:types.kind2scope = {
    \ 'f' : 'function',
    \ 'm' : 'module',
    \ 't' : 'type'
    \ }

let s:types.scope2kind = {
    \ 'function' : 'f',
    \ 'module'   : 'm',
    \ 'type'     : 't'
    \ }

let g:vista#types#uctags#elm# = s:types
./autoload/vista/types/uctags/erlang.vim	[[[1
25

" Erlang {{{1
let s:types = {}

let s:types.lang = 'erlang'

let s:types.kinds = {
    \ 'm': {'long' : 'modules',            'fold' : 0, 'stl' : 1},
    \ 'd': {'long' : 'macro definitions',  'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',          'fold' : 0, 'stl' : 1},
    \ 'r': {'long' : 'record definitions', 'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'type definitions',   'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro        = '.' " Not sure, is nesting even possible?

let s:types.kind2scope = {
    \ 'm' : 'module'
    \ }

let s:types.scope2kind = {
    \ 'module' : 'm'
    \ }

let g:vista#types#uctags#erlang# = s:types
./autoload/vista/types/uctags/fortran.vim	[[[1
41

" Fortran {{{1
let s:types = {}

let s:types.lang = 'fortran'

let s:types.kinds = {
    \ 'm': {'long' : 'modules',    'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'programs',   'fold' : 0, 'stl' : 1},
    \ 'k': {'long' : 'components', 'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'derived types and structures', 'fold' : 0,'stl' : 1},
    \ 'c': {'long' : 'common blocks', 'fold' : 0, 'stl' : 1},
    \ 'b': {'long' : 'block data',    'fold' : 0, 'stl' : 0},
    \ 'E': {'long' : 'enumerations',  'fold' : 0, 'stl' : 1},
    \ 'N': {'long' : 'enumeration values', 'fold' : 0, 'stl' : 0},
    \ 'e': {'long' : 'entry points',  'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',     'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'subroutines',   'fold' : 0, 'stl' : 1},
    \ 'M': {'long' : 'type bound procedures',   'fold' : 0,'stl' : 1},
    \ 'l': {'long' : 'labels',        'fold' : 0, 'stl' : 1},
    \ 'n': {'long' : 'namelists',     'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',     'fold' : 0, 'stl' : 0}
    \ }

let s:types.sro = '.' " Not sure, is nesting even possible?

let s:types.kind2scope = {
    \ 'm' : 'module',
    \ 'p' : 'program',
    \ 'f' : 'function',
    \ 's' : 'subroutine'
    \ }

let s:types.scope2kind = {
    \ 'module'     : 'm',
    \ 'program'    : 'p',
    \ 'function'   : 'f',
    \ 'subroutine' : 's'
    \ }

let g:vista#types#uctags#fortran# = s:types
./autoload/vista/types/uctags/go.vim	[[[1
30

" Go {{{1
let type_go = {}

let type_go.lang = 'go'

let type_go.kinds = {
    \ 'p': {'long' : 'packages',       'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'imports',        'fold' : 0, 'stl' : 0},
    \ 'n': {'long' : 'interfaces',     'fold' : 0, 'stl' : 0},
    \ 'c': {'long' : 'constants',      'fold' : 0, 'stl' : 0},
    \ 's': {'long' : 'structs',        'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'methods',        'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'types',          'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',      'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',      'fold' : 0, 'stl' : 0},
    \ 'w': {'long' : 'struct members', 'fold' : 0, 'stl' : 0}
    \ }

let type_go.sro = '.'

let type_go.kind2scope = {
    \ 's' : 'struct'
    \ }

let type_go.scope2kind = {
    \ 'struct' : 's'
    \ }

let g:vista#types#uctags#go# = type_go
./autoload/vista/types/uctags/html.vim	[[[1
14

" HTML {{{1
let s:types = {}

let s:types.lang = 'html'

let s:types.kinds = {
    \ 'a': {'long' : 'named anchors', 'fold' : 0, 'stl' : 1},
    \ 'h': {'long' : 'H1 headings',   'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'H2 headings',   'fold' : 0, 'stl' : 1},
    \ 'j': {'long' : 'H3 headings',   'fold' : 0, 'stl' : 1},
    \ }

let g:vista#types#uctags#html# = s:types
./autoload/vista/types/uctags/java.vim	[[[1
32

" Java {{{1
let s:types = {}

let s:types.lang = 'java'

let s:types.kinds = {
    \ 'p': {'long' : 'packages',       'fold' : 1, 'stl' : 0},
    \ 'f': {'long' : 'fields',         'fold' : 0, 'stl' : 0},
    \ 'g': {'long' : 'enum types',     'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enum constants', 'fold' : 0, 'stl' : 0},
    \ 'a': {'long' : 'annotations',    'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'interfaces',     'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',        'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'methods',        'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '.'

let s:types.kind2scope = {
    \ 'g' : 'enum',
    \ 'i' : 'interface',
    \ 'c' : 'class'
    \ }

let s:types.scope2kind = {
    \ 'enum'      : 'g',
    \ 'interface' : 'i',
    \ 'class'     : 'c'
    \ }

let g:vista#types#uctags#java# = s:types
./autoload/vista/types/uctags/javascript.vim	[[[1
31

" JavaScript {{{1
let s:types = {}

let s:types.lang = 'javascript'

let s:types.kinds = {
    \ 'v': {'long': 'global variables', 'fold': 0, 'stl': 0},
    \ 'C': {'long': 'constants',        'fold': 0, 'stl': 0},
    \ 'c': {'long': 'classes',          'fold': 0, 'stl': 1},
    \ 'g': {'long': 'generators',       'fold': 0, 'stl': 0},
    \ 'p': {'long': 'properties',       'fold': 0, 'stl': 0},
    \ 'm': {'long': 'methods',          'fold': 0, 'stl': 1},
    \ 'f': {'long': 'functions',        'fold': 0, 'stl': 1},
    \ }

let s:types.sro        = '.'

let s:types.kind2scope = {
    \ 'c' : 'class',
    \ 'f' : 'function',
    \ 'm' : 'method',
    \ 'p' : 'property',
    \ }

let s:types.scope2kind = {
    \ 'class'    : 'c',
    \ 'function' : 'f',
    \ }

let g:vista#types#uctags#javascript# = s:types
./autoload/vista/types/uctags/lisp.vim	[[[1
11

" Lisp {{{1
let s:types = {}

let s:types.lang = 'lisp'

let s:types.kinds = {
    \ 'f': {'long' : 'functions', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#lisp# = s:types
./autoload/vista/types/uctags/lua.vim	[[[1
11

" Lua {{{1
let s:types = {}

let s:types.lang = 'lua'

let s:types.kinds = {
    \ 'f': {'long' : 'functions', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags# = s:types
./autoload/vista/types/uctags/make.vim	[[[1
13

" Make {{{1
let s:types = {}

let s:types.lang = 'make'

let s:types.kinds = {
    \ 'I': {'long' : 'makefiles', 'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'macros',    'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'targets',   'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#make# = s:types
./autoload/vista/types/uctags/matlab.vim	[[[1
12

" Matlab {{{1
let s:types = {}

let s:types.lang = 'matlab'

let s:types.kinds = {
    \ 'f': {'long' : 'functions', 'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables', 'fold' : 0, 'stl' : 0}
    \ }

let g:vista#types#uctags#matlab# = s:types
./autoload/vista/types/uctags/mxml.vim	[[[1
30

" Flex {{{1
" Vim doesn't support Flex out of the box, this is based on rough
" guesses and probably requires
" http://www.vim.org/scripts/script.php?script_id=2909
" Improvements welcome!
let s:types = {}

let s:types.lang = 'flex'

let s:types.kinds = {
    \ 'v': {'long' : 'global variables', 'fold' : 0, 'stl' : 0},
    \ 'c': {'long' : 'classes',          'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'methods',          'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'properties',       'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',        'fold' : 0, 'stl' : 1},
    \ 'x': {'long' : 'mxtags',           'fold' : 0, 'stl' : 0}
    \ }

let s:types.sro        = '.'

let s:types.kind2scope = {
    \ 'c' : 'class'
    \ }

let s:types.scope2kind = {
    \ 'class' : 'c'
    \ }

let g:vista#types#uctags#mxml# = s:types
./autoload/vista/types/uctags/objc.vim	[[[1
39

" ObjectiveC {{{1
let s:types = {}

let s:types.lang = 'objectivec'

let s:types.kinds = {
    \ 'M': {'long' : 'preprocessor macros',   'fold' : 1, 'stl' : 0},
    \ 't': {'long' : 'type aliases',          'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'global variables',      'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'class interfaces',      'fold' : 0, 'stl' : 1},
    \ 'I': {'long' : 'class implementations', 'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'class methods',         'fold' : 0, 'stl' : 1},
    \ 'E': {'long' : 'object fields',         'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'object methods',        'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'type structures',       'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerations',          'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',             'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'properties',            'fold' : 0, 'stl' : 0},
    \ 'P': {'long' : 'protocols',             'fold' : 0, 'stl' : 0},
    \ }

let s:types.sro = ':'

let s:types.kind2scope = {
    \ 'i' : 'interface',
    \ 'I' : 'implementation',
    \ 's' : 'struct',
    \ 'p' : 'protocol',
    \ }

let s:types.scope2kind = {
    \ 'interface' : 'i',
    \ 'implementation' : 'I',
    \ 'struct' : 's',
    \ 'protocol' : 'p',
    \ }

let g:vista#types#uctags#objc# = s:types
./autoload/vista/types/uctags/ocaml.vim	[[[1
34

" Ocaml {{{1
let s:types = {}

let s:types.lang = 'ocaml'

let s:types.kinds = {
    \ 'M': {'long' : 'modules or functors', 'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'global variables',    'fold' : 0, 'stl' : 0},
    \ 'c': {'long' : 'classes',             'fold' : 0, 'stl' : 1},
    \ 'C': {'long' : 'constructors',        'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'methods',             'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'exceptions',          'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'type names',          'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',           'fold' : 0, 'stl' : 1},
    \ 'r': {'long' : 'structure fields',    'fold' : 0, 'stl' : 0},
    \ 'p': {'long' : 'signature items',     'fold' : 0, 'stl' : 0}
    \ }

let s:types.sro = '.' " Not sure, is nesting even possible?

let s:types.kind2scope = {
    \ 'M' : 'Module',
    \ 'c' : 'class',
    \ 't' : 'type'
    \ }

let s:types.scope2kind = {
    \ 'Module' : 'M',
    \ 'class'  : 'c',
    \ 'type'   : 't'
    \ }

let g:vista#types#uctags#ocaml# = s:types
./autoload/vista/types/uctags/pascal.vim	[[[1
12

" Pascal {{{1
let s:types = {}

let s:types.lang = 'pascal'

let s:types.kinds = {
    \ 'f': {'long' : 'functions',  'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'procedures', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#pascal# = s:types
./autoload/vista/types/uctags/perl.vim	[[[1
15

" Perl {{{1
let s:types = {}

let s:types.lang = 'perl'

let s:types.kinds = {
    \ 'p': {'long' : 'packages',    'fold' : 1, 'stl' : 0},
    \ 'c': {'long' : 'constants',   'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'formats',     'fold' : 0, 'stl' : 0},
    \ 'l': {'long' : 'labels',      'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'subroutines', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#perl# = s:types
./autoload/vista/types/uctags/perl6.vim	[[[1
20

" Perl 6 {{{1
let s:types6 = {}

let s:types6.lang = 'perl6'

let s:types6.kinds = {
    \ 'o': {'long' : 'modules',     'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'packages',    'fold' : 1, 'stl' : 0},
    \ 'c': {'long' : 'classes',     'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'grammars',    'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'methods',     'fold' : 0, 'stl' : 1},
    \ 'r': {'long' : 'roles',       'fold' : 0, 'stl' : 1},
    \ 'u': {'long' : 'rules',       'fold' : 0, 'stl' : 0},
    \ 'b': {'long' : 'submethods',  'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'subroutines', 'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'tokens',      'fold' : 0, 'stl' : 0},
    \ }

let g:vista#types#uctags#perl6# = s:types6
./autoload/vista/types/uctags/php.vim	[[[1
34

" PHP {{{1
let s:types = {}

let s:types.lang = 'php'

let s:types.kinds = {
    \ 'n': {'long' : 'namespaces',           'fold' : 0, 'stl' : 0},
    \ 'a': {'long' : 'use aliases',          'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'constant definitions', 'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'interfaces',           'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'traits',               'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',              'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',            'fold' : 1, 'stl' : 0},
    \ 'f': {'long' : 'functions',            'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '\\'

let s:types.kind2scope = {
    \ 'c' : 'class',
    \ 'n' : 'namespace',
    \ 'i' : 'interface',
    \ 't' : 'trait',
    \ }

let s:types.scope2kind = {
    \ 'class'     : 'c',
    \ 'namespace' : 'n',
    \ 'interface' : 'i',
    \ 'trait'     : 't',
    \ }

let g:vista#types#uctags#php# = s:types
./autoload/vista/types/uctags/proto.vim	[[[1
16

" Protobuf {{{1
let s:types = {}

let s:types.lang = 'Protobuf'

let s:types.kinds = {
    \ 'p': {'long' : 'packages',       'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'messages',       'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'fields',         'fold' : 0, 'stl' : 0},
    \ 'e': {'long' : 'enum constants', 'fold' : 0, 'stl' : 0},
    \ 'g': {'long' : 'enum types',     'fold' : 0, 'stl' : 0},
    \ 's': {'long' : 'services',       'fold' : 0, 'stl' : 0},
    \ }

let g:vista#types#uctags#proto# = s:types
./autoload/vista/types/uctags/python.vim	[[[1
28

" Python {{{1
let s:types = {}

let s:types.lang = 'python'

let s:types.kinds     = {
    \ 'i': {'long' : 'modules',   'fold' : 1, 'stl' : 0},
    \ 'c': {'long' : 'classes',   'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions', 'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'members',   'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables', 'fold' : 0, 'stl' : 0}
    \ }

let s:types.sro        = '.'
let s:types.kind2scope = {
    \ 'c' : 'class',
    \ 'f' : 'function',
    \ 'm' : 'member'
    \ }

let s:types.scope2kind = {
    \ 'class'    : 'c',
    \ 'function' : 'f',
    \ 'member'   : 'm'
    \ }

let g:vista#types#uctags#python# = s:types
./autoload/vista/types/uctags/r.vim	[[[1
15

" R {{{1
let s:types = {}

let s:types.lang = 'R'

let s:types.kinds = {
    \ 'l': {'long' : 'libraries',          'fold' : 1, 'stl' : 0},
    \ 'f': {'long' : 'functions',          'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'sources',            'fold' : 0, 'stl' : 0},
    \ 'g': {'long' : 'global variables',   'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'function variables', 'fold' : 0, 'stl' : 0},
    \ }

let g:vista#types#uctags#r# = s:types
./autoload/vista/types/uctags/rexx.vim	[[[1
11

" REXX {{{1
let s:types = {}

let s:types.lang = 'rexx'

let s:types.kinds     = {
    \ 's': {'long' : 'subroutines', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#rexx# = s:types
./autoload/vista/types/uctags/ruby.vim	[[[1
28

" Ruby {{{1
let s:types = {}

let s:types.lang = 'ruby'

let s:types.kinds = {
    \ 'm': {'long' : 'modules',           'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',           'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'methods',           'fold' : 0, 'stl' : 1},
    \ 'S': {'long' : 'singleton methods', 'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '.'

let s:types.kind2scope = {
    \ 'c' : 'class',
    \ 'f' : 'method',
    \ 'm' : 'module'
    \ }

let s:types.scope2kind = {
    \ 'class'  : 'c',
    \ 'method' : 'f',
    \ 'module' : 'm'
    \ }

let g:vista#types#uctags#ruby# = s:types
./autoload/vista/types/uctags/rust.vim	[[[1
42
let s:types = {}

let s:types.lang = 'rust'

let s:types.kinds = {
    \ 'n': {'long' : 'module',          'fold' : 1, 'stl' : 0},
    \ 's': {'long' : 'struct',          'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'trait',           'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'implementation',  'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'function',        'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'enum',            'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'type alias',      'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'global variable', 'fold' : 0, 'stl' : 1},
    \ 'M': {'long' : 'macro',           'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'struct field',    'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enum variant',    'fold' : 0, 'stl' : 1},
    \ 'P': {'long' : 'method',          'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '::'

let s:types.kind2scope = {
    \ 'n' : 'module',
    \ 's' : 'struct',
    \ 'i' : 'interface',
    \ 'c' : 'implementation',
    \ 'f' : 'function',
    \ 'g' : 'enum',
    \ 'P' : 'method',
    \ }

let s:types.scope2kind = {
    \ 'module'        : 'n',
    \ 'struct'        : 's',
    \ 'interface'     : 'i',
    \ 'implementation': 'c',
    \ 'function'      : 'f',
    \ 'enum'          : 'g',
    \ 'method'        : 'P',
    \ }

let g:vista#types#uctags#rust# = s:types
./autoload/vista/types/uctags/scheme.vim	[[[1
13

" scheme {{{1
let s:types = {}

let s:types.lang = 'scheme'

let s:types.kinds = {
  \ 'f': {'long' : 'functions', 'fold' : 0, 'stl' : 1},
  \ 's': {'long' : 'sets',      'fold' : 0, 'stl' : 1}
  \ }

" scheme racket
let g:vista#types#uctags#scheme# = s:types
./autoload/vista/types/uctags/sh.vim	[[[1
14

" Shell script {{{1
let s:types = {}

let s:types.lang = 'sh'

let s:types.kinds = {
    \ 'f': {'long' : 'functions',    'fold' : 0, 'stl' : 1},
    \ 'a': {'long' : 'aliases',      'fold' : 0, 'stl' : 0},
    \ 's': {'long' : 'script files', 'fold' : 0, 'stl' : 0}
    \ }

" sh csh zsh
let g:vista#types#uctags#sh# = s:types
./autoload/vista/types/uctags/slang.vim	[[[1
12

" SLang {{{1
let s:types = {}

let s:types.lang = 'slang'

let s:types.kinds = {
    \ 'n': {'long' : 'namespaces', 'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',  'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#slang# = s:types
./autoload/vista/types/uctags/sml.vim	[[[1
17

" SML {{{1
let s:types = {}

let s:types.lang = 'sml'

let s:types.kinds = {
    \ 'e': {'long' : 'exception declarations', 'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'function definitions',   'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'functor definitions',    'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'signature declarations', 'fold' : 0, 'stl' : 0},
    \ 'r': {'long' : 'structure declarations', 'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'type definitions',       'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'value bindings',         'fold' : 0, 'stl' : 0}
    \ }

let g:vista#types#uctags#sml# = s:types
./autoload/vista/types/uctags/sql.vim	[[[1
34

" SQL {{{1
" The SQL ctags parser seems to be buggy for me, so this just uses the
" normal kinds even though scopes should be available. Improvements
" welcome!
let s:types = {}

let s:types.lang = 'sql'

let s:types.kinds = {
    \ 'P': {'long' : 'packages',               'fold' : 1, 'stl' : 1},
    \ 'd': {'long' : 'prototypes',             'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'cursors',                'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',              'fold' : 0, 'stl' : 1},
    \ 'E': {'long' : 'record fields',          'fold' : 0, 'stl' : 1},
    \ 'L': {'long' : 'block label',            'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'procedures',             'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'subtypes',               'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'tables',                 'fold' : 0, 'stl' : 1},
    \ 'T': {'long' : 'triggers',               'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',              'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'indexes',                'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'events',                 'fold' : 0, 'stl' : 1},
    \ 'U': {'long' : 'publications',           'fold' : 0, 'stl' : 1},
    \ 'R': {'long' : 'services',               'fold' : 0, 'stl' : 1},
    \ 'D': {'long' : 'domains',                'fold' : 0, 'stl' : 1},
    \ 'V': {'long' : 'views',                  'fold' : 0, 'stl' : 1},
    \ 'n': {'long' : 'synonyms',               'fold' : 0, 'stl' : 1},
    \ 'x': {'long' : 'MobiLink Table Scripts', 'fold' : 0, 'stl' : 1},
    \ 'y': {'long' : 'MobiLink Conn Scripts',  'fold' : 0, 'stl' : 1},
    \ 'z': {'long' : 'MobiLink Properties',    'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#sql# = s:types
./autoload/vista/types/uctags/tcl.vim	[[[1
12

" Tcl {{{1
let s:types = {}

let s:types.lang = 'tcl'

let s:types.kinds = {
    \ 'n': {'long' : 'namespaces', 'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'procedures', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#tcl# = s:types
./autoload/vista/types/uctags/tex.vim	[[[1
45

" LaTeX {{{1
let s:types = {}

let s:types.lang = 'tex'

let s:types.kinds = {
    \ 'i': {'long' : 'includes',       'fold' : 1, 'stl' : 0},
    \ 'p': {'long' : 'parts',          'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'chapters',       'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'sections',       'fold' : 0, 'stl' : 1},
    \ 'u': {'long' : 'subsections',    'fold' : 0, 'stl' : 1},
    \ 'b': {'long' : 'subsubsections', 'fold' : 0, 'stl' : 1},
    \ 'P': {'long' : 'paragraphs',     'fold' : 0, 'stl' : 0},
    \ 'G': {'long' : 'subparagraphs',  'fold' : 0, 'stl' : 0},
    \ 'l': {'long' : 'labels',         'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'frame',          'fold' : 0, 'stl' : 0},
    \ 'g': {'long' : 'subframe',       'fold' : 0, 'stl' : 0}
    \ }

let s:types.sro = '""'

let s:types.kind2scope = {
    \ 'p' : 'part',
    \ 'c' : 'chapter',
    \ 's' : 'section',
    \ 'u' : 'subsection',
    \ 'b' : 'subsubsection',
    \ 'f' : 'frame',
    \ 'g' : 'subframe'
    \ }

let s:types.scope2kind = {
    \ 'part'          : 'p',
    \ 'chapter'       : 'c',
    \ 'section'       : 's',
    \ 'subsection'    : 'u',
    \ 'subsubsection' : 'b',
    \ 'frame'         : 'f',
    \ 'subframe'      : 'g'
    \ }

let s:types.sort = 0

let g:vista#types#uctags#tex# = s:types
./autoload/vista/types/uctags/vala.vim	[[[1
46

" Vala {{{1
" Vala is supported by the ctags fork provided by Anjuta, so only add the
" type if the fork is used to prevent error messages otherwise
let s:types = {}

let s:types.lang = 'vala'

let s:types.kinds = {
    \ 'e': {'long' : 'Enumerations',       'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'Enumeration values', 'fold' : 0, 'stl' : 0},
    \ 's': {'long' : 'Structures',         'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'Interfaces',         'fold' : 0, 'stl' : 1},
    \ 'd': {'long' : 'Delegates',          'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'Classes',            'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'Properties',         'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'Fields',             'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'Methods',            'fold' : 0, 'stl' : 1},
    \ 'E': {'long' : 'Error domains',      'fold' : 0, 'stl' : 1},
    \ 'r': {'long' : 'Error codes',        'fold' : 0, 'stl' : 1},
    \ 'S': {'long' : 'Signals',            'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '.'

" 'enum' doesn't seem to be used as a scope, but it can't hurt to have
" it here
let s:types.kind2scope = {
    \ 's' : 'struct',
    \ 'i' : 'interface',
    \ 'c' : 'class',
    \ 'e' : 'enum'
    \ }

let s:types.scope2kind = {
    \ 'struct'    : 's',
    \ 'interface' : 'i',
    \ 'class'     : 'c',
    \ 'enum'      : 'e'
    \ }

let g:vista#types#uctags#vala# = s:types

if executable('anjuta-tags')
  let g:vista#types#uctags#vala#.ctagsbin = 'anjuta-tags'
endif
./autoload/vista/types/uctags/vera.vim	[[[1
38

" Vera {{{1
" Why are variables 'virtual'?
let s:types = {}

let s:types.lang = 'vera'

let s:types.kinds = {
    \ 'h': {'long' : 'header files', 'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'macros',      'fold' : 1, 'stl' : 0},
    \ 'g': {'long' : 'enums',       'fold' : 0, 'stl' : 1},
    \ 'T': {'long' : 'typedefs',    'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'interfaces',  'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',     'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerators', 'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'members',     'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',   'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 'signals',     'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'tasks',       'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',   'fold' : 0, 'stl' : 0},
    \ 'p': {'long' : 'programs',    'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro        = '.' " Nesting doesn't seem to be possible

let s:types.kind2scope = {
    \ 'g' : 'enum',
    \ 'c' : 'class',
    \ 'v' : 'virtual'
    \ }

let s:types.scope2kind = {
    \ 'enum'      : 'g',
    \ 'class'     : 'c',
    \ 'virtual'   : 'v'
    \ }

let g:vista#types#uctags#vera# = s:types
./autoload/vista/types/uctags/verilog.vim	[[[1
19

" Verilog {{{1
let s:types = {}

let s:types.lang = 'verilog'

let s:types.kinds = {
    \ 'c': {'long' : 'constants',           'fold' : 0, 'stl' : 0},
    \ 'e': {'long' : 'events',              'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',           'fold' : 0, 'stl' : 1},
    \ 'm': {'long' : 'modules',             'fold' : 0, 'stl' : 1},
    \ 'b': {'long' : 'blocks',              'fold' : 0, 'stl' : 1},
    \ 'n': {'long' : 'net data types',      'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'ports',               'fold' : 0, 'stl' : 1},
    \ 'r': {'long' : 'register data types', 'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'tasks',               'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#verilog# = s:types
./autoload/vista/types/uctags/vhdl.vim	[[[1
19

" VHDL {{{1
" The VHDL ctags parser unfortunately doesn't generate proper scopes
let s:types = {}

let s:types.lang = 'vhdl'

let s:types.kinds = {
    \ 'P': {'long' : 'packages',   'fold' : 1, 'stl' : 0},
    \ 'c': {'long' : 'constants',  'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'types',      'fold' : 0, 'stl' : 1},
    \ 'T': {'long' : 'subtypes',   'fold' : 0, 'stl' : 1},
    \ 'r': {'long' : 'records',    'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'entities',   'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'functions',  'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'procedures', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#vhdl# = s:types
./autoload/vista/types/uctags/vim.vim	[[[1
14
let s:types = {}

let s:types.lang = 'vim'

let s:types.kinds = {
    \ 'n': {'long' : 'vimball filenames',  'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',          'fold' : 1, 'stl' : 0},
    \ 'f': {'long' : 'functions',          'fold' : 0, 'stl' : 1},
    \ 'a': {'long' : 'autocommand groups', 'fold' : 1, 'stl' : 1},
    \ 'c': {'long' : 'commands',           'fold' : 0, 'stl' : 0},
    \ 'm': {'long' : 'maps',               'fold' : 1, 'stl' : 0}
    \ }

let g:vista#types#uctags#vim# = s:types
./autoload/vista/types/uctags/yacc.vim	[[[1
12

" YACC {{{1
let s:types = {}

let s:types.lang = 'yacc'

let s:types.kinds = {
    \ {'short' : 'l', 'long' : 'labels', 'fold' : 0, 'stl' : 1}
    \ }

let g:vista#types#uctags#yacc# = s:types
" }}}1
./autoload/vista/types/uctags.vim	[[[1
56
let s:language_opt = {
      \ 'ant'        : ['ant'        , 'pt']            ,
      \ 'asm'        : ['asm'        , 'dlmt']          ,
      \ 'aspperl'    : ['asp'        , 'fsv']           ,
      \ 'aspvbs'     : ['asp'        , 'fsv']           ,
      \ 'awk'        : ['awk'        , 'f']             ,
      \ 'beta'       : ['beta'       , 'fsv']           ,
      \ 'c'          : ['c'          , 'dgsutvf']       ,
      \ 'cpp'        : ['c++'        , 'nvdtcgsuf']     ,
      \ 'cs'         : ['c#'         , 'dtncEgsipm']    ,
      \ 'cobol'      : ['cobol'      , 'dfgpPs']        ,
      \ 'delphi'     : ['pascal'     , 'fp']            ,
      \ 'dosbatch'   : ['dosbatch'   , 'lv']            ,
      \ 'eiffel'     : ['eiffel'     , 'cf']            ,
      \ 'erlang'     : ['erlang'     , 'drmf']          ,
      \ 'expect'     : ['tcl'        , 'cfp']           ,
      \ 'fortran'    : ['fortran'    , 'pbceiklmntvfs'] ,
      \ 'go'         : ['go'         , 'fctv']          ,
      \ 'html'       : ['html'       , 'af']            ,
      \ 'java'       : ['java'       , 'pcifm']         ,
      \ 'javascript' : ['javascript' , 'f']             ,
      \ 'lisp'       : ['lisp'       , 'f']             ,
      \ 'lua'        : ['lua'        , 'f']             ,
      \ 'make'       : ['make'       , 'm']             ,
      \ 'matlab'     : ['matlab'     , 'f']             ,
      \ 'ocaml'      : ['ocaml'      , 'cmMvtfCre']     ,
      \ 'pascal'     : ['pascal'     , 'fp']            ,
      \ 'perl'       : ['perl'       , 'clps']          ,
      \ 'php'        : ['php'        , 'cdvf']          ,
      \ 'python'     : ['python'     , 'cmf']           ,
      \ 'rexx'       : ['rexx'       , 's']             ,
      \ 'ruby'       : ['ruby'       , 'cfFm']          ,
      \ 'rust'       : ['rust'       , 'fgsmcti']     ,
      \ 'scheme'     : ['scheme'     , 'sf']            ,
      \ 'sh'         : ['sh'         , 'f']             ,
      \ 'csh'        : ['sh'         , 'f']             ,
      \ 'zsh'        : ['sh'         , 'f']             ,
      \ 'scala'      : ['scala'      , 'ctTmlp']        ,
      \ 'slang'      : ['slang'      , 'nf']            ,
      \ 'sml'        : ['sml'        , 'ecsrtvf']       ,
      \ 'sql'        : ['sql'        , 'cFPrstTvfp']    ,
      \ 'tex'        : ['tex'        , 'ipcsubPGl']     ,
      \ 'tcl'        : ['tcl'        , 'cfmp']          ,
      \ 'vera'       : ['vera'       , 'cdefgmpPtTvx']  ,
      \ 'verilog'    : ['verilog'    , 'mcPertwpvf']    ,
      \ 'vhdl'       : ['vhdl'       , 'PctTrefp']      ,
      \ 'vim'        : ['vim'        , 'avf']           ,
      \ 'yacc'       : ['yacc'       , 'l']             ,
      \ }

let s:language_opt = map(s:language_opt,
      \ 'printf(''--language-force=%s --%s-types=%s'', v:val[0], v:val[0], v:val[1])')

function! vista#types#uctags#KindsFor(filetype) abort
  return get(s:language_opt, a:filetype, '')
endfunction
./autoload/vista/util.vim	[[[1
276
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:path_separator = has('win32') ? '\' : '/'

function! vista#util#MaxLen() abort
  let l:maxlen = &columns * &cmdheight - 2
  let l:maxlen = &showcmd ? l:maxlen - 11 : l:maxlen
  let l:maxlen = &ruler ? l:maxlen - 18 : l:maxlen
  return l:maxlen
endfunction

" Avoid hit-enter prompt when the message being echoed is too long.
function! vista#util#Truncate(msg) abort
  let maxlen = vista#util#MaxLen()
  return len(a:msg) < maxlen ? a:msg : a:msg[:maxlen-3].'...'
endfunction

if exists('*trim')
  function! vista#util#Trim(str) abort
    return trim(a:str)
  endfunction
else
  function! vista#util#Trim(str) abort
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
  endfunction
endif

" Set the file path as the first line if possible.
function! s:PrependFpath(lines) abort
  if exists('g:vista.source.fpath')
    let width = winwidth(g:vista.winnr())
    let fpath = g:vista.source.fpath
    " Make the path relative to current directory.
    let fpath = fnamemodify(fpath, ':p:.')
    " Shorten the file path if it's too long
    if len(fpath) > width
      let fpath = '..'.fpath[len(fpath)-width+4 : ]
    endif
    return [fpath, ''] + a:lines
  endif

  return a:lines
endfunction

if has('nvim')
  function! s:SetBufline(bufnr, lines) abort
    call nvim_buf_set_lines(a:bufnr, 0, -1, 0, a:lines)
  endfunction

  function! vista#util#JobStop(jobid) abort
    silent! call jobstop(a:jobid)
  endfunction

else
  function! s:SetBufline(bufnr, lines) abort
    let cur_lines = getbufline(a:bufnr, 1, '$')
    call setbufline(a:bufnr, 1, a:lines)
    if len(cur_lines) > len(a:lines)
      silent call deletebufline(a:bufnr, len(a:lines)+1, len(cur_lines)+1)
    endif
  endfunction

  function! vista#util#JobStop(jobid) abort
    silent! call job_stop(a:jobid)
  endfunction
endif

" Using s:SetBufline() runes into the internal error E315.
" I don't know why. So we jump to the vista window
" and then replace the lines.
function! s:SafeSetBufline(bufnr, lines) abort
  let lines = s:PrependFpath(a:lines)

  let bufnr = bufnr('')
  call setbufvar(bufnr, '&readonly', 0)
  call setbufvar(bufnr, '&modifiable', 1)

  silent 1,$delete _
  call setline(1, lines)

  call setbufvar(bufnr, '&readonly', 1)
  call setbufvar(bufnr, '&modifiable', 0)

  let filetype = vista#sidebar#WhichFileType()
  call setbufvar(bufnr, '&filetype', filetype)

  call vista#ftplugin#Set()
  " Reload vista syntax as you may switch between serveral
  " executives/extensions.
  "
  " rst shares the same syntax with vista_markdown.
  if g:vista.source.filetype() ==# 'rst'
    execute 'runtime! syntax/vista_markdown.vim'
  else
    execute 'runtime! syntax/'.filetype.'vim'
  endif
endfunction

function! vista#util#SetBufline(bufnr, lines) abort
  call vista#win#Execute(g:vista.winnr(), function('s:SafeSetBufline'), a:bufnr, a:lines)
endfunction

function! vista#util#Join(...) abort
  return join(a:000, '')
endfunction

" Change coc, ctags, lcn, vim_lsp to Coc, Ctags, Lcn, VimLsp
function! vista#util#ToCamelCase(s) abort
  return substitute(a:s, '\(^\l\+\)\|_\(\l\+\)', '\u\1\2', 'g')
endfunction

" Blink current line under cursor, from junegunn/vim-slash
function! vista#util#Blink(times, delay, ...) abort
  let s:blink = { 'ticks': 2 * a:times, 'delay': a:delay }
  let s:hi_pos = get(a:000, 0, line('.'))

  if !exists('#VistaBlink')
    augroup VistaBlink
      autocmd!
      autocmd BufWinEnter * call s:blink.clear()
    augroup END
  endif

  function! s:blink.tick(_) abort
    let self.ticks -= 1
    let active = self == s:blink && self.ticks > 0

    if !self.clear() && active && &hlsearch
      let w:vista_blink_id = matchaddpos('IncSearch', [s:hi_pos])
    endif
    if active
      call timer_start(self.delay, self.tick)
    endif
  endfunction

  function! s:blink.clear() abort
    if exists('w:vista_blink_id')
      call matchdelete(w:vista_blink_id)
      unlet w:vista_blink_id
      return 1
    endif
  endfunction

  call s:blink.clear()
  call s:blink.tick(0)
  return ''
endfunction

function! vista#util#Warning(msg) abort
  echohl WarningMsg
  echom  '[vista.vim] '.a:msg
  echohl NONE
endfunction

function! vista#util#Retriving(executive) abort
  echohl WarningMsg
  echom '[Vista.vim] '
  echohl NONE

  echohl Function
  echon a:executive
  echohl NONE

  echohl Type
  echon  ' is retriving symbols ..., please try again later'
  echohl NONE
endfunction

function! vista#util#Complete(A, L, P) abort
  let args = split(a:L)
  if !empty(args)
    if args[-1] ==# 'finder'
      return join(g:vista#executives, "\n")
    elseif args[-1] ==# 'finder!'
      return join(['ctags'], "\n")
    endif
  endif
  return join(g:vista#executives + ['finder', 'finder!'], "\n")
endfunction

" Return the lower indent line number
function! vista#util#LowerIndentLineNr() abort
  let linenr = line('.')
  let indent = indent(linenr)
  while linenr > 0
    let linenr -= 1
    if indent(linenr) < indent
      return linenr
    endif
  endwhile
  return 0
endfunction

" Return the nearest method of function.
"
" array: List of Dict, composed of Method or Function symbols
" target: current line number in the source buffer
function! vista#util#BinarySearch(array, target, cmp_key, ret_key) abort
  let [array, target] = [a:array, a:target]

  let low = 0
  let high = len(array) - 1

  while low <= high
    let mid = (low + high) / 2
    if array[mid][a:cmp_key] == target
      let found = array[mid]
      return empty(a:ret_key) ? found : get(found, a:ret_key, v:null)
    elseif array[mid][a:cmp_key] > target
      let high = mid - 1
    else
      let low = mid + 1
    endif
  endwhile

  if low == 0
    return v:null
  endif

  " If no exact match, prefer the previous nearest one.
  if g:vista_find_absolute_nearest_method_or_function
    if abs(array[low][a:cmp_key] - target) < abs(array[low - 1][a:cmp_key] - target)
      let found = array[low]
    else
      let found = array[low - 1]
    endif
  else
    let found = array[low - 1]
  endif

  return empty(a:ret_key) ? found : get(found, a:ret_key, v:null)
endfunction

if has('nvim')
  let s:cache_dir = stdpath('cache')
elseif exists('$XDG_CACHE_HOME')
  let s:cache_dir = $XDG_CACHE_HOME
else
  let s:cache_dir = $HOME . s:path_separator . '.cache'
endif

if s:cache_dir !~# s:path_separator.'$'
  let s:cache_dir .= s:path_separator
endif

let s:vista_cache_dir = s:cache_dir.'vista'.s:path_separator

" Return the directory for caching the tmp data.
" with the ending /.
function! vista#util#CacheDirectory() abort
  if !isdirectory(s:vista_cache_dir)
    call mkdir(s:vista_cache_dir, 'p')
  endif

  return s:vista_cache_dir
endfunction

" Wrap the native cursor() function, with current position
" pushed to the jumplist before applying cursor()
function! vista#util#Cursor(...) abort
  " Push the current position to the jumplist
  normal! m'
  silent call call('cursor', a:000)
endfunction

" Try initializing the key of dict to be list with the value,
" otherwise append the value.
function! vista#util#TryAdd(dict, key, value) abort
  if has_key(a:dict, a:key)
    call add(a:dict[a:key], a:value)
  else
    let a:dict[a:key] = [a:value]
  endif
endfunction
./autoload/vista/win.vim	[[[1
74
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:has_floating_win = exists('*nvim_open_win')
let s:has_popup = exists('*popup_create')

function! vista#win#CloseFloating() abort
  if s:has_floating_win
    call vista#floating#Close()
  elseif s:has_popup
    call vista#popup#Close()
  endif
endfunction

function! vista#win#FloatingDisplay(...) abort
  if s:has_popup
    call call('vista#popup#DisplayAt', a:000)
  elseif s:has_floating_win
    call call('vista#floating#DisplayAt', a:000)
  else
    call vista#error#Need('neovim compiled with floating window support or vim compiled with popup feature')
  endif
endfunction

" Show the folded content if in a closed fold.
function! vista#win#ShowFoldedDetailInFloatingIsOk() abort
  if foldclosed('.') != -1
    if s:has_floating_win || s:has_popup
      let foldclosed_end = foldclosedend('.')
      let curlnum = line('.')
      let lines = getbufline(g:vista.bufnr, curlnum, foldclosed_end)

      if s:has_floating_win
        call vista#floating#DisplayRawAt(curlnum, lines)
      elseif s:has_popup
        call vista#popup#DisplayRawAt(curlnum, lines)
      endif

      return v:true
    endif
  endif
  return v:false
endfunction

function! vista#win#FloatingDisplayOrPeek(lnum, tag) abort
  if s:has_floating_win || s:has_popup
    call vista#win#FloatingDisplay(a:lnum, a:tag)
  else
    call vista#source#PeekSymbol(a:lnum, a:tag)
  endif
endfunction

" call Run in the window win unsilently, unlike win_execute() which uses
" silent by default.
"
" CocAction only fetch symbols for current document, no way for specify the other at the moment.
" workaround for #52
"
" see also #71
"
" NOTE: a:winnr is winnr, not winid. Ref https://github.com/liuchengxu/vim-clap/issues/371
function! vista#win#Execute(winnr, Run, ...) abort
  if winnr() != a:winnr
    noautocmd execute a:winnr.'wincmd w'
    let l:switch_back = 1
  endif

  call call(a:Run, a:000)

  if exists('l:switch_back')
    noautocmd wincmd p
  endif
endfunction
./autoload/vista.vim	[[[1
238
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:cur_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! vista#FindItemsUnderDirectory(dir) abort
  return map(split(globpath(a:dir, '*'), '\n'), 'fnamemodify(v:val, '':t:r'')')
endfunction

let g:vista#finders = vista#FindItemsUnderDirectory(s:cur_dir.'/vista/finder')
let g:vista#executives = vista#FindItemsUnderDirectory(s:cur_dir.'/vista/executive')
let g:vista#extensions = vista#FindItemsUnderDirectory(s:cur_dir.'/vista/extension')

let s:ignore_list = ['vista', 'vista_kind', 'nerdtree', 'startify', 'tagbar', 'fzf', 'gitcommit', 'coc-explorer']

" Skip special buffers, filetypes.
function! vista#ShouldSkip() abort
  if exists('g:vista.skip_once_flag') && g:vista.skip_once_flag
    let g:vista.skip_once_flag = v:false
    return v:true
  else
    return !empty(&buftype)
          \ || empty(&filetype)
          \ || index(s:ignore_list, &filetype) > -1
  endif
endfunction

" Ignore some kinds of tags/symbols which is done at the parser step.
function! vista#ShouldIgnore(kind) abort
  return exists('g:vista_ignore_kinds') && index(g:vista_ignore_kinds, a:kind) != -1
endfunction

function! vista#SetProvider(provider) abort
  if get(g:vista, 'skip_set_provider', v:false)
    let g:vista.skip_set_provider = v:false
    return
  endif
  let g:vista.provider = a:provider
  call vista#statusline#Render()
endfunction

function! vista#OnExecute(provider, AUF) abort
  call vista#SetProvider(a:provider)
  call vista#autocmd#Init('Vista'.vista#util#ToCamelCase(a:provider), a:AUF)
endfunction

" Sort the items under some kind alphabetically.
function! vista#Sort() abort
  if !has_key(g:vista, 'sort')
    let g:vista.sort = v:true
  else
    let g:vista.sort = !g:vista.sort
  endif

  let cache = vista#executive#{g:vista.provider}#Cache()

  let cur_pos = getpos('.')

  call vista#sidebar#Reload(cache)

  if cur_pos != getpos('.')
    call setpos('.', cur_pos)
  endif
endfunction

" coc.nvim returns no symbols if you just send the request on the event.
" We use a delayed update instead.
" Maybe also useful for the other LSP clients.
function! vista#AutoUpdateWithDelay(Fn, Args) abort
  call timer_start(30, { -> call(a:Fn, a:Args) })
endfunction

function! vista#GetExplicitExecutive(filetype) abort
  if exists('g:vista_'.a:filetype.'_executive')
    return g:vista_{a:filetype}_executive
  endif

  if has_key(g:vista_executive_for, a:filetype)
    return g:vista_executive_for[a:filetype]
  endif

  return v:null
endfunction

function! vista#GetExplicitExecutiveOrDefault() abort
  let explicit_executive = vista#GetExplicitExecutive(&filetype)

  if explicit_executive isnot# v:null
    let executive = explicit_executive
  else
    let executive = g:vista_default_executive
  endif

  return executive
endfunction

function! s:TryInitializeVista() abort
  if !exists('g:vista')
    call vista#init#Api()
  endif
endfunction

call s:TryInitializeVista()

" TODO: vista is designed to have an instance per tab, but it does not work as
" expected now.
" augroup VistaInitialize
  " autocmd!
  " ++once needs 8.1.1113, it's safer but requires newer vim.
  " autocmd TabNew * ++once call s:TryInitializeVista()
" augroup END

" Used for running vista.vim on startup
function! vista#RunForNearestMethodOrFunction() abort
  let [bufnr, winnr, fname, fpath] = [bufnr('%'), winnr(), expand('%'), expand('%:p')]
  call vista#source#Update(bufnr, winnr, fname, fpath)
  call vista#executive#{g:vista_default_executive}#Execute(v:false, v:false)
  let g:__vista_initial_run_find_nearest_method = 1

  if !exists('#VistaMOF')
    call vista#autocmd#InitMOF()
  endif
endfunction

let s:logging_enabled = exists('g:vista_log_file') && !empty(g:vista_log_file)

function! vista#Debug(...) abort
  if s:logging_enabled
    call writefile([strftime('%Y-%m-%d %H:%M:%S ').json_encode(a:000)], g:vista_log_file, 'a')
  endif
endfunction

function! s:HandleSingleArgument(arg) abort
  if index(g:vista#executives, a:arg) > -1
    call vista#executive#{a:arg}#Execute(v:false, v:true)
    let g:vista.lnum = line('.')
  elseif a:arg ==# 'finder'
    call vista#finder#Dispatch(v:false, '', '')
  elseif a:arg ==# 'finder!'
    call vista#finder#Dispatch(v:true, '', '')
  elseif a:arg ==# 'toc'
    if vista#toc#IsSupported(&filetype)
      call vista#toc#Run()
    else
      return vista#error#For('Vista toc', &filetype)
    endif
  elseif a:arg ==# 'focus'
    call vista#sidebar#ToggleFocus()
  elseif a:arg ==# 'show'
    if vista#sidebar#IsOpen()
      call vista#cursor#ShowTag()
    else
      call vista#sidebar#Open()
      let g:vista.lnum = line('.')
    endif
  elseif a:arg ==# 'info'
    call vista#debugging#Info()
  elseif a:arg ==# 'info+'
    call vista#debugging#InfoToClipboard()
  else
    return vista#error#Expect('Vista [finder] [EXECUTIVE]')
  endif
endfunction

function! s:HandleArguments(fst, snd) abort
  if a:fst !~# '^finder'
    return vista#error#Expect('Vista finder[!] [EXECUTIVE]')
  endif
  " Vista finder [finder:executive]
  if stridx(a:snd, ':') > -1
    if !exists('s:finder_args_pattern')
      let s:finder_args_pattern = '^\('.join(g:vista#finders, '\|').'\):\('.join(g:vista#executives, '\|').'\)$'
    endif
    if a:snd =~? s:finder_args_pattern
      let matched = matchlist(a:snd, s:finder_args_pattern)
      let finder = matched[1]
      let executive = matched[2]
    else
      return vista#error#InvalidFinderArgument()
    endif
  else
    " Vista finder [finder]/[executive]
    if index(g:vista#finders, a:snd) > -1
      let finder = a:snd
      let executive = ''
    elseif index(g:vista#executives, a:snd) > -1
      let finder = ''
      let executive = a:snd
    else
      return vista#error#InvalidFinderArgument()
    endif
  endif
  call vista#finder#Dispatch(v:false, finder, executive)
endfunction

" Main entrance to interact with vista.vim
function! vista#(bang, ...) abort
  " `:Vista focus` should be handled before updating the source buffer info.
  if a:0 == 1 && a:1 ==# 'focus'
    call vista#sidebar#ToggleFocus()
    return
  endif

  let [bufnr, winnr, fname, fpath] = [bufnr('%'), winnr(), expand('%'), expand('%:p')]
  let g:vista.source.winid = win_getid()
  call vista#source#Update(bufnr, winnr, fname, fpath)

  if a:bang
    if a:0 == 0
      call vista#sidebar#Close()
      return
    elseif a:0 == 1
      if a:1 ==# '!'
        let g:vista.lnum = line('.')
        call vista#sidebar#Toggle()
        return
      else
        return vista#error#Expect('Vista!!')
      endif
    else
      return vista#error#Expect('Vista![!]')
    endif
  endif

  if a:0 == 0
    call vista#sidebar#Open()
    return
  endif

  if a:0 == 1
    call s:HandleSingleArgument(a:1)
  elseif a:0 == 2
    call s:HandleArguments(a:1, a:2)
  elseif a:0 > 0
    return vista#error#('Too many arguments for Vista')
  endif
endfunction
./ci/install_docker.sh	[[[1
10
#!/usr/bin/env bash

# Install Docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
docker --version
./ci/run-vint	[[[1
23
#!/usr/bin/env bash

set -eu

image=liuchengxu/vista.vim

exit_code=0

docker_flags=(--rm -v "$PWD:/testplugin" -v "$PWD/test:/home" -w /testplugin "$image")

echo '----------------------------------------'
echo 'Running Vint...'
echo '----------------------------------------'
echo 'Vint warnings/errors follow:'
echo

set -o pipefail
docker run -a stdout "${docker_flags[@]}" vint -w . || exit_code=$?
set +o pipefail

echo

exit $exit_code
./doc/vista.txt	[[[1
581
*vista.txt*   --  View and search LSP symbols, tags in Vim and NeoVim.
*vista*

================================================================================
CONTENTS                                                          *vista-contents*

1. Vista.vim.....................................................|vista-vista.vim|
    1.1. Introduction.........................................|vista-introduction|
    1.2. Features.................................................|vista-features|
    1.3. Requirement...........................................|vista-requirement|
    1.4. Usage.......................................................|vista-usage|
        1.4.1. Commands...........................................|vista-commands|
        1.4.2. Options.............................................|vista-options|
        1.4.3. Key Mappings...................................|vista-key-mappings|
    1.5. Contributing.........................................|vista-contributing|
    1.6. License...................................................|vista-license|

================================================================================
VISTA.VIM                                                        *vista-vista.vim*

View and search LSP symbols, tags in Vim/NeoVim.

================================================================================
INTRODUCTION                                                  *vista-introduction*

I initially started {vista.vim}{1} with an intention of replacing {tagbar}{2} as
it seemingly does not have a plan to support the promising
{Language Server Protocol}{3} and async processing.

Vista.vim can also be a symbol navigator similar to {ctrlp-funky}{4}. Last but
not least, one important goal of vista.vim is to support LSP symbols, which
understands the semantics instead of the regex only.

{1} https://github.com/liuchengxu/vista.vim
{2} https://github.com/majutsushi/tagbar
{3} https://github.com/Microsoft/language-server-protocol
{4} https://github.com/tacahiroy/ctrlp-funky

================================================================================
FEATURES                                                          *vista-features*

[x] View tags and LSP symbols in a sidebar.
    [x] universal-ctags (https://github.com/universal-ctags/ctags)
    [x] ale (https://github.com/w0rp/ale)
    [x] vim-lsp (https://github.com/prabirshrestha/vim-lsp)
    [x] coc.nvim (https://github.com/neoclide/coc.nvim)
    [x] LanguageClient-neovim (https://github.com/autozimu/LanguageClient-neovim)
    [x] vim-lsc (https://github.com/natebosch/vim-lsc)
    [x] nvim-lsp (https://github.com/neovim/neovim)
[x] Finder for tags and LSP symbols.
    [x] fzf (https://github.com/junegunn/fzf)
[x] Display decent detailed symbol info in cmdline.
[x] Jump to the tag/symbol from vista sidebar with a blink.
[x] Update automatically when switching between buffers.
[x] Update asynchonously in the background when `+job` avaliable.
[x] Find the nearest method or function to the cursor, which could be
    integrated into the statusline.
[x] Highlight current tag/symbol.
[x] Show the visibility (public/private) of tags.
[x] Tree viewer for hierarchy data, only works for ctags for now.

Notes:

*   The feature of finder in vista.vim is a bit like `:BTags` or `:Tags` in {fzf.vim}{5},
    `:CocList` in coc.nvim, `:LeaderfBufTag` in {leaderf.vim}{6}, etc. You can choose
    whichever you like.

*   I personally don't use all the features I have listed. Hence some of them
    may be on the TODOs forever :(.

{5} https://github.com/junegunn/fzf.vim
{6} https://github.com/Yggdroot/LeaderF

================================================================================
REQUIREMENT                                                    *vista-requirement*

I don't know the mimimal supported version. But if you only care about the ctags
related feature, vim 7.4.1154+ should be enough.

Otherwise, if you want to try any LSP related features, then you certainly need
some plugins to retrive the LSP symbols, e.g., coc.nvim. When you have these
LSP plugins setted up, vista.vim should be ok to go as well.

In addition, if you want to search the symbols via fzf, you will have to install
it first.

{7} https://github.com/junegunn/fzf

================================================================================
USAGE                                                                *vista-usage*

--------------------------------------------------------------------------------
COMMANDS                                                          *vista-commands*

Vista                                                                      *Vista*

  Open vista window for viewing tags or LSP symbols.

  `:Vista`           same with `:Vista ctags` .

  `:Vista show`      jump to the tag nearby the current cursor in vista window.
                   This is for ctags `default` renderer only.

  `:Vista toc`       show table of contents of the markdown file.

                                                                     *vista-focus*

  `:Vista focus`     jump back and forth between the vista sidebar and the source
                   code window.

                                                                 *vista-executive*

  `:Vista coc`       open vista window based on coc.nvim.

  `:Vista ale`       open vista window based on ale.

  `:Vista lcn`       open vista window based on LanguageClient-neovim.

  `:Vista ctags`     open vista window based on ctags.

  `:Vista vim_lsp`   open vista window based on vim-lsp.

  `:Vista vim_lsc`   open vista window based on vim-lsc.

  `:Vista nvim_lsp`  open vista window based on nvim-lsp.

                                                                    *vista-finder*

  `:Vista finder`   same with `:Vista finder fzf:ctags` .

  `:Vista finder!`  search tags recursively.
                  Note: it's still experimental.
                  What's more, it may be very slow to generate all tags
                  in a whole project.

  `:Vista finder [finder:executive]`
                  You can specify either the finder or the
                  executive, or the both, e.g., `:Vista finder skim:ctags` .

                  Specify the finder or executive, e.g.,:

                  `:Vista finder fzf`  same with `:Vista finder fzf:ctags` .

                  `:Vista finder coc`  same with `:Vista finder fzf:coc` .

  `:Vista finder clap` synonysm for `:Clap tags`
                                                                      *vista-info*

  `:Vista info`     print information about vista.vim, including the explicit
                  global variables, autocmds.

  `:Vista info+`    copy the output of `:Vista info` to your clipboard, may
                  fail in some cases.

Vista!                                                                    *Vista!*

  Close the vista view window if already opened.

Vista!!                                                                  *Vista!!*

  Toggle the vista view window.

--------------------------------------------------------------------------------
OPTIONS                                                            *vista-options*

g:vista_sidebar_position                                *g:vista_sidebar_position*

  Type: |String|
  Default: `vertical botright`

  This variable controls the position to open the vista sidebar only.
  On the right by default. Change to `vertical topleft` to open on the left.

  Please use |g:vista_sidebar_open_cmd| if you want to have a full control of
  the window opening.

g:vista_sidebar_width                                      *g:vista_sidebar_width*

  Type: |Number|
  Default: `30`

  This variable controls the width of vista sidebar only.

  Please use |g:vista_sidebar_open_cmd| if you want to have a full control of
  the window opening.

g:vista_sidebar_open_cmd                                *g:vista_sidebar_open_cmd*

  Type: |String|
  Default: `undefined`

  This variable controls the command used for openning the vista sidebar
  window.

  Open the sidebar in current split with width 30:
>
  let g:vista_sidebar_open_cmd = '30vsplit'
<
g:vista_sidebar_keepalt                                  *g:vista_sidebar_keepalt*

  Type: |Number|
  Default: `0`

  Set this option to `1` to keep the alternate buffer when opening vista
  sidebar. See `:h keepalt` for more information.

g:vista_fold_toggle_icons                              *g:vista_fold_toggle_icons*

  Type: |List|
  Default: `['▼', '▶']`

  This variable controls the icons used to indicate open or close folds.

g:vista_echo_cursor                                          *g:vista_echo_cursor*

  Type: |Number|
  Default: `1`

  Set this option to `0` to disable echoing when the cursor moves.
>
g:vista_cursor_delay                                        *g:vista_cursor_delay*

  Type: |Number|
  Default: `400`

  Time delay for showing detailed symbol info at current cursor.

g:vista_echo_cursor_strategy                        *g:vista_echo_cursor_strategy*

  Type: |String|
  Default: `echo`

  How to show the detailed formation of current cursor symbol. Avaliable
  options:

  `echo`         - echo in the cmdline.
  `scroll`       - make the source line of current tag at the center of the
                 window.
  `floating_win` - display in neovim's floating window or vim's popup window.
                 See if you have neovim's floating window support via
                 `:echo exists('*nvim_open_win')` or vim's popup feature
                 via `:echo exists('*popup_create')`
  `both`         - both `echo` and `floating_win` if it's avaliable otherwise
                 `scroll` will be used.

g:vista_update_on_text_changed                    *g:vista_update_on_text_changed*

  Type: |Number|
  Default: `0`

  Update the vista on |TextChanged| and |TextChangedI|.

g:vista_update_on_text_changed_delay         *g:vista_update_on_text_changed_delay*

  Type: |Number|
  Default: `500`

  Time delay for updating the vista on |TextChanged| and |TextChangedI|.

g:vista_close_on_jump                                      *g:vista_close_on_jump*

  Type: |Number|
  Default: `0`

  Set this option to `1` to close the vista window automatically
  close when you jump to a symbol.

g:vista_close_on_fzf_select                          *g:vista_close_on_fzf_select*

  Type: |Number|
  Default: `0`

  Close the vista window when you select an item from the fzf search window.
>
g:vista_stay_on_open                                        *g:vista_stay_on_open*

  Type: |Number|
  Default: `1`

  Move to the vista window when it is opened. Set this option to `0` to stay
  in current windown when opening the vista sidebar.
>
g:vista_blink                                                      *g:vista_blink*

  Type: |List|
  Default: `[2, 100]`

  By default blinking cursor 2 times with 100ms interval after jumping to
  the source line of tag.Disable blinking by setting it to `[0, 0]` .
>
g:vista_top_level_blink                                  *g:vista_top_level_blink*

  Type: |List|
  Default: `[2, 100]`

  By default blinking cursor 2 times with 100ms interval after
  jumping to top-level tag. Disable blinking by setting it to `[0, 0]` .
>
g:vista_icon_indent                                          *g:vista_icon_indent*

  Type: |List|
  Default: `['└ ', '│ ']`

  How each level is indented and what to prepend. This could make
  the display more compact or more spacious.

  Note: this option only works the LSP executives, doesn't work for `:Vista ctags` .
>
g:vista_default_executive                              *g:vista_default_executive*

  Type: |String|
  Default: `ctags`

  Executive used when opening vista sidebar without specifying it. This also
  applys to the vista finder.

  See all the avaliable executives via `:echo g:vista#executives` .

g:vista_executive_for                                      *g:vista_executive_for*

  Type: |Dict|
  Default: `{}`

  Set the executive for some filetypes explicitly, which is useful for setting
  `ctags` as the default executive, whereas you prefer to use LSP for some
  filetypes when you ensure that the related LSP server has been installed.

  The rationale is the LSP server has to be installed first explicitly and
  people normally only install a few frequently used ones, but ctags supports
  much more languages by default.
  >
  let g:vista_default_executive = 'ctags'

  let g:vista_executive_for = {
      \ 'cpp': 'vim_lsp',
      \ 'php': 'vim_lsp',
      \ }
<
  You can also set `toc` or some extension name for markdown like document to
  use the builtin toc extension in vista.vim. For `toc`, it actuallys derives
  the extension using the `&filetype`.
  >
  " Use the markdown extension for vimwiki and pandoc filetype.
  let g:vista_executive_for = {
      \ 'vimwiki': 'markdown',
      \ 'pandoc': 'markdown',
      \ 'markdown': 'toc',
      \ }

g:vista_{&filetype}_executive                   *g:vista_{&filetype}_executive*

  Type: |String|
  Default: `''`

  The goal of this option is similar to |g:vista_executive_for|, but with
  higher priority if you set the same filetype in `g:vista_executive_for`.
  vista.vim will check `g:vista_{&filetype}_executive` first and then
  `g:vista_executive_for`. >

  let g:vista_cpp_executive = 'vim_lsp'

  " Use the markdown extension for vimwiki as if you are using the
  " standard markdown syntax in vimwiki.
  let g:vista_vimwiki_executive = 'markdown'

g:vista_ctags_executable                                *g:vista_ctags_executable*

  Type: |String|
  Default: `ctags`

  The executable to run ctags.

g:vista_ctags_cmd                                              *g:vista_ctags_cmd*

  Type: |Dictionary|
  Default: `{}`

  Declare the command including the executable and options
  used to generate ctags output for some certain filetypes.
  The file path will be appened to your custom command.
  For example:
  >
  let g:vista_ctags_cmd = {
      \ 'haskell': 'hasktags -o - -c',
      \ }

g:vista_ctags_project_opts                                *g:vista_ctags_project_opts*

  Type: |String|
  Default: ''

  ctags options to use when generating project tags.
  Note: it's still experimental.

g:vista_fzf_preview                                          *g:vista_fzf_preview*

  Type: |List|
  Default: `[]`

  To enable fzf's preview window set g:vista_fzf_preview.
  The elements of g:vista_fzf_preview will be passed as arguments
  to `fzf#vim#with_preview()` .
  For example:
  >
  let g:vista_fzf_preview = ['right:50%']

g:vista_fzf_opt                                                  *g:vista_fzf_opt*

  Type: |List|
  Default: `[]`

  Append options to `fzf#run()`.

g:vista_keep_fzf_colors                                   *g:vista_keep_fzf_colors*

  Type: |Number|
  Default: `0`

  Set this variable to `1` to keep the original |g:fzf_colors| when using fzf
  finder in vista.vim.

g:vista_finder_alternative_executives      *g:vista_finder_alternative_executives*

  Type: |List|
  Default: `['coc']`

  Fall back to other executives if the specified one gives empty data.
  This is useful if you want to switch to `ctags` when LSP is not usable.
  By default it's all the provided executives excluding the tried one.

g:vista_disable_statusline                            *g:vista_disable_statusline*

  Type: |Number|
  Default: `exists('g:loaded_airline') || exists('g:loaded_lightline')`

  Vista.vim has a builtin statusline renderer, which may cause some problems
  if you use other statusline plugins at the same time. Hence it's disabled
  by default if you have installed airline or lightline.

g:vista_highlight_whole_line                        *g:vista_highlight_whole_line*

  Type: |Number|
  Default: `0`

  By default vista.vim will try to highlight the tag precisely in the vista window.
  Set this to `1` to always higlight the whole line.


g:vista_floating_border                      *g:vista_floating_border*

  Type: |String|
  Default: `none`

  See `nvim_open_win` for border options that may be used.

g:vista_floating_delay                                    *g:vista_floating_delay*

  Type: |Number|
  Default: 100

  Given any integer, this option controls the number of milliseconds before
  vista will show a popup or floating win of the target line context near the cursor.

g:vista#renderer#enable_icon                        *g:vista#renderer#enable_icon*

  Type: |Number|
  Default: `exists('g:vista#renderer#icons') || exists('g:airline_powerline_fonts')`

  Add pretty symbols for the kind of tags or LSP symbols.

g:vista#renderer#enable_kind                        g:vista#renderer#enable_kind

  Type: |Number|
  Default: !g:vista#renderer#enable_icon

  Show textual kind of tags or LSP symbols.

g:vista_enable_markdown_extension              *g:vista_enable_markdown_extension*

  Type: |Number|
  Default: `1`

  Use markdown extension instead of the ctags executive.

g:vista_ignore_kinds                                        *g:vista_ignore_kinds*

  Type: |List|
  Default: `[]`

  Ignore some kinds of tags or symbols.

g:vista#renderer#icons                                    *g:vista#renderer#icons*

  Type: |Dict|
  Default: See `autoload/vista/renderer.vim` .

g:vista#renderer#ctags                                    *g:vista#renderer#ctags*

  Type: |String|
  Default: `default`

  Options:

  `default` - render tags in nested structure.
  `kind`    - render tags kindwise.
  `line`    - render tags linewise.

g:vista_no_mappings                                          *g:vista_no_mappings*

  Type: |Number|
  Default: `0`

  Disable the default mappings.

g:vista_log_file                                                *g:vista_log_file*

  Type: |String|
  Default: `Undefined`

  Enable the logging feature for debugging. For example:
  >
  let g:vista_log_file = expand('~/vista.log')
<
  Note: Do not enable this unless you want to debug vista.vim as this may have
  a side effect on the performance!

g:vista_enable_centering_jump                      *g:vista_enable_centering_jump*

  Type: |Number|
  Default: `1`

  Set this variable to `0` to not make the line at center of window when you
  jump to the tag.

--------------------------------------------------------------------------------
Key Mappings                                                  *vista-key-mappings*

The following mappings are defined by default in the vista window.

<CR>          - jump to the tag under the cursor.
<2-LeftMouse> - Same as <CR>.
p             - preview the tag under the context via the floating window if
                it's avaliable.
s             - sort the symbol alphabetically or the location they are
                declared.
q             - close the vista window.

You can add a mapping to `/` in order to open the vista finder for
searching by adding the following autocommand in your vimrc:
 >
 autocmd FileType vista,vista_kind nnoremap <buffer> <silent> \
             / :<c-u>call vista#finder#fzf#Run()<CR>

--------------------------------------------------------------------------------
Highlights                                                      *vista-highlights*

Use |:hi| command in your vimrc to change the default highlights in vista.vim,
e.g.:
  >
  hi VistaFloat ctermbg=237 guibg=#3a3a3a

VistaFloat                                                            *VistaFloat*

  Default: `hi default link VistaFloat Pmenu`

  The highlight used for the floating window.

================================================================================
CONTRIBUTING                                                  *vista-contributing*

Vista.vim is still in beta, if you run into any trouble or have any sugguestions,
please file an issue (https://github.com/liuchengxu/vista.vim/issues/new).

================================================================================
LICENSE                                                            *vista-license*

MIT

Copyright (c) 2019 Liu-Cheng Xu

vim:tw=78:ts=2:sts=2:sw=2:ft=help:norl:
./plugin/vista.vim	[[[1
37
" vista.vim - View and search LSP symbols, tags, etc.
" Author:     Liu-Cheng Xu <xuliuchengxlc@gmail.com>
" Website:    https://github.com/liuchengxu/vista.vim
" License:    MIT

if exists('g:loaded_vista')
  finish
endif

let g:loaded_vista = 1

let g:vista_floating_border = get(g:, 'vista_floating_border', 'none')
let g:vista_sidebar_width = get(g:, 'vista_sidebar_width', 30)
let g:vista_sidebar_position = get(g:, 'vista_sidebar_position', 'vertical botright')
let g:vista_blink = get(g:, 'vista_blink', [2, 100])
let g:vista_top_level_blink = get(g:, 'vista_top_level_blink', [2, 100])
let g:vista_icon_indent = get(g:, 'vista_icon_indent', ['└ ', '│ '])
let g:vista_fold_toggle_icons = get(g:, 'vista_fold_toggle_icons', ['▼', '▶'])
let g:vista_update_on_text_changed = get(g:, 'vista_update_on_text_changed', 0)
let g:vista_update_on_text_changed_delay = get(g:, 'vista_update_on_text_changed_delay', 500)
let g:vista_echo_cursor = get(g:, 'vista_echo_cursor', 1)
let g:vista_no_mappings = get(g:, 'vista_no_mappings', 0)
let g:vista_stay_on_open = get(g:, 'vista_stay_on_open', 1)
let g:vista_close_on_jump =  get(g:, 'vista_close_on_jump', 0)
let g:vista_close_on_fzf_select =  get(g:, 'vista_close_on_fzf_select', 0)
let g:vista_disable_statusline = get(g:, 'vista_disable_statusline', exists('g:loaded_airline') || exists('g:loaded_lightline'))
let g:vista_cursor_delay = get(g:, 'vista_cursor_delay', 400)
let g:vista_ignore_kinds = get(g:, 'vista_ignore_kinds', [])
let g:vista_executive_for = get(g:, 'vista_executive_for', {})
let g:vista_default_executive = get(g:, 'vista_default_executive', 'ctags')
let g:vista_enable_centering_jump = get(g:, 'vista_enable_centering_jump', 1)
let g:vista_find_nearest_method_or_function_delay = get(g:, 'vista_find_nearest_method_or_function_delay', 300)
" Select the absolute nearest function when using binary search.
let g:vista_find_absolute_nearest_method_or_function = get(g:, 'vista_find_absolute_nearest_method_or_function', 0)
let g:vista_fzf_preview = get(g:, 'vista_fzf_preview', [])

command! -bang -nargs=* -bar -complete=custom,vista#util#Complete Vista call vista#(<bang>0, <f-args>)
./syntax/vista.vim	[[[1
46
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

if exists('b:current_syntax') && b:current_syntax ==# 'vista'
  finish
endif

let s:icons = join(values(g:vista#renderer#icons), '\|')
execute 'syntax match VistaIcon' '/'.s:icons.'/' 'contained'

syntax match VistaPublic /^\s*+\</ contained
syntax match VistaProtected /^\s*\~\</ contained
syntax match VistaPrivate /^\s*-\</ contained

syntax match VistaParenthesis /(\|)/ contained
syntax match VistaArgs  /(\zs.*\ze) /
syntax match VistaKind / \a*\ze:\d\+$/ contained
syntax match VistaScopeKind /\S\+\zs \a\+\ze:\d\+$/ nextgroup=VistaColon
syntax match VistaColon /:\ze\d\+$/ contained nextgroup=VistaLineNr
syntax match VistaLineNr /\d\+$/
syntax match VistaScope /^\S.*$/ contains=VistaPrivate,VistaProtected,VistaPublic,VistaKind,VistaIcon,VistaParenthesis
syntax region VistaTag start="^" end="$" contains=VistaPublic,VistaProtected,VistaPrivate,VistaArgs,VistaScope,VistaScopeKind,VistaLineNr,VistaColon,VistaIcon

hi default link VistaParenthesis Operator
hi default link VistaScope       Function
hi default link VistaTag         Keyword
hi default link VistaKind        Type
hi default link VistaScopeKind   Define
hi default link VistaLineNr      LineNr
hi default link VistaColon       SpecialKey
hi default link VistaIcon        StorageClass
hi default link VistaArgs        Comment

hi default VistaPublic     guifg=Green  ctermfg=Green
hi default VistaProtected  guifg=Yellow ctermfg=Yellow
hi default VistaPrivate    guifg=Red    ctermfg=Red

" Do not touch the global highlight group.
" hi! link Folded Function

if has('nvim')
  call setwinvar(winnr(), '&winhl', 'Folded:Function')
endif

let b:current_syntax = 'vista'
./syntax/vista_kind.vim	[[[1
35
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

if exists('b:current_syntax') && b:current_syntax ==# 'vista_kind'
  finish
endif

let s:icons = join(values(g:vista#renderer#icons), '\|')
execute 'syntax match VistaIcon' '/'.s:icons.'/' 'contained'

syntax match VistaBracket /\(\[\|\]\)/ contained
syntax match VistaChildrenNr /\[\d*\]$/ contains=VistaBracket

let s:prefixes = filter(
      \ map(copy(g:vista_icon_indent), 'vista#util#Trim(v:val)'),
      \ '!empty(v:val)')
let s:pattern = join(s:prefixes, '\|')
execute 'syntax match VistaPrefix' '/\('.s:pattern.'\)/' 'contained'

syntax match VistaScope /^\S.*$/ contains=VistaPrefix,VistaChildrenNr,VistaIcon
syntax match VistaColon /:/ contained
syntax match VistaLineNr /:\d*$/ contains=VistaColon
syntax region VistaTag start="^" end="$" contains=VistaLineNr,VistaScope,VistaPrefix

hi default link VistaBracket     Identifier
hi default link VistaChildrenNr  Number
hi default link VistaScope       Function
hi default link VistaTag         Keyword
hi default link VistaPrefix      String
hi default link VistaLineNr      LineNr
hi default link VistaColon       SpecialKey
hi default link VistaIcon        StorageClass

let b:current_syntax = 'vista_kind'
./syntax/vista_markdown.vim	[[[1
32
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

if exists('b:current_syntax') && b:current_syntax ==# 'vista_markdown'
  finish
endif

syntax match VistaColon /:/ contained
syntax match VistaLineNr /\d\+$/

syntax match VistaHeadNr /H1\|H2\|H3\|H4\|H5\|H6:\d\+$/ contains=VistaLineNr contained

syntax match VistaH1 /.*H1/ contains=VistaColon,VistaLineNr,VistaHeadNr
syntax match VistaH2 /.*H2/ contains=VistaColon,VistaLineNr,VistaHeadNr
syntax match VistaH3 /.*H3/ contains=VistaColon,VistaLineNr,VistaHeadNr
syntax match VistaH4 /.*H4/ contains=VistaColon,VistaLineNr,VistaHeadNr
syntax match VistaH5 /.*H5/ contains=VistaColon,VistaLineNr,VistaHeadNr
syntax match VistaH6 /.*H6/ contains=VistaColon,VistaLineNr,VistaHeadNr

hi default link VistaColon       SpecialKey
hi default link VistaLineNr      LineNr
hi default link VistaHeadNr      Comment

highlight default link VistaH1 markdownH1
highlight default link VistaH2 markdownH2
highlight default link VistaH3 markdownH3
highlight default link VistaH4 markdownH4
highlight default link VistaH5 markdownH5
highlight default link VistaH6 markdownH6

let b:current_syntax = 'vista_markdown'
./test/data/114.py	[[[1
3
class Foo:
    def __init__(self, x):
        self.x = x
./test/data/123.cpp	[[[1
30
#include <iostream>

using std::cout;
using std::endl;

namespace foo::bar {
	static const int x = 1;
};

void print_x(void)
{
	cout << foo::bar::x << endl;
}

namespace foo::bar {
	static const int y = 2;
};

void print_y(void)
{
	cout << foo::bar::y << endl;
}

int main(void)
{
	print_x();
	print_y();

	return 0;
}
./test/data/175.cpp	[[[1
36
#include <iostream>
using namespace std;

struct {
	int bar;
} anon;

namespace example {
	struct {
		int foo;
	};

	struct {
		int bar;
	};

	enum {
		FOO
	};

	enum {
		BAR
	};
}

namespace {
	enum {
		BAZ
	};
}

int
main(void)
{
	return 0;
}
./test/data/70.py	[[[1
4
class Foo:
    class Bar:
        def baz(self):
            pass
./test/data/anonymous_namespace.cpp	[[[1
12
namespace {
    extern int foo();
    extern int baz();
}

namespace {
    extern int foo();
}

namespace {
    extern int foo();
}
./test/data/ctags_tree_view.py	[[[1
90
#!/usr/bin/env python
# -*- coding: utf-8 -*-


class Foo:
    class Bar:
        BAR = 12

        class Baz:
            pass

        class Qux:
            class Bar:
                BAR = 12

                class Baz:
                    pass

                class Qux:
                    pass

            pass

    class Bar1:
        BAR = 12

        class Baz:
            pass

        class Qux:
            class Bar:
                BAR = 12

                class Baz:
                    pass

                class Qux:
                    pass

        pass

    class Bar2:
        BAR = 12

        class Baz:
            pass

        class Qux:
            class Bar:
                BAR = 12

                class Baz:
                    pass

                class Qux:
                    pass

        pass

    def qux(self):
        def thing1():
            pass

        if True:

            def thing2():
                pass
        else:

            def thing3():
                pass

        def thing4():
            pass

    def qux1(self):
        def thing1():
            pass

        if True:

            def thing2():
                pass
        else:

            def thing3():
                pass

        def thing4():
            pass
./test/fetch_testdata.sh	[[[1
17
#!/usr/bin/env bash

try_download() {
  local testdata=$1
  local source=$2
  if [ -f "$testdata" ]; then
      echo "$testdata already exists"
  else
      echo "$testdata does not exist, downloading..."
      curl "$source" -o "$testdata"
  fi
}

try_download data/184.cpp https://raw.githubusercontent.com/PointCloudLibrary/pcl/master/io/src/pcd_io.cpp

try_download data/190.cpp https://raw.githubusercontent.com/opencv/opencv/master/modules/core/include/opencv2/core/mat.hpp

