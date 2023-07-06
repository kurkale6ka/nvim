" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/workflows/jq.yml	[[[1
21
---
# yamllint disable-line rule:truthy
on:
  push:
    paths:
      - assets/json/*.json
  pull_request:
    paths:
      - assets/json/*.json
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check if a json is sorted
        run: |
          for json in assets/json/*.json ; do
            diff <(jq -S . $json) $json || exit 1
          done
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
./.github/workflows/test.yml	[[[1
45
name: test

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        os:
          - macos-latest
          - windows-latest
          - ubuntu-latest
        host:
          - vim_type: Vim
            version: head
          - vim_type: Vim
            version: v8.1.2424
          - vim_type: Neovim
            version: head
          - vim_type: Neovim
            version: v0.4.3
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
          vim_type: ${{ matrix.host.vim_type }}
          vim_version: ${{ matrix.host.version }}
      - name: Run tests
        env:
          THEMIS_VIM: ${{ steps.vim.outputs.executable }}
        run: |
          ./vim-themis/bin/themis
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

./LICENSE.vim-devicon	[[[1
22
The MIT License (MIT)

Copyright (c) 2014 Ryan L McIntyre

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
76
# 👓 nerdfont.vim

![Support Vim 8.1 or above](https://img.shields.io/badge/support-Vim%208.1%20or%20above-yellowgreen.svg)
![Support Neovim 0.4 or above](https://img.shields.io/badge/support-Neovim%200.4%20or%20above-yellowgreen.svg)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20nerdfont-orange.svg)](doc/nerdfont.txt)

[![reviewdog](https://github.com/lambdalisue/nerdfont.vim/workflows/reviewdog/badge.svg)](https://github.com/lambdalisue/nerdfont.vim/actions?query=workflow%3Areviewdog)
[![vim](https://github.com/lambdalisue/nerdfont.vim/workflows/vim/badge.svg)](https://github.com/lambdalisue/nerdfont.vim/actions?query=workflow%3Avim)
[![neovim](https://github.com/lambdalisue/nerdfont.vim/workflows/neovim/badge.svg)](https://github.com/lambdalisue/nerdfont.vim/actions?query=workflow%3Aneovim)

A simplified version of [vim-devicons][] which does NOT provide any 3rd party integrations in itself.
In otherwords, it is a fundemental plugin to handle [Nerd Fonts][] from Vim.

[vim-devicons]: https://github.com/ryanoasis/vim-devicons
[nerd fonts]: https://github.com/ryanoasis/nerd-fonts

![](https://user-images.githubusercontent.com/546312/88701008-6c1c5980-d144-11ea-8d6b-d4f4290274a6.png)
_With fern.vim + fern-renderer-nerdfont.vim. All glyphs above were powered by this plugin_

## Usage

First of all, make sure one of [Nerd Fonts][] is used in your Vim.
After that, use `nerdfont#find()` function to find a glyph for the current filetype like:

```vim
echo nerdfont#find()

```

Or specify a path to find a glyph for a particular path like:

```vim
echo nerdfont#find(expand('~/.vimrc'))

echo nerdfont#find(expand('~/.vim'))

```

Above automatically check if the specified path is directory.
To avoid that, specify the second argument to tell if the path is directory or not like:

```vim
echo nerdfont#find(expand('~/.vimrc'), 0)

echo nerdfont#find(expand('~/.vimrc'), 1)

```

See `:help nerdfont-function` to find glyphs for directory, fileformat, platform, etc.

## Contribution

If you would like to add new glyph/filetype supports, see the following files

| If                                                  | Where                                                        |
| --------------------------------------------------- | ------------------------------------------------------------ |
| Want to add new extension (e.g. `.js`)              | [`assets/json/extension.json`](./assets/json/extension.json) |
| Want to add new exact name (e.g. `Makefile`)        | [`assets/json/basename.json`](./assets/json/basename.json)   |
| Want to add new complex pattern (e.g. `.*/bin/.*$`) | [`assets/json/pattern.json`](./assets/json/pattern.json)     |

## Integrations

| Name                           | Description                                                          |
| ------------------------------ | -------------------------------------------------------------------- |
| [glyph-palette.vim][]          | An universal palette for glyphs to highlight nicely                  |
| [fern-renderer-nerdfont.vim][] | A [fern.vim][] plugin which use nerdfont.vim to provide fancy glyphs |

[glyph-palette.vim]: https://github.com/lambdalisue/glyph-palette.vim
[fern-renderer-nerdfont.vim]: https://github.com/lambdalisue/fern-renderer-nerdfont.vim
[fern.vim]: https://github.com/lambdalisue/fern.vim

## License

The glyph mappings has copied from [vim-devicons][] thus the part follow the license of [vim-devicons][] ([LICENSE.vim-devicons](./LICENSE.vim-devicon)).
Other parts are MIT license explained in [LICENSE](./LICENSE).
./assets/json/basename.json	[[[1
62
{
  ".bashprofile": "",
  ".bashrc": "",
  ".ds_store": "",
  ".editorconfig": "",
  ".eslintignore": "󰱺",
  ".gcloudignore": "󱇶",
  ".git": "",
  ".gitattributes": "",
  ".gitconfig": "",
  ".gitignore": "",
  ".gitlab-ci.yml": "",
  ".gitmodules": "",
  ".gvimrc": "",
  ".prettierignore": "󰏣",
  ".rvm": "",
  ".vimrc": "",
  ".zprofile": "",
  ".zshrc": "",
  "_gvimrc": "",
  "_vimrc": "",
  "brewfile": "󱄖",
  "brewfile.lock.json": "󱄖",
  "cargo.lock": "",
  "cmakelists.txt": "",
  "config.ru": "",
  "docker-compose.yml": "",
  "dockerfile": "",
  "dropbox": "",
  "ds_store": "",
  "exact-match-case-sensitive-1.txt": "1",
  "exact-match-case-sensitive-2": "2",
  "favicon.ico": "",
  "gemfile": "",
  "gitignore_global": "",
  "go.mod": "",
  "go.sum": "",
  "gradle": "",
  "gruntfile.coffee": "",
  "gruntfile.js": "",
  "gruntfile.ls": "",
  "gulpfile.coffee": "",
  "gulpfile.js": "",
  "gulpfile.ls": "",
  "hidden": "",
  "license": "",
  "localized": "",
  "makefile": "",
  "mix.lock": "",
  "npmignore": "",
  "package.json": "",
  "pkgbuild": "",
  "procfile": "",
  "rakefile": "",
  "react.jsx": "",
  "renovate.json": "󰉼",
  "requirements.txt": "",
  "robots.txt": "󰚩",
  "rubydoc": "",
  "tsconfig.json": "",
  "yarn.lock": ""
}
./assets/json/directory.json	[[[1
6
{
  ".": "",
  "close": "",
  "open": "",
  "symlink": ""
}
./assets/json/extension.json	[[[1
285
{
  ".": "",
  "DS_store": "",
  "ai": "",
  "android": "",
  "apk": "",
  "apple": "",
  "avi": "",
  "avif": "",
  "avro": "",
  "awk": "",
  "bash": "",
  "bash_history": "",
  "bash_profile": "",
  "bashrc": "",
  "bat": "",
  "bats": "",
  "bmp": "",
  "bz": "",
  "bz2": "",
  "c": "",
  "c++": "",
  "cab": "",
  "cc": "",
  "cfg": "",
  "cjs": "",
  "class": "",
  "clj": "",
  "cljc": "",
  "cljs": "",
  "cls": "",
  "cmd": "",
  "coffee": "",
  "conf": "",
  "cp": "",
  "cpio": "",
  "cpp": "",
  "cr": "",
  "cs": "",
  "csh": "",
  "cshtml": "",
  "csproj": "",
  "css": "",
  "csv": "",
  "csx": "",
  "cts": "",
  "cu": "",
  "cuh": "",
  "cxx": "",
  "d": "",
  "dart": "",
  "db": "",
  "deb": "",
  "diff": "",
  "djvu": "",
  "dll": "",
  "doc": "",
  "docx": "",
  "dump": "",
  "ebook": "",
  "ebuild": "",
  "editorconfig": "",
  "edn": "",
  "eex": "",
  "ejs": "",
  "elm": "",
  "eot": "",
  "epub": "",
  "erb": "",
  "erl": "",
  "ex": "",
  "exe": "",
  "exs": "",
  "f#": "",
  "fish": "",
  "flac": "",
  "flv": "",
  "font": "",
  "fs": "",
  "fsi": "",
  "fsscript": "",
  "fsx": "",
  "gdoc": "",
  "gem": "",
  "gemfile": "",
  "gemspec": "",
  "gform": "",
  "gif": "",
  "git": "",
  "gitattributes": "",
  "gitignore": "",
  "gitmodules": "",
  "go": "",
  "gradle": "",
  "groovy": "",
  "gsheet": "",
  "gslides": "",
  "guardfile": "",
  "gz": "",
  "h": "",
  "haml": "",
  "hbs": "",
  "hh": "",
  "hpp": "",
  "hrl": "",
  "hs": "",
  "htm": "",
  "html": "",
  "hxx": "",
  "ico": "",
  "image": "",
  "img": "",
  "iml": "",
  "ini": "",
  "ipynb": "",
  "iso": "",
  "j2c": "",
  "j2k": "",
  "jad": "",
  "jar": "",
  "java": "",
  "jfi": "",
  "jfif": "",
  "jif": "",
  "jl": "",
  "jmd": "",
  "jp2": "",
  "jpe": "",
  "jpeg": "",
  "jpg": "",
  "jpx": "",
  "js": "",
  "json": "",
  "jsonc": "",
  "jsx": "",
  "jxl": "",
  "ksh": "",
  "latex": "",
  "leex": "",
  "less": "",
  "lhs": "",
  "license": "",
  "localized": "",
  "lock": "",
  "log": "",
  "lua": "",
  "lz": "",
  "lz4": "",
  "lzh": "",
  "lzma": "",
  "lzo": "",
  "m": "",
  "m4a": "",
  "markdown": "",
  "md": "",
  "mdx": "",
  "mjs": "",
  "mk": "",
  "mkd": "",
  "mkv": "",
  "ml": "λ",
  "mli": "λ",
  "mm": "",
  "mobi": "",
  "mov": "",
  "mp3": "",
  "mp4": "",
  "msi": "",
  "mts": "",
  "mustache": "",
  "nix": "",
  "node": "",
  "npmignore": "",
  "odp": "",
  "ods": "",
  "odt": "",
  "ogg": "",
  "ogv": "",
  "otf": "",
  "part": "",
  "patch": "",
  "pdf": "",
  "php": "",
  "pl": "",
  "plx": "",
  "pm": "",
  "png": "",
  "pod": "",
  "pp": "",
  "ppt": "",
  "pptx": "",
  "procfile": "",
  "properties": "",
  "ps1": "",
  "psb": "",
  "psd": "",
  "pxm": "",
  "py": "",
  "pyc": "",
  "pyd": "",
  "pyo": "",
  "r": "",
  "rake": "",
  "rakefile": "",
  "rar": "",
  "razor": "",
  "rb": "",
  "rdata": "",
  "rdb": "",
  "rdoc": "",
  "rds": "",
  "readme": "",
  "rlib": "",
  "rmd": "",
  "rpm": "",
  "rs": "",
  "rspec": "",
  "rspec_parallel": "",
  "rspec_status": "",
  "rss": "",
  "rtf": "",
  "ru": "",
  "rubydoc": "",
  "sass": "",
  "scala": "",
  "scss": "",
  "sh": "",
  "shell": "",
  "slim": "",
  "sln": "",
  "so": "",
  "sql": "",
  "sqlite3": "",
  "sty": "",
  "styl": "",
  "stylus": "",
  "suo": "",
  "svg": "",
  "swift": "",
  "t": "",
  "tar": "",
  "taz": "",
  "tbz": "",
  "tbz2": "",
  "tex": "",
  "tgz": "",
  "tiff": "",
  "tlz": "",
  "toml": "",
  "torrent": "",
  "ts": "",
  "tsv": "",
  "tsx": "",
  "ttf": "",
  "twig": "",
  "txt": "",
  "txz": "",
  "tz": "",
  "tzo": "",
  "video": "",
  "vim": "",
  "vue": "󰡄",
  "war": "",
  "wav": "",
  "webm": "",
  "webmanifest": "",
  "webp": "",
  "windows": "",
  "woff": "",
  "woff2": "",
  "xcplayground": "",
  "xhtml": "",
  "xls": "",
  "xlsx": "",
  "xml": "",
  "xul": "",
  "xz": "",
  "yaml": "",
  "yml": "",
  "zip": "",
  "zsh": "",
  "zsh-theme": "",
  "zshrc": "",
  "zst": ""
}
./assets/json/fileformat.json	[[[1
5
{
  "dos": "",
  "mac": "",
  "unix": ""
}
./assets/json/pattern.json	[[[1
39
{
  ".*\\.d\\.ts$": "",
  ".*angular.*\\.js$": "",
  ".*backbone.*\\.js$": "",
  ".*jquery.*\\.js$": "",
  ".*materialize.*\\.css$": "",
  ".*materialize.*\\.js$": "",
  ".*mootools.*\\.js$": "",
  ".*require.*\\.js$": "",
  ".*vimrc.*": "",
  "/Trash.$": "",
  "/Users.$": "",
  "/\\.Trash-\\d\\+.$": "",
  "/\\.\\?yarnrc\\(\\.ya\\?ml\\)\\?$": "",
  "/\\.atom.$": "",
  "/\\.config.$": "",
  "/\\.env\\(\\.[A-z0-9]\\+\\)*$": "",
  "/\\.eslintrc\\(\\.\\(c\\?js\\|ya\\?ml\\|json\\)\\)\\?$": "󰱺",
  "/\\.git.$": "",
  "/\\.github.$": "",
  "/\\.idea.$": "",
  "/\\.prettierrc\\(\\.\\(json5\\?\\|c\\?js\\|ya\\?ml\\|toml\\)\\)\\?": "󰏣",
  "/\\.vscode.$": "",
  "/\\cloudbuild\\.ya\\?ml$": "󱇶",
  "/bin.$": "",
  "/codecov\\.ya\\?ml": "",
  "/eslint\\.config\\.js?$": "󰱺",
  "/home.$": "",
  "/include.$": "",
  "/lib.$": "",
  "/lib32.$": "",
  "/lib64.$": "",
  "/libexec.$": "",
  "/node_modules.$": "",
  "/prettier\\.config\\.c\\?js?$": "󰏣",
  "/sbin.$": "",
  "/xbin.$": "",
  "Vagrantfile$": ""
}
./assets/json/platform.json	[[[1
12
{
  "android": "",
  "arch": "",
  "centos": "",
  "debian": "",
  "docker": "",
  "gentoo": "",
  "linux": "",
  "macos": "",
  "ubuntu": "",
  "windows": ""
}
./autoload/nerdfont/directory.vim	[[[1
16
let g:nerdfont#directory#customs = get(g:, 'nerdfont#directory#customs', {})
let g:nerdfont#directory#defaults = nerdfont#get_json('directory')

function! nerdfont#directory#find(...) abort
  let n = a:0 ? a:1 : '.'
  return get(s:m, n, '')
endfunction

function! nerdfont#directory#refresh() abort
  let s:m = extend(
        \ copy(g:nerdfont#directory#defaults),
        \ g:nerdfont#directory#customs,
        \)
endfunction

call nerdfont#directory#refresh()
./autoload/nerdfont/fileformat.vim	[[[1
16
let g:nerdfont#fileformat#customs = get(g:, 'nerdfont#fileformat#customs', {})
let g:nerdfont#fileformat#defaults = nerdfont#get_json('fileformat')

function! nerdfont#fileformat#find(...) abort
  let n = a:0 ? a:1 : &fileformat
  return get(s:m, n, '')
endfunction

function! nerdfont#fileformat#refresh() abort
  let s:m = extend(
        \ copy(g:nerdfont#fileformat#defaults),
        \ g:nerdfont#fileformat#customs,
        \)
endfunction

call nerdfont#fileformat#refresh()
./autoload/nerdfont/path/basename.vim	[[[1
16
let g:nerdfont#path#basename#customs = get(g:, 'nerdfont#path#basename#customs', {})
let g:nerdfont#path#basename#defaults = nerdfont#get_json('basename')

function! nerdfont#path#basename#find(path) abort
  let n = tolower(fnamemodify(a:path, ':t'))
  return get(s:m, n, '')
endfunction

function! nerdfont#path#basename#refresh() abort
  let s:m = extend(
        \ copy(g:nerdfont#path#basename#defaults),
        \ g:nerdfont#path#basename#customs,
        \)
endfunction

call nerdfont#path#basename#refresh()
./autoload/nerdfont/path/extension.vim	[[[1
16
let g:nerdfont#path#extension#customs = get(g:, 'nerdfont#path#extension#customs', {})
let g:nerdfont#path#extension#defaults = nerdfont#get_json('extension')

function! nerdfont#path#extension#find(path) abort
  let n = tolower(fnamemodify(a:path, ':e'))
  return get(s:m, n, '')
endfunction

function! nerdfont#path#extension#refresh() abort
  let s:m = extend(
        \ copy(g:nerdfont#path#extension#defaults),
        \ g:nerdfont#path#extension#customs,
        \)
endfunction

call nerdfont#path#extension#refresh()
./autoload/nerdfont/path/pattern.vim	[[[1
20
let g:nerdfont#path#pattern#customs = get(g:, 'nerdfont#path#pattern#customs', {})
let g:nerdfont#path#pattern#defaults = nerdfont#get_json('pattern')

function! nerdfont#path#pattern#find(path) abort
  for [k, v] in s:m
    if a:path =~# '\m' . k
      return v
    endif
  endfor
  return ''
endfunction

function! nerdfont#path#pattern#refresh() abort
  let s:m = items(extend(
        \ copy(g:nerdfont#path#pattern#defaults),
        \ g:nerdfont#path#pattern#customs,
        \))
endfunction

call nerdfont#path#pattern#refresh()
./autoload/nerdfont/platform.vim	[[[1
57
let g:nerdfont#platform#customs = get(g:, 'nerdfont#platform#customs', {})
let g:nerdfont#platform#defaults = nerdfont#get_json('platform')

function! nerdfont#platform#find(...) abort
  let n = a:0 ? a:1 : s:find_platform()
  return get(s:m, n, '')
endfunction

function! s:find_platform() abort
  if exists('s:platform')
    return s:platform
  endif
  if has('win32')
    let s:platform = 'windows'
    return s:platform
  endif
  if has('mac') || has('macunix')
    let s:platform = 'macos'
    return s:platform
  endif
  " https://wiki.termux.com/wiki/Differences_from_Linux
  if $PREFIX ==# '/data/data/com.termux/files/usr'
    let s:platform = 'android'
    return s:platform
  endif
  let s:platform = s:find_distro()
  return s:platform
endfunction

function! s:find_distro() abort
  if executable('lsb_release')
    let result = system('lsb_release -i')
    if result =~# 'Arch'
      return 'arch'
    elseif result =~# 'Gentoo'
      return 'gentoo'
    elseif result =~# 'Ubuntu'
      return 'ubuntu'
    elseif result =~# 'Cent'
      return 'centos'
    elseif result =~# 'Debian'
      return 'debian'
    elseif result =~# 'Dock'
      return 'docker'
    endif
  endif
  return 'linux'
endfunction

function! nerdfont#platform#refresh() abort
  let s:m = extend(
        \ copy(g:nerdfont#platform#defaults),
        \ g:nerdfont#platform#customs,
        \)
endfunction

call nerdfont#platform#refresh()
./autoload/nerdfont.vim	[[[1
38
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:json_dir = s:path . '/assets/json'

function! nerdfont#get_json(json_name) abort
  let l:json = s:json_dir . '/' . a:json_name . '.json'
  let l:result = json_decode(join(readfile(l:json), ''))
  return l:result
endfunction

function! nerdfont#find(...) abort
  let path = a:0 > 0 ? a:1 : bufname('%')
  let isdir = a:0 > 1 ? a:2 : 'auto'

  let glyph = nerdfont#path#pattern#find(path)
  if !empty(glyph)
    return glyph
  endif

  let glyph = nerdfont#path#basename#find(path)
  if !empty(glyph)
    return glyph
  endif

  let isdir = isdir ==# 'auto' ? isdirectory(path) : isdir
  if !empty(isdir)
    return nerdfont#directory#find(type(isdir) is# v:t_string ? isdir : '')
  endif

  let glyph = nerdfont#path#extension#find(path)
  if !empty(glyph)
    return glyph
  endif

  return g:nerdfont#default
endfunction

let g:nerdfont#default = get(g:, 'nerdfont#default',
      \ g:nerdfont#path#extension#defaults['.'])
./doc/.gitignore	[[[1
1
tags
./doc/nerdfont.txt	[[[1
201
*nerdfont.txt*				A plugin to handle Nerd Fonts

Author:  Alisue <lambdalisue@hashnote.net>
License: MIT license

=============================================================================
CONTENTS						*nerdfont-contents*

INTRODUCTION				|nerdfont-introduction|
USAGE					|nerdfont-usage|
INTERFACE				|nerdfont-interface|
  VARIABLE				|nerdfont-variable|
  FUNCTION				|nerdfont-function|


=============================================================================
INTRODUCTION						*nerdfont-introduction*

*nerdfont.vim* (nerdfont) is a plugin to handle Nerd Fonts [1].
It is like a simplified version of vim-devicons [2]. It does not provide any
3rd party integrations in itself. Any 3rd party integrations will be released
as cooperate plugins.

[1] https://github.com/ryanoasis/nerd-fonts
[2] https://github.com/ryanoasis/vim-devicons

Most of glyph mappings has copied from vim-devicons.


=============================================================================
USAGE							*nerdfont-usage*

Use |nerdfont#find()| function to find a filetype glyph of a current buffer
like WebDevIconsGetFileTypeSymbol() function in vim-devicons.

Use |nerdfont#fileformat#find()| function to find fileformat of a current
buffer like WebDevIconsGetFileFormatSymbol() function in vim-devicons.

Users can use above functions to show current status in 'statusline' like:
>
	set statusline=%f\ %{nerdfont#find()}\ %{nerdfont#fileformat#find()}
<
See |nerdfont-function| for more details.


=============================================================================
INTERFACE						*nerdfont-interface*

-----------------------------------------------------------------------------
VARIABLE						*nerdfont-variable*

*g:nerdfont#default*
	A default glyph.
>
	let g:nerdfont#default = 'glyph for default path'
<
*g:nerdfont#directory#customs*
	A custom glyph mappings for directory.
>
	let g:nerdfont#directory#customs = {
	      \ '': 'glyph for default directory',
	      \ 'open': 'glyph for open directory',
	      \ 'close': 'glyph for close directory',
	      \ 'symlink': 'glyph for symlink directory',
	      \}
<
*g:nerdfont#fileformat#customs*
	A custom glyph mappings for fileformat.
>
	let g:nerdfont#fileformat#customs = {
	      \ 'dos': 'glyph for dos',
	      \ 'mac': 'glyph for mac',
	      \ 'unix': 'glyph for unix',
	      \}
<
*g:nerdfont#platform#customs*
	A custom glyph mappings for platform.
>
	let g:nerdfont#platform#customs = {
	      \ 'windows': 'glyph for Windows',
	      \ 'macos': 'glyph for macOS',
	      \ 'linux': 'glyph for Linux',
	      \ 'arch': 'glyph for Arch Linux',
	      \ 'ubuntu': 'glyph for Ubuntu',
	      \ 'debian': 'glyph for Debian',
	      \ 'centos': 'glyph for CentOS',
	      \ 'docker': 'glyph for Docker',
	      \}
<
*g:nerdfont#path#basename#customs*
	A custom glyph mappings for basename match.
>
	let g:nerdfont#path#basename#customs = {
	      \ 'dockerfile': 'glyph for dockerfile',
	      \ 'Makefile': 'glyph for Makefile',
	      \}
<
*g:nerdfont#path#extension#customs*
	A custom glyph mappings for extension match.
>
	let g:nerdfont#path#extension#customs = {
	      \ 'js': 'glyph for .js',
	      \ 'rb': 'glyph for .rb',
	      \}
<
*g:nerdfont#path#pattern#customs*
	A custom glyph mappings for pattern match.
>
	let g:nerdfont#path#pattern#customs = {
	      \ '.*/dockerfiles/[^.]*$': 'glyph for files under dockerfiles',
	      \}
<
-----------------------------------------------------------------------------
FUNCTION						*nerdfont-function*

						*nerdfont#find()*
nerdfont#find([{path}][, {isdir}])
	Return a glyph (|String|) of a given {path} (|String|).

	It sequentically tries following functions and fallback to
	|g:nerdfont#default| to find a suitable glyph.

	1. |nerdfont#path#pattern#find()|
	2. |nerdfont#path#basename#find()|
	3. |nerdfont#directory#find()| if {isdir} is truthy value
	4. |nerdfont#path#extension#find()| if {isdir} is falsy value

	When {isdir} is omitted or "auto", |isdirectory()| function is used to
	determine if the given {path} is directory or not prior to step 3.
	When {isdir} is non empty |String|, the value is passed to the
	|nerdfont#directory#find()| as a {state} of a directory.
	When {path} is omitted, a name of the current buffer is used.

	For example:
>
	echo nerdfont#find()
	" 
	echo nerdfont#find('hello.rb')
	" 
	echo nerdfont#find('hello', 1)
	" 
	echo nerdfont#find('hello', 'open')
	" 
<
						*nerdfont#directory#find()*
nerdfont#directory#find([{state}])
	Return a glyph (|String|) of a given {state} directory. The following
	state is available in default set

        State		Description~
	""		Default directory
	"open"		Opend directory
	"close"		Closed directory
	"symlink"	Symlinked directory

	For example:
>
	echo nerdfont#directory#find()
	" 
	echo nerdfont#directory#find('open')
	" 
<
						*nerdfont#fileformat#find()*
nerdfont#fileformat#find([{fileformat}])
	Return a glyph (|String|) of a given {fileformat}.  If {fileformat} is
	omitted, 'fileformat' of the current buffer is used instead.

					*nerdfont#path#basename#find()*
nerdfont#path#basename#find({path})
	Return a glyph (|String|) of a given {path} by matching basename.

					*nerdfont#path#extension#find()*
nerdfont#path#extension#find({path})
	Return a glyph (|String|) of a given {path} by matching extension.

					*nerdfont#path#pattern#find()*
nerdfont#path#pattern#find({path})
	Return a glyph (|String|) of a given {path} by matching pattern.

						*nerdfont#path#clear_cache()*
nerdfont#platform#find([{platform}])
	Return a glyph (|String|) of a given {platform}. If {platform} is
	omitted, the running platform will be automatically detected.
	The following platform is available in default set.

	Platform		Description~
	"windows"		Windows
	"macos"			macOS
	"arch"			Arch Linux
	"ubuntu"		Ubuntu
	"debian"		Debian
	"centos"		CentOS
	"docker"		Docker container
	"linux"			Other linux/unix

	Note that it internally call "lsb_release -i" to detect linux
	distribution if needed and the result is cached.


=============================================================================
vim:tw=78:fo=tcq2mM:ts=8:ft=help:norl
./test/.themisrc	[[[1
30
if &encoding ==# 'latin1'
  set encoding=utf-8
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
call themis#log('&hidden:        ' . &hidden)
call themis#log('&runtimepath:')
for s:runtimepath in split(&runtimepath, ',')
  call themis#log('  ' . s:runtimepath)
endfor
call themis#log('-----------------------------------------------------------')
./test/nerdfont/directory.vimspec	[[[1
28
Describe nerdfont#directory
  Describe #find({path})
    It returns a default directory glyph
      let glyph = nerdfont#directory#find()
      Assert Equals(glyph, '')
    End

    It returns an opened directory glyph for 'open'
      let glyph = nerdfont#directory#find('open')
      Assert Equals(glyph, '')
    End

    It returns an closed directory glyph for 'close'
      let glyph = nerdfont#directory#find('close')
      Assert Equals(glyph, '')
    End

    It returns an symlinked directory glyph for 'symlink'
      let glyph = nerdfont#directory#find('symlink')
      Assert Equals(glyph, '')
    End

    It returns an empty string for 'hogehogefoobar'
      let glyph = nerdfont#directory#find('hogehogefoobar')
      Assert Equals(glyph, '')
    End
  End
End
./test/nerdfont/fileformat.vimspec	[[[1
23
Describe nerdfont#fileformat
  Describe #find({path})
    It returns a windows glyph for 'dos'
      let glyph = nerdfont#fileformat#find('dos')
      Assert Equals(glyph, '')
    End

    It returns an apple glyph for 'mac'
      let glyph = nerdfont#fileformat#find('mac')
      Assert Equals(glyph, '')
    End

    It returns a linux glyph for 'unix'
      let glyph = nerdfont#fileformat#find('unix')
      Assert Equals(glyph, '')
    End

    It returns an empty string for 'hogehogefoobar'
      let glyph = nerdfont#fileformat#find('hogehogefoobar')
      Assert Equals(glyph, '')
    End
  End
End
./test/nerdfont/path/basename.vimspec	[[[1
23
Describe nerdfont#path#basename
  Describe #find({path})
    It returns a gulpfile glyph for 'gulpfile.js'
      let glyph = nerdfont#path#basename#find('gulpfile.js')
      Assert Equals(glyph, '')
    End

    It returns a Docker glyph for 'dockerfile'
      let glyph = nerdfont#path#basename#find('dockerfile')
      Assert Equals(glyph, '')
    End

    It returns a Key glyph for 'license'
      let glyph = nerdfont#path#basename#find('license')
      Assert Equals(glyph, '')
    End

    It returns an empty string for 'hogehogefoobar'
      let glyph = nerdfont#path#basename#find('hogehogefoobar')
      Assert Equals(glyph, '')
    End
  End
End
./test/nerdfont/path/extension.vimspec	[[[1
23
Describe nerdfont#path#extension
  Describe #find({path})
    It returns a code glyph for 'index.html'
      let glyph = nerdfont#path#extension#find('index.html')
      Assert Equals(glyph, '')
    End

    It returns a JS glyph for 'index.js'
      let glyph = nerdfont#path#extension#find('index.js')
      Assert Equals(glyph, '')
    End

    It returns a Ruby glyph for 'index.rb'
      let glyph = nerdfont#path#extension#find('index.rb')
      Assert Equals(glyph, '')
    End

    It returns an empty string for 'hogehogefoobar'
      let glyph = nerdfont#path#extension#find('hogehogefoobar')
      Assert Equals(glyph, '')
    End
  End
End
./test/nerdfont/path/pattern.vimspec	[[[1
23
Describe nerdfont#path#pattern
  Describe #find({path})
    It returns a jQuery glyph for 'xxxxxjquery.yyyyy.js'
      let glyph = nerdfont#path#pattern#find('xxxxxjquery.yyyyy.js')
      Assert Equals(glyph, '')
    End

    It returns a Angular glyph for 'xxxxxangular.yyyyy.js'
      let glyph = nerdfont#path#pattern#find('xxxxxangular.yyyyy.js')
      Assert Equals(glyph, '')
    End

    It returns a Vagrant glyph for 'Vagrantfile'
      let glyph = nerdfont#path#pattern#find('Vagrantfile')
      Assert Equals(glyph, '')
    End

    It returns an empty string for 'hogehogefoobar'
      let glyph = nerdfont#path#pattern#find('hogehogefoobar')
      Assert Equals(glyph, '')
    End
  End
End
./test/nerdfont/platform.vimspec	[[[1
23
Describe nerdfont#platform
  Describe #find({path})
    It returns a windows glyph for 'windows'
      let glyph = nerdfont#platform#find('windows')
      Assert Equals(glyph, '')
    End

    It returns an apple glyph for 'macos'
      let glyph = nerdfont#platform#find('macos')
      Assert Equals(glyph, '')
    End

    It returns a linux glyph for 'linux'
      let glyph = nerdfont#platform#find('linux')
      Assert Equals(glyph, '')
    End

    It returns an empty string for 'hogehogefoobar'
      let glyph = nerdfont#platform#find('hogehogefoobar')
      Assert Equals(glyph, '')
    End
  End
End
./test/run_themis.sh	[[[1
9
#!/bin/bash
themis --version

export THEMIS_VIM="vim"
themis --reporter dot

export THEMIS_VIM="nvim"
export THEMIS_ARGS="-e -s --headless"
themis --reporter dot
