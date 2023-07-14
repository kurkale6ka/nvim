" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/ISSUE_TEMPLATE.md	[[[1
26
#### environment

- vim: ????
- vim-airline: ????
- OS: ????
- Have you reproduced with a minimal vimrc: ???
- What is your airline configuration: ???
if you are using terminal:
- terminal: ????
- $TERM variable: ???
- terminal columns size: ???
- terminal line size: ???
- color configuration (:set t_Co?):

if you are using Neovim:
- does it happen in Vim: ???

#### actual behavior

????

#### expected behavior

????

#### screen shot (if possible)
./.github/workflows/ci.yml	[[[1
44
name: CI

on:
  push:
    branches:
    - master
  pull_request:
    branches:
    - master

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    strategy:
      matrix:
        vim:
        - v9.0.0000
        - v8.2.1000
        - v8.2.0000
        - v8.1.0000
        - v8.0.0000
        - v7.4

    steps:
    - name: Checkout code
      uses: actions/checkout@main

    - name: Checkout vim-themis
      uses: actions/checkout@main
      with:
        repository: thinca/vim-themis
        path: vim-themis

    - name: Setup Vim
      uses: rhysd/action-setup-vim@v1
      id: vim
      with:
        version: ${{ matrix.vim }}

    - name: Test
      env:
        THEMIS_VIM: ${{ steps.vim.outputs.executable }}
      run: ./vim-themis/bin/themis --reporter spec
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
  vint:
    name: runner / vint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@main
      - name: vint
        uses: reviewdog/action-vint@v1
        with:
          github_token: ${{ secrets.github_token }}
          level: error
          reporter: github-pr-check
./.gitignore	[[[1
8
.DS_Store
doc/tags
*.lock
.vim-flavor
*.swp
.bundle
vendor
test/.deps
./CHANGELOG.md	[[[1
251
# Change Log

This is the Changelog for the vim-airline project.

## [0.12] - Unreleased
- New features
  - Extensions:
    - [poetv](https://github.com/petobens/poet-v) support
    - [vim-lsp](https://github.com/prabirshrestha/vim-lsp) support
    - [zoomwintab](https://github.com/troydm/zoomwintab.vim) support
    - [Vaffle](https://github.com/cocopon/vaffle.vim) support
    - [vim-dirvish](https://github.com/justinmk/vim-dirvish) support
    - [fzf.vim](https://github.com/junegunn/fzf.vim) support
    - [OmniSharp](https://github.com/OmniSharp/omnisharp-vim) support
    - [searchcount](https://vim-jp.org/vimdoc-en/eval.html#searchcount())  support
    - [fern.vim](https://github.com/lambdalisue/fern.vim) support
    - [Vim-CMake](https://github.com/cdelledonne/vim-cmake) support
    - [battery.vim](https://github.com/lambdalisue/battery.vim) support
    - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) support
    - [gen_tags.vim](https://github.com/jsfaint/gen_tags.vim) support
    - Ascii Scrollbar support
- Improvements
  - git branch can also be displayed using [gina.vim](https://github.com/lambdalisue/gina.vim)
  - coc extensions can also show additional status messages as well as the current function
  - [coc-git](https://github.com/neoclide/coc-git) extension integrated into hunks extension
  - rewrote parts using Vim9 Script for performance improvements
- Other
  - Changed CI from travis-ci.org to GitHub Actions
  - Introduce Vim script static analysis using [reviewdog](https://github.com/reviewdog/action-vint)
  - Added multiple Vim versions to unit tests using Travis CI
  - Added option to show short paths in the status line

## [0.11] - 2019-11-10
- New features
  - Extensions:
    - [Coc](https://github.com/neoclide/coc.nvim) support
    - [Defx](https://github.com/Shougo/defx.nvim) support
    - [gina](https://github.com/lambdalisue/gina.vim) support
    - [vim-bookmark](https://github.com/MattesGroeger/vim-bookmarks) support
    - [vista.vim](https://github.com/liuchengxu/vista.vim) support
    - [tabws](https://github.com/s1341/vim-tabws) support for the tabline
- Improvements
  - The statusline can be configured to be shown on top (in the tabline)
    Set the `g:airline_statusline_ontop` to enable this experimental feature.
  - If `buffer_idx_mode=2`, up to 89 mappings will be exposed to access more
    buffers directly (issue [#1823](https://github.com/vim-airline/vim-airline/issues/1823))
  - Allow to use `random` as special theme name, which will switch to a random
    airline theme (at least if a random number can be generated :()
  - The branch extensions now also displays whether the repository is in a clean state
    (will append a ! or ⚡if the repository is considered dirty).
  - The whitespace extensions will also check for conflict markers
  - `:AirlineRefresh` command now takes an additional `!` attribute, that **skips**
    recreating the highlighting groups (which might have a serious performance
    impact if done very often, as might be the case when the configuration variable
    `airline_skip_empty_sections` is active).
  - airline can now also detect multiple cursor mode (issue [#1933](https://github.com/vim-airline/vim-airline/issues/1933))
  - expose hunks output using the function `airline#extensions#hunks#get_raw_hunks()` to the outside [#1877](https://github.com/vim-airline/vim-airline/pull/1877)
  - expose wordcount affected filetype list to the public using the `airline#extensions#wordcount#filetypes` variable [#1887](https://github.com/vim-airline/vim-airline/pull/1887)
  - for the `:AirlineExtension` command, indicate whether the extension has been loaded from an external source [#1890](https://github.com/vim-airline/vim-airline/issues/1890)
  - correctly load custom wordcount formatters [#1896](https://github.com/vim-airline/vim-airline/issues/1896)
  - add a new short_path formatter for the tabline [#1898](https://github.com/vim-airline/vim-airline/pull/1898)
  - several improvements to the branch, denite and tabline extension, as well as the async code for Vim and Neovim
  - the term extension supports [neoterm](https://github.com/kassio/neoterm) vim plugin

## [0.10] - 2018-12-15
- New features
  - Extensions:
    - [LanguageClient](https://github.com/autozimu/LanguageClient-neovim)
    - [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
    - [vim-localsearch](https://github.com/mox-mox/vim-localsearch)
    - [xtabline](https://github.com/mg979/vim-xtabline)
    - [vim-grepper](https://github.com/mhinz/vim-grepper)
  - Add custom AirlineModeChanged autocommand, allowing to call user defined commands
    whenever airline displays a different mode
  - New :AirlineExtensions command, to show which extensions have been loaded
  - Detect several new modes (e.g. completion, virtual replace, etc)
- Improvements
  - Various performance improvements, should Vim keep responsive, even when
    many highlighting groups need to be re-created
  - Rework tabline extension
  - Refactor [vim-ctrlspace](https://github.com/szw/vim-ctrlspace) extension
  - Refactor the wordcount extension
  - Reworked the po extension
  - Allow to disable line numbers for the [Ale Extension](https://github.com/w0rp/ale)
  - [fugitive](https://github.com/tpope/vim-fugitive) plugin has been refactored
    causing adjustments for vim-airline, also uses Fugitives new API calls
  - some improvements to Vims terminal mode
  - Allow to use alternative seperators for inactive windows ([#1236](https://github.com/vim-airline/vim-airline/issues/1236))
  - Statusline can be set to inactive, whenever Vim loses focus (using FocusLost autocommand)

## [0.9] - 2018-01-15
- Changes
  - Look of default Airline Symbols has been improved [#1397](https://github.com/vim-airline/vim-airline/issues/1397)
  - Airline does now set `laststatus=2` if needed
  - Syntastic extension now displays warnings and errors separately
  - Updates on Resize and SessionLoad events
  - Add `maxlinenr` symbol to `airline_section_z`
  - Add quickfix title to inactive windows
- Improvements
  - Many performance improvements (using caching and async feature when possible)
  - Cache changes to highlighting groups if `g:airline_highlighting_cache = 1` is set
  - Allow to skip empty sections by setting `g:airline_skip_empty_sections` variable
  - Make use of improved Vim Script API, if available (e.g. getwininfo())
  - Support for Vims terminal feature (very experimental since it hasn't been stabilized yet)
  - More configuration for the tabline extension (with clickable buffers for Neovim)
  - Works better on smaller window sizes
  - Make airline aware of git worktrees
  - Improvements to the fugitive extension [#1603](https://github.com/vim-airline/vim-airline/issues/1603)
  - Allows for configurable fileformat output if `g:airline#parts#ffenc#skip_expected_string` is set
  - Improvements to the documentation
- New features
  - Full async support for Vim 8 and Neovim
  - Extensions:
    - [vim-bufmru](https://github.com/mildred/vim-bufmru)
    - [xkb-switch](https://github.com/ierton/xkb-switch)
    - [input-source-switcher](https://github.com/vovkasm/input-source-switcher)
    - [vimagit](https://github.com/jreybert/vimagit)
    - [denite](https://github.com/Shougo/denite.nvim)
    - [dein](https://github.com/Shougo/dein.vim)
    - [vimtex](https://github.com/lervag/vimtex)
    - [minpac](https://github.com/k-takata/minpac/)
    - [vim-cursormode](https://github.com/vheon/vim-cursormode)
    - [Neomake](https://github.com/neomake/neomake)
    - [Ale](https://github.com/w0rp/ale)
    - [vim-obsession](https://github.com/tpope/vim-obsession)
    - spell (can also display Spell language)
    - keymap
  - Formatters:
    - Formatters for JavaScript [#1617](https://github.com/vim-airline/vim-airline/issues/1617)
    - Tabline: Allow for custom formatter for `tab_nr_type` [#1418](https://github.com/vim-airline/vim-airline/issues/1418)
    - Customizable wordcount formatter [#1584](https://github.com/vim-airline/vim-airline/issues/1584)
  - Add User autocommand for Theme changing [#1226](https://github.com/vim-airline/vim-airline/issues/1226)
  - Shows mercurial mq status if hg mq extension is enabled

## [0.8] - 2016-03-09
- Changes
  - Airline converted to an organization and moved to new [repository](https://github.com/vim-airline/vim-airline)
  - Themes have been split into an separate repository [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- Improvements
  - Extensions
    - branch: support Git and Mercurial simultaneously, untracked files
    - whitespace: new mixed-indent rule
  - Windows support
  - Many bug fixes
  - Support for Neovim
- New features
  - Many new themes
  - Extensions/integration
    - [taboo](https://github.com/gcmt/taboo.vim)
    - [vim-ctrlspace](https://github.com/szw/vim-ctrlspace)
    - [quickfixsigns](https://github.com/tomtom/quickfixsigns_vim)
    - [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
    - [po.vim](http://www.vim.org/scripts/script.php?script_id=695)
    - [unicode.vim](https://github.com/chrisbra/unicode.vim)
    - wordcount
    - crypt indicator
    - byte order mark indicator
  - Tabline's tab mode can display splits simultaneously

## [0.7] - 2014-12-10
- New features
    - accents support; allowing multiple colors/styles in the same section
    - extensions: eclim
    - themes: understated, monochrome, murmur, sol, lucius
- Improvements
    -  solarized theme; support for 8 color terminals
    -  tabline resizes dynamically based on number of open buffers
    -  miscellaneous bug fixes

## [0.6] - 2013-10-08

- New features
    - accents support; allowing multiple colors/styles in the same section
    - extensions: eclim
    - themes: understated, monochrome, murmur, sol, lucius
- Improvements
    - solarized theme; support for 8 color terminals
    - tabline resizes dynamically based on number of open buffers
    - miscellaneous bug fixes

## [0.5] - 2013-09-13

- New features
    - smart tabline extension which displays all buffers when only one tab is visible
    - automatic section truncation when the window resizes
    - support for a declarative style of configuration, allowing parts to contain metadata such as minimum window width or conditional visibility
    - themes: zenburn, serene
- Other
    - a sizable chunk of vim-airline is now running through a unit testing suite, automated via Travis CI

## [0.4] - 2013-08-26

 - New features
    - integration with csv.vim and vim-virtualenv
    - hunks extension for vim-gitgutter and vim-signify
    - automatic theme switching with matching colorschemes
    - commands: AirlineToggle
    - themes: base16 (all variants)
 - Improvements
    - integration with undotree, tagbar, and unite
 - Other
    - refactored core and exposed statusline builder and pipeline
    - all extension related g:airline_variables have been deprecated in favor of g:airline#extensions# variables
    - extensions found in the runtimepath outside of the default distribution will be automatically loaded

## [0.3] - 2013-08-12

-  New features
    -  first-class integration with tagbar
    -  white space detection for trailing spaces and mixed indentation
    -  introduced warning section for syntastic and white space detection
    -  improved ctrlp integration: colors are automatically selected based on the current airline theme
    -  new themes: molokai, bubblegum, jellybeans, tomorrow
-  Bug fixes
    -  improved handling of eventignore used by other plugins
-  Other
    - code cleaned up for clearer separation between core functionality and extensions
    - introduced color extraction from highlight groups, allowing themes to be generated off of the active colorscheme (e.g. jellybeans and tomorrow)
    - License changed to MIT

## [0.2] - 2013-07-28

-  New features
      - iminsert detection
      - integration with vimshell, vimfiler, commandt, lawrencium
      - enhanced bufferline theming
      - support for ctrlp theming
      - support for custom window excludes
- New themes
      - luna and wombat
- Bug fixes
      - refresh branch name after switching with a shell command

## [0.1] - 2013-07-17

- Initial release
  - integration with other plugins: netrw, unite, nerdtree, undotree, gundo, tagbar, minibufexplr, ctrlp
  - support for themes: 8 included

[0.12]: https://github.com/vim-airline/vim-airline/compare/v0.11...HEAD
[0.11]: https://github.com/vim-airline/vim-airline/compare/v0.10...v0.11
[0.10]: https://github.com/vim-airline/vim-airline/compare/v0.9...v0.10
[0.9]: https://github.com/vim-airline/vim-airline/compare/v0.8...v0.9
[0.8]: https://github.com/vim-airline/vim-airline/compare/v0.7...v0.8
[0.7]: https://github.com/vim-airline/vim-airline/compare/v0.6...v0.7
[0.6]: https://github.com/vim-airline/vim-airline/compare/v0.5...v0.6
[0.5]: https://github.com/vim-airline/vim-airline/compare/v0.4...v0.5
[0.4]: https://github.com/vim-airline/vim-airline/compare/v0.3...v0.4
[0.3]: https://github.com/vim-airline/vim-airline/compare/v0.2...v0.3
[0.2]: https://github.com/vim-airline/vim-airline/compare/v0.1...v0.2
[0.1]: https://github.com/vim-airline/vim-airline/releases/tag/v0.1
./CONTRIBUTING.md	[[[1
45
# Contributions

Contributions and pull requests are welcome.  Please take note of the following guidelines:

*  Adhere to the existing style as much as possible; notably, 2 space indents and long-form keywords.
*  Keep the history clean!  Squash your branches before you submit a pull request.  `pull --rebase` is your friend.
*  Any changes to the core should be tested against Vim 7.4.

# Testing

Contributors should install [thinca/vim-themis](https://github.com/thinca/vim-themis) to run tests before sending a PR if they applied some modification to the code. PRs which do not pass tests won't be accepted.

## 1. Installation

```
$ cd /path/to/vim-airline
$ git submodule add https://github.com/thinca/vim-themis ./.themis-bin
```

## 2. Running tests

```
$ ./path/to/themis-bin/bin/themis path/to/vim-airline/test --reporter spec
```

# Bugs

Tracking down bugs can take a very long time due to different configurations, versions, and operating systems.  To ensure a timely response, please help me out by doing the following:

* the `:version` of vim
* the commit of vim-airline you're using
* the OS that you're using, including terminal emulator, GUI vs non-GUI

# Themes

*  If you submit a theme, please create a screenshot so it can be added to the [Wiki][14].
*  In the majority of cases, modifications to colors of existing themes will likely be rejected.  Themes are a subjective thing, so while you may prefer that a particular color be darker, another user will prefer it to be lighter, or something entirely different.  The more popular the theme, the more unlikely the change will be accepted.  However, it's pretty simple to create your own theme; copy the theme to `~/.vim/autoload/airline/themes` under a new name with your modifications, and it can be used.

# Maintenance

If you would like to take a more active role in improving vim-airline, please consider [becoming a maintainer][43].


[14]: https://github.com/vim-airline/vim-airline/wiki/Screenshots
[43]: https://github.com/vim-airline/vim-airline/wiki/Becoming-a-Maintainer
./LICENSE	[[[1
21
The MIT License (MIT)

Copyright (C) 2013-2021 Bailey Ling, Christian Brabandt, et al.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
./README.md	[[[1
372
# vim-airline

[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/chrisbra)
[![reviewdog](https://github.com/vim-airline/vim-airline/workflows/reviewdog/badge.svg?branch=master&event=push)](https://github.com/vim-airline/vim-airline/actions?query=workflow%3Areviewdog+event%3Apush+branch%3Amaster)
[![CI](https://github.com/vim-airline/vim-airline/workflows/CI/badge.svg)](https://github.com/vim-airline/vim-airline/actions?query=workflow%3ACI)

Lean & mean status/tabline for vim that's light as air.

![img](https://github.com/vim-airline/vim-airline/wiki/screenshots/demo.gif)

When the plugin is correctly loaded, there will be a nice statusline at the
bottom of each vim window.

That line consists of several sections, each one displaying some piece of
information. By default (without configuration) this line will look like this:

```
+-----------------------------------------------------------------------------+
|~                                                                            |
|~                                                                            |
|~                     VIM - Vi IMproved                                      |
|~                                                                            |
|~                       version 8.2                                          |
|~                    by Bram Moolenaar et al.                                |
|~           Vim is open source and freely distributable                      |
|~                                                                            |
|~           type :h :q<Enter>          to exit                               |
|~           type :help<Enter> or <F1>  for on-line help                      |
|~           type :help version8<Enter> for version info                      |
|~                                                                            |
|~                                                                            |
+-----------------------------------------------------------------------------+
| A | B |                     C                            X | Y | Z |  [...] |
+-----------------------------------------------------------------------------+
```

The statusline is the colored line at the bottom, which contains the sections
(possibly in different colors):

section|meaning (example)
-------|------------------
  A    | displays the mode + additional flags like crypt/spell/paste (INSERT)
  B    | Environment status (VCS information - branch, hunk summary (master), [battery][61] level)
  C    | filename + read-only flag (~/.vim/vimrc RO)
  X    | filetype  (vim)
  Y    | file encoding[fileformat] (utf-8[unix])
  Z    | current position in the file
 [...] | additional sections (warning/errors/statistics) from external plugins (e.g. YCM, syntastic, ...)

The information in Section Z looks like this:

`10% ☰ 10/100 ln : 20`

This means:
```
10%     - 10 percent down the top of the file
☰ 10    - current line 10
/100 ln - of 100 lines
: 20    - current column 20
```

For a better look, those sections can be colored differently, depending on various conditions
(e.g. the mode or whether the current file is 'modified')

# Features

*  Tiny core written with extensibility in mind ([open/closed principle][8]).
*  Integrates with a variety of plugins, including: [vim-bufferline][6],
   [fugitive][4], [flog][62], [unite][9], [ctrlp][10], [minibufexpl][15], [gundo][16],
   [undotree][17], [nerdtree][18], [tagbar][19], [vim-gitgutter][29],
   [vim-signify][30], [quickfixsigns][39], [syntastic][5], [eclim][34],
   [lawrencium][21], [virtualenv][31], [tmuxline][35], [taboo.vim][37],
   [ctrlspace][38], [vim-bufmru][47], [vimagit][50], [denite][51],
   [vim.battery][61] and more.
*  Looks good with regular fonts and provides configuration points so you can use unicode or powerline symbols.
*  Optimized for speed - loads in under a millisecond.
*  Extensive suite of themes for popular color schemes including [solarized][23] (dark and light), [tomorrow][24] (all variants), [base16][32] (all variants), [molokai][25], [jellybeans][26] and others.
 Note these are now external to this plugin. More details can be found in the [themes repository][46].
*  Supports 7.2 as the minimum Vim version.
*  The master branch tries to be as stable as possible, and new features are merged in only after they have gone through a [full regression test][33].
*  Unit testing suite.

# Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

| Plugin Manager | Install with... |
| ------------- | ------------- |
| [Pathogen][11] | `git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline`<br/>Remember to run `:Helptags` to generate help tags |
| [NeoBundle][12] | `NeoBundle 'vim-airline/vim-airline'` |
| [Vundle][13] | `Plugin 'vim-airline/vim-airline'` |
| [Plug][40] | `Plug 'vim-airline/vim-airline'` |
| [VAM][22] | `call vam#ActivateAddons([ 'vim-airline' ])` |
| [Dein][52] | `call dein#add('vim-airline/vim-airline')` |
| [minpac][55] | `call minpac#add('vim-airline/vim-airline')` |
| pack feature (native Vim 8 package feature)| `git clone https://github.com/vim-airline/vim-airline ~/.vim/pack/dist/start/vim-airline`<br/>Remember to run `:helptags ~/.vim/pack/dist/start/vim-airline/doc` to generate help tags |
| manual | copy all of the files into your `~/.vim` directory |

## Straightforward customization

If you don't like the defaults, you can replace all sections with standard `statusline` syntax.  Give your statusline that you've built over the years a face lift.

![image](https://f.cloud.github.com/assets/306502/1009429/d69306da-0b38-11e3-94bf-7c6e3eef41e9.png)

## Themes

Themes have moved to
another repository as of [this commit][45].

Install the themes as you would this plugin (Vundle example):

```vim
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
```

See [vim-airline-themes][46] for more.

## Automatic truncation

Sections and parts within sections can be configured to automatically hide when the window size shrinks.

![image](https://f.cloud.github.com/assets/306502/1060831/05c08aac-11bc-11e3-8470-a506a3037f45.png)

## Smarter tab line

Automatically displays all buffers when there's only one tab open.

![tabline](https://f.cloud.github.com/assets/306502/1072623/44c292a0-1495-11e3-9ce6-dcada3f1c536.gif)

This is disabled by default; add the following to your vimrc to enable the extension:

    let g:airline#extensions#tabline#enabled = 1

Separators can be configured independently for the tabline, so here is how you can define "straight" tabs:

    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'

In addition, you can also choose which path formatter airline uses. This affects how file paths are
displayed in each individual tab as well as the current buffer indicator in the upper right.
To do so, set the `formatter` field with:

    let g:airline#extensions#tabline#formatter = 'default'

Here is a complete list of formatters with screenshots:

#### `default`
![image](https://user-images.githubusercontent.com/2652762/34422844-1d005efa-ebe6-11e7-8053-c784c0da7ba7.png)

#### `jsformatter`
![image](https://user-images.githubusercontent.com/2652762/34422843-1cf6a4d2-ebe6-11e7-810a-07e6eb08de24.png)

#### `unique_tail`
![image](https://user-images.githubusercontent.com/2652762/34422841-1ce5b4ec-ebe6-11e7-86e9-3d45c876068b.png)

#### `unique_tail_improved`
![image](https://user-images.githubusercontent.com/2652762/34422842-1cee23f2-ebe6-11e7-962d-97e068873077.png)

## Seamless integration

vim-airline integrates with a variety of plugins out of the box.  These extensions will be lazily loaded if and only if you have the other plugins installed (and of course you can turn them off).

#### [ctrlp.vim][10]
![image](https://f.cloud.github.com/assets/306502/962258/7345a224-04ec-11e3-8b5a-f11724a47437.png)

#### [unite.vim][9]
![image](https://f.cloud.github.com/assets/306502/962319/4d7d3a7e-04ed-11e3-9d59-ab29cb310ff8.png)

#### [denite.nvim][51]
![image](https://cloud.githubusercontent.com/assets/246230/23939717/f65bce6e-099c-11e7-85c3-918dbc839392.png)

#### [tagbar][19]
![image](https://f.cloud.github.com/assets/306502/962150/7e7bfae6-04ea-11e3-9e28-32af206aed80.png)

#### [csv.vim][28]
![image](https://f.cloud.github.com/assets/306502/962204/cfc1210a-04eb-11e3-8a93-42e6bcd21efa.png)

#### [syntastic][5]
![image](https://f.cloud.github.com/assets/306502/962864/9824c484-04f7-11e3-9928-da94f8c7da5a.png)

#### hunks ([vim-gitgutter][29], [vim-signify][30], [coc-git][59] & [gitsigns.nvim][63])
![image](https://f.cloud.github.com/assets/306502/995185/73fc7054-09b9-11e3-9d45-618406c6ed98.png)

#### [vimagit][50]
![vim-airline-vimagit-demo](https://cloud.githubusercontent.com/assets/533068/22107273/2ea85ba0-de4d-11e6-9fa8-331103b88df4.gif)

#### [flog][62]
![vim-flog-airline-demo](https://user-images.githubusercontent.com/5008897/120819897-4e820280-c554-11eb-963e-6c08a1bbae09.png)

#### [virtualenv][31]
![image](https://f.cloud.github.com/assets/390964/1022566/cf81f830-0d98-11e3-904f-cf4fe3ce201e.png)

#### [tmuxline][35]
![image](https://f.cloud.github.com/assets/1532071/1559276/4c28fbac-4fc7-11e3-90ef-7e833d980f98.gif)

#### [promptline][36]
![airline-promptline-sc](https://f.cloud.github.com/assets/1532071/1871900/7d4b28a0-789d-11e3-90e4-16f37269981b.gif)

#### [ctrlspace][38]
![papercolor_with_ctrlspace](https://cloud.githubusercontent.com/assets/493242/12912041/7fc3c6ec-cf16-11e5-8775-8492b9c64ebf.png)

#### [xkb-switch][48]/[xkb-layout][49]
![image](https://cloud.githubusercontent.com/assets/5715281/22061422/347e7842-ddb8-11e6-8bdb-7abbd418653c.gif)

#### [vimtex][53]
![image](https://cloud.githubusercontent.com/assets/1798172/25799740/e77d5c2e-33ee-11e7-8660-d34ce4c5f13f.png)

#### [localsearch][54]
![image](https://raw.githubusercontent.com/mox-mox/vim-localsearch/master/vim-airline-localsearch-indicator.png)

#### [LanguageClient][57]
![image](https://user-images.githubusercontent.com/9622/45275524-52f45c00-b48b-11e8-8b83-a66240b10747.gif)

#### [Vim-CMake][60]
![image](https://user-images.githubusercontent.com/24732205/87788512-c876a380-c83d-11ea-9ee3-5f639f986a8f.png)

#### [vim.battery][61]
![image](https://user-images.githubusercontent.com/1969470/94561399-368b0e00-0264-11eb-94a0-f6b67c73d422.png)

## Extras

vim-airline also supplies some supplementary stand-alone extensions.  In addition to the tabline extension mentioned earlier, there is also:

#### whitespace
![image](https://f.cloud.github.com/assets/306502/962401/2a75385e-04ef-11e3-935c-e3b9f0e954cc.png)

### statusline on top
The statusline can alternatively be drawn on top, making room for other plugins to use the statusline:
The example shows a custom statusline setting, that imitates Vims default statusline, while allowing
to call custom functions.  Use `:let g:airline_statusline_ontop=1` to enable it.

![image](https://i.imgur.com/tW1lMRU.png)

## Configurable and extensible

#### Fine-tuned configuration

Every section is composed of parts, and you can reorder and reconfigure them at will.

![image](https://f.cloud.github.com/assets/306502/1073278/f291dd4c-14a3-11e3-8a83-268e2753f97d.png)

Sections can contain accents, which allows for very granular control of visuals (see configuration [here](https://github.com/vim-airline/vim-airline/issues/299#issuecomment-25772886)).

![image](https://f.cloud.github.com/assets/306502/1195815/4bfa38d0-249d-11e3-823e-773cfc2ca894.png)

#### Extensible pipeline

Completely transform the statusline to your liking.  Build out the statusline as you see fit by extracting colors from the current colorscheme's highlight groups.

![allyourbase](https://f.cloud.github.com/assets/306502/1022714/e150034a-0da7-11e3-94a5-ca9d58a297e8.png)

# Rationale

There's already [powerline][2], why yet another statusline?

*  100% vimscript; no python needed.

What about [vim-powerline][1]?

*  vim-powerline has been deprecated in favor of the newer, unifying powerline, which is under active development; the new version is written in python at the core and exposes various bindings such that it can style statuslines not only in vim, but also tmux, bash, zsh, and others.

# Where did the name come from?

I wrote the initial version on an airplane, and since it's light as air it turned out to be a good name.  Thanks for flying vim!

# Documentation

`:help airline`

# Integrating with powerline fonts

For the nice looking powerline symbols to appear, you will need to install a patched font.  Instructions can be found in the official powerline [documentation][20].  Prepatched fonts can be found in the [powerline-fonts][3] repository.

Finally, you can add the convenience variable `let g:airline_powerline_fonts = 1` to your vimrc which will automatically populate the `g:airline_symbols` dictionary with the powerline symbols.

# FAQ

Solutions to common problems can be found in the [Wiki][27].

# Performance

Whoa! Everything got slow all of a sudden...

vim-airline strives to make it easy to use out of the box, which means that by default it will look for all compatible plugins that you have installed and enable the relevant extension.

Many optimizations have been made such that the majority of users will not see any performance degradation, but it can still happen.  For example, users who routinely open very large files may want to disable the `tagbar` extension, as it can be very expensive to scan for the name of the current function.

The [minivimrc][7] project has some helper mappings to troubleshoot performance related issues.

If you don't want all the bells and whistles enabled by default, you can define a value for `g:airline_extensions`.  When this variable is defined, only the extensions listed will be loaded; an empty array would effectively disable all extensions (e.g. `:let g:airline_extensions = []`).

Also, you can enable caching of the various syntax highlighting groups. This will try to prevent some of the more expensive `:hi` calls in Vim, which seem to be expensive in the Vim core at the expense of possibly not being one hundred percent correct all the time (especially if you often change highlighting groups yourself using `:hi` commands). To set this up do `:let g:airline_highlighting_cache = 1`. A `:AirlineRefresh` will however clear the cache.

In addition you might want to check out the [dark_minimal theme][56], which does not change highlighting groups once they are defined. Also please check the [FAQ][27] for more information on how to diagnose and fix the problem.

# Screenshots

A full list of screenshots for various themes can be found in the [Wiki][14].

# Maintainers

The project is currently being maintained by [Christian Brabandt][42] and [Bailey Ling][41].

If you are interested in becoming a maintainer (we always welcome more maintainers), please [go here][43].

# License

[MIT License][58]. Copyright (c) 2013-2021 Bailey Ling & Contributors.

[1]: https://github.com/Lokaltog/vim-powerline
[2]: https://github.com/powerline/powerline
[3]: https://github.com/Lokaltog/powerline-fonts
[4]: https://github.com/tpope/vim-fugitive
[5]: https://github.com/scrooloose/syntastic
[6]: https://github.com/bling/vim-bufferline
[7]: https://github.com/bling/minivimrc
[8]: http://en.wikipedia.org/wiki/Open/closed_principle
[9]: https://github.com/Shougo/unite.vim
[10]: https://github.com/ctrlpvim/ctrlp.vim
[11]: https://github.com/tpope/vim-pathogen
[12]: https://github.com/Shougo/neobundle.vim
[13]: https://github.com/VundleVim/Vundle.vim
[14]: https://github.com/vim-airline/vim-airline/wiki/Screenshots
[15]: https://github.com/techlivezheng/vim-plugin-minibufexpl
[16]: https://github.com/sjl/gundo.vim
[17]: https://github.com/mbbill/undotree
[18]: https://github.com/preservim/nerdtree
[19]: https://github.com/majutsushi/tagbar
[20]: https://powerline.readthedocs.org/en/master/installation.html#patched-fonts
[21]: https://github.com/ludovicchabant/vim-lawrencium
[22]: https://github.com/MarcWeber/vim-addon-manager
[23]: https://github.com/altercation/solarized
[24]: https://github.com/chriskempson/tomorrow-theme
[25]: https://github.com/tomasr/molokai
[26]: https://github.com/nanotech/jellybeans.vim
[27]: https://github.com/vim-airline/vim-airline/wiki/FAQ
[28]: https://github.com/chrisbra/csv.vim
[29]: https://github.com/airblade/vim-gitgutter
[30]: https://github.com/mhinz/vim-signify
[31]: https://github.com/jmcantrell/vim-virtualenv
[32]: https://github.com/chriskempson/base16-vim
[33]: https://github.com/vim-airline/vim-airline/wiki/Test-Plan
[34]: http://eclim.org
[35]: https://github.com/edkolev/tmuxline.vim
[36]: https://github.com/edkolev/promptline.vim
[37]: https://github.com/gcmt/taboo.vim
[38]: https://github.com/vim-ctrlspace/vim-ctrlspace
[39]: https://github.com/tomtom/quickfixsigns_vim
[40]: https://github.com/junegunn/vim-plug
[41]: https://github.com/bling
[42]: https://github.com/chrisbra
[43]: https://github.com/vim-airline/vim-airline/wiki/Becoming-a-Maintainer
[45]: https://github.com/vim-airline/vim-airline/commit/d7fd8ca649e441b3865551a325b10504cdf0711b
[46]: https://github.com/vim-airline/vim-airline-themes#vim-airline-themes--
[47]: https://github.com/mildred/vim-bufmru
[48]: https://github.com/ierton/xkb-switch
[49]: https://github.com/vovkasm/input-source-switcher
[50]: https://github.com/jreybert/vimagit
[51]: https://github.com/Shougo/denite.nvim
[52]: https://github.com/Shougo/dein.vim
[53]: https://github.com/lervag/vimtex
[54]: https://github.com/mox-mox/vim-localsearch
[55]: https://github.com/k-takata/minpac/
[56]: https://github.com/vim-airline/vim-airline-themes/blob/master/autoload/airline/themes/dark_minimal.vim
[57]: https://github.com/autozimu/LanguageClient-neovim
[58]: https://github.com/vim-airline/vim-airline/blob/master/LICENSE
[59]: https://github.com/neoclide/coc-git
[60]: https://github.com/cdelledonne/vim-cmake
[61]: http://github.com/lambdalisue/battery.vim/
[62]: http://github.com/rbong/vim-flog/
[63]: https://github.com/lewis6991/gitsigns.nvim
./autoload/airline/async.vim	[[[1
382
" MIT License. Copyright (c) 2013-2021 Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:untracked_jobs = {}
let s:mq_jobs        = {}
let s:po_jobs        = {}
let s:clean_jobs     = {}

" Generic functions handling on exit event of the various async functions
function! s:untracked_output(dict, buf)
  if a:buf =~? ('^'. a:dict.cfg['untracked_mark'])
    let a:dict.cfg.untracked[a:dict.file] = get(g:, 'airline#extensions#branch#notexists', g:airline_symbols.notexists)
  else
    let a:dict.cfg.untracked[a:dict.file] = ''
  endif
endfunction

" also called from branch extension (for non-async vims)
function! airline#async#mq_output(buf, file)
  let buf=a:buf
  if !empty(a:buf)
    if a:buf =~# 'no patches applied' ||
      \ a:buf =~# "unknown command 'qtop'" ||
      \ a:buf =~# "abort"
      let buf = ''
    elseif exists("b:mq") && b:mq isnot# buf
      " make sure, statusline is updated
      unlet! b:airline_head
    endif
    let b:mq = buf
  endif
  if has_key(s:mq_jobs, a:file)
    call remove(s:mq_jobs, a:file)
  endif
endfunction

function! s:po_output(buf, file)
  if !empty(a:buf)
    let b:airline_po_stats = printf("%s", a:buf)
  else
    let b:airline_po_stats = ''
  endif
  if has_key(s:po_jobs, a:file)
    call remove(s:po_jobs, a:file)
  endif
endfunction

function! s:valid_dir(dir)
  if empty(a:dir) || !isdirectory(a:dir)
    return getcwd()
  endif
  return a:dir
endfunction

function! airline#async#vcs_untracked(config, file, vcs)
  if g:airline#init#vim_async
    " Vim 8 with async support
    noa call airline#async#vim_vcs_untracked(a:config, a:file)
  else
    " nvim async or vim without job-feature
    noa call airline#async#nvim_vcs_untracked(a:config, a:file, a:vcs)
  endif
endfunction

function! s:set_clean_variables(file, vcs, val)
  let var=getbufvar(fnameescape(a:file), 'buffer_vcs_config', {})
  if has_key(var, a:vcs) && has_key(var[a:vcs], 'dirty') &&
        \ type(getbufvar(fnameescape(a:file), 'buffer_vcs_config')) == type({})
    let var[a:vcs].dirty=a:val
    try
      call setbufvar(fnameescape(a:file), 'buffer_vcs_config', var)
      unlet! b:airline_head
    catch
    endtry
  endif
endfunction

function! s:set_clean_jobs_variable(vcs, file, id)
  if !has_key(s:clean_jobs, a:vcs)
    let s:clean_jobs[a:vcs] = {}
  endif
  let s:clean_jobs[a:vcs][a:file]=a:id
endfunction

function! s:on_exit_clean(...) dict abort
  let buf=self.buf
  call s:set_clean_variables(self.file, self.vcs, !empty(buf))
  if has_key(get(s:clean_jobs, self.vcs, {}), self.file)
    call remove(s:clean_jobs[self.vcs], self.file)
  endif
endfunction

function! airline#async#vcs_clean(cmd, file, vcs)
  if g:airline#init#vim_async
    " Vim 8 with async support
    noa call airline#async#vim_vcs_clean(a:cmd, a:file, a:vcs)
  elseif has("nvim")
    " nvim async
    noa call airline#async#nvim_vcs_clean(a:cmd, a:file, a:vcs)
  else
    " Vim pre 8 using system()
    call airline#async#vim7_vcs_clean(a:cmd, a:file, a:vcs)
  endif
endfunction

if v:version >= 800 && has("job")
  " Vim 8.0 with Job feature
  " TODO: Check if we need the cwd option for the job_start() functions
  "       (only works starting with Vim 8.0.0902)

  function! s:on_stdout(channel, msg) dict abort
    let self.buf .= a:msg
  endfunction

  function! s:on_exit_mq(channel) dict abort
    call airline#async#mq_output(self.buf, self.file)
  endfunction

  function! s:on_exit_untracked(channel) dict abort
    call s:untracked_output(self, self.buf)
    if has_key(s:untracked_jobs, self.file)
      call remove(s:untracked_jobs, self.file)
    endif
  endfunction

  function! s:on_exit_po(channel) dict abort
    call s:po_output(self.buf, self.file)
    call airline#extensions#po#shorten()
  endfunction

  function! airline#async#get_mq_async(cmd, file)
    if g:airline#init#is_windows && &shell =~ 'cmd\|powershell'
      let cmd = a:cmd
    else
      let cmd = [&shell, &shellcmdflag, a:cmd]
    endif

    let options = {'cmd': a:cmd, 'buf': '', 'file': a:file}
    if has_key(s:mq_jobs, a:file)
      if job_status(get(s:mq_jobs, a:file)) == 'run'
        return
      elseif has_key(s:mq_jobs, a:file)
        call remove(s:mq_jobs, a:file)
      endif
    endif
    let id = job_start(cmd, {
          \ 'err_io':   'out',
          \ 'out_cb':   function('s:on_stdout', options),
          \ 'close_cb': function('s:on_exit_mq', options)})
    let s:mq_jobs[a:file] = id
  endfunction

  function! airline#async#get_msgfmt_stat(cmd, file)
    if !executable('msgfmt')
      " no msgfmt
      return
    endif
    if g:airline#init#is_windows
      let cmd = 'cmd /C ' . a:cmd. shellescape(a:file)
    else
      let cmd = ['sh', '-c', a:cmd. shellescape(a:file)]
    endif

    let options = {'buf': '', 'file': a:file}
    if has_key(s:po_jobs, a:file)
      if job_status(get(s:po_jobs, a:file)) == 'run'
        return
      elseif has_key(s:po_jobs, a:file)
        call remove(s:po_jobs, a:file)
      endif
    endif
    let id = job_start(cmd, {
          \ 'err_io':   'out',
          \ 'out_cb':   function('s:on_stdout', options),
          \ 'close_cb': function('s:on_exit_po', options)})
    let s:po_jobs[a:file] = id
  endfunction

  function! airline#async#vim_vcs_clean(cmd, file, vcs)
    if g:airline#init#is_windows && &shell =~ 'cmd\|powershell'
      let cmd = a:cmd
    else
      let cmd = [&shell, &shellcmdflag, a:cmd]
    endif

    let options = {'buf': '', 'vcs': a:vcs, 'file': a:file}
    let jobs = get(s:clean_jobs, a:vcs, {})
    if has_key(jobs, a:file)
      if job_status(get(jobs, a:file)) == 'run'
        return
      elseif has_key(jobs, a:file)
        " still running
        return
        " jobs dict should be cleaned on exit, so not needed here
        " call remove(jobs, a:file)
      endif
    endif
    let id = job_start(cmd, {
          \ 'err_io':   'null',
          \ 'out_cb':   function('s:on_stdout', options),
          \ 'close_cb': function('s:on_exit_clean', options)})
    call s:set_clean_jobs_variable(a:vcs, a:file, id)
  endfunction

  function! airline#async#vim_vcs_untracked(config, file)
    if g:airline#init#is_windows && &shell =~ 'cmd\|powershell'
      let cmd = a:config['cmd'] . shellescape(a:file)
    else
      let cmd = [&shell, &shellcmdflag, a:config['cmd'] . shellescape(a:file)]
    endif

    let options = {'cfg': a:config, 'buf': '', 'file': a:file}
    if has_key(s:untracked_jobs, a:file)
      if job_status(get(s:untracked_jobs, a:file)) == 'run'
        return
      elseif has_key(s:untracked_jobs, a:file)
        call remove(s:untracked_jobs, a:file)
      endif
    endif
    let id = job_start(cmd, {
          \ 'err_io':   'out',
          \ 'out_cb':   function('s:on_stdout', options),
          \ 'close_cb': function('s:on_exit_untracked', options)})
    let s:untracked_jobs[a:file] = id
  endfunction

elseif has("nvim")
  " NVim specific functions

  function! s:nvim_output_handler(job_id, data, event) dict
    if a:event == 'stdout' || a:event == 'stderr'
      let self.buf .=  join(a:data)
    endif
  endfunction

  function! s:nvim_untracked_job_handler(job_id, data, event) dict
    if a:event == 'exit'
      call s:untracked_output(self, self.buf)
      if has_key(s:untracked_jobs, self.file)
        call remove(s:untracked_jobs, self.file)
      endif
    endif
  endfunction

  function! s:nvim_mq_job_handler(job_id, data, event) dict
    if a:event == 'exit'
      call airline#async#mq_output(self.buf, self.file)
    endif
  endfunction

  function! s:nvim_po_job_handler(job_id, data, event) dict
    if a:event == 'exit'
      call s:po_output(self.buf, self.file)
      call airline#extensions#po#shorten()
    endif
  endfunction

  function! airline#async#nvim_get_mq_async(cmd, file)
    let config = {
    \ 'buf': '',
    \ 'file': a:file,
    \ 'cwd': s:valid_dir(fnamemodify(a:file, ':p:h')),
    \ 'on_stdout': function('s:nvim_output_handler'),
    \ 'on_stderr': function('s:nvim_output_handler'),
    \ 'on_exit': function('s:nvim_mq_job_handler')
    \ }
    if g:airline#init#is_windows && &shell =~ 'cmd\|powershell'
      let cmd = a:cmd
    else
      let cmd = [&shell, &shellcmdflag, a:cmd]
    endif

    if has_key(s:mq_jobs, a:file)
      call remove(s:mq_jobs, a:file)
    endif
    let id = jobstart(cmd, config)
    let s:mq_jobs[a:file] = id
  endfunction

  function! airline#async#nvim_get_msgfmt_stat(cmd, file)
    let config = {
    \ 'buf': '',
    \ 'file': a:file,
    \ 'cwd': s:valid_dir(fnamemodify(a:file, ':p:h')),
    \ 'on_stdout': function('s:nvim_output_handler'),
    \ 'on_stderr': function('s:nvim_output_handler'),
    \ 'on_exit': function('s:nvim_po_job_handler')
    \ }
    if g:airline#init#is_windows && &shell =~ 'cmd\|powershell'
      " no msgfmt on windows?
      return
    else
      let cmd = [&shell, &shellcmdflag, a:cmd. shellescape(a:file)]
    endif

    if has_key(s:po_jobs, a:file)
      call remove(s:po_jobs, a:file)
    endif
    let id = jobstart(cmd, config)
    let s:po_jobs[a:file] = id
  endfunction

  function! airline#async#nvim_vcs_clean(cmd, file, vcs)
    let config = {
    \ 'buf': '',
    \ 'vcs': a:vcs,
    \ 'file': a:file,
    \ 'cwd': s:valid_dir(fnamemodify(a:file, ':p:h')),
    \ 'on_stdout': function('s:nvim_output_handler'),
    \ 'on_stderr': function('s:nvim_output_handler'),
    \ 'on_exit': function('s:on_exit_clean')}
    if g:airline#init#is_windows && &shell =~ 'cmd\|powershell'
      let cmd = a:cmd
    else
      let cmd = [&shell, &shellcmdflag, a:cmd]
    endif

    if !has_key(s:clean_jobs, a:vcs)
      let s:clean_jobs[a:vcs] = {}
    endif
    if has_key(s:clean_jobs[a:vcs], a:file)
      " still running
      return
      " jobs dict should be cleaned on exit, so not needed here
      " call remove(s:clean_jobs[a:vcs], a:file)
    endif
    let id = jobstart(cmd, config)
    call s:set_clean_jobs_variable(a:vcs, a:file, id)
  endfunction

endif

" Should work in either Vim pre 8 or Nvim
function! airline#async#nvim_vcs_untracked(cfg, file, vcs)
  let cmd = a:cfg.cmd . shellescape(a:file)
  let id = -1
  let config = {
  \ 'buf': '',
  \ 'vcs': a:vcs,
  \ 'cfg': a:cfg,
  \ 'file': a:file,
  \ 'cwd': s:valid_dir(fnamemodify(a:file, ':p:h'))
  \ }
  if has("nvim")
    call extend(config, {
    \ 'on_stdout': function('s:nvim_output_handler'),
    \ 'on_exit': function('s:nvim_untracked_job_handler')})
    if has_key(s:untracked_jobs, config.file)
      " still running
      return
    endif
    try
    let id = jobstart(cmd, config)
    catch
      " catch-all, jobstart() failed, fall back to system()
      let id=-1
    endtry
    let s:untracked_jobs[a:file] = id
  endif
  " vim without job feature or nvim jobstart failed
  if id < 1
    let output=system(cmd)
    call s:untracked_output(config, output)
    call airline#extensions#branch#update_untracked_config(a:file, a:vcs)
  endif
endfunction

function! airline#async#vim7_vcs_clean(cmd, file, vcs)
  " Vim pre 8, fallback using system()
  " don't want to to see error messages
  if g:airline#init#is_windows && &shell =~ 'cmd'
    let cmd = a:cmd .' 2>nul'
  elseif g:airline#init#is_windows && &shell =~ 'powerline'
    let cmd = a:cmd .' 2> $null'
  else
    let cmd = a:cmd .' 2>/dev/null'
  endif
  let output=system(cmd)
  call s:set_clean_variables(a:file, a:vcs, !empty(output))
endfunction
./autoload/airline/builder.vim	[[[1
246
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

function! s:prototype.split(...) dict
  call add(self._sections, ['|', a:0 ? a:1 : '%='])
endfunction

function! s:prototype.add_section_spaced(group, contents) dict
  let spc = empty(a:contents) ? '' : g:airline_symbols.space
  call self.add_section(a:group, spc.a:contents.spc)
endfunction

function! s:prototype.add_section(group, contents) dict
  call add(self._sections, [a:group, a:contents])
endfunction

function! s:prototype.add_raw(text) dict
  call add(self._sections, ['', a:text])
endfunction

function! s:prototype.insert_section(group, contents, position) dict
  call insert(self._sections, [a:group, a:contents], a:position)
endfunction

function! s:prototype.insert_raw(text, position) dict
  call insert(self._sections, ['', a:text], a:position)
endfunction

function! s:prototype.get_position() dict
  return len(self._sections)
endfunction

function! airline#builder#get_prev_group(sections, i)
  let x = a:i - 1
  while x >= 0
    let group = a:sections[x][0]
    if group != '' && group != '|'
      return group
    endif
    let x = x - 1
  endwhile
  return ''
endfunction

function! airline#builder#get_next_group(sections, i)
  let x = a:i + 1
  let l = len(a:sections)
  while x < l
    let group = a:sections[x][0]
    if group != '' && group != '|'
      return group
    endif
    let x = x + 1
  endwhile
  return ''
endfunction

function! s:prototype.build() dict
  let side = 1
  let line = ''
  let i = 0
  let length = len(self._sections)
  let split = 0
  let is_empty = 0
  let prev_group = ''

  while i < length
    let section = self._sections[i]
    let group = section[0]
    let contents = section[1]
    let pgroup = prev_group
    let prev_group = airline#builder#get_prev_group(self._sections, i)
    if group ==# 'airline_c' && &buftype ==# 'terminal' && self._context.active
      let group = 'airline_term'
    elseif group ==# 'airline_c' && !self._context.active && has_key(self._context, 'bufnr')
      let group = 'airline_c'. self._context.bufnr
    elseif prev_group ==# 'airline_c' && !self._context.active && has_key(self._context, 'bufnr')
      let prev_group = 'airline_c'. self._context.bufnr
    endif
    if is_empty
      let prev_group = pgroup
    endif
    let is_empty = s:section_is_empty(self, contents)

    if is_empty
      " need to fix highlighting groups, since we
      " have skipped a section, we actually need
      " the previous previous group and so the
      " separator goes from the previous previous group
      " to the current group
      let pgroup = group
    endif

    if group == ''
      let line .= contents
    elseif group == '|'
      let side = 0
      let line .= contents
      let split = 1
    else
      if prev_group == ''
        let line .= '%#'.group.'#'
      elseif split
        if !is_empty
          let line .= s:get_transitioned_separator(self, prev_group, group, side)
        endif
        let split = 0
      else
        if !is_empty
          let line .= s:get_separator(self, prev_group, group, side)
        endif
      endif
      let line .= is_empty ? '' : s:get_accented_line(self, group, contents)
    endif

    let i = i + 1
  endwhile

  if !self._context.active
    "let line = substitute(line, '%#airline_c#', '%#airline_c'.self._context.bufnr.'#', '')
    let line = substitute(line, '%#.\{-}\ze#', '\0_inactive', 'g')
  endif
  return line
endfunction

function! airline#builder#should_change_group(group1, group2)
  if a:group1 == a:group2
    return 0
  endif
  let color1 = airline#highlighter#get_highlight(a:group1)
  let color2 = airline#highlighter#get_highlight(a:group2)
  return color1[1] != color2[1] || color1[0] != color2[0]
      \ ||  color1[2] != color2[2] || color1[3] != color2[3]
endfunction

function! s:get_transitioned_separator(self, prev_group, group, side)
  let line = ''
  if get(a:self._context, 'tabline', 0) && get(g:, 'airline#extensions#tabline#alt_sep', 0) && a:group ==# 'airline_tabsel' && a:side
    call airline#highlighter#add_separator(a:prev_group, a:group, 0)
    let line .= '%#'.a:prev_group.'_to_'.a:group.'#'
    let line .=  a:self._context.right_sep.'%#'.a:group.'#'
  else
    call airline#highlighter#add_separator(a:prev_group, a:group, a:side)
    let line .= '%#'.a:prev_group.'_to_'.a:group.'#'
    let line .= a:side ? a:self._context.left_sep : a:self._context.right_sep
    let line .= '%#'.a:group.'#'
  endif
  return line
endfunction

function! s:get_separator(self, prev_group, group, side)
  if airline#builder#should_change_group(a:prev_group, a:group)
    return s:get_transitioned_separator(a:self, a:prev_group, a:group, a:side)
  else
    return a:side ? a:self._context.left_alt_sep : a:self._context.right_alt_sep
  endif
endfunction

function! s:get_accented_line(self, group, contents)
  if a:self._context.active
    " active window
    let contents = []
    let content_parts = split(a:contents, '__accent')
    for cpart in content_parts
      let accent = matchstr(cpart, '_\zs[^#]*\ze')
      call add(contents, cpart)
    endfor
    let line = join(contents, a:group)
    let line = substitute(line, '__restore__', a:group, 'g')
  else
    " inactive window
    let line = substitute(a:contents, '%#__accent[^#]*#', '', 'g')
    let line = substitute(line, '%#__restore__#', '', 'g')
  endif
  return line
endfunction

function! s:section_is_empty(self, content)
  let start=1

  " do not check for inactive windows or the tabline
  if a:self._context.active == 0
    return 0
  elseif get(a:self._context, 'tabline', 0)
    return 0
  endif

  " only check, if airline#skip_empty_sections == 1
  if get(g:, 'airline_skip_empty_sections', 0) == 0
    return 0
  endif

  " only check, if airline#skip_empty_sections == 1
  if get(w:, 'airline_skip_empty_sections', -1) == 0
    return 0
  endif

  " special case: When the content is %=, that is the
  " separation marker, which switches between left- and
  " right-aligned content.
  " Consider that to be empty, so that the previous previous
  " group is correctly remembered in the builder() function
  if empty(a:content) || a:content is# '%='
    return 1
  endif

  let stripped = substitute(a:content,
        \ '\(%{.*}\|%#__accent_[^#]*#\|%#__restore__#\|%( \| %)\)', '', 'g')

  if !empty(stripped)
    return 0 " There is content in the statusline
  endif

  let exprlist = []
  call substitute(a:content, '%{\([^}]*\)}', '\=add(exprlist, submatch(1))', 'g')

  for expr in exprlist
    try
      " catch all exceptions, just in case
      if !empty(eval(expr))
        return 0
      endif
    catch
      return 0
    endtry
  endfor
  return 1
endfunction

function! airline#builder#new(context)
  let builder = copy(s:prototype)
  let builder._context = a:context
  let builder._sections = []

  call extend(builder._context, {
        \ 'left_sep': g:airline_left_sep,
        \ 'left_alt_sep': g:airline_left_alt_sep,
        \ 'right_sep': g:airline_right_sep,
        \ 'right_alt_sep': g:airline_right_alt_sep,
        \ }, 'keep')
  return builder
endfunction
./autoload/airline/debug.vim	[[[1
51
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#debug#profile1()
  profile start airline-profile-switch.log
  profile func *
  profile file *
  split
  for i in range(1, 1000)
    wincmd w
    redrawstatus
  endfor
  profile pause
  noautocmd qall!
endfunction

function! airline#debug#profile2()
  profile start airline-profile-cursor.log
  profile func *
  profile file *
  edit blank
  call setline(1, 'all your base are belong to us')
  call setline(2, 'all your base are belong to us')
  let positions = [[1,2], [2,2], [1,2], [1,1]]
  for i in range(1, 1000)
    for pos in positions
      call cursor(pos[0], pos[1])
      redrawstatus
    endfor
  endfor
  profile pause
  noautocmd qall!
endfunction

function! airline#debug#profile3()
  profile start airline-profile-mode.log
  profile func *
  profile file *

  for i in range(1000)
    startinsert
    redrawstatus
    stopinsert
    redrawstatus
  endfor

  profile pause
  noautocmd qall!
endfunction
./autoload/airline/extensions/ale.vim	[[[1
138
" MIT License. Copyright (c) 2013-2021 Bjorn Neergaard, w0rp et al.
" Plugin: https://github.com/dense-analysis/ale
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_ale_dont_use_this_in_other_plugins_please', 0)
  finish
endif

function! s:airline_ale_count(cnt, symbol)
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! s:legacy_airline_ale_get_line_number(cnt, type) abort
  " Before ALE introduced the FirstProblem API function, this is how
  " airline would get the line numbers:
  " 1. Get the whole loclist; 2. Filter it for the desired problem type.
  " 3. Return the line number of the first element in the filtered list.
  if a:cnt == 0
    return ''
  endif

  let buffer       = bufnr('')
  let problem_type = (a:type ==# 'error') ? 'E' : 'W'
  let problems     = copy(ale#engine#GetLoclist(buffer))

  call filter(problems, 'v:val.bufnr is buffer && v:val.type is# problem_type')

  if empty(problems)
    return ''
  endif

  let open_lnum_symbol  = get(g:, 'airline#extensions#ale#open_lnum_symbol', '(L')
  let close_lnum_symbol = get(g:, 'airline#extensions#ale#close_lnum_symbol', ')')

  return open_lnum_symbol . problems[0].lnum . close_lnum_symbol
endfunction

function! s:new_airline_ale_get_line_number(cnt, type) abort
  " The FirstProblem call in ALE is a far more efficient way
  " of obtaining line number data. If the installed ALE supports
  " it, we should use this method of getting line data.
  if a:cnt == 0
    return ''
  endif
  let l:buffer = bufnr('')

  " Try to get the first error from ALE.
  let l:result = ale#statusline#FirstProblem(l:buffer, a:type)
  if empty(l:result)
    " If there are no errors then try and check for style errors.
    let l:result =  ale#statusline#FirstProblem(l:buffer, 'style_' . a:type)
  endif

  if empty(l:result)
      return ''
  endif

  let l:open_lnum_symbol  =
    \ get(g:, 'airline#extensions#ale#open_lnum_symbol', '(L')
  let l:close_lnum_symbol =
    \ get(g:, 'airline#extensions#ale#close_lnum_symbol', ')')

  return open_lnum_symbol . l:result.lnum . close_lnum_symbol
endfunction

function! s:airline_ale_get_line_number(cnt, type) abort
  " Use the new ALE statusline API function if it is available.
  if exists("*ale#statusline#FirstProblem")
    return s:new_airline_ale_get_line_number(a:cnt, a:type)
  endif

  return s:legacy_airline_ale_get_line_number(a:cnt, a:type)
endfunction

function! airline#extensions#ale#get(type)
  if !exists(':ALELint')
    return ''
  endif

  let error_symbol = get(g:, 'airline#extensions#ale#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#ale#warning_symbol', 'W:')
  let checking_symbol = get(g:, 'airline#extensions#ale#checking_symbol', '...')
  let show_line_numbers = get(g:, 'airline#extensions#ale#show_line_numbers', 1)

  let is_err = a:type ==# 'error'

  if ale#engine#IsCheckingBuffer(bufnr('')) == 1
    return is_err ? '' : checking_symbol
  endif

  let symbol = is_err ? error_symbol : warning_symbol

  let counts = ale#statusline#Count(bufnr(''))
  if type(counts) == type({}) && has_key(counts, 'error')
    " Use the current Dictionary format.
    let errors = counts.error + counts.style_error
    let num = is_err ? errors : counts.total - errors
  else
    " Use the old List format.
    let num = is_err ? counts[0] : counts[1]
  endif

  if show_line_numbers == 1
    return s:airline_ale_count(num, symbol) . <sid>airline_ale_get_line_number(num, a:type)
  else
    return s:airline_ale_count(num, symbol)
  endif
endfunction

function! airline#extensions#ale#get_warning()
  return airline#extensions#ale#get('warning')
endfunction

function! airline#extensions#ale#get_error()
  return airline#extensions#ale#get('error')
endfunction

function! airline#extensions#ale#init(ext)
  call airline#parts#define_function('ale_error_count', 'airline#extensions#ale#get_error')
  call airline#parts#define_function('ale_warning_count', 'airline#extensions#ale#get_warning')
  augroup airline_ale
    autocmd!
    autocmd CursorHold,BufWritePost * call <sid>ale_refresh()
    autocmd User ALEJobStarted,ALELintPost call <sid>ale_refresh()
  augroup END
endfunction

function! s:ale_refresh()
  if !exists('#airline')
    " airline disabled
    return
  endif
  if get(g:, 'airline_skip_empty_sections', 0)
    exe ':AirlineRefresh!'
  endif
endfunction
./autoload/airline/extensions/battery.vim	[[[1
23
" MIT License. Copyright (c) 2014-2021 Mathias Andersson et al.
" Plugin: https://github.com/lambdalisue/battery.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:loaded_battery')
  finish
endif

function! airline#extensions#battery#status(...) abort
  if !exists('g:battery#update_statusline')
    let g:battery#update_statusline = 1
    call battery#update()
  endif

  let bat = battery#component()
  return bat
endfunction

function! airline#extensions#battery#init(ext) abort
  call airline#parts#define_function('battery', 'airline#extensions#battery#status')
endfunction
./autoload/airline/extensions/bookmark.vim	[[[1
30
" MIT License. Copyright (c) 2021 Bjoern Petri <bjoern.petri@sundevil.de>
" Plugin: https://github.com/MattesGroeger/vim-bookmarks
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':BookmarkToggle')
  finish
endif

function! airline#extensions#bookmark#currentbookmark() abort
  if get(w:, 'airline_active', 0)
    let file = expand('%:p')
    if file ==# ''
      return
    endif

    let current_line = line('.')
    let has_bm = bm#has_bookmark_at_line(file, current_line)
    let bm = has_bm ? bm#get_bookmark_by_line(file, current_line) : 0
    let annotation = has_bm ? bm['annotation'] : ''

    return annotation
  endif
  return ''
endfunction

function! airline#extensions#bookmark#init(ext) abort
  call airline#parts#define_function('bookmark', 'airline#extensions#bookmark#currentbookmark')
endfunction
./autoload/airline/extensions/branch.vim	[[[1
369
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: fugitive, gina, lawrencium and vcscommand
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

" s:vcs_config contains static configuration of VCSes and their status relative
" to the active file.
" 'branch'    - The name of currently active branch. This field is empty iff it
"               has not been initialized yet or the current file is not in
"               an active branch.
" 'untracked' - Cache of untracked files represented as a dictionary with files
"               as keys. A file has a not exists symbol set as its value if it
"               is untracked. A file is present in this dictionary iff its
"               status is considered up to date.
" 'untracked_mark' - used as regexp to test against the output of 'cmd'
let s:vcs_config = {
\  'git': {
\    'exe': 'git',
\    'cmd': 'git status --porcelain -- ',
\    'dirty': 'git status -uno --porcelain --ignore-submodules',
\    'untracked_mark': '??',
\    'exclude': '\.git',
\    'update_branch': 's:update_git_branch',
\    'display_branch': 's:display_git_branch',
\    'branch': '',
\    'untracked': {},
\  },
\  'mercurial': {
\    'exe': 'hg',
\    'cmd': 'hg status -u -- ',
\    'dirty': 'hg status -mard',
\    'untracked_mark': '?',
\    'exclude': '\.hg',
\    'update_branch': 's:update_hg_branch',
\    'display_branch': 's:display_hg_branch',
\    'branch': '',
\    'untracked': {},
\  },
\}

" Initializes b:buffer_vcs_config. b:buffer_vcs_config caches the branch and
" untracked status of the file in the buffer. Caching those fields is necessary,
" because s:vcs_config may be updated asynchronously and s:vcs_config fields may
" be invalid during those updates. b:buffer_vcs_config fields are updated
" whenever corresponding fields in s:vcs_config are updated or an inconsistency
" is detected during update_* operation.
"
" b:airline_head caches the head string it is empty iff it needs to be
" recalculated. b:airline_head is recalculated based on b:buffer_vcs_config.
function! s:init_buffer()
  let b:buffer_vcs_config = {}
  for vcs in keys(s:vcs_config)
    let b:buffer_vcs_config[vcs] = {
          \     'branch': '',
          \     'untracked': '',
          \     'dirty': 0,
          \   }
  endfor
  unlet! b:airline_head
endfunction

let s:head_format = get(g:, 'airline#extensions#branch#format', 0)
if s:head_format == 1
  function! s:format_name(name)
    return fnamemodify(a:name, ':t')
  endfunction
elseif s:head_format == 2
  function! s:format_name(name)
    return pathshorten(a:name)
  endfunction
elseif type(s:head_format) == type('')
  function! s:format_name(name)
    return call(s:head_format, [a:name])
  endfunction
else
  function! s:format_name(name)
    return a:name
  endfunction
endif


" Fugitive special revisions. call '0' "staging" ?
let s:names = {'0': 'index', '1': 'orig', '2':'fetch', '3':'merge'}
let s:sha1size = get(g:, 'airline#extensions#branch#sha1_len', 7)

function! s:update_git_branch()
  call airline#util#ignore_next_focusgain()
  if airline#util#has_fugitive()
    call s:config_fugitive_branch()
  elseif airline#util#has_gina()
    call s:config_gina_branch()
  else
    let s:vcs_config['git'].branch = ''
    return
  endif
endfunction

function! s:config_fugitive_branch() abort
  let s:vcs_config['git'].branch =  FugitiveHead(s:sha1size)
  if s:vcs_config['git'].branch is# 'master' &&
        \ airline#util#winwidth() < 81
    " Shorten default a bit
    let s:vcs_config['git'].branch='mas'
  endif
endfunction

function! s:config_gina_branch() abort
  try
    let g:gina#component#repo#commit_length = s:sha1size
    let s:vcs_config['git'].branch = gina#component#repo#branch()
  catch
  endtry
  if s:vcs_config['git'].branch is# 'master' &&
        \ airline#util#winwidth() < 81
    " Shorten default a bit
    let s:vcs_config['git'].branch='mas'
  endif
endfunction

function! s:display_git_branch()
  let name = b:buffer_vcs_config['git'].branch
  try
    let commit = matchstr(FugitiveParse()[0], '^\x\+')

    if has_key(s:names, commit)
      let name = get(s:names, commit)."(".name.")"
    elseif !empty(commit)
      if exists('*FugitiveExecute')
        let ref = FugitiveExecute(['describe', '--all', '--exact-match', commit], bufnr('')).stdout[0]
      else
        noautocmd let ref = fugitive#repo().git_chomp('describe', '--all', '--exact-match', commit)
        if ref =~# ':'
          let ref = ''
        endif
      endif
      if !empty(ref)
        let name = s:format_name(substitute(ref, '\v\C^%(heads/|remotes/|tags/)=','',''))."(".name.")"
      else
        let name = matchstr(commit, '.\{'.s:sha1size.'}')."(".name.")"
      endif
    endif
  catch
  endtry
  return name
endfunction

function! s:update_hg_branch()
  if airline#util#has_lawrencium()
    let cmd='LC_ALL=C hg qtop'
    let stl=lawrencium#statusline()
    let file=expand('%:p')
    if !empty(stl) && get(b:, 'airline_do_mq_check', 1)
      if g:airline#init#vim_async
        noa call airline#async#get_mq_async(cmd, file)
      elseif has("nvim")
        noa call airline#async#nvim_get_mq_async(cmd, file)
      else
        " remove \n at the end of the command
        let output=system(cmd)[0:-2]
        noa call airline#async#mq_output(output, file)
      endif
    endif
    " do not do mq check anymore
    let b:airline_do_mq_check = 0
    if exists("b:mq") && !empty(b:mq)
      if stl is# 'default'
        " Shorten default a bit
        let stl='def'
      endif
      let stl.=' ['.b:mq.']'
    endif
    let s:vcs_config['mercurial'].branch = stl
  else
    let s:vcs_config['mercurial'].branch = ''
  endif
endfunction

function! s:display_hg_branch()
  return b:buffer_vcs_config['mercurial'].branch
endfunction

function! s:update_branch()
  for vcs in keys(s:vcs_config)
    call {s:vcs_config[vcs].update_branch}()
    if b:buffer_vcs_config[vcs].branch != s:vcs_config[vcs].branch
      let b:buffer_vcs_config[vcs].branch = s:vcs_config[vcs].branch
      unlet! b:airline_head
    endif
  endfor
endfunction

function! airline#extensions#branch#update_untracked_config(file, vcs)
  if !has_key(s:vcs_config[a:vcs].untracked, a:file)
    return
  elseif s:vcs_config[a:vcs].untracked[a:file] != b:buffer_vcs_config[a:vcs].untracked
    let b:buffer_vcs_config[a:vcs].untracked = s:vcs_config[a:vcs].untracked[a:file]
    unlet! b:airline_head
  endif
endfunction

function! s:update_untracked()
  let file = expand("%:p")
  if empty(file) || isdirectory(file) || !empty(&buftype)
    return
  endif

  let needs_update = 1
  let vcs_checks   = get(g:, "airline#extensions#branch#vcs_checks", ["untracked", "dirty"])
  for vcs in keys(s:vcs_config)
    if file =~ s:vcs_config[vcs].exclude
      " Skip check for files that live in the exclude directory
      let needs_update = 0
    endif
    if has_key(s:vcs_config[vcs].untracked, file)
      let needs_update = 0
      call airline#extensions#branch#update_untracked_config(file, vcs)
    endif
  endfor

  if !needs_update
    return
  endif

  for vcs in keys(s:vcs_config)
    " only check, for git, if fugitive is installed
    " and for 'hg' if lawrencium is installed, else skip
    if vcs is# 'git' && (!airline#util#has_fugitive() && !airline#util#has_gina())
      continue
    elseif vcs is# 'mercurial' && !airline#util#has_lawrencium()
      continue
    endif
    let config = s:vcs_config[vcs]
    " Note that asynchronous update updates s:vcs_config only, and only
    " s:update_untracked updates b:buffer_vcs_config. If s:vcs_config is
    " invalidated again before s:update_untracked is called, then we lose the
    " result of the previous call, i.e. the head string is not updated. It
    " doesn't happen often in practice, so we let it be.
    if index(vcs_checks, 'untracked') > -1
      call airline#async#vcs_untracked(config, file, vcs)
    endif
    " Check clean state of repo
    if index(vcs_checks, 'dirty') > -1
      call airline#async#vcs_clean(config.dirty, file, vcs)
    endif
  endfor
endfunction

function! airline#extensions#branch#head()
  if !exists('b:buffer_vcs_config')
    call s:init_buffer()
  endif

  call s:update_branch()
  call s:update_untracked()

  if exists('b:airline_head') && !empty(b:airline_head)
    return b:airline_head
  endif

  let b:airline_head = ''
  let vcs_priority = get(g:, "airline#extensions#branch#vcs_priority", ["git", "mercurial"])

  let heads = []
  for vcs in vcs_priority
    if !empty(b:buffer_vcs_config[vcs].branch)
      let heads += [vcs]
    endif
  endfor

  for vcs in heads
    if !empty(b:airline_head)
      let b:airline_head .= ' | '
    endif
    if len(heads) > 1
      let b:airline_head .= s:vcs_config[vcs].exe .':'
    endif
    let b:airline_head .= s:format_name({s:vcs_config[vcs].display_branch}())
    let additional = b:buffer_vcs_config[vcs].untracked
    if empty(additional) &&
          \ has_key(b:buffer_vcs_config[vcs], 'dirty') &&
          \ b:buffer_vcs_config[vcs].dirty
      let additional = g:airline_symbols['dirty']
    endif
    let b:airline_head .= additional
  endfor

  if empty(heads)
    if airline#util#has_vcscommand()
      noa call VCSCommandEnableBufferSetup()
      if exists('b:VCSCommandBufferInfo')
        let b:airline_head = s:format_name(get(b:VCSCommandBufferInfo, 0, ''))
      endif
    endif
  endif

  if empty(heads)
    if airline#util#has_custom_scm()
      try
        let Fn = function(g:airline#extensions#branch#custom_head)
        let b:airline_head = Fn()
      endtry
    endif
  endif

  if exists("g:airline#extensions#branch#displayed_head_limit")
    let w:displayed_head_limit = g:airline#extensions#branch#displayed_head_limit
    if strwidth(b:airline_head) > w:displayed_head_limit - 1
      let b:airline_head =
            \ airline#util#strcharpart(b:airline_head, 0, w:displayed_head_limit - 1)
            \ . (&encoding ==? 'utf-8' ?  '…' : '.')
    endif
  endif

  return b:airline_head
endfunction

function! airline#extensions#branch#get_head()
  let head = airline#extensions#branch#head()
  let winwidth = get(airline#parts#get('branch'), 'minwidth', 120)
  let minwidth = empty(get(b:, 'airline_hunks', '')) ? 14 : 7
  let head = airline#util#shorten(head, winwidth, minwidth)
  let symbol = get(g:, 'airline#extensions#branch#symbol', g:airline_symbols.branch)
  return empty(head)
        \ ? get(g:, 'airline#extensions#branch#empty_message', '')
        \ : printf('%s%s', empty(symbol) ? '' : symbol.(g:airline_symbols.space), head)
endfunction

function! s:reset_untracked_cache(shellcmdpost)
  " shellcmdpost - whether function was called as a result of ShellCmdPost hook
  if !exists('#airline')
    " airline disabled
    return
  endif
  if !g:airline#init#vim_async && !has('nvim')
    if a:shellcmdpost
      " Clear cache only if there was no error or the script uses an
      " asynchronous interface. Otherwise, cache clearing would overwrite
      " v:shell_error with a system() call inside get_*_untracked.
      if v:shell_error
        return
      endif
    endif
  endif

  let file = expand("%:p")
  for vcs in keys(s:vcs_config)
    " Dump the value of the cache for the current file. Partially mitigates the
    " issue of cache invalidation happening before a call to
    " s:update_untracked()
    call airline#extensions#branch#update_untracked_config(file, vcs)
    let s:vcs_config[vcs].untracked = {}
  endfor
endfunction

function! s:sh_autocmd_handler()
  if exists('#airline')
    unlet! b:airline_head b:airline_do_mq_check
  endif
endfunction

function! airline#extensions#branch#init(ext)
  call airline#parts#define_function('branch', 'airline#extensions#branch#get_head')

  autocmd ShellCmdPost,CmdwinLeave * call s:sh_autocmd_handler()
  autocmd User AirlineBeforeRefresh call s:sh_autocmd_handler()
  autocmd BufWritePost * call s:reset_untracked_cache(0)
  autocmd ShellCmdPost * call s:reset_untracked_cache(1)
endfunction
./autoload/airline/extensions/bufferline.vim	[[[1
28
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/bling/vim-bufferline
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*bufferline#get_status_string')
  finish
endif

function! airline#extensions#bufferline#init(ext)
  if get(g:, 'airline#extensions#bufferline#overwrite_variables', 1)
    highlight bufferline_selected gui=bold cterm=bold term=bold
    highlight link bufferline_selected_inactive airline_c_inactive
    let g:bufferline_inactive_highlight = 'airline_c'
    let g:bufferline_active_highlight = 'bufferline_selected'
    let g:bufferline_active_buffer_left = ''
    let g:bufferline_active_buffer_right = ''
    let g:bufferline_separator = g:airline_symbols.space
  endif

  if exists("+autochdir") && &autochdir == 1
    " if 'acd' is set, vim-airline uses the path section, so we need to redefine this here as well
    call airline#parts#define_raw('path', '%{bufferline#refresh_status()}'.bufferline#get_status_string())
  else
    call airline#parts#define_raw('file', '%{bufferline#refresh_status()}'.bufferline#get_status_string())
  endif
endfunction
./autoload/airline/extensions/capslock.vim	[[[1
17
" MIT License. Copyright (c) 2014-2021 Mathias Andersson et al.
" Plugin: https://github.com/tpope/vim-capslock
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*CapsLockStatusline')
  finish
endif

function! airline#extensions#capslock#status()
  return tolower(CapsLockStatusline()) ==# '[caps]' ? get(g:, 'airline#extensions#capslock#symbol', 'CAPS') : ''
endfunction

function! airline#extensions#capslock#init(ext)
  call airline#parts#define_function('capslock', 'airline#extensions#capslock#status')
endfunction
./autoload/airline/extensions/coc.vim	[[[1
54
" MIT License. Copyright (c) 2019-2021 Peng Guanwen et al.
" vim: et ts=2 sts=2 sw=2
" Plugin: https://github.com/neoclide/coc

scriptencoding utf-8

let s:show_coc_status = get(g:, 'airline#extensions#coc#show_coc_status', 1)

function! airline#extensions#coc#get_warning() abort
  return airline#extensions#coc#get('warning')
endfunction

function! airline#extensions#coc#get_error() abort
  return airline#extensions#coc#get('error')
endfunction

function! airline#extensions#coc#get(type) abort
  if !exists(':CocCommand') | return '' | endif

  let is_err = (a:type  is# 'error')
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif

  let cnt = get(info, a:type, 0)
  if empty(cnt) | return '' | endif

  let error_symbol = get(g:, 'airline#extensions#coc#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#coc#warning_symbol', 'W:')
  let error_format = get(g:, 'airline#extensions#coc#stl_format_err', '%C(L%L)')
  let warning_format = get(g:, 'airline#extensions#coc#stl_format_warn', '%C(L%L)')

  " replace %C with error count and %L with line number
  return (is_err ? error_symbol : warning_symbol) .
    \ substitute(substitute(is_err ? error_format : warning_format,
      \ '%C', cnt, 'g'),
      \ '%L', (info.lnums)[is_err ? 0 : 1], 'g')
endfunction

function! airline#extensions#coc#get_status() abort
  " Shorten text for windows < 91 characters
  let status = airline#util#shorten(get(g:, 'coc_status', ''), 91, 9)
  return (s:show_coc_status ? status : '')
endfunction

function! airline#extensions#coc#get_current_function() abort
  return get(b:, 'coc_current_function', '')
endfunction

function! airline#extensions#coc#init(ext) abort
  call airline#parts#define_function('coc_error_count', 'airline#extensions#coc#get_error')
  call airline#parts#define_function('coc_warning_count', 'airline#extensions#coc#get_warning')
  call airline#parts#define_function('coc_status', 'airline#extensions#coc#get_status')
  call airline#parts#define_function('coc_current_function', 'airline#extensions#coc#get_current_function')
endfunction
./autoload/airline/extensions/commandt.vim	[[[1
19
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/wincent/command-t
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'command_t_loaded', 0)
  finish
endif

function! airline#extensions#commandt#apply(...)
  if bufname('%') ==# 'GoToFile'
    call airline#extensions#apply_left_override('CommandT', '')
  endif
endfunction

function! airline#extensions#commandt#init(ext)
  call a:ext.add_statusline_func('airline#extensions#commandt#apply')
endfunction
./autoload/airline/extensions/csv.vim	[[[1
33
" MIT License. Copyright (c) 2013-2021 Bailey Ling, Christian Brabandt et al.
" Plugin: https://github.com/chrisbra/csv.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_csv', 0) && !exists(':Table')
  finish
endif

let s:column_display = get(g:, 'airline#extensions#csv#column_display', 'Number')

function! airline#extensions#csv#get_column()
  if exists('*CSV_WCol')
    if s:column_display ==# 'Name'
      return '['.CSV_WCol('Name').CSV_WCol().']'
    else
      return '['.CSV_WCol().']'
    endif
  endif
  return ''
endfunction

function! airline#extensions#csv#apply(...)
  if &ft ==# "csv"
    call airline#extensions#prepend_to_section('gutter',
          \ g:airline_left_alt_sep.' %{airline#extensions#csv#get_column()}')
  endif
endfunction

function! airline#extensions#csv#init(ext)
  call a:ext.add_statusline_func('airline#extensions#csv#apply')
endfunction
./autoload/airline/extensions/ctrlp.vim	[[[1
82
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/ctrlpvim/ctrlp.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:color_template = get(g:, 'airline#extensions#ctrlp#color_template', 'insert')

function! airline#extensions#ctrlp#generate_color_map(dark, light, white)
  return {
        \ 'CtrlPdark'   : a:dark,
        \ 'CtrlPlight'  : a:light,
        \ 'CtrlPwhite'  : a:white,
        \ 'CtrlParrow1' : [ a:light[1] , a:white[1] , a:light[3] , a:white[3] , ''     ] ,
        \ 'CtrlParrow2' : [ a:white[1] , a:light[1] , a:white[3] , a:light[3] , ''     ] ,
        \ 'CtrlParrow3' : [ a:light[1] , a:dark[1]  , a:light[3] , a:dark[3]  , ''     ] ,
        \ }
endfunction

function! airline#extensions#ctrlp#load_theme(palette)
  if exists('a:palette.ctrlp')
    let theme = a:palette.ctrlp
  else
    let s:color_template = has_key(a:palette, s:color_template) ? s:color_template : 'insert'
    let theme = airline#extensions#ctrlp#generate_color_map(
          \ a:palette[s:color_template]['airline_c'],
          \ a:palette[s:color_template]['airline_b'],
          \ a:palette[s:color_template]['airline_a'])
  endif
  for key in keys(theme)
    call airline#highlighter#exec(key, theme[key])
  endfor
endfunction

" Arguments: focus, byfname, regexp, prv, item, nxt, marked
function! airline#extensions#ctrlp#ctrlp_airline(...)
  let b = airline#builder#new({'active': 1})
  if a:2 == 'file'
    call b.add_section_spaced('CtrlPlight', 'by fname')
  endif
  if a:3
    call b.add_section_spaced('CtrlPlight', 'regex')
  endif
  if get(g:, 'airline#extensions#ctrlp#show_adjacent_modes', 1)
    call b.add_section_spaced('CtrlPlight', a:4)
    call b.add_section_spaced('CtrlPwhite', a:5)
    call b.add_section_spaced('CtrlPlight', a:6)
  else
    call b.add_section_spaced('CtrlPwhite', a:5)
  endif
  call b.add_section_spaced('CtrlPdark', a:7)
  call b.split()
  call b.add_section_spaced('CtrlPdark', a:1)
  call b.add_section_spaced('CtrlPdark', a:2)
  call b.add_section_spaced('CtrlPlight', '%{getcwd()}')
  return b.build()
endfunction

" Argument: len
function! airline#extensions#ctrlp#ctrlp_airline_status(...)
  let len = '%#CtrlPdark# '.a:1
  let dir = '%=%<%#CtrlParrow3#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
  return len.dir
endfunction

function! airline#extensions#ctrlp#apply(...)
  " disable statusline overwrite if ctrlp already did it
  return match(&statusline, 'CtrlPwhite') >= 0 ? -1 : 0
endfunction

function! airline#extensions#ctrlp#init(ext)
  let g:ctrlp_status_func = {
        \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
        \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
        \ }
  call a:ext.add_statusline_func('airline#extensions#ctrlp#apply')
  call a:ext.add_theme_func('airline#extensions#ctrlp#load_theme')
endfunction
./autoload/airline/extensions/ctrlspace.vim	[[[1
21
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/szw/vim-ctrlspace
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#ctrlspace#statusline(...) abort
  let spc = g:airline_symbols.space
  let l:padding = spc . spc . spc
  let cs = ctrlspace#context#Configuration().Symbols.CS

  let b = airline#builder#new({ 'active': 1 })
  call b.add_section('airline_b', cs . l:padding . ctrlspace#api#StatuslineModeSegment(l:padding))
  call b.split()
  call b.add_section('airline_x', spc . ctrlspace#api#StatuslineTabSegment() . spc)
  return b.build()
endfunction

function! airline#extensions#ctrlspace#init(ext) abort
  let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"
endfunction
./autoload/airline/extensions/cursormode.vim	[[[1
126
" MIT Licsense.
" Plugin: https://github.com/vheon/vim-cursormode
" Copyright (C) 2014 Andrea Cedraro <a.cedraro@gmail.com>,
" Copyright (C) 2017 Eduardo Suarez-Santana <e.suarezsantana@gmail.com>

scriptencoding utf-8

if exists('g:loaded_cursormode')
  finish
endif

let g:loaded_cursormode = 1

let s:is_win = has('win32') || has('win64')
let s:is_iTerm = exists('$TERM_PROGRAM') && $TERM_PROGRAM =~# 'iTerm.app'
let s:is_AppleTerminal = exists('$TERM_PROGRAM') && $TERM_PROGRAM =~# 'Apple_Terminal'

let s:is_good = !has('gui_running') && !s:is_win && !s:is_AppleTerminal

let s:last_mode = ''

if !exists('g:cursormode_exit_mode')
  let g:cursormode_exit_mode='n'
endif

function! airline#extensions#cursormode#tmux_escape(escape)
  return '\033Ptmux;'.substitute(a:escape, '\\033', '\\033\\033', 'g').'\033\\'
endfunction

let s:iTerm_escape_template = '\033]Pl%s\033\\'
let s:xterm_escape_template = '\033]12;%s\007'

function! s:get_mode()
  return call(get(g:, 'cursormode_mode_func', 'mode'), [])
endfunction

function! airline#extensions#cursormode#set(...)
  let mode = s:get_mode()
  if mode !=# s:last_mode
    let s:last_mode = mode
  call s:set_cursor_color_for(mode)
  endif
  return ''
endfunction

function! s:set_cursor_color_for(mode)
  let mode = a:mode
  for mode in [a:mode, a:mode.&background]
    if has_key(s:color_map, mode)
      try
        let save_eventignore = &eventignore
        set eventignore=all
        let save_shelltemp = &shelltemp
        set noshelltemp

        silent call system(s:build_command(s:color_map[mode]))
        return
      finally
        let &shelltemp = save_shelltemp
        let &eventignore = save_eventignore
      endtry
    endif
  endfor
endfunction

function! s:build_command(color)
  if s:is_iTerm
    let color = substitute(a:color, '^#', '', '')
    let escape_template = s:iTerm_escape_template
  else
    let color = a:color
    let escape_template = s:xterm_escape_template
  endif

  let escape = printf(escape_template, color)
  if exists('$TMUX')
    let escape = airline#extensions#cursormode#tmux_escape(escape)
  endif
  return "printf '".escape."' > /dev/tty"
endfunction

function! s:get_color_map()
  if exists('g:cursormode_color_map')
    return g:cursormode_color_map
  endif

  try
    let map = g:cursormode#{g:colors_name}#color_map
    return map
  catch
    return {
          \   "nlight": "#000000",
          \   "ndark":  "#BBBBBB",
          \   "i":      "#0000BB",
          \   "v":      "#FF5555",
          \   "V":      "#BBBB00",
          \   "\<C-V>": "#BB00BB",
          \ }
  endtry
endfunction

augroup airline#extensions#cursormode
  autocmd!
  autocmd VimLeave * nested call s:set_cursor_color_for(g:cursormode_exit_mode)
  " autocmd VimEnter * call airline#extensions#cursormode#activate()
  autocmd Colorscheme * call airline#extensions#cursormode#activate()
augroup END

function! airline#extensions#cursormode#activate()
  if !exists('#airline')
    " airline disabled
    return
  endif
  let s:color_map = s:get_color_map()
  call airline#extensions#cursormode#set()
endfunction

function! airline#extensions#cursormode#apply(...)
  let w:airline_section_a = get(w:, 'airline_section_a', g:airline_section_a)
  let w:airline_section_a .= '%{airline#extensions#cursormode#set()}'
endfunction

function! airline#extensions#cursormode#init(ext)
  let s:color_map = s:get_color_map()
  call a:ext.add_statusline_func('airline#extensions#cursormode#apply')
endfunction
./autoload/airline/extensions/default.vim	[[[1
97
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:section_use_groups     = get(g:, 'airline#extensions#default#section_use_groupitems', 1)
let s:section_truncate_width = get(g:, 'airline#extensions#default#section_truncate_width', {
      \ 'b': 79,
      \ 'x': 60,
      \ 'y': 80,
      \ 'z': 45,
      \ 'warning': 80,
      \ 'error': 80,
      \ })
let s:layout = get(g:, 'airline#extensions#default#layout', [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z', 'warning', 'error' ]
      \ ])

function! s:get_section(winnr, key, ...)
  if has_key(s:section_truncate_width, a:key)
    if airline#util#winwidth(a:winnr) < s:section_truncate_width[a:key]
      return ''
    endif
  endif
  let spc = g:airline_symbols.space
  if !exists('g:airline_section_{a:key}')
    return ''
  endif
  let text = airline#util#getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
  let [prefix, suffix] = [get(a:000, 0, '%('.spc), get(a:000, 1, spc.'%)')]
  return empty(text) ? '' : prefix.text.suffix
endfunction

function! s:build_sections(builder, context, keys)
  for key in a:keys
    if (key == 'warning' || key == 'error') && !a:context.active
      continue
    endif
    call s:add_section(a:builder, a:context, key)
  endfor
endfunction

" There still is a highlighting bug when using groups %(%) in the statusline,
" deactivate it, unless it is fixed (7.4.1511)
if s:section_use_groups && (v:version >= 704 || (v:version >= 703 && has('patch81')))
  function! s:add_section(builder, context, key)
    let condition = (a:key is# "warning" || a:key is# "error") &&
          \ (v:version == 704 && !has("patch1511"))
    " i have no idea why the warning section needs special treatment, but it's
    " needed to prevent separators from showing up
    if ((a:key == 'error' || a:key == 'warning') && empty(s:get_section(a:context.winnr, a:key)))
      return
    endif
    if condition
      call a:builder.add_raw('%(')
    endif
    call a:builder.add_section('airline_'.a:key, s:get_section(a:context.winnr, a:key))
    if condition
      call a:builder.add_raw('%)')
    endif
  endfunction
else
  " older version don't like the use of %(%)
  function! s:add_section(builder, context, key)
    if ((a:key == 'error' || a:key == 'warning') && empty(s:get_section(a:context.winnr, a:key)))
      return
    endif
    if a:key == 'warning'
      call a:builder.add_raw('%#airline_warning#'.s:get_section(a:context.winnr, a:key))
    elseif a:key == 'error'
      call a:builder.add_raw('%#airline_error#'.s:get_section(a:context.winnr, a:key))
    else
      call a:builder.add_section('airline_'.a:key, s:get_section(a:context.winnr, a:key))
    endif
  endfunction
endif

function! airline#extensions#default#apply(builder, context) abort
  let winnr = a:context.winnr
  let active = a:context.active

  if airline#util#getwinvar(winnr, 'airline_render_left', active || (!active && !g:airline_inactive_collapse))
    call s:build_sections(a:builder, a:context, s:layout[0])
  else
    let text = !empty(s:get_section(winnr, 'c')) ? s:get_section(winnr, 'c') : ' %f%m '
    call a:builder.add_section('airline_c'.(a:context.bufnr), text)
  endif

  call a:builder.split(s:get_section(winnr, 'gutter', '', ''))

  if airline#util#getwinvar(winnr, 'airline_render_right', 1)
    call s:build_sections(a:builder, a:context, s:layout[1])
  endif

  return 1
endfunction
./autoload/airline/extensions/denite.vim	[[[1
55
" MIT License. Copyright (c) 2017-2021 Thomas Dy et al.
" Plugin: https://github.com/Shougo/denite.nvim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_denite', 0)
  finish
endif

let s:denite_ver = (exists('*denite#get_status_mode') ? 2 : 3)
" Denite does not use vim's built-in modal editing but has a custom prompt
" that implements its own insert/normal mode so we have to handle changing the
" highlight
function! airline#extensions#denite#check_denite_mode(bufnr) abort
  if &filetype !=# 'denite' && &filetype !=# 'denite-filter'
    return ''
  endif

  if s:denite_ver == 3
    let mode = split(denite#get_status("mode"), ' ')
  else
    let mode = split(denite#get_status_mode(), ' ')
  endif
  let mode = tolower(get(mode, 1, ''))
  if !exists('b:denite_mode_cache') || mode != b:denite_mode_cache
    call airline#highlighter#highlight([mode], a:bufnr)
    let b:denite_mode_cache = mode
  endif
  return ''
endfunction

function! airline#extensions#denite#apply(...) abort
  if &filetype ==# 'denite' || &filetype ==# 'denite-filter'
    let w:airline_skip_empty_sections = 0
    call a:1.add_section('airline_a', ' Denite %{airline#extensions#denite#check_denite_mode('.a:2['bufnr'].')}')
    if s:denite_ver == 3
      call a:1.add_section('airline_c', ' %{denite#get_status("sources")}')
      call a:1.split()
      call a:1.add_section('airline_y', ' %{denite#get_status("path")} ')
      call a:1.add_section('airline_z', ' %{denite#get_status("linenr")} ')
    else
      call a:1.add_section('airline_c', ' %{denite#get_status_sources()}')
      call a:1.split()
      call a:1.add_section('airline_y', ' %{denite#get_status_path()} ')
      call a:1.add_section('airline_z', ' %{denite#get_status_linenr()} ')
    endif
    return 1
  endif
endfunction

function! airline#extensions#denite#init(ext) abort
  call denite#custom#option('_', 'statusline', 0)
  call a:ext.add_statusline_func('airline#extensions#denite#apply')
endfunction
./autoload/airline/extensions/dirvish.vim	[[[1
36
" MIT Licsense
" Plugin: https://github.com/justinmk/vim-dirvish
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_dirvish', 0)
  finish
endif

let s:spc = g:airline_symbols.space

function! airline#extensions#dirvish#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#dirvish#apply')
endfunction

function! airline#extensions#dirvish#apply(...) abort
  if &filetype ==# 'dirvish' && exists('b:dirvish')
    let w:airline_section_a = 'Dirvish'

    let w:airline_section_b = exists('*airline#extensions#branch#get_head')
      \ ? '%{airline#extensions#branch#get_head()}'
      \ : ''

    let w:airline_section_c = '%{b:dirvish._dir}'

    let w:airline_section_x = ''
    let w:airline_section_y = ''

    let current_column_regex = ':%\dv'
    let w:airline_section_z = join(filter(
      \   split(get(w:, 'airline_section_z', g:airline_section_z)),
      \   'v:val !~ current_column_regex'
      \ ))
  endif
endfunction
./autoload/airline/extensions/eclim.vim	[[[1
62
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" PLugin: https://eclim.org
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':ProjectCreate')
  finish
endif

function! airline#extensions#eclim#creat_line(...)
  if &filetype == "tree"
    let builder = a:1
    call builder.add_section('airline_a', ' Project ')
    call builder.add_section('airline_b', ' %f ')
    call builder.add_section('airline_c', '')
  return 1
  endif
endfunction

function! airline#extensions#eclim#get_warnings()
  " Cache vavlues, so that it isn't called too often
  if exists("s:eclim_errors") &&
    \  get(b:,  'airline_changenr', 0) == changenr()
    return s:eclim_errors
  endif
  let eclimList = eclim#display#signs#GetExisting()
  let s:eclim_errors = ''

  if !empty(eclimList)
    " Remove any non-eclim signs (see eclim#display#signs#Update)
    " First check for just errors since they are more important.
    " If there are no errors, then check for warnings.
    let errorList = filter(copy(eclimList), 'v:val.name =~ "^\\(qf_\\)\\?\\(error\\)$"')

    if (empty(errorList))
      " use the warnings
      call filter(eclimList, 'v:val.name =~ "^\\(qf_\\)\\?\\(warning\\)$"')
      let type = 'W'
    else
      " Use the errors
      let eclimList = errorList
      let type = 'E'
    endif

    if !empty(eclimList)
      let errorsLine = eclimList[0]['line']
      let errorsNumber = len(eclimList)
      let errors = "[Eclim:" . type . " line:".string(errorsLine)." (".string(errorsNumber).")]"
      if !exists(':SyntasticCheck') || SyntasticStatuslineFlag() == ''
        let s:eclim_errors = errors.(g:airline_symbols.space)
      endif
    endif
  endif
  let b:airline_changenr = changenr()
  return s:eclim_errors
endfunction

function! airline#extensions#eclim#init(ext)
  call airline#parts#define_function('eclim', 'airline#extensions#eclim#get_warnings')
  call a:ext.add_statusline_func('airline#extensions#eclim#creat_line')
endfunction
./autoload/airline/extensions/example.vim	[[[1
55
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

" we don't actually want this loaded :P
finish

" Due to some potential rendering issues, the use of the `space` variable is
" recommended.
let s:spc = g:airline_symbols.space

" Extension specific variables can be defined the usual fashion.
if !exists('g:airline#extensions#example#number_of_cats')
  let g:airline#extensions#example#number_of_cats = 42
endif

" First we define an init function that will be invoked from extensions.vim
function! airline#extensions#example#init(ext)

  " Here we define a new part for the plugin.  This allows users to place this
  " extension in arbitrary locations.
  call airline#parts#define_raw('cats', '%{airline#extensions#example#get_cats()}')

  " Next up we add a funcref so that we can run some code prior to the
  " statusline getting modified.
  call a:ext.add_statusline_func('airline#extensions#example#apply')

  " You can also add a funcref for inactive statuslines.
  " call a:ext.add_inactive_statusline_func('airline#extensions#example#unapply')
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#example#apply(...)
  " First we check for the filetype.
  if &filetype == "nyancat"

    " Let's say we want to append to section_c, first we check if there's
    " already a window-local override, and if not, create it off of the global
    " section_c.
    let w:airline_section_c = get(w:, 'airline_section_c', g:airline_section_c)

    " Then we just append this extension to it, optionally using separators.
    let w:airline_section_c .= s:spc.g:airline_left_alt_sep.s:spc.'%{airline#extensions#example#get_cats()}'
  endif
endfunction

" Finally, this function will be invoked from the statusline.
function! airline#extensions#example#get_cats()
  let cats = ''
  for i in range(1, g:airline#extensions#example#number_of_cats)
    let cats .= ' (,,,)=(^.^)=(,,,) '
  endfor
  return cats
endfunction
./autoload/airline/extensions/fern.vim	[[[1
36
" MIT License. Copyright (c) 2013-2021
" Plugin: https://github.com/lambdalisue/fern.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'loaded_fern', 0)
  finish
endif

function! airline#extensions#fern#apply(...) abort
  if (&ft =~# 'fern')
    let spc = g:airline_symbols.space
    let fri = fern#fri#parse(expand('%f'))

    call a:1.add_section('airline_a', spc.'fern'.spc)
    if exists('*airline#extensions#branch#get_head')
      call a:1.add_section('airline_b', spc.'%{airline#extensions#branch#get_head()}'.spc)
    else
      call a:1.add_section('airline_b', '')
    endif
    if !(fri.authority =~# '^drawer')
      let abspath = substitute(fri.path, 'file://', '', '')
      call a:1.add_section('airline_c', spc.fnamemodify(abspath, ':~'))
      call a:1.split()
      if len(get(g:, 'fern#comparators', {}))
        call a:1.add_section('airline_y', spc.'%{fern#comparator}'.spc)
      endif
    endif
    return 1
  endif
endfunction

function! airline#extensions#fern#init(ext) abort
  let g:fern_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#fern#apply')
endfunction
./autoload/airline/extensions/fugitiveline.vim	[[[1
61
" MIT License. Copyright (c) 2017-2021 Cimbali et al
" Plugin: https://github.com/tpope/vim-fugitive
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !airline#util#has_fugitive()
  finish
endif

let s:has_percent_eval = v:version > 802 || (v:version == 802 && has("patch2854"))

function! airline#extensions#fugitiveline#bufname() abort
  if !exists('b:fugitive_name')
    let b:fugitive_name = ''
    try
      if bufname('%') =~? '^fugitive:' && exists('*FugitiveReal')
        let b:fugitive_name = FugitiveReal(bufname('%'))
      endif
    catch
    endtry
  endif

  let fmod = (exists("+autochdir") && &autochdir) ? ':p' : ':.'
  let result=''
  if empty(b:fugitive_name)
    if empty(bufname('%'))
      return &buftype ==# 'nofile' ? '[Scratch]' : '[No Name]'
    endif
    return s:has_percent_eval ? '%f' : fnamemodify(bufname('%'), fmod)
  else
    return s:has_percent_eval ? '%f [git]' : (fnamemodify(b:fugitive_name, fmod). " [git]")
  endif
endfunction

function! s:sh_autocmd_handler()
  if exists('#airline')
    unlet! b:fugitive_name
  endif
endfunction

function! airline#extensions#fugitiveline#init(ext) abort
  let prct = s:has_percent_eval ? '%' : ''

  if exists("+autochdir") && &autochdir
    " if 'acd' is set, vim-airline uses the path section, so we need to redefine this here as well
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('path', '%<%{'. prct. 'pathshorten(airline#extensions#fugitiveline#bufname())' . prct . '}%m')
    else
      call airline#parts#define_raw('path', '%<%{' . prct . 'airline#extensions#fugitiveline#bufname()' . prct . '}%m')
    endif
  else
    if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
      call airline#parts#define_raw('file', '%<%{' . prct . 'pathshorten(airline#extensions#fugitiveline#bufname())' . prct . '}%m')
    else
      call airline#parts#define_raw('file', '%<%{' . prct . 'airline#extensions#fugitiveline#bufname()' . prct . '}%m')
    endif
  endif
  autocmd ShellCmdPost,CmdwinLeave * call s:sh_autocmd_handler()
  autocmd User AirlineBeforeRefresh call s:sh_autocmd_handler()
endfunction
./autoload/airline/extensions/fzf.vim	[[[1
44
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/junegunn/fzf, https://github.com/junegunn/fzf.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#fzf#init(ext) abort
  " Remove the custom statusline that fzf.vim sets by removing its `FileType
  " fzf` autocmd. Ideally we'd use `let g:fzf_statusline = 0`, but this
  " variable is checked *before* airline#extensions#init() is called.
  augroup _fzf_statusline
    autocmd!
  augroup END

  call a:ext.add_statusline_func('airline#extensions#fzf#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#fzf#inactive_apply')
endfunction

function! airline#extensions#fzf#statusline(...) abort
  let spc = g:airline_symbols.space

  let builder = airline#builder#new({ 'active': 1 })
  call builder.add_section('airline_a', spc.'FZF'.spc)
  call builder.add_section('airline_c', '')
  return builder.build()
endfunction

function! airline#extensions#fzf#apply(...) abort
  if &filetype ==# 'fzf'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'FZF'.spc)
    call a:1.add_section('airline_c', '')
    return 1
  endif
endfunction

function! airline#extensions#fzf#inactive_apply(...) abort
  if getbufvar(a:2.bufnr, '&filetype') ==# 'fzf'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'FZF'.spc)
    call a:1.add_section('airline_c', '')
    return 1
  endif
endfunction
./autoload/airline/extensions/gen_tags.vim	[[[1
19
" MIT License. Copyright (c) 2014-2021 Mathias Andersson et al.
" Written by Kamil Cukrowski 2020
" Plugin: https://github.com/jsfaint/gen_tags.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !(get(g:, 'loaded_gentags#gtags', 0) || get(g:, 'loaded_gentags#ctags', 0))
  finish
endif

function! airline#extensions#gen_tags#status(...) abort
  return gen_tags#job#is_running() != 0 ? 'Gen. gen_tags' : ''
endfunction

function! airline#extensions#gen_tags#init(ext) abort
  call airline#parts#define_function('gen_tags', 'airline#extensions#gen_tags#status')
endfunction

./autoload/airline/extensions/gina.vim	[[[1
28
" MIT License. Copyright (c) 2013-2021
" Plugin: https://github.com/lambdalisue/gina.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'loaded_gina', 0)
  finish
endif

function! airline#extensions#gina#apply(...) abort
  " gina.vim seems to set b:gina_initialized = 1 in diff buffers it open,
  " where get(b:, 'gina_initialized', 0) returns 1.
  " In diff buffers not opened by gina.vim b:gina_initialized is not set,
  " so get(b:, 'gina_initialized', 0) returns 0.
  if (&ft =~# 'gina' && &ft !~# 'blame') || (&ft ==# 'diff' && get(b:, 'gina_initialized', 0))
    call a:1.add_section('airline_a', ' gina ')
    call a:1.add_section('airline_b', ' %{gina#component#repo#branch()} ')
    call a:1.split()
    call a:1.add_section('airline_y', ' staged %{gina#component#status#staged()} ')
    call a:1.add_section('airline_z', ' unstaged %{gina#component#status#unstaged()} ')
    return 1
  endif
endfunction

function! airline#extensions#gina#init(ext) abort
  let g:gina_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#gina#apply')
endfunction
./autoload/airline/extensions/grepper.vim	[[[1
18
" MIT License. Copyright (c) 2014-2021 Mathias Andersson et al.
" Plugin: https://github.com/mhinz/vim-grepper
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_grepper', 0)
  finish
endif

function! airline#extensions#grepper#status()
  let msg = grepper#statusline()
  return empty(msg) ? '' : 'grepper'
endfunction

function! airline#extensions#grepper#init(ext)
  call airline#parts#define_function('grepper', 'airline#extensions#grepper#status')
endfunction
./autoload/airline/extensions/gutentags.vim	[[[1
18
" MIT License. Copyright (c) 2014-2021 Mathias Andersson et al.
" Plugin: https://github.com/ludovicchabant/vim-gutentags
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_gutentags', 0)
  finish
endif

function! airline#extensions#gutentags#status()
  let msg = gutentags#statusline()
  return empty(msg) ? '' :  'Gen. ' . msg
endfunction

function! airline#extensions#gutentags#init(ext)
  call airline#parts#define_function('gutentags', 'airline#extensions#gutentags#status')
endfunction
./autoload/airline/extensions/hunks.vim	[[[1
149
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: vim-gitgutter, vim-signify, changesPlugin, quickfixsigns, coc-git,
"         gitsigns.nvim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_signify', 0)
  \ && !get(g:, 'loaded_gitgutter', 0)
  \ && !get(g:, 'loaded_changes', 0)
  \ && !get(g:, 'loaded_quickfixsigns', 0)
  \ && !exists(':Gitsigns')
  \ && !exists("*CocAction")
  finish
endif

let s:non_zero_only = get(g:, 'airline#extensions#hunks#non_zero_only', 0)
let s:hunk_symbols = get(g:, 'airline#extensions#hunks#hunk_symbols', ['+', '~', '-'])

function! s:coc_git_enabled() abort
  if !exists("*CocAction") ||
   \ !get(g:, 'airline#extensions#hunks#coc_git', 0)
     " coc-git extension is disabled by default
     " unless specifically being enabled by the user
     " (as requested from coc maintainer)
    return 0
  endif
  return 1
endfunction

function! s:parse_hunk_status_dict(hunks) abort
  let result = [0, 0, 0]
  let result[0] = get(a:hunks, 'added', 0)
  let result[1] = get(a:hunks, 'changed', 0)
  let result[2] = get(a:hunks, 'removed', 0)
  return result
endfunction

function! s:parse_hunk_status_decorated(hunks) abort
  if empty(a:hunks)
    return []
  endif
  let result = [0, 0, 0]
  for val in split(a:hunks)
    if val[0] is# '+'
      let result[0] = val[1:] + 0
    elseif val[0] is# '~'
      let result[1] = val[1:] + 0
    elseif val[0] is# '-'
      let result[2] = val[1:] + 0
    endif
  endfor
  return result
endfunction

function! s:get_hunks_signify() abort
  let hunks = sy#repo#get_stats()
  if hunks[0] >= 0
    return hunks
  endif
  return []
endfunction

function! s:get_hunks_gitgutter() abort
  let hunks = GitGutterGetHunkSummary()
  return hunks == [0, 0, 0] ? [] : hunks
endfunction

function! s:get_hunks_changes() abort
  let hunks = changes#GetStats()
  return hunks == [0, 0, 0] ? [] : hunks
endfunction

function! s:get_hunks_gitsigns() abort
  let hunks = get(b:, 'gitsigns_status_dict', {})
  return s:parse_hunk_status_dict(hunks)
endfunction

function! s:get_hunks_coc() abort
  let hunks = get(b:, 'coc_git_status', '')
  return s:parse_hunk_status_decorated(hunks)
endfunction

function! s:get_hunks_empty() abort
  return ''
endfunction

function! airline#extensions#hunks#get_raw_hunks() abort
  if !exists('b:source_func') || get(b:, 'source_func', '') is# 's:get_hunks_empty'
    if get(g:, 'loaded_signify') && sy#buffer_is_active()
      let b:source_func = 's:get_hunks_signify'
    elseif exists('*GitGutterGetHunkSummary') && get(g:, 'gitgutter_enabled')
      let b:source_func = 's:get_hunks_gitgutter'
    elseif exists('*changes#GetStats')
      let b:source_func = 's:get_hunks_changes'
    elseif exists('*quickfixsigns#vcsdiff#GetHunkSummary')
      let b:source_func = 'quickfixsigns#vcsdiff#GetHunkSummary'
    elseif exists(':Gitsigns')
      let b:source_func = 's:get_hunks_gitsigns'
    elseif s:coc_git_enabled()
      let b:source_func = 's:get_hunks_coc'
    else
      let b:source_func = 's:get_hunks_empty'
    endif
  endif
  return {b:source_func}()
endfunction

function! airline#extensions#hunks#get_hunks() abort
  if !get(w:, 'airline_active', 0)
    return ''
  endif
  " Cache values, so that it isn't called too often
  if exists("b:airline_hunks") &&
    \ get(b:,  'airline_changenr', 0) == b:changedtick &&
    \ airline#util#winwidth() == get(s:, 'airline_winwidth', 0) &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_signify' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_gitgutter' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_empty' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_changes' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_gitsigns' &&
    \ get(b:, 'source_func', '') isnot# 's:get_hunks_coc'
    return b:airline_hunks
  endif
  let hunks = airline#extensions#hunks#get_raw_hunks()
  let string = ''
  let winwidth = get(airline#parts#get('hunks'), 'minwidth', 100)
  if !empty(hunks)
    " hunks should contain [added, changed, deleted]
    for i in [0, 1, 2]
      if (s:non_zero_only == 0 && airline#util#winwidth() > winwidth) || hunks[i] > 0
        let string .= printf('%s%s ', s:hunk_symbols[i], hunks[i])
      endif
    endfor
  endif
  if index(airline#extensions#get_loaded_extensions(), 'branch') == -1 && string[-1:] == ' '
    " branch extension not loaded, skip trailing whitespace
    let string = string[0:-2]
  endif

  let b:airline_hunks = string
  let b:airline_changenr = b:changedtick
  let s:airline_winwidth = airline#util#winwidth()
  return string
endfunction

function! airline#extensions#hunks#init(ext) abort
  call airline#parts#define_function('hunks', 'airline#extensions#hunks#get_hunks')
endfunction
./autoload/airline/extensions/keymap.vim	[[[1
31
" MIT License. Copyright (c) 2013-2021 Doron Behar, C.Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !has('keymap')
  finish
endif

function! airline#extensions#keymap#status()
  if (get(g:, 'airline#extensions#keymap#enabled', 1) && has('keymap'))
    let short_codes = get(g:, 'airline#extensions#keymap#short_codes', {})
    let label = get(g:, 'airline#extensions#keymap#label', g:airline_symbols.keymap)
    let default = get(g:, 'airline#extensions#keymap#default', '')
    if (label !=# '')
      let label .= ' '
    endif
    let keymap = &keymap
    if has_key(short_codes, keymap)
      let keymap = short_codes[keymap]
    endif
    return printf('%s', (!empty(keymap) && &iminsert ? (label . keymap) :
          \ (!empty(default) ? label . default : default)))
  else
    return ''
  endif
endfunction

function! airline#extensions#keymap#init(ext)
  call airline#parts#define_function('keymap', 'airline#extensions#keymap#status')
endfunction
./autoload/airline/extensions/languageclient.vim	[[[1
113
" MIT License. Copyright (c) 2013-2021 Bjorn Neergaard, hallettj et al.
" Plugin: https://github.com/autozimu/LanguageClient-neovim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:error_symbol = get(g:, 'airline#extensions#languageclient#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#languageclient#warning_symbol', 'W:')
let s:show_line_numbers = get(g:, 'airline#extensions#languageclient#show_line_numbers', 1)

" Severity codes from the LSP spec
let s:severity_error = 1
let s:severity_warning = 2
let s:severity_info = 3
let s:severity_hint = 4

" After each LanguageClient state change `s:diagnostics` will be populated with
" a map from file names to lists of errors, warnings, informational messages,
" and hints.
let s:diagnostics = {}

function! s:languageclient_refresh()
  if get(g:, 'airline_skip_empty_sections', 0)
    exe ':AirlineRefresh!'
  endif
endfunction

function! s:record_diagnostics(state)
  " The returned message might not have the 'result' key
  if has_key(a:state, 'result')
    let result = json_decode(a:state.result)
    let s:diagnostics = result.diagnostics
  endif
  call s:languageclient_refresh()
endfunction

function! s:get_diagnostics()
  if !exists('#airline')
    " airline disabled
    return
  endif
  call LanguageClient#getState(function("s:record_diagnostics"))
endfunction

function! s:diagnostics_for_buffer()
  return get(s:diagnostics, expand('%:p'), [])
endfunction

function! s:airline_languageclient_count(cnt, symbol)
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! s:airline_languageclient_get_line_number(type) abort
  let linenumber_of_first_problem = 0
  for d in s:diagnostics_for_buffer()
    if has_key(d, 'severity') && d.severity == a:type
      let linenumber_of_first_problem = d.range.start.line
      break
    endif
  endfor

  if linenumber_of_first_problem == 0
    return ''
  endif

  let open_lnum_symbol  = get(g:, 'airline#extensions#languageclient#open_lnum_symbol', '(L')
  let close_lnum_symbol = get(g:, 'airline#extensions#languageclient#close_lnum_symbol', ')')

  return open_lnum_symbol . linenumber_of_first_problem . close_lnum_symbol
endfunction

function! airline#extensions#languageclient#get(type)
  if get(b:, 'LanguageClient_isServerRunning', 0) ==# 0
    return ''
  endif

  let is_err = a:type == s:severity_error
  let symbol = is_err ? s:error_symbol : s:warning_symbol

  let cnt = 0
  for d in s:diagnostics_for_buffer()
    if has_key(d, 'severity') && d.severity == a:type
      let cnt += 1
    endif
  endfor

  if cnt == 0
    return ''
  endif

  if s:show_line_numbers == 1
    return s:airline_languageclient_count(cnt, symbol) . <sid>airline_languageclient_get_line_number(a:type)
  else
    return s:airline_languageclient_count(cnt, symbol)
  endif
endfunction

function! airline#extensions#languageclient#get_warning()
  return airline#extensions#languageclient#get(s:severity_warning)
endfunction

function! airline#extensions#languageclient#get_error()
  return airline#extensions#languageclient#get(s:severity_error)
endfunction

function! airline#extensions#languageclient#init(ext)
  call airline#parts#define_function('languageclient_error_count', 'airline#extensions#languageclient#get_error')
  call airline#parts#define_function('languageclient_warning_count', 'airline#extensions#languageclient#get_warning')
  augroup airline_languageclient
    autocmd!
    autocmd User LanguageClientDiagnosticsChanged call <sid>get_diagnostics()
  augroup END
endfunction
./autoload/airline/extensions/localsearch.vim	[[[1
41
" MIT License. Copyright (c) 2018-2021 mox et al.
" Plugin: https://github.com/mox-mox/vim-localsearch
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:enabled = get(g:, 'airline#extensions#localsearch#enabled', 1)
if !get(g:, 'loaded_localsearch', 0) || !s:enabled || get(g:, 'airline#extensions#localsearch#loaded', 0)
  finish
endif
let g:airline#extensions#localsearch#loaded = 001

let s:spc = g:airline_symbols.space

let g:airline#extensions#localsearch#inverted = get(g:, 'airline#extensions#localsearch#inverted', 0)

function! airline#extensions#localsearch#load_theme(palette) abort
  call airline#highlighter#exec('localsearch_dark', [ '#ffffff' , '#000000' , 15  , 1 , ''])
endfunction


function! airline#extensions#localsearch#init(ext) abort
  call a:ext.add_theme_func('airline#extensions#localsearch#load_theme')
  call a:ext.add_statusline_func('airline#extensions#localsearch#apply')
endfunction


function! airline#extensions#localsearch#apply(...) abort
  " first variable is the statusline builder
  let builder = a:1

  """"" WARNING: the API for the builder is not finalized and may change
  if exists('#localsearch#WinEnter') && !g:airline#extensions#localsearch#inverted " If localsearch mode is enabled and 'invert' option is false
    call builder.add_section('localsearch_dark', s:spc.airline#section#create('LS').s:spc)
  endif
  if !exists('#localsearch#WinEnter') && g:airline#extensions#localsearch#inverted " If localsearch mode is disabled and 'invert' option is true
    call builder.add_section('localsearch_dark', s:spc.airline#section#create('GS').s:spc)
  endif
  return 0
endfunction

./autoload/airline/extensions/lsp.vim	[[[1
111
" MIT License. Copyright (c) 2013-2021 François-Xavier Carton et al.
" Plugin: https://github.com/prabirshrestha/vim-lsp
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'lsp_loaded', 0)
  finish
endif

function! s:airline_lsp_count(cnt, symbol) abort
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! s:airline_lsp_get_line_number(cnt, type) abort
  let result = ''

  if a:type ==# 'error'
    let result = lsp#get_buffer_first_error_line()
  endif

  if empty(result)
      return ''
  endif

  let open_lnum_symbol  =
    \ get(g:, 'airline#extensions#lsp#open_lnum_symbol', '(L')
  let close_lnum_symbol =
    \ get(g:, 'airline#extensions#lsp#close_lnum_symbol', ')')

  return open_lnum_symbol . result . close_lnum_symbol
endfunction

function! airline#extensions#lsp#get(type) abort
  if !exists(':LspDeclaration')
    return ''
  endif

  let error_symbol = get(g:, 'airline#extensions#lsp#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#lsp#warning_symbol', 'W:')
  let show_line_numbers = get(g:, 'airline#extensions#lsp#show_line_numbers', 1)

  let is_err = a:type ==# 'error'

  let symbol = is_err ? error_symbol : warning_symbol

  let num = lsp#get_buffer_diagnostics_counts()[a:type]

  if show_line_numbers == 1
    return s:airline_lsp_count(num, symbol) . <sid>airline_lsp_get_line_number(num, a:type)
  else
    return s:airline_lsp_count(num, symbol)
  endif
endfunction

function! airline#extensions#lsp#get_warning() abort
  return airline#extensions#lsp#get('warning')
endfunction

function! airline#extensions#lsp#get_error() abort
  return airline#extensions#lsp#get('error')
endfunction

let s:lsp_progress = []
function! airline#extensions#lsp#progress() abort
  if get(w:, 'airline_active', 0)
    if exists('*lsp#get_progress')
      let s:lsp_progress = lsp#get_progress()

      if len(s:lsp_progress) == 0 | return '' | endif

      " show only most new progress
      let s:lsp_progress = s:lsp_progress[0]
      if s:lsp_progress['message'] !=# ''
        let percent = ''
        if has_key(s:lsp_progress, 'percentage') && s:lsp_progress['percentage'] >= 0
          let percent = ' ' . string(s:lsp_progress['percentage']) . '%'
        endif
        let s:title = s:lsp_progress['title']
        let message = airline#util#shorten(s:lsp_progress['message'] . percent, 91, 9)
        return s:lsp_progress['server'] . ': ' . s:title . ' ' . message
      endif
    endif
  endif
  return ''
endfunction

let s:timer = 0
let s:ignore_time = 0
function! airline#extensions#lsp#update() abort
  if !exists('#airline')
    " airline disabled
    return
  endif
  if reltimefloat(reltime()) - s:ignore_time >=
        \ get(g:, 'airline#extensions#lsp#progress_skip_time', 0.3)
        \ || len(s:lsp_progress) == 0
    call airline#update_statusline()
    let s:ignore_time = reltimefloat(reltime())
  endif
endfunction

function! airline#extensions#lsp#init(ext) abort
  call airline#parts#define_function('lsp_error_count', 'airline#extensions#lsp#get_error')
  call airline#parts#define_function('lsp_warning_count', 'airline#extensions#lsp#get_warning')
  call airline#parts#define_function('lsp_progress', 'airline#extensions#lsp#progress')
  augroup airline_lsp_progress
    autocmd!
    autocmd User lsp_progress_updated call airline#extensions#lsp#update()
  augroup END
endfunction
./autoload/airline/extensions/neomake.vim	[[[1
37
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/neomake/neomake
" vim: et ts=2 sts=2 sw=2

if !exists(':Neomake')
  finish
endif

let s:error_symbol = get(g:, 'airline#extensions#neomake#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#neomake#warning_symbol', 'W:')

function! s:get_counts()
  let l:counts = neomake#statusline#LoclistCounts()

  if empty(l:counts)
    return neomake#statusline#QflistCounts()
  else
    return l:counts
  endif
endfunction

function! airline#extensions#neomake#get_warnings()
  let counts = s:get_counts()
  let warnings = get(counts, 'W', 0)
  return warnings ? s:warning_symbol.warnings : ''
endfunction

function! airline#extensions#neomake#get_errors()
  let counts = s:get_counts()
  let errors = get(counts, 'E', 0)
  return errors ? s:error_symbol.errors : ''
endfunction

function! airline#extensions#neomake#init(ext)
  call airline#parts#define_function('neomake_warning_count', 'airline#extensions#neomake#get_warnings')
  call airline#parts#define_function('neomake_error_count', 'airline#extensions#neomake#get_errors')
endfunction
./autoload/airline/extensions/netrw.vim	[[[1
35
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: http://www.drchip.org/astronaut/vim/#NETRW
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':NetrwSettings')
  finish
endif

function! airline#extensions#netrw#apply(...)
  if &ft == 'netrw'
    let spc = g:airline_symbols.space

    call a:1.add_section('airline_a', spc.'netrw'.spc)
    if exists('*airline#extensions#branch#get_head')
      call a:1.add_section('airline_b', spc.'%{airline#extensions#branch#get_head()}'.spc)
    endif
    call a:1.add_section('airline_c', spc.'%f'.spc)
    call a:1.split()
    call a:1.add_section('airline_y', spc.'%{airline#extensions#netrw#sortstring()}'.spc)
    return 1
  endif
endfunction

function! airline#extensions#netrw#init(ext)
  let g:netrw_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#netrw#apply')
endfunction


function! airline#extensions#netrw#sortstring()
  let order = (get(g:, 'netrw_sort_direction', 'n') =~ 'n') ? '+' : '-'
  return get(g:, 'netrw_sort_by', '') . (g:airline_symbols.space) . '[' . order . ']'
endfunction
./autoload/airline/extensions/nrrwrgn.vim	[[[1
58
" MIT License. Copyright (c) 2013-2021 Bailey Ling, Christian Brabandt et al.
" Plugin: https://github.com/chrisbra/NrrwRgn
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_nrrw_rgn', 0)
  finish
endif

function! airline#extensions#nrrwrgn#apply(...)
  if exists(":WidenRegion") == 2
    let spc = g:airline_symbols.space
    if !exists("*nrrwrgn#NrrwRgnStatus()") || empty(nrrwrgn#NrrwRgnStatus())
      call a:1.add_section('airline_a', printf('%s[Narrowed%s#%d]', spc, spc, b:nrrw_instn))
      let bufname=(get(b:, 'orig_buf', 0) ? bufname(b:orig_buf) : substitute(bufname('%'), '^Nrrwrgn_\zs.*\ze_\d\+$', submatch(0), ''))
      call a:1.add_section('airline_c', spc.bufname.spc)
      call a:1.split()
    else
      let dict=nrrwrgn#NrrwRgnStatus()
      let vmode = { 'v': 'Char ', 'V': 'Line ', '': 'Block '}
      let mode = dict.visual ? vmode[dict.visual] : vmode['V']
      let winwidth = airline#util#winwidth()
      if winwidth < 80
        let mode = mode[0]
      endif
      let title = (winwidth < 80 ? "Nrrw" : "Narrowed ")
      let multi = (winwidth < 80 ? 'M' : 'Multi')
      call a:1.add_section('airline_a', printf('[%s%s%s#%d]%s', (dict.multi ? multi : ""),
        \ title, mode, b:nrrw_instn, spc))
      let name = dict.fullname
      if name !=# '[No Name]'
        if winwidth > 100
          " need some space
          let name = fnamemodify(dict.fullname, ':~')
          if strlen(name) > 8
            " shorten name
            let name = substitute(name, '\(.\)[^/\\]*\([/\\]\)', '\1\2', 'g')
          endif
        else
          let name = fnamemodify(dict.fullname, ':t')
        endif
      endif
      let range=(dict.multi ? '' : printf("[%d-%d]", dict.start[1], dict.end[1]))
      call a:1.add_section('airline_c', printf("%s %s %s", name, range,
        \ dict.enabled ? (&encoding ==? 'utf-8'  ? "\u2713"  : '')  : '!'))
      call a:1.split()
      call a:1.add_section('airline_x', get(g:, 'airline_section_x').spc)
      call a:1.add_section('airline_y', spc.get(g:, 'airline_section_y').spc)
      call a:1.add_section('airline_z', spc.get(g:, 'airline_section_z'))
    endif
    return 1
  endif
endfunction

function! airline#extensions#nrrwrgn#init(ext)
  call a:ext.add_statusline_func('airline#extensions#nrrwrgn#apply')
endfunction
./autoload/airline/extensions/nvimlsp.vim	[[[1
69
" Apache 2.0 license. Copyright (c) 2019-2021 Copyright Neovim contributors.
" Plugin: https://github.com/neovim/nvim-lsp
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !(get(g:, 'airline#extensions#nvimlsp#enabled', 1)
      \ && has('nvim')
      \ && luaeval('vim.lsp ~= nil'))
  finish
endif

function! s:airline_nvimlsp_count(cnt, symbol) abort
  return a:cnt ? a:symbol. a:cnt : ''
endfunction

function! airline#extensions#nvimlsp#get(type) abort
  if luaeval('vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    return ''
  endif

  let error_symbol = get(g:, 'airline#extensions#nvimlsp#error_symbol', 'E:')
  let warning_symbol = get(g:, 'airline#extensions#nvimlsp#warning_symbol', 'W:')
  let show_line_numbers = get(g:, 'airline#extensions#nvimlsp#show_line_numbers', 1)

  let is_err = a:type ==# 'Error'

  let symbol = is_err ? error_symbol : warning_symbol

  if luaeval("pcall(require, 'vim.diagnostic')")
    let severity = a:type == 'Warning' ? 'Warn' : a:type
    let num = len(v:lua.vim.diagnostic.get(0, { 'severity': severity }))
  elseif luaeval("pcall(require, 'vim.lsp.diagnostic')")
    let num = v:lua.vim.lsp.diagnostic.get_count(0, a:type)
  else
    let num = v:lua.vim.lsp.util.buf_diagnostics_count(a:type)
  endif

  if show_line_numbers == 1 && luaeval("pcall(require, 'vim.diagnostic')") && num > 0
    return s:airline_nvimlsp_count(num, symbol) . <sid>airline_nvimlsp_get_line_number(num, a:type)
  else
    return s:airline_nvimlsp_count(num, symbol)
  endif
endfunction

function! s:airline_nvimlsp_get_line_number(cnt, type) abort
  let severity = a:type == 'Warning' ? 'Warn' : a:type
  let num = v:lua.vim.diagnostic.get(0, { 'severity': severity })[0].lnum

  let l:open_lnum_symbol  =
    \ get(g:, 'airline#extensions#nvimlsp#open_lnum_symbol', '(L')
  let l:close_lnum_symbol =
    \ get(g:, 'airline#extensions#nvimlsp#close_lnum_symbol', ')')

  return open_lnum_symbol . num . close_lnum_symbol
endfunction

function! airline#extensions#nvimlsp#get_warning() abort
  return airline#extensions#nvimlsp#get('Warning')
endfunction

function! airline#extensions#nvimlsp#get_error() abort
  return airline#extensions#nvimlsp#get('Error')
endfunction

function! airline#extensions#nvimlsp#init(ext) abort
  call airline#parts#define_function('nvimlsp_error_count', 'airline#extensions#nvimlsp#get_error')
  call airline#parts#define_function('nvimlsp_warning_count', 'airline#extensions#nvimlsp#get_warning')
endfunction
./autoload/airline/extensions/obsession.vim	[[[1
23
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/tpope/vim-obsession
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*ObsessionStatus')
  finish
endif

let s:spc = g:airline_symbols.space

if !exists('g:airline#extensions#obsession#indicator_text')
  let g:airline#extensions#obsession#indicator_text = '$'
endif

function! airline#extensions#obsession#init(ext)
  call airline#parts#define_function('obsession', 'airline#extensions#obsession#get_status')
endfunction

function! airline#extensions#obsession#get_status()
  return ObsessionStatus((g:airline#extensions#obsession#indicator_text . s:spc), '')
endfunction
./autoload/airline/extensions/omnisharp.vim	[[[1
45
" MIT License
" Plugin: https://github.com/OmniSharp/omnisharp-vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'OmniSharp_loaded', 0)
  finish
endif

function! airline#extensions#omnisharp#server_status(...) abort
  if !exists(':OmniSharpGotoDefinition') || !get(g:, 'OmniSharp_server_stdio', 0)
    return ''
  endif

  let host = OmniSharp#GetHost(bufnr('%'))
  if type(host.job) != v:t_dict || get(host.job, 'stopped')
    return ''
  endif

  let sln = fnamemodify(host.sln_or_dir, ':t')

  if get(host.job, 'loaded', 0)
    return sln
  endif

  try
    let projectsloaded = OmniSharp#project#CountLoaded()
    let projectstotal = OmniSharp#project#CountTotal()
  catch
    " The CountLoaded and CountTotal functions are very new - catch the error
    " when they don't exist
    let projectsloaded = 0
    let projectstotal = 0
  endtry
  return printf('%s(%d/%d)', sln, projectsloaded, projectstotal)
endfunction

function! airline#extensions#omnisharp#init(ext) abort
  call airline#parts#define_function('omnisharp', 'airline#extensions#omnisharp#server_status')
  augroup airline_omnisharp
    autocmd!
    autocmd User OmniSharpStarted,OmniSharpReady,OmniSharpStopped AirlineRefresh!
  augroup END
endfunction
./autoload/airline/extensions/po.vim	[[[1
105
" MIT License. Copyright (c) 2013-2021 Bailey Ling, Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#po#shorten()
  " Format and shorte the output of msgfmt
  let b:airline_po_stats = substitute(get(b:, 'airline_po_stats', ''), ' \(message\|translation\)s*\.*', '', 'g')
  let b:airline_po_stats = substitute(b:airline_po_stats, ', ', '/', 'g')
  if exists("g:airline#extensions#po#displayed_limit")
    let w:displayed_po_limit = g:airline#extensions#po#displayed_limit
    if len(b:airline_po_stats) > w:displayed_po_limit - 1
      let b:airline_po_stats = b:airline_po_stats[0:(w:displayed_po_limit - 2)].(&encoding==?'utf-8' ? '…' : '.')
    endif
  endif
  if strlen(get(b:, 'airline_po_stats', '')) >= 30 && airline#util#winwidth() < 150
    let fuzzy = ''
    let untranslated = ''
    let messages = ''
    " Shorten [120 translated, 50 fuzzy, 4 untranslated] to [120T/50F/4U]
    if b:airline_po_stats =~ 'fuzzy'
      let fuzzy = substitute(b:airline_po_stats, '.\{-}\(\d\+\) fuzzy.*', '\1F', '')
      if fuzzy == '0F'
        let fuzzy = ''
      endif
    endif
    if b:airline_po_stats =~ 'untranslated'
      let untranslated = substitute(b:airline_po_stats, '.\{-}\(\d\+\) untranslated.*', '\1U', '')
      if untranslated == '0U'
        let untranslated = ''
      endif
    endif
    let messages = substitute(b:airline_po_stats, '\(\d\+\) translated.*', '\1T', '')
      if messages ==# '0T'
        let messages = ''
      endif
    let b:airline_po_stats = printf('%s%s%s', fuzzy, (empty(fuzzy) || empty(untranslated) ? '' : '/'), untranslated)
    if strlen(b:airline_po_stats) < 10
      let b:airline_po_stats = messages. (!empty(b:airline_po_stats) && !empty(messages) ? '/':''). b:airline_po_stats
    endif
  endif
  let b:airline_po_stats = '['.b:airline_po_stats. '] '
endfunction

function! airline#extensions#po#on_winenter()
  if !exists('#airline')
    " airline disabled
    return
  endif
  " only reset cache, if the window size changed
  if get(b:, 'airline_winwidth', 0) != airline#util#winwidth()
    let b:airline_winwidth = airline#util#winwidth()
    " needs re-formatting
    unlet! b:airline_po_stats
  endif
endfunction

function! s:autocmd_handler()
  if exists('#airline')
    unlet! b:airline_po_stats
  endif
endfunction

function! airline#extensions#po#apply(...)
  if &ft ==# 'po'
    call airline#extensions#prepend_to_section('z', '%{airline#extensions#po#stats()}')
    " Also reset the cache variable, if a window has been split, e.g. the winwidth changed
    autocmd airline BufWritePost * call s:autocmd_handler()
    autocmd airline WinEnter * call airline#extensions#po#on_winenter()
  endif
endfunction

function! airline#extensions#po#stats()
  if exists('b:airline_po_stats') && !empty(b:airline_po_stats)
    return b:airline_po_stats
  endif

  " Write stdout to null because we only want to see warnings.
  if g:airline#init#is_windows
    let cmd = 'msgfmt --statistics -o /NUL '
  else
    let cmd = 'msgfmt --statistics -o /dev/null -- '
  endif
  if g:airline#init#vim_async
    call airline#async#get_msgfmt_stat(cmd, expand('%:p'))
  elseif has("nvim")
    call airline#async#nvim_get_msgfmt_stat(cmd, expand('%:p'))
  else
    let airline_po_stats = system(cmd. shellescape(expand('%:p')))
    if v:shell_error
      return ''
    endif
    try
      let b:airline_po_stats = split(airline_po_stats, '\n')[0]
    catch
      let b:airline_po_stats = ''
    endtry
    call airline#extensions#po#shorten()
  endif
  return get(b:, 'airline_po_stats', '')
endfunction

function! airline#extensions#po#init(ext)
    call a:ext.add_statusline_func('airline#extensions#po#apply')
endfunction
./autoload/airline/extensions/poetv.vim	[[[1
32
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/petobens/poet_v
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space

function! airline#extensions#poetv#init(ext)
  call a:ext.add_statusline_func('airline#extensions#poetv#apply')
endfunction

function! airline#extensions#poetv#apply(...)
  if &filetype =~# 'python'
    if get(g:, 'poetv_loaded', 0)
      let statusline = poetv#statusline()
    else
      let statusline = fnamemodify($VIRTUAL_ENV, ':t')
    endif
    if !empty(statusline)
      call airline#extensions#append_to_section('x',
            \ s:spc.g:airline_right_alt_sep.s:spc.statusline)
    endif
  endif
endfunction

function! airline#extensions#poetv#update()
  if &filetype =~# 'python'
    call airline#extensions#poetv#apply()
    call airline#update_statusline()
  endif
endfunction
./autoload/airline/extensions/promptline.vim	[[[1
36
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/edkolev/promptline.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':PromptlineSnapshot')
  finish
endif

if !exists('airline#extensions#promptline#snapshot_file') || !len('airline#extensions#promptline#snapshot_file')
  finish
endif

let s:prompt_snapshot_file = get(g:, 'airline#extensions#promptline#snapshot_file', '')
let s:color_template = get(g:, 'airline#extensions#promptline#color_template', 'normal')

function! airline#extensions#promptline#init(ext)
  call a:ext.add_theme_func('airline#extensions#promptline#set_prompt_colors')
endfunction

function! airline#extensions#promptline#set_prompt_colors(palette)
  let color_template = has_key(a:palette, s:color_template) ? s:color_template : 'normal'
  let mode_palette = a:palette[color_template]

  if !has_key(g:, 'promptline_symbols')
    let g:promptline_symbols = {
          \ 'left'           : g:airline_left_sep,
          \ 'right'          : g:airline_right_sep,
          \ 'left_alt'       : g:airline_left_alt_sep,
          \ 'right_alt'      : g:airline_right_alt_sep}
  endif

  let promptline_theme = promptline#api#create_theme_from_airline(mode_palette)
  call promptline#api#create_snapshot_with_theme(s:prompt_snapshot_file, promptline_theme)
endfunction
./autoload/airline/extensions/quickfix.vim	[[[1
58
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:airline#extensions#quickfix#quickfix_text')
  let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
endif

if !exists('g:airline#extensions#quickfix#location_text')
  let g:airline#extensions#quickfix#location_text = 'Location'
endif

function! airline#extensions#quickfix#apply(...)
  if &buftype == 'quickfix'
    let w:airline_section_a = airline#extensions#quickfix#get_type()
    let w:airline_section_b = '%{get(w:, "quickfix_title", "")}'
    let w:airline_section_c = ''
    let w:airline_section_x = ''
  endif
endfunction

function! airline#extensions#quickfix#init(ext)
  call a:ext.add_statusline_func('airline#extensions#quickfix#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#quickfix#inactive_qf_window')
endfunction

function! airline#extensions#quickfix#inactive_qf_window(...)
  if getbufvar(a:2.bufnr, '&filetype') is# 'qf' && !empty(airline#util#getwinvar(a:2.winnr, 'quickfix_title', ''))
    call setwinvar(a:2.winnr, 'airline_section_c', '[%{get(w:, "quickfix_title", "")}] %f %m')
  endif
endfunction

function! airline#extensions#quickfix#get_type()
  if exists("*win_getid") && exists("*getwininfo")
    let dict = getwininfo(win_getid())
    if len(dict) > 0 && get(dict[0], 'quickfix', 0) && !get(dict[0], 'loclist', 0)
      return g:airline#extensions#quickfix#quickfix_text
    elseif len(dict) > 0 && get(dict[0], 'quickfix', 0) && get(dict[0], 'loclist', 0)
      return g:airline#extensions#quickfix#location_text
    endif
  endif
  redir => buffers
  silent ls
  redir END

  let nr = bufnr('%')
  for buf in split(buffers, '\n')
    if match(buf, '\v^\s*'.nr) > -1
      if match(buf, '\cQuickfix') > -1
        return g:airline#extensions#quickfix#quickfix_text
      else
        return g:airline#extensions#quickfix#location_text
      endif
    endif
  endfor
  return ''
endfunction
./autoload/airline/extensions/rufo.vim	[[[1
38
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:rufo_loaded')
  finish
endif

let s:spc = g:airline_symbols.space

if !exists('g:airline#extensions#rufo#symbol')
  let g:airline#extensions#rufo#symbol = 'RuFo'
endif

function! airline#extensions#rufo#init(ext)
   call airline#parts#define_raw('rufo', '%{airline#extensions#rufo#get_status}')
   call a:ext.add_statusline_func('airline#extensions#rufo#apply')
endfunction

function! airline#extensions#rufo#get_status()
  let out = ''
  if &ft == "ruby" && g:rufo_auto_formatting == 1
    let out .= s:spc.g:airline_left_alt_sep.s:spc.g:airline#extensions#rufo#symbol
  endif
  return out
endfunction

" This function will be invoked just prior to the statusline getting modified.
function! airline#extensions#rufo#apply(...)
  " First we check for the filetype.
  if &filetype == "ruby"
    " section_z.
    let w:airline_section_z = get(w:, 'airline_section_z', g:airline_section_z)

    " Then we just append this extension to it, optionally using separators.
    let w:airline_section_z .= '%{airline#extensions#rufo#get_status()}'
  endif
endfunction
./autoload/airline/extensions/scrollbar.vim	[[[1
37
" MIT License. Copyright (c) 2013-2021
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

function! airline#extensions#scrollbar#calculate() abort
  if winwidth(0) > get(g:, 'airline#extensions#scrollbar#minwidth', 200)
      \ && get(w:, 'airline_active', 0)
    let overwrite = 0
    if &encoding ==? 'utf-8' && !get(g:, 'airline_symbols_ascii', 0)
      let [left, right, middle] = [ '|', '|', '█']
      let overwrite = 1
    else
      let [left, right, middle] = [ '[', ']', '-']
    endif
    let spc = get(g:, 'airline_symbols.space', ' ')
    let width = 20 " max width, plus one border and indicator
    let perc = (line('.') + 0.0) / (line('$') + 0.0)
    let before = float2nr(round(perc * width))
    if before >= 0 && line('.') == 1
      let before = 0
      let left = (overwrite ? '' : left)
    endif
    let after  = width - before
    if (after <= 1 && line('.') == line('$'))
      let after = 0
      let right = (overwrite ? '' : right)
    endif
    return left . repeat(spc,  before) . middle . repeat(spc, after) . right
  else
    return ''
  endif
endfunction

function! airline#extensions#scrollbar#init(ext) abort
  call airline#parts#define_function('scrollbar', 'airline#extensions#scrollbar#calculate')
endfunction
./autoload/airline/extensions/searchcount.vim	[[[1
56
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" This extension is inspired by vim-anzu <https://github.com/osyo-manga/vim-anzu>.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*searchcount')
  finish
endif

function! airline#extensions#searchcount#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#searchcount#apply')
endfunction

function! airline#extensions#searchcount#apply(...) abort
  call airline#extensions#append_to_section('y',
        \ '%{v:hlsearch ? airline#extensions#searchcount#status() : ""}')
endfunction

function! s:search_term()
  let show_search_term = get(g:, 'airline#extensions#searchcount#show_search_term', 1)
  let search_term_limit = get(g:, 'airline#extensions#searchcount#search_term_limit', 8)

  if show_search_term == 0
    return ''
  endif
  " shorten for all width smaller than 300 (this is just a guess)
  " this uses a non-breaking space, because it looks like
  " a leading space is stripped :/
  return "\ua0" .  '/' . airline#util#shorten(getreg('/'), 300, search_term_limit)
endfunction

function! airline#extensions#searchcount#status() abort
  try
    let result = searchcount(#{recompute: 1, maxcount: -1})
    if empty(result) || result.total ==# 0
      return ''
    endif
    if result.incomplete ==# 1     " timed out
      return printf('%s[?/??]', s:search_term())
    elseif result.incomplete ==# 2 " max count exceeded
      if result.total > result.maxcount &&
            \  result.current > result.maxcount
        return printf('%s[>%d/>%d]', s:search_term(),
              \		    result.current, result.total)
      elseif result.total > result.maxcount
        return printf('%s[%d/>%d]', s:search_term(),
              \		    result.current, result.total)
      endif
    endif
    return printf('%s[%d/%d]', s:search_term(),
          \		result.current, result.total)
  catch
    return ''
  endtry
endfunction
./autoload/airline/extensions/syntastic.vim	[[[1
44
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/vim-syntastic/syntastic
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':SyntasticCheck')
  finish
endif

let s:error_symbol = get(g:, 'airline#extensions#syntastic#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#syntastic#warning_symbol', 'W:')

function! airline#extensions#syntastic#get_warning()
  return airline#extensions#syntastic#get('warning')
endfunction

function! airline#extensions#syntastic#get_error()
  return airline#extensions#syntastic#get('error')
endfunction

function! airline#extensions#syntastic#get(type)
  let _backup = get(g:, 'syntastic_stl_format', '')
  let is_err = (a:type  is# 'error')
  if is_err
    let g:syntastic_stl_format = get(g:, 'airline#extensions#syntastic#stl_format_err', '%E{[%fe(#%e)]}')
  else
    let g:syntastic_stl_format = get(g:, 'airline#extensions#syntastic#stl_format_warn', '%W{[%fw(#%w)]}')
  endif
  let cnt = SyntasticStatuslineFlag()
  if !empty(_backup)
    let g:syntastic_stl_format = _backup
  endif
  if empty(cnt)
    return ''
  else
    return (is_err ? s:error_symbol : s:warning_symbol).cnt
  endif
endfunction

function! airline#extensions#syntastic#init(ext)
  call airline#parts#define_function('syntastic-warn', 'airline#extensions#syntastic#get_warning')
  call airline#parts#define_function('syntastic-err', 'airline#extensions#syntastic#get_error')
endfunction
./autoload/airline/extensions/tabline/autoshow.vim	[[[1
53
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
let s:buf_min_count = get(g:, 'airline#extensions#tabline#buffer_min_count', 0)
let s:tab_min_count = get(g:, 'airline#extensions#tabline#tab_min_count', 0)

function! airline#extensions#tabline#autoshow#off()
  if exists('s:original_tabline')
    let &tabline = s:original_tabline
    let &showtabline = s:original_showtabline
  endif

  augroup airline_tabline_autoshow
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#autoshow#on()
  let [ s:original_tabline, s:original_showtabline ] = [ &tabline, &showtabline ]

  augroup airline_tabline_autoshow
    autocmd!
    if s:buf_min_count <= 0 && s:tab_min_count <= 1
      call airline#extensions#tabline#enable()
    else
      if s:show_buffers == 1
        autocmd BufEnter  * call <sid>show_tabline(s:buf_min_count, len(airline#extensions#tabline#buflist#list()))
        autocmd BufUnload * call <sid>show_tabline(s:buf_min_count, len(airline#extensions#tabline#buflist#list()) - 1)
      else
        autocmd TabNew,TabClosed  * call <sid>show_tabline(s:tab_min_count, tabpagenr('$'))
      endif
    endif

    " Invalidate cache.  This has to come after the BufUnload for
    " s:show_buffers, to invalidate the cache for BufEnter.
    autocmd BufLeave,BufAdd,BufUnload * call airline#extensions#tabline#buflist#invalidate()
  augroup END
endfunction

function! s:show_tabline(min_count, total_count)
  if a:total_count >= a:min_count
    if &showtabline != 2 && &lines > 3
      set showtabline=2
    endif
  else
    if &showtabline != 0
      set showtabline=0
    endif
  endif
endfunction
./autoload/airline/extensions/tabline/buffers.vim	[[[1
267
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space

let s:current_bufnr = -1
let s:current_modified = 0
let s:current_tabline = ''
let s:current_visible_buffers = []

let s:number_map = {
      \ '0': '⁰',
      \ '1': '¹',
      \ '2': '²',
      \ '3': '³',
      \ '4': '⁴',
      \ '5': '⁵',
      \ '6': '⁶',
      \ '7': '⁷',
      \ '8': '⁸',
      \ '9': '⁹'
      \ }
let s:number_map = &encoding == 'utf-8'
      \ ? get(g:, 'airline#extensions#tabline#buffer_idx_format', s:number_map)
      \ : {}

function! airline#extensions#tabline#buffers#off()
  augroup airline_tabline_buffers
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#buffers#on()
  let terminal_event = has("nvim") ? 'TermOpen' : 'TerminalOpen'
  augroup airline_tabline_buffers
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#buflist#clean()
    if exists("##".terminal_event)
      exe 'autocmd '. terminal_event. ' * call airline#extensions#tabline#buflist#clean()'
    endif
    autocmd User BufMRUChange call airline#extensions#tabline#buflist#clean()
  augroup END
endfunction

function! airline#extensions#tabline#buffers#invalidate()
  let s:current_bufnr = -1
endfunction

function! airline#extensions#tabline#buffers#get()
  try
    call <sid>map_keys()
  catch
    " no-op
  endtry
  let cur = bufnr('%')
  if cur == s:current_bufnr && &columns == s:column_width
    if !g:airline_detect_modified || getbufvar(cur, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let b = airline#extensions#tabline#new_builder()
  let tab_bufs = tabpagebuflist(tabpagenr())
  let show_buf_label_first = 0

  if get(g:, 'airline#extensions#tabline#buf_label_first', 0)
    let show_buf_label_first = 1
  endif
  if show_buf_label_first
    call airline#extensions#tabline#add_label(b, 'buffers', 0)
  endif

  let b.tab_bufs = tabpagebuflist(tabpagenr())

  let b.overflow_group = 'airline_tabhid'
  let b.buffers = airline#extensions#tabline#buflist#list()
  if get(g:, 'airline#extensions#tabline#current_first', 0)
    if index(b.buffers, cur) > -1
      call remove(b.buffers, index(b.buffers, cur))
    endif
    let b.buffers = [cur] + b.buffers
  endif

  function! b.get_group(i) dict
    let bufnum = get(self.buffers, a:i, -1)
    if bufnum == -1
      return ''
    endif
    let group = airline#extensions#tabline#group_of_bufnr(self.tab_bufs, bufnum)
    if bufnum == bufnr('%')
      let s:current_modified = (group == 'airline_tabmod') ? 1 : 0
    endif
    return group
  endfunction

  if has("tablineat")
    function! b.get_pretitle(i) dict
      let bufnum = get(self.buffers, a:i, -1)
      return '%'.bufnum.'@airline#extensions#tabline#buffers#clickbuf@'
    endfunction

    function! b.get_posttitle(i) dict
      return '%X'
    endfunction
  endif

  function! b.get_title(i) dict
    let bufnum = get(self.buffers, a:i, -1)
    let group = self.get_group(a:i)
    let pgroup = self.get_group(a:i - 1)
    " always add a space when powerline_fonts are used
    " or for the very first item
    if get(g:, 'airline_powerline_fonts', 0) || a:i == 0
      let space = s:spc
    else
      let space= (pgroup == group ? s:spc : '')
    endif

    if get(g:, 'airline#extensions#tabline#buffer_idx_mode', 0)
      if len(s:number_map) > 0
        return space. s:get_number(a:i) . '%(%{airline#extensions#tabline#get_buffer_name('.bufnum.')}%)' . s:spc
      else
        return '['.(a:i+1).s:spc.'%(%{airline#extensions#tabline#get_buffer_name('.bufnum.')}%)'.']'
      endif
    else
      return space.'%(%{airline#extensions#tabline#get_buffer_name('.bufnum.')}%)'.s:spc
    endif
  endfunction

  let current_buffer = max([index(b.buffers, cur), 0])
  let last_buffer = len(b.buffers) - 1
  call b.insert_titles(current_buffer, 0, last_buffer)

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')
  if !show_buf_label_first
    call airline#extensions#tabline#add_label(b, 'buffers', 1)
  endif

  call airline#extensions#tabline#add_tab_label(b)

  let s:current_bufnr = cur
  let s:column_width = &columns
  let s:current_tabline = b.build()
  let s:current_visible_buffers = copy(b.buffers)
  " Do not remove from s:current_visible_buffers, this breaks s:select_tab()
  "if b._right_title <= last_buffer
  "  call remove(s:current_visible_buffers, b._right_title, last_buffer)
  "endif
  "if b._left_title > 0
  "  call remove(s:current_visible_buffers, 0, b._left_title)
  "endif
  return s:current_tabline
endfunction

function! s:get_number(index)
  if len(s:number_map) == 0
    return a:index
  endif
  let bidx_mode = get(g:, 'airline#extensions#tabline#buffer_idx_mode', 0)
  let number_format = bidx_mode > 1 ? '%02d' : '%d'
  let l:count = bidx_mode == 2 ? a:index+11 : a:index+1
  return join(map(split(printf(number_format, l:count), '\zs'),
        \ 'get(s:number_map, v:val, "")'), '')
endfunction

function! s:select_tab(buf_index)
  " no-op when called in 'keymap_ignored_filetypes'
  if count(get(g:, 'airline#extensions#tabline#keymap_ignored_filetypes',
        \ ['vimfiler', 'nerdtree']), &ft)
    return
  endif
  let idx = a:buf_index
  if s:current_visible_buffers[0] == -1
    let idx = idx + 1
  endif

  let buf = get(s:current_visible_buffers, idx, 0)
  if buf != 0
     exec 'b!' . buf
   endif
endfunction

function! s:jump_to_tab(offset)
    let l = airline#extensions#tabline#buflist#list()
    let i = index(l, bufnr('%'))
    if i > -1
        exec 'b!' . l[(i + a:offset) % len(l)]
    endif
endfunction

function! s:map_keys()
  let bidx_mode = get(g:, 'airline#extensions#tabline#buffer_idx_mode', 1)
  if bidx_mode > 0
    if bidx_mode == 1
      for i in range(1, 10)
        exe printf('noremap <silent> <Plug>AirlineSelectTab%d :call <SID>select_tab(%d)<CR>', i%10, i-1)
      endfor
    else
      let start_idx = bidx_mode == 2 ? 11 : 1
      for i in range(start_idx, 99)
        exe printf('noremap <silent> <Plug>AirlineSelectTab%02d :call <SID>select_tab(%d)<CR>', i, i-start_idx)
      endfor
    endif
    noremap <silent> <Plug>AirlineSelectPrevTab :<C-u>call <SID>jump_to_tab(-v:count1)<CR>
    noremap <silent> <Plug>AirlineSelectNextTab :<C-u>call <SID>jump_to_tab(v:count1)<CR>
    " Enable this for debugging
    " com! AirlineBufferList :echo map(copy(s:current_visible_buffers), {i,k -> k.": ".bufname(k)})
  endif
endfunction

function! airline#extensions#tabline#buffers#clickbuf(minwid, clicks, button, modifiers) abort
    " Clickable buffers
    " works only in recent NeoVim with has('tablineat')

    " single mouse button click without modifiers pressed
    if a:clicks == 1 && a:modifiers !~# '[^ ]'
      if a:button is# 'l'
        " left button - switch to buffer
        try
          silent execute 'buffer' a:minwid
        catch
          call airline#util#warning("Cannot switch buffer, current buffer is modified! See :h 'hidden'")
        endtry
      elseif a:button is# 'm'
        " middle button - delete buffer

        if get(g:, 'airline#extensions#tabline#middle_click_preserves_windows', 0) == 0 || winnr('$') == 1
          " just simply delete the clicked buffer. This will cause windows
          " associated with the clicked buffer to be closed.
          silent execute 'bdelete' a:minwid
        else
          " find windows displaying the clicked buffer and open an new
          " buffer in them.
          let current_window = bufwinnr("%")
          let window_number = bufwinnr(a:minwid)
          let last_window_visited = -1

          " Set to 1 if the clicked buffer was open in any windows.
          let buffer_in_window = 0

          " Find the next window with the clicked buffer open. If bufwinnr()
          " returns the same window number, this is because we clicked a new
          " buffer, and then tried editing a new buffer. Vim won't create a
          " new empty buffer for the same window, so we get the same window
          " number from bufwinnr(). In this case we just give up and don't
          " delete the buffer.
          " This could be made cleaner if we could check if the clicked buffer
          " is a new buffer, but I don't know if there is a way to do that.
          while window_number != -1 && window_number != last_window_visited
            let buffer_in_window = 1
            silent execute window_number . 'wincmd w'
            silent execute 'enew'
            let last_window_visited = window_number
            let window_number = bufwinnr(a:minwid)
          endwhile
          silent execute current_window . 'wincmd w'
          if window_number != last_window_visited || buffer_in_window == 0
            silent execute 'bdelete' a:minwid
          endif
        endif
      endif
    endif
endfunction
./autoload/airline/extensions/tabline/buflist.vim	[[[1
85
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#buflist#invalidate()
  unlet! s:current_buffer_list
endfunction

function! airline#extensions#tabline#buflist#clean()
  if !exists('#airline')
    " airline disabled
    return
  endif
  call airline#extensions#tabline#buflist#invalidate()
  call airline#extensions#tabline#buffers#invalidate()
endfunction

" paths in excludes list
function! s:ExcludePaths(nr, exclude_paths)
  let bname = bufname(a:nr)
  if empty(bname)
    return 0
  endif
  let bpath = fnamemodify(bname, ":p")
  for f in a:exclude_paths
    if bpath =~# f | return 1 | endif
  endfor
endfunction

" other types to exclude
function! s:ExcludeOther(nr, exclude_preview)
  if (getbufvar(a:nr, 'current_syntax') == 'qf') ||
        \  (a:exclude_preview && getbufvar(a:nr, '&bufhidden') == 'wipe'
        \  && getbufvar(a:nr, '&buftype') == 'nofile')
    return 1 | endif
endfunction

function! airline#extensions#tabline#buflist#list()
  if exists('s:current_buffer_list')
    return s:current_buffer_list
  endif

  let exclude_buffers = get(g:, 'airline#extensions#tabline#exclude_buffers', [])
  let exclude_paths = get(g:, 'airline#extensions#tabline#excludes', [])
  let exclude_preview = get(g:, 'airline#extensions#tabline#exclude_preview', 1)

  let list = (exists('g:did_bufmru') && g:did_bufmru) ? BufMRUList() : range(1, bufnr("$"))

  let buffers = []
  " If this is too slow, we can switch to a different algorithm.
  " Basically branch 535 already does it, but since it relies on
  " BufAdd autocommand, I'd like to avoid this if possible.
  for nr in list
    if buflisted(nr)
      " Do not add to the bufferlist, if either
      " 1) bufnr is exclude_buffers list
      " 2) buffername matches one of exclude_paths patterns
      " 3) buffer is a quickfix buffer
      " 4) when excluding preview windows:
      "     'bufhidden' == wipe
      "     'buftype' == nofile
      " 5) ignore buffers matching airline#extensions#tabline#ignore_bufadd_pat

      " check buffer numbers first
      if index(exclude_buffers, nr) >= 0
        continue
      " check paths second
      elseif !empty(exclude_paths) && s:ExcludePaths(nr, exclude_paths)
        continue
      " ignore buffers matching airline#extensions#tabline#ignore_bufadd_pat
      elseif airline#util#ignore_buf(bufname(nr))
        continue
      " check other types last
      elseif s:ExcludeOther(nr, exclude_preview)
        continue
      endif

      call add(buffers, nr)
    endif
  endfor

  let s:current_buffer_list = buffers
  return buffers
endfunction
./autoload/airline/extensions/tabline/builder.vim	[[[1
232
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:prototype = {}

" Set the point in the tabline where the builder should insert the titles.
"
" Subsequent calls will overwrite the previous ones, so only the last call
" determines to location to insert titles.
"
" NOTE: The titles are not inserted until |build| is called, so that the
" remaining contents of the tabline can be taken into account.
"
" Callers should define at least |get_title| and |get_group| on the host
" object before calling |build|.
function! s:prototype.insert_titles(current, first, last) dict
  let self._first_title = a:first " lowest index
  let self._last_title = a:last " highest index
  let self._left_title = a:current " next index to add on the left
  let self._right_title = a:current + 1 " next index to add on the right
  let self._left_position = self.get_position() " left end of titles
  let self._right_position = self._left_position " right end of the titles
endfunction

" Insert a title for entry number |index|, of group |group| at position |pos|,
" if there is space for it. Returns 1 if it is inserted, 0 otherwise
"
" |force| inserts the title even if there isn't enough space left for it.
" |sep_size| adjusts the size change that the title is considered to take up,
"            to account for changes to the separators
"
" The title is defined by |get_title| on the hosting object, called with
" |index| as its only argument.
" |get_pretitle| and |get_posttitle| may be defined on the host object to
" insert some formatting before or after the title. These should be 0-width.
"
" This method updates |_right_position| and |_remaining_space| on the host
" object, if the title is inserted.
function! s:prototype.try_insert_title(index, group, pos, sep_size, force) dict
  let title = self.get_title(a:index)
  let title_size = s:tabline_evaluated_length(title) + a:sep_size
  if a:force || self._remaining_space >= title_size
    let pos = a:pos
    if has_key(self, "get_pretitle")
      call self.insert_raw(self.get_pretitle(a:index), pos)
      let self._right_position += 1
      let pos += 1
    endif

    call self.insert_section(a:group, title, pos)
    let self._right_position += 1
    let pos += 1

    if has_key(self, "get_posttitle")
      call self.insert_raw(self.get_posttitle(a:index), pos)
      let self._right_position += 1
      let pos += 1
    endif

    let self._remaining_space -= title_size
    return 1
  endif
  return 0
endfunction

function! s:get_separator_change(new_group, old_group, end_group, sep_size, alt_sep_size)
  return s:get_separator_change_with_end(a:new_group, a:old_group, a:end_group, a:end_group, a:sep_size, a:alt_sep_size)
endfunction

" Compute the change in size of the tabline caused by separators
"
" This should be kept up-to-date with |s:get_transitioned_separator| and
" |s:get_separator| in autoload/airline/builder.vim
function! s:get_separator_change_with_end(new_group, old_group, new_end_group, old_end_group, sep_size, alt_sep_size)
  let sep_change = 0
  if !empty(a:new_end_group) " Separator between title and the end
    let sep_change += airline#builder#should_change_group(a:new_group, a:new_end_group) ? a:sep_size : a:alt_sep_size
  endif
  if !empty(a:old_group) " Separator between the title and the one adjacent
    let sep_change += airline#builder#should_change_group(a:new_group, a:old_group) ? a:sep_size : a:alt_sep_size
    if !empty(a:old_end_group) " Remove mis-predicted separator
      let sep_change -= airline#builder#should_change_group(a:old_group, a:old_end_group) ? a:sep_size : a:alt_sep_size
    endif
  endif
  return sep_change
endfunction

" This replaces the build function of the |airline#builder#new| object, to
" insert titles as specified by the last call to |insert_titles| before
" passing to the original build function.
"
" Callers should define at least |get_title| and |get_group| on the host
" object if |insert_titles| has been called on it.
function! s:prototype.build() dict
  if has_key(self, '_left_position') && self._first_title <= self._last_title
    let self._remaining_space = &columns - s:tabline_evaluated_length(self._build())

    let center_active = get(g:, 'airline#extensions#tabline#center_active', 0)

    let sep_size = s:tabline_evaluated_length(self._context.left_sep)
    let alt_sep_size = s:tabline_evaluated_length(self._context.left_alt_sep)

    let outer_left_group = airline#builder#get_prev_group(self._sections, self._left_position)
    let outer_right_group = airline#builder#get_next_group(self._sections, self._right_position)

    let overflow_marker = get(g:, 'airline#extensions#tabline#overflow_marker', g:airline_symbols.ellipsis)
    let overflow_marker_size = s:tabline_evaluated_length(overflow_marker)
    " Allow space for the markers before we begin filling in titles.
    if self._left_title > self._first_title
      let self._remaining_space -= overflow_marker_size +
        \ s:get_separator_change(self.overflow_group, "", outer_left_group, sep_size, alt_sep_size)
    endif
    if self._left_title < self._last_title
      let self._remaining_space -= overflow_marker_size +
        \ s:get_separator_change(self.overflow_group, "", outer_right_group, sep_size, alt_sep_size)
    endif

    " Add the current title
    let group = self.get_group(self._left_title)
    if self._left_title == self._first_title
      let sep_change = s:get_separator_change(group, "", outer_left_group, sep_size, alt_sep_size)
    else
      let sep_change = s:get_separator_change(group, "", self.overflow_group, sep_size, alt_sep_size)
    endif
    if self._left_title == self._last_title
      let sep_change += s:get_separator_change(group, "", outer_right_group, sep_size, alt_sep_size)
    else
      let sep_change += s:get_separator_change(group, "", self.overflow_group, sep_size, alt_sep_size)
    endif
    let left_group = group
    let right_group = group
    let self._left_title -=
      \ self.try_insert_title(self._left_title, group, self._left_position, sep_change, 1)

    if get(g:, 'airline#extensions#tabline#current_first', 0)
      " always have current title first
      let self._left_position += 1
    endif

    if !center_active && self._right_title <= self._last_title
      " Add the title to the right
      let group = self.get_group(self._right_title)
      if self._right_title == self._last_title
        let sep_change = s:get_separator_change_with_end(group, right_group, outer_right_group, self.overflow_group, sep_size, alt_sep_size) - overflow_marker_size
      else
        let sep_change = s:get_separator_change(group, right_group, self.overflow_group, sep_size, alt_sep_size)
      endif
      let right_group = group
      let self._right_title +=
      \ self.try_insert_title(self._right_title, group, self._right_position, sep_change, 1)
    endif

    while self._remaining_space > 0
      let done = 0
      if self._left_title >= self._first_title
        " Insert next title to the left
        let group = self.get_group(self._left_title)
        if self._left_title == self._first_title
          let sep_change = s:get_separator_change_with_end(group, left_group, outer_left_group, self.overflow_group, sep_size, alt_sep_size) - overflow_marker_size
        else
          let sep_change = s:get_separator_change(group, left_group, self.overflow_group, sep_size, alt_sep_size)
        endif
        let left_group = group
        let done = self.try_insert_title(self._left_title, group, self._left_position, sep_change, 0)
        let self._left_title -= done
      endif
      " If center_active is set, this |if| operates as an independent |if|,
      " otherwise as an |elif|.
      if self._right_title <= self._last_title && (center_active || !done)
        " Insert next title to the right
        let group = self.get_group(self._right_title)
        if self._right_title == self._last_title
          let sep_change = s:get_separator_change_with_end(group, right_group, outer_right_group, self.overflow_group, sep_size, alt_sep_size) - overflow_marker_size
        else
          let sep_change = s:get_separator_change(group, right_group, self.overflow_group, sep_size, alt_sep_size)
        endif
        let right_group = group
        let done = self.try_insert_title(self._right_title, group, self._right_position, sep_change, 0)
        let self._right_title += done
      endif
      if !done
        break
      endif
    endwhile

    if self._left_title >= self._first_title
      if get(g:, 'airline#extensions#tabline#current_first', 0)
        let self._left_position -= 1
      endif
      call self.insert_section(self.overflow_group, overflow_marker, self._left_position)
      let self._right_position += 1
    endif

    if self._right_title <= self._last_title
      call self.insert_section(self.overflow_group, overflow_marker, self._right_position)
    endif
  endif

  return self._build()
endfunction

let s:prototype.overflow_group = 'airline_tab'

" Extract the text content a tabline will render. (Incomplete).
"
" See :help 'statusline' for the list of fields.
function! s:evaluate_tabline(tabline)
  let tabline = a:tabline
  let tabline = substitute(tabline, '%{\([^}]\+\)}', '\=eval(submatch(1))', 'g')
  let tabline = substitute(tabline, '%#[^#]\+#', '', 'g')
  let tabline = substitute(tabline, '%(\([^)]\+\)%)', '\1', 'g')
  let tabline = substitute(tabline, '%\d\+[TX]', '', 'g')
  let tabline = substitute(tabline, '%=', '', 'g')
  let tabline = substitute(tabline, '%\d*\*', '', 'g')
  if has('tablineat')
    let tabline = substitute(tabline, '%@[^@]\+@', '', 'g')
  endif
  return tabline
endfunction

function! s:tabline_evaluated_length(tabline)
  return airline#util#strchars(s:evaluate_tabline(a:tabline))
endfunction

function! airline#extensions#tabline#builder#new(context)
  let builder = airline#builder#new(a:context)
  let builder._build = builder.build
  call extend(builder, s:prototype, 'force')
  return builder
endfunction
./autoload/airline/extensions/tabline/ctrlspace.vim	[[[1
169
" MIT License. Copyright (c) 2016-2021 Kevin Sapper et al.
" Plugin: https://github.com/szw/vim-ctrlspace
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:current_bufnr = -1
let s:current_modified = 0
let s:current_tabnr = -1
let s:current_tabline = ''
let s:highlight_groups = ['hid', 0, '', 'sel', 'mod_unsel', 0, 'mod_unsel', 'mod']

function! airline#extensions#tabline#ctrlspace#off()
  augroup airline_tabline_ctrlspace
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#ctrlspace#on()
  augroup airline_tabline_ctrlspace
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#ctrlspace#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#ctrlspace#invalidate()
  if !exists('#airline')
    return
  endif
  let s:current_bufnr = -1
  let s:current_tabnr = -1
endfunction

function! airline#extensions#tabline#ctrlspace#add_buffer_section(builder, cur_tab, cur_buf, pull_right)
  let pos_extension = (a:pull_right ? '_right' : '')

  let buffer_list = []
  for bufferindex in sort(keys(ctrlspace#api#Buffers(a:cur_tab)), 'N')
    for buffer in ctrlspace#api#BufferList(a:cur_tab)
      if buffer['index'] == bufferindex
        call add(buffer_list, buffer)
      endif
    endfor
  endfor

  " add by tenfy(tenfyzhong@qq.com)
  " if the current buffer no in the buffer list
  " return false and no redraw tabline.
  " Fixes #1515. if there a BufEnter autocmd execute redraw. The tabline may no update.
  let bufnr_list = map(copy(buffer_list), 'v:val["index"]')
  if index(bufnr_list, a:cur_buf) == -1 && a:cur_tab == s:current_tabnr
    return 0
  endif

  let s:current_modified = getbufvar(a:cur_buf, '&modified')

  for buffer in buffer_list
    let group = 'airline_tab'
          \ .s:highlight_groups[(4 * buffer.modified) + (2 * buffer.visible) + (a:cur_buf == buffer.index)]
          \ .pos_extension

    let buf_name = '%(%{airline#extensions#tabline#get_buffer_name('.buffer.index.')}%)'

    if has("tablineat")
      let buf_name = '%'.buffer.index.'@airline#extensions#tabline#buffers#clickbuf@'.buf_name.'%X'
    endif

    call a:builder.add_section_spaced(group, buf_name)
  endfor

  " add by tenfy(tenfyzhong@qq.com)
  " if the selected buffer was updated
  " return true
  return 1
endfunction

function! airline#extensions#tabline#ctrlspace#add_tab_section(builder, pull_right)
  let pos_extension = (a:pull_right ? '_right' : '')
  let tab_list = ctrlspace#api#TabList()

  for tab in tab_list
    let group = 'airline_tab'
          \ .s:highlight_groups[(4 * tab.modified) + (3 * tab.current)]
          \ .pos_extension

    if get(g:, 'airline#extensions#tabline#ctrlspace_show_tab_nr', 0) == 0
      call a:builder.add_section_spaced(group, '%'.tab.index.'T'.tab.title.ctrlspace#api#TabBuffersNumber(tab.index).'%T')
    else
      call a:builder.add_section_spaced(group, '%'.(tab.index).'T'.(tab.index).(g:airline_symbols.space).(tab.title).ctrlspace#api#TabBuffersNumber(tab.index).'%T')
    endif
  endfor
endfunction

function! airline#extensions#tabline#ctrlspace#get()
  let cur_buf = bufnr('%')
  let buffer_label = get(g:, 'airline#extensions#tabline#buffers_label', 'buffers')
  let tab_label = get(g:, 'airline#extensions#tabline#tabs_label', 'tabs')
  let switch_buffers_and_tabs = get(g:, 'airline#extensions#tabline#switch_buffers_and_tabs', 0)

  try
    call airline#extensions#tabline#tabs#map_keys()
  endtry

  let cur_tab = tabpagenr()

  if cur_buf == s:current_bufnr && cur_tab == s:current_tabnr
    if !g:airline_detect_modified || getbufvar(cur_buf, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let builder = airline#extensions#tabline#new_builder()

  let show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
  let show_tabs = get(g:, 'airline#extensions#tabline#show_tabs', 1)

  let AppendBuffers = function('airline#extensions#tabline#ctrlspace#add_buffer_section', [builder, cur_tab, cur_buf])
  let AppendTabs = function('airline#extensions#tabline#ctrlspace#add_tab_section', [builder])
  let AppendLabel = function(builder.add_section_spaced, ['airline_tabtype'], builder)

  " <= 1: |{Tabs}                      <tab|
  " == 2: |{Buffers}               <buffers|
  " == 3: |buffers> {Buffers}  {Tabs} <tabs|
  let showing_mode = (2 * show_buffers) + (show_tabs)
  let ignore_update = 0

  " Add left tabline content
  if showing_mode <= 1 " Tabs only mode
    call AppendTabs(0)
  elseif showing_mode == 2 " Buffers only mode
    let ignore_update = !AppendBuffers(0)
  else
    if !switch_buffers_and_tabs
      call AppendLabel(buffer_label)
      let ignore_update = !AppendBuffers(0)
    else
      call AppendLabel(tab_label)
      call AppendTabs(0)
    endif
  endif

  if ignore_update | return s:current_tabline | endif

  call builder.add_section('airline_tabfill', '')
  call builder.split()
  call builder.add_section('airline_tabfill', '')

  " Add right tabline content
  if showing_mode <= 1 " Tabs only mode
    call AppendLabel(tab_label)
  elseif showing_mode == 2 " Buffers only mode
    call AppendLabel(buffer_label)
  else
    if !switch_buffers_and_tabs
      call AppendTabs(1)
      call AppendLabel(tab_label)
    else
      let ignore_update = AppendBuffers(1)
      call AppendLabel(buffer_label)
    endif
  endif

  if ignore_update | return s:current_tabline | endif

  let s:current_bufnr = cur_buf
  let s:current_tabnr = cur_tab
  let s:current_tabline = builder.build()
  return s:current_tabline
endfunction
./autoload/airline/extensions/tabline/formatters/default.vim	[[[1
85
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

if !exists(":def") || !airline#util#has_vim9_script()
  function! airline#extensions#tabline#formatters#default#format(bufnr, buffers)
    let fnametruncate = get(g:, 'airline#extensions#tabline#fnametruncate', 0)
    let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
    let _ = ''

    let name = bufname(a:bufnr)
    if empty(name)
      let _ = '[No Name]'
    elseif name =~ 'term://'
      " Neovim Terminal
      let _ = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
    else
      if get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
        " Does not handle non-ascii characters like Cyrillic: 'D/Учёба/t.c'
        "let _ .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
        let _ = pathshorten(fnamemodify(name, fmod))
      else
        let _ = fnamemodify(name, fmod)
      endif
      if a:bufnr != bufnr('%') && fnametruncate && strlen(_) > fnametruncate
        let _ = airline#util#strcharpart(_, 0, fnametruncate)
      endif
    endif

    return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, _)
  endfunction

  function! airline#extensions#tabline#formatters#default#wrap_name(bufnr, buffer_name)
    let buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
    let buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)

    let _ = buf_nr_show ? printf(buf_nr_format, a:bufnr) : ''
    let _ .= substitute(a:buffer_name, '\\', '/', 'g')

    if getbufvar(a:bufnr, '&modified') == 1
      let _ .= g:airline_symbols.modified
    endif
    return _
  endfunction
  finish
else
  " Vim9 Script implementation
  def airline#extensions#tabline#formatters#default#format(bufnr: number, buffers: list<number>): string
		var fnametruncate = get(g:, 'airline#extensions#tabline#fnametruncate', 0)
    var fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':~:.')
    var result = ''

    var name = bufname(bufnr)
    if empty(name)
      result = '[No Name]'
    elseif name =~ 'term://'
      # Neovim Terminal
      result = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
    else
      if get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
         result = pathshorten(fnamemodify(name, fmod))
      else
         result = fnamemodify(name, fmod)
      endif
      if bufnr != bufnr('%') && fnametruncate && strlen(result) > fnametruncate
        result = airline#util#strcharpart(result, 0, fnametruncate)
      endif
    endif
    return airline#extensions#tabline#formatters#default#wrap_name(bufnr, result)
  enddef

  def airline#extensions#tabline#formatters#default#wrap_name(bufnr: number, buffer_name: string): string
    var buf_nr_format = get(g:, 'airline#extensions#tabline#buffer_nr_format', '%s: ')
    var buf_nr_show = get(g:, 'airline#extensions#tabline#buffer_nr_show', 0)

    var result = buf_nr_show ? printf(buf_nr_format, bufnr) : ''
    result ..= substitute(buffer_name, '\\', '/', 'g')

    if getbufvar(bufnr, '&modified')
      result ..= g:airline_symbols.modified
    endif
    return result
  enddef
endif
./autoload/airline/extensions/tabline/formatters/jsformatter.vim	[[[1
15
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#jsformatter#format(bufnr, buffers)
  let buf = bufname(a:bufnr)
  let filename = fnamemodify(buf, ':t')

  if filename ==# 'index.js' || filename ==# 'index.jsx' || filename ==# 'index.ts' || filename ==# 'index.tsx' || filename ==# 'index.vue'
    return fnamemodify(buf, ':p:h:t') . '/i'
  else
    return airline#extensions#tabline#formatters#unique_tail_improved#format(a:bufnr, a:buffers)
  endif
endfunction
./autoload/airline/extensions/tabline/formatters/short_path.vim	[[[1
21
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#short_path#format(bufnr, buffers)
  let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':p:h:t')
  let _ = ''

  let name = bufname(a:bufnr)
  if empty(name)
    let _ .= '[No Name]'
  elseif name =~ 'term://'
    " Neovim Terminal
    let _ = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
  else
    let _ .= fnamemodify(name, fmod) . '/' . fnamemodify(name, ':t')
  endif

  return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, _)
endfunction
./autoload/airline/extensions/tabline/formatters/short_path_improved.vim	[[[1
36
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#short_path_improved#format(bufnr, buffers) abort
  let name = bufname(a:bufnr)
  if empty(name)
    return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, '[No Name]')
  endif

  let tail = s:tail(a:bufnr)
  let tails = s:tails(a:bufnr, a:buffers)

  if has_key(tails, tail)
    " Use short path for duplicates
    return airline#extensions#tabline#formatters#short_path#format(a:bufnr, a:buffers)
  endif

  " Use tail for unique filenames
  return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, tail)
endfunction

function! s:tails(self, buffers) abort
  let tails = {}
  for nr in a:buffers
    if nr != a:self
      let tails[s:tail(nr)] = 1
    endif
  endfor
  return tails
endfunction

function! s:tail(bufnr) abort
  return fnamemodify(bufname(a:bufnr), ':t')
endfunction
./autoload/airline/extensions/tabline/formatters/tabnr.vim	[[[1
18
" MIT License. Copyright (c) 2017-2021 Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#tabnr#format(tab_nr, buflist)
  let spc=g:airline_symbols.space
  let tab_nr_type = get(g:, 'airline#extensions#tabline#tab_nr_type', 0)
  if tab_nr_type == 0 " nr of splits
    return spc. len(tabpagebuflist(a:tab_nr))
  elseif tab_nr_type == 1 " tab number
    " Return only the current tab number
    return spc. a:tab_nr
  else " tab_nr_type == 2 splits and tab number
    " return the tab number followed by the number of buffers (in the tab)
    return spc. a:tab_nr. spc. len(tabpagebuflist(a:tab_nr))
  endif
endfunction
./autoload/airline/extensions/tabline/formatters/unique_tail.vim	[[[1
46
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#tabline#formatters#unique_tail#format(bufnr, buffers)
  let duplicates = {}
  let tails = {}
  let map = {}
  for nr in a:buffers
    let name = bufname(nr)
    if empty(name)
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, '[No Name]')
    else
      if name =~ 'term://'
        " Neovim Terminal
        let tail = substitute(name, '\(term:\)//.*:\(.*\)', '\1 \2', '')
      else
        let tail = fnamemodify(name, ':s?/\+$??:t')
      endif
      if has_key(tails, tail)
        let duplicates[nr] = nr
      endif
      let tails[tail] = 1
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, tail)
    endif
  endfor

  let fmod = get(g:, 'airline#extensions#tabline#fnamemod', ':p:.')
  for nr in values(duplicates)
    let name = bufname(nr)
    let fnamecollapse = get(g:, 'airline#extensions#tabline#fnamecollapse', 1)
    if fnamecollapse
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g'))
    else
      let map[nr] = airline#extensions#tabline#formatters#default#wrap_name(nr, fnamemodify(name, fmod))
    endif
  endfor

  if has_key(map, a:bufnr)
    return map[a:bufnr]
  endif

  " if we get here, the buffer list isn't in sync with the selected buffer yet, fall back to the default
  return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
endfunction
./autoload/airline/extensions/tabline/formatters/unique_tail_improved.vim	[[[1
91
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:skip_symbol = '…'

function! airline#extensions#tabline#formatters#unique_tail_improved#format(bufnr, buffers)
  if len(a:buffers) <= 1 " don't need to compare bufnames if has less than one buffer opened
    return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
  endif

  let curbuf_tail = fnamemodify(bufname(a:bufnr), ':t')
  let do_deduplicate = 0
  let path_tokens = {}

  for nr in a:buffers
    let name = bufname(nr)
    if !empty(name) && nr != a:bufnr && fnamemodify(name, ':t') == curbuf_tail " only perform actions if curbuf_tail isn't unique
      let do_deduplicate = 1
      let tokens = reverse(split(substitute(fnamemodify(name, ':p:h'), '\\', '/', 'g'), '/'))
      let token_index = 0
      for token in tokens
        if token == '' | continue | endif
        if token == '.' | break | endif
        if !has_key(path_tokens, token_index)
          let path_tokens[token_index] = {}
        endif
        let path_tokens[token_index][token] = 1
        let token_index += 1
      endfor
    endif
  endfor

  if do_deduplicate == 1
    let path = []
    let token_index = 0
    for token in reverse(split(substitute(fnamemodify(bufname(a:bufnr), ':p:h'), '\\', '/', 'g'), '/'))
      if token == '.' | break | endif
      let duplicated = 0
      let uniq = 1
      let single = 1
      if has_key(path_tokens, token_index)
        let duplicated = 1
        if len(keys(path_tokens[token_index])) > 1 | let single = 0 | endif
        if has_key(path_tokens[token_index], token) | let uniq = 0 | endif
      endif
      call insert(path, {'token': token, 'duplicated': duplicated, 'uniq': uniq, 'single': single})
      let token_index += 1
    endfor

    let buf_name = [curbuf_tail]
    let has_uniq = 0
    let has_skipped = 0
    for token1 in reverse(path)
      if !token1['duplicated'] && len(buf_name) > 1
        call insert(buf_name, s:skip_symbol)
        let has_skipped = 0
        break
      endif

      if has_uniq == 1
        call insert(buf_name, s:skip_symbol)
        let has_skipped = 0
        break
      endif

      if token1['uniq'] == 0 && token1['single'] == 1
        let has_skipped = 1
      else
        if has_skipped == 1
          call insert(buf_name, s:skip_symbol)
          let has_skipped = 0
        endif
        call insert(buf_name, token1['token'])
      endif

      if token1['uniq'] == 1
        let has_uniq = 1
      endif
    endfor

    if has_skipped == 1
      call insert(buf_name, s:skip_symbol)
    endif

    return airline#extensions#tabline#formatters#default#wrap_name(a:bufnr, join(buf_name, '/'))
  else
    return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
  endif
endfunction
./autoload/airline/extensions/tabline/tabs.vim	[[[1
141
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space
let s:current_bufnr = -1
let s:current_tabnr = -1
let s:current_modified = 0

function! airline#extensions#tabline#tabs#off()
  augroup airline_tabline_tabs
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#tabs#on()
  augroup airline_tabline_tabs
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#tabs#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#tabs#invalidate()
  if exists('#airline')
    let s:current_bufnr = -1
  endif
endfunction

function! airline#extensions#tabline#tabs#get()
  let curbuf = bufnr('%')
  let curtab = tabpagenr()
  try
    call airline#extensions#tabline#tabs#map_keys()
  catch
    " no-op
  endtry
  if curbuf == s:current_bufnr && curtab == s:current_tabnr && &columns == s:column_width
    if !g:airline_detect_modified || getbufvar(curbuf, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let s:filtered_buflist =  airline#extensions#tabline#buflist#list()

  let b = airline#extensions#tabline#new_builder()

  call airline#extensions#tabline#add_label(b, 'tabs', 0)

  function! b.get_group(i) dict
    let curtab = tabpagenr()
    let group = 'airline_tab'
    if a:i == curtab
      let group = 'airline_tabsel'
      if g:airline_detect_modified
        for bi in tabpagebuflist(curtab)
          if index(s:filtered_buflist,bi) != -1
            if getbufvar(bi, '&modified')
              let group = 'airline_tabmod'
            endif
          endif
        endfor
      endif
      let s:current_modified = (group == 'airline_tabmod') ? 1 : 0
    endif
    return group
  endfunction

  function! b.get_title(i) dict
    let val = '%('

    if get(g:, 'airline#extensions#tabline#show_tab_nr', 1)
      let val .= airline#extensions#tabline#tabs#tabnr_formatter(a:i, tabpagebuflist(a:i))
    endif

    return val.'%'.a:i.'T %{airline#extensions#tabline#title('.a:i.')} %)'
  endfunction

  call b.insert_titles(curtab, 1, tabpagenr('$'))

  call b.add_section('airline_tabfill', '')
  call b.split()
  call b.add_section('airline_tabfill', '')

  if get(g:, 'airline#extensions#tabline#show_close_button', 1)
    call b.add_section('airline_tab_right', ' %999X'.
          \ get(g:, 'airline#extensions#tabline#close_symbol', 'X').'%X ')
  endif

  if get(g:, 'airline#extensions#tabline#show_splits', 1) == 1
    let buffers = tabpagebuflist(curtab)
    for nr in buffers
      if index(s:filtered_buflist,nr) != -1
        let group = airline#extensions#tabline#group_of_bufnr(buffers, nr) . "_right"
        call b.add_section_spaced(group, '%(%{airline#extensions#tabline#get_buffer_name('.nr.')}%)')
      endif
    endfor
    if get(g:, 'airline#extensions#tabline#show_buffers', 1)
      call airline#extensions#tabline#add_label(b, 'buffers', 1)
    endif
  endif
  call airline#extensions#tabline#add_tab_label(b)

  let s:current_bufnr = curbuf
  let s:current_tabnr = curtab
  let s:column_width = &columns
  let s:current_tabline = b.build()
  return s:current_tabline
endfunction

function! airline#extensions#tabline#tabs#map_keys()
  if maparg('<Plug>AirlineSelectTab1', 'n') is# ':1tabn<CR>'
    return
  endif
  let bidx_mode = get(g:, 'airline#extensions#tabline#buffer_idx_mode', 1)
  if bidx_mode == 1
    for i in range(1, 10)
      exe printf('noremap <silent> <Plug>AirlineSelectTab%d :%dtabn<CR>', i%10, i)
    endfor
  else
      for i in range(11, 99)
        exe printf('noremap <silent> <Plug>AirlineSelectTab%d :%dtabn<CR>', i, i-10)
      endfor
    endif
  noremap <silent> <Plug>AirlineSelectPrevTab gT
  " tabn {count} goes to count tab does not go {count} tab pages forward!
  noremap <silent> <Plug>AirlineSelectNextTab :<C-U>exe repeat(':tabn\|', v:count1)<cr>
endfunction

function! airline#extensions#tabline#tabs#tabnr_formatter(nr, i) abort
  let formatter = get(g:, 'airline#extensions#tabline#tabnr_formatter', 'tabnr')
  try
    return airline#extensions#tabline#formatters#{formatter}#format(a:nr, a:i)
  catch /^Vim\%((\a\+)\)\=:E117/	" catch E117, unknown function
    " Function not found
    return call(formatter, [a:nr, a:i])
  catch
    " something went wrong, return an empty string
    return ""
  endtry
endfunction
./autoload/airline/extensions/tabline/tabws.vim	[[[1
156
" MIT License. Copyright (c) 2016-2021 Kevin Sapper et al.
" PLugin: https://github.com/s1341/vim-tabws
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:current_bufnr = -1
let s:current_modified = 0
let s:current_tabnr = -1
let s:current_tabline = ''
let s:highlight_groups = ['hid', 0, '', 'sel', 'mod_unsel', 0, 'mod_unsel', 'mod']

function! airline#extensions#tabline#tabws#off()
  augroup airline_tabline_tabws
    autocmd!
  augroup END
endfunction

function! airline#extensions#tabline#tabws#on()
  augroup airline_tabline_tabws
    autocmd!
    autocmd BufDelete * call airline#extensions#tabline#tabws#invalidate()
  augroup END
endfunction

function! airline#extensions#tabline#tabws#invalidate()
  if exists('#airline')
    let s:current_bufnr = -1
    let s:current_tabnr = -1
  endif
endfunction

function! airline#extensions#tabline#tabws#add_buffer_section(builder, cur_tab, cur_buf, pull_right)
  let pos_extension = (a:pull_right ? '_right' : '')
  let bufnr_list = tabws#getbuffersfortab(a:cur_tab)

  if index(bufnr_list, a:cur_buf) == -1 && a:cur_tab == s:current_tabnr
    return 0
  endif

  let s:current_modified = getbufvar(a:cur_buf, '&modified')
  let visible_list = tabpagebuflist(a:cur_tab)

  for buffer in bufnr_list
    let group = 'airline_tab'
          \ .s:highlight_groups[(4 * getbufvar(buffer, '&modified')) + (2 * (index(visible_list, buffer) != -1)) + (a:cur_buf == buffer)]
          \ .pos_extension

    let buf_name = '%(%{airline#extensions#tabline#get_buffer_name('.buffer.')}%)'

    if has("tablineat")
      let buf_name = '%'.buffer.'@airline#extensions#tabline#buffers#clickbuf@'.buf_name.'%X'
    endif

    call a:builder.add_section_spaced(group, buf_name)
  endfor

  " add by tenfy(tenfyzhong@qq.com)
  " if the selected buffer was updated
  " return true
  return 1
endfunction

function! airline#extensions#tabline#tabws#add_tab_section(builder, pull_right)
  let pos_extension = (a:pull_right ? '_right' : '')

  for tab in range(1, tabpagenr('$'))
    let current = tab == tabpagenr()
    let group = 'airline_tab'
          \ .s:highlight_groups[(3 * current)]
          \ .pos_extension

    if get(g:, 'airline#extensions#tabline#tabws_show_tab_nr', 0) == 0
      call a:builder.add_section_spaced(group, '%'.tab.'T'.tabws#gettabname(tab).'%T')
    else
      call a:builder.add_section_spaced(group, '%'.tab.'T'.tab.(g:airline_symbols.space).tabws#gettabname(tab).'%T')
    endif
  endfor
endfunction

function! airline#extensions#tabline#tabws#get()
  let cur_buf = bufnr('%')
  let buffer_label = get(g:, 'airline#extensions#tabline#buffers_label', 'buffers')
  let tab_label = get(g:, 'airline#extensions#tabline#tabs_label', 'tabs')
  let switch_buffers_and_tabs = get(g:, 'airline#extensions#tabline#switch_buffers_and_tabs', 0)

  try
    call airline#extensions#tabline#tabs#map_keys()
  endtry

  let cur_tab = tabpagenr()

  if cur_buf == s:current_bufnr && cur_tab == s:current_tabnr
    if !g:airline_detect_modified || getbufvar(cur_buf, '&modified') == s:current_modified
      return s:current_tabline
    endif
  endif

  let builder = airline#extensions#tabline#new_builder()

  let show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
  let show_tabs = get(g:, 'airline#extensions#tabline#show_tabs', 1)

  let AppendBuffers = function('airline#extensions#tabline#tabws#add_buffer_section', [builder, cur_tab, cur_buf])
  let AppendTabs = function('airline#extensions#tabline#tabws#add_tab_section', [builder])
  let AppendLabel = function(builder.add_section_spaced, ['airline_tabtype'], builder)

  " <= 1: |{Tabs}                      <tab|
  " == 2: |{Buffers}               <buffers|
  " == 3: |buffers> {Buffers}  {Tabs} <tabs|
  let showing_mode = (2 * show_buffers) + (show_tabs)
  let ignore_update = 0

  " Add left tabline content
  if showing_mode <= 1 " Tabs only mode
    call AppendTabs(0)
  elseif showing_mode == 2 " Buffers only mode
    let ignore_update = !AppendBuffers(0)
  else
    if !switch_buffers_and_tabs
      call AppendLabel(buffer_label)
      let ignore_update = !AppendBuffers(0)
    else
      call AppendLabel(tab_label)
      call AppendTabs(0)
    endif
  endif

  if ignore_update | return s:current_tabline | endif

  call builder.add_section('airline_tabfill', '')
  call builder.split()
  call builder.add_section('airline_tabfill', '')

  " Add right tabline content
  if showing_mode <= 1 " Tabs only mode
    call AppendLabel(tab_label)
  elseif showing_mode == 2 " Buffers only mode
    call AppendLabel(buffer_label)
  else
    if !switch_buffers_and_tabs
      call AppendTabs(1)
      call AppendLabel(tab_label)
    else
      let ignore_update = AppendBuffers(1)
      call AppendLabel(buffer_label)
    endif
  endif

  if ignore_update | return s:current_tabline | endif

  let s:current_bufnr = cur_buf
  let s:current_tabnr = cur_tab
  let s:current_tabline = builder.build()
  return s:current_tabline
endfunction
./autoload/airline/extensions/tabline/xtabline.vim	[[[1
404
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" xTabline - Reduced version for vim-airline
" Plugin: https://github.com/mg979/vim-xtabline
" MIT License Copyright (C) 2018-2021 Gianmaria Bajo <mg1979.git@gmail.com>
" tabpagecd:
" expanded version by mg979
" MIT License Copyright (C) 2012-2013 Kana Natsuno <http://whileimautomaton.net/>
" MIT License Copyright (C) 2018-2021 Gianmaria Bajo <mg1979.git@gmail.com>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


function! airline#extensions#tabline#xtabline#init()

    let s:state = 0

    " initialize mappings
    call airline#extensions#tabline#xtabline#maps()

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Variables
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    let g:loaded_xtabline = 1
    let s:most_recent = -1
    let s:xtabline_filtering = 1

    let t:xtl_excluded = get(g:, 'airline#extensions#tabline#exclude_buffers', [])
    let t:xtl_accepted = []

    let g:xtabline_include_previews = get(g:, 'xtabline_include_previews', 1)

    let g:xtabline_alt_action = get(g:, 'xtabline_alt_action', "buffer #")


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Autocommands
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    augroup plugin-xtabline
        autocmd!

        autocmd TabNew    * call s:Do('new')
        autocmd TabEnter  * call s:Do('enter')
        autocmd TabLeave  * call s:Do('leave')
        autocmd TabClosed * call s:Do('close')

        autocmd BufEnter  * if exists('#airline') | let g:xtabline_changing_buffer = 0 | endif
        autocmd BufAdd,BufDelete,BufWrite * call airline#extensions#tabline#xtabline#filter_buffers()
    augroup END


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Commands
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    com! XTabReopen call airline#extensions#tabline#xtabline#reopen_last_tab()

endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#maps()

    if !exists('g:xtabline_disable_keybindings')

        fun! s:mapkeys(keys, plug)
            if empty(mapcheck(a:keys)) && !hasmapto(a:plug)
                silent! execute 'nmap <unique> '.a:keys.' '.a:plug
            endif
        endfun

        call s:mapkeys('<F5>','<Plug>XTablineToggleTabs')
        call s:mapkeys('<leader><F5>','<Plug>XTablineToggleFiltering')
        call s:mapkeys('<BS>','<Plug>XTablineSelectBuffer')
        call s:mapkeys(']l','<Plug>XTablineNextBuffer')
        call s:mapkeys('[l','<Plug>XTablinePrevBuffer')
        call s:mapkeys('<leader>tr','<Plug>XTablineReopen')
    endif

    nnoremap <unique> <script> <Plug>XTablineToggleTabs <SID>ToggleTabs
    nnoremap <silent> <SID>ToggleTabs :call airline#extensions#tabline#xtabline#toggle_tabs()<cr>

    nnoremap <unique> <script> <Plug>XTablineToggleFiltering <SID>ToggleFiltering
    nnoremap <silent> <SID>ToggleFiltering :call airline#extensions#tabline#xtabline#toggle_buffers()<cr>

    nnoremap <unique> <script> <Plug>XTablineSelectBuffer <SID>SelectBuffer
    nnoremap <silent> <expr> <SID>SelectBuffer g:xtabline_changing_buffer ? "\<C-c>" : ":<C-u>call airline#extensions#tabline#xtabline#select_buffer(v:count)\<cr>"

    nnoremap <unique> <script> <Plug>XTablineNextBuffer <SID>NextBuffer
    nnoremap <silent> <expr> <SID>NextBuffer airline#extensions#tabline#xtabline#next_buffer(v:count1)

    nnoremap <unique> <script> <Plug>XTablinePrevBuffer <SID>PrevBuffer
    nnoremap <silent> <expr> <SID>PrevBuffer airline#extensions#tabline#xtabline#prev_buffer(v:count1)

    nnoremap <unique> <script> <Plug>XTablineReopen <SID>ReopenLastTab
    nnoremap <silent> <SID>ReopenLastTab :XTabReopen<cr>

    if get(g:, 'xtabline_cd_commands', 0)
        map <unique> <leader>cdc <Plug>XTablineCdCurrent
        map <unique> <leader>cdd <Plug>XTablineCdDown1
        map <unique> <leader>cd2 <Plug>XTablineCdDown2
        map <unique> <leader>cd3 <Plug>XTablineCdDown3
        map <unique> <leader>cdh <Plug>XTablineCdHome
        nnoremap <unique> <script> <Plug>XTablineCdCurrent :cd %:p:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdDown1   :cd %:p:h:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdDown2   :cd %:p:h:h:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdDown3   :cd %:p:h:h:h:h<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
        nnoremap <unique> <script> <Plug>XTablineCdHome    :cd ~<cr>:call airline#util#doautocmd('BufAdd')<cr>:pwd<cr>
    endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#toggle_tabs()
    """Toggle between tabs/buffers tabline."""

    if tabpagenr("$") == 1 | call airline#util#warning("There is only one tab.") | return | endif

    if g:airline#extensions#tabline#show_tabs
        let g:airline#extensions#tabline#show_tabs = 0
        call airline#util#warning("Showing buffers")
    else
        let g:airline#extensions#tabline#show_tabs = 1
        call airline#util#warning("Showing tabs")
    endif

    doautocmd BufAdd
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#toggle_buffers()
    """Toggle buffer filtering in the tabline."""

    if s:xtabline_filtering
        let s:xtabline_filtering = 0
        let g:airline#extensions#tabline#exclude_buffers = []
        call airline#util#warning("Buffer filtering turned off")
        doautocmd BufAdd
    else
        let s:xtabline_filtering = 1
        call airline#extensions#tabline#xtabline#filter_buffers()
        call airline#util#warning("Buffer filtering turned on")
        doautocmd BufAdd
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#reopen_last_tab()
    """Reopen the last closed tab."""

    if !exists('s:most_recently_closed_tab')
        call airline#util#warning("No recent tabs.")
        return
    endif

    let tab = s:most_recently_closed_tab
    tabnew
    let empty = bufnr("%")
    let t:cwd = tab['cwd']
    cd `=t:cwd`
    let t:name = tab['name']
    for buf in tab['buffers'] | execute "badd ".buf | endfor
    execute "edit ".tab['buffers'][0]
    execute "bdelete ".empty
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#filter_buffers()
    """Filter buffers so that only the ones within the tab's cwd will show up.

    " 'accepted' is a list of buffer numbers, for quick access.
    " 'excluded' is a list of buffer numbers, it will be used by Airline to hide buffers.

    if !exists('#airline')
      " airline disabled
      return
    endif
    if !s:xtabline_filtering | return | endif

    let g:airline#extensions#tabline#exclude_buffers = []
    let t:xtl_excluded = g:airline#extensions#tabline#exclude_buffers
    let t:xtl_accepted = [] | let accepted = t:xtl_accepted
    let previews = g:xtabline_include_previews

    " bufnr(0) is the alternate buffer
    for buf in range(1, bufnr("$"))

        if !buflisted(buf) | continue | endif

        " get the path
        let path = expand("#".buf.":p")

        " confront with the cwd
        if !previews && path =~ "^".getcwd()
            call add(accepted, buf)
        elseif previews && path =~ getcwd()
            call add(accepted, buf)
        else
            call add(t:xtl_excluded, buf)
        endif
    endfor

    call s:RefreshTabline()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#next_buffer(nr)
    """Switch to next visible buffer."""

    if ( s:NotEnoughBuffers() || !s:xtabline_filtering ) | return | endif
    let accepted = t:xtl_accepted

    let ix = index(accepted, bufnr("%"))
    let target = ix + a:nr
    let total = len(accepted)

    if ix == -1
        " not in index, go back to most recent or back to first
        if s:most_recent == -1 || s:most_recent >= total
            let s:most_recent = 0
        endif

    elseif target >= total
        " over last buffer
        while target >= total | let target -= total | endwhile
        let s:most_recent = target

    else
        let s:most_recent = target
    endif

    return ":buffer " . accepted[s:most_recent] . "\<cr>"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#prev_buffer(nr)
    """Switch to previous visible buffer."""

    if ( s:NotEnoughBuffers() || !s:xtabline_filtering ) | return | endif
    let accepted = t:xtl_accepted

    let ix = index(accepted, bufnr("%"))
    let target = ix - a:nr
    let total = len(accepted)

    if ix == -1
        " not in index, go back to most recent or back to first
        if s:most_recent == -1 || s:most_recent >= total
            let s:most_recent = 0
        endif

    elseif target < 0
        " before first buffer
        while target < 0 | let target += total | endwhile
        let s:most_recent = target

    else
        let s:most_recent = target
    endif

    return ":buffer " . accepted[s:most_recent] . "\<cr>"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#select_buffer(nr)
    """Switch to visible buffer in the tabline with [count]."""

    if ( a:nr == 0 || !s:xtabline_filtering ) | execute g:xtabline_alt_action | return | endif
    let accepted = t:xtl_accepted

    if (a:nr > len(accepted)) || s:NotEnoughBuffers() || accepted[a:nr - 1] == bufnr("%")
        return
    else
        let g:xtabline_changing_buffer = 1
        execute "buffer ".accepted[a:nr - 1]
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:TabBuffers()
    """Return a list of buffers names for this tab."""

    return map(copy(t:xtl_accepted), 'bufname(v:val)')
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:NotEnoughBuffers()
    """Just return if there aren't enough buffers."""

    if len(t:xtl_accepted) < 2
        if index(t:xtl_accepted, bufnr("%")) == -1
            return
        elseif !len(t:xtl_accepted)
            call airline#util#warning("No available buffers for this tab.")
        else
            call airline#util#warning("No other available buffers for this tab.")
        endif
        return 1
    endif
endfunction

function! s:RefreshTabline()
    call airline#extensions#tabline#buflist#invalidate()
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TabPageCd
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tabpagecd - Turn :cd into :tabpagecd, to use one tab page per project
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:InitCwds()
    if !exists('g:xtab_cwds') | let g:xtab_cwds = [] | endif

    while len(g:xtab_cwds) < tabpagenr("$")
        call add(g:xtab_cwds, getcwd())
    endwhile
    let s:state    = 1
    let t:cwd      = getcwd()
    let s:last_tab = 0
    call airline#extensions#tabline#xtabline#filter_buffers()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! airline#extensions#tabline#xtabline#update_obsession()
    let string = 'let g:xtab_cwds = '.string(g:xtab_cwds).' | call airline#extensions#tabline#xtabline#update_obsession()'
    if !exists('g:obsession_append')
        let g:obsession_append = [string]
    else
        call filter(g:obsession_append, 'v:val !~# "^let g:xtab_cwds"')
        call add(g:obsession_append, string)
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:Do(action)
    if !exists('#airline')
      " airline disabled
      return
    endif
    let arg = a:action
    if !s:state | call s:InitCwds() | return | endif

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    if arg == 'new'

        call insert(g:xtab_cwds, getcwd(), tabpagenr()-1)

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    elseif arg == 'enter'

        let t:cwd =g:xtab_cwds[tabpagenr()-1]

        cd `=t:cwd`
        call airline#extensions#tabline#xtabline#filter_buffers()

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    elseif arg == 'leave'

        let t:cwd = getcwd()
        let g:xtab_cwds[tabpagenr()-1] = t:cwd
        let s:last_tab = tabpagenr() - 1

        if !exists('t:name') | let t:name = t:cwd | endif
        let s:most_recent_tab = {'cwd': t:cwd, 'name': t:name, 'buffers': s:TabBuffers()}

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    elseif arg == 'close'

        let s:most_recently_closed_tab = copy(s:most_recent_tab)
        call remove(g:xtab_cwds, s:last_tab)
    endif

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    call airline#extensions#tabline#xtabline#update_obsession()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
./autoload/airline/extensions/tabline.vim	[[[1
483
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

let s:taboo = get(g:, 'airline#extensions#taboo#enabled', 1) && get(g:, 'loaded_taboo', 0)
if s:taboo
  let g:taboo_tabline = 0
endif

let s:ctrlspace = get(g:, 'CtrlSpaceLoaded', 0)
let s:tabws = get(g:, 'tabws_loaded', 0)
let s:current_tabcnt = -1

" Dictionary functions are not possible in Vim9 Script,
" so use the legacy Vim Script implementation

function! airline#extensions#tabline#init(ext)
  if has('gui_running') && match(&guioptions, 'e') > -1
    set guioptions-=e
  endif

  autocmd User AirlineToggledOn call s:toggle_on()
  autocmd User AirlineToggledOff call s:toggle_off()

  call s:toggle_on()
  call a:ext.add_theme_func('airline#extensions#tabline#load_theme')
endfunction

function! airline#extensions#tabline#add_label(dict, type, right)
  if get(g:, 'airline#extensions#tabline#show_tab_type', 1)
    call a:dict.add_section_spaced('airline_tablabel'. (a:right ? '_right' : ''),
          \ get(g:, 'airline#extensions#tabline#'.a:type.'_label', a:type))
  endif
endfunction

function! airline#extensions#tabline#add_tab_label(dict)
  let show_tab_count = get(g:, 'airline#extensions#tabline#show_tab_count', 1)
  if show_tab_count == 2
    call a:dict.add_section_spaced('airline_tabmod', printf('%s %d/%d', "tab", tabpagenr(), tabpagenr('$')))
  elseif show_tab_count == 1 && tabpagenr('$') > 1
    call a:dict.add_section_spaced('airline_tabmod', printf('%s %d/%d', "tab", tabpagenr(), tabpagenr('$')))
  endif
endfunction


if !exists(":def") || !airline#util#has_vim9_script()

  " Legacy Vim Script Implementation

  function! s:toggle_off()
    call airline#extensions#tabline#autoshow#off()
    call airline#extensions#tabline#tabs#off()
    call airline#extensions#tabline#buffers#off()
    if s:ctrlspace
      call airline#extensions#tabline#ctrlspace#off()
    endif
    if s:tabws
      call airline#extensions#tabline#tabws#off()
    endif
  endfunction

  function! s:toggle_on()
    if get(g:, 'airline_statusline_ontop', 0)
      call airline#extensions#tabline#enable()
      let &tabline='%!airline#statusline('.winnr().')'
      return
    endif
    call airline#extensions#tabline#autoshow#on()
    call airline#extensions#tabline#tabs#on()
    call airline#extensions#tabline#buffers#on()
    if s:ctrlspace
      call airline#extensions#tabline#ctrlspace#on()
    endif
    if s:tabws
      call airline#extensions#tabline#tabws#on()
    endif

    set tabline=%!airline#extensions#tabline#get()
  endfunction

  function! airline#extensions#tabline#load_theme(palette)
    if pumvisible()
      return
    endif
    let colors    = get(a:palette, 'tabline', {})
    let tablabel  = get(colors, 'airline_tablabel', a:palette.normal.airline_b)
    " Theme for tabs on the left
    let tab     = get(colors, 'airline_tab', a:palette.inactive.airline_c)
    let tabsel  = get(colors, 'airline_tabsel', a:palette.normal.airline_a)
    let tabtype = get(colors, 'airline_tabtype', a:palette.visual.airline_a)
    let tabfill = get(colors, 'airline_tabfill', a:palette.normal.airline_c)
    let tabmod  = get(colors, 'airline_tabmod', a:palette.insert.airline_a)
    let tabhid  = get(colors, 'airline_tabhid', a:palette.normal.airline_c)
    if has_key(a:palette, 'normal_modified') && has_key(a:palette.normal_modified, 'airline_c')
      let tabmodu = get(colors, 'airline_tabmod_unsel', a:palette.normal_modified.airline_c)
      let tabmodu_right = get(colors, 'airline_tabmod_unsel_right', a:palette.normal_modified.airline_c)
    else
      "Fall back to normal airline_c if modified airline_c isn't present
      let tabmodu = get(colors, 'airline_tabmod_unsel', a:palette.normal.airline_c)
      let tabmodu_right = get(colors, 'airline_tabmod_unsel_right', a:palette.normal.airline_c)
    endif
    call airline#highlighter#exec('airline_tablabel', tablabel)
    call airline#highlighter#exec('airline_tab', tab)
    call airline#highlighter#exec('airline_tabsel', tabsel)
    call airline#highlighter#exec('airline_tabtype', tabtype)
    call airline#highlighter#exec('airline_tabfill', tabfill)
    call airline#highlighter#exec('airline_tabmod', tabmod)
    call airline#highlighter#exec('airline_tabmod_unsel', tabmodu)
    call airline#highlighter#exec('airline_tabhid', tabhid)

    " Theme for tabs on the right
    " label on the right
    let tablabel_r  = get(colors, 'airline_tablabel', a:palette.normal.airline_b)
    let tabsel_right  = get(colors, 'airline_tabsel_right', a:palette.normal.airline_a)
    let tab_right     = get(colors, 'airline_tab_right',    a:palette.inactive.airline_c)
    let tabmod_right  = get(colors, 'airline_tabmod_right', a:palette.insert.airline_a)
    let tabhid_right  = get(colors, 'airline_tabhid_right', a:palette.normal.airline_c)
    call airline#highlighter#exec('airline_tablabel_right', tablabel_r)
    call airline#highlighter#exec('airline_tab_right',    tab_right)
    call airline#highlighter#exec('airline_tabsel_right', tabsel_right)
    call airline#highlighter#exec('airline_tabmod_right', tabmod_right)
    call airline#highlighter#exec('airline_tabhid_right', tabhid_right)
    call airline#highlighter#exec('airline_tabmod_unsel_right', tabmodu_right)
  endfunction

  function! s:update_tabline(forceit)
    if get(g:, 'airline#extensions#tabline#disable_refresh', 0)
      return
    endif
    " loading a session file
    " On SessionLoadPost, g:SessionLoad variable is still set :/
    if !a:forceit && get(g:, 'SessionLoad', 0)
      return
    endif
    let match = expand('<afile>')
    if pumvisible()
      return
    elseif !get(g:, 'airline#extensions#tabline#enabled', 0)
      return
    " return, if buffer matches ignore pattern or is directory (netrw)
    elseif empty(match) || airline#util#ignore_buf(match) || isdirectory(match)
      return
    endif
    call airline#util#doautocmd('BufMRUChange')
    call airline#extensions#tabline#redraw()
  endfunction

  function! airline#extensions#tabline#redraw()
    " sometimes, the tabline is not correctly updated see #1580
    " so force redraw here
    if exists(":redrawtabline") == 2
      redrawtabline
    else
    " Have to set a property equal to itself to get airline to re-eval.
    " Setting `let &tabline=&tabline` destroys the cursor position so we
    " need something less invasive.
      let &ro = &ro
    endif
  endfunction

  function! airline#extensions#tabline#enable()
    if &lines > 3
      set showtabline=2
    endif
  endfunction


  function! airline#extensions#tabline#get()
    let show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
    let show_tabs = get(g:, 'airline#extensions#tabline#show_tabs', 1)

    let curtabcnt = tabpagenr('$')
    if curtabcnt != s:current_tabcnt
      let s:current_tabcnt = curtabcnt
      call airline#extensions#tabline#tabs#invalidate()
      call airline#extensions#tabline#buffers#invalidate()
      call airline#extensions#tabline#ctrlspace#invalidate()
      call airline#extensions#tabline#tabws#invalidate()
    endif

    if !exists('#airline#BufAdd#*')
      autocmd airline BufAdd * call <sid>update_tabline(0)
    endif
    if !exists('#airline#SessionLoadPost')
      autocmd airline SessionLoadPost * call <sid>update_tabline(1)
    endif
    if s:ctrlspace
      return airline#extensions#tabline#ctrlspace#get()
    elseif s:tabws
      return airline#extensions#tabline#tabws#get()
    elseif show_buffers && curtabcnt == 1 || !show_tabs
      return airline#extensions#tabline#buffers#get()
    else
      return airline#extensions#tabline#tabs#get()
    endif
  endfunction

  function! airline#extensions#tabline#title(n)
    let title = ''
    if s:taboo
      let title = TabooTabTitle(a:n)
    endif

    if empty(title) && exists('*gettabvar')
      let title = gettabvar(a:n, 'title')
    endif

    let formatter = get(g:, 'airline#extensions#tabline#tabtitle_formatter')
    if empty(title) && formatter !=# '' && exists("*".formatter)
      let title = call(formatter, [a:n])
    endif

    if empty(title)
      let buflist = tabpagebuflist(a:n)
      let winnr = tabpagewinnr(a:n)
      let all_buffers = airline#extensions#tabline#buflist#list()
      let curbuf = filter(buflist, 'index(all_buffers, v:val) != -1')
      if len(curbuf) ==  0
        call add(curbuf, tabpagebuflist(a:n)[0])
      endif
      " a:n: -> buffer number
      " curbuf: list of buffers in current tabpage
      " we need the buffername in current tab page.
      return airline#extensions#tabline#get_buffer_name(curbuf[0], curbuf)
    endif

    return title
  endfunction

  function! airline#extensions#tabline#get_buffer_name(nr, ...)
    let buffers = a:0 ? a:1 : airline#extensions#tabline#buflist#list()
    let formatter = get(g:, 'airline#extensions#tabline#formatter', 'default')
    return airline#extensions#tabline#formatters#{formatter}#format(a:nr, buffers)
  endfunction

  function! airline#extensions#tabline#new_builder()
    let builder_context = {
          \ 'active'        : 1,
          \ 'tabline'       : 1,
          \ 'right_sep'     : get(g:, 'airline#extensions#tabline#right_sep'    , g:airline_right_sep),
          \ 'right_alt_sep' : get(g:, 'airline#extensions#tabline#right_alt_sep', g:airline_right_alt_sep),
          \ }
    if get(g:, 'airline_powerline_fonts', 0)
      let builder_context.left_sep     = get(g:, 'airline#extensions#tabline#left_sep'     , g:airline_left_sep)
      let builder_context.left_alt_sep = get(g:, 'airline#extensions#tabline#left_alt_sep' , g:airline_left_alt_sep)
    else
      let builder_context.left_sep     = get(g:, 'airline#extensions#tabline#left_sep'     , ' ')
      let builder_context.left_alt_sep = get(g:, 'airline#extensions#tabline#left_alt_sep' , '|')
    endif

    return airline#extensions#tabline#builder#new(builder_context)
  endfunction

  function! airline#extensions#tabline#group_of_bufnr(tab_bufs, bufnr)
    let cur = bufnr('%')
    if cur == a:bufnr
      if g:airline_detect_modified && getbufvar(a:bufnr, '&modified')
        let group = 'airline_tabmod'
      else
        let group = 'airline_tabsel'
      endif
    else
      if g:airline_detect_modified && getbufvar(a:bufnr, '&modified')
        let group = 'airline_tabmod_unsel'
      elseif index(a:tab_bufs, a:bufnr) > -1
        let group = 'airline_tab'
      else
        let group = 'airline_tabhid'
      endif
    endif
    return group
  endfunction
  finish
else
  def s:toggle_off(): void
    airline#extensions#tabline#autoshow#off()
    airline#extensions#tabline#tabs#off()
    airline#extensions#tabline#buffers#off()
    if s:ctrlspace
      airline#extensions#tabline#ctrlspace#off()
    endif
    if s:tabws
      airline#extensions#tabline#tabws#off()
    endif
  enddef

  def s:toggle_on(): void
    if get(g:, 'airline_statusline_ontop', 0)
      airline#extensions#tabline#enable()
      &tabline = '%!airline#statusline(' .. winnr() .. ')'
      return
    endif
    airline#extensions#tabline#autoshow#on()
    airline#extensions#tabline#tabs#on()
    airline#extensions#tabline#buffers#on()
    if s:ctrlspace
      airline#extensions#tabline#ctrlspace#on()
    endif
    if s:tabws
      airline#extensions#tabline#tabws#on()
    endif
    &tabline = '%!airline#extensions#tabline#get()'
  enddef

  def airline#extensions#tabline#load_theme(palette: dict<any>): number
    # Needs to return a number, because it is implicitly used as extern_funcref
    # And funcrefs should return a value (see airline#util#exec_funcrefs())
    if pumvisible()
      return 0
    endif
    var colors    = get(palette, 'tabline', {})
    var tablabel  = get(colors, 'airline_tablabel', palette.normal.airline_b)
    # Theme for tabs on the left
    var tab     = get(colors, 'airline_tab', palette.inactive.airline_c)
    var tabsel  = get(colors, 'airline_tabsel', palette.normal.airline_a)
    var tabtype = get(colors, 'airline_tabtype', palette.visual.airline_a)
    var tabfill = get(colors, 'airline_tabfill', palette.normal.airline_c)
    var tabmod  = get(colors, 'airline_tabmod', palette.insert.airline_a)
    var tabhid  = get(colors, 'airline_tabhid', palette.normal.airline_c)
    var tabmodu = tabhid
    var tabmodu_right = tabhid
    if has_key(palette, 'normal_modified') && has_key(palette.normal_modified, 'airline_c')
      tabmodu = get(colors, 'airline_tabmod_unsel', palette.normal_modified.airline_c)
      tabmodu_right = get(colors, 'airline_tabmod_unsel_right', palette.normal_modified.airline_c)
    else
      # Fall back to normal airline_c if modified airline_c isn't present
      tabmodu = get(colors, 'airline_tabmod_unsel', palette.normal.airline_c)
      tabmodu_right = get(colors, 'airline_tabmod_unsel_right', palette.normal.airline_c)
    endif
    airline#highlighter#exec('airline_tablabel', tablabel)
    airline#highlighter#exec('airline_tab', tab)
    airline#highlighter#exec('airline_tabsel', tabsel)
    airline#highlighter#exec('airline_tabtype', tabtype)
    airline#highlighter#exec('airline_tabfill', tabfill)
    airline#highlighter#exec('airline_tabmod', tabmod)
    airline#highlighter#exec('airline_tabmod_unsel', tabmodu)
    airline#highlighter#exec('airline_tabmod_unsel_right', tabmodu_right)
    airline#highlighter#exec('airline_tabhid', tabhid)
    # Theme for tabs on the right
    var tablabel_r  = get(colors, 'airline_tablabel', palette.normal.airline_b)
    var tabsel_right  = get(colors, 'airline_tabsel_right', palette.normal.airline_a)
    var tab_right     = get(colors, 'airline_tab_right',    palette.inactive.airline_c)
    var tabmod_right  = get(colors, 'airline_tabmod_right', palette.insert.airline_a)
    var tabhid_right  = get(colors, 'airline_tabhid_right', palette.normal.airline_c)
    airline#highlighter#exec('airline_tablabel_right', tablabel_r)
    airline#highlighter#exec('airline_tab_right',    tab_right)
    airline#highlighter#exec('airline_tabsel_right', tabsel_right)
    airline#highlighter#exec('airline_tabmod_right', tabmod_right)
    airline#highlighter#exec('airline_tabhid_right', tabhid_right)
    return 0
  enddef

  def s:update_tabline(forceit: number): void
    if get(g:, 'airline#extensions#tabline#disable_refresh', 0)
      return
    endif
    # loading a session file
    # On SessionLoadPost, g:SessionLoad variable is still set :/
    if !forceit && get(g:, 'SessionLoad', 0)
      return
    endif
    var match = expand('<afile>')
    if pumvisible()
      return
    elseif !get(g:, 'airline#extensions#tabline#enabled', 0)
      return
    # return, if buffer matches ignore pattern or is directory (netrw)
    elseif empty(match) || airline#util#ignore_buf(match) || isdirectory(match)
      return
    endif
    airline#util#doautocmd('BufMRUChange')
    airline#extensions#tabline#redraw()
  enddef

  def airline#extensions#tabline#redraw(): void
    # redrawtabline should always be available
    :redrawtabline
  enddef

  def airline#extensions#tabline#enable(): void
    if &lines > 3
      &showtabline = 2
    endif
  enddef

  def airline#extensions#tabline#get(): string
    var show_buffers = get(g:, 'airline#extensions#tabline#show_buffers', 1)
    var show_tabs = get(g:, 'airline#extensions#tabline#show_tabs', 1)

    var curtabcnt = tabpagenr('$')
    if curtabcnt != s:current_tabcnt
      s:current_tabcnt = curtabcnt
      airline#extensions#tabline#tabs#invalidate()
      airline#extensions#tabline#buffers#invalidate()
      airline#extensions#tabline#ctrlspace#invalidate()
      airline#extensions#tabline#tabws#invalidate()
    endif

    if !exists('#airline#BufAdd#*')
      autocmd airline BufAdd * call <sid>update_tabline(0)
    endif
    if !exists('#airline#SessionLoadPost')
      autocmd airline SessionLoadPost * call <sid>update_tabline(1)
    endif
    if s:ctrlspace
      return airline#extensions#tabline#ctrlspace#get()
    elseif s:tabws
      return airline#extensions#tabline#tabws#get()
    elseif show_buffers && curtabcnt == 1 || !show_tabs
      return airline#extensions#tabline#buffers#get()
    else
      return airline#extensions#tabline#tabs#get()
    endif
  enddef

  def airline#extensions#tabline#title(n: number): string
    var title = ''
    if get(g:, 'airline#extensions#taboo#enabled', 1) &&
      get(g:, 'loaded_taboo', 0) && exists("*TabooTabTitle")
      title = call("TabooTabTitle", [n])
    endif

    if empty(title)
      title = gettabvar(n, 'title')
    endif

    var formatter = get(g:, 'airline#extensions#tabline#tabtitle_formatter', '')
    if empty(title) && !empty(formatter) && exists("*" .. formatter)
      title = call(formatter, [n])
    endif

    if empty(title)
      var buflist = tabpagebuflist(n)
      var winnr = tabpagewinnr(n)
      var all_buffers = airline#extensions#tabline#buflist#list()
      var curbuf = filter(buflist, (_, v) => index(all_buffers, v) != -1)
      if len(curbuf) ==  0
        add(curbuf, tabpagebuflist(n)[0])
      endif
      return airline#extensions#tabline#get_buffer_name(curbuf[0], curbuf)
    endif
    return title
  enddef

  def airline#extensions#tabline#get_buffer_name(nr: number, buffers = airline#extensions#tabline#buflist#list()): string
    var Formatter = 'airline#extensions#tabline#formatters#' .. get(g:, 'airline#extensions#tabline#formatter', 'default') .. '#format'
    return call(Formatter, [ nr, buffers] )
  enddef

  def airline#extensions#tabline#new_builder(): dict<any>
    var builder_context = {
        'active': 1,
        'tabline': 1,
        'right_sep': get(g:, 'airline#extensions#tabline#right_sep', g:airline_right_sep),
        'right_alt_sep': get(g:, 'airline#extensions#tabline#right_alt_sep', g:airline_right_alt_sep),
        'left_sep': get(g:, 'airline#extensions#tabline#left_sep', g:airline_left_sep),
        'left_alt_sep': get(g:, 'airline#extensions#tabline#left_alt_sep', g:airline_left_alt_sep),
        }
    return airline#extensions#tabline#builder#new(builder_context)
  enddef

  def airline#extensions#tabline#group_of_bufnr(tab_bufs: list<number>, bufnr: number): string
    var cur = bufnr('%')
    var group = ''
    if cur == bufnr
      if g:airline_detect_modified && getbufvar(bufnr, '&modified')
        group = 'airline_tabmod'
      else
        group = 'airline_tabsel'
      endif
    else
      if g:airline_detect_modified && getbufvar(bufnr, '&modified')
        group = 'airline_tabmod_unsel'
      elseif index(tab_bufs, bufnr) > -1
        group = 'airline_tab'
      else
        group = 'airline_tabhid'
      endif
    endif
    return group
  enddef
endif
./autoload/airline/extensions/tagbar.vim	[[[1
64
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/majutsushi/tagbar
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':TagbarToggle')
  finish
endif

let s:spc = g:airline_symbols.space
let s:init=0

" Arguments: current, sort, fname
function! airline#extensions#tagbar#get_status(...)
  let builder = airline#builder#new({ 'active': a:1 })
  call builder.add_section('airline_a', s:spc.'Tagbar'.s:spc)
  call builder.add_section('airline_b', s:spc.a:2.s:spc)
  call builder.add_section('airline_c', s:spc.a:3.s:spc)
  return builder.build()
endfunction

function! airline#extensions#tagbar#inactive_apply(...)
  if getwinvar(a:2.winnr, '&filetype') == 'tagbar'
    return -1
  endif
endfunction

let s:airline_tagbar_last_lookup_time = 0
let s:airline_tagbar_last_lookup_val = ''
function! airline#extensions#tagbar#currenttag()
  if get(w:, 'airline_active', 0)
    if !s:init
      try
        " try to load the plugin, if filetypes are disabled,
        " this will cause an error, so try only once
        let a = tagbar#currenttag('%s', '', '')
      catch
      endtry
      unlet! a
      let s:init=1
    endif
    let cursize = getfsize(fnamemodify(bufname('%'), ':p'))
    if cursize > 0 && cursize > get(g:, 'airline#extensions#tagbar#max_filesize', 1024 * 1024)
      return ''
    endif
    let flags = get(g:, 'airline#extensions#tagbar#flags', '')
    " function tagbar#currenttag does not exist, if filetype is not enabled
    if s:airline_tagbar_last_lookup_time != localtime() && exists("*tagbar#currenttag")
      let s:airline_tagbar_last_lookup_val = tagbar#currenttag('%s', '', flags,
            \ get(g:, 'airline#extensions#tagbar#searchmethod', 'nearest-stl'))
      let s:airline_tagbar_last_lookup_time = localtime()
    endif
    return s:airline_tagbar_last_lookup_val
  endif
  return ''
endfunction

function! airline#extensions#tagbar#init(ext)
  call a:ext.add_inactive_statusline_func('airline#extensions#tagbar#inactive_apply')
  let g:tagbar_status_func = 'airline#extensions#tagbar#get_status'

  call airline#parts#define_function('tagbar', 'airline#extensions#tagbar#currenttag')
endfunction
./autoload/airline/extensions/taglist.vim	[[[1
37
" MIT License. Copyright (c) 2021       DEMAREST Maxime (maxime@indelog.fr)
" Plugin: https://github.com/yegappan/taglist/
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':TlistShowTag')
  finish
endif

function! airline#extensions#taglist#currenttag()
  " Update tag list if taglist is not loaded (else we get an empty tag name)
  " Load yegappan/taglist and vim-scripts/taglist.vim only once.
  let tlist_updated = 0
  if !exists('*taglist#Tlist_Get_Tagname_By_Line()') && !exists('*Tlist_Get_Tagname_By_Line()')
      TlistUpdate
      let tlist_updated = 1
  endif
  if  !tlist_updated && exists('*Tlist_Get_Filenames()')
      let tlist_filenames = Tlist_Get_Filenames()
      if stridx(type(tlist_filenames) == type([]) ? join(tlist_filenames, '\n') : tlist_filenames, expand('%:p')) < 0
          TlistUpdate
      endif
  endif
  " Is this function is not present it'means you use the old vertsion of
  " tag list : https://github.com/vim-scripts/taglist.vim.
  " Please use the new version : https://github.com/yegappan/taglist.
  if exists('*taglist#Tlist_Get_Tagname_By_Line()')
      return taglist#Tlist_Get_Tagname_By_Line()
  else
      return ''
  endif
endfunction

function! airline#extensions#taglist#init(ext)
  call airline#parts#define_function('taglist', 'airline#extensions#taglist#currenttag')
endfunction
./autoload/airline/extensions/term.vim	[[[1
80
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#parts#define_function('tmode', 'airline#extensions#term#termmode')
call airline#parts#define('terminal', {'text': get(g:airline_mode_map, 't', 't'), 'accent': 'bold'})

let s:spc = g:airline_symbols.space

let s:section_a = airline#section#create_left(['terminal', 'tmode'])
let s:section_z = airline#section#create(['linenr', 'maxlinenr'])

function! airline#extensions#term#apply(...) abort
  if &buftype ==? 'terminal' || bufname(a:2.bufnr)[0] ==? '!'
    call a:1.add_section_spaced('airline_a', s:section_a)
    call a:1.add_section_spaced('airline_b', s:neoterm_id(a:2.bufnr))
    call a:1.add_section('airline_term', s:spc.s:termname(a:2.bufnr))
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section_spaced('airline_z', s:section_z)
    return 1
  endif
endfunction

function! airline#extensions#term#inactive_apply(...) abort
  if getbufvar(a:2.bufnr, '&buftype') ==? 'terminal'
    call a:1.add_section_spaced('airline_a', s:section_a)
    call a:1.add_section_spaced('airline_b', s:neoterm_id(a:2.bufnr))
    call a:1.add_section('airline_term', s:spc.s:termname(a:2.bufnr))
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section_spaced('airline_z', s:section_z)
    return 1
  endif
endfunction

function! airline#extensions#term#termmode() abort
  let mode = airline#parts#mode()[0]
  if mode ==? 'T' || mode ==? '-'
    " We don't need to output T, the statusline already says "TERMINAL".
    " Also we don't want to output "-" on an inactive statusline.
    let mode = ''
  endif
  return mode
endfunction

function! s:termname(bufnr) abort
  let bufname = bufname(a:bufnr)
  if has('nvim')
    " Get rid of the leading "term", working dir and process ID.
    " Afterwards, remove the possibly added neoterm ID.
    return substitute(matchstr(bufname, 'term.*:\zs.*'),
                    \ ';#neoterm-\d\+', '', '')
  else
    if bufname =~? 'neoterm-\d\+'
      " Do not return a redundant buffer name, when this is a neoterm terminal.
      return ''
    endif
    " Get rid of the leading "!".
    if bufname[0] ==? '!'
      return bufname[1:]
    else
      return bufname
    endif
  endif
endfunction

function! s:neoterm_id(bufnr) abort
  let id = getbufvar(a:bufnr, 'neoterm_id')
  if id !=? ''
    let id = 'neoterm-'.id
  endif
  return id
endfunction

function! airline#extensions#term#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#term#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#term#inactive_apply')
endfunction
./autoload/airline/extensions/tmuxline.vim	[[[1
28
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/edkolev/tmuxline.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':Tmuxline')
  finish
endif

let s:tmuxline_snapshot_file = get(g:, 'airline#extensions#tmuxline#snapshot_file', '')
let s:color_template = get(g:, 'airline#extensions#tmuxline#color_template', 'normal')

function! airline#extensions#tmuxline#init(ext)
  call a:ext.add_theme_func('airline#extensions#tmuxline#set_tmux_colors')
endfunction

function! airline#extensions#tmuxline#set_tmux_colors(palette)
  let color_template = has_key(a:palette, s:color_template) ? s:color_template : 'normal'
  let mode_palette = a:palette[color_template]

  let tmuxline_theme = tmuxline#api#create_theme_from_airline(mode_palette)
  call tmuxline#api#set_theme(tmuxline_theme)

  if strlen(s:tmuxline_snapshot_file)
    call tmuxline#api#snapshot(s:tmuxline_snapshot_file)
  endif
endfunction
./autoload/airline/extensions/undotree.vim	[[[1
29
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/mbbill/undotree
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':UndotreeToggle')
  finish
endif

function! airline#extensions#undotree#apply(...)
  if exists('t:undotree')
    if &ft == 'undotree'
      if exists('*t:undotree.GetStatusLine')
        call airline#extensions#apply_left_override('undo', '%{exists("t:undotree") ? t:undotree.GetStatusLine() : ""}')
      else
        call airline#extensions#apply_left_override('undotree', '%f')
      endif
    endif

    if &ft == 'diff' && exists('*t:diffpanel.GetStatusLine')
      call airline#extensions#apply_left_override('diff', '%{exists("t:diffpanel") ? t:diffpanel.GetStatusLine() : ""}')
    endif
  endif
endfunction

function! airline#extensions#undotree#init(ext)
  call a:ext.add_statusline_func('airline#extensions#undotree#apply')
endfunction
./autoload/airline/extensions/unicode.vim	[[[1
25
" MIT License. Copyright (c) 2013-2021 Bailey Ling, Christian Brabandt et al.
" Plugin: https://github.com/chrisbra/unicode.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_unicodePlugin', 0)
  finish
endif

function! airline#extensions#unicode#apply(...)
  if exists(':UnicodeTable') == 2 && bufname('') =~# '/UnicodeTable.txt'
    call airline#parts#define('unicode', {
          \ 'text': '[UnicodeTable]',
          \ 'accent': 'bold' })
    let w:airline_section_a = airline#section#create(['unicode'])
    let w:airline_section_b = ''
    let w:airline_section_c = ' '
    let w:airline_section_y = ''
  endif
endfunction

function! airline#extensions#unicode#init(ext)
  call a:ext.add_statusline_func('airline#extensions#unicode#apply')
endfunction
./autoload/airline/extensions/unite.vim	[[[1
25
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/Shougo/unite.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_unite', 0)
  finish
endif

function! airline#extensions#unite#apply(...)
  if &ft == 'unite'
    call a:1.add_section('airline_a', ' Unite ')
    call a:1.add_section('airline_b', ' %{get(unite#get_context(), "buffer_name", "")} ')
    call a:1.add_section('airline_c', ' %{unite#get_status_string()} ')
    call a:1.split()
    call a:1.add_section('airline_y', ' %{get(unite#get_context(), "real_buffer_name", "")} ')
    return 1
  endif
endfunction

function! airline#extensions#unite#init(ext)
  let g:unite_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#unite#apply')
endfunction
./autoload/airline/extensions/vim9lsp.vim	[[[1
27
" MIT License. Copyright (c) 2021       DEMAREST Maxime (maxime@indelog.fr)
" Plugin: https://github.com/yegappan/lsp
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*lsp#lsp#ErrorCount')
    finish
endif

let s:error_symbol = get(g:, 'airline#extensions#vim9lsp#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#vim9lsp#warning_symbol', 'W:')

function! airline#extensions#vim9lsp#get_warnings() abort
    let res = get(lsp#lsp#ErrorCount(), 'Warn', 0)
    return res > 0 ? s:warning_symbol . res : ''
endfunction

function! airline#extensions#vim9lsp#get_errors() abort
    let res = get(lsp#lsp#ErrorCount(), 'Error', 0)
    return res > 0 ? s:error_symbol . res : ''
endfunction

function! airline#extensions#vim9lsp#init(ext) abort
  call airline#parts#define_function('vim9lsp_warning_count', 'airline#extensions#vim9lsp#get_warnings')
  call airline#parts#define_function('vim9lsp_error_count', 'airline#extensions#vim9lsp#get_errors')
endfunction
./autoload/airline/extensions/vimagit.vim	[[[1
30
" MIT License. Copyright (c) 2016-2021 Jerome Reybert et al.
" Plugin: https://github.com/jreybert/vimagit
" vim: et ts=2 sts=2 sw=2

" This plugin replaces the whole section_a when in vimagit buffer
scriptencoding utf-8

if !get(g:, 'loaded_magit', 0)
  finish
endif

let s:commit_mode = {'ST': 'STAGING', 'CC': 'COMMIT', 'CA': 'AMEND'}

function! airline#extensions#vimagit#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#vimagit#apply')
endfunction

function! airline#extensions#vimagit#get_mode() abort
  if ( exists("*magit#get_current_mode") )
    return magit#get_current_mode()
  else
    return get(s:commit_mode, b:magit_current_commit_mode, '???')
  endif
endfunction

function! airline#extensions#vimagit#apply(...) abort
  if ( &filetype == 'magit' )
    let w:airline_section_a = '%{airline#extensions#vimagit#get_mode()}'
  endif
endfunction
./autoload/airline/extensions/vimcmake.vim	[[[1
30
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/cdelledonne/vim-cmake
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#vimcmake#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#vimcmake#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#vimcmake#inactive_apply')
endfunction

function! airline#extensions#vimcmake#apply(...) abort
  if &filetype ==# 'vimcmake'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'CMake'.spc)
    call a:1.add_section('airline_b', spc.'%{cmake#statusline#GetBuildInfo(1)}'.spc)
    call a:1.add_section('airline_c', spc.'%{cmake#statusline#GetCmdInfo()}'.spc)
    return 1
  endif
endfunction

function! airline#extensions#vimcmake#inactive_apply(...) abort
  if getbufvar(a:2.bufnr, '&filetype') ==# 'vimcmake'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'[CMake]')
    call a:1.add_section('airline_b', spc.'%{cmake#statusline#GetBuildInfo(0)}')
    call a:1.add_section('airline_c', spc.'%{cmake#statusline#GetCmdInfo()}')
    return 1
  endif
endfunction
./autoload/airline/extensions/vimtex.vim	[[[1
84
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/lervag/vimtex
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space

function! s:SetDefault(var, val)
  if !exists(a:var)
    execute 'let ' . a:var . '=' . string(a:val)
  endif
endfunction

" Left and right delimiters (added only when status string is not empty)
call s:SetDefault( 'g:airline#extensions#vimtex#left',       "{")
call s:SetDefault( 'g:airline#extensions#vimtex#right',      "}")

" The current tex file is the main project file
call s:SetDefault( 'g:airline#extensions#vimtex#main',       "" )
"
" The current tex file is a subfile of the project
" and the compilation is set for the main file
call s:SetDefault( 'g:airline#extensions#vimtex#sub_main',   "m")
"
" The current tex file is a subfile of the project
" and the compilation is set for this subfile
call s:SetDefault( 'g:airline#extensions#vimtex#sub_local',  "l")
"
" Compilation is running and continuous compilation is off
call s:SetDefault( 'g:airline#extensions#vimtex#compiled',   "c₁")

" Compilation is running and continuous compilation is on
call s:SetDefault( 'g:airline#extensions#vimtex#continuous', "c")

" Viewer is opened
call s:SetDefault( 'g:airline#extensions#vimtex#viewer',     "v")

function! airline#extensions#vimtex#init(ext)
  call airline#parts#define_raw('vimtex', '%{airline#extensions#vimtex#get_scope()}')
  call a:ext.add_statusline_func('airline#extensions#vimtex#apply')
endfunction

function! airline#extensions#vimtex#apply(...)
  if exists("b:vimtex")
    let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x)
    let w:airline_section_x.=s:spc.g:airline_left_alt_sep.s:spc.'%{airline#extensions#vimtex#get_scope()}'
  endif
endfunction

function! airline#extensions#vimtex#get_scope()
  let l:status = ''

  let vt_local = get(b:, 'vimtex_local', {})
  if empty(vt_local)
    let l:status .= g:airline#extensions#vimtex#main
  else
    if get(vt_local, 'active')
      let l:status .= g:airline#extensions#vimtex#sub_local
    else
      let l:status .= g:airline#extensions#vimtex#sub_main
    endif
  endif

  if get(get(get(b:, 'vimtex', {}), 'viewer', {}), 'xwin_id')
    let l:status .= g:airline#extensions#vimtex#viewer
  endif

  let l:compiler = get(get(b:, 'vimtex', {}), 'compiler', {})
  if !empty(l:compiler)
    if has_key(l:compiler, 'is_running') && b:vimtex.compiler.is_running()
      if get(l:compiler, 'continuous')
        let l:status .= g:airline#extensions#vimtex#continuous
      else
        let l:status .= g:airline#extensions#vimtex#compiled
      endif
    endif
  endif

  if !empty(l:status)
    let l:status = g:airline#extensions#vimtex#left . l:status . g:airline#extensions#vimtex#right
  endif
  return l:status
endfunction
./autoload/airline/extensions/virtualenv.vim	[[[1
32
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/jmcantrell/vim-virtualenv
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:spc = g:airline_symbols.space

function! airline#extensions#virtualenv#init(ext)
  call a:ext.add_statusline_func('airline#extensions#virtualenv#apply')
endfunction

function! airline#extensions#virtualenv#apply(...)
  if match(get(g:, 'airline#extensions#virtualenv#ft', ['python']), &filetype) > -1
    if get(g:, 'virtualenv_loaded', 0)
      let statusline = virtualenv#statusline()
    else
      let statusline = fnamemodify($VIRTUAL_ENV, ':t')
    endif
    if !empty(statusline)
      call airline#extensions#append_to_section('x',
            \ s:spc.g:airline_right_alt_sep.s:spc.statusline)
    endif
  endif
endfunction

function! airline#extensions#virtualenv#update()
  if match(get(g:, 'airline#extensions#virtualenv#ft', ['python']), &filetype) > -1
    call airline#extensions#virtualenv#apply()
    call airline#update_statusline()
  endif
endfunction
./autoload/airline/extensions/vista.vim	[[[1
18
" MIT License. Copyright (c) 2021 s1341 (github@shmarya.net)
" Plugin: https://github.com/liuchengxu/vista.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'loaded_vista', 0)
  finish
endif

function! airline#extensions#vista#currenttag() abort
  if get(w:, 'airline_active', 0)
    return airline#util#shorten(get(b:, 'vista_nearest_method_or_function', ''), 91, 9)
  endif
endfunction

function! airline#extensions#vista#init(ext) abort
  call airline#parts#define_function('vista', 'airline#extensions#vista#currenttag')
endfunction
./autoload/airline/extensions/whitespace.vim	[[[1
199
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html

scriptencoding utf-8

let s:show_message = get(g:, 'airline#extensions#whitespace#show_message', 1)
let s:symbol = get(g:, 'airline#extensions#whitespace#symbol', g:airline_symbols.whitespace)
let s:default_checks = ['indent', 'trailing', 'mixed-indent-file', 'conflicts']

let s:enabled = get(g:, 'airline#extensions#whitespace#enabled', 1)
let s:skip_check_ft = {'make': ['indent', 'mixed-indent-file'],
      \ 'csv': ['indent', 'mixed-indent-file'],
      \ 'mail': ['trailing']}

function! s:check_mixed_indent()
  let indent_algo = get(g:, 'airline#extensions#whitespace#mixed_indent_algo', 0)
  if indent_algo == 1
    " [<tab>]<space><tab>
    " spaces before or between tabs are not allowed
    let t_s_t = '(^\t* +\t\s*\S)'
    " <tab>(<space> x count)
    " count of spaces at the end of tabs should be less than tabstop value
    let t_l_s = '(^\t+ {' . &ts . ',}' . '\S)'
    return search('\v' . t_s_t . '|' . t_l_s, 'nw')
  elseif indent_algo == 2
    return search('\v(^\t* +\t\s*\S)', 'nw', 0, 500)
  else
    return search('\v(^\t+ +)|(^ +\t+)', 'nw', 0, 500)
  endif
endfunction

function! s:check_mixed_indent_file()
  let c_like_langs = get(g:, 'airline#extensions#c_like_langs',
        \ [ 'arduino', 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php' ])
  if index(c_like_langs, &ft) > -1
    " for C-like languages: allow /** */ comment style with one space before the '*'
    let head_spc = '\v(^ +\*@!)'
  else
    let head_spc = '\v(^ +)'
  endif
  let indent_tabs = search('\v(^\t+)', 'nw')
  let indent_spc  = search(head_spc, 'nw')
  if indent_tabs > 0 && indent_spc > 0
    return printf("%d:%d", indent_tabs, indent_spc)
  else
    return ''
  endif
endfunction

function! s:conflict_marker()
  " Checks for git conflict markers
  let annotation = '\%([0-9A-Za-z_.:]\+\)\?'
  if match(['rst', 'markdown', 'rmd'], &ft) >= 0
    " rst filetypes use '=======' as header
    let pattern = '^\%(\%(<\{7} '.annotation. '\)\|\%(>\{7\} '.annotation.'\)\)$'
  else
    let pattern = '^\%(\%(<\{7} '.annotation. '\)\|\%(=\{7\}\)\|\%(>\{7\} '.annotation.'\)\)$'
  endif
  return search(pattern, 'nw')
endfunction

function! airline#extensions#whitespace#check()
  let max_lines = get(g:, 'airline#extensions#whitespace#max_lines', 20000)
  if &readonly || !&modifiable || !s:enabled || line('$') > max_lines
          \ || get(b:, 'airline_whitespace_disabled', 0)
    return ''
  endif
  let skip_check_ft = extend(s:skip_check_ft,
        \ get(g:, 'airline#extensions#whitespace#skip_indent_check_ft', {}), 'force')

  if !exists('b:airline_whitespace_check')
    let b:airline_whitespace_check = ''
    let checks = get(b:, 'airline_whitespace_checks', get(g:, 'airline#extensions#whitespace#checks', s:default_checks))

    let trailing = 0
    let check = 'trailing'
    if index(checks, check) > -1 && index(get(skip_check_ft, &ft, []), check) < 0
      try
        let regexp = get(b:, 'airline_whitespace_trailing_regexp',
              \ get(g:, 'airline#extensions#whitespace#trailing_regexp', '\s$'))
        let trailing = search(regexp, 'nw')
      catch
        call airline#util#warning(printf('Whitespace: error occurred evaluating "%s"', regexp))
        echomsg v:exception
        return ''
      endtry
    endif

    let mixed = 0
    let check = 'indent'
    if index(checks, check) > -1 && index(get(skip_check_ft, &ft, []), check) < 0
      let mixed = s:check_mixed_indent()
    endif

    let mixed_file = ''
    let check = 'mixed-indent-file'
    if index(checks, check) > -1 && index(get(skip_check_ft, &ft, []), check) < 0
      let mixed_file = s:check_mixed_indent_file()
    endif

    let long = 0
    if index(checks, 'long') > -1 && &tw > 0
      let long = search('\%>'.&tw.'v.\+', 'nw')
    endif

    let conflicts = 0
    if index(checks, 'conflicts') > -1
      let conflicts = s:conflict_marker()
    endif

    if trailing != 0 || mixed != 0 || long != 0 || !empty(mixed_file) || conflicts != 0
      let b:airline_whitespace_check = s:symbol
      if strlen(s:symbol) > 0
        let space = (g:airline_symbols.space)
      else
        let space = ''
      endif

      if s:show_message
        if trailing != 0
          let trailing_fmt = get(g:, 'airline#extensions#whitespace#trailing_format', '[%s]trailing')
          let b:airline_whitespace_check .= space.printf(trailing_fmt, trailing)
        endif
        if mixed != 0
          let mixed_indent_fmt = get(g:, 'airline#extensions#whitespace#mixed_indent_format', '[%s]mixed-indent')
          let b:airline_whitespace_check .= space.printf(mixed_indent_fmt, mixed)
        endif
        if long != 0
          let long_fmt = get(g:, 'airline#extensions#whitespace#long_format', '[%s]long')
          let b:airline_whitespace_check .= space.printf(long_fmt, long)
        endif
        if !empty(mixed_file)
          let mixed_indent_file_fmt = get(g:, 'airline#extensions#whitespace#mixed_indent_file_format', '[%s]mix-indent-file')
          let b:airline_whitespace_check .= space.printf(mixed_indent_file_fmt, mixed_file)
        endif
        if conflicts != 0
          let conflicts_fmt = get(g:, 'airline#extensions#whitespace#conflicts_format', '[%s]conflicts')
          let b:airline_whitespace_check .= space.printf(conflicts_fmt, conflicts)
        endif
      endif
    endif
  endif
  return airline#util#shorten(b:airline_whitespace_check, 120, 9)
endfunction

function! airline#extensions#whitespace#toggle()
  if s:enabled
    augroup airline_whitespace
      autocmd!
    augroup END
    augroup! airline_whitespace
    let s:enabled = 0
  else
    call airline#extensions#whitespace#init()
    let s:enabled = 1
  endif

  if exists("g:airline#extensions#whitespace#enabled")
    let g:airline#extensions#whitespace#enabled = s:enabled
    if s:enabled && match(g:airline_section_warning, '#whitespace#check') < 0
      let g:airline_section_warning .= airline#section#create(['whitespace'])
      call airline#update_statusline()
    endif
  endif
  call airline#util#warning(printf('Whitespace checking: %s',(s:enabled ? 'Enabled' : 'Disabled')))
endfunction

function! airline#extensions#whitespace#disable()
  if s:enabled
    call airline#extensions#whitespace#toggle()
  endif
endfunction

function! airline#extensions#whitespace#init(...)
  call airline#parts#define_function('whitespace', 'airline#extensions#whitespace#check')

  unlet! b:airline_whitespace_check
  augroup airline_whitespace
    autocmd!
    autocmd CursorHold,BufWritePost * call <sid>ws_refresh()
  augroup END
endfunction

function! s:ws_refresh()
  if !exists('#airline')
    " airline disabled
    return
  endif
  if get(b:, 'airline_ws_changedtick', 0) == b:changedtick
    return
  endif
  unlet! b:airline_whitespace_check
  if get(g:, 'airline_skip_empty_sections', 0)
    exe ':AirlineRefresh!'
  endif
  let b:airline_ws_changedtick = b:changedtick
endfunction
./autoload/airline/extensions/windowswap.vim	[[[1
30
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" Plugin: https://github.com/wesQ3/vim-windowswap
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:loaded_windowswap')
  finish
endif

let s:spc = g:airline_symbols.space

if !exists('g:airline#extensions#windowswap#indicator_text')
  let g:airline#extensions#windowswap#indicator_text = 'WS'
endif

function! airline#extensions#windowswap#init(ext)
  call airline#parts#define_function('windowswap', 'airline#extensions#windowswap#get_status')
endfunction

function! airline#extensions#windowswap#get_status()
  " use new tab-aware api if WS is up to date
  let s:mark = exists('*WindowSwap#IsCurrentWindowMarked') ?
    \WindowSwap#IsCurrentWindowMarked() :
    \(WindowSwap#HasMarkedWindow() && WindowSwap#GetMarkedWindowNum() == winnr())
  if s:mark
    return g:airline#extensions#windowswap#indicator_text.s:spc
  endif
  return ''
endfunction
./autoload/airline/extensions/wordcount/formatters/default.vim	[[[1
47
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#wordcount#formatters#default#update_fmt(...)
  let s:fmt = get(g:, 'airline#extensions#wordcount#formatter#default#fmt', '%s words')
  let s:fmt_short = get(g:, 'airline#extensions#wordcount#formatter#default#fmt_short', s:fmt == '%s words' ? '%sW' : s:fmt)
endfunction

" Reload format when statusline is rebuilt
call airline#extensions#wordcount#formatters#default#update_fmt()

if index(g:airline_statusline_funcrefs, function('airline#extensions#wordcount#formatters#default#update_fmt')) == -1
  " only add it, if not already done
  call airline#add_statusline_funcref(function('airline#extensions#wordcount#formatters#default#update_fmt'))
endif

if match(get(v:, 'lang', ''), '\v\cC|en') > -1
  let s:decimal_group = ','
elseif match(get(v:, 'lang', ''), '\v\cde|dk|fr|pt') > -1
  let s:decimal_group = '.'
else
  let s:decimal_group = ''
endif

function! airline#extensions#wordcount#formatters#default#to_string(wordcount)
  if airline#util#winwidth() > 85
    if a:wordcount > 999
      " Format number according to locale, e.g. German: 1.245 or English: 1,245
      let wordcount = substitute(a:wordcount, '\d\@<=\(\(\d\{3\}\)\+\)$', s:decimal_group.'&', 'g')
    else
      let wordcount = a:wordcount
    endif
    let str = printf(s:fmt, wordcount)
  else
    let str = printf(s:fmt_short, a:wordcount)
  endif

  let str .= g:airline_symbols.space

  if !empty(g:airline_right_alt_sep)
    let str .= g:airline_right_alt_sep . g:airline_symbols.space
  endif

  return str
endfunction
./autoload/airline/extensions/wordcount/formatters/readingtime.vim	[[[1
47
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#wordcount#formatters#readingtime#update_fmt(...) abort
  let s:fmt = get(g:, 'airline#extensions#wordcount#formatter#readingtime#fmt', 'About %s minutes')
  let s:fmt_short = get(g:, 'airline#extensions#wordcount#formatter#readingtime#fmt_short', s:fmt ==# 'About %s minutes' ? '%sW' : s:fmt)
endfunction

" Reload format when statusline is rebuilt
call airline#extensions#wordcount#formatters#readingtime#update_fmt()

if index(g:airline_statusline_funcrefs, function('airline#extensions#wordcount#formatters#readingtime#update_fmt')) == -1
  " only add it, if not already done
  call airline#add_statusline_funcref(function('airline#extensions#wordcount#formatters#readingtime#update_fmt'))
endif

if match(get(v:, 'lang', ''), '\v\cC|en') > -1
  let s:decimal_group = ','
elseif match(get(v:, 'lang', ''), '\v\cde|dk|fr|pt') > -1
  let s:decimal_group = '.'
else
  let s:decimal_group = ''
endif

function! airline#extensions#wordcount#formatters#readingtime#to_string(wordcount) abort
  if airline#util#winwidth() > 85
    if a:wordcount > 999
      " Format number according to locale, e.g. German: 1.245 or English: 1,245
      let wordcount = substitute(a:wordcount, '\d\@<=\(\(\d\{3\}\)\+\)$', s:decimal_group.'&', 'g')
    else
      let wordcount = a:wordcount
    endif
    let str = printf(s:fmt, ceil(wordcount / 200.0))
  else
    let str = printf(s:fmt_short, ceil(a:wordcount / 200.0))
  endif

  let str .= g:airline_symbols.space

  if !empty(g:airline_right_alt_sep)
    let str .= g:airline_right_alt_sep . g:airline_symbols.space
  endif

  return str
endfunction
./autoload/airline/extensions/wordcount.vim	[[[1
128
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 fdm=marker

scriptencoding utf-8

" get wordcount {{{1
if exists('*wordcount')
  function! s:get_wordcount(visual_mode_active)
    if get(g:, 'actual_curbuf', '') != bufnr('')
      return
    endif
    if &filetype ==# 'tex' && exists('b:vimtex') && get(g:, 'airline#extensions#vimtex#wordcount', 0)
      " We're in a TeX file and vimtex is a plugin, so use vimtex's wordcount...
      if a:visual_mode_active
        " not useful? 
        return
      else
        return vimtex#misc#wordcount()
      endif
    else
      let query = a:visual_mode_active ? 'visual_words' : 'words'
      return get(wordcount(), query, 0)
    endif
  endfunction
else  " Pull wordcount from the g_ctrl-g stats
  function! s:get_wordcount(visual_mode_active)
    let pattern = a:visual_mode_active
          \ ? '^.\D*\d\+\D\+\d\+\D\+\zs\d\+'
          \ : '^.\D*\%(\d\+\D\+\)\{5}\zs\d\+'

    let save_status = v:statusmsg
    if !a:visual_mode_active && col('.') == col('$')
      let save_pos = getpos('.')
      execute "silent normal! g\<c-g>"
      call setpos('.', save_pos)
    else
      execute "silent normal! g\<c-g>"
    endif
    let stats = v:statusmsg
    let v:statusmsg = save_status

    return str2nr(matchstr(stats, pattern))
  endfunction
endif

" format {{{1
let s:formatter = get(g:, 'airline#extensions#wordcount#formatter', 'default')

" wrapper function for compatibility; redefined below for old-style formatters
function! s:format_wordcount(wordcount)
  return airline#extensions#wordcount#formatters#{s:formatter}#to_string(a:wordcount)
endfunction

" check user-defined formatter exists with appropriate functions, otherwise
" fall back to default
if s:formatter !=# 'default'
  execute 'runtime! autoload/airline/extensions/wordcount/formatters/'.s:formatter.'.vim'
  if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#to_string')
    if !exists('*airline#extensions#wordcount#formatters#{s:formatter}#format')
      let s:formatter = 'default'
    else
      " redefine for backwords compatibility
      function! s:format_wordcount(_)
        if mode() ==? 'v'
          return b:airline_wordcount
        else
          return airline#extensions#wordcount#formatters#{s:formatter}#format()
        endif
      endfunction
    endif
  endif
endif

" update {{{1
let s:wordcount_cache = 0  " cache wordcount for performance when force_update=0
function! s:update_wordcount(force_update)
  let wordcount = s:get_wordcount(0)
  if wordcount != s:wordcount_cache || a:force_update
    let s:wordcount_cache = wordcount
    let b:airline_wordcount =  s:format_wordcount(wordcount)
  endif
endfunction

function airline#extensions#wordcount#get()
  if get(g:, 'airline#visual_active', 0)
    return s:format_wordcount(s:get_wordcount(1))
  else
    if get(b:, 'airline_changedtick', 0) != b:changedtick
      call s:update_wordcount(0)
      let b:airline_changedtick = b:changedtick
    endif
    return get(b:, 'airline_wordcount', '')
  endif
endfunction

" airline functions {{{1
" default filetypes:
function! airline#extensions#wordcount#apply(...)
  let filetypes = get(g:, 'airline#extensions#wordcount#filetypes',
    \ ['asciidoc', 'help', 'mail', 'markdown', 'rmd', 'nroff', 'org', 'rst', 'plaintex', 'tex', 'text'])
  " export current filetypes settings to global namespace
  let g:airline#extensions#wordcount#filetypes = filetypes

  " Check if filetype needs testing
  if did_filetype()
    " correctly test for compound filetypes (e.g. markdown.pandoc)
    let ft = substitute(&filetype, '\.', '\\|', 'g')

    " Select test based on type of "filetypes": new=list, old=string
    if type(filetypes) == get(v:, 't_list', type([]))
          \ ? match(filetypes, '\<'. ft. '\>') > -1 || index(filetypes, 'all') > -1
          \ : match(&filetype, filetypes) > -1
      let b:airline_changedtick = -1
      call s:update_wordcount(1) " force update: ensures initial worcount exists
    elseif exists('b:airline_wordcount') " cleanup when filetype is removed
      unlet b:airline_wordcount
    endif
  endif

  if exists('b:airline_wordcount')
    call airline#extensions#prepend_to_section(
          \ 'z', '%{airline#extensions#wordcount#get()}')
  endif
endfunction

function! airline#extensions#wordcount#init(ext)
  call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
endfunction
./autoload/airline/extensions/xkblayout.vim	[[[1
29
" MIT License. Copyright (c) 2017-2021 YoungHoon Rhiu et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:XkbSwitchLib') && !exists('*FcitxCurrentIM')
  finish
endif

function! airline#extensions#xkblayout#status()
  if exists('g:XkbSwitchLib')
    let keyboard_layout = libcall(g:XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
    let keyboard_layout = get(split(keyboard_layout, '\.'), -1, '')
  else
    " substitute keyboard-us to us
    let keyboard_layout = substitute(FcitxCurrentIM(), 'keyboard-', '', 'g')
  endif

  let short_codes = get(g:, 'airline#extensions#xkblayout#short_codes', {'2SetKorean': 'KR', 'Chinese': 'CN', 'Japanese': 'JP'})
  if has_key(short_codes, keyboard_layout)
    let keyboard_layout = short_codes[keyboard_layout]
  endif

  return keyboard_layout
endfunction

function! airline#extensions#xkblayout#init(ext)
  call airline#parts#define_function('xkblayout', 'airline#extensions#xkblayout#status')
endfunction
./autoload/airline/extensions/ycm.vim	[[[1
42
" MIT License. Copyright (c) 2015-2021 Evgeny Firsov et al.
" Plugin: https://github.com/ycm-core/YouCompleteMe
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_youcompleteme', 0)
  finish
endif

let s:spc = g:airline_symbols.space
let s:error_symbol = get(g:, 'airline#extensions#ycm#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#ycm#warning_symbol', 'W:')

function! airline#extensions#ycm#init(ext)
  call airline#parts#define_function('ycm_error_count', 'airline#extensions#ycm#get_error_count')
  call airline#parts#define_function('ycm_warning_count', 'airline#extensions#ycm#get_warning_count')
endfunction

function! airline#extensions#ycm#get_error_count() abort
  if exists("*youcompleteme#GetErrorCount")
    let cnt = youcompleteme#GetErrorCount()

    if cnt != 0
      return s:error_symbol.cnt
    endif
  endif

  return ''
endfunction

function! airline#extensions#ycm#get_warning_count()
  if exists("*youcompleteme#GetWarningCount")
    let cnt = youcompleteme#GetWarningCount()

    if cnt != 0
      return s:warning_symbol.cnt.s:spc
    endif
  endif

  return ''
endfunction
./autoload/airline/extensions/zoomwintab.vim	[[[1
27
" MIT License. Copyright (c) 2021 Dmitry Geurkov (d.geurkov@gmail.com)
" Plugin: https://github.com/troydm/zoomwintab.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8


" Avoid installing twice
if exists('g:loaded_vim_airline_zoomwintab')
  finish
endif

let g:loaded_vim_airline_zoomwintab = 1

let s:zoomwintab_status_zoomed_in =
  \ get(g:, 'airline#extensions#zoomwintab#status_zoomed_in', g:airline_left_alt_sep.' Zoomed')
let s:zoomwintab_status_zoomed_out =
  \ get(g:, 'airline#extensions#zoomwintab#status_zoomed_out', '')

function! airline#extensions#zoomwintab#apply(...) abort
  call airline#extensions#prepend_to_section('gutter',
    \ exists('t:zoomwintab') ? s:zoomwintab_status_zoomed_in : s:zoomwintab_status_zoomed_out)
endfunction

function! airline#extensions#zoomwintab#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#zoomwintab#apply')
endfunction
./autoload/airline/extensions.vim	[[[1
523
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:loaded_ext = []
let s:ext = {}
let s:ext._theme_funcrefs = []

function! s:ext.add_statusline_func(name) dict
  call airline#add_statusline_func(a:name)
endfunction
function! s:ext.add_statusline_funcref(function) dict
  call airline#add_statusline_funcref(a:function)
endfunction
function! s:ext.add_inactive_statusline_func(name) dict
  call airline#add_inactive_statusline_func(a:name)
endfunction
function! s:ext.add_theme_func(name) dict
  call add(self._theme_funcrefs, function(a:name))
endfunction

let s:script_path = tolower(resolve(expand('<sfile>:p:h')))

let s:filetype_overrides = {
      \ 'coc-explorer':  [ 'CoC Explorer', '' ],
      \ 'defx':  ['defx', '%{b:defx.paths[0]}'],
      \ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}'],
      \ 'floggraph':  [ 'Flog', '%{get(b:, "flog_status_summary", "")}' ],
      \ 'gundo': [ 'Gundo', '' ],
      \ 'help':  [ 'Help', '%f' ],
      \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
      \ 'startify': [ 'startify', '' ],
      \ 'vim-plug': [ 'Plugins', '' ],
      \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
      \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
      \ 'vaffle' : [ 'Vaffle', '%{b:vaffle.dir}' ],
      \ }

if get(g:, 'airline#extensions#nerdtree_statusline', 1)
  let s:filetype_overrides['nerdtree'] = [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ]
else
  let s:filetype_overrides['nerdtree'] = ['NERDTree', '']
endif

let s:filetype_regex_overrides = {}

function! s:check_defined_section(name)
  if !exists('w:airline_section_{a:name}')
    let w:airline_section_{a:name} = g:airline_section_{a:name}
  endif
endfunction

function! airline#extensions#append_to_section(name, value)
  call <sid>check_defined_section(a:name)
  let w:airline_section_{a:name} .= a:value
endfunction

function! airline#extensions#prepend_to_section(name, value)
  call <sid>check_defined_section(a:name)
  let w:airline_section_{a:name} = a:value . w:airline_section_{a:name}
endfunction

function! airline#extensions#apply_left_override(section1, section2)
  let w:airline_section_a = a:section1
  let w:airline_section_b = a:section2
  let w:airline_section_c = airline#section#create(['readonly'])
  let w:airline_render_left = 1
  let w:airline_render_right = 0
endfunction

function! airline#extensions#apply(...)
  let filetype_overrides = get(s:, 'filetype_overrides', {})
  call extend(filetype_overrides, get(g:, 'airline_filetype_overrides', {}), 'force')

  if s:is_excluded_window()
    return -1
  endif

  if &buftype == 'terminal'
    let w:airline_section_x = ''
    let w:airline_section_y = ''
  endif

  if &previewwindow && empty(get(w:, 'airline_section_a', ''))
    let w:airline_section_a = 'Preview'
    let w:airline_section_b = ''
    let w:airline_section_c = bufname(winbufnr(winnr()))
  endif

  if has_key(filetype_overrides, &ft) &&
        \ ((&filetype == 'help' && &buftype == 'help') || &filetype !~ 'help')
    " for help files only override it, if the buftype is also of type 'help',
    " else it would trigger when editing Vim help files
    let args = filetype_overrides[&ft]
    call airline#extensions#apply_left_override(args[0], args[1])
  endif

  if &buftype == 'help'
    let w:airline_section_x = ''
    let w:airline_section_y = ''
    let w:airline_render_right = 1
  endif

  for item in items(s:filetype_regex_overrides)
    if match(&ft, item[0]) >= 0
      call airline#extensions#apply_left_override(item[1][0], item[1][1])
    endif
  endfor
endfunction

function! s:is_excluded_window()
  for matchft in g:airline_exclude_filetypes
    if matchft ==# &ft
      return 1
    endif
  endfor

  for matchw in g:airline_exclude_filenames
    if matchstr(expand('%'), matchw) ==# matchw
      return 1
    endif
  endfor

  if g:airline_exclude_preview && &previewwindow
    return 1
  endif

  return 0
endfunction

function! airline#extensions#load_theme()
  call airline#util#exec_funcrefs(s:ext._theme_funcrefs, g:airline#themes#{g:airline_theme}#palette)
endfunction

function! airline#extensions#load()
  let s:loaded_ext = []

  if exists('g:airline_extensions')
    for ext in g:airline_extensions
      try
        call airline#extensions#{ext}#init(s:ext)
      catch /^Vim\%((\a\+)\)\=:E117/	" E117, function does not exist
        call airline#util#warning("Extension '".ext."' not installed, ignoring!")
        continue
      endtry
      call add(s:loaded_ext, ext)
    endfor
    return
  endif

  call airline#extensions#quickfix#init(s:ext)
  call add(s:loaded_ext, 'quickfix')

  if get(g:, 'loaded_unite', 0) && get(g:, 'airline#extensions#unite#enabled', 1)
    call airline#extensions#unite#init(s:ext)
    call add(s:loaded_ext, 'unite')
  endif

  if get(g:, 'loaded_denite', 0) && get(g:, 'airline#extensions#denite#enabled', 1)
    call airline#extensions#denite#init(s:ext)
    call add(s:loaded_ext, 'denite')
  endif

  if get(g:, 'loaded_gina', 0) && get(g:, 'airline#extensions#gina#enabled', 1)
    call airline#extensions#gina#init(s:ext)
    call add(s:loaded_ext, 'gina')
  endif

  if get(g:, 'loaded_fern', 0) && get(g:, 'airline#extensions#fern#enabled', 1)
    call airline#extensions#fern#init(s:ext)
    call add(s:loaded_ext, 'fern')
  endif

  if exists(':NetrwSettings')
    call airline#extensions#netrw#init(s:ext)
    call add(s:loaded_ext, 'netrw')
  endif

  " fzf buffers are also terminal buffers, so this must be above term.
  if exists(':FZF') && get(g:, 'airline#extensions#fzf#enabled', 1)
    call airline#extensions#fzf#init(s:ext)
    call add(s:loaded_ext, 'fzf')
  endif

  " Vim-CMake buffers are also terminal buffers, so this must be above term.
  if get(g:, 'loaded_cmake', 0) && get(g:, 'airline#extensions#vimcmake#enabled', 1)
    call airline#extensions#vimcmake#init(s:ext)
    call add(s:loaded_ext, 'vimcmake')
  endif

  if (has("terminal") || has('nvim')) &&
        \ get(g:, 'airline#extensions#term#enabled', 1)
    call airline#extensions#term#init(s:ext)
    call add(s:loaded_ext, 'term')
  endif

  if get(g:, 'airline#extensions#ycm#enabled', 0) && exists('g:loaded_youcompleteme')
    call airline#extensions#ycm#init(s:ext)
    call add(s:loaded_ext, 'ycm')
  endif

  if get(g:, 'loaded_vimfiler', 0)
    let g:vimfiler_force_overwrite_statusline = 0
  endif

  if get(g:, 'loaded_ctrlp', 0)
    call airline#extensions#ctrlp#init(s:ext)
    call add(s:loaded_ext, 'ctrlp')
  endif

  if get(g:, 'loaded_localsearch', 0)
    call airline#extensions#localsearch#init(s:ext)
    call add(s:loaded_ext, 'localsearch')
  endif

  if get(g:, 'CtrlSpaceLoaded', 0)
    call airline#extensions#ctrlspace#init(s:ext)
    call add(s:loaded_ext, 'ctrlspace')
  endif

  if get(g:, 'command_t_loaded', 0)
    call airline#extensions#commandt#init(s:ext)
    call add(s:loaded_ext, 'commandt')
  endif

  if exists(':UndotreeToggle')
    call airline#extensions#undotree#init(s:ext)
    call add(s:loaded_ext, 'undotree')
  endif

  if get(g:, 'airline#extensions#hunks#enabled', 1)
        \ && (exists('g:loaded_signify')
        \ || exists('g:loaded_gitgutter')
        \ || exists('g:loaded_changes')
        \ || exists('g:loaded_quickfixsigns')
        \ || exists(':Gitsigns')
        \ || exists(':CocCommand'))
    call airline#extensions#hunks#init(s:ext)
    call add(s:loaded_ext, 'hunks')
  endif

  if get(g:, 'airline#extensions#vimagit#enabled', 1)
        \ && (exists('g:loaded_magit'))
    call airline#extensions#vimagit#init(s:ext)
    call add(s:loaded_ext, 'vimagit')
  endif

  if get(g:, 'airline#extensions#tagbar#enabled', 1)
        \ && exists(':TagbarToggle')
    call airline#extensions#tagbar#init(s:ext)
    call add(s:loaded_ext, 'tagbar')
  endif
  if get(g:, 'airline#extensions#taglist#enabled', 1) && exists(':TlistShowTag')
    call airline#extensions#taglist#init(s:ext)
    call add(s:loaded_ext, 'taglist')
  endif

  if get(g:, 'airline#extensions#vista#enabled', 1)
        \ && exists(':Vista')
    call airline#extensions#vista#init(s:ext)
    call add(s:loaded_ext, 'vista')
  endif

  if get(g:, 'airline#extensions#bookmark#enabled', 1)
        \ && exists(':BookmarkToggle')
    call airline#extensions#bookmark#init(s:ext)
    call add(s:loaded_ext, 'bookmark')
  endif

  if get(g:, 'airline#extensions#scrollbar#enabled', 0)
    call airline#extensions#scrollbar#init(s:ext)
    call add(s:loaded_ext, 'scrollbar')
  endif

  if get(g:, 'airline#extensions#csv#enabled', 1)
        \ && (get(g:, 'loaded_csv', 0) || exists(':Table'))
    call airline#extensions#csv#init(s:ext)
    call add(s:loaded_ext, 'csv')
  endif

  if get(g:, 'airline#extensions#zoomwintab#enabled', 0)
    call airline#extensions#zoomwintab#init(s:ext)
    call add(s:loaded_ext, 'zoomwintab')
  endif

  if exists(':VimShell')
    let s:filetype_regex_overrides['^int-'] = ['vimshell','%{substitute(&ft, "int-", "", "")}']
  endif

  if get(g:, 'airline#extensions#branch#enabled', 1) && (
          \ airline#util#has_fugitive() ||
          \ airline#util#has_gina() ||
          \ airline#util#has_lawrencium() ||
          \ airline#util#has_vcscommand() ||
          \ airline#util#has_custom_scm())
    call airline#extensions#branch#init(s:ext)
    call add(s:loaded_ext, 'branch')
  endif

  if get(g:, 'airline#extensions#bufferline#enabled', 1)
        \ && exists('*bufferline#get_status_string')
    call airline#extensions#bufferline#init(s:ext)
    call add(s:loaded_ext, 'bufferline')
  endif

  if get(g:, 'airline#extensions#fugitiveline#enabled', 1)
        \ && airline#util#has_fugitive()
        \ && index(s:loaded_ext, 'bufferline') == -1
    call airline#extensions#fugitiveline#init(s:ext)
    call add(s:loaded_ext, 'fugitiveline')
  endif

  " NOTE: This means that if both virtualenv and poetv are enabled and
  " available, poetv silently takes precedence and the virtualenv
  " extension won't be initialized. Since both extensions currently just
  " add a virtualenv identifier section to the airline, this seems
  " acceptable.
  if (get(g:, 'airline#extensions#poetv#enabled', 0) && (exists(':PoetvActivate')))
    call airline#extensions#poetv#init(s:ext)
    call add(s:loaded_ext, 'poetv')
  elseif (get(g:, 'airline#extensions#virtualenv#enabled', 0) && (exists(':VirtualEnvList')))
    call airline#extensions#virtualenv#init(s:ext)
    call add(s:loaded_ext, 'virtualenv')
  elseif (get(g:, 'airline#extensions#poetv#enabled', 0) && (isdirectory($VIRTUAL_ENV)))
    call airline#extensions#poetv#init(s:ext)
    call add(s:loaded_ext, 'poetv')
  endif

  if (get(g:, 'airline#extensions#eclim#enabled', 1) && exists(':ProjectCreate'))
    call airline#extensions#eclim#init(s:ext)
    call add(s:loaded_ext, 'eclim')
  endif

  if get(g:, 'airline#extensions#syntastic#enabled', 1)
        \ && exists(':SyntasticCheck')
    call airline#extensions#syntastic#init(s:ext)
    call add(s:loaded_ext, 'syntastic')
  endif

  if (get(g:, 'airline#extensions#ale#enabled', 1) && exists(':ALELint'))
    call airline#extensions#ale#init(s:ext)
    call add(s:loaded_ext, 'ale')
  endif

  if (get(g:, 'airline#extensions#lsp#enabled', 1) && exists(':LspDeclaration'))
    call airline#extensions#lsp#init(s:ext)
    call add(s:loaded_ext, 'lsp')
  endif

  if (get(g:, 'airline#extensions#nvimlsp#enabled', 1)
        \ && has('nvim')
        \ && luaeval('vim.lsp ~= nil'))
    call airline#extensions#nvimlsp#init(s:ext)
    call add(s:loaded_ext, 'nvimlsp')
  endif

  if (get(g:, 'airline#extensions#coc#enabled', 1) && exists(':CocCommand'))
    call airline#extensions#coc#init(s:ext)
    call add(s:loaded_ext, 'coc')
  endif

  if (get(g:, 'airline#extensions#languageclient#enabled', 1) && exists(':LanguageClientStart'))
    call airline#extensions#languageclient#init(s:ext)
    call add(s:loaded_ext, 'languageclient')
  endif

  if get(g:, 'airline#extensions#whitespace#enabled', 1)
    call airline#extensions#whitespace#init(s:ext)
    call add(s:loaded_ext, 'whitespace')
  endif

  if (get(g:, 'airline#extensions#neomake#enabled', 1) && exists(':Neomake'))
    call airline#extensions#neomake#init(s:ext)
    call add(s:loaded_ext, 'neomake')
  endif

  if get(g:, 'airline#extensions#po#enabled', 1) && executable('msgfmt')
    call airline#extensions#po#init(s:ext)
    call add(s:loaded_ext, 'po')
  endif

  if get(g:, 'airline#extensions#wordcount#enabled', 1)
    call airline#extensions#wordcount#init(s:ext)
    call add(s:loaded_ext, 'wordcount')
  endif

  if get(g:, 'airline#extensions#tabline#enabled', 0)
    call airline#extensions#tabline#init(s:ext)
    call add(s:loaded_ext, 'tabline')
  endif

  if get(g:, 'airline#extensions#tmuxline#enabled', 1) && exists(':Tmuxline')
    call airline#extensions#tmuxline#init(s:ext)
    call add(s:loaded_ext, 'tmuxline')
  endif

  if get(g:, 'airline#extensions#promptline#enabled', 1) && exists(':PromptlineSnapshot') && len(get(g:, 'airline#extensions#promptline#snapshot_file', ''))
    call airline#extensions#promptline#init(s:ext)
    call add(s:loaded_ext, 'promptline')
  endif

  if get(g:, 'airline#extensions#nrrwrgn#enabled', 1) && get(g:, 'loaded_nrrw_rgn', 0)
      call airline#extensions#nrrwrgn#init(s:ext)
    call add(s:loaded_ext, 'nrrwrgn')
  endif

  if get(g:, 'airline#extensions#unicode#enabled', 1) && exists(':UnicodeTable') == 2
      call airline#extensions#unicode#init(s:ext)
    call add(s:loaded_ext, 'unicode')
  endif

  if (get(g:, 'airline#extensions#capslock#enabled', 1) && exists('*CapsLockStatusline'))
    call airline#extensions#capslock#init(s:ext)
    call add(s:loaded_ext, 'capslock')
  endif

  if (get(g:, 'airline#extensions#gutentags#enabled', 1) && get(g:, 'loaded_gutentags', 0))
    call airline#extensions#gutentags#init(s:ext)
    call add(s:loaded_ext, 'gutentags')
  endif

  if get(g:, 'airline#extensions#gen_tags#enabled', 1) && (get(g:, 'loaded_gentags#gtags', 0) || get(g:, 'loaded_gentags#ctags', 0))
    call airline#extensions#gen_tags#init(s:ext)
    call add(s:loaded_ext, 'gen_tags')
  endif

  if (get(g:, 'airline#extensions#grepper#enabled', 1) && get(g:, 'loaded_grepper', 0))
    call airline#extensions#grepper#init(s:ext)
    call add(s:loaded_ext, 'grepper')
  endif

  if get(g:, 'airline#extensions#xkblayout#enabled', 1) && (exists('g:XkbSwitchLib') || exists('*FcitxCurrentIM'))
    call airline#extensions#xkblayout#init(s:ext)
    call add(s:loaded_ext, 'xkblayout')
  endif

  if (get(g:, 'airline#extensions#keymap#enabled', 1) && has('keymap'))
    call airline#extensions#keymap#init(s:ext)
    call add(s:loaded_ext, 'keymap')
  endif

  if (get(g:, 'airline#extensions#windowswap#enabled', 1) && get(g:, 'loaded_windowswap', 0))
    call airline#extensions#windowswap#init(s:ext)
    call add(s:loaded_ext, 'windowswap')
  endif

  if (get(g:, 'airline#extensions#obsession#enabled', 1) && exists('*ObsessionStatus'))
    call airline#extensions#obsession#init(s:ext)
    call add(s:loaded_ext, 'obsession')
  endif

  if get(g:, 'airline#extensions#vimtex#enabled', 1)
    runtime autoload/vimtex.vim
    if exists('*vimtex#init')
      call airline#extensions#vimtex#init(s:ext)
      call add(s:loaded_ext, 'vimtex')
    endif
  endif

  if (get(g:, 'airline#extensions#cursormode#enabled', 0))
    call airline#extensions#cursormode#init(s:ext)
    call add(s:loaded_ext, 'cursormode')
  endif

  if get(g:, 'airline#extensions#searchcount#enabled', 1) && exists('*searchcount')
    call airline#extensions#searchcount#init(s:ext)
    call add(s:loaded_ext, 'searchcount')
  endif

  if get(g:, 'loaded_battery', 0) && get(g:, 'airline#extensions#battery#enabled', 0)
    call airline#extensions#battery#init(s:ext)
    call add(s:loaded_ext, 'battery')
  endif

  if (get(g:, 'airline#extensions#vim9lsp#enabled', 1) && exists('*lsp#lsp#ErrorCount'))
    call airline#extensions#vim9lsp#init(s:ext)
    call add(s:loaded_ext, 'vim9lsp')
  endif

  if !get(g:, 'airline#extensions#disable_rtp_load', 0)
    " load all other extensions, which are not part of the default distribution.
    " (autoload/airline/extensions/*.vim outside of our s:script_path).
    for file in split(globpath(&rtp, 'autoload/airline/extensions/*.vim', 1), "\n")
      " we have to check both resolved and unresolved paths, since it's possible
      " that they might not get resolved properly (see #187)
      if stridx(tolower(resolve(fnamemodify(file, ':p'))), s:script_path) < 0
            \ && stridx(tolower(fnamemodify(file, ':p')), s:script_path) < 0
        let name = fnamemodify(file, ':t:r')
        if !get(g:, 'airline#extensions#'.name.'#enabled', 1) ||
            \ index(s:loaded_ext, name.'*') > -1
          continue
        endif
        try
          call airline#extensions#{name}#init(s:ext)
          " mark as external
          call add(s:loaded_ext, name.'*')
        catch
        endtry
      endif
    endfor
  endif

  if exists(':Dirvish') && get(g:, 'airline#extensions#dirvish#enabled', 1)
    call airline#extensions#dirvish#init(s:ext)
    call add(s:loaded_ext, 'dirvish')
  endif

  if (get(g:, 'airline#extensions#omnisharp#enabled', 1) && get(g:, 'OmniSharp_loaded', 0))
    call airline#extensions#omnisharp#init(s:ext)
    call add(s:loaded_ext, 'omnisharp')
  endif

  if (get(g:, 'airline#extensions#rufo#enabled', 0) && get(g:, 'rufo_loaded', 0))
    call airline#extensions#rufo#init(s:ext)
    call add(s:loaded_ext, 'rufo')
  endif

endfunction

function! airline#extensions#get_loaded_extensions()
  return s:loaded_ext
endfunction
./autoload/airline/formatter/short_path.vim	[[[1
8
scriptencoding utf-8

function! airline#formatter#short_path#format(val) abort
  if get(g:, 'airline_stl_path_style', 'default') ==# 'short'
    return '%{pathshorten(expand("'.a:val.'"))}'
  endif
  return a:val
endfunction
./autoload/airline/highlighter.vim	[[[1
685
" MIT License. Copyright (c) 2013-2021 Bailey Ling Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

let s:is_win32term = (has('win32') || has('win64')) &&
                   \ !has('gui_running') &&
                   \ (empty($CONEMUBUILD) || &term !=? 'xterm') &&
                   \ empty($WT_SESSION) &&
                   \ !(exists("+termguicolors") && &termguicolors)

let s:separators = {}
let s:accents = {}
let s:hl_groups = {}

if !exists(":def") || !airline#util#has_vim9_script()

  " Legacy Vimscript implementation
  function! s:gui2cui(rgb, fallback) abort
    if a:rgb == ''
      return a:fallback
    elseif match(a:rgb, '^\%(NONE\|[fb]g\)$') > -1
      return a:rgb
    elseif a:rgb[0] !~ '#'
      " a:rgb contains colorname
      return a:rgb
    endif
    let rgb = map(split(a:rgb[1:], '..\zs'), '0 + ("0x".v:val)')
    return airline#msdos#round_msdos_colors(rgb)
  endfunction

  function! s:group_not_done(list, name) abort
    if index(a:list, a:name) == -1
      call add(a:list, a:name)
      return 1
    else
      if &vbs
        echomsg printf("airline: group: %s already done, skipping", a:name)
      endif
      return 0
    endif
  endfu

  function! s:get_syn(group, what, mode) abort
    let color = ''
    if hlexists(a:group)
      let color = synIDattr(synIDtrans(hlID(a:group)), a:what, a:mode)
    endif
    if empty(color) || color == -1
      " should always exist
      let color = synIDattr(synIDtrans(hlID('Normal')), a:what, a:mode)
      " however, just in case
      if empty(color) || color == -1
        let color = 'NONE'
      endif
    endif
    return color
  endfunction

  function! s:get_array(guifg, guibg, ctermfg, ctermbg, opts) abort
    return [ a:guifg, a:guibg, a:ctermfg, a:ctermbg, empty(a:opts) ? '' : join(a:opts, ',') ]
  endfunction

  function! airline#highlighter#reset_hlcache() abort
    let s:hl_groups = {}
  endfunction

  function! airline#highlighter#get_highlight(group, ...) abort
    " only check for the cterm reverse attribute
    " TODO: do we need to check all modes (gui, term, as well)?
    let reverse = synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'cterm')
    if get(g:, 'airline_highlighting_cache', 0) && has_key(s:hl_groups, a:group)
      let res = s:hl_groups[a:group]
      return reverse ? [ res[1], res[0], res[3], res[2], res[4] ] : res
    else
      let ctermfg = s:get_syn(a:group, 'fg', 'cterm')
      let ctermbg = s:get_syn(a:group, 'bg', 'cterm')
      let guifg = s:get_syn(a:group, 'fg', 'gui')
      let guibg = s:get_syn(a:group, 'bg', 'gui')
      let bold = synIDattr(synIDtrans(hlID(a:group)), 'bold')
      if reverse
        let res = s:get_array(guibg, guifg, ctermbg, ctermfg, bold ? ['bold'] : a:000)
      else
        let res = s:get_array(guifg, guibg, ctermfg, ctermbg, bold ? ['bold'] : a:000)
      endif
    endif
    let s:hl_groups[a:group] = res
    return res
  endfunction

  function! airline#highlighter#get_highlight2(fg, bg, ...) abort
    let guifg = s:get_syn(a:fg[0], a:fg[1], 'gui')
    let guibg = s:get_syn(a:bg[0], a:bg[1], 'gui')
    let ctermfg = s:get_syn(a:fg[0], a:fg[1], 'cterm')
    let ctermbg = s:get_syn(a:bg[0], a:bg[1], 'cterm')
    return s:get_array(guifg, guibg, ctermfg, ctermbg, a:000)
  endfunction

  function! s:hl_group_exists(group) abort
    if !hlexists(a:group)
      return 0
    elseif empty(synIDattr(synIDtrans(hlID(a:group)), 'fg'))
      return 0
    endif
    return 1
  endfunction

  function! s:CheckDefined(colors) abort
    " Checks, whether the definition of the colors is valid and is not empty or NONE
    " e.g. if the colors would expand to this:
    " hi airline_c ctermfg=NONE ctermbg=NONE
    " that means to clear that highlighting group, therefore, fallback to Normal
    " highlighting group for the cterm values

    " This only works, if the Normal highlighting group is actually defined, so
    " return early, if it has been cleared
    if !exists("g:airline#highlighter#normal_fg_hi")
      let g:airline#highlighter#normal_fg_hi = synIDattr(synIDtrans(hlID('Normal')), 'fg', 'cterm')
    endif
    if empty(g:airline#highlighter#normal_fg_hi) || g:airline#highlighter#normal_fg_hi < 0
      return a:colors
    endif

    for val in a:colors
      if !empty(val) && val !=# 'NONE'
        return a:colors
      endif
    endfor
    " this adds the bold attribute to the term argument of the :hi command,
    " but at least this makes sure, the group will be defined
    let fg = g:airline#highlighter#normal_fg_hi
    let bg = synIDattr(synIDtrans(hlID('Normal')), 'bg', 'cterm')
    if empty(bg) || bg < 0
      " in case there is no background color defined for Normal
      let bg = a:colors[3]
    endif
    return a:colors[0:1] + [fg, bg] + [a:colors[4]]
  endfunction

  function! s:GetHiCmd(list) abort
    " a:list needs to have 5 items!
    let res = ''
    let i = -1
    while i < 4
      let i += 1
      let item = get(a:list, i, '')
      if item is ''
        continue
      endif
      if i == 0
        let res .= ' guifg='.item
      elseif i == 1
        let res .= ' guibg='.item
      elseif i == 2
        let res .= ' ctermfg='.item
      elseif i == 3
        let res .= ' ctermbg='.item
      elseif i == 4
        let res .= printf(' gui=%s cterm=%s term=%s', item, item, item)
      endif
    endwhile
    return res
  endfunction

  function! airline#highlighter#load_theme() abort
    if pumvisible()
      return
    endif
    for winnr in filter(range(1, winnr('$')), 'v:val != winnr()')
      call airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
    endfor
    call airline#highlighter#highlight(['inactive'])
    if getbufvar( bufnr('%'), '&modified'  ) && &buftype != 'terminal'
      call airline#highlighter#highlight(['normal', 'modified'])
    else
      call airline#highlighter#highlight(['normal'])
    endif
  endfunction

  function! airline#highlighter#add_accent(accent) abort
    let s:accents[a:accent] = 1
  endfunction

  function! airline#highlighter#add_separator(from, to, inverse) abort
    let s:separators[a:from.a:to] = [a:from, a:to, a:inverse]
    call <sid>exec_separator({}, a:from, a:to, a:inverse, '')
  endfunction

  function! s:exec_separator(dict, from, to, inverse, suffix) abort
    if pumvisible()
      return
    endif
    let group = a:from.'_to_'.a:to.a:suffix
    let l:from = airline#themes#get_highlight(a:from.a:suffix)
    let l:to = airline#themes#get_highlight(a:to.a:suffix)
    if a:inverse
      let colors = [ l:from[1], l:to[1], l:from[3], l:to[3] ]
    else
      let colors = [ l:to[1], l:from[1], l:to[3], l:from[3] ]
    endif
    let a:dict[group] = colors
    call airline#highlighter#exec(group, colors)
  endfunction

  function! airline#highlighter#highlight_modified_inactive(bufnr) abort
    if getbufvar(a:bufnr, '&modified')
      let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c')
            \ ? g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c : []
    else
      let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive.airline_c')
            \ ? g:airline#themes#{g:airline_theme}#palette.inactive.airline_c : []
    endif

    if !empty(colors)
      call airline#highlighter#exec('airline_c'.(a:bufnr).'_inactive', colors)
    endif
  endfunction

  function! airline#highlighter#exec(group, colors) abort
    if pumvisible()
      return
    endif
    let colors = a:colors
    if len(colors) == 4
      call add(colors, '')
    endif
    " colors should always be string values
    let colors = map(copy(colors), 'type(v:val) != type("") ? string(v:val) : v:val')
    if s:is_win32term
      let colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
      let colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
    endif
    let old_hi = airline#highlighter#get_highlight(a:group)
    let new_hi = [colors[0], colors[1], printf('%s', colors[2]), printf('%s', colors[3]), colors[4]]
    let colors = s:CheckDefined(colors)
    if old_hi != new_hi || !s:hl_group_exists(a:group)
      let cmd = printf('hi %s%s', a:group, s:GetHiCmd(colors))
      try
        exe cmd
      catch /^Vim\%((\a\+)\)\=:E421:/ " color definition not found
        let group=matchstr(v:exception, '\w\+\ze=')
        let color=matchstr(v:exception, '=\zs\w\+')
        let cmd=substitute(cmd, color, 'grey', 'g')
        exe cmd
        call airline#util#warning('color definition for group ' . a:group . ' not found, using grey as fallback')
      catch
        call airline#util#warning('Error when running command: '. cmd)
      endtry
      if has_key(s:hl_groups, a:group)
        let s:hl_groups[a:group] = colors
      endif
    endif
  endfunction

  function! airline#highlighter#highlight(modes, ...) abort
    let bufnr = a:0 ? a:1 : ''
    let p = g:airline#themes#{g:airline_theme}#palette

    " draw the base mode, followed by any overrides
    let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
    let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
    let airline_grouplist = []
    let buffers_in_tabpage = sort(tabpagebuflist())
    if exists("*uniq")
      let buffers_in_tabpage = uniq(buffers_in_tabpage)
    endif
    " mapped might be something like ['normal', 'normal_modified']
    " if a group is in both modes available, only define the second
    " that is how this was done previously overwrite the previous definition
    for mode in reverse(mapped)
      if exists('g:airline#themes#{g:airline_theme}#palette[mode]')
        let dict = g:airline#themes#{g:airline_theme}#palette[mode]
        for kvp in items(dict)
          let mode_colors = kvp[1]
          let name = kvp[0]
          if name is# 'airline_c' && !empty(bufnr) && suffix is# '_inactive'
            let name = 'airline_c'.bufnr
          endif
          " do not re-create highlighting for buffers that are no longer visible
          " in the current tabpage
          if name =~# 'airline_c\d\+'
            let bnr = matchstr(name, 'airline_c\zs\d\+') + 0
            if bnr > 0 && index(buffers_in_tabpage, bnr) == -1
              continue
            endif
          elseif (name =~# '_to_') || (name[0:10] is# 'airline_tab' && !empty(suffix))
            " group will be redefined below at exec_separator
            " or is not needed for tabline with '_inactive' suffix
            " since active flag is 1 for builder)
            continue
          endif
          if s:group_not_done(airline_grouplist, name.suffix)
            call airline#highlighter#exec(name.suffix, mode_colors)
          endif

          if !has_key(p, 'accents')
            " work around a broken installation
            " shouldn't actually happen, p should always contain accents
            continue
          endif

          for accent in keys(s:accents)
            if !has_key(p.accents, accent)
              continue
            endif
            let colors = copy(mode_colors)
            if p.accents[accent][0] != ''
              let colors[0] = p.accents[accent][0]
            endif
            if p.accents[accent][2] != ''
              let colors[2] = p.accents[accent][2]
            endif
            if len(colors) >= 5
              let colors[4] = get(p.accents[accent], 4, '')
            else
              call add(colors, get(p.accents[accent], 4, ''))
            endif
            if s:group_not_done(airline_grouplist, name.suffix.'_'.accent)
              call airline#highlighter#exec(name.suffix.'_'.accent, colors)
            endif
          endfor
        endfor

        if empty(s:separators)
          " nothing to be done
          continue
        endif
        " TODO: optimize this
        for sep in items(s:separators)
          " we cannot check, that the group already exists, else the separators
          " might not be correctly defined. But perhaps we can skip above groups
          " that match the '_to_' name, because they would be redefined here...
          call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
        endfor
      endif
    endfor
  endfunction

  " End legacy VimScript
  finish

else

  " This is using Vim9 script

  def s:gui2cui(rgb: string, fallback: string): string
    if empty(rgb)
      return fallback
    elseif match(rgb, '^\%(NONE\|[fb]g\)$') > -1
      return rgb
    elseif rgb !~ '#'
      # rgb contains colorname
      return rgb
    endif
    var _rgb = []
    _rgb = mapnew(split(rgb[1 : ], '..\zs'), (_, v) => ('0x' .. v)->str2nr(16))
    return airline#msdos#round_msdos_colors(_rgb)
  enddef

  def s:group_not_done(list: list<string>, name: string): bool
    if index(list, name) == -1
      add(list, name)
      return true
    else
      if &vbs
        echomsg printf("airline: group: %s already done, skipping", name)
      endif
      return false
    endif
  enddef

  def s:get_syn(group: string, what: string, mode: string): string
    var color = ''
    if hlexists(group)
      color = hlID(group)->synIDtrans()->synIDattr(what, mode)
    endif
    if empty(color) || str2nr(color) == -1
      # Normal highlighting group should always exist
      color = hlID('Normal')->synIDtrans()->synIDattr(what, mode)
      # however, just in case
      if empty(color) || str2nr(color) == -1
        color = 'NONE'
      endif
    endif
    return color
  enddef

  def s:get_array(guifg: string, guibg: string, ctermfg: string, ctermbg: string, opts: list<string>): list<string>
    return [ guifg, guibg, ctermfg, ctermbg, empty(opts) ? '' : join(opts, ',') ]
  enddef

  def airline#highlighter#reset_hlcache(): void
    s:hl_groups = {}
  enddef

  def airline#highlighter#get_highlight(group: string, rest: list<string> = ['']): list<string>
    # only check for the cterm reverse attribute
    # TODO: do we need to check all modes (gui, term, as well)?
    var reverse = false
    var bold = false
    var property: string
    var res = []
    var ctermfg: string
    var ctermbg: string
    var guifg: string
    var guibg: string
    property = hlID(group)->synIDtrans()->synIDattr('reverse', 'cterm')
    if !empty(property) && property->str2nr()
      reverse = true
    endif
    if get(g:, 'airline_highlighting_cache', 0) && has_key(s:hl_groups, group)
      res = s:hl_groups[group]
      return reverse ? [ res[1], res[0], res[3], res[2], res[4] ] : res
    else
      ctermfg = s:get_syn(group, 'fg', 'cterm')
      ctermbg = s:get_syn(group, 'bg', 'cterm')
      guifg = s:get_syn(group, 'fg', 'gui')
      guibg = s:get_syn(group, 'bg', 'gui')
      property = hlID(group)->synIDtrans()->synIDattr('bold')
      if !empty(property) && property->str2nr()
        bold = true
      endif
      if reverse
        res = s:get_array(guibg, guifg, ctermbg, ctermfg, bold ? ['bold'] : rest)
      else
        res = s:get_array(guifg, guibg, ctermfg, ctermbg, bold ? ['bold'] : rest)
      endif
    endif
    s:hl_groups[group] = res
    return res
  enddef

  def airline#highlighter#get_highlight2(fg: list<string>, bg: list<string>, ...rest: list<string>): list<string>
    var guifg = s:get_syn(fg[0], fg[1], 'gui')
    var guibg = s:get_syn(bg[0], bg[1], 'gui')
    var ctermfg = s:get_syn(fg[0], fg[1], 'cterm')
    var ctermbg = s:get_syn(bg[0], bg[1], 'cterm')
    return s:get_array(guifg, guibg, ctermfg, ctermbg, filter(rest, (_, v) => !empty(v)))
  enddef

  def s:hl_group_exists(group: string): bool
    if !hlexists(group)
      return false
    elseif hlID(group)->synIDtrans()->synIDattr('fg')->empty()
      return false
    endif
    return true
  enddef

  def s:CheckDefined(colors: list<any>): list<any>
    # Checks, whether the definition of the colors is valid and is not empty or NONE
    # e.g. if the colors would expand to this:
    # hi airline_c ctermfg=NONE ctermbg=NONE
    # that means to clear that highlighting group, therefore, fallback to Normal
    # highlighting group for the cterm values

    # This only works, if the Normal highlighting group is actually defined,
    # so return early, if it has been cleared
    if !exists("g:airline#highlighter#normal_fg_hi")
      g:airline#highlighter#normal_fg_hi = hlID('Normal')->synIDtrans()->synIDattr('fg', 'cterm')
    endif
    if empty(g:airline#highlighter#normal_fg_hi) || str2nr(g:airline#highlighter#normal_fg_hi) < 0
      return colors
    endif

    for val in colors
      if !empty(val) && val !=# 'NONE'
        return colors
      endif
    endfor
    # this adds the bold attribute to the term argument of the :hi command,
    # but at least this makes sure, the group will be defined
    var fg = g:airline#highlighter#normal_fg_hi
    var bg = hlID('Normal')->synIDtrans()->synIDattr('bg', 'cterm')
    if empty(bg) || str2nr(bg) < 0
      # in case there is no background color defined for Normal
      bg = colors[3]
    endif
    return colors[ 0 : 1 ] + [fg, bg] + [colors[4]]
  enddef

  def s:GetHiCmd(list: list<string>): string
    # list needs to have 5 items!
    var res: string
    var i = -1
    var item: string
    while i < 4
      i += 1
      item = get(list, i, '')
      if item is ''
        continue
      endif
      if i == 0
        res ..= ' guifg=' .. item
      elseif i == 1
        res ..= ' guibg=' .. item
      elseif i == 2
        res ..= ' ctermfg=' .. item
      elseif i == 3
        res ..= ' ctermbg=' .. item
      elseif i == 4
        res ..= printf(' gui=%s cterm=%s term=%s', item, item, item)
      endif
    endwhile
    return res
  enddef

  def airline#highlighter#load_theme(): void
    if pumvisible()
      return
    endif
    for winnr in filter(range(1, winnr('$')), (_, v) => v != winnr())
      airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
    endfor
    airline#highlighter#highlight(['inactive'])
    if getbufvar( bufnr('%'), '&modified'  ) && &buftype != 'terminal'
      airline#highlighter#highlight(['normal', 'modified'])
    else
      airline#highlighter#highlight(['normal'])
    endif
  enddef

  def airline#highlighter#add_accent(accent: string): void
    s:accents[accent] = 1
  enddef

  def airline#highlighter#add_separator(from: string, to: string, inverse: bool): void
    s:separators[from .. to] = [from, to, inverse]
    s:exec_separator({}, from, to, inverse, '')
  enddef

  def s:exec_separator(dict: dict<any>, from_arg: string, to_arg: string, inverse: bool, suffix: string): void
    if pumvisible()
      return
    endif
    var group = from_arg .. '_to_' .. to_arg .. suffix
    var from = mapnew(airline#themes#get_highlight(from_arg .. suffix), (_, v) => type(v) != type('') ? string(v) : v)
    var colors = []
    var to = mapnew(airline#themes#get_highlight(to_arg .. suffix), (_, v) => type(v) != type('') ? string(v) : v)
    if inverse
      colors = [ from[1], to[1], from[3], to[3] ]
    else
      colors = [ to[1], from[1], to[3], from[3] ]
    endif
    dict[group] = colors
    airline#highlighter#exec(group, colors)
  enddef

  def airline#highlighter#highlight_modified_inactive(bufnr: number): void
    var colors: list<any>
    var dict1  = eval('g:airline#themes#' .. g:airline_theme .. '#palette')->get('inactive_modified', {})
    var dict2  = eval('g:airline#themes#' .. g:airline_theme .. '#palette')->get('inactive', {})

    if empty(dict2)
      return
    endif

    if getbufvar(bufnr, '&modified')
      colors = get(dict1, 'airline_c', [])
    else
      colors = get(dict2, 'airline_c', [])
    endif
    if !empty(colors)
      airline#highlighter#exec('airline_c' .. bufnr .. '_inactive', colors)
    endif
  enddef

  def airline#highlighter#exec(group: string, clrs: list<any>): void
    if pumvisible()
      return
    endif
    var colors: list<string> = mapnew(copy(clrs), (_, v) => type(v) != type('') ? string(v) : v)
    if len(colors) == 4
      add(colors, '')
    endif
    if s:is_win32term
      colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
      colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
    endif
    var old_hi: list<string> = airline#highlighter#get_highlight(group)
    var new_hi: list<string> = colors
    if old_hi != new_hi || !s:hl_group_exists(group)
      var cmd = printf('hi %s%s', group, s:GetHiCmd(colors))
      try
        :exe cmd
      catch /^Vim\%((\a\+)\)\=:E421:/
        var grp = matchstr(v:exception, '\w\+\ze=')
        var clr = matchstr(v:exception, '=\zs\w\+')
        cmd = substitute(cmd, clr, 'grey', 'g')
        :exe cmd
        airline#util#warning('color ' .. clr .. ' definition for group ' .. grp .. ' not found, using grey as fallback')
      catch
        airline#util#warning('Error when running command: ' .. cmd)
      endtry
      if has_key(s:hl_groups, group)
        s:hl_groups[group] = colors
      endif
    endif
  enddef

  def airline#highlighter#highlight(modes: list<string>, bufnr: string = ''): void
    var p: dict<any> = eval('g:airline#themes#' .. g:airline_theme .. '#palette')

    # draw the base mode, followed by any overrides
    var mapped = map(modes, (_, v) => v == modes[0] ? v : modes[0] .. "_" .. v)
    var suffix = ''
    if modes[0] == 'inactive'
      suffix = '_inactive'
    endif
    var airline_grouplist = []
    var dict: dict<any>
    var bnr: number = 0

    var buffers_in_tabpage: list<number> = uniq(sort(tabpagebuflist()))
    # mapped might be something like ['normal', 'normal_modified']
    # if a group is in both modes available, only define the second
    # that is how this was done previously overwrite the previous definition
    for mode in reverse(mapped)
      if exists('g:airline#themes#' .. g:airline_theme .. '#palette.' .. mode)
        dict = eval('g:airline#themes#' .. g:airline_theme .. '#palette.' .. mode)
        for kvp in items(dict)
          var mode_colors = kvp[1]
          var name = kvp[0]
          if name == 'airline_c' && !empty(bufnr) && suffix == '_inactive'
            name = 'airline_c' .. bufnr
          endif
          # do not re-create highlighting for buffers that are no longer visible
          # in the current tabpage
          if name =~# 'airline_c\d\+'
            bnr = matchstr(name, 'airline_c\zs\d\+')->str2nr()
            if bnr > 0 && index(buffers_in_tabpage, bnr) == -1
              continue
            endif
          elseif (name =~ '_to_') || (name[ 0 : 10 ] == 'airline_tab' && !empty(suffix))
            # group will be redefined below at exec_separator
            # or is not needed for tabline with '_inactive' suffix
            # since active flag is 1 for builder)
            continue
          endif
          if s:group_not_done(airline_grouplist, name .. suffix)
            airline#highlighter#exec(name .. suffix, mode_colors)
          endif

          if !has_key(p, 'accents')
            # shouldn't actually happen, p should always contain accents
            continue
          endif

          for accent in keys(s:accents)
            if !has_key(p.accents, accent)
              continue
            endif
            var colors = copy(mode_colors)
            if p.accents[accent][0] != ''
                colors[0] = p.accents[accent][0]
            endif
            if type(get(p.accents[accent], 2, '')) == type('')
              colors[2] = get(p.accents[accent], 2, '')
            else
              colors[2] = string(p.accents[accent][2])
            endif
            if len(colors) >= 5
              colors[4] = get(p.accents[accent], 4, '')
            else
              add(colors, get(p.accents[accent], 4, ''))
            endif
            if s:group_not_done(airline_grouplist, name .. suffix .. '_' .. accent)
              airline#highlighter#exec(name .. suffix .. '_' .. accent, colors)
            endif
          endfor
        endfor

        if empty(s:separators)
          continue
        endif
        for sep in items(s:separators)
          # we cannot check, that the group already exists, else the separators
          # might not be correctly defined. But perhaps we can skip above groups
          # that match the '_to_' name, because they would be redefined here...
          s:exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
        endfor
      endif
    endfor
	enddef
endif
./autoload/airline/init.vim	[[[1
288
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! s:check_defined(variable, default)
  if !exists(a:variable)
    let {a:variable} = a:default
  endif
endfunction

let s:loaded = 0
function! airline#init#bootstrap()
  if s:loaded
    return
  endif
  let s:loaded = 1

  let g:airline#init#bootstrapping = 1

  let g:airline#init#vim_async = (v:version >= 800 && has('job'))
  let g:airline#init#is_windows = has('win32') || has('win64')

  call s:check_defined('g:airline_detect_modified', 1)
  call s:check_defined('g:airline_detect_paste', 1)
  call s:check_defined('g:airline_detect_crypt', 1)
  call s:check_defined('g:airline_detect_spell', 1)
  call s:check_defined('g:airline_detect_spelllang', 1)
  call s:check_defined('g:airline_detect_iminsert', 0)
  call s:check_defined('g:airline_inactive_collapse', 1)
  call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
  call s:check_defined('g:airline_exclude_filetypes', [])
  call s:check_defined('g:airline_exclude_preview', 0)

  " If g:airline_mode_map_codes is set to 1 in your .vimrc it will display
  " only the modes' codes in the status line. Refer :help mode() for codes.
  " That may be a preferred presentation because it is minimalistic.
  call s:check_defined('g:airline_mode_map_codes', 0)
  call s:check_defined('g:airline_mode_map', {})

  if g:airline_mode_map_codes != 1
    " If you prefer different mode names than those below they can be
    " customised by inclusion in your .vimrc - for example, including just:
    " let g:airline_mode_map = {
    "    \ 'Rv' : 'VIRTUAL REPLACE',
    "    \ 'niV' : 'VIRTUAL REPLACE (NORMAL)',
    "    \ }
    " ...would override 'Rv' and 'niV' below respectively.
    call extend(g:airline_mode_map, {
        \ '__' : '------',
        \ 'n' : 'NORMAL',
        \ 'no' : 'OP PENDING',
        \ 'nov' : 'OP PENDING CHAR',
        \ 'noV' : 'OP PENDING LINE',
        \ 'no' : 'OP PENDING BLOCK',
        \ 'niI' : 'INSERT (NORMAL)',
        \ 'niR' : 'REPLACE (NORMAL)',
        \ 'niV' : 'V REPLACE (NORMAL)',
        \ 'v' : 'VISUAL',
        \ 'V' : 'V-LINE',
        \ '' : 'V-BLOCK',
        \ 's' : 'SELECT',
        \ 'S' : 'S-LINE',
        \ '' : 'S-BLOCK',
        \ 'i' : 'INSERT',
        \ 'ic' : 'INSERT COMPL GENERIC',
        \ 'ix' : 'INSERT COMPL',
        \ 'R' : 'REPLACE',
        \ 'Rc' : 'REPLACE COMP GENERIC',
        \ 'Rv' : 'V REPLACE',
        \ 'Rx' : 'REPLACE COMP',
        \ 'c'  : 'COMMAND',
        \ 'cv'  : 'VIM EX',
        \ 'ce'  : 'EX',
        \ 'r'  : 'PROMPT',
        \ 'rm'  : 'MORE PROMPT',
        \ 'r?'  : 'CONFIRM',
        \ '!'  : 'SHELL',
        \ 't'  : 'TERMINAL',
        \ 'multi' : 'MULTI',
        \ }, 'keep')
        " NB: no*, cv, ce, r? and ! do not actually display
  else
    " Exception: The control character in ^S and ^V modes' codes
    " break the status line if allowed to render 'naturally' so
    " they are overridden with ^ (when g:airline_mode_map_codes = 1)
    call extend(g:airline_mode_map, {
        \ '' : '^V',
        \ '' : '^S',
        \ }, 'keep')
  endif

  call s:check_defined('g:airline_theme_map', {})
  call extend(g:airline_theme_map, {
        \ 'default': 'dark',
        \ '\CTomorrow': 'tomorrow',
        \ 'base16': 'base16',
        \ 'mo[l|n]okai': 'molokai',
        \ 'wombat': 'wombat',
        \ 'zenburn': 'zenburn',
        \ 'solarized': 'solarized',
        \ 'flattened': 'solarized',
        \ '\CNeoSolarized': 'solarized',
        \ }, 'keep')

  call s:check_defined('g:airline_symbols', {})
  " First define the symbols,
  " that are common in Powerline/Unicode/ASCII mode,
  " then add specific symbols for either mode
  call extend(g:airline_symbols, {
          \ 'paste': 'PASTE',
          \ 'spell': 'SPELL',
          \ 'modified': '+',
          \ 'space': ' ',
          \ 'keymap': 'Keymap:',
          \ 'ellipsis': '...'
          \  }, 'keep')

  if get(g:, 'airline_powerline_fonts', 0)
    " Symbols for Powerline terminals
    call s:check_defined('g:airline_left_sep', "\ue0b0")      " 
    call s:check_defined('g:airline_left_alt_sep', "\ue0b1")  " 
    call s:check_defined('g:airline_right_sep', "\ue0b2")     " 
    call s:check_defined('g:airline_right_alt_sep', "\ue0b3") " 
    " ro=, ws=☲, lnr=, mlnr=☰, colnr=℅, br=, nx=Ɇ, crypt=🔒, dirty=⚡
    "  Note: For powerline, we add an extra space after maxlinenr symbol,
    "  because it is usually setup as a ligature in most powerline patched
    "  fonts. It can be over-ridden by configuring a custom maxlinenr
    call extend(g:airline_symbols, {
          \ 'readonly': "\ue0a2",
          \ 'whitespace': "\u2632",
          \ 'maxlinenr': "\u2630 ",
          \ 'linenr': " \ue0a1:",
          \ 'colnr': " \u2105:",
          \ 'branch': "\ue0a0",
          \ 'notexists': "\u0246",
          \ 'dirty': "\u26a1",
          \ 'crypt': nr2char(0x1F512),
          \ }, 'keep')
    "  Note: If "\u2046" (Ɇ) does not show up, try to use "\u2204" (∄)
  elseif &encoding==?'utf-8' && !get(g:, "airline_symbols_ascii", 0)
    " Symbols for Unicode terminals
    call s:check_defined('g:airline_left_sep', "")
    call s:check_defined('g:airline_left_alt_sep', "")
    call s:check_defined('g:airline_right_sep', "")
    call s:check_defined('g:airline_right_alt_sep', "")
    " ro=⊝, ws=☲, lnr=㏑, mlnr=☰, colnr=℅, br=ᚠ, nx=Ɇ, crypt=🔒
    call extend(g:airline_symbols, {
          \ 'readonly': "\u229D",
          \ 'whitespace': "\u2632",
          \ 'maxlinenr': "\u2630",
          \ 'linenr': " \u33d1:",
          \ 'colnr': " \u2105:",
          \ 'branch': "\u16A0",
          \ 'notexists': "\u0246",
          \ 'crypt': nr2char(0x1F512),
          \ 'dirty': '!',
          \ }, 'keep')
  else
    " Symbols for ASCII terminals
    call s:check_defined('g:airline_left_sep', "")
    call s:check_defined('g:airline_left_alt_sep', "")
    call s:check_defined('g:airline_right_sep', "")
    call s:check_defined('g:airline_right_alt_sep', "")
    call extend(g:airline_symbols, {
          \ 'readonly': 'RO',
          \ 'whitespace': '!',
          \ 'linenr': ' ln:',
          \ 'maxlinenr': '',
          \ 'colnr': ' cn:',
          \ 'branch': '',
          \ 'notexists': '?',
          \ 'crypt': 'cr',
          \ 'dirty': '!',
          \ }, 'keep')
  endif

  call airline#parts#define('mode', {
        \ 'function': 'airline#parts#mode',
        \ 'accent': 'bold',
        \ })
  call airline#parts#define_function('iminsert', 'airline#parts#iminsert')
  call airline#parts#define_function('paste', 'airline#parts#paste')
  call airline#parts#define_function('crypt', 'airline#parts#crypt')
  call airline#parts#define_function('spell', 'airline#parts#spell')
  call airline#parts#define_function('filetype', 'airline#parts#filetype')
  call airline#parts#define('readonly', {
        \ 'function': 'airline#parts#readonly',
        \ 'accent': 'red',
        \ })
  if get(g:, 'airline_section_c_only_filename',0)
    call airline#parts#define_raw('file', '%t%m')
  else
    call airline#parts#define_raw('file', airline#formatter#short_path#format('%f%m'))
  endif
  call airline#parts#define_raw('path', '%F%m')
  call airline#parts#define('linenr', {
        \ 'raw': '%{g:airline_symbols.linenr}%l',
        \ 'accent': 'bold'})
  call airline#parts#define('maxlinenr', {
        \ 'raw': '/%L%{g:airline_symbols.maxlinenr}',
        \ 'accent': 'bold'})
  call airline#parts#define('colnr', {
        \ 'raw': '%{g:airline_symbols.colnr}%v',
        \ 'accent': 'bold'})
  call airline#parts#define_function('ffenc', 'airline#parts#ffenc')
  call airline#parts#define('hunks', {
        \ 'raw': '',
        \ 'minwidth': 100})
  call airline#parts#define('branch', {
        \ 'raw': '',
        \ 'minwidth': 80})
  call airline#parts#define('coc_status', {
        \ 'raw': '',
        \ 'accent': 'bold'
        \ })
  call airline#parts#define('coc_current_function', {
        \ 'raw': '',
        \ 'accent': 'bold'
        \ })
  call airline#parts#define('lsp_progress', {
        \ 'raw': '',
        \ 'accent': 'bold'
        \ })
  call airline#parts#define_empty(['obsession', 'tagbar', 'syntastic-warn',
        \ 'syntastic-err', 'eclim', 'whitespace','windowswap', 'taglist',
        \ 'ycm_error_count', 'ycm_warning_count', 'neomake_error_count',
        \ 'neomake_warning_count', 'ale_error_count', 'ale_warning_count',
        \ 'lsp_error_count', 'lsp_warning_count', 'scrollbar',
        \ 'nvimlsp_error_count', 'nvimlsp_warning_count',
        \ 'vim9lsp_warning_count', 'vim9lsp_error_count',
        \ 'languageclient_error_count', 'languageclient_warning_count',
        \ 'coc_warning_count', 'coc_error_count', 'vista', 'battery'])

  call airline#parts#define_text('bookmark', '')
  call airline#parts#define_text('capslock', '')
  call airline#parts#define_text('gutentags', '')
  call airline#parts#define_text('gen_tags', '')
  call airline#parts#define_text('grepper', '')
  call airline#parts#define_text('xkblayout', '')
  call airline#parts#define_text('keymap', '')
  call airline#parts#define_text('omnisharp', '')

  unlet g:airline#init#bootstrapping
endfunction

function! airline#init#sections()
  let spc = g:airline_symbols.space
  if !exists('g:airline_section_a')
    let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'keymap', 'spell', 'capslock', 'xkblayout', 'iminsert'])
  endif
  if !exists('g:airline_section_b')
    if airline#util#winwidth() > 99
      let g:airline_section_b = airline#section#create(['hunks', 'branch', 'battery'])
    else
      let g:airline_section_b = airline#section#create(['hunks', 'branch'])
    endif
  endif
  if !exists('g:airline_section_c')
    if exists("+autochdir") && &autochdir == 1
      let g:airline_section_c = airline#section#create(['%<', 'path', spc, 'readonly', 'coc_status', 'lsp_progress'])
    else
      let g:airline_section_c = airline#section#create(['%<', 'file', spc, 'readonly', 'coc_status', 'lsp_progress'])
    endif
  endif
  if !exists('g:airline_section_gutter')
    let g:airline_section_gutter = airline#section#create(['%='])
  endif
  if !exists('g:airline_section_x')
    let g:airline_section_x = airline#section#create_right(['coc_current_function', 'bookmark', 'scrollbar', 'tagbar', 'taglist', 'vista', 'gutentags', 'gen_tags', 'omnisharp', 'grepper', 'filetype'])
  endif
  if !exists('g:airline_section_y')
    let g:airline_section_y = airline#section#create_right(['ffenc'])
  endif
  if !exists('g:airline_section_z')
    if airline#util#winwidth() > 79
      let g:airline_section_z = airline#section#create(['windowswap', 'obsession', '%p%%', 'linenr', 'maxlinenr', 'colnr'])
    else
      let g:airline_section_z = airline#section#create(['%p%%', 'linenr', 'colnr'])
    endif
  endif
  if !exists('g:airline_section_error')
    let g:airline_section_error = airline#section#create(['ycm_error_count', 'syntastic-err', 'eclim', 'neomake_error_count', 'ale_error_count', 'lsp_error_count', 'nvimlsp_error_count', 'languageclient_error_count', 'coc_error_count', 'vim9lsp_error_count'])
  endif
  if !exists('g:airline_section_warning')
    let g:airline_section_warning = airline#section#create(['ycm_warning_count',  'syntastic-warn', 'neomake_warning_count', 'ale_warning_count', 'lsp_warning_count', 'nvimlsp_warning_count', 'languageclient_warning_count', 'whitespace', 'coc_warning_count', 'vim9lsp_warning_count'])
  endif
endfunction
./autoload/airline/msdos.vim	[[[1
83
" MIT License. Copyright (c) 2013-2021 Bailey Ling Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

" basic 16 msdos from MSDOS
" see output of color, should be
"     0    Black
"     1    DarkBlue
"     2    DarkGreen
"     3    DarkCyan
"     4    DarkRed
"     5    DarkMagenta
"     6    Brown
"     7    LightGray
"     8    DarkGray
"     9    Blue
"     10   Green
"     11   Cyan
"     12   Red
"     13   Magenta
"     14   Yellow
"     15   White

let s:basic16 = [
  \ [ 0x00, 0x00, 0x00 ],
  \ [ 0x00, 0x00, 0x80 ],
  \ [ 0x00, 0x80, 0x00 ],
  \ [ 0x00, 0x80, 0x80 ],
  \ [ 0x80, 0x00, 0x00 ],
  \ [ 0x80, 0x00, 0x80 ],
  \ [ 0x80, 0x80, 0x00 ],
  \ [ 0xC0, 0xC0, 0xC0 ],
  \ [ 0x80, 0x80, 0x80 ],
  \ [ 0x00, 0x00, 0xFF ],
  \ [ 0x00, 0xFF, 0x00 ],
  \ [ 0x00, 0xFF, 0xFF ],
  \ [ 0xFF, 0x00, 0x00 ],
  \ [ 0xFF, 0x00, 0xFF ],
  \ [ 0xFF, 0xFF, 0x00 ],
  \ [ 0xFF, 0xFF, 0xFF ]
  \ ]

if !exists(":def") || !airline#util#has_vim9_script()

	function! airline#msdos#round_msdos_colors(rgblist)
		" Check for values from MSDOS 16 color terminal
		let best = []
		let min  = 100000
		let list = s:basic16
		for value in list
			let t = abs(value[0] - a:rgblist[0]) +
						\ abs(value[1] - a:rgblist[1]) +
						\ abs(value[2] - a:rgblist[2])
			if min > t
				let min = t
				let best = value
			endif
		endfor
		return index(s:basic16, best)
	endfunction

	finish

else

  def airline#msdos#round_msdos_colors(rgblist: list<number>): string
    # Check for values from MSDOS 16 color terminal
    var best = []
    var min  = 100000
    var t = 0
    for value in s:basic16
      t = abs(value[0] - rgblist[0]) +
          abs(value[1] - rgblist[1]) +
          abs(value[2] - rgblist[2])
      if min > t
        min = t
        best = value
      endif
    endfor
    return string(index(s:basic16, best))
  enddef
endif
./autoload/airline/parts.vim	[[[1
208
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:parts = {}

" PUBLIC API {{{

function! airline#parts#define(key, config)
  let s:parts[a:key] = get(s:parts, a:key, {})
  if exists('g:airline#init#bootstrapping')
    call extend(s:parts[a:key], a:config, 'keep')
  else
    call extend(s:parts[a:key], a:config, 'force')
  endif
endfunction

function! airline#parts#define_function(key, name)
  call airline#parts#define(a:key, { 'function': a:name })
endfunction

function! airline#parts#define_text(key, text)
  call airline#parts#define(a:key, { 'text': a:text })
endfunction

function! airline#parts#define_raw(key, raw)
  call airline#parts#define(a:key, { 'raw': a:raw })
endfunction

function! airline#parts#define_minwidth(key, width)
  call airline#parts#define(a:key, { 'minwidth': a:width })
endfunction

function! airline#parts#define_condition(key, predicate)
  call airline#parts#define(a:key, { 'condition': a:predicate })
endfunction

function! airline#parts#define_accent(key, accent)
  call airline#parts#define(a:key, { 'accent': a:accent })
endfunction

function! airline#parts#define_empty(keys)
  for key in a:keys
    call airline#parts#define_raw(key, '')
  endfor
endfunction

function! airline#parts#get(key)
  return get(s:parts, a:key, {})
endfunction

" }}}

function! airline#parts#mode()
  let part = airline#parts#get('mode')
  let minwidth = get(part, 'minwidth', 79)
  return airline#util#shorten(get(w:, 'airline_current_mode', ''), minwidth, 1)
endfunction

function! airline#parts#crypt()
  return g:airline_detect_crypt && exists("+key") && !empty(&key) ? g:airline_symbols.crypt : ''
endfunction

function! airline#parts#paste()
  return g:airline_detect_paste && &paste ? g:airline_symbols.paste : ''
endfunction

" Sources:
" https://ftp.nluug.nl/pub/vim/runtime/spell/
" https://en.wikipedia.org/wiki/Regional_indicator_symbol
let s:flags = {
                  \ 'af_za': '🇿🇦[af]',
                  \ 'am_et': '🇭🇺[am]',
                  \ 'bg_bg': '🇧🇬',
                  \ 'br_fr': '🇫🇷[br]',
                  \ 'ca_es': '🇪🇸[ca]',
                  \ 'cs_cz': '🇨🇿',
                  \ 'cy_gb': '🇬🇧[cy]',
                  \ 'da_dk': '🇩🇰',
                  \ 'de'   : '🇩🇪',
                  \ 'de_19': '🇩🇪[19]',
                  \ 'de_20': '🇩🇪[20]',
                  \ 'de_at': '🇩🇪[at]',
                  \ 'de_ch': '🇩🇪[ch]',
                  \ 'de_de': '🇩🇪',
                  \ 'el_gr': '🇬🇷',
                  \ 'en':    '🇬🇧',
                  \ 'en_au': '🇦🇺',
                  \ 'en_ca': '🇨🇦',
                  \ 'en_gb': '🇬🇧',
                  \ 'en_nz': '🇳🇿',
                  \ 'en_us': '🇺🇸',
                  \ 'es':    '🇪🇸',
                  \ 'es_es': '🇪🇸',
                  \ 'es_mx': '🇲🇽',
                  \ 'fo_fo': '🇫🇴',
                  \ 'fr_fr': '🇫🇷',
                  \ 'ga_ie': '🇮🇪',
                  \ 'gd_gb': '🇬🇧[gd]',
                  \ 'gl_es': '🇪🇸[gl]',
                  \ 'he_il': '🇮🇱',
                  \ 'hr_hr': '🇭🇷',
                  \ 'hu_hu': '🇭🇺',
                  \ 'id_id': '🇮🇩',
                  \ 'it_it': '🇮🇹',
                  \ 'ku_tr': '🇹🇷[ku]',
                  \ 'la'   : '🇮🇹[la]',
                  \ 'lt_lt': '🇱🇹',
                  \ 'lv_lv': '🇱🇻',
                  \ 'mg_mg': '🇲🇬',
                  \ 'mi_nz': '🇳🇿[mi]',
                  \ 'ms_my': '🇲🇾',
                  \ 'nb_no': '🇳🇴',
                  \ 'nl_nl': '🇳🇱',
                  \ 'nn_no': '🇳🇴[ny]',
                  \ 'ny_mw': '🇲🇼',
                  \ 'pl_pl': '🇵🇱',
                  \ 'pt':    '🇵🇹',
                  \ 'pt_br': '🇧🇷',
                  \ 'pt_pt': '🇵🇹',
                  \ 'ro_ro': '🇷🇴',
                  \ 'ru'   : '🇷🇺',
                  \ 'ru_ru': '🇷🇺',
                  \ 'ru_yo': '🇷🇺[yo]',
                  \ 'rw_rw': '🇷🇼',
                  \ 'sk_sk': '🇸🇰',
                  \ 'sl_si': '🇸🇮',
                  \ 'sr_rs': '🇷🇸',
                  \ 'sv_se': '🇸🇪',
                  \ 'sw_ke': '🇰🇪',
                  \ 'tet_id': '🇮🇩[tet]',
                  \ 'th'   : '🇹🇭',
                  \ 'tl_ph': '🇵🇭',
                  \ 'tn_za': '🇿🇦[tn]',
                  \ 'uk_ua': '🇺🇦',
                  \ 'yi'   : '🇻🇮',
                  \ 'yi_tr': '🇹🇷',
                  \ 'zu_za': '🇿🇦[zu]',
      \ }
" Also support spelllang without region codes
let s:flags_noregion = {}
for s:key in keys(s:flags)
  let s:flags_noregion[split(s:key, '_')[0]] = s:flags[s:key]
endfor

function! airline#parts#spell()
  let spelllang = g:airline_detect_spelllang ? printf(" [%s]", toupper(substitute(&spelllang, ',', '/', 'g'))) : ''
  if g:airline_detect_spell && (&spell || (exists('g:airline_spell_check_command') && eval(g:airline_spell_check_command)))

    if g:airline_detect_spelllang !=? '0' && g:airline_detect_spelllang ==? 'flag'
      let spelllang = tolower(&spelllang)
      if has_key(s:flags, spelllang)
        return s:flags[spelllang]
      elseif has_key(s:flags_noregion, spelllang)
        return s:flags_noregion[spelllang]
      endif
    endif

    let winwidth = airline#util#winwidth()
    if winwidth >= 90
      return g:airline_symbols.spell . spelllang
    elseif winwidth >= 70
      return g:airline_symbols.spell
    elseif !empty(g:airline_symbols.spell)
      return split(g:airline_symbols.spell, '\zs')[0]
    endif
  endif
  return ''
endfunction

function! airline#parts#iminsert()
  if g:airline_detect_iminsert && &iminsert && exists('b:keymap_name')
    return toupper(b:keymap_name)
  endif
  return ''
endfunction

function! airline#parts#readonly()
  " only consider regular buffers (e.g. ones that represent actual files,
  " but not special ones like e.g. NERDTree)
  if !empty(&buftype) || airline#util#ignore_buf(bufname('%'))
    return ''
  endif
  if &readonly && !filereadable(bufname('%'))
    return '[noperm]'
  else
    return &readonly ? g:airline_symbols.readonly : ''
  endif
endfunction

function! airline#parts#filetype()
  return (airline#util#winwidth() < 90 && strlen(&filetype) > 3)
        \ ? matchstr(&filetype, '...'). (&encoding is? 'utf-8' ? '…' : '>')
        \ : &filetype
endfunction

function! airline#parts#ffenc()
  let expected = get(g:, 'airline#parts#ffenc#skip_expected_string', '')
  let bomb     = &bomb ? '[BOM]' : ''
  let noeolf   = &eol ? '' : '[!EOL]'
  let ff       = strlen(&ff) ? '['.&ff.']' : ''
  if expected is# &fenc.bomb.noeolf.ff
    return ''
  else
    return &fenc.bomb.noeolf.ff
  endif
endfunction
./autoload/airline/section.vim	[[[1
84
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#init#bootstrap()
let s:spc = g:airline_symbols.space

function! s:wrap_accent(part, value)
  if exists('a:part.accent')
    call airline#highlighter#add_accent(a:part.accent)
    return '%#__accent_'.(a:part.accent).'#'.a:value.'%#__restore__#'
  endif
  return a:value
endfunction

function! s:create(parts, append)
  let _ = ''
  for idx in range(len(a:parts))
    let part = airline#parts#get(a:parts[idx])
    let val = ''
    let add_sep = get(l:, 'add_sep', 0)

    if exists('part.function')
      let func = (part.function).'()'
    elseif exists('part.text')
      let func = '"'.(part.text).'"'
    else
      if a:append > 0 && idx != 0
        let val .= s:spc.g:airline_left_alt_sep.s:spc
      endif
      if a:append < 0 && idx != 0
        let t = ''
        if !add_sep
          let t = s:spc.g:airline_right_alt_sep.s:spc
        endif
        let val = t.val
      endif
      if exists('part.raw')
        let _ .= s:wrap_accent(part, val.(part.raw))
        continue
      else
        let _ .= s:wrap_accent(part, val.a:parts[idx])
        continue
      endif
    endif

    let minwidth = get(part, 'minwidth', 0)

    if a:append > 0 && idx != 0
      let partval = printf('%%{airline#util#append(%s,%s)}', func, minwidth)
      " will add an extra separator, if minwidth is zero
      let add_sep = (minwidth == 0)
    elseif a:append < 0 && idx != len(a:parts) - 1
      let partval = printf('%%{airline#util#prepend(%s,%s)}', func, minwidth)
      " will add an extra separator, if minwidth is zero
      let add_sep = (minwidth == 0)
    else
      let partval = printf('%%{airline#util#wrap(%s,%s)}', func, minwidth)
      let add_sep = 0
    endif

    if exists('part.condition')
      let partval = substitute(partval, '{', '\="{".(part.condition)." ? "', '')
      let partval = substitute(partval, '}', ' : ""}', '')
    endif

    let val .= s:wrap_accent(part, partval)
    let _ .= val
  endfor
  return _
endfunction

function! airline#section#create(parts)
  return s:create(a:parts, 0)
endfunction

function! airline#section#create_left(parts)
  return s:create(a:parts, 1)
endfunction

function! airline#section#create_right(parts)
  return s:create(a:parts, -1)
endfunction
./autoload/airline/themes/dark.vim	[[[1
163
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 tw=80

scriptencoding utf-8

" Airline themes are generated based on the following concepts:
"   * The section of the status line, valid Airline statusline sections are:
"       * airline_a (left most section)
"       * airline_b (section just to the right of airline_a)
"       * airline_c (section just to the right of airline_b)
"       * airline_x (first section of the right most sections)
"       * airline_y (section just to the right of airline_x)
"       * airline_z (right most section)
"   * The mode of the buffer, as reported by the :mode() function.  Airline
"     converts the values reported by mode() to the following:
"       * normal
"       * insert
"       * replace
"       * visual
"       * inactive
"       * terminal
"       The last one is actually no real mode as returned by mode(), but used by
"       airline to style inactive statuslines (e.g. windows, where the cursor
"       currently does not reside in).
"   * In addition to each section and mode specified above, airline themes
"     can also specify overrides.  Overrides can be provided for the following
"     scenarios:
"       * 'modified'
"       * 'paste'
"
" Airline themes are specified as a global viml dictionary using the above
" sections, modes and overrides as keys to the dictionary.  The name of the
" dictionary is significant and should be specified as:
"   * g:airline#themes#<theme_name>#palette
" where <theme_name> is substituted for the name of the theme.vim file where the
" theme definition resides.  Airline themes should reside somewhere on the
" 'runtimepath' where it will be loaded at vim startup, for example:
"   * autoload/airline/themes/theme_name.vim
"
" For this, the dark.vim, theme, this is defined as
let g:airline#themes#dark#palette = {}

" Keys in the dictionary are composed of the mode, and if specified the
" override.  For example:
"   * g:airline#themes#dark#palette.normal
"       * the colors for a statusline while in normal mode
"   * g:airline#themes#dark#palette.normal_modified
"       * the colors for a statusline while in normal mode when the buffer has
"         been modified
"   * g:airline#themes#dark#palette.visual
"       * the colors for a statusline while in visual mode
"
" Values for each dictionary key is an array of color values that should be
" familiar for colorscheme designers:
"   * [guifg, guibg, ctermfg, ctermbg, opts]
" See "help attr-list" for valid values for the "opt" value.
"
" Each theme must provide an array of such values for each airline section of
" the statusline (airline_a through airline_z).  A convenience function,
" airline#themes#generate_color_map() exists to mirror airline_a/b/c to
" airline_x/y/z, respectively.

" The dark.vim theme:
let s:airline_a_normal   = [ '#00005f' , '#dfff00' , 17  , 190 ]
let s:airline_b_normal   = [ '#ffffff' , '#444444' , 255 , 238 ]
let s:airline_c_normal   = [ '#9cffd3' , '#202020' , 85  , 234 ]
let g:airline#themes#dark#palette.normal = airline#themes#generate_color_map(s:airline_a_normal, s:airline_b_normal, s:airline_c_normal)

" It should be noted the above is equivalent to:
" let g:airline#themes#dark#palette.normal = airline#themes#generate_color_map(
"    \  [ '#00005f' , '#dfff00' , 17  , 190 ],  " section airline_a
"    \  [ '#ffffff' , '#444444' , 255 , 238 ],  " section airline_b
"    \  [ '#9cffd3' , '#202020' , 85  , 234 ]   " section airline_c
"    \)
"
" In turn, that is equivalent to:
" let g:airline#themes#dark#palette.normal = {
"    \  'airline_a': [ '#00005f' , '#dfff00' , 17  , 190 ],  "section airline_a
"    \  'airline_b': [ '#ffffff' , '#444444' , 255 , 238 ],  "section airline_b
"    \  'airline_c': [ '#9cffd3' , '#202020' , 85  , 234 ],  "section airline_c
"    \  'airline_x': [ '#9cffd3' , '#202020' , 85  , 234 ],  "section airline_x
"    \  'airline_y': [ '#ffffff' , '#444444' , 255 , 238 ],  "section airline_y
"    \  'airline_z': [ '#00005f' , '#dfff00' , 17  , 190 ]   "section airline_z
"    \}
"
" airline#themes#generate_color_map() also uses the values provided as
" parameters to create intermediary groups such as:
"   airline_a_to_airline_b
"   airline_b_to_airline_c
"   etc...

" Here we define overrides for when the buffer is modified.  This will be
" applied after g:airline#themes#dark#palette.normal, hence why only certain keys are
" declared.
let g:airline#themes#dark#palette.normal_modified = {
      \ 'airline_c': [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }


let s:airline_a_insert = [ '#00005f' , '#00dfff' , 17  , 45  ]
let s:airline_b_insert = [ '#ffffff' , '#005fff' , 255 , 27  ]
let s:airline_c_insert = [ '#ffffff' , '#000080' , 15  , 17  ]
let g:airline#themes#dark#palette.insert = airline#themes#generate_color_map(s:airline_a_insert, s:airline_b_insert, s:airline_c_insert)
let g:airline#themes#dark#palette.insert_modified = {
      \ 'airline_c': [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }
let g:airline#themes#dark#palette.insert_paste = {
      \ 'airline_a': [ s:airline_a_insert[0]   , '#d78700' , s:airline_a_insert[2] , 172     , ''     ] ,
      \ }

let g:airline#themes#dark#palette.terminal = airline#themes#generate_color_map(s:airline_a_insert, s:airline_b_insert, s:airline_c_insert)

let g:airline#themes#dark#palette.replace = copy(g:airline#themes#dark#palette.insert)
let g:airline#themes#dark#palette.replace.airline_a = [ s:airline_b_insert[0]   , '#af0000' , s:airline_b_insert[2] , 124     , ''     ]
let g:airline#themes#dark#palette.replace_modified = g:airline#themes#dark#palette.insert_modified


let s:airline_a_visual = [ '#000000' , '#ffaf00' , 232 , 214 ]
let s:airline_b_visual = [ '#000000' , '#ff5f00' , 232 , 202 ]
let s:airline_c_visual = [ '#ffffff' , '#5f0000' , 15  , 52  ]
let g:airline#themes#dark#palette.visual = airline#themes#generate_color_map(s:airline_a_visual, s:airline_b_visual, s:airline_c_visual)
let g:airline#themes#dark#palette.visual_modified = {
      \ 'airline_c': [ '#ffffff' , '#5f005f' , 255     , 53      , ''     ] ,
      \ }


let s:airline_a_inactive = [ '#4e4e4e' , '#1c1c1c' , 239 , 234 , '' ]
let s:airline_b_inactive = [ '#4e4e4e' , '#262626' , 239 , 235 , '' ]
let s:airline_c_inactive = [ '#4e4e4e' , '#303030' , 239 , 236 , '' ]
let g:airline#themes#dark#palette.inactive = airline#themes#generate_color_map(s:airline_a_inactive, s:airline_b_inactive, s:airline_c_inactive)
let g:airline#themes#dark#palette.inactive_modified = {
      \ 'airline_c': [ '#875faf' , '' , 97 , '' , '' ] ,
      \ }

" For commandline mode, we use the colors from normal mode, except the mode
" indicator should be colored differently, e.g. light green
let s:airline_a_commandline = [ '#00005f' , '#00d700' , 17  , 40 ]
let s:airline_b_commandline = [ '#ffffff' , '#444444' , 255 , 238 ]
let s:airline_c_commandline = [ '#9cffd3' , '#202020' , 85  , 234 ]
let g:airline#themes#dark#palette.commandline = airline#themes#generate_color_map(s:airline_a_commandline, s:airline_b_commandline, s:airline_c_commandline)

" Accents are used to give parts within a section a slightly different look or
" color. Here we are defining a "red" accent, which is used by the 'readonly'
" part by default. Only the foreground colors are specified, so the background
" colors are automatically extracted from the underlying section colors. What
" this means is that regardless of which section the part is defined in, it
" will be red instead of the section's foreground color. You can also have
" multiple parts with accents within a section.
let g:airline#themes#dark#palette.accents = {
      \ 'red': [ '#ff0000' , '' , 160 , ''  ]
      \ }


" Here we define the color map for ctrlp.  We check for the g:loaded_ctrlp
" variable so that related functionality is loaded if the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if get(g:, 'loaded_ctrlp', 0)
  let g:airline#themes#dark#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
        \ [ '#d7d7ff' , '#5f00af' , 189 , 55  , ''     ],
        \ [ '#ffffff' , '#875fd7' , 231 , 98  , ''     ],
        \ [ '#5f00af' , '#ffffff' , 55  , 231 , 'bold' ])
endif
./autoload/airline/themes.vim	[[[1
163
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2 et

scriptencoding utf-8

if !exists(":def") || !airline#util#has_vim9_script()

  " Legacy Vim Script Implementation

  " generates a dictionary which defines the colors for each highlight group
  function! airline#themes#generate_color_map(sect1, sect2, sect3, ...)
    let palette = {
          \ 'airline_a': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , get(a:sect1 , 4 , '') ] ,
          \ 'airline_b': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , get(a:sect2 , 4 , '') ] ,
          \ 'airline_c': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , get(a:sect3 , 4 , '') ] ,
          \ }

    if a:0 > 0
      call extend(palette, {
            \ 'airline_x': [ a:1[0] , a:1[1] , a:1[2] , a:1[3] , get(a:1 , 4 , '' ) ] ,
            \ 'airline_y': [ a:2[0] , a:2[1] , a:2[2] , a:2[3] , get(a:2 , 4 , '' ) ] ,
            \ 'airline_z': [ a:3[0] , a:3[1] , a:3[2] , a:3[3] , get(a:3 , 4 , '' ) ] ,
            \ })
    else
      call extend(palette, {
            \ 'airline_x': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , '' ] ,
            \ 'airline_y': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , '' ] ,
            \ 'airline_z': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , '' ] ,
            \ })
    endif

    return palette
  endfunction

  function! airline#themes#get_highlight(group, ...)
    return call('airline#highlighter#get_highlight', [a:group] + a:000)
  endfunction

  function! airline#themes#get_highlight2(fg, bg, ...)
    return call('airline#highlighter#get_highlight2', [a:fg, a:bg] + a:000)
  endfunction

  function! airline#themes#patch(palette)
    for mode in keys(a:palette)
      if mode == 'accents'
        continue
      endif
      if !has_key(a:palette[mode], 'airline_warning')
        let a:palette[mode]['airline_warning'] = [ '#000000', '#df5f00', 232, 166 ]
      endif
      if !has_key(a:palette[mode], 'airline_error')
        let a:palette[mode]['airline_error'] = [ '#000000', '#990000', 232, 160 ]
      endif
      if !has_key(a:palette[mode], 'airline_term')
        let a:palette[mode]['airline_term'] = [ '#9cffd3', '#202020', 85, 232]
      endif
    endfor

    let a:palette.accents = get(a:palette, 'accents', {})
    let a:palette.accents.none = [ '', '', '', '', '' ]
    let a:palette.accents.bold = [ '', '', '', '', 'bold' ]
    let a:palette.accents.italic = [ '', '', '', '', 'italic' ]

    if !has_key(a:palette.accents, 'red')
      let a:palette.accents.red = [ '#ff0000' , '' , 160 , '' ]
    endif
    if !has_key(a:palette.accents, 'green')
      let a:palette.accents.green = [ '#008700' , '' , 22  , '' ]
    endif
    if !has_key(a:palette.accents, 'blue')
      let a:palette.accents.blue = [ '#005fff' , '' , 27  , '' ]
    endif
    if !has_key(a:palette.accents, 'yellow')
      let a:palette.accents.yellow = [ '#dfff00' , '' , 190 , '' ]
    endif
    if !has_key(a:palette.accents, 'orange')
      let a:palette.accents.orange = [ '#df5f00' , '' , 166 , '' ]
    endif
    if !has_key(a:palette.accents, 'purple')
      let a:palette.accents.purple = [ '#af00df' , '' , 128 , '' ]
    endif
  endfunction
  finish
else
  " New Vim9 Script Implementation
  def airline#themes#generate_color_map(sect1: list<any>, sect2: list<any>, sect3: list<any>, ...rest: list<any>): dict<any>
    # all sections should be string
    for section in [sect1, sect2, sect3] + rest
      map(section, (_, v) => type(v) != type('') ? string(v) : v)
    endfor

    var palette = {
      'airline_a': [ sect1[0], sect1[1], sect1[2], sect1[3], get(sect1, 4, '') ],
      'airline_b': [ sect2[0], sect2[1], sect2[2], sect2[3], get(sect2, 4, '') ],
      'airline_c': [ sect3[0], sect3[1], sect3[2], sect3[3], get(sect3, 4, '') ],
      }

    if rest->len() > 0
      extend(palette, {
        'airline_x': [ rest[0][0], rest[0][1], rest[0][2], rest[0][3], get(rest[0], 4, '' ) ],
        'airline_y': [ rest[1][0], rest[1][1], rest[1][2], rest[1][3], get(rest[1], 4, '' ) ],
        'airline_z': [ rest[2][0], rest[2][1], rest[2][2], rest[2][3], get(rest[2], 4, '' ) ],
        })
    else
      extend(palette, {
        'airline_x': [ sect3[0], sect3[1], sect3[2], sect3[3], '' ],
        'airline_y': [ sect2[0], sect2[1], sect2[2], sect2[3], '' ],
        'airline_z': [ sect1[0], sect1[1], sect1[2], sect1[3], '' ],
      })
    endif

    return palette
  enddef

  def airline#themes#get_highlight(group: string, ...modifiers: list<string>): list<string>
    return call('airline#highlighter#get_highlight', [group, modifiers])
  enddef

  def airline#themes#get_highlight2(fg: list<string>, bg: list<string>, ...modifiers: list<string>): list<string>
    return call('airline#highlighter#get_highlight2', [fg, bg] + modifiers)
  enddef

  def airline#themes#patch(palette: dict<any>): void
    for mode in keys(palette)
      if mode == 'accents'
        continue
      endif
      if !has_key(palette[mode], 'airline_warning')
        extend(palette[mode], {airline_warning: [ '#000000', '#df5f00', '232', '166' ]})
      endif
      if !has_key(palette[mode], 'airline_error')
        extend(palette[mode], {airline_error: [ '#000000', '#990000', '232', '160' ]})
      endif
      if !has_key(palette[mode], 'airline_term')
        extend(palette[mode], {airline_term: [ '#9cffd3', '#202020', '85', '232' ]})
      endif
    endfor

    palette.accents = get(palette, 'accents', {})
    extend(palette.accents, {none: [ '', '', '', '', '' ]})
    extend(palette.accents, {bold:  [ '', '', '', '', 'bold' ]})
    extend(palette.accents, {italic: [ '', '', '', '', 'italic' ]})

    if !has_key(palette.accents, 'red')
      extend(palette.accents, {red: [ '#ff0000', '', '160', '' ]})
    endif
    if !has_key(palette.accents, 'green')
      extend(palette.accents, {green: [ '#008700', '', '22', '' ]})
    endif
    if !has_key(palette.accents, 'blue')
      extend(palette.accents, {blue: [ '#005fff', '', '27', '' ]})
    endif
    if !has_key(palette.accents, 'yellow')
      extend(palette.accents, {yellow: [ '#dfff00', '', '190', '' ]})
    endif
    if !has_key(palette.accents, 'orange')
      extend(palette.accents, {orange: [ '#df5f00', '', '166', '' ]})
    endif
    if !has_key(palette.accents, 'purple')
      extend(palette.accents, {purple: [ '#af00df', '', '128', '' ]})
    endif
  enddef
endif
./autoload/airline/util.vim	[[[1
240
" MIT License. Copyright (c) 2013-2021 Bailey Ling Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#init#bootstrap()

" couple of static variables. Those should not change within a session, thus
" can be initialized here as "static"
let s:spc = g:airline_symbols.space
let s:nomodeline = (v:version > 703 || (v:version == 703 && has("patch438"))) ? '<nomodeline>' : ''
let s:has_strchars = exists('*strchars')
let s:has_strcharpart = exists('*strcharpart')
let s:focusgained_ignore_time = 0

" TODO: Try to cache winwidth(0) function
" e.g. store winwidth per window and access that, only update it, if the size
" actually changed.
function! airline#util#winwidth(...) abort
  let nr = get(a:000, 0, 0)
  " When statusline is on top, or using global statusline for Neovim
  " always return the number of columns
  if get(g:, 'airline_statusline_ontop', 0) || &laststatus > 2
    return &columns
  else
    return winwidth(nr)
  endif
endfunction

function! airline#util#shorten(text, winwidth, minwidth, ...)
  if airline#util#winwidth() < a:winwidth && len(split(a:text, '\zs')) > a:minwidth
    if get(a:000, 0, 0)
      " shorten from tail
      return '…'.matchstr(a:text, '.\{'.a:minwidth.'}$')
    else
      " shorten from beginning of string
      return matchstr(a:text, '^.\{'.a:minwidth.'}').'…'
    endif
  else
    return a:text
  endif
endfunction

function! airline#util#wrap(text, minwidth)
  if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
    return ''
  endif
  return a:text
endfunction

function! airline#util#append(text, minwidth)
  if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
    return ''
  endif
  let prefix = s:spc == "\ua0" ? s:spc : s:spc.s:spc
  return empty(a:text) ? '' : prefix.g:airline_left_alt_sep.s:spc.a:text
endfunction

function! airline#util#warning(msg)
  echohl WarningMsg
  echomsg "airline: ".a:msg
  echohl Normal
endfunction

function! airline#util#prepend(text, minwidth)
  if a:minwidth > 0 && airline#util#winwidth() < a:minwidth
    return ''
  endif
  return empty(a:text) ? '' : a:text.s:spc.g:airline_right_alt_sep.s:spc
endfunction

if v:version >= 704
  function! airline#util#getbufvar(bufnr, key, def)
    return getbufvar(a:bufnr, a:key, a:def)
  endfunction
else
  function! airline#util#getbufvar(bufnr, key, def)
    let bufvals = getbufvar(a:bufnr, '')
    return get(bufvals, a:key, a:def)
  endfunction
endif

if v:version >= 704
  function! airline#util#getwinvar(winnr, key, def)
    return getwinvar(a:winnr, a:key, a:def)
  endfunction
else
  function! airline#util#getwinvar(winnr, key, def)
    let winvals = getwinvar(a:winnr, '')
    return get(winvals, a:key, a:def)
  endfunction
endif

if v:version >= 704
  function! airline#util#exec_funcrefs(list, ...)
    for Fn in a:list
      let code = call(Fn, a:000)
      if code != 0
        return code
      endif
    endfor
    return 0
  endfunction
else
  function! airline#util#exec_funcrefs(list, ...)
    " for 7.2; we cannot iterate the list, hence why we use range()
    " for 7.3-[97, 328]; we cannot reuse the variable, hence the {}
    for i in range(0, len(a:list) - 1)
      let Fn{i} = a:list[i]
      let code = call(Fn{i}, a:000)
      if code != 0
        return code
      endif
    endfor
    return 0
  endfunction
endif

" Compatibility wrapper for strchars, in case this vim version does not
" have it natively
function! airline#util#strchars(str)
  if s:has_strchars
    return strchars(a:str)
  else
    return strlen(substitute(a:str, '.', 'a', 'g'))
  endif
endfunction

function! airline#util#strcharpart(...)
  if s:has_strcharpart
    return call('strcharpart',  a:000)
  else
    " does not handle multibyte chars :(
    return a:1[(a:2):(a:3)]
  endif
endfunction

function! airline#util#ignore_buf(name)
  let pat = '\c\v'. get(g:, 'airline#ignore_bufadd_pat', '').
        \ get(g:, 'airline#extensions#tabline#ignore_bufadd_pat',
        \ '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler')
  return match(a:name, pat) > -1
endfunction

function! airline#util#has_fugitive()
  if !exists("s:has_fugitive")
    let s:has_fugitive = exists('*FugitiveHead')
  endif
  return s:has_fugitive
endfunction

function! airline#util#has_gina()
  if !exists("s:has_gina")
    let s:has_gina = (exists(':Gina') && v:version >= 800)
  endif
  return s:has_gina
endfunction


function! airline#util#has_lawrencium()
  if !exists("s:has_lawrencium")
    let s:has_lawrencium  = exists('*lawrencium#statusline')
  endif
  return s:has_lawrencium
endfunction

function! airline#util#has_vcscommand()
  if !exists("s:has_vcscommand")
    let s:has_vcscommand = exists('*VCSCommandGetStatusLine')
  endif
  return get(g:, 'airline#extensions#branch#use_vcscommand', 0) && s:has_vcscommand
endfunction

function! airline#util#has_custom_scm()
  return !empty(get(g:, 'airline#extensions#branch#custom_head', ''))
endfunction

function! airline#util#doautocmd(event)
  if !exists('#airline') && a:event !=? 'AirlineToggledOff'
    " airline disabled
    return
  endif
  try
    exe printf("silent doautocmd %s User %s", s:nomodeline, a:event)
  catch /^Vim\%((\a\+)\)\=:E48:/
    " Catch: Sandbox mode
    " no-op
  endtry
endfunction

function! airline#util#themes(match)
  let files = split(globpath(&rtp, 'autoload/airline/themes/'.a:match.'*.vim', 1), "\n")
  return sort(map(files, 'fnamemodify(v:val, ":t:r")') + ('random' =~ a:match ? ['random'] : []))
endfunction

function! airline#util#stl_disabled(winnr)
  " setting the statusline is disabled,
  " either globally, per window, or per buffer
  " w:airline_disabled is deprecated!
  return get(g:, 'airline_disable_statusline', 0) ||
   \ airline#util#getwinvar(a:winnr, 'airline_disable_statusline', 0) ||
   \ airline#util#getwinvar(a:winnr, 'airline_disabled', 0) ||
   \ airline#util#getbufvar(winbufnr(a:winnr), 'airline_disable_statusline', 0)
endfunction

function! airline#util#ignore_next_focusgain()
  if has('win32')
    " Setup an ignore for platforms that trigger FocusLost on calls to
    " system(). macvim (gui and terminal) and Linux terminal vim do not.
    let s:focusgained_ignore_time = localtime()
  endif
endfunction

function! airline#util#is_popup_window(winnr)
   " Keep the statusline active if it's a popup window
   if exists('*win_gettype')
     return win_gettype(a:winnr) ==# 'popup' || win_gettype(a:winnr) ==# 'autocmd'
   else
      return airline#util#getwinvar(a:winnr, '&buftype', '') ==# 'popup'
  endif
endfunction

function! airline#util#try_focusgained()
  " Ignore lasts for at most one second and is cleared on the first
  " focusgained. We use ignore to prevent system() calls from triggering
  " FocusGained (which occurs 100% on win32 and seem to sometimes occur under
  " tmux).
  let dt = localtime() - s:focusgained_ignore_time
  let s:focusgained_ignore_time = 0
  return dt >= 1
endfunction

function! airline#util#has_vim9_script()
  " Returns true, if Vim is new enough to understand vim9 script
  return (exists(":def") &&
    \ exists("v:versionlong") &&
    \ v:versionlong >= 8022844 &&
    \ get(g:, "airline_experimental", 0))
endfunction

./autoload/airline.vim	[[[1
313
" MIT License. Copyright (c) 2013-2021 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let g:airline_statusline_funcrefs = get(g:, 'airline_statusline_funcrefs', [])
let g:airline_inactive_funcrefs = get(g:, 'airline_inactive_statusline_funcrefs', [])

let s:sections = ['a','b','c','gutter','x','y','z', 'error', 'warning']
let s:contexts = {}
let s:core_funcrefs = [
      \ function('airline#extensions#apply'),
      \ function('airline#extensions#default#apply') ]


function! airline#add_statusline_func(name, ...)
  let warn = get(a:, 1, 1)
  call airline#add_statusline_funcref(function(a:name), warn)
endfunction

function! airline#add_inactive_statusline_func(name, ...)
  let warn = get(a:, 1, 1)
  call airline#add_inactive_statusline_funcref(function(a:name), warn)
endfunction


function! airline#add_statusline_funcref(function, ...)
  if index(g:airline_statusline_funcrefs, a:function) >= 0
    let warn = get(a:, 1, 1)
    if warn > 0
      call airline#util#warning(printf('The airline statusline funcref "%s" has already been added.', string(a:function)))
    endif
    return
  endif
  call add(g:airline_statusline_funcrefs, a:function)
endfunction

function! airline#remove_statusline_func(name)
  let i = index(g:airline_statusline_funcrefs, function(a:name))
  if i > -1
    call remove(g:airline_statusline_funcrefs, i)
  endif
endfunction

function! airline#add_inactive_statusline_funcref(function, ...)
  if index(g:airline_inactive_funcrefs, a:function) >= 0
    let warn = get(a:, 1, 1)
    if warn > 0
      call airline#util#warning(printf('The airline inactive statusline funcref "%s" has already been added.', string(a:function)))
    endif
    return
  endif
  call add(g:airline_inactive_funcrefs, a:function)
endfunction

function! airline#load_theme()
  let g:airline_theme = get(g:, 'airline_theme', 'dark')
  if exists('*airline#themes#{g:airline_theme}#refresh')
    call airline#themes#{g:airline_theme}#refresh()
  endif

  let palette = g:airline#themes#{g:airline_theme}#palette
  call airline#themes#patch(palette)

  if exists('g:airline_theme_patch_func')
    let Fn = function(g:airline_theme_patch_func)
    call Fn(palette)
  endif

  call airline#highlighter#load_theme()
  call airline#extensions#load_theme()
  call airline#update_statusline()

  call airline#util#doautocmd('AirlineAfterTheme')
endfunction

" Load an airline theme
function! airline#switch_theme(name, ...)
  let silent = get(a:000, '0', 0)
  " get all available themes
  let themes = airline#util#themes('')
  let err = 0
  try
    if index(themes, a:name) == -1
      " Theme not available
      if !silent
        call airline#util#warning(printf('The specified theme "%s" cannot be found.', a:name))
      endif
      throw "not-found"
      let err = 1
    else
      exe "ru autoload/airline/themes/". a:name. ".vim"
      let g:airline_theme = a:name
    endif
  catch /^Vim/
    " catch only Vim errors, not "not-found"
    call airline#util#warning(printf('There is an error in theme "%s".', a:name))
    if &vbs
      call airline#util#warning(v:exception)
    endif
    let err = 1
  endtry

  if err
    if exists('g:airline_theme')
      return
    else
      let g:airline_theme = 'dark'
    endif
  endif

  unlet! w:airline_lastmode
  call airline#load_theme()

  " this is required to prevent clobbering the startup info message, i don't know why...
  call airline#check_mode(winnr())
endfunction

" Try to load the right theme for the current colorscheme
function! airline#switch_matching_theme()
  if exists('g:colors_name')
    let existing = g:airline_theme
    let theme = tr(tolower(g:colors_name), '-', '_')
    try
      call airline#switch_theme(theme, 1)
      return 1
    catch
      for map in items(g:airline_theme_map)
        if match(g:colors_name, map[0]) > -1
          try
            call airline#switch_theme(map[1], 1)
          catch
            call airline#switch_theme(existing)
          endtry
          return 1
        endif
      endfor
    endtry
  endif
  return 0
endfunction

" Update the statusline
function! airline#update_statusline()
  if airline#util#stl_disabled(winnr()) || airline#util#is_popup_window(winnr())
    return
  endif
  " TODO: need to ignore popup windows here as well?
  let range = filter(range(1, winnr('$')), 'v:val != winnr()')
  " create inactive statusline
  call airline#update_statusline_inactive(range)

  unlet! w:airline_render_left w:airline_render_right
  exe 'unlet! ' 'w:airline_section_'. join(s:sections, ' w:airline_section_')

  " Now create the active statusline
  let w:airline_active = 1
  let context = { 'winnr': winnr(), 'active': 1, 'bufnr': winbufnr(winnr()) }
  try
    call s:invoke_funcrefs(context, g:airline_statusline_funcrefs)
  catch /^Vim\%((\a\+)\)\=:E48:/
    " Catch: Sandbox mode
    " no-op
  endtry
endfunction

" Function to be called to make all statuslines inactive
" Triggered on FocusLost autocommand
function! airline#update_statusline_focuslost()
  if get(g:, 'airline_focuslost_inactive', 0)
    let bufnr=bufnr('%')
    call airline#highlighter#highlight_modified_inactive(bufnr)
    call airline#highlighter#highlight(['inactive'], bufnr)
    call airline#update_statusline_inactive(range(1, winnr('$')))
  endif
endfunction

" Function to draw inactive statuslines for inactive windows
function! airline#update_statusline_inactive(range)
  if airline#util#stl_disabled(winnr())
    return
  endif
  for nr in a:range
    if airline#util#stl_disabled(nr)
      continue
    endif
    call setwinvar(nr, 'airline_active', 0)
    let context = { 'winnr': nr, 'active': 0, 'bufnr': winbufnr(nr) }
    if get(g:, 'airline_inactive_alt_sep', 0)
      call extend(context, {
            \ 'left_sep': g:airline_left_alt_sep,
            \ 'right_sep': g:airline_right_alt_sep }, 'keep')
    endif
    try
      call s:invoke_funcrefs(context, g:airline_inactive_funcrefs)
    catch /^Vim\%((\a\+)\)\=:E48:/
      " Catch: Sandbox mode
      " no-op
    endtry
  endfor
endfunction

" Gather output from all funcrefs which will later be returned by the
" airline#statusline() function
function! s:invoke_funcrefs(context, funcrefs)
  let builder = airline#builder#new(a:context)
  let err = airline#util#exec_funcrefs(a:funcrefs + s:core_funcrefs, builder, a:context)
  if err == 1
    let a:context.line = builder.build()
    let s:contexts[a:context.winnr] = a:context
    let option = get(g:, 'airline_statusline_ontop', 0) ? '&tabline' : '&statusline'
    call setwinvar(a:context.winnr, option, '%!airline#statusline('.a:context.winnr.')')
  endif
endfunction

" Main statusline function per window
" will be set to the statusline option
function! airline#statusline(winnr)
  if has_key(s:contexts, a:winnr)
    return '%{airline#check_mode('.a:winnr.')}'.s:contexts[a:winnr].line
  endif
  " in rare circumstances this happens...see #276
  return ''
endfunction

" Check if mode has changed
function! airline#check_mode(winnr)
  if !has_key(s:contexts, a:winnr)
    return ''
  endif
  let context = s:contexts[a:winnr]

  if get(w:, 'airline_active', 1)
    let m = mode(1)
    " Refer :help mode() to see the list of modes
    "   NB: 'let mode' here refers to the display colour _groups_,
    "   not the literal mode's code (i.e., m). E.g., Select modes
    "   v, S and ^V use 'visual' since they are of similar ilk.
    "   Some modes do not get recognised for status line purposes:
    "   no, nov, noV, no^V, !, cv, and ce.
    "   Mode name displayed is handled in init.vim (g:airline_mode_map).
    "
    if m[0] ==# "i"
      let mode = ['insert']  " Insert modes + submodes (i, ic, ix)
    elseif m[0] == "R"
      let mode = ['replace']  " Replace modes + submodes (R, Rc, Rv, Rx) (NB: case sensitive as 'r' is a mode)
    elseif m[0] =~ '\v(v|V||s|S|)'
        let mode = ['visual']  " Visual and Select modes (v, V, ^V, s, S, ^S))
    elseif m ==# "t"
      let mode = ['terminal']  " Terminal mode (only has one mode (t))
    elseif m[0] =~ '\v(c|r|!)'
      let mode = ['commandline']  " c, cv, ce, r, rm, r? (NB: cv and ce stay showing as mode entered from)
    else
      let mode = ['normal']  " Normal mode + submodes (n, niI, niR, niV; plus operator pendings no, nov, noV, no^V)
    endif
    if exists("*VMInfos") && !empty(VMInfos())
      " Vim plugin Multiple Cursors https://github.com/mg979/vim-visual-multi
      let m = 'multi'
    endif
    " Adjust to handle additional modes, which don't display correctly otherwise
    if index(['niI', 'niR', 'niV', 'ic', 'ix', 'Rc', 'Rv', 'Rx', 'multi'], m) == -1
      let m = m[0]
    endif
    let w:airline_current_mode = get(g:airline_mode_map, m, m)
  else
    let mode = ['inactive']
    let w:airline_current_mode = get(g:airline_mode_map, '__')
  endif

  if g:airline_detect_modified && &modified
    call add(mode, 'modified')
  endif

  if g:airline_detect_paste && &paste
    call add(mode, 'paste')
  endif

  if g:airline_detect_crypt && exists("+key") && !empty(&key)
    call add(mode, 'crypt')
  endif

  if g:airline_detect_spell && &spell
    call add(mode, 'spell')
  endif

  if &readonly || ! &modifiable
    call add(mode, 'readonly')
  endif

  let mode_string = join(mode)
  if get(w:, 'airline_lastmode', '') != mode_string
    call airline#highlighter#highlight_modified_inactive(context.bufnr)
    call airline#highlighter#highlight(mode, string(context.bufnr))
    call airline#util#doautocmd('AirlineModeChanged')
    let w:airline_lastmode = mode_string
  endif

  return ''
endfunction

function! airline#update_tabline()
  if get(g:, 'airline_statusline_ontop', 0)
    call airline#extensions#tabline#redraw()
  endif
endfunction

function! airline#mode_changed()
  " airline#visual_active
  " Boolean: for when to get visual wordcount
  " needed for the wordcount extension
  let g:airline#visual_active = (mode() =~? '[vs]')
  call airline#update_tabline()
endfunction
./doc/airline.txt	[[[1
2147
*airline.txt*  Lean and mean status/tabline that's light as air
*airline* *vim-airline*
                  _                       _      _ _                        ~
           __   _(_)_ __ ___         __ _(_)_ __| (_)_ __   ___             ~
           \ \ / / | '_ ` _ \ _____ / _` | | '__| | | '_ \ / _ \            ~
            \ V /| | | | | | |_____| (_| | | |  | | | | | |  __/            ~
             \_/ |_|_| |_| |_|      \__,_|_|_|  |_|_|_| |_|\___|            ~
                                                                           ~
Version: 0.11
=============================================================================
CONTENTS                                                  *airline-contents*

   01. Intro ............................................... |airline-intro|
   02. Features ......................................... |airline-features|
   03. Name ................................................. |airline-name|
   04. Configuration ............................... |airline-configuration|
   05. Commands ......................................... |airline-commands|
   06. Autocommands ................................. |airline-autocommands|
   07. Customization ............................... |airline-customization|
   08. Extensions ..................................... |airline-extensions|
   09. Advanced Customization ............. |airline-advanced-customization|
   10. Funcrefs ......................................... |airline-funcrefs|
   11. Pipeline ......................................... |airline-pipeline|
   12. Writing Extensions ..................... |airline-writing-extensions|
   13. Writing Themes ..................................... |airline-themes|
   14. Troubleshooting ........................... |airline-troubleshooting|
   15. Contributions ............................... |airline-contributions|
   16. License ........................................... |airline-license|

=============================================================================
INTRODUCTION                                                 *airline-intro*

vim-airline is a fast and lightweight alternative to powerline, written
in 100% vimscript with no outside dependencies.

When the plugin is correctly loaded, Vim will draw a nice statusline at the
bottom of each window.

That line consists of several sections, each one displaying some piece of
information. By default (without configuration) this line will look like
this: >

+---------------------------------------------------------------------------+
|~                                                                          |
|~                                                                          |
|~                     VIM - Vi IMproved                                    |
|~                                                                          |
|~                       version 8.0                                        |
|~                    by Bram Moolenaar et al.                              |
|~           Vim is open source and freely distributable                    |
|~                                                                          |
|~           type :h :q<Enter>          to exit                             |
|~           type :help<Enter> or <F1>  for on-line help                    |
|~           type :help version8<Enter> for version info                    |
|~                                                                          |
|~                                                                          |
+---------------------------------------------------------------------------+
| A | B |                     C                          X | Y | Z |  [...] |
+---------------------------------------------------------------------------+

The statusline is the colored line at the bottom, which contains the sections
(possibly in different colors):

section  meaning (example)~
--------------------------
  A      displays mode + additional flags like crypt/spell/paste (`INSERT`)
  B      VCS information (branch, hunk summary) (`master`)
  C      filename + read-only flag (`~/.vim/vimrc RO`)
  X      filetype  (`vim`)
  Y      file encoding[fileformat] (`utf-8[unix]`)
         optionally may contain Byte Order Mark `[BOM]` and missing end of last
         line `[!EOL]`
  Z      current position in the file
           percentage % ln: current line/number of lines ☰ cn: column
           So this: 10% ln:10/100☰ cn:20
	   means: >
              10%     - 10 percent
	      ln:     - line number is
              10/100☰ - 10 of 100 total lines
	      cn:     - column number is
              20      - 20
<
  [...]  additional sections (warning/errors/statistics)
         from external plugins (e.g. YCM/syntastic/...)

For a better look, those sections can be colored differently, depending on
the mode and whether the current file is 'modified'

Additionally, several extensions exists, that can provide additional feature
(for example the tabline extension provides an extra statusline on the top of
the Vim window and can display loaded buffers and tabs in the current Vim
session).

Most of this is customizable and the default sections can be configured using
the vim variables g:airline_section_<name> (see |airline-default-sections|)

=============================================================================
FEATURES                                                  *airline-features*

*  tiny core written with extensibility in mind.
*  integrates with many popular plugins.
*  looks good with regular fonts, and provides configuration points so you
   can use unicode or powerline symbols.
*  optimized for speed; it loads in under a millisecond.
*  fully customizable; if you know a little 'statusline' syntax you can
   tweak it to your needs.
*  extremely easy to write themes.

=============================================================================
NAME                                                          *airline-name*

Where did the name come from?

I wrote this on an airplane, and since it's light as air it turned out to be
a good name :-)

=============================================================================
CONFIGURATION                                        *airline-configuration*

There are a couple configuration values available (shown with their default
values):

* enable experimental features >
  " Currently: Enable Vim9 Script implementation
  let g:airline_experimental = 1

* the separator used on the left side >
  let g:airline_left_sep='>'
<
* the separator used on the right side >
  let g:airline_right_sep='<'
<
* enable modified detection >
  let g:airline_detect_modified=1

* enable paste detection >
  let g:airline_detect_paste=1
<
* enable crypt detection >
  let g:airline_detect_crypt=1

* enable spell detection >
  let g:airline_detect_spell=1

* display spelling language when spell detection is enabled
  (if enough space is available) >
  let g:airline_detect_spelllang=1
<
  Set to 'flag' to get a unicode icon of the relevant country flag instead of
  the 'spelllang' itself

* enable iminsert detection >
  let g:airline_detect_iminsert=0
<
* determine whether inactive windows should have the left section collapsed
  to only the filename of that buffer.  >
  let g:airline_inactive_collapse=1
<
* Use alternative separators for the statusline of inactive windows >
  let g:airline_inactive_alt_sep=1
<
* themes are automatically selected based on the matching colorscheme. this
  can be overridden by defining a value. >
  let g:airline_theme='dark'
<
  Note: Only the dark theme is distributed with vim-airline. For more themes,
  checkout the vim-airline-themes repository
  (https://github.com/vim-airline/vim-airline-themes)

* if you want to patch the airline theme before it gets applied, you can
  supply the name of a function where you can modify the palette. >
  let g:airline_theme_patch_func = 'AirlineThemePatch'
  function! AirlineThemePatch(palette)
    if g:airline_theme == 'badwolf'
      for colors in values(a:palette.inactive)
        let colors[3] = 245
      endfor
    endif
  endfunction
<
* if you want to update your highlights without affecting the airline theme,
  you can do so using the AirlineAfterTheme autocmd. >
  function! s:update_highlights()
    hi CursorLine ctermbg=none guibg=NONE
    hi VertSplit ctermbg=none guibg=NONE
  endfunction
  autocmd User AirlineAfterTheme call s:update_highlights()
<
* By default, airline will use unicode symbols if your encoding matches
  utf-8. If you want the powerline symbols set this variable: >
  let g:airline_powerline_fonts = 1
<
  If you want to use plain ascii symbols, set this variable: >
  let g:airline_symbols_ascii = 1
<
* define the set of text to display for each mode.  >
  let g:airline_mode_map = {} " see source for the defaults

  " or copy paste the following into your vimrc for shortform text
  let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }
   Note: 'multi' is for displaying the multiple cursor mode
<
* define the set of filename match queries which excludes a window from
  having its statusline modified >
  let g:airline_exclude_filenames = [] " see source for current list
<
* define the set of filetypes which are excluded from having its window
  statusline modified >
  let g:airline_exclude_filetypes = [] " see source for current list
<
* define the set of names to be displayed instead of a specific filetypes
  (for section a and b): >

  let g:airline_filetype_overrides = {
      \ 'coc-explorer':  [ 'CoC Explorer', '' ],
      \ 'defx':  ['defx', '%{b:defx.paths[0]}'],
      \ 'fugitive': ['fugitive', '%{airline#util#wrap(airline#extensions#branch#get_head(),80)}'],
      \ 'floggraph':  [ 'Flog', '%{get(b:, "flog_status_summary", "")}' ],
      \ 'gundo': [ 'Gundo', '' ],
      \ 'help':  [ 'Help', '%f' ],
      \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
      \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
      \ 'startify': [ 'startify', '' ],
      \ 'vim-plug': [ 'Plugins', '' ],
      \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
      \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
      \ 'vaffle' : [ 'Vaffle', '%{b:vaffle.dir}' ],
      \ }
<
* defines whether the preview window should be excluded from having its window
  statusline modified (may help with plugins which use the preview window
  heavily) >
  let g:airline_exclude_preview = 0
<
* disable the Airline statusline customization for selected windows (this is a
  window-local variable so you can disable it per-window) >
  let w:airline_disable_statusline = 1
<
  Old deprecated name: `w:airline_disabled`

  See also the following options, for disabling setting the statusline
  globally or per-buffer
* Disable setting the statusline option: >
  " disable globally
  let g:airline_disable_statusline = 1

  " disable per-buffer
  let b:airline_disable_statusline = 1

< This setting disables setting the 'statusline' option. This allows to use
 e.g. the tabline extension (|airline-tabline|) but keep the 'statusline'
 option totally configurable by a custom configuration.
* Do not draw separators for empty sections (only for the active window) >
  let g:airline_skip_empty_sections = 1
<
  This variable can be overridden by setting a window-local variable with
  the same name (in the correct window): >
  let w:airline_skip_empty_sections = 0
<
* Caches the changes to the highlighting groups, should therefore be faster.
  Set this to one, if you experience a sluggish Vim: >
  let g:airline_highlighting_cache = 0
<
* disable airline on FocusLost autocommand (e.g. when Vim loses focus): >
  let g:airline_focuslost_inactive = 0
<
* configure the fileformat output
  By default, it will display something like 'utf-8[unix]', however, you can
  skip displaying it, if the output matches a configured string. To do so,
  set: >
  let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
<
* Display the statusline in the tabline (first top line): >
  let g:airline_statusline_ontop = 1
<
  Setting this option, allows to use the statusline option to be used by
  a custom function or another plugin, since airline won't change it.

  Note: This setting is experimental and works on a best effort approach.
  Updating the statusline might not always happen as fast as needed, but that
  is a limitation, that comes from Vim. airline tries to force an update if
  needed, but it might not always work as expected.
  To force updating the tabline on mode changes, call `airline#check_mode()`
  in your custom statusline setting: `:set stl=%!airline#check_mode(winnr())`
  will correctly update the tabline on mode changes.

* Display a short path in statusline: >
  let g:airline_stl_path_style = 'short'
>
* Display a only file name in statusline: >
  let g:airline_section_c_only_filename = 1
>
=============================================================================
COMMANDS                                                  *airline-commands*

:AirlineTheme {theme-name}                                   *:AirlineTheme*
  Displays or changes the current theme.
  Note: `random` will switch to a random theme.

:AirlineToggleWhitespace                          *:AirlineToggleWhitespace*
  Toggles whitespace detection.

:AirlineToggle                                              *:AirlineToggle*
  Toggles between the standard 'statusline' and airline.

:AirlineRefresh[!]                                         *:AirlineRefresh*
  Refreshes all highlight groups and redraws the statusline. With the '!'
  attribute, skips refreshing the highlighting groups.

:AirlineExtensions                                      *:AirlineExtensions*
  Shows the status of all available airline extensions.
  Extern means, the extensions does not come bundled with Airline.

=============================================================================
AUTOCOMMANDS                                          *airline-autocommands*

Airline comes with some user-defined autocommands.

|AirlineAfterInit|    after plugin is initialized, but before the statusline
                    is replaced
|AirlineAfterTheme|   after theme of the statusline has been changed
|AirlineToggledOn|    after airline is activated and replaced the statusline
|AirlineToggledOff|   after airline is deactivated and the statusline is
                    restored to the original
|AirlineModeChanged|  The mode in Vim changed.

=============================================================================
CUSTOMIZATION                                        *airline-customization*

The following are some unicode symbols for customizing the left/right
separators, as well as the powerline font glyphs.

Note: Some additional characters like spaces and colons may be included in the
default. Including them within the symbol definitions rather than outside of
them allows you to eliminate or otherwise alter them.

Note: Be aware that some of these glyphs are defined as ligatures, so they may
show up different (usually bigger) if followed by a space. This only happens
if both the font and terminal implementation used support ligatures. If you
want to follow a glyph with a space _without_ the alternate ligature being
rendered, follow it with a non-breaking-space character.

Note: You must define the dictionary first before setting values. Also, it's
a good idea to check whether it exists as to avoid accidentally overwriting
its contents. >
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.colnr = ' ㏇:'
  let g:airline_symbols.colnr = ' ℅:'
  let g:airline_symbols.crypt = '🔒'
  let g:airline_symbols.linenr = '☰'
  let g:airline_symbols.linenr = ' ␊:'
  let g:airline_symbols.linenr = ' ␤:'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.maxlinenr = '㏑'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.paste = '∥'
  let g:airline_symbols.spell = 'Ꞩ'
  let g:airline_symbols.notexists = 'Ɇ'
  let g:airline_symbols.notexists = '∄'
  let g:airline_symbols.whitespace = 'Ξ'

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.colnr = ' ℅:'
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ' :'
  let g:airline_symbols.maxlinenr = '☰ '
  let g:airline_symbols.dirty='⚡'

  " old vim-powerline symbols
  let g:airline_left_sep = '⮀'
  let g:airline_left_alt_sep = '⮁'
  let g:airline_right_sep = '⮂'
  let g:airline_right_alt_sep = '⮃'
  let g:airline_symbols.branch = '⭠'
  let g:airline_symbols.readonly = '⭤'
  let g:airline_symbols.linenr = '⭡'
<

For more intricate customizations, you can replace the predefined sections
with the usual statusline syntax.

Note: If you define any section variables it will replace the default values
entirely.  If you want to disable only certain parts of a section you can
try using variables defined in the |airline-configuration| or
|airline-extensions| section.
                                                   |airline-default-sections|
The following table describes what sections are available by default, and
which extensions/functions make use of it. Note: using `g:` (global) variable
prefix means, those variables are defined for all windows. You can use `w:`
(window local variables) instead to make this apply only to a particular
window.
>
  variable names                default contents
  ---------------------------------------------------------------------------
  let g:airline_section_a       (mode, crypt, paste, spell, iminsert)
  let g:airline_section_b       (hunks, branch)[*]
  let g:airline_section_c       (bufferline or filename, readonly)
  let g:airline_section_gutter  (csv)
  let g:airline_section_x       (tagbar, filetype, virtualenv)
  let g:airline_section_y       (fileencoding, fileformat, 'bom', 'eol')
  let g:airline_section_z       (percentage, line number, column number)
  let g:airline_section_error   (ycm_error_count, syntastic-err, eclim,
                                 languageclient_error_count)
  let g:airline_section_warning (ycm_warning_count, syntastic-warn,
                                 languageclient_warning_count, whitespace)

  " [*] This section needs at least the fugitive extension or else
  "     it will remain empty
  "
  " here is an example of how you could replace the branch indicator with
  " the current working directory (limited to 10 characters),
  " followed by the filename.
  let g:airline_section_b = '%-0.10{getcwd()}'
  let g:airline_section_c = '%t'
<
                                                *airline#ignore_bufadd_pat*
Determines a pattern to ignore a buffer name for various things (e.g. the
tabline extension) or the read-only check. Default is
`g:airline#extensions#tabline#ignore_bufadd_pat` (see below) or
`'!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler'`
if it is unset.
The "!" prevents terminal buffers to appear in the tabline.

                                *airline#extensions#tabline#exclude_buffers*
Buffer numbers to be excluded from showing in the tabline (similar to
|airline#ignore_bufadd_pat|).

=============================================================================
EXTENSIONS                                              *airline-extensions*

Most extensions are enabled by default and lazily loaded when the
corresponding plugin (if any) is detected.

By default, airline will attempt to load any extension it can find in the
'runtimepath'.  On some systems this can result in an undesirable startup
cost.  You can disable the check with the following flag. >
  let g:airline#extensions#disable_rtp_load = 1
<
  Note: Third party plugins that rely on this behavior will be affected. You
  will need to manually load them.

Alternatively, if you want a minimalistic setup and would rather opt-in which
extensions get loaded instead of disabling each individually, you can declare
the following list variable: >
  " an empty list disables all extensions
  let g:airline_extensions = []

  " or only load what you want
  let g:airline_extensions = ['branch', 'tabline']
<
In addition, each extension can be configured individually.  Following are
the options for each extension (in alphabetical order, after the default
extension)

Usually, each extension will only be loaded if the required Vim plugin is
installed as well, otherwise it will remain disabled. See the output of the
|:AirlineExtensions| command.

-------------------------------------                    *airline-ale*
ale <https://github.com/dense-analysis/ale>

* enable/disable ale integration >
  let g:airline#extensions#ale#enabled = 1

* ale error_symbol >
  let airline#extensions#ale#error_symbol = 'E:'
<
* ale warning >
  let airline#extensions#ale#warning_symbol = 'W:'

* ale show_line_numbers >
  let airline#extensions#ale#show_line_numbers = 1
<
* ale open_lnum_symbol >
  let airline#extensions#ale#open_lnum_symbol = '(L'
<
* ale close_lnum_symbol >
  let airline#extensions#ale#close_lnum_symbol = ')'

-------------------------------------                      *airline-battery*
vim-battery <https://github.com/lambdalisue/battery.vim>

* enable/disable battery integration >
  let g:airline#extensions#battery#enabled = 1
<  default: 0

-------------------------------------                      *airline-bookmark*
vim-bookmark <https://github.com/MattesGroeger/vim-bookmarks>

* enable/disable bookmark integration >
  let g:airline#extensions#bookmark#enabled = 1

-------------------------------------                      *airline-branch*
vim-airline will display the branch-indicator together with the branch name
in the statusline, if one of the following plugins is installed:

fugitive.vim <https://github.com/tpope/vim-fugitive>
gina.vim     <https://github.com/lambdalisue/gina.vim>
lawrencium   <https://bitbucket.org/ludovicchabant/vim-lawrencium>
vcscommand   <http://www.vim.org/scripts/script.php?script_id=90>

If a file is edited, that is not yet in the repository, the
notexists symbol will be displayed after the branch name. If the repository
is not clean, the dirty symbol will be displayed after the branch name.

* notexists symbol means you are editing a file, that has not been
  committed yet
  default: '?'

* the dirty symbol basically means your working directory is dirty
  default: '!'

Note: the branch extension will be disabled for windows smaller than 80
characters.

* enable/disable fugitive/lawrencium integration >
  let g:airline#extensions#branch#enabled = 1
<
* change the text for when no branch is detected >
  let g:airline#extensions#branch#empty_message = ''
<
* define the order in which the branches of different vcs systems will be
  displayed on the statusline (currently only for fugitive and lawrencium) >
  let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]
<
* use vcscommand.vim if available >
  let g:airline#extensions#branch#use_vcscommand = 0
<
* truncate long branch names to a fixed length >
  let g:airline#extensions#branch#displayed_head_limit = 10
<
* customize formatting of branch name >
  " default value leaves the name unmodified
  let g:airline#extensions#branch#format = 0

  " to only show the tail, e.g. a branch 'feature/foo' becomes 'foo', use
  let g:airline#extensions#branch#format = 1

  " to truncate all path sections but the last one, e.g. a branch
  " 'foo/bar/baz' becomes 'f/b/baz', use
  let g:airline#extensions#branch#format = 2

  " if a string is provided, it should be the name of a function that
  " takes a string and returns the desired value
  let g:airline#extensions#branch#format = 'CustomBranchName'
  function! CustomBranchName(name)
    return '[' . a:name . ']'
  endfunction
<
* truncate sha1 commits at this number of characters  >
  let g:airline#extensions#branch#sha1_len = 10

* customize branch name retrieval for any version control system >
  let g:airline#extensions#branch#custom_head = 'GetScmBranch'
  function! GetScmBranch()
    if !exists('b:perforce_client')
      let b:perforce_client = system('p4 client -o | grep Client')
      " Invalidate cache to prevent stale data when switching clients. Use a
      " buffer-unique group name to prevent clearing autocmds for other
      " buffers.
      exec 'augroup perforce_client-'. bufnr("%")
          au!
          autocmd BufWinLeave <buffer> silent! unlet! b:perforce_client
      augroup END
    endif
    return b:perforce_client
  endfunction
>
* configure additional vcs checks to run
  By default, vim-airline will check if the current edited file is untracked
  in the repository. If so, it will append the `g:airline_symbols.notexists`
  symbol to the branch name.
  In addition, it will check if the repository is clean, else it will append
  the `g:airline_symbols.dirty` symbol to the branch name (if the current
  file is not untracked). Configure, by setting the following variable: >

  let g:airline#extensions#branch#vcs_checks = ['untracked', 'dirty']
<
-------------------------------------                      *airline-flog*
vim-flog <https://github.com/rbong/vim-flog>

If vim-flog is installed, vim-airline will display the branch name
together with a status summary in the git log graph buffer;
either 'no changes' or the number of added/removed/modified files.

-------------------------------------                   *airline-bufferline*
vim-bufferline <https://github.com/bling/vim-bufferline>

* enable/disable bufferline integration >
  let g:airline#extensions#bufferline#enabled = 1
<
* determine whether bufferline will overwrite customization variables >
  let g:airline#extensions#bufferline#overwrite_variables = 1
<
-------------------------------------                     *airline-capslock*
vim-capslock <https://github.com/tpope/vim-capslock>

* enable/disable vim-capslock integration >
  let g:airline#extensions#capslock#enabled = 1

* change vim-capslock symbol >
  let g:airline#extensions#capslock#symbol = 'CAPS' (default)

-------------------------------------                    *airline-coc*
coc <https://github.com/neoclide/coc.nvim>

* enable/disable coc integration >
  let g:airline#extensions#coc#enabled = 1
<
* change error symbol: >
  let airline#extensions#coc#error_symbol = 'E:'
<
* change warning symbol: >
  let airline#extensions#coc#warning_symbol = 'W:'
<
* enable/disable coc status display >
  g:airline#extensions#coc#show_coc_status = 1

* change the error format (%C - error count, %L - line number): >
  let airline#extensions#coc#stl_format_err = '%C(L%L)'
<
* change the warning format (%C - error count, %L - line number): >
  let airline#extensions#coc#stl_format_warn = '%C(L%L)'
<
-------------------------------------                    *airline-commandt*
command-t <https://github.com/wincent/command-t>

No configuration available.

-------------------------------------                          *airline-csv*
csv.vim <https://github.com/chrisbra/csv.vim>

* enable/disable csv integration for displaying the current column. >
  let g:airline#extensions#csv#enabled = 1
<
* change how columns are displayed. >
  let g:airline#extensions#csv#column_display = 'Number' (default)
  let g:airline#extensions#csv#column_display = 'Name'
<
-------------------------------------                        *airline-ctrlp*
ctrlp <https://github.com/ctrlpvim/ctrlp.vim>

* configure which mode colors should ctrlp window use (takes effect
  only if the active airline theme doesn't define ctrlp colors) >
  let g:airline#extensions#ctrlp#color_template = 'insert' (default)
  let g:airline#extensions#ctrlp#color_template = 'normal'
  let g:airline#extensions#ctrlp#color_template = 'visual'
  let g:airline#extensions#ctrlp#color_template = 'replace'
<
* configure whether to show the previous and next modes (mru, buffer, etc...)
>
 let g:airline#extensions#ctrlp#show_adjacent_modes = 1
<
-------------------------------------                    *airline-ctrlspace*
vim-ctrlspace <https://github.com/szw/vim-ctrlspace>

* enable/disable vim-ctrlspace integration >
  let g:airline#extensions#ctrlspace#enabled = 1
<
  To make the vim-ctrlspace integration work you will need to make the
  ctrlspace statusline function call the correct airline function. Therefore
  add the following line into your .vimrc: >

  let g:CtrlSpaceStatuslineFunction =
   \  "airline#extensions#ctrlspace#statusline()"
<
-------------------------------------                    *airline-cursormode*
cursormode <https://github.com/vheon/vim-cursormode>

Built-in extension to displays cursor in different colors depending on the
current mode (only works in terminals iTerm, AppleTerm and xterm)

* enable cursormode integration >
  let g:airline#extensions#cursormode#enabled = 1

* mode function. Return value is used as key for the color mapping. Default
  is |mode()|
  `let g:cursormode_mode_func = 'mode'`
  color mapping. Keys come from `g:cursormode_mode_func`
  (a background value can be appended)
  `let g:cursormode_color_map = {`
`\ "nlight": '#000000',`
`\ "ndark": '#BBBBBB',`
`\ "i": g:airline#themes#{g:airline_theme}#palette.insert.airline_a[1],`
`\ "R": g:airline#themes#{g:airline_theme}#palette.replace.airline_a[1],`
`\ "v": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],`
`\ "V": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],`
`\ "\<C-V>": g:airline#themes#{g:airline_theme}#palette.visual.airline_a[1],`
`\ }`

-------------------------------------                      *airline-default*
The default extensions is an internal extension that is needed for handling
all other extensions, takes care of how all sections will be combined into a
'statusline' specific item and when to truncate each section.

It understands all of the `g:` variables in the |airline-configuration|
section, however it also has some more fine-tuned configuration values that
you can use.

* control which sections get truncated and at what width. >
  let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 79,
      \ 'x': 60,
      \ 'y': 80,
      \ 'z': 45,
      \ 'warning': 80,
      \ 'error': 80,
      \ }

  " Note: set to an empty dictionary to disable truncation.
  let g:airline#extensions#default#section_truncate_width = {}
<
* configure the layout of the sections by specifying an array of two arrays
  (first array is the left side, second array is the right side). >
  let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z', 'error', 'warning' ]
      \ ]
<
* configure the layout to not use %(%) grouping items in the statusline.
  Try setting this to zero, if you notice bleeding color artifacts >
  let airline#extensions#default#section_use_groupitems = 1
<
-------------------------------------                      *airline-denite*
Denite <https://github.com/Shougo/denite.nvim>

* enable/disable denite integration >
  let g:airline#extensions#denite#enabled = 1

-------------------------------------                      *airline-dirvish*
vim-dirvish <https://github.com/justinmk/vim-dirvish>

* enable/disable vim-dirvish integration >
  let g:airline#extensions#dirvish#enabled = 1
<  default: 1

-------------------------------------                        *airline-eclim*
eclim <https://eclim.org>

* enable/disable eclim integration, which works well with the
  |airline-syntastic| extension. >
  let g:airline#extensions#eclim#enabled = 1

-------------------------------------                 	      *airline-fern*
fern.vim <https://github.com/lambdalisue/fern.vim>

Airline displays the fern.vim specific statusline.
(for details, see the help of fern.vim)

* enable/disable bufferline integration >
  let g:airline#extensions#fern#enabled = 1
<  default: 1

-------------------------------------                  *airline-fugitiveline*
This extension hides the fugitive://**// part of the buffer names, to only
show the file name as if it were in the current working tree.
It is deactivated by default if |airline-bufferline| is activated.

* enable/disable bufferline integration >
  let g:airline#extensions#fugitiveline#enabled = 1
<
If enabled, the buffer that comes from fugitive, will have added a trailing
"[git]" to be able to distinguish between fugitive and non-fugitive buffers.

-------------------------------------                        *airline-fzf*
fzf <https://github.com/junegunn/fzf>
fzf.vim <https://github.com/junegunn/fzf.vim>

* enable/disable fzf integration >
  let g:airline#extensions#fzf#enabled = 1

-------------------------------------                     *airline-gina*
gina.vim <https://github.com/lambdalisue/gina.vim>

Airline displays the gina.vim specific statusline.
(for details, see the help of gina.vim)

* enable/disable bufferline integration >
  let g:airline#extensions#gina#enabled = 1
<  default: 1

-------------------------------------                     *airline-grepper*
vim-grepper <https://github.com/mhinz/vim-grepper>

* enable/disable vim-grepper integration >
  let g:airline#extensions#grepper#enabled = 1

-------------------------------------                     *airline-gutentags*
vim-gutentags <https://github.com/ludovicchabant/vim-gutentags>

* enable/disable vim-gutentags integration >
  let g:airline#extensions#gutentags#enabled = 1

-------------------------------------                     *gen_tags.vim*
gen_tags.vim <https://github.com/jsfaint/gen_tags.vim>

* enable/disable gen_tags.vim integration >
  let g:airline#extensions#gen_tags#enabled = 1

-------------------------------------                        *airline-hunks*
vim-gitgutter <https://github.com/airblade/vim-gitgutter>
vim-signify <https://github.com/mhinz/vim-signify>
changesPlugin <https://github.com/chrisbra/changesPlugin>
quickfixsigns <https://github.com/tomtom/quickfixsigns_vim>
coc-git <https://github.com/neoclide/coc-git>
gitsigns.nvim <https://github.com/lewis6991/gitsigns.nvim>

You can use `airline#extensions#hunks#get_raw_hunks()` to get the full hunks,
without shortening. This allows for advanced customization, or a quick way of
querying how many changes you got. It will return something like '+4 ~2 -1'.

* enable/disable showing a summary of changed hunks under source control. >
  let g:airline#extensions#hunks#enabled = 1
<
* enable/disable showing only non-zero hunks. >
  let g:airline#extensions#hunks#non_zero_only = 0
<
* set hunk count symbols. >
  let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

* enable coc-git extension.
  If not set to 1, vim-airline will not consider to use coc-git for the hunks
  extension. Make sure to have the coc-git extension enabled. >
  let g:airline#extensions#hunks#coc_git = 1
<
-------------------------------------                     *airline-keymap*
vim-keymap

This extension displays the current 'keymap' in use.

* enable/disable vim-keymap extension >
  let g:airline#extensions#keymap#enabled = 1

* set label for a keymap (default is from g:airline_symbols.keymap) >
  let g:airline#extensions#keymap#label = 'Layout:'

* set name for default layout (empty to disable it completely) >
  let g:airline#extensions#keymap#default = ''

* set short codes for layout names >
  let g:airline#extensions#keymap#short_codes = {'russian-jcukenwin': 'ru'}

-------------------------------------                *airline-languageclient*
LanguageClient <https://github.com/autozimu/LanguageClient-neovim>
(despite its name, it can be used for Vim and Neovim).

* enable/disable LanguageClient integration >
  let g:airline#extensions#languageclient#enabled = 1

* languageclient error_symbol >
  let airline#extensions#languageclient#error_symbol = 'E:'
<
* languageclient warning_symbol >
  let airline#extensions#languageclient#warning_symbol = 'W:'

* languageclient show_line_numbers >
  let airline#extensions#languageclient#show_line_numbers = 1
<
* languageclient open_lnum_symbol >
  let airline#extensions#languageclient#open_lnum_symbol = '(L'
<
* languageclient close_lnum_symbol >
  let airline#extensions#languageclient#close_lnum_symbol = ')'

-------------------------------------                   *airline-localsearch*
localsearch <https://github.com/mox-mox/vim-localsearch>

* enable/disable localsearch indicator integration >
  let g:airline#extensions#localsearch#enabled = 1

* invert the localsearch indicator
  if set to 1, the indicator shall only be shown when localsearch is disabled
  the text will also change from 'LS' to 'GS' (Global Search) >
  let g:airline#extensions#localsearch#inverted = 0

-------------------------------------                    *airline-lsp*
lsp <https://github.com/prabirshrestha/vim-lsp>

* enable/disable lsp integration >
  let g:airline#extensions#lsp#enabled = 1

* lsp error_symbol >
  let airline#extensions#lsp#error_symbol = 'E:'
<
* lsp warning >
  let airline#extensions#lsp#warning_symbol = 'W:'

* lsp show_line_numbers >
  let airline#extensions#lsp#show_line_numbers = 1
<
* lsp open_lnum_symbol >
  let airline#extensions#lsp#open_lnum_symbol = '(L'
<
* lsp close_lnum_symbol >
  let airline#extensions#lsp#close_lnum_symbol = ')'
<
* lsp progress skip time
  Suppresses the frequency of status line updates.
  Prevents heavy operation when using a language server that sends frequent progress notifications.
  Set 0 to disable. >
  g:airline#extensions#lsp#progress_skip_time = 0.3 (default)
<

-------------------------------------                    *airline-neomake*
neomake <https://github.com/neomake/neomake>

* enable/disable neomake integration >
  let g:airline#extensions#neomake#enabled = 1

* neomake error_symbol >
  let airline#extensions#neomake#error_symbol = 'E:'
<
* neomake warning >
  let airline#extensions#neomake#warning_symbol = 'W:'
<
-------------------------------------                   *airline-nerdtree*
NerdTree <https://github.com/preservim/nerdtree.git>

Airline displays the Nerdtree specific statusline (which can be configured
using the |'NerdTreeStatusline'| variable (for details, see the help of
NerdTree)

* enable/disable nerdtree's statusline integration >
  let g:airline#extensions#nerdtree_statusline = 1
<  default: 1

-------------------------------------                      *airline-nrrwrgn*
NrrwRgn <https://github.com/chrisbra/NrrwRgn>

* enable/disable NrrwRgn integration >
  let g:airline#extensions#nrrwrgn#enabled = 1

-------------------------------------                    *airline-nvimlsp*
nvimlsp <https://github.com/neovim/nvim-lsp>

* enable/disable nvimlsp integration >
  let g:airline#extensions#nvimlsp#enabled = 1

* nvimlsp error_symbol >
  let airline#extensions#nvimlsp#error_symbol = 'E:'
<
* nvimlsp warning - needs v:lua.vim.diagnostic.get
  let airline#extensions#nvimlsp#warning_symbol = 'W:'

* nvimlsp show_line_numbers - needs v:lua.vim.diagnostic.get
  let airline#extensions#nvimlsp#show_line_numbers = 1

* nvimlsp open_lnum_symbol - needs v:lua.vim.diagnostic.get
  let airline#extensions#nvimlsp#open_lnum_symbol = '(L'

* nvimlsp close_lnum_symbol - needs v:lua.vim.diagnostic.get
  let airline#extensions#nvimlsp#close_lnum_symbol = ')'

-------------------------------------                    *airline-obsession*
vim-obsession <https://github.com/tpope/vim-obsession>

* enable/disable vim-obsession integration >
  let g:airline#extensions#obsession#enabled = 1

* set marked window indicator string >
  let g:airline#extensions#obsession#indicator_text = '$'
<
-------------------------------------                    *airline-omnisharp*
OmniSharp <https://github.com/OmniSharp/omnisharp-vim>

* enable/disable OmniSharp integration >
  let g:airline#extensions#omnisharp#enabled = 1

-------------------------------------                          *airline-po*
This extension will display the currently translated, untranslated and fuzzy
messages when editing translations (po files). Related plugin (not necessary
for this extension is po.vim from
<http://www.vim.org/scripts/script.php?script_id=2530>

It will be enabled if the `msgfmt` executable is available and one is editing
files with the 'filetype' "po".

* enable/disable po integration >
  let g:airline#extensions#po#enabled = 1
<
* truncate width names to a fixed length >
  let g:airline#extensions#po#displayed_limit = 0

-------------------------------------                   *airline-poetv*
poetv <https://github.com/petobens/poet-v>

* enable/disable poetv integration >
  let g:airline#extensions#poetv#enabled = 1
<
-------------------------------------                   *airline-promptline*
promptline <https://github.com/edkolev/promptline.vim>

* configure the path to the snapshot .sh file. Mandatory option. The created
  file should be sourced by the shell on login >
  " in .vimrc
  airline#extensions#promptline#snapshot_file = "~/.shell_prompt.sh"

  " in .bashrc/.zshrc
  [ -f ~/.shell_prompt.sh ] && source ~/.shell_prompt.sh
<
* enable/disable promptline integration >
  let g:airline#extensions#promptline#enabled = 0
<
* configure which mode colors should be used in prompt >
  let airline#extensions#promptline#color_template = 'normal' (default)
  let airline#extensions#promptline#color_template = 'insert'
  let airline#extensions#promptline#color_template = 'visual'
  let airline#extensions#promptline#color_template = 'replace'
<
-------------------------------------                     *airline-quickfix*
The quickfix extension is a simple built-in extension which determines
whether the buffer is a quickfix or location list buffer, and adjusts the
title accordingly.

* configure the title text for quickfix buffers >
  let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
<
* configure the title text for location list buffers >
  let g:airline#extensions#quickfix#location_text = 'Location'
<
-------------------------------------                     *airline-rufo*
rufo <https://github.com/ruby-formatter/rufo-vim>

The rufo (Ruby Formatter) extension merely displays whether vim-rufo is
currently enabled, in the z section of the statusline.

* enable/disable vim-rufo integration >
  let g:airline#extensions#rufo#enabled = 1
<
* configure the symbol, or text, to display when vim-rufo auto formatting
  is on >
  let g:airline#extensions#rufo#symbol = 'R'
<
-------------------------------------                     *airline-searchcount*
The searchcount extension supports the searchcount() function in Vim script.
Note: This is only enabled when 'hls' is on. When you turn off search
highlighting (e.g. using |:nohls|), it this will be disabled.

* enable/disable searchcount integration >
  let g:airline#extensions#searchcount#enabled = 1

* enable/disable displaying search term >
  let g:airline#extensions#searchcount#show_search_term = 1

* truncate long search terms to a fixed length >
  let g:airline#extensions#searchcount#search_term_limit = 8
<
-------------------------------------                    *airline-syntastic*
syntastic <https://github.com/vim-syntastic/syntastic>

* enable/disable syntastic integration >
  let g:airline#extensions#syntastic#enabled = 1

  Note: The recommendation from syntastic to modify the statusline directly
  does not apply, if you use vim-airline, since it will take care for you of
  adjusting the statusline.

* syntastic error_symbol >
  let airline#extensions#syntastic#error_symbol = 'E:'
<
* syntastic statusline error format (see |syntastic_stl_format|) >
  let airline#extensions#syntastic#stl_format_err = '%E{[%fe(#%e)]}'

* syntastic warning >
  let airline#extensions#syntastic#warning_symbol = 'W:'
<
* syntastic statusline warning format (see |syntastic_stl_format|) >
  let airline#extensions#syntastic#stl_format_warn = '%W{[%fw(#%w)]}'
<
-------------------------------------                      *airline-tabline*
Note: If you're using the ctrlspace tabline only the option marked with (c)
are supported!

* enable/disable enhanced tabline. (c) >
  let g:airline#extensions#tabline#enabled = 0

* enable/disable displaying open splits per tab (only when tabs are opened) >
  let g:airline#extensions#tabline#show_splits = 1

* switch position of buffers and tabs on splited tabline (c)
  (only supported for ctrlspace plugin). >
  let g:airline#extensions#tabline#switch_buffers_and_tabs = 0
<
* enable/disable displaying buffers with a single tab. (c) >
  let g:airline#extensions#tabline#show_buffers = 1

Note: If you are using neovim (has('tablineat') = 1), then you can click
on the tabline with the left mouse button to switch to that buffer, and
with the middle mouse button to delete that buffer.

* if you want to show the current active buffer like this:
  ----------------------
  buffer <buffer> buffer `
>
 let g:airline#extensions#tabline#alt_sep = 1
< Only makes sense, if g:airline_right_sep is not empty.
 default: 0

* enable/disable displaying tabs, regardless of number. (c) >
  let g:airline#extensions#tabline#show_tabs = 1

* enable/disable displaying number of tabs in the right side (c) >
  let g:airline#extensions#tabline#show_tab_count = 1

Note: Not displayed if the number of tabs is less than 1

* always displaying number of tabs in the right side (c) >
  let g:airline#extensions#tabline#show_tab_count = 2
<
* configure filename match rules to exclude from the tabline. >
  let g:airline#extensions#tabline#excludes = []

* enable/disable display preview window buffer in the tabline. >
  let g:airline#extensions#tabline#exclude_preview = 1

* configure how numbers are displayed in tab mode. >
  let g:airline#extensions#tabline#tab_nr_type = 0 " # of splits (default)
  let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
  let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
  let g:airline#extensions#tabline#tabnr_formatter = 'tabnr'

  Note: last option can be used to specify a different formatter for
  displaying the numbers. By default tabline/formatter/tabnr.vim is used
  The argument of that setting should either be a filename that exists
  autoload/airline/extensions/tabline/formatter/ (without .vim extension)
  and needs to provide a format() function. Alternatively you can use a
  custom function name, that is defined e.g. in your .vimrc file. In any
  case, the function needs to take 2 arguments, tab_nr_type and tabpage
  number.
  For an example, have a look at the default tabline/formatter/tabnr.vim
<
* enable/disable displaying tab number in tabs mode. >
  let g:airline#extensions#tabline#show_tab_nr = 1

* enable/disable displaying tab number in tabs mode for ctrlspace. (c) >
  let g:airline#extensions#tabline#ctrlspace_show_tab_nr = 0

* enable/disable displaying tab type (e.g. [buffers]/[tabs]) >
  let g:airline#extensions#tabline#show_tab_type = 1

* show buffer label at first position: >
  let g:airline#extensions#tabline#buf_label_first = 1

* rename label for buffers (default: 'buffers') (c) >
  let g:airline#extensions#tabline#buffers_label = 'b'

* rename label for tabs (default: 'tabs') (c) >
  let g:airline#extensions#tabline#tabs_label = 't'

* change the symbol for skipped tabs/buffers (default '...') >
  let g:airline#extensions#tabline#overflow_marker = '…'

* always show current tabpage/buffer first >
  let airline#extensions#tabline#current_first = 1
<  default: 0

* enable/disable displaying index of the buffer.

  `buffer_idx_mode` allows 3 different modes to access buffers from the
  tabline. When enabled, numbers will be displayed in the tabline and
  mappings will be exposed to allow you to select a buffer directly.
  In default mode, when the variable is 1 Up to 10 mappings will be
  exposed. Note: As 10 and 1 have same prefix, we use 0 to replace 10. So,
  <leader>0 will jump to tenth buffer. Those mappings are not automatically
  created, vim-airline just exposes those `<Plug>AirlineSeelctTab` keys
  for you to map to a convenient key >

  let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  nmap <leader>0 <Plug>AirlineSelectTab0
  nmap <leader>- <Plug>AirlineSelectPrevTab
  nmap <leader>+ <Plug>AirlineSelectNextTab
<
  In mode 2, (when the variable is 2) 89 mappings will be exposed: >

  let g:airline#extensions#tabline#buffer_idx_mode = 2
  nmap <Leader>10 <Plug>AirlineSelectTab10
  nmap <Leader>11 <Plug>AirlineSelectTab11
  nmap <Leader>12 <Plug>AirlineSelectTab12
  nmap <Leader>13 <Plug>AirlineSelectTab13
  ...
  nmap <Leader>99 <Plug>AirlineSelectTab99
<
  The <Plug>AirlineSelect<Prev/Next>Tab mapping handles counts as well,
  so one can handle arbitrarily number of buffers/tabs.

  Mode 3 is exactly the same as mode 2, except the indexing start at 01,
  exposing 99 mappings: >

  let g:airline#extensions#tabline#buffer_idx_mode = 3
  nmap <Leader>01 <Plug>AirlineSelectTab01
  nmap <Leader>02 <Plug>AirlineSelectTab02
  nmap <Leader>03 <Plug>AirlineSelectTab03
  ...
  nmap <Leader>99 <Plug>AirlineSelectTab99
<
  This matches that of the numbering scheme of |:buffers|, letting
  `<Plug>AirlineSelectTab67` to reference buffer 67.

  Note: To avoid ambiguity, there won't be <Plug>AirlineSelectTab1
  - <Plug>AirlineSelectTab9 maps in mode 2 and 3.

  Note: Mappings will be ignored for filetypes that match
  `g:airline#extensions#tabline#keymap_ignored_filetypes`.

  Note: In buffer_idx_mode these mappings won't change the
  current tab, but switch to the buffer `visible` in the current tab.
  If you want to switch to a buffer, that is not visible use the
  `AirlineSelectPrev/NextTab` mapping (it supports using a count).
  Use |gt| for switching tabs.
  In tabmode, those mappings will be exposed as well and will switch
  to the specified tab.

* define the set of filetypes which are ignored for the selectTab
  keymappings: >
  let g:airline#extensions#tabline#keymap_ignored_filetypes =
        \ ['vimfiler', 'nerdtree']

* change the display format of the buffer index >
  let g:airline#extensions#tabline#buffer_idx_format = {
        \ '0': '0 ',
        \ '1': '1 ',
        \ '2': '2 ',
        \ '3': '3 ',
        \ '4': '4 ',
        \ '5': '5 ',
        \ '6': '6 ',
        \ '7': '7 ',
        \ '8': '8 ',
        \ '9': '9 '
        \}
<
* defines the name of a formatter for how buffer names are displayed. (c) >
  let g:airline#extensions#tabline#formatter = 'default'

  " here is how you can define a 'foo' formatter:
  " create a file in the dir autoload/airline/extensions/tabline/formatters/
  " called foo.vim >
  function! airline#extensions#tabline#formatters#foo#format(bufnr, buffers)
    return fnamemodify(bufname(a:bufnr), ':t')
  endfunction
  let g:airline#extensions#tabline#formatter = 'foo'
<
  Note: the following variables are used by the 'default' formatter.
  When no disambiguation is needed, both 'unique_tail_improved' and
  'unique_tail' delegate formatting to 'default', so these variables also
  control rendering of unique filenames when using these formatters.

    * configure whether buffer numbers should be shown. >
      let g:airline#extensions#tabline#buffer_nr_show = 0
<
    * configure how buffer numbers should be formatted with |printf()|. >
      let g:airline#extensions#tabline#buffer_nr_format = '%s: '
<
    * configure the formatting of filenames (see |filename-modifiers|). >
      let g:airline#extensions#tabline#fnamemod = ':p:.'
<
    * configure collapsing parent directories in buffer name. >
      let g:airline#extensions#tabline#fnamecollapse = 1
<
    * configure truncating non-active buffer names to specified length. >
      let g:airline#extensions#tabline#fnametruncate = 0

  " The `unique_tail` algorithm will display the tail of the filename, unless
  " there is another file of the same name, in which it will display it along
  " with the containing parent directory.
  let g:airline#extensions#tabline#formatter = 'unique_tail'

      " The following variables are also used by `unique_tail` formatter.
      " the meanings are the same as the ones in default formatter.

      let g:airline#extensions#tabline#fnamemod = ':p:.'
      let g:airline#extensions#tabline#fnamecollapse = 1

  " The `unique_tail_improved` algorithm will uniquify buffers names with
  " similar filename, suppressing common parts of paths.
  let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

  " The `short_path` algorithm is a simple formatter, that will show the
  filename, with its extension, and the first parent directory only.

  e.g.
     /home/user/project/subdir/file.ext -> subdir/file.ext

  let g:airline#extensions#tabline#formatter = 'short_path'

  " `short_path` can also display file name as relative to the current
  " directory, if possible
  let g:airline#extensions#tabline#fnamemod = ':h'

  " or display file name as relative to the home directory, if possible
  let g:airline#extensions#tabline#fnamemod = ':~:h'

  " The `short_path_improved` algorithm will only show the short path for
  " duplicate buffer names, otherwise suppressing directories.

  let g:airline#extensions#tabline#formatter = 'short_path_improved'

* defines the customized format() function to display tab title in tab mode. >
  let g:airline#extensions#tabline#tabtitle_formatter = 'MyTabTitleFormatter'
<
  Then define the MyTabTitleFormatter() function in your vimrc. >
    function MyTabTitleFormatter(n)
      let buflist = tabpagebuflist(a:n)
      let winnr = tabpagewinnr(a:n)
      let bufnr = buflist[winnr - 1]
      let winid = win_getid(winnr, a:n)
      let title = bufname(bufnr)

      if empty(title)
        if getqflist({'qfbufnr' : 0}).qfbufnr == bufnr
          let title = '[Quickfix List]'
        elseif winid && getloclist(winid, {'qfbufnr' : 0}).qfbufnr == bufnr
          let title = '[Location List]'
        else
          let title = '[No Name]'
        endif
      endif

      return title
    endfunction

* configure the minimum number of buffers needed to show the tabline. >
  let g:airline#extensions#tabline#buffer_min_count = 0
<
  Note: this setting only applies to a single tab and when `show_buffers` is
  true.

* configure the minimum number of tabs needed to show the tabline. >
  let g:airline#extensions#tabline#tab_min_count = 0
<
  Note: this setting only applies when `show_buffers` is false.

* configure separators for the tabline only. >
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''
  let g:airline#extensions#tabline#right_sep = ''
  let g:airline#extensions#tabline#right_alt_sep = ''

* configure whether close button should be shown: >
  let g:airline#extensions#tabline#show_close_button = 1

* configure symbol used to represent close button >
  let g:airline#extensions#tabline#close_symbol = 'X'

* configure pattern to be ignored on BufAdd autocommand >
  " fixes unnecessary redraw, when e.g. opening Gundo window
  let airline#extensions#tabline#ignore_bufadd_pat =
            \ '\c\vgundo|undotree|vimfiler|tagbar|nerd_tree'

Note: Enabling this extension will modify 'showtabline' and 'guioptions'.

* enable Refresh of tabline buffers on |BufAdd| autocommands
  (set this to one, if you note 'AirlineTablineRefresh', however, this
   won't update airline on |:badd| commands) >
  let airline#extensions#tabline#disable_refresh = 0

* preserve windows when closing a buffer from the bufferline
  (neovim specific, only works with buffers and not real tabs, default: 0) >
  let airline#extensions#tabline#middle_click_preserves_windows = 1
<
						*airline-tabline-hlgroups*
When the tabline is enabled, vim-airline exposes the following highlighting
groups:

  airline_tab:		default highlighting group for the tabline
  airline_tab_right:	idem, but for the right side of the tabline

  airline_tabsel:	highlighting group of the selected item
  airline_tabsel_right: idem, but for the right side of the tabline
  airline_tabmod:       highlighting group for a 'modified' buffer
  airline_tabmod_right: idem, but on the right side
  airline_tabmod_unsel: unselected tab with modified buffer
  airline_tabmod_unsel_right: (unused)
  airline_tabtype:      label group used by ctrlspace and tabws
  airline_tabfill:	highlighting group for the filler space
  airline_tablabel:     highlighting group for the label
  airline_tablabel_right: highlighting group for the label on the right side
  airline_tabhid:	hidden buffer
  airline_tabhid_right: idem, but on the right

-------------------------------------                      *airline-scrollbar*

Displays an Ascii Scrollbar for active windows with a width > 200.

* enable/disable scrollbar integration >
  let g:airline#extensions#scrollbar#enabled = 1 (default: 0)
* set minimum window width, below which the scollbar
  will be disabled >
  let g:airline#extensions#scrollbar#minwidth = 100 (default: 200)

-------------------------------------                        *airline-taboo*
taboo.vim <https://github.com/gcmt/taboo.vim>

* enable/disable taboo.vim integration >
  let g:airline#extensions#taboo#enabled = 1
<
-------------------------------------                        *airline-term*
Vim-Airline comes with a small extension for the styling the builtin
|terminal|. This requires Nvim or a Vim compiled with terminal support.

* enable/disable terminal integration >
  let g:airline#extensions#term#enabled = 1
  default: 1

-------------------------------------                        *airline-tabws*
vim-tabws <https://github.com/s1341/vim-tabws>

* enable/disable tabws integration >
  let g:airline#extensions#tabws#enabled = 1
<
-------------------------------------                       *airline-tagbar*
tagbar <https://github.com/majutsushi/tagbar>

* enable/disable tagbar integration >
  let g:airline#extensions#tagbar#enabled = 1
<
* change how tags are displayed (:help tagbar-statusline) >
  let g:airline#extensions#tagbar#flags = ''  (default)
  let g:airline#extensions#tagbar#flags = 'f'
  let g:airline#extensions#tagbar#flags = 's'
  let g:airline#extensions#tagbar#flags = 'p'
<
* configure how to search for the nearest tag (:help tagbar-statusline) >
  let g:airline#extensions#tagbar#searchmethod = 'nearest-stl' (default)
  let g:airline#extensions#tagbar#searchmethod = 'nearest'
  let g:airline#extensions#tagbar#searchmethod = 'scoped-stl'

* configure max filesize, after which to skip loading the extension
  If the file is larger, tags won't be displayed for performance reasons >
  let g:airline#extensions#tagbar#max_filesize = 1024*1024 (default)
<
-------------------------------------                       *airline-taglist*
taglist <https://github.com/yegappan/taglist>

* enable/disable taglist integration >
  let g:airline#extensions#taglist#enabled = 1
<
-------------------------------------                     *airline-tmuxline*
tmuxline <https://github.com/edkolev/tmuxline.vim>

* enable/disable tmuxline integration >
  let g:airline#extensions#tmuxline#enabled = 0
<
* configure which mode colors should be used in tmux statusline >
  let airline#extensions#tmuxline#color_template = 'normal' (default)
  let airline#extensions#tmuxline#color_template = 'insert'
  let airline#extensions#tmuxline#color_template = 'visual'
  let airline#extensions#tmuxline#color_template = 'replace'
<
* if specified, setting this option will trigger writing to the file whenever the
  airline theme is applied, i.e. when :AirlineTheme is executed and on vim
  startup >
  airline#extensions#tmuxline#snapshot_file =
   \  "~/.tmux-statusline-colors.conf"
<
-------------------------------------                     *airline-undotree*
Undotree <https://github.com/mbbill/undotree>

No configuration available.

-------------------------------------                     *airline-unicode*
Unicode <https://github.com/chrisbra/unicode.vim>

No configuration available.

-------------------------------------                     *airline-unite*
Unite <https://github.com/Shougo/unite.vim>

* enable/disable unite integration >
  let g:airline#extensions#unite#enabled = 1

-------------------------------------                     *airline-vim9lsp*
vim9lsp <https://github.com/yegappan/lsp>

* enable/disable vim9lsp integration >
  let airline#extensions#vim9lsp#enabled = 1
<
* vim9lsp error_symbol >
  let airline#extensions#vim9lsp#error_symbol = 'E:'
<
* vim9lsp warning >
  let airline#extensions#vim9lsp#warning_symbol = 'W:'
<
-------------------------------------                     *airline-vimagit*
vimagit <https://github.com/jreybert/vimagit>

* enable/disable vimagit integration >
  let g:airline#extensions#vimagit#enabled = 1
<
-------------------------------------                    *airline-vimcmake*
Vim-CMake <https://github.com/cdelledonne/vim-cmake>

* enable/disable Vim-CMake integration >
  let g:airline#extensions#vimcmake#enabled = 1
<
-------------------------------------                      *airline-vimtex*
vimtex <https://github.com/lervag/vimtex>

Shows the current file's vimtex related info.

* enable/disable vimtex integration >
  let g:airline#extensions#vimtex#enabled = 1
<
* left and right delimiters (shown only when status string is not empty) >
  let g:airline#extensions#vimtex#left = "{"
  let g:airline#extensions#vimtex#right = "}"

State indicators:

* the current tex file is the main project file
  (nothing is shown by default) >
  let g:airline#extensions#vimtex#main = ""

* the current tex file is a subfile of the project
  and the compilation is set for the main file >
  let g:airline#extensions#vimtex#sub_main = "m"

* the current tex file is a subfile of the project
  and the compilation is set for this subfile >
  let g:airline#extensions#vimtex#sub_local = "l"

* single compilation is running >
  let g:airline#extensions#vimtex#compiled = "c₁"

* continuous compilation is running >
  let g:airline#extensions#vimtex#continuous = "c"

* viewer is opened >
  let g:airline#extensions#vimtex#viewer = "v"

* use vimtex specific wordcount function
  for TeX buffers Note: this more accurate
  but may slow down Vim) >
  let g:airline#extensions#vimtex#wordcount = 1

-------------------------------------                   *airline-virtualenv*
virtualenv <https://github.com/jmcantrell/vim-virtualenv>

* enable/disable virtualenv integration >
  let g:airline#extensions#virtualenv#enabled = 1
<
* enable virtualenv for additional filetypes:
  (default: python): >
  let g:airline#extensions#virtualenv#ft = ['python', 'markdown', 'rmd']
<
-------------------------------------                   *airline-vista*
vista.vim <https://github.com/liuchengxu/vista.vim>

* enable/disable vista integration >
  let g:airline#extensions#vista#enabled = 1

-------------------------------------                   *airline-whitespace*
* enable/disable detection of whitespace errors. >
  let g:airline#extensions#whitespace#enabled = 1
<
* disable detection of whitespace errors. >
  " useful to call for particular file types (e.g., in "ftplugin/*")
  silent! call airline#extensions#whitespace#disable()
<
* customize the type of mixed indent checking to perform. >
  " must be all spaces or all tabs before the first non-whitespace character
  let g:airline#extensions#whitespace#mixed_indent_algo = 0 (default)

  " certain number of spaces are allowed after tabs, but not in between
  " this algorithm works well for /* */ style comments in a tab-indented file
  let g:airline#extensions#whitespace#mixed_indent_algo = 1

  " spaces are allowed after tabs, but not in between
  " this algorithm works well with programming styles that use tabs for
  " indentation and spaces for alignment
  let g:airline#extensions#whitespace#mixed_indent_algo = 2
<
* customize the whitespace symbol. >
  let g:airline#extensions#whitespace#symbol = '!'
<
* configure which whitespace checks to enable. >
  " indent: mixed indent within a line
  " long:   overlong lines
  " trailing: trailing whitespace
  " mixed-indent-file: different indentation in different lines
  " conflicts: checks for conflict markers
  let g:airline#extensions#whitespace#checks =
    \  [ 'indent', 'trailing', 'long', 'mixed-indent-file', 'conflicts' ]

  " this can also be configured for an individual buffer
  let b:airline_whitespace_checks =
    \  [ 'indent', 'trailing', 'long', 'mixed-indent-file', 'conflicts' ]
<
* configure the max number of lines where whitespace checking is enabled. >
  let g:airline#extensions#whitespace#max_lines = 20000
<
* configure whether a message should be displayed. >
  let g:airline#extensions#whitespace#show_message = 1
<
* configure the formatting of the warning messages. >
  let g:airline#extensions#whitespace#trailing_format = 'trailing[%s]'
  let g:airline#extensions#whitespace#mixed_indent_format =
     \ 'mixed-indent[%s]'
  let g:airline#extensions#whitespace#long_format = 'long[%s]'
  let g:airline#extensions#whitespace#mixed_indent_file_format =
     \ 'mix-indent-file[%s]'
  let g:airline#extensions#whitespace#conflicts_format = 'conflicts[%s]'

* configure custom trailing whitespace regexp rule >
  let g:airline#extensions#whitespace#trailing_regexp = '\s$'

  " this can also be configured for an individual buffer
  let b:airline_whitespace_trailing_regexp = '\s$'

* configure, which filetypes have special treatment of /* */ comments,
  matters for mix-indent-file algorithm: >
  let airline#extensions#c_like_langs =
     \ ['arduino', 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php']
<
* disable whitespace checking for an individual buffer >
  " Checking is enabled by default because b:airline_whitespace_disabled
  " is by default not defined:
  unlet b:airline_whitespace_disabled

  " If b:airline_whitespace_disabled is defined and is non-zero for a buffer,
  " then whitespace checking will be disabled for that buffer; for example:
  " let b:airline_whitespace_disabled = 1
<
* disable specific whitespace checks for individual filetypes >
  " The global variable g:airline#extensions#whitespace#skip_indent_check_ft
  " defines what whitespaces checks to skip per filetype.
  " the list can contain any of the available checks,
  " (see above at g:airline#extensions#whitespace#checks)
  " To disable mixed-indent-file for go files use:
  let g:airline#extensions#whitespace#skip_indent_check_ft =
   \  {'go': ['mixed-indent-file']}
<
-------------------------------------                   *airline-windowswap*
vim-windowswap <https://github.com/wesQ3/vim-windowswap>

* enable/disable vim-windowswap integration >
  let g:airline#extensions#windowswap#enabled = 1

* set marked window indicator string >
  let g:airline#extensions#windowswap#indicator_text = 'WS'
<
-------------------------------------                    *airline-wordcount*
* enable/disable word counting of the document/visual selection >
  let g:airline#extensions#wordcount#enabled = 1
<
* set list of filetypes for which word counting is enabled: >
  " The default value matches filetypes typically used for documentation
  " such as markdown and help files. Default is:
  let g:airline#extensions#wordcount#filetypes =
    \ ['asciidoc', 'help', 'mail', 'markdown', 'rmd', 'nroff', 'org', 'plaintex', 'rst', 'tex', 'text'])
  " Use ['all'] to enable for all filetypes.

* defines the name of a formatter for word count will be displayed: >
  " The default will try to guess LC_NUMERIC and format number accordingly
  " e.g. 1,042 in English and 1.042 in German locale
  let g:airline#extensions#wordcount#formatter = 'default'

  " enable reading time formatter
  let g:airline#extensions#wordcount#formatter = 'readingtime'

  " here is how you can define a 'foo' formatter:
  " create a file in autoload/airline/extensions/wordcount/formatters/
  " called foo.vim, which defines the following function signature:
  function! airline#extensions#wordcount#formatters#foo#to_string(wordcount)
    return a:wordcount == 0 ? 'NONE' :
        \ a:wordcount > 100 ? 'okay' : 'not enough')
  endfunction
  let g:airline#extensions#wordline#formatter = 'foo'
  " The function is passed the word count of the document or visual selection

* defines how to display the wordcount statistics for the default formatter >
  " Defaults are below.  If fmt_short isn't defined, fmt is used.
  " '%s' will be substituted by the word count
  " fmt_short is displayed when window width is less than 80
  let g:airline#extensions#wordcount#formatter#default#fmt = '%s words'
  let g:airline#extensions#wordcount#formatter#default#fmt_short = '%sW'
<
-------------------------------------                     *airline-xkblayout*

The vim-xkblayout extension will only be enabled, if the global variable
`g:XkbSwitchLib` is set or `FcitxCurrentIM()` exists.
`g:XkbSwitchLib` should be set to a C library that will be called
using |libcall()| with the function name `Xkb_Switch_getXkbLayout`. For
details on how to use it, see e.g. <https://github.com/ierton/xkb-switch>

* enable/disable vim-xkblayout extension >
  let g:airline#extensions#xkblayout#enabled = 1

* redefine keyboard layout short codes to shown in status >
  let g:airline#extensions#xkblayout#short_codes =
    \  {'Russian-Phonetic': 'RU', 'ABC': 'EN'}
<
  'RU' instead of system 'Russian-Phonetic',
  'EN' instead of system 'ABC'.

  Default: >
  let g:airline#extensions#xkblayout#short_codes =
    \ {'2SetKorean': 'KR', 'Chinese': 'CN', 'Japanese': 'JP'}

* define path to the backend switcher library
  Linux with gnome (Install https://github.com/lyokha/g3kb-switch): >
   let g:XkbSwitchLib = '/usr/lib/libg3kbswitch.so'
<
  Linux (Install https://github.com/ierton/xkb-switch): >
   let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
<
  macOS (Install https://github.com/vovkasm/input-source-switcher): >
   let g:XkbSwitchLib = '/usr/local/lib/libInputSourceSwitcher.dylib'
<
  Linux with fcitx (Install https://github.com/fcitx/fcitx5):
   Install https://github.com/lilydjwg/fcitx.vim) to get `FcitxCurrentIM()`

-------------------------------------                     *airline-xtabline*
xtabline <https://github.com/mg979/vim-xtabline>

This is a simplified and stand-alone version of the original extension.
The bigger version adds fzf commands, session management, tab bookmarks, and
features that you may not need. They both require |vim-airline| anyway.

Main features and default mappings of this extension are:

* tab cwd persistence, also across sessions if vim-obsession is being used.

* buffer filtering in the tabline: only buffers whose path is within the tab
  cwd will be shown in the tabline.

* toggle tabs/buffer view on the tabline, toggle buffer filtering:
>
  nmap <F5>          <Plug>XTablineToggleTabs
  nmap <leader><F5>  <Plug>XTablineToggleFiltering

* reopen last closed tab, restoring its cwd and buffers:
>
  nmap <leader>tr    <Plug>XTablineReopen <SID>ReopenLastTab

* switch among filtered buffers (accepts count):
>
  nmap ]l            <Plug>XTablineNextBuffer
  nmap [l            <Plug>XTablinePrevBuffer

* go to N buffer (a count must be provided):
>
  nmap <BS>          <Plug>XTablineSelectBuffer

* alternative command if count is not provided:
>
  let g:xtabline_alt_action = "buffer #"

Note: Make sure to also enable >
  :let g:airline#extensions#tabline#show_buffers = 1
otherwise the tabline might not actually be displayed correctly (see
|airline-tabline|)

* exclude fugitive logs and files that share part of the real buffer path:
>
  let g:xtabline_include_previews = 0           (default 1)

* activate fast cwd selection mappings:
>
  let g:xtabline_cd_commands = 1                (default 0)

* default mappings for them are:
>
  map <leader>cdc       <Plug>XTablineCdCurrent
  map <leader>cdd       <Plug>XTablineCdDown1
  map <leader>cd2       <Plug>XTablineCdDown2
  map <leader>cd3       <Plug>XTablineCdDown3
  map <leader>cdh       <Plug>XTablineCdHome

Note: if you don't use these mappings and change the cwd, the tabline won't
be updated automatically. Either re-enter the tab or press <F5> two times.

* here are some easier mappings to change tab buffer:
>
  nnoremap <silent> <expr> <Right> v:count ?
   \ airline#extensions#tabline#xtabline#next_buffer(v:count) : "\<Right>"
  nnoremap <silent> <expr> <Left>  v:count ?
   \ airline#extensions#tabline#xtabline#prev_buffer(v:count) : "\<Left>"

-------------------------------------                    *airline-ycm*
YouCompleteMe <https://github.com/ycm-core/YouCompleteMe>

Shows number of errors and warnings in the current file detected by YCM.

* enable/disable YCM integration >
  let g:airline#extensions#ycm#enabled = 1

* set error count prefix >
  let g:airline#extensions#ycm#error_symbol = 'E:'

* set warning count prefix >
  let g:airline#extensions#ycm#warning_symbol = 'W:'
<

-------------------------------------                    *airline-zoomwintab*
zoomwintab <https://github.com/troydm/zoomwintab.vim>

* enable/disable zoomwintab integration >
  let g:airline#extensions#zoomwintab#enabled = 1

* zoomwintab's zoomin symbol >
  let g:airline#extensions#zoomwintab#status_zoomed_in = 'Currently Zoomed In'

default: '> Zoomed'

* zoomwintab's zoomout symbol >
  let g:airline#extensions#zoomwintab#status_zoomed_out = 'Currently Zoomed Out'

default: ''

=============================================================================
ADVANCED CUSTOMIZATION                      *airline-advanced-customization*

The defaults will accommodate the mass majority of users with minimal
configuration. However, if you want to reposition sections or contents you
can do so with built-in helper functions, which makes it possible to create
sections in a more declarative style.

-------------------------------------                        *airline-parts*
A part is something that contains metadata that eventually gets rendered into
the statusline. You can define parts that contain constant strings or
functions. Defining parts is needed if you want to use features like automatic
insertion of separators or hiding based on window width.

For example, this is how you would define a part function: >
  call airline#parts#define_function('foo', 'GetFooText')
<
Here is how you would define a part that is visible only if the window width
greater than a minimum width. >
  call airline#parts#define_minwidth('foo', 50)
<
Parts can be configured to be visible conditionally. >
  call airline#parts#define_condition('foo', 'getcwd() =~ "work_dir"')
<
Now add part "foo" to section airline_section_y: >
  let g:airline_section_y = airline#section#create_right(['ffenc','foo'])
<
Note: Part definitions are combinative; e.g. the two examples above modify
the same `foo` part.

Note: Look at the source code and tests for the full API.

-------------------------------------             *airline-predefined-parts*
The following list of parts are predefined by vim-airline.

* `mode`         displays the current mode
* `iminsert`     displays the current insert method
* `paste`        displays the paste indicator
* `crypt`        displays the crypted indicator
* `spell`        displays the spell indicator
* `filetype`     displays the file type
* `readonly`     displays the read only indicator
* `file`         displays the filename and modified indicator
* `path`         displays the filename (absolute path) and modifier indicator
* `linenr`       displays the current line number
* `maxlinenr`    displays the number of lines in the buffer
* `ffenc`        displays the file format and encoding

And the following are defined for their respective extensions:

`ale_error_count` `ale_warning_count` `branch` `eclim` `hunks`
`languageclient_error_count` `languageclient_warning_count` `lsp_error_count`
`lsp_warning_count``neomake_error_count` `neomake_warning_count`
`nvimlsp_error_count` `nvimlsp_warning_count` `obsession`
`syntastic-warn` `syntastic-err` `tagbar` `whitespace` `windowswap`
`ycm_error_count` `ycm_warning_count`

-------------------------------------                      *airline-accents*
Accents can be defined on any part, like so: >
  call airline#parts#define_accent('foo', 'red')
<
This will override the colors of that part by using what is defined in that
particular accent. In the above example, the `red` accent is used, which
means regardless of which section the part is used in, it will have red
foreground colors instead of the section's default foreground color.

The following accents are defined by default. Themes can define their
variants of the colors, but defaults will be provided if missing. >
  bold, italic, red, green, blue, yellow, orange, purple, none
<
The defaults configure the mode and line number parts to be bold, and the
readonly part to be red.

"none" is special. This can be used, to remove a bold accent from an existing
theme. For example, the mode part of the statusline is usually defined to be
bold. However, it can be hard to remove an existing bold accent from the
default configuration. Therefore, you can use the none accent to remove
existing accents, so if you put >
    call airline#parts#define_accent('mode', 'none')
the mode section will be set to non-bold font style.

-------------------------------------                     *airline-sections*
Once a part is defined, you can use helper functions to generate the
statuslines for each section. For example, to use the part above, we could
define a section like this: >
  function! AirlineInit()
    let g:airline_section_a = airline#section#create(['mode', ' ', 'foo'])
    let g:airline_section_b = airline#section#create_left(['ffenc','file'])
    let g:airline_section_c = airline#section#create(['%{getcwd()}'])
  endfunction
  autocmd User AirlineAfterInit call AirlineInit()
<
This will create a section with the `mode`, followed by a space, and our
`foo` part in section `a`. Section `b` will have two parts with a left-side
separator. And section `c` will contain the current path. You may notice that
the space and cwd are not defined parts. For convenience, if a part of that
key does not exist, it will be inserted as is. The unit tests will be a good
resource for possibilities.

Note: The use of |User| is important, because most extensions are lazily
loaded, so we must give them a chance to define their parts before we can use
them. Also this autocommand is only triggered, after the airline functions
are actually available on startup.

Note: The `airline#section#create` function and friends will do its best to
create a section with the appropriate separators, but it only works for
function and text parts. Special 'statusline' items like %f or raw/undefined
parts will not work as it is not possible to inspect their widths/contents
before rendering to the statusline.

=============================================================================
FUNCREFS                                                  *airline-funcrefs*

vim-airline internally uses funcrefs to integrate with third party plugins,
and you can tap into this functionality to extend it for you needs. This is
the most powerful way to customize the statusline, and sometimes it may be
easier to go this route than the above methods.

Every section can have two values. The default value is the global `g:`
variable which is used in the absence of a `w:` value. This makes it very
easy to override only certain parts of the statusline by only defining
window-local variables for a subset of all sections.

-------------------------------------                  *add_statusline_func*
                                              *add_inactive_statusline_func*
The following is an example of how you can extend vim-airline to support a
new plugin. >
  function! MyPlugin(...)
    if &filetype == 'MyPluginFileType'
      let w:airline_section_a = 'MyPlugin'
      let w:airline_section_b = '%f'
      let w:airline_section_c = '%{MyPlugin#function()}'
      let g:airline_variable_referenced_in_statusline = 'foo'
    endif
  endfunction
  call airline#add_statusline_func('MyPlugin')
<
Notice that only the left side of the statusline is overwritten. This means
the right side (the line/column numbers, etc) will be intact.

To have the function act only on statuslines of inactive functions, use
`airline#add_inactive_statusline_func('MyPlugin')`

-------------------------------------               *remove_statusline_func*
You can also remove a function as well, which is useful for when you want a
temporary override. >
  call airline#remove_statusline_func('MyPlugin')
<
=============================================================================
PIPELINE                                                  *airline-pipeline*

Sometimes you want to do more than just use overrides. The statusline funcref
is invoked and passed two arguments.  The first of these arguments is the
statusline builder.  You can use this to build completely custom statuslines
to your liking.  Here is an example: >
>
  function! MyPlugin(...)
    " first variable is the statusline builder
    let builder = a:1

    " WARNING: the API for the builder is not finalized and may change
    call builder.add_section('Normal', '%f')
    call builder.add_section('WarningMsg', '%{getcwd()}')
    call builder.split()
    call builder.add_section('airline_z', '%p%%')

    " tell the core to use the contents of the builder
    return 1
  endfunction
<
The above example uses various example highlight groups to demonstrate
that you can use any combination from the loaded colorscheme. However, if
you want colors to change between modes, you should use one of the section
highlight groups, e.g. `airline_a` and `airline_b`.

The second variable is the context, which is a dictionary containing various
values such as whether the statusline is active or not, and the window
number.
>
  context = {
    'winnr': 'the window number for the statusline',
    'active': 'whether the window is active or not',
    'bufnr': 'the current buffer for this window',
  }
<
-------------------------------------        *airline-pipeline-return-codes*
The pipeline accepts various return codes and can be used to determine the
next action.  The following are the supported codes: >
   0   the default, continue on with the next funcref
  -1   do not modify the statusline
   1   modify the statusline with the current contents of the builder
<
Note: Any value other than 0 will halt the pipeline and prevent the next
funcref from executing.

=============================================================================
WRITING EXTENSIONS                              *airline-writing-extensions*

For contributions into the plugin, here are the following guidelines:

1.  For simple 'filetype' checks, they can be added directly into the
`extensions.vim` file.

2.  Pretty much everything else should live as a separate file under the
`extensions/` directory.

  a.  Inside `extensions.vim`, add a check for some variable or command that
      is always available (these must be defined in `plugin/`, and _not_
      `autoload/` of the other plugin).  If it exists, then initialize the
      extension. This ensures that the extension is loaded if and only if the
      user has the other plugin installed.  Also, a check to
      `airline#extensions#foo_plugin#enabled` should be performed to allow
      the user to disable it.

  b.  Configuration variables for the extension should reside in the
      extension, e.g. `g:airline#extensions#foo_plugin#bar_variable`.

See the source of |example.vim| for documented code of how to write one.
Looking at the other extensions is also a good resource.

=============================================================================
WRITING THEMES                                              *airline-themes*

Themes are written "close to the metal" -- you will need to know some basic
VimL syntax to write a theme, but if you've written in any programming
language before it will be easy to pick up.

The |dark.vim| theme fully documents this procedure and will guide you
through the process.

For other examples, you can visit the official themes repository at
<https://github.com/vim-airline/vim-airline-themes>.  It also includes
examples such as |jellybeans.vim| which define colors by extracting highlight
groups from the underlying colorscheme.

=============================================================================
TROUBLESHOOTING                                    *airline-troubleshooting*

Q. There are no colors.
A. You need to set up your terminal correctly.  For more details, see
   <http://vim.wikia.com/wiki/256_colors_in_vim>.  Alternatively, if you want
   to bypass the automatic detection of terminal colors, you can force Vim
   into 256 color mode with this: >
  set t_Co=256
<
  Also if you enable true color mode in your terminal, make sure it will work
  correctly with your terminal. Check if it makes a difference without it: >
  set notermguicolors

Q. Powerline symbols are not showing up.
A. First, you must install patched powerline fonts. Second, you must enable
   unicode in vim.  >
  set encoding=utf-8
<
Q. There is a pause when leaving insert mode.
A. Add the following to your vimrc.  >
  set ttimeoutlen=50
<
Q. The colors look a little off for some themes.
A. Certain themes are derived from the active colorscheme by extracting
   colors from predefined highlight groups.  These airline themes will look
   good for their intended matching colorschemes, but will be hit or miss
   when loaded with other colorschemes.

Q. Themes are missing
A. Themes have been extracted into the vim-airlines-themes repository. Simply
   clone https://github.com/vim-airline/vim-airline-themes and everything
   should work again.

Q. Performance is bad
A. Check the question at the wiki:
   https://github.com/vim-airline/vim-airline/wiki/FAQ#i-have-a-performance-problem

Q. Something strange happens on certain autocommands
A. Try to disable the autocommand by setting the 'eventignore' option like
   this: >
   set eventignore+=FocusGained

Solutions to other common problems can be found in the Wiki:
<https://github.com/vim-airline/vim-airline/wiki/FAQ>

=============================================================================
CONTRIBUTIONS                                        *airline-contributions*

Contributions and pull requests are welcome.

=============================================================================
LICENSE                                                    *airline-license*

MIT License. Copyright © 2013-2021 Bailey Ling, Christian Brabandt, Mike
Hartington et al.

 vim:tw=78:ts=8:ft=help:norl:
./plugin/airline.vim	[[[1
310
" MIT License. Copyright (c) 2013-2021 Bailey Ling, Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

if &cp || v:version < 702 || (exists('g:loaded_airline') && g:loaded_airline)
  finish
endif
let g:loaded_airline = 1

let s:airline_initialized = 0
function! s:init()
  if s:airline_initialized
    return
  endif
  let s:airline_initialized = 1

  call airline#extensions#load()
  call airline#init#sections()

  let s:theme_in_vimrc = exists('g:airline_theme')
  if s:theme_in_vimrc
    try
      if g:airline_theme is# 'random'
        let g:airline_theme=s:random_theme()
      endif
      let palette = g:airline#themes#{g:airline_theme}#palette
    catch
      call airline#util#warning(printf('Could not resolve airline theme "%s". Themes have been migrated to github.com/vim-airline/vim-airline-themes.', g:airline_theme))
      let g:airline_theme = 'dark'
    endtry
    try
      silent call airline#switch_theme(g:airline_theme)
    catch
      call airline#util#warning(printf('Could not find airline theme "%s".', g:airline_theme))
      let g:airline_theme = 'dark'
      silent call airline#switch_theme(g:airline_theme)
    endtry
  else
    let g:airline_theme = 'dark'
    silent call s:on_colorscheme_changed()
  endif

  call airline#util#doautocmd('AirlineAfterInit')
endfunction

let s:active_winnr = -1
function! s:on_window_changed(event)
  " don't trigger for Vim popup windows
  if &buftype is# 'popup'
    return
  endif

  if pumvisible() && (!&previewwindow || g:airline_exclude_preview)
    " do not trigger for previewwindows
    return
  endif
  let s:active_winnr = winnr()
  " Handle each window only once, since we might come here several times for
  " different autocommands.
  let l:key = [bufnr('%'), s:active_winnr, winnr('$'), tabpagenr(), &ft]
  if get(g:, 'airline_last_window_changed', []) == l:key
        \ && &stl is# '%!airline#statusline('.s:active_winnr.')'
        \ && &ft !~? 'gitcommit'
    " fugitive is special, it changes names and filetypes several times,
    " make sure the caching does not get into its way
    return
  endif
  let g:airline_last_window_changed = l:key
  call s:init()
  call airline#update_statusline()
endfunction

function! s:on_focus_gained()
  if &eventignore =~? 'focusgained'
    return
  endif

  if airline#util#try_focusgained()
    unlet! w:airline_lastmode | :call <sid>airline_refresh(1)
  endif
endfunction

function! s:on_cursor_moved()
  if winnr() != s:active_winnr || !exists('w:airline_active')
    call s:on_window_changed('CursorMoved')
  endif
  call airline#update_tabline()
endfunction

function! s:on_colorscheme_changed()
  call s:init()
  unlet! g:airline#highlighter#normal_fg_hi
  call airline#highlighter#reset_hlcache()
  if !s:theme_in_vimrc
    call airline#switch_matching_theme()
  endif

  " couldn't find a match, or theme was defined, just refresh
  call airline#load_theme()
endfunction

function! airline#cmdwinenter(...)
  call airline#extensions#apply_left_override('Command Line', '')
endfunction

function! s:airline_toggle()
  if exists("#airline")
    augroup airline
      au!
    augroup END
    augroup! airline

    if exists("s:stl")
      let &stl = s:stl
    endif
    if exists("s:tal")
      let [&tal, &showtabline] = s:tal
    endif
    call airline#highlighter#reset_hlcache()

    call airline#util#doautocmd('AirlineToggledOff')
  else
    let s:stl = &statusline
    let s:tal = [&tabline, &showtabline]
    augroup airline
      autocmd!

      autocmd CmdwinEnter *
            \ call airline#add_statusline_func('airline#cmdwinenter')
            \ | call <sid>on_window_changed('CmdwinEnter')
      autocmd CmdwinLeave * call airline#remove_statusline_func('airline#cmdwinenter')

      autocmd ColorScheme * call <sid>on_colorscheme_changed()
      " Set all statuslines to inactive
      autocmd FocusLost * call airline#update_statusline_focuslost()
      " Refresh airline for :syntax off
      autocmd SourcePre */syntax/syntax.vim
            \ call airline#extensions#tabline#buffers#invalidate()
      autocmd VimEnter * call <sid>on_window_changed('VimEnter')
      autocmd WinEnter * call <sid>on_window_changed('WinEnter')
      autocmd FileType * call <sid>on_window_changed('FileType')
      autocmd BufWinEnter * call <sid>on_window_changed('BufWinEnter')
      autocmd BufUnload * call <sid>on_window_changed('BufUnload')
      if exists('##CompleteDone')
        autocmd CompleteDone * call <sid>on_window_changed('CompleteDone')
      endif
      " non-trivial number of external plugins use eventignore=all, so we need to account for that
      autocmd CursorMoved * call <sid>on_cursor_moved()

      autocmd VimResized * call <sid>on_focus_gained()
      if exists('*timer_start') && exists('*funcref') && &eventignore !~? 'focusgained'
        " do not trigger FocusGained on startup, it might erase the intro screen (see #1817)
        " needs funcref() (needs 7.4.2137) and timers (7.4.1578)
        let Handler=funcref('<sid>FocusGainedHandler')
        let s:timer=timer_start(5000, Handler)
      else
        autocmd FocusGained * call <sid>on_focus_gained()
      endif

      if exists("##TerminalOpen")
        " Using the same function with the TermOpen autocommand
        " breaks for Neovim see #1828, looks like a neovim bug.
        autocmd TerminalOpen * :call airline#load_theme() " reload current theme for Terminal, forces the terminal extension to be loaded
      endif
      autocmd TabEnter * :unlet! w:airline_lastmode | let w:airline_active=1
      autocmd BufWritePost */autoload/airline/themes/*.vim
            \ exec 'source '.split(globpath(&rtp, 'autoload/airline/themes/'.g:airline_theme.'.vim', 1), "\n")[0]
            \ | call airline#load_theme()
      autocmd User AirlineModeChanged nested call airline#mode_changed()

      if get(g:, 'airline_statusline_ontop', 0)
        " Force update of tabline more often
        autocmd InsertEnter,InsertLeave,CursorMovedI * :call airline#update_tabline()
      endif

      if exists("##ModeChanged")
        autocmd ModeChanged * :call airline#update_tabline()
      endif
    augroup END

    if !airline#util#stl_disabled(winnr())
      if &laststatus < 2
        let _scroll=&scroll
        if !get(g:, 'airline_statusline_ontop', 0)
          set laststatus=2
        endif
        if &scroll != _scroll
          let &scroll = _scroll
        endif
      endif
    endif
    if s:airline_initialized
      call s:on_window_changed('Init')
    endif

    call airline#util#doautocmd('AirlineToggledOn')
  endif
endfunction

function! s:get_airline_themes(a, l, p)
  return airline#util#themes(a:a)
endfunction

function! s:airline_theme(...)
  if a:0
    try
      let theme = a:1
      if  theme is# 'random'
        let theme = s:random_theme()
      endif
      call airline#switch_theme(theme)
    catch " discard error
    endtry
    if a:1 is# 'random'
      echo g:airline_theme
    endif
  else
    echo g:airline_theme
  endif
endfunction

function! s:airline_refresh(...)
  " a:1, fast refresh, do not reload the theme
  let fast=!empty(get(a:000, 0, 0))
  if !exists("#airline")
    " disabled
    return
  endif
  call airline#util#doautocmd('AirlineBeforeRefresh')
  call airline#highlighter#reset_hlcache()
  if !fast
    call airline#load_theme()
  endif
  call airline#update_statusline()
  call airline#update_tabline()
endfunction

function! s:FocusGainedHandler(timer)
  if exists("s:timer") && a:timer == s:timer && exists('#airline') && &eventignore !~? 'focusgained'
    augroup airline
      au FocusGained * call s:on_focus_gained()
    augroup END
  endif
endfu

function! s:airline_extensions()
  let loaded = airline#extensions#get_loaded_extensions()
  let files = split(globpath(&rtp, 'autoload/airline/extensions/*.vim', 1), "\n")
  call map(files, 'fnamemodify(v:val, ":t:r")')
  if empty(files)
    echo "No extensions loaded"
    return
  endif
  echohl Title
  echo printf("%-15s\t%s\t%s", "Extension", "Extern", "Status")
  echohl Normal
  let set=[]
  for ext in sort(files)
    if index(set, ext) > -1
      continue
    endif
    let indx=match(loaded, '^'.ext.'\*\?$')
    let external = (indx > -1 && loaded[indx] =~ '\*$')
    echo printf("%-15s\t%s\t%sloaded", ext, external, indx == -1 ? 'not ' : '')
    call add(set, ext)
  endfor
endfunction

function! s:rand(max) abort
  if exists("*rand")
    " Needs Vim 8.1.2342
    let number=rand()
  elseif has("reltime")
    let timerstr=reltimestr(reltime())
    let number=split(timerstr, '\.')[1]+0
  elseif has("win32") && &shell =~ 'cmd'
    let number=system("echo %random%")+0
  else
    " best effort, bash and zsh provide $RANDOM
    " cmd.exe on windows provides %random%, but expand()
    " does not seem to be able to expand this correctly.
    " In the worst case, this always returns zero
    let number=expand("$RANDOM")+0
  endif
  return number % a:max
endfunction

function! s:random_theme() abort
  let themes=airline#util#themes('')
  return themes[s:rand(len(themes))]
endfunction

command! -bar -nargs=? -complete=customlist,<sid>get_airline_themes AirlineTheme call <sid>airline_theme(<f-args>)
command! -bar AirlineToggleWhitespace call airline#extensions#whitespace#toggle()
command! -bar AirlineToggle  call s:airline_toggle()
command! -bar -bang AirlineRefresh call s:airline_refresh(<q-bang>)
command! AirlineExtensions   call s:airline_extensions()

call airline#init#bootstrap()
call s:airline_toggle()
if exists("v:vim_did_enter") && v:vim_did_enter
  call <sid>on_window_changed('VimEnter')
endif

let &cpo = s:save_cpo
unlet s:save_cpo
./test/.themisrc	[[[1
28
let s:helper = themis#helper('assert')
let s:deps = themis#helper('deps')

call themis#helper('command').with(s:helper)
call s:deps.git('vim-airline/vim-airline-themes')
call s:deps.git('tomasr/molokai')

function! MyFuncref(...)
  call a:1.add_raw('hello world')
  return 1
endfunction

function! MyIgnoreFuncref(...)
  return -1
endfunction

function! MyAppend1(...)
  call a:1.add_raw('hello')
endfunction

function! MyAppend2(...)
  call a:1.add_raw('world')
endfunction

let g:airline#extensions#default#layout = [
      \ [ 'c', 'a', 'b', 'warning' ],
      \ [ 'x', 'z', 'y' ]
      \ ]
./test/airline.vimspec	[[[1
64
Describe airline.vim
  Before
    let g:airline_statusline_funcrefs = []
  End

  It should run user funcrefs first
    call airline#add_statusline_func('MyFuncref')
    let &statusline = ''
    call airline#update_statusline()
    Assert Match(airline#statusline(1), 'hello world')
  End

  It should not change the statusline with -1
    call airline#add_statusline_funcref(function('MyIgnoreFuncref'))
    let &statusline = 'foo'
    call airline#update_statusline()
    Assert Equals(&statusline, 'foo')
  End

  It should support multiple chained funcrefs
    call airline#add_statusline_func('MyAppend1')
    call airline#add_statusline_func('MyAppend2')
    call airline#update_statusline()
    Assert Match(airline#statusline(1), 'helloworld')
  End

  It should allow users to redefine sections
    let g:airline_section_a = airline#section#create(['mode', 'mode'])
    call airline#update_statusline()
    Assert Match(airline#statusline(1), '%{airline#util#wrap(airline#parts#mode(),0)}%#airline_a#%#airline_a_bold#%{airline#util#wrap(airline#parts#mode(),0)}%#airline_a#')
  End

  It should remove funcrefs properly
    let c = len(g:airline_statusline_funcrefs)
    call airline#add_statusline_func('MyIgnoreFuncref')
    call airline#remove_statusline_func('MyIgnoreFuncref')
    Assert Equals(len(g:airline_statusline_funcrefs), c)
  End

  It should overwrite the statusline with active and inactive splits
    wincmd s
    Assert NotMatch(airline#statusline(1), 'inactive')
    Assert Match(airline#statusline(2), 'inactive')
    wincmd c
  End

  It should collapse the inactive split if the variable is set true
    let g:airline_inactive_collapse = 1
    wincmd s
    Assert NotMatch(getwinvar(2, '&statusline'), 'airline#parts#mode')
    wincmd c
  end

  It should collapse the inactive split if the variable is set false
    let g:airline_inactive_collapse = 0
    wincmd s
    Assert NotEquals(getwinvar(2, '&statusline'), 'airline#parts#mode')
    wincmd c
  End

  It should include check_mode
    Assert Match(airline#statusline(1), 'airline#check_mode')
  End
End
./test/builder.vimspec	[[[1
107
Describe builder.vim
  Describe active builder
    Before each
      let s:builder = airline#builder#new({'active': 1})
    End

    It should start with an empty statusline
      let stl = s:builder.build()
      Assert Equals(stl, '')
    End

    It should transition colors from one to the next
      call s:builder.add_section('Normal', 'hello')
      call s:builder.add_section('Search', 'world')
      let stl = s:builder.build()
      Assert Match(stl,'%#Normal#hello%#Normal_to_Search#%#Search#world')
    End


    It should reuse highlight group if background colors match
      highlight Foo1 ctermfg=1 ctermbg=2
      highlight Foo2 ctermfg=1 ctermbg=2
      call s:builder.add_section('Foo1', 'hello')
      call s:builder.add_section('Foo2', 'world')
      let stl = s:builder.build()
      Assert Match(stl, '%#Foo1#helloworld')
    End


    It should switch highlight groups if foreground colors differ
      highlight Foo1 ctermfg=1 ctermbg=2
      highlight Foo2 ctermfg=2 ctermbg=2
      call s:builder.add_section('Foo1', 'hello')
      call s:builder.add_section('Foo2', 'world')
      let stl = s:builder.build()
      Assert Match(stl, '%#Foo1#hello%#Foo1_to_Foo2#%#Foo2#world')
    End

    It should split left/right sections
      call s:builder.split()
      let stl = s:builder.build()
      Assert Match(stl, '%=')
    End

    It after split, sections use the right separator
      call s:builder.split()
      call s:builder.add_section('Normal', 'hello')
      call s:builder.add_section('Search', 'world')
      let stl = s:builder.build()
      Assert Match(stl, 'hello%#Normal_to_Search#%#Search#world')
    End

    It should not repeat the same highlight group
      call s:builder.add_section('Normal', 'hello')
      call s:builder.add_section('Normal', 'hello')
      let stl = s:builder.build()
      Assert Match(stl, '%#Normal#hellohello')
    End

    It should replace accent groups with the specified group
      call s:builder.add_section('Normal', '%#__accent_foo#hello')
      let stl = s:builder.build()
      Assert Match(stl, '%#Normal#%#Normal_foo#hello')
    End

    It should replace two accent groups with correct groups
      call s:builder.add_section('Normal', '%#__accent_foo#hello%#__accent_bar#world')
      let stl = s:builder.build()
      Assert Match(stl, '%#Normal_foo#hello%#Normal_bar#world')
    End

    It should special restore group should go back to previous group
      call s:builder.add_section('Normal', '%#__restore__#')
      let stl = s:builder.build()
      Assert NotMatch(stl, '%#__restore__#')
      Assert Match(stl, '%#Normal#')
    End

    It should blend colors from the left through the split to the right
      call s:builder.add_section('Normal', 'hello')
      call s:builder.split()
      call s:builder.add_section('Search', 'world')
      let stl = s:builder.build()
      Assert Match(stl, 'Normal_to_Search')
    End
  End

  Describe inactive builder
    Before each
      let s:builder = airline#builder#new({'active': 0})
    End

    It should transition colors from one to the next
      call s:builder.add_section('Normal', 'hello')
      call s:builder.add_section('Search', 'world')
      let stl = s:builder.build()
      Assert Match(stl, '%#Normal_inactive#hello%#Normal_to_Search_inactive#%#Search_inactive#world')
    End

    It should not render accents
      call s:builder.add_section('Normal', '%#__accent_foo#hello%#foo#foo%#__accent_bar#world')
      let stl = s:builder.build()
      Assert Equals(stl, '%#Normal_inactive#hello%#foo_inactive#fooworld')
    End
  End

End
./test/commands.vimspec	[[[1
50
Describe commands.vim

  It should toggle off and on
    execute 'AirlineToggle'
    Assert False(exists('#airline'))
    execute 'AirlineToggle'
    Assert True(exists('#airline'))
  End

  It should toggle whitespace off
    call airline#extensions#load()
    execute 'AirlineToggleWhitespace'
    Assert False(exists('#airline_whitespace'))
  End

  It should toggle whitespace on
    call airline#extensions#load()
    execute 'AirlineToggleWhitespace'
    Assert True(exists('#airline_whitespace'))
  End

  It should display theme name "simple"
    execute 'AirlineTheme simple'
    Assert Equals(g:airline_theme, 'simple')
  End

  It should display theme name "dark"'
    execute 'AirlineTheme dark'
    Assert Equals(g:airline_theme, 'dark')
  End

  It should display theme name "dark" because specifying a name that does not exist
    execute 'AirlineTheme doesnotexist'
    Assert Equals(g:airline_theme, 'dark')
  End

  It should display theme name molokai
    colors molokai
    Assert Equals(g:airline_theme, 'molokai')
  End

  It should have a refresh command
    Assert Equals(exists(':AirlineRefresh'), 2)
  End

  It should have a extensions command
    Assert Equals(exists(':AirlineExtensions'), 2)
  End

End
./test/extensions_default.vimspec	[[[1
47
Describe extensions_default.vim
  Before
    let g:airline#extensions#default#layout = [
          \ [ 'c', 'a', 'b', 'warning' ],
          \ [ 'x', 'z', 'y' ]
          \ ]

    let s:builder = airline#builder#new({'active': 1})
  End

  It should use the layout airline_a_to_airline_b
    call airline#extensions#default#apply(s:builder, { 'winnr': 1, 'active': 1 })
    let stl = s:builder.build()
    Assert Match(stl, 'airline_c_to_airline_a')
  end

  It should use the layout airline_a_to_airline_b
    call airline#extensions#default#apply(s:builder, { 'winnr': 1, 'active': 1 })
    let stl = s:builder.build()
    Assert Match(stl, 'airline_a_to_airline_b')
  End

  It should use the layout airline_b_to_airline_warning
    call airline#extensions#default#apply(s:builder, { 'winnr': 1, 'active': 1 })
    let stl = s:builder.build()
    Assert Match(stl, 'airline_b_to_airline_warning')
  end

  it should use the layout airline_x_to_airline_z
    call airline#extensions#default#apply(s:builder, { 'winnr': 1, 'active': 1 })
    let stl = s:builder.build()
    Assert Match(stl, 'airline_x_to_airline_z')
  end

  it should use the layout airline_z_to_airline_y
    call airline#extensions#default#apply(s:builder, { 'winnr': 1, 'active': 1 })
    let stl = s:builder.build()
    Assert Match(stl, 'airline_z_to_airline_y')
  end

  it should only render warning section in active splits
    wincmd s
    Assert Match(airline#statusline(1), 'warning')
    Assert NotMatch(airline#statusline(2), 'warning')
    wincmd c
  end
end
./test/extensions_tabline.vimspec	[[[1
14
Describe extensions_tabline.vim

  It should use a tabline
    e! file1
    Assert Match(airline#extensions#tabline#get(), '%#airline_tabsel# %(%{airline#extensions#tabline#get_buffer_name(\d)}%) |%=%#airline_tabfill_to_airline_tabfill#%#airline_tabfill# buffers' )
  End

  It Trigger on BufDelete autocommands
    e! file1
    sp file2
    bd
    Assert Match(airline#extensions#tabline#get(), '%#airline_tabsel# %(%{airline#extensions#tabline#get_buffer_name(\d)}%) |%=%#airline_tabfill_to_airline_tabfill#%#airline_tabfill# buffers' )
  End
End
./test/highlighter.vimspec	[[[1
28
Describe highlighter.vim
  It should create separator highlight groups
    hi highlighter1 ctermfg=1 ctermbg=2
    hi highlighter2 ctermfg=3 ctermbg=4
    call airline#highlighter#add_separator('highlighter1', 'highlighter2', 0)
    let hl = airline#highlighter#get_highlight('highlighter1_to_highlighter2')
    Assert Equal([ 'NONE', 'NONE', '4', '2', '' ], hl)
  End

  if exists("+termguicolors")
    It should create separator highlight groups with termguicolors
      set termguicolors
      hi highlighter1 guifg=#cd0000 guibg=#00cd00 ctermfg=1 ctermbg=2
      hi highlighter2 guifg=#cdcd00 guibg=#0000ee ctermfg=3 ctermbg=4
      call airline#highlighter#add_separator('highlighter1', 'highlighter2', 0)
      let hl = airline#highlighter#get_highlight('highlighter1_to_highlighter2')
      Assert Equal(['#0000ee', '#00cd00', '4', '2', '' ], hl)
    End
  endif

  It should populate accent colors
    Assert False(exists('g:airline#themes#dark#palette.normal.airline_c_red'))
    call airline#themes#patch(g:airline#themes#dark#palette)
    call airline#highlighter#add_accent('red')
    call airline#highlighter#highlight(['normal'])
    Assert NotEqual(0, hlID('airline_c_red'))
  End
End
./test/init.vimspec	[[[1
109
Describe init.vim
  function! s:clear()
    for key in s:sections
      unlet! g:airline_section_{key}
    endfor
  endfunction

  let s:sections = ['a', 'b', 'c', 'gutter', 'x', 'y', 'z', 'warning']
  call airline#init#bootstrap()

  Before each
    call s:clear()
    call airline#init#sections()
  End

  It section a should have mode, paste, spell, iminsert
    Assert Match(g:airline_section_a, 'mode')
    Assert Match(g:airline_section_a, 'paste')
    Assert Match(g:airline_section_a, 'spell')
    Assert Match(g:airline_section_a, 'iminsert')
  End

  It section b should be blank because no extensions are installed
    Assert Equals(g:airline_section_b, '')
  End

  It section c should be file and coc_status
    set noautochdir
    call airline#init#sections()
    Assert Equals(g:airline_section_c, '%<%f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#%#__accent_bold#%#__restore__#%#__accent_bold#%#__restore__#')
  End

  It section c should be path and coc_status
    set autochdir
    call s:clear()
    call airline#init#sections()
    Assert Equals(g:airline_section_c, '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#%#__accent_bold#%#__restore__#%#__accent_bold#%#__restore__#')
  End

  It section x should be filetype
    Assert Equals(g:airline_section_x, '%#__accent_bold#%#__restore__#%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#wrap(airline#parts#filetype(),0)}')
  End

  It section y should be fenc and ff
    Assert Equals(g:airline_section_y, '%{airline#util#wrap(airline#parts#ffenc(),0)}')
  End

  It section z should be line numbers
    Assert Match(g:airline_section_z, '%p%%')
    Assert Match(g:airline_section_z, '%l')
    Assert Match(g:airline_section_z, '%v')
  End

  It section gutter should be blank unless csv extension is installed
    " Note: the csv extension uses only the window local variable
    Assert Equals(g:airline_section_gutter, '%=')
  End

  It section warning should be blank
    Assert Match(g:airline_section_warning, '')
  End

  It should not redefine sections already defined
    for s in s:sections
      let g:airline_section_{s} = s
    endfor
    call airline#init#bootstrap()
    for s in s:sections
      Assert Equals(g:airline_section_{s}, s)
    endfor
  End

  It all default statusline extensions should be blank
    Assert Equals(airline#parts#get('ale_error_count').raw, '')
    Assert Equals(airline#parts#get('ale_warning_count').raw, '')
    Assert Equals(airline#parts#get('lsp_error_count').raw, '')
    Assert Equals(airline#parts#get('lsp_warning_count').raw, '')
    Assert Equals(airline#parts#get('nvimlsp_error_count').raw, '')
    Assert Equals(airline#parts#get('nvimlsp_warning_count').raw, '')
    Assert Equals(airline#parts#get('hunks').raw, '')
    Assert Equals(airline#parts#get('branch').raw, '')
    Assert Equals(airline#parts#get('eclim').raw, '')
    Assert Equals(airline#parts#get('neomake_error_count').raw, '')
    Assert Equals(airline#parts#get('neomake_warning_count').raw, '')
    Assert Equals(airline#parts#get('obsession').raw, '')
    Assert Equals(airline#parts#get('syntastic-err').raw, '')
    Assert Equals(airline#parts#get('syntastic-warn').raw, '')
    Assert Equals(airline#parts#get('tagbar').raw , '')
    Assert Equals(airline#parts#get('whitespace').raw, '')
    Assert Equals(airline#parts#get('windowswap').raw , '')
    Assert Equals(airline#parts#get('ycm_error_count').raw, '')
    Assert Equals(airline#parts#get('ycm_warning_count').raw, '')
    Assert Equals(airline#parts#get('languageclient_error_count').raw, '')
    Assert Equals(airline#parts#get('languageclient_warning_count').raw, '')
    Assert Equals(airline#parts#get('coc_status').raw, '')
    Assert Equals(airline#parts#get('coc_current_function').raw, '')
    Assert Equals(airline#parts#get('vista').raw, '')
    Assert Equals(airline#parts#get('coc_warning_count').raw, '')
    Assert Equals(airline#parts#get('coc_error_count').raw, '')
    Assert Equals(airline#parts#get('battery').raw, '')
  End

  it should not redefine parts already defined
    call airline#parts#define_raw('linenr', 'bar')
    call s:clear()
    call airline#init#sections()
    Assert Match(g:airline_section_z, 'bar')
  End
End
./test/parts.vimspec	[[[1
58
Describe parts.vim

  It overwrItes existing values
    call airline#parts#define('foo', { 'test': '123' })
    Assert Equals(airline#parts#get('foo').test, '123')
    call airline#parts#define('foo', { 'test': '321' })
    Assert Equals(airline#parts#get('foo').test, '321')
  End

  It can define a function part
    call airline#parts#define_function('func', 'bar')
    Assert Equals(airline#parts#get('func').function, 'bar')
  End

  It can define a text part
    call airline#parts#define_text('text', 'bar')
    Assert Equals(airline#parts#get('text').text, 'bar')
  End

  It can define a raw part
    call airline#parts#define_raw('raw', 'bar')
    Assert Equals(airline#parts#get('raw').raw, 'bar')
  End

  It can define a minwidth
    call airline#parts#define_minwidth('mw', 123)
    Assert Equals(airline#parts#get('mw').minwidth, 123)
  End

  It can define a condition
    call airline#parts#define_condition('part', '1')
    Assert Equals(airline#parts#get('part').condition, '1')
  End

  It can define a accent
    call airline#parts#define_accent('part', 'red')
    Assert Equals(airline#parts#get('part').accent, 'red')
  End

  It value should be blank
    Assert Equals(airline#parts#filetype(), '')
  End

  It can overwrIte a filetype
    set ft=aaa
    Assert Equals(airline#parts#filetype(), 'aaa')
  End

  It can overwrite a filetype
    "GItHub actions's vim's column is smaller than 90
    set ft=aaaa
    if &columns >= 90
      Assert Equals(airline#parts#filetype(), 'aaaa')
    else
      Assert Equals(airline#parts#filetype(), 'aaa…')
    endif
  End
End
./test/section.vimspec	[[[1
77
Describe section
  Before
    call airline#parts#define_text('text', 'text')
    call airline#parts#define_raw('raw', 'raw')
    call airline#parts#define_function('func', 'SectionSpec')
  End

  It should be able to reference default parts
    let s = airline#section#create(['paste'])
    Assert Equals(s, '%{airline#util#wrap(airline#parts#paste(),0)}')
  End

  It should create sections wIth no separators
    let s = airline#section#create(['text', 'raw', 'func'])
    Assert Equals(s, '%{airline#util#wrap("text",0)}raw%{airline#util#wrap(SectionSpec(),0)}')
  End

  It should create left sections with separators
    let s = airline#section#create_left(['text', 'text'])
    Assert Equals(s, '%{airline#util#wrap("text",0)}%{airline#util#append("text",0)}')
  End

  It should create right sections wIth separators
    let s = airline#section#create_right(['text', 'text'])
    Assert Equals(s, '%{airline#util#prepend("text",0)}%{airline#util#wrap("text",0)}')
  End

  It should prefix with accent group if provided and restore afterwards
    call airline#parts#define('hi', {
          \ 'raw': 'hello',
          \ 'accent': 'red',
          \ })
    let s = airline#section#create(['hi'])
    Assert Equals(s, '%#__accent_red#hello%#__restore__#')
  End

  It should accent functions
    call airline#parts#define_function('hi', 'Hello')
    call airline#parts#define_accent('hi', 'bold')
    let s = airline#section#create(['hi'])
    Assert Equals(s, '%#__accent_bold#%{airline#util#wrap(Hello(),0)}%#__restore__#')
  End

  It should parse out a section from the distro
    call airline#extensions#load()
    let s = airline#section#create(['whitespace'])
    Assert Match(s, 'airline#extensions#whitespace#check')
  End

  It should use parts as is if they are not found
    let s = airline#section#create(['asdf', 'func'])
    Assert Equals(s, 'asdf%{airline#util#wrap(SectionSpec(),0)}')
  End

  It should force add separators for raw and missing keys
    let s = airline#section#create_left(['asdf', 'raw'])
    Assert Equals(s, 'asdf  raw')
    let s = airline#section#create_left(['asdf', 'aaaa', 'raw'])
    Assert Equals(s, 'asdf  aaaa  raw')
    let s = airline#section#create_right(['raw', '%f'])
    Assert Equals(s, 'raw  %f')
    let s = airline#section#create_right(['%t', 'asdf', '%{getcwd()}'])
    Assert Equals(s, '%t  asdf  %{getcwd()}')
  End

  It should empty out parts that do not pass their condition
    call airline#parts#define_text('conditional', 'conditional')
    call airline#parts#define_condition('conditional', '0')
    let s = airline#section#create(['conditional'])
    Assert Equals(s, '%{0 ? airline#util#wrap("conditional",0) : ""}')
  End

  It should not draw two separators after another
    let s = airline#section#create_right(['ffenc','%{strftime("%H:%M")}'])
    Assert Equals(s, '%{airline#util#prepend(airline#parts#ffenc(),0)}%{strftime("%H:%M")}')
  End
End
./test/themes.vimspec	[[[1
91
Describe themes.vim
  After each
    highlight clear Foo
    highlight clear Normal
  End

  It should extract correct colors
    call airline#highlighter#reset_hlcache()
    highlight Foo ctermfg=1 ctermbg=2
    let colors = airline#themes#get_highlight('Foo')
    Assert Equals(colors[0], 'NONE')
    Assert Equals(colors[1], 'NONE')
    Assert Equals(colors[2], '1')
    Assert Equals(colors[3], '2')
  End

  if exists("+termguicolors")
    It should extract correct colors with termguicolors
      call airline#highlighter#reset_hlcache()
      set termguicolors
      highlight Foo guifg=#cd0000 guibg=#00cd00 ctermfg=1 ctermbg=2
      let colors = airline#themes#get_highlight('Foo')
      Assert Equals(colors[0], '#cd0000')
      Assert Equals(colors[1], '#00cd00')
      Assert Equals(colors[2], '1')
      Assert Equals(colors[3], '2')
    End
  endif

  It should extract from normal if colors unavailable
    call airline#highlighter#reset_hlcache()
    highlight Normal ctermfg=100 ctermbg=200
    highlight Foo ctermbg=2
    let colors = airline#themes#get_highlight('Foo')
    Assert Equals(colors[0], 'NONE')
    Assert Equals(colors[1], 'NONE')
    Assert Equals(colors[2], '100')
    Assert Equals(colors[3], '2')
  End

  It should flip target group if It is reversed
    call airline#highlighter#reset_hlcache()
    highlight Foo ctermbg=222 ctermfg=103 cterm=reverse
    let colors = airline#themes#get_highlight('Foo')
    Assert Equals(colors[0], 'NONE')
    Assert Equals(colors[1], 'NONE')
    Assert Equals(colors[2], '222')
    Assert Equals(colors[3], '103')
  End

  It should pass args through correctly
    call airline#highlighter#reset_hlcache()
    hi clear Normal
    let hl = airline#themes#get_highlight('Foo', 'bold', 'italic')
    Assert Equals(hl, ['NONE', 'NONE', 'NONE', 'NONE', 'bold,italic'])

    let hl = airline#themes#get_highlight2(['Foo','bg'], ['Foo','fg'], 'italic', 'bold')
    Assert Equals(hl, ['NONE', 'NONE', 'NONE', 'NONE', 'italic,bold'])
  End

  It should generate color map with mirroring
    let map = airline#themes#generate_color_map(
          \ [ 1, 1, 1, 1, '1' ],
          \ [ 2, 2, 2, 2, '2' ],
          \ [ 3, 3, 3, 3, '3' ],
          \ )
    Assert Equals(map.airline_a[0], 1)
    Assert Equals(map.airline_b[0], 2)
    Assert Equals(map.airline_c[0], 3)
    Assert Equals(map.airline_x[0], 3)
    Assert Equals(map.airline_y[0], 2)
    Assert Equals(map.airline_z[0], 1)
  End

  It should generate color map with full set of colors
    let map = airline#themes#generate_color_map(
          \ [ 1, 1, 1, 1, '1' ],
          \ [ 2, 2, 2, 2, '2' ],
          \ [ 3, 3, 3, 3, '3' ],
          \ [ 4, 4, 4, 4, '4' ],
          \ [ 5, 5, 5, 5, '5' ],
          \ [ 6, 6, 6, 6, '6' ],
          \ )
    Assert Equals(map.airline_a[0], 1)
    Assert Equals(map.airline_b[0], 2)
    Assert Equals(map.airline_c[0], 3)
    Assert Equals(map.airline_x[0], 4)
    Assert Equals(map.airline_y[0], 5)
    Assert Equals(map.airline_z[0], 6)
  End
End
./test/util.vimspec	[[[1
69
call airline#init#bootstrap()

function! Util1()
  let g:count += 1
endfunction

function! Util2()
  let g:count += 2
endfunction

function! Util3(...)
  let g:count = a:0
endfunction

Describe util
  Before each
    let g:count = 0
  End

  It has append wrapper function
    Assert Equals(airline#util#append('', 0), '')
    Assert Equals(airline#util#append('1', 0), '   1')
  End

  It should be same &columns
    let g:airline_statusline_ontop = 1
    Assert Equals(airline#util#winwidth(), &columns)
  End

  It should be same winwidth(0)
    let g:airline_statusline_ontop = 0
    Assert Equals(airline#util#winwidth(), winwidth(0))
  End

  It should be same winwidth(30)
    Assert Equals(airline#util#winwidth(30, 0), winwidth(30))
  End

  It has prepend wrapper function
    Assert Equals(airline#util#prepend('', 0), '')
    Assert Equals(airline#util#prepend('1', 0), '1  ')
  End

  It has getwinvar function
    Assert Equals(airline#util#getwinvar(1, 'asdf', '123'), '123')
    call setwinvar(1, 'vspec', 'is cool')
    Assert Equals(airline#util#getwinvar(1, 'vspec', ''), 'is cool')
  End

  It has exec funcrefs helper functions
    call airline#util#exec_funcrefs([function('Util1'), function('Util2')])
    Assert Equals(g:count, 3)

    call airline#util#exec_funcrefs([function('Util3')], 1, 2, 3, 4)
    Assert Equals(g:count, 4)
  End

  It should ignore minwidth if less than 0
    Assert Equals(airline#util#append('foo', -1), '   foo')
    Assert Equals(airline#util#prepend('foo', -1), 'foo  ')
    Assert Equals(airline#util#wrap('foo', -1), 'foo')
  End

  It should return empty if winwidth() > minwidth
    Assert Equals(airline#util#append('foo', 99999), '')
    Assert Equals(airline#util#prepend('foo', 99999), '')
    Assert Equals(airline#util#wrap('foo', 99999), '')
  End
End
