" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/issue_template.md	[[[1
4
> What is the latest commit SHA in your installed vim-gitgutter?

> What vim/nvim version are you on?

./.gitignore	[[[1
5
/doc/tags
/misc
/test/*.actual
*.log

./LICENCE	[[[1
22
MIT License

Copyright (c) Andrew Stewart

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

./README.mkd	[[[1
751
## vim-gitgutter

A Vim plugin which shows a git diff in the sign column.  It shows which lines have been added, modified, or removed.  You can also preview, stage, and undo individual hunks; and stage partial hunks.  The plugin also provides a hunk text object.

The signs are always up to date and the plugin never saves your buffer.

The name "gitgutter" comes from the Sublime Text 3 plugin which inspired this in 2013.

Features:

* Shows signs for added, modified, and removed lines.
* Runs the diffs asynchronously where possible.
* Ensures signs are always up to date.
* Never saves the buffer.
* Quick jumping between blocks of changed lines ("hunks").
* Stage/undo/preview individual hunks.
* Previews highlight intra-line changes.
* Stage partial hunks.
* Provides a hunk text object.
* Diffs against index (default) or any commit.
* Heeds git's "assume unchanged" bit.
* Allows folding all unchanged text.
* Provides fold text showing whether folded lines have been changed.
* Can load all hunk locations into quickfix list or the current window's location list.
* Handles line endings correctly, even with repos that do CRLF conversion.
* Handles clean/smudge filters.
* Optional line highlighting.
* Optional line number highlighting. (Only available in Neovim 0.3.2 or higher)
* Fully customisable (signs, sign column, line (number) highlights, mappings, extra git-diff arguments, etc).
* Can be toggled on/off, globally or per buffer.
* Preserves signs from other plugins.
* Easy to integrate diff stats into status line; built-in integration with [vim-airline](https://github.com/bling/vim-airline/).
* Works with fish shell (in addition to the usual shells).

Constraints:

* Supports git only.  If you work with other version control systems, I recommend [vim-signify](https://github.com/mhinz/vim-signify).
* Relies on the `FocusGained` event.  If your terminal doesn't report focus events, either use something like [Terminus][] or set `let g:gitgutter_terminal_reports_focus=0`.  For tmux, `set -g focus-events on` in your tmux.conf.

Compatibility:

Compatible back to Vim 7.4, and probably 7.3.


### Screenshot

![screenshot](./screenshot.png?raw=true)

In the screenshot above you can see:

* Lines 183-184 are new.
* Lines 186-187 have been modified.
* The preview for the modified lines highlights changed regions within the line.


### Installation

Install using your favourite package manager, or use Vim's built-in package support.

Vim:

```
mkdir -p ~/.vim/pack/airblade/start
cd ~/.vim/pack/airblade/start
git clone https://github.com/airblade/vim-gitgutter.git
vim -u NONE -c "helptags vim-gitgutter/doc" -c q
```

Neovim:


```
mkdir -p ~/.config/nvim/pack/airblade/start
cd ~/.config/nvim/pack/airblade/start
git clone https://github.com/airblade/vim-gitgutter.git
nvim -u NONE -c "helptags vim-gitgutter/doc" -c q
```


### Windows

There is a potential risk on Windows due to `cmd.exe` prioritising the current folder over folders in `PATH`.  If you have a file named `git.*` (i.e. with any extension in `PATHEXT`) in your current folder, it will be executed instead of git whenever the plugin calls git.

You can avoid this risk by configuring the full path to your git executable.  For example:

```viml
" This path probably won't work
let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe'
```

Unfortunately I don't know the correct escaping for the path - if you do, please let me know!


### Getting started

When you make a change to a file tracked by git, the diff markers should appear automatically.  The delay is governed by vim's `updatetime` option; the default value is `4000`, i.e. 4 seconds, but I suggest reducing it to around 100ms (add `set updatetime=100` to your vimrc).  Note `updatetime` also controls the delay before vim writes its swap file (see `:help updatetime`).

You can jump between hunks with `[c` and `]c`.  You can preview, stage, and undo hunks with `<leader>hp`, `<leader>hs`, and `<leader>hu` respectively.

You cannot unstage a staged hunk.

After updating the signs, the plugin fires the `GitGutter` User autocommand.

After staging a hunk or part of a hunk, the plugin fires the `GitGutterStage` User autocommand.


#### Activation

You can explicitly turn vim-gitgutter off and on (defaults to on):

* turn off with `:GitGutterDisable`
* turn on with `:GitGutterEnable`
* toggle with `:GitGutterToggle`.

To toggle vim-gitgutter per buffer:

* turn off with `:GitGutterBufferDisable`
* turn on with `:GitGutterBufferEnable`
* toggle with `:GitGutterBufferToggle`

You can turn the signs on and off (defaults to on):

* turn on with `:GitGutterSignsEnable`
* turn off with `:GitGutterSignsDisable`
* toggle with `:GitGutterSignsToggle`.

And you can turn line highlighting on and off (defaults to off):

* turn on with `:GitGutterLineHighlightsEnable`
* turn off with `:GitGutterLineHighlightsDisable`
* toggle with `:GitGutterLineHighlightsToggle`.

Note that if you have line highlighting on and signs off, you will have an empty sign column – more accurately, a sign column with invisible signs.  This is because line highlighting requires signs and Vim/NeoVim always shows the sign column when there are signs even if the signs are invisible.

With Neovim 0.3.2 or higher, you can turn line number highlighting on and off (defaults to off):

* turn on with `:GitGutterLineNrHighlightsEnable`
* turn off with `:GitGutterLineNrHighlightsDisable`
* toggle with `:GitGutterLineNrHighlightsToggle`.

The same caveat applies to line number highlighting as to line highlighting just above.

If you switch off both line highlighting and signs, you won't see the sign column.

In older Vims (pre 8.1.0614 / Neovim 0.4.0) vim-gitgutter will suppress the signs when a file has more than 500 changes, to avoid slowing down the UI.  As soon as the number of changes falls below the limit vim-gitgutter will show the signs again.  You can configure the threshold with:

```viml
let g:gitgutter_max_signs = 500  " default value (Vim < 8.1.0614, Neovim < 0.4.0)
let g:gitgutter_max_signs = -1   " default value (otherwise)
```

You can also remove the limit by setting `g:gitgutter_max_signs = -1`.

#### Hunks

You can jump between hunks:

* jump to next hunk (change): `]c`
* jump to previous hunk (change): `[c`.

Both of those take a preceding count.

To set your own mappings for these, for example `]h` and `[h`:

```viml
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
```

When you jump between hunks, a message like `Hunk 4 of 11` is shown on the command line. If you want to turn the message off, you can use:

```viml
let g:gitgutter_show_msg_on_hunk_jumping = 0
```

You can load all your hunks into the quickfix list with `:GitGutterQuickFix`.  Note this ignores any unsaved changes in your buffers. If the option `g:gitgutter_use_location_list` is set, this command will load hunks into the current window's location list instead.  Use `:copen` (or `:lopen`) to open the quickfix / location list or add a custom command like this:

```viml
command! Gqf GitGutterQuickFix | copen
```

You can stage or undo an individual hunk when your cursor is in it:

* stage the hunk with `<Leader>hs` or
* undo it with `<Leader>hu`.

To stage part of an additions-only hunk by:

* either visually selecting the part you want and staging with your mapping, e.g. `<Leader>hs`;
* or using a range with the `GitGutterStageHunk` command, e.g. `:42,45GitGutterStageHunk`.

To stage part of any hunk:

* preview the hunk, e.g. `<Leader>hp`;
* move to the preview window, e.g. `:wincmd P`;
* delete the lines you do not want to stage;
* stage the remaining lines: either write (`:w`) the window or stage via `<Leader>hs` or `:GitGutterStageHunk`.

Note the above workflow is not possible if you have opted in to preview hunks with Vim's popup windows.

See the FAQ if you want to unstage staged changes.

The `.` command will work with both these if you install [repeat.vim](https://github.com/tpope/vim-repeat).

To set your own mappings for these, for example if you prefer `g`-based maps:

```viml
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
```

And you can preview a hunk's changes with `<Leader>hp`.  The location of the preview window is configured with `g:gitgutter_preview_win_location` (default `'bo'`).  You can of course change this mapping, e.g:

```viml
nmap ghp <Plug>(GitGutterPreviewHunk)
```

A hunk text object is provided which works in visual and operator-pending modes.

- `ic` operates on all lines in the current hunk.
- `ac` operates on all lines in the current hunk and any trailing empty lines.

To re-map these, for example to `ih` and `ah`:

```viml
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)
```

If you don't want vim-gitgutter to set up any mappings at all, use this:

```viml
let g:gitgutter_map_keys = 0
```

Finally, you can force vim-gitgutter to update its signs across all visible buffers with `:GitGutterAll`.

See the customisation section below for how to change the defaults.


### Vimdiff

Use the `GitGutterDiffOrig` command to open a vimdiff view of the current buffer, respecting `g:gitgutter_diff_relative_to` and `:gitgutter_diff_base`.


### Folding

Use the `GitGutterFold` command to fold all unchanged lines, leaving just the hunks visible.  Use `zr` to unfold 3 lines of context above and below a hunk.

Execute `GitGutterFold` a second time to restore the previous view.

Use `gitgutter#fold#foldtext()` to augment the default `foldtext()` with an indicator of whether the folded lines have been changed.

```viml
set foldtext=gitgutter#fold#foldtext()
```

For a closed fold with changed lines:

```
Default foldtext():         +-- 45 lines: abcdef
gitgutter#fold#foldtext():  +-- 45 lines (*): abcdef
```

You can use `gitgutter#fold#is_changed()` in your own `foldtext` expression to find out whether the folded lines have been changed.


### Status line

Call the `GitGutterGetHunkSummary()` function from your status line to get a list of counts of added, modified, and removed lines in the current buffer.  For example:

```viml
" Your vimrc
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}
```


### Customisation

You can customise:

* The sign column's colours
* Whether or not the sign column is shown when there aren't any signs (defaults to no)
* How to handle non-gitgutter signs
* The signs' colours and symbols
* Line highlights
* Line number highlights (only in Neovim 0.3.2 or higher)
* The diff syntax colours used in the preview window
* The intra-line diff highlights used in the preview window
* Whether the diff is relative to the index (default) or working tree.
* The base of the diff
* Extra arguments for `git` when running `git diff`
* Extra arguments for `git diff`
* Key mappings
* Whether vim-gitgutter is on initially (defaults to on)
* Whether signs are shown (defaults to yes)
* Whether line highlighting is on initially (defaults to off)
* Whether line number highlighting is on initially (defaults to off)
* Whether vim-gitgutter runs asynchronously (defaults to yes)
* Whether to clobber or preserve non-gitgutter signs
* The priority of gitgutter's signs.
* Whether to use a floating/popup window for hunk previews
* The appearance of a floating/popup window for hunk previews
* Whether to populate the quickfix list or a location list with all hunks

Please note that vim-gitgutter won't override any colours or highlights you've set in your colorscheme.


#### Sign column

Set the `SignColumn` highlight group to change the sign column's colour.  For example:

```viml
" vim-gitgutter used to do this by default:
highlight! link SignColumn LineNr

" or you could do this:
highlight SignColumn guibg=whatever ctermbg=whatever
```

By default the sign column will appear when there are signs to show and disappear when there aren't.  To always have the sign column, add to your vimrc:

```viml
" Vim 7.4.2201
set signcolumn=yes
```

GitGutter can preserve or ignore non-gitgutter signs.  For Vim v8.1.0614 and later you can set gitgutter's signs' priorities with `g:gitgutter_sign_priority`, so gitgutter defaults to clobbering other signs.  For Neovim v0.4.0 and later you can set an expanding sign column so gitgutter again defaults to clobbering other signs.  Otherwise, gitgutter defaults to preserving other signs.  You can configure this with:

```viml
let g:gitgutter_sign_allow_clobber = 1
```


#### Signs' colours and symbols

If you or your colourscheme has defined `GitGutter*` highlight groups, the plugin will use them for the signs' colours.

If you want the background colours to match the sign column, but don't want to update the `GitGutter*` groups yourself, you can get the plugin to do it:

```viml
let g:gitgutter_set_sign_backgrounds = 1
```

If no `GitGutter*` highlight groups exist, the plugin will check the `Diff*` highlight groups.  If their foreground colours differ the plugin will use them; if not, these colours will be used:

```viml
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
```

To customise the symbols, add the following to your `~/.vimrc`:

```viml
let g:gitgutter_sign_added = 'xx'
let g:gitgutter_sign_modified = 'yy'
let g:gitgutter_sign_removed = 'zz'
let g:gitgutter_sign_removed_first_line = '^^'
let g:gitgutter_sign_removed_above_and_below = '{'
let g:gitgutter_sign_modified_removed = 'ww'
```


#### Line highlights

Similarly to the signs' colours, set up the following highlight groups in your colorscheme or `~/.vimrc`:

```viml
GitGutterAddLine          " default: links to DiffAdd
GitGutterChangeLine       " default: links to DiffChange
GitGutterDeleteLine       " default: links to DiffDelete
GitGutterChangeDeleteLine " default: links to GitGutterChangeLine, i.e. DiffChange
```

For example, in some colorschemes the `DiffText` highlight group is easier to read than `DiffChange`.  You could use it like this:

```viml
highlight link GitGutterChangeLine DiffText
```


#### Line number highlights

NOTE: This feature requires Neovim 0.3.2 or higher.

Similarly to the signs' colours, set up the following highlight groups in your colorscheme or `~/.vimrc`:

```viml
GitGutterAddLineNr          " default: links to CursorLineNr
GitGutterChangeLineNr       " default: links to CursorLineNr
GitGutterDeleteLineNr       " default: links to CursorLineNr
GitGutterChangeDeleteLineNr " default: links to GitGutterChangeLineNr
```

Maybe you think `CursorLineNr` is a bit annoying.  For example, you could use `Underlined` for this:

```viml
highlight link GitGutterChangeLineNr Underlined
```


#### The diff syntax colours used in the preview window

To change the diff syntax colours used in the preview window, set up the `diff*` highlight groups in your colorscheme or `~/.vimrc`:

```viml
diffAdded   " if not set: use GitGutterAdd's foreground colour
diffChanged " if not set: use GitGutterChange's foreground colour
diffRemoved " if not set: use GitGutterDelete's foreground colour
```

Note the `diff*` highlight groups are used in any buffer whose `'syntax'` is `diff`.


#### The intra-line diff highlights used in the preview window

To change the intra-line diff highlights used in the preview window, set up the following highlight groups in your colorscheme or `~/.vimrc`:

```viml
GitGutterAddIntraLine    " default: gui=reverse cterm=reverse
GitGutterDeleteIntraLine " default: gui=reverse cterm=reverse
```

For example, to use `DiffAdd` for intra-line added regions:

```viml
highlight link GitGutterAddIntraLine DiffAdd
```


#### Whether the diff is relative to the index or working tree

By default diffs are relative to the index.  How you can make them relative to the working tree:

```viml
let g:gitgutter_diff_relative_to = 'working_tree'
```


#### The base of the diff

By default buffers are diffed against the index.  However you can diff against any commit by setting:

```viml
let g:gitgutter_diff_base = '<commit SHA>'
```

If you are looking at a previous version of a file with Fugitive (e.g. via `:0Gclog`), gitgutter sets the diff base to the parent of the current revision.

This setting is ignored when the diffs are relative to the working tree.


#### Extra arguments for `git` when running `git diff`

If you want to pass extra arguments to `git` when running `git diff`, do so like this:

```viml
let g:gitgutter_git_args = '--git-dir-""'
```

#### Extra arguments for `git diff`

If you want to pass extra arguments to `git diff`, for example to ignore whitespace, do so like this:

```viml
let g:gitgutter_diff_args = '-w'
```

#### Key mappings

To disable all key mappings:

```viml
let g:gitgutter_map_keys = 0
```

See above for configuring maps for hunk-jumping and staging/undoing.


#### Use a custom `grep` command

If you use an alternative to grep, you can tell vim-gitgutter to use it here.

```viml
" Default:
let g:gitgutter_grep = 'grep'
```

#### To turn off vim-gitgutter by default

Add `let g:gitgutter_enabled = 0` to your `~/.vimrc`.


#### To turn off signs by default

Add `let g:gitgutter_signs = 0` to your `~/.vimrc`.


#### To turn on line highlighting by default

Add `let g:gitgutter_highlight_lines = 1` to your `~/.vimrc`.


#### To turn on line number highlighting by default

Add `let g:gitgutter_highlight_linenrs = 1` to your `~/.vimrc`.


#### To turn off asynchronous updates

By default diffs are run asynchronously.  To run diffs synchronously instead:

```viml
let g:gitgutter_async = 0
```


#### To use floating/popup windows for hunk previews

Add `let g:gitgutter_preview_win_floating = 1` to your `~/.vimrc`.  Note that on Vim this prevents you staging (partial) hunks via the preview window.


#### The appearance of a floating/popup window for hunk previews

Either set `g:gitgutter_floating_window_options` to a dictionary of the options you want.  This dictionary is passed directly to `popup_create()` (Vim) / `nvim_open_win()` (Neovim).

Or if you just want to override one or two of the defaults, you can do that with a file in an `after/` directory.  For example:

```viml
" ~/.vim/after/vim-gitgutter/overrides.vim
let g:gitgutter_floating_window_options['border'] = 'single'
```


#### To load all hunks into the current window's location list instead of the quickfix list

Add `let g:gitgutter_use_location_list = 1` to your `~/.vimrc`.


### Extensions

#### Operate on every line in a hunk

You can map an operator to do whatever you want to every line in a hunk.

Let's say, for example, you want to remove trailing whitespace.

```viml
function! CleanUp(...)
  if a:0  " opfunc
    let [first, last] = [line("'["), line("']")]
  else
    let [first, last] = [line("'<"), line("'>")]
  endif
  for lnum in range(first, last)
    let line = getline(lnum)

    " clean up the text, e.g.:
    let line = substitute(line, '\s\+$', '', '')

    call setline(lnum, line)
  endfor
endfunction

nmap <silent> <Leader>x :set opfunc=CleanUp<CR>g@
```

Then place your cursor in a hunk and type `\xic` (assuming a leader of `\`).

Alternatively you could place your cursor in a hunk, type `vic` to select it, then `:call CleanUp()`.


#### Operate on every changed line in a file

You can write a command to do whatever you want to every changed line in a file.

```viml
function! GlobalChangedLines(ex_cmd)
  for hunk in GitGutterGetHunks()
    for lnum in range(hunk[2], hunk[2]+hunk[3]-1)
      let cursor = getcurpos()
      silent! execute lnum.a:ex_cmd
      call setpos('.', cursor)
    endfor
  endfor
endfunction

command -nargs=1 Glines call GlobalChangedLines(<q-args>)
```

Let's say, for example, you want to remove trailing whitespace from all changed lines:

```viml
:Glines s/\s\+$//
```


#### Cycle through hunks in current buffer

This is like `:GitGutterNextHunk` but when it gets to the last hunk in the buffer it cycles around to the first.

```viml
function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction
```


#### Cycle through hunks in all buffers

You can use `:GitGutterQuickFix` to load all hunks into the quickfix list or the current window's location list.

Alternatively, given that`]c` and `[c` jump from one hunk to the next in the current buffer, you can use this code to jump to the next hunk no matter which buffer it's in.

```viml
function! NextHunkAllBuffers()
  let line = line('.')
  GitGutterNextHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bnext
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      1
      GitGutterNextHunk
      return
    endif
  endwhile
endfunction

function! PrevHunkAllBuffers()
  let line = line('.')
  GitGutterPrevHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bprevious
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! G
      GitGutterPrevHunk
      return
    endif
  endwhile
endfunction

nmap <silent> ]c :call NextHunkAllBuffers()<CR>
nmap <silent> [c :call PrevHunkAllBuffers()<CR>
```


### FAQ

> How can I turn off realtime updates?

Add this to your vim configuration (in an `/after/plugin` directory):

```viml
" .vim/after/plugin/gitgutter.vim
autocmd! gitgutter CursorHold,CursorHoldI
```

> I turned off realtime updates, how can I have signs updated when I save a file?

If you really want to update the signs when you save a file, add this to your vimrc:

```viml
autocmd BufWritePost * GitGutter
```

> Why can't I unstage staged changes?

This plugin is for showing changes between the buffer and the index (and staging/undoing those changes).  Unstaging a staged hunk would require showing changes between the index and HEAD, which is out of scope.

> Why are the colours in the sign column weird?

Your colorscheme is configuring the `SignColumn` highlight group weirdly.  Please see the section above on customising the sign column.

> What happens if I also use another plugin which uses signs (e.g. Syntastic)?

You can configure whether GitGutter preserves or clobbers other signs using `g:gitgutter_sign_allow_clobber`.  Set to `1` to clobber other signs (default on Vim >= 8.1.0614 and NeoVim >= 0.4.0) or `0` to preserve them.


### Troubleshooting

#### When no signs are showing at all

Here are some things you can check:

* Try adding `let g:gitgutter_grep=''` to your vimrc.  If it works, the problem is grep producing non-plain output; e.g. ANSI escape codes or colours.
* Verify `:echo system("git --version")` succeeds.
* Verify your git config is compatible with the version of git returned by the command above.
* Verify your Vim supports signs (`:echo has('signs')` should give `1`).
* Verify your file is being tracked by git and has unstaged changes.  Check whether the plugin thinks git knows about your file: `:echo b:gitgutter.path` should show the path to the file in the repo.
* Execute `:sign place group=gitgutter`; you should see a list of signs.
  - If the signs are listed: this is a colorscheme / highlight problem.  Compare `:highlight GitGutterAdd` with `:highlight SignColumn`.
  - If no signs are listed: the call to git-diff is probably failing.  Add `let g:gitgutter_log=1` to your vimrc, restart, reproduce the problem, and look at the `gitgutter.log` file in the plugin's directory.

#### When the whole file is marked as added

* If you use zsh, and you set `CDPATH`, make sure `CDPATH` doesn't include the current directory.

#### When signs take a few seconds to appear

* Try reducing `updatetime`, e.g. `set updatetime=100`.  Note this also controls the delay before vim writes its swap file.

#### When signs don't update after focusing Vim

* Your terminal probably isn't reporting focus events.  Either try installing [Terminus][] or set `let g:gitgutter_terminal_reports_focus=0`.  For tmux, try `set -g focus-events on` in your tmux.conf.


### Shameless Plug

If this plugin has helped you, or you'd like to learn more about Vim, why not check out this screencast I wrote for PeepCode:

* [Smash Into Vim][siv]

This was one of PeepCode's all-time top three bestsellers and is now available at Pluralsight.


### Intellectual Property

Copyright Andrew Stewart, AirBlade Software Ltd.  Released under the MIT licence.


  [pathogen]: https://github.com/tpope/vim-pathogen
  [siv]: http://pluralsight.com/training/Courses/TableOfContents/smash-into-vim
  [terminus]: https://github.com/wincent/terminus
./autoload/gitgutter/async.vim	[[[1
107
let s:available = has('nvim') || (
      \   has('job') && (
      \     (has('patch-7.4.1826') && !has('gui_running')) ||
      \     (has('patch-7.4.1850') &&  has('gui_running')) ||
      \     (has('patch-7.4.1832') &&  has('gui_macvim'))
      \   )
      \ )

let s:jobs = {}

function! gitgutter#async#available()
  return s:available
endfunction


function! gitgutter#async#execute(cmd, bufnr, handler) abort
  call gitgutter#debug#log('[async] '.a:cmd)

  let options = {
        \   'stdoutbuffer': [],
        \   'buffer': a:bufnr,
        \   'handler': a:handler
        \ }
  let command = s:build_command(a:cmd)

  if has('nvim')
    call jobstart(command, extend(options, {
          \   'on_stdout': function('s:on_stdout_nvim'),
          \   'on_stderr': function('s:on_stderr_nvim'),
          \   'on_exit':   function('s:on_exit_nvim')
          \ }))
  else
    let job = job_start(command, {
          \   'out_cb':   function('s:on_stdout_vim', options),
          \   'err_cb':   function('s:on_stderr_vim', options),
          \   'close_cb': function('s:on_exit_vim', options)
          \ })
    let s:jobs[s:job_id(job)] = 1
  endif
endfunction


function! s:build_command(cmd)
  if has('unix')
    return ['sh', '-c', a:cmd]
  endif

  if has('win32')
    return has('nvim') ? ['cmd.exe', '/c', a:cmd] : 'cmd.exe /c '.a:cmd
  endif

  throw 'unknown os'
endfunction


function! s:on_stdout_nvim(_job_id, data, _event) dict abort
  if empty(self.stdoutbuffer)
    let self.stdoutbuffer = a:data
  else
    let self.stdoutbuffer = self.stdoutbuffer[:-2] +
          \ [self.stdoutbuffer[-1] . a:data[0]] +
          \ a:data[1:]
  endif
endfunction

function! s:on_stderr_nvim(_job_id, data, _event) dict abort
  if a:data != ['']  " With Neovim there is always [''] reported on stderr.
    call self.handler.err(self.buffer)
  endif
endfunction

function! s:on_exit_nvim(_job_id, exit_code, _event) dict abort
  if !a:exit_code
    call self.handler.out(self.buffer, join(self.stdoutbuffer, "\n"))
  endif
endfunction


function! s:on_stdout_vim(_channel, data) dict abort
  call add(self.stdoutbuffer, a:data)
endfunction

function! s:on_stderr_vim(channel, _data) dict abort
  call self.handler.err(self.buffer)
endfunction

function! s:on_exit_vim(channel) dict abort
  let job = ch_getjob(a:channel)
  let jobid = s:job_id(job)
  if has_key(s:jobs, jobid) | unlet s:jobs[jobid] | endif
  while 1
    if job_status(job) == 'dead'
      let exit_code = job_info(job).exitval
      break
    endif
    sleep 5m
  endwhile

  if !exit_code
    call self.handler.out(self.buffer, join(self.stdoutbuffer, "\n"))
  endif
endfunction

function! s:job_id(job)
  " Vim
  return job_info(a:job).process
endfunction
./autoload/gitgutter/debug.vim	[[[1
107
let s:plugin_dir  = expand('<sfile>:p:h:h:h').'/'
let s:log_file    = s:plugin_dir.'gitgutter.log'
let s:channel_log = s:plugin_dir.'channel.log'
let s:new_log_session = 1


function! gitgutter#debug#debug()
  " Open a scratch buffer
  vsplit __GitGutter_Debug__
  normal! ggdG
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noswapfile

  call s:vim_version()
  call s:separator()

  call s:git_version()
  call s:separator()

  call s:grep_version()
  call s:separator()

  call s:option('updatetime')
endfunction


function! s:separator()
  call s:output('')
endfunction

function! s:vim_version()
  redir => version_info
    silent execute 'version'
  redir END
  call s:output(split(version_info, '\n')[0:2])
endfunction

function! s:git_version()
  let v = system(g:gitgutter_git_executable.' --version')
  call s:output( substitute(v, '\n$', '', '') )
endfunction

function! s:grep_version()
  let v = system(g:gitgutter_grep.' --version')
  call s:output( substitute(v, '\n$', '', '') )

  let v = system(g:gitgutter_grep.' --help')
  call s:output( substitute(v, '\%x00', '', 'g') )
endfunction

function! s:option(name)
  if exists('+' . a:name)
    let v = eval('&' . a:name)
    call s:output(a:name . '=' . v)
    " redir => output
    "   silent execute "verbose set " . a:name . "?"
    " redir END
    " call s:output(a:name . '=' . output)
  else
    call s:output(a:name . ' [n/a]')
  end
endfunction

function! s:output(text)
  call append(line('$'), a:text)
endfunction

" assumes optional args are calling function's optional args
function! gitgutter#debug#log(message, ...) abort
  if g:gitgutter_log
    if s:new_log_session && gitgutter#async#available()
      if exists('*ch_logfile')
        call ch_logfile(s:channel_log, 'w')
      endif
    endif

    if s:new_log_session
      let s:start = reltime()
      call writefile(['', '========== start log session '.strftime('%d.%m.%Y %H:%M:%S').' =========='], s:log_file, 'a')
    endif

    let elapsed = reltimestr(reltime(s:start)).' '
    call writefile([''], s:log_file, 'a')
    " callers excluding this function
    call writefile([elapsed.expand('<sfile>')[:-22].':'], s:log_file, 'a')
    call writefile([elapsed.s:format_for_log(a:message)], s:log_file, 'a')
    if a:0 && !empty(a:1)
      for msg in a:000
        call writefile([elapsed.s:format_for_log(msg)], s:log_file, 'a')
      endfor
    endif

    let s:new_log_session = 0
  endif
endfunction

function! s:format_for_log(data) abort
  if type(a:data) == 1
    return join(split(a:data,'\n'),"\n")
  elseif type(a:data) == 3
    return '['.join(a:data,"\n").']'
  else
    return a:data
  endif
endfunction

./autoload/gitgutter/diff.vim	[[[1
447
scriptencoding utf8

let s:nomodeline = (v:version > 703 || (v:version == 703 && has('patch442'))) ? '<nomodeline>' : ''

let s:hunk_re = '^@@ -\(\d\+\),\?\(\d*\) +\(\d\+\),\?\(\d*\) @@'

" True for git v1.7.2+.
function! s:git_supports_command_line_config_override() abort
  call gitgutter#utility#system(gitgutter#git().' -c foo.bar=baz --version')
  return !v:shell_error
endfunction

let s:c_flag = s:git_supports_command_line_config_override()

let s:temp_from = tempname()
let s:temp_buffer = tempname()
let s:counter = 0

" Returns a diff of the buffer against the index or the working tree.
"
" After running the diff we pass it through grep where available to reduce
" subsequent processing by the plugin.  If grep is not available the plugin
" does the filtering instead.
"
" When diffing against the index:
"
" The buffer contents is not the same as the file on disk so we need to pass
" two instances of the file to git-diff:
"
"     git diff myfileA myfileB
"
" where myfileA comes from
"
"     git show :myfile > myfileA
"
" and myfileB is the buffer contents.
"
" Regarding line endings:
"
" git-show does not convert line endings.
" git-diff FILE FILE does convert line endings for the given files.
"
" If a file has CRLF line endings and git's core.autocrlf is true,
" the file in git's object store will have LF line endings.  Writing
" it out via git-show will produce a file with LF line endings.
"
" If this last file is one of the files passed to git-diff, git-diff will
" convert its line endings to CRLF before diffing -- which is what we want --
" but also by default output a warning on stderr.
"
"   warning: LF will be replace by CRLF in <temp file>.
"   The file will have its original line endings in your working directory.
"
" When running the diff asynchronously, the warning message triggers the stderr
" callbacks which assume the overall command has failed and reset all the
" signs.  As this is not what we want, and we can safely ignore the warning,
" we turn it off by passing the '-c "core.safecrlf=false"' argument to
" git-diff.
"
" When writing the temporary files we preserve the original file's extension
" so that repos using .gitattributes to control EOL conversion continue to
" convert correctly.
"
" Arguments:
"
" bufnr              - the number of the buffer to be diffed
" from               - 'index' or 'working_tree'; what the buffer is diffed against
" preserve_full_diff - truthy to return the full diff or falsey to return only
"                      the hunk headers (@@ -x,y +m,n @@); only possible if
"                      grep is available.
function! gitgutter#diff#run_diff(bufnr, from, preserve_full_diff) abort
  if gitgutter#utility#repo_path(a:bufnr, 0) == -1
    throw 'gitgutter path not set'
  endif

  if gitgutter#utility#repo_path(a:bufnr, 0) == -2
    throw 'gitgutter not tracked'
  endif

  if gitgutter#utility#repo_path(a:bufnr, 0) == -3
    throw 'gitgutter assume unchanged'
  endif

  " If we are diffing against a specific branch/commit, handle the case
  " where a file exists on the current branch but not in/at the diff base.
  " We have to handle it here because the approach below (using git-show)
  " doesn't work for this case.
  if !empty(g:gitgutter_diff_base)
    let index_name = gitgutter#utility#get_diff_base(a:bufnr).':'.gitgutter#utility#repo_path(a:bufnr, 1)
    let cmd = gitgutter#git().' --no-pager show '.index_name
    let cmd = gitgutter#utility#cd_cmd(a:bufnr, cmd)
    call gitgutter#utility#system(cmd)
    if v:shell_error
      throw 'gitgutter file unknown in base'
    endif
  endif

  " Wrap compound commands in parentheses to make Windows happy.
  " bash doesn't mind the parentheses.
  let cmd = '('

  " Append buffer number to temp filenames to avoid race conditions between
  " writing and reading the files when asynchronously processing multiple
  " buffers.

  " Without the buffer number, buff_file would have a race between the
  " second gitgutter#process_buffer() writing the file (synchronously, below)
  " and the first gitgutter#process_buffer()'s async job reading it (with
  " git-diff).
  let buff_file = s:temp_buffer.'.'.a:bufnr

  " Add a counter to avoid a similar race with two quick writes of the same buffer.
  " Use a modulus greater than a maximum reasonable number of visible buffers.
  let s:counter = (s:counter + 1) % 20
  let buff_file .= '.'.s:counter

  let extension = gitgutter#utility#extension(a:bufnr)
  if !empty(extension)
    let buff_file .= '.'.extension
  endif

  " Write buffer to temporary file.
  " Note: this is synchronous.
  call s:write_buffer(a:bufnr, buff_file)

  if a:from ==# 'index'
    " Without the buffer number, from_file would have a race in the shell
    " between the second process writing it (with git-show) and the first
    " reading it (with git-diff).
    let from_file = s:temp_from.'.'.a:bufnr

    " Add a counter to avoid a similar race with two quick writes of the same buffer.
    let from_file .= '.'.s:counter

    if !empty(extension)
      let from_file .= '.'.extension
    endif

    " Write file from index to temporary file.
    let index_name = gitgutter#utility#get_diff_base(a:bufnr).':'.gitgutter#utility#repo_path(a:bufnr, 1)
    let cmd .= gitgutter#git().' --no-pager show --textconv '.index_name.' > '.from_file.' && '

  elseif a:from ==# 'working_tree'
    let from_file = gitgutter#utility#repo_path(a:bufnr, 1)
  endif

  " Call git-diff.
  let cmd .= gitgutter#git().' --no-pager'
  if s:c_flag
    let cmd .= ' -c "diff.autorefreshindex=0"'
    let cmd .= ' -c "diff.noprefix=false"'
    let cmd .= ' -c "core.safecrlf=false"'
  endif
  let cmd .= ' diff --no-ext-diff --no-color -U0 '.g:gitgutter_diff_args.' -- '.from_file.' '.buff_file

  " Pipe git-diff output into grep.
  if !a:preserve_full_diff && !empty(g:gitgutter_grep)
    let cmd .= ' | '.g:gitgutter_grep.' '.gitgutter#utility#shellescape('^@@ ')
  endif

  " grep exits with 1 when no matches are found; git-diff exits with 1 when
  " differences are found.  However we want to treat non-matches and
  " differences as non-erroneous behaviour; so we OR the command with one
  " which always exits with success (0).
  let cmd .= ' || exit 0'

  let cmd .= ')'

  let cmd = gitgutter#utility#cd_cmd(a:bufnr, cmd)

  if g:gitgutter_async && gitgutter#async#available()
    call gitgutter#async#execute(cmd, a:bufnr, {
          \   'out': function('gitgutter#diff#handler'),
          \   'err': function('gitgutter#hunk#reset'),
          \ })
    return 'async'

  else
    let diff = gitgutter#utility#system(cmd)

    if v:shell_error
      call gitgutter#debug#log(diff)
      throw 'gitgutter diff failed'
    endif

    return diff
  endif
endfunction


function! gitgutter#diff#handler(bufnr, diff) abort
  call gitgutter#debug#log(a:diff)

  if !bufexists(a:bufnr)
    return
  endif

  call gitgutter#hunk#set_hunks(a:bufnr, gitgutter#diff#parse_diff(a:diff))
  let modified_lines = gitgutter#diff#process_hunks(a:bufnr, gitgutter#hunk#hunks(a:bufnr))

  let signs_count = len(modified_lines)
  if g:gitgutter_max_signs != -1 && signs_count > g:gitgutter_max_signs
    call gitgutter#utility#warn_once(a:bufnr, printf(
          \ 'exceeded maximum number of signs (%d > %d, configured by g:gitgutter_max_signs).',
          \ signs_count, g:gitgutter_max_signs), 'max_signs')
    call gitgutter#sign#clear_signs(a:bufnr)

  else
    if g:gitgutter_signs || g:gitgutter_highlight_lines || g:gitgutter_highlight_linenrs
      call gitgutter#sign#update_signs(a:bufnr, modified_lines)
    endif
  endif

  call s:save_last_seen_change(a:bufnr)
  if exists('#User#GitGutter')
    let g:gitgutter_hook_context = {'bufnr': a:bufnr}
    execute 'doautocmd' s:nomodeline 'User GitGutter'
    unlet g:gitgutter_hook_context
  endif
endfunction


function! gitgutter#diff#parse_diff(diff) abort
  let hunks = []
  for line in split(a:diff, '\n')
    let hunk_info = gitgutter#diff#parse_hunk(line)
    if len(hunk_info) == 4
      call add(hunks, hunk_info)
    endif
  endfor
  return hunks
endfunction

function! gitgutter#diff#parse_hunk(line) abort
  let matches = matchlist(a:line, s:hunk_re)
  if len(matches) > 0
    let from_line  = str2nr(matches[1])
    let from_count = (matches[2] == '') ? 1 : str2nr(matches[2])
    let to_line    = str2nr(matches[3])
    let to_count   = (matches[4] == '') ? 1 : str2nr(matches[4])
    return [from_line, from_count, to_line, to_count]
  else
    return []
  end
endfunction

" This function is public so it may be used by other plugins
" e.g. vim-signature.
function! gitgutter#diff#process_hunks(bufnr, hunks) abort
  let modified_lines = []
  for hunk in a:hunks
    call extend(modified_lines, s:process_hunk(a:bufnr, hunk))
  endfor
  return modified_lines
endfunction

" Returns [ [<line_number (number)>, <name (string)>], ...]
function! s:process_hunk(bufnr, hunk) abort
  let modifications = []
  let from_line  = a:hunk[0]
  let from_count = a:hunk[1]
  let to_line    = a:hunk[2]
  let to_count   = a:hunk[3]

  if s:is_added(from_count, to_count)
    call s:process_added(modifications, from_count, to_count, to_line)
    call gitgutter#hunk#increment_lines_added(a:bufnr, to_count)

  elseif s:is_removed(from_count, to_count)
    call s:process_removed(modifications, from_count, to_count, to_line)
    call gitgutter#hunk#increment_lines_removed(a:bufnr, from_count)

  elseif s:is_modified(from_count, to_count)
    call s:process_modified(modifications, from_count, to_count, to_line)
    call gitgutter#hunk#increment_lines_modified(a:bufnr, to_count)

  elseif s:is_modified_and_added(from_count, to_count)
    call s:process_modified_and_added(modifications, from_count, to_count, to_line)
    call gitgutter#hunk#increment_lines_added(a:bufnr, to_count - from_count)
    call gitgutter#hunk#increment_lines_modified(a:bufnr, from_count)

  elseif s:is_modified_and_removed(from_count, to_count)
    call s:process_modified_and_removed(modifications, from_count, to_count, to_line)
    call gitgutter#hunk#increment_lines_modified(a:bufnr, to_count)
    call gitgutter#hunk#increment_lines_removed(a:bufnr, from_count - to_count)

  endif
  return modifications
endfunction

function! s:is_added(from_count, to_count) abort
  return a:from_count == 0 && a:to_count > 0
endfunction

function! s:is_removed(from_count, to_count) abort
  return a:from_count > 0 && a:to_count == 0
endfunction

function! s:is_modified(from_count, to_count) abort
  return a:from_count > 0 && a:to_count > 0 && a:from_count == a:to_count
endfunction

function! s:is_modified_and_added(from_count, to_count) abort
  return a:from_count > 0 && a:to_count > 0 && a:from_count < a:to_count
endfunction

function! s:is_modified_and_removed(from_count, to_count) abort
  return a:from_count > 0 && a:to_count > 0 && a:from_count > a:to_count
endfunction

function! s:process_added(modifications, from_count, to_count, to_line) abort
  let offset = 0
  while offset < a:to_count
    let line_number = a:to_line + offset
    call add(a:modifications, [line_number, 'added'])
    let offset += 1
  endwhile
endfunction

function! s:process_removed(modifications, from_count, to_count, to_line) abort
  if a:to_line == 0
    call add(a:modifications, [1, 'removed_first_line'])
  else
    call add(a:modifications, [a:to_line, 'removed'])
  endif
endfunction

function! s:process_modified(modifications, from_count, to_count, to_line) abort
  let offset = 0
  while offset < a:to_count
    let line_number = a:to_line + offset
    call add(a:modifications, [line_number, 'modified'])
    let offset += 1
  endwhile
endfunction

function! s:process_modified_and_added(modifications, from_count, to_count, to_line) abort
  let offset = 0
  while offset < a:from_count
    let line_number = a:to_line + offset
    call add(a:modifications, [line_number, 'modified'])
    let offset += 1
  endwhile
  while offset < a:to_count
    let line_number = a:to_line + offset
    call add(a:modifications, [line_number, 'added'])
    let offset += 1
  endwhile
endfunction

function! s:process_modified_and_removed(modifications, from_count, to_count, to_line) abort
  let offset = 0
  while offset < a:to_count
    let line_number = a:to_line + offset
    call add(a:modifications, [line_number, 'modified'])
    let offset += 1
  endwhile
  let a:modifications[-1] = [a:to_line + offset - 1, 'modified_removed']
endfunction


" Returns a diff for the current hunk.
" Assumes there is only 1 current hunk unless the optional argument is given,
" in which case the cursor is in two hunks and the argument specifies the one
" to choose.
"
" Optional argument: 0 (to use the first hunk) or 1 (to use the second).
function! gitgutter#diff#hunk_diff(bufnr, full_diff, ...)
  let modified_diff = []
  let hunk_index = 0
  let keep_line = 1
  " Don't keepempty when splitting because the diff we want may not be the
  " final one.  Instead add trailing NL at end of function.
  for line in split(a:full_diff, '\n')
    let hunk_info = gitgutter#diff#parse_hunk(line)
    if len(hunk_info) == 4  " start of new hunk
      let keep_line = gitgutter#hunk#cursor_in_hunk(hunk_info)

      if a:0 && hunk_index != a:1
        let keep_line = 0
      endif

      let hunk_index += 1
    endif
    if keep_line
      call add(modified_diff, line)
    endif
  endfor
  return join(modified_diff, "\n")."\n"
endfunction


function! gitgutter#diff#hunk_header_showing_every_line_added(bufnr)
  let buf_line_count = getbufinfo(a:bufnr)[0].linecount
  return '@@ -0,0 +1,'.buf_line_count.' @@'
endfunction


function! s:write_buffer(bufnr, file)
  let bufcontents = getbufline(a:bufnr, 1, '$')

  if bufcontents == [''] && line2byte(1) == -1
    " Special case: completely empty buffer.
    " A nearly empty buffer of only a newline has line2byte(1) == 1.
    call writefile([], a:file)
    return
  endif

  if getbufvar(a:bufnr, '&fileformat') ==# 'dos'
    if getbufvar(a:bufnr, '&endofline')
      call map(bufcontents, 'v:val."\r"')
    else
      for i in range(len(bufcontents) - 1)
        let bufcontents[i] = bufcontents[i] . "\r"
      endfor
    endif
  endif

  if getbufvar(a:bufnr, '&endofline')
    call add(bufcontents, '')
  endif

  let fenc = getbufvar(a:bufnr, '&fileencoding')
  if fenc !=# &encoding
    call map(bufcontents, 'iconv(v:val, &encoding, "'.fenc.'")')
  endif

  if getbufvar(a:bufnr, '&bomb')
    let bufcontents[0]='﻿'.bufcontents[0]
  endif

  " The file we are writing to is a temporary file.  Sometimes the parent
  " directory is deleted outside Vim but, because Vim caches the directory
  " name at startup and does not check for its existence subsequently, Vim
  " does not realise.  This causes E482 errors.
  try
    call writefile(bufcontents, a:file, 'b')
  catch /E482/
    call mkdir(fnamemodify(a:file, ':h'), '', '0700')
    call writefile(bufcontents, a:file, 'b')
  endtry
endfunction


function! s:save_last_seen_change(bufnr) abort
  call gitgutter#utility#setbufvar(a:bufnr, 'tick', getbufvar(a:bufnr, 'changedtick'))
endfunction
./autoload/gitgutter/diff_highlight.vim	[[[1
201
" This is the minimum number of characters required between regions of change
" in a line.  It's somewhat arbitrary: higher values mean less visual busyness;
" lower values mean more detail.
let s:gap_between_regions = 5


" Calculates the changed portions of lines.
"
" Based on:
"
" - diff-highlight (included with git)
"   https://github.com/git/git/blob/master/contrib/diff-highlight/DiffHighlight.pm
"
" - Diff Strategies, Neil Fraser
"   https://neil.fraser.name/writing/diff/


" Returns a list of intra-line changed regions.
" Each element is a list:
"
"   [
"     line number (1-based),
"     type ('+' or '-'),
"     start column (1-based, inclusive),
"     stop column (1-based, inclusive),
"   ]
"
" Args:
"   hunk_body - list of lines
function! gitgutter#diff_highlight#process(hunk_body)
  " Check whether we have the same number of lines added as removed.
  let [removed, added] = [0, 0]
  for line in a:hunk_body
    if line[0] == '-'
      let removed += 1
    elseif line[0] == '+'
      let added += 1
    endif
  endfor
  if removed != added
    return []
  endif

  let regions = []

  for i in range(removed)
    " pair lines by position
    let rline = a:hunk_body[i]
    let aline = a:hunk_body[i + removed]

    call s:diff(rline, aline, i, i+removed, 0, 0, regions, 1)
  endfor

  return regions
endfunction


function! s:diff(rline, aline, rlinenr, alinenr, rprefix, aprefix, regions, whole_line)
  " diff marker does not count as a difference in prefix
  let start = a:whole_line ? 1 : 0
  let prefix = s:common_prefix(a:rline[start:], a:aline[start:])
  if a:whole_line
    let prefix += 1
  endif
  let [rsuffix, asuffix] = s:common_suffix(a:rline, a:aline, prefix+1)

  " region of change (common prefix and suffix removed)
  let rtext = a:rline[prefix+1:rsuffix-1]
  let atext = a:aline[prefix+1:asuffix-1]

  " singular insertion
  if empty(rtext)
    if !a:whole_line || len(atext) != len(a:aline)  " not whole line
      call add(a:regions, [a:alinenr+1, '+', a:aprefix+prefix+1+1, a:aprefix+asuffix+1-1])
    endif
    return
  endif

  " singular deletion
  if empty(atext)
    if !a:whole_line || len(rtext) != len(a:rline)  " not whole line
      call add(a:regions, [a:rlinenr+1, '-', a:rprefix+prefix+1+1, a:rprefix+rsuffix+1-1])
    endif
    return
  endif

  " two insertions
  let j = stridx(atext, rtext)
  if j != -1
    call add(a:regions, [a:alinenr+1, '+', a:aprefix+prefix+1+1, a:aprefix+prefix+j+1])
    call add(a:regions, [a:alinenr+1, '+', a:aprefix+prefix+1+1+j+len(rtext), a:aprefix+asuffix+1-1])
    return
  endif

  " two deletions
  let j = stridx(rtext, atext)
  if j != -1
    call add(a:regions, [a:rlinenr+1, '-', a:rprefix+prefix+1+1, a:rprefix+prefix+j+1])
    call add(a:regions, [a:rlinenr+1, '-', a:rprefix+prefix+1+1+j+len(atext), a:rprefix+rsuffix+1-1])
    return
  endif

  " two edits
  let lcs = s:lcs(rtext, atext)
  " TODO do we need to ensure we don't get more than 2 elements when splitting?
  if len(lcs) > s:gap_between_regions
    let redits = s:split(rtext, lcs)
    let aedits = s:split(atext, lcs)
    call s:diff(redits[0], aedits[0], a:rlinenr, a:alinenr, a:rprefix+prefix+1,                         a:aprefix+prefix+1,                         a:regions, 0)
    call s:diff(redits[1], aedits[1], a:rlinenr, a:alinenr, a:rprefix+prefix+1+len(redits[0])+len(lcs), a:aprefix+prefix+1+len(aedits[0])+len(lcs), a:regions, 0)
    return
  endif

  " fall back to highlighting entire changed area

  " if a change (but not the whole line)
  if !a:whole_line || ((prefix != 0 || rsuffix != len(a:rline)) && prefix+1 < rsuffix)
    call add(a:regions, [a:rlinenr+1, '-', a:rprefix+prefix+1+1, a:rprefix+rsuffix+1-1])
  endif

  " if a change (but not the whole line)
  if !a:whole_line || ((prefix != 0 || asuffix != len(a:aline)) && prefix+1 < asuffix)
    call add(a:regions, [a:alinenr+1, '+', a:aprefix+prefix+1+1, a:aprefix+asuffix+1-1])
  endif
endfunction


function! s:lcs(s1, s2)
  if empty(a:s1) || empty(a:s2)
    return ''
  endif

  let matrix = map(repeat([repeat([0], len(a:s2)+1)], len(a:s1)+1), 'copy(v:val)')

  let maxlength = 0
  let endindex = len(a:s1)

  for i in range(1, len(a:s1))
    for j in range(1, len(a:s2))
      if a:s1[i-1] ==# a:s2[j-1]
        let matrix[i][j] = 1 + matrix[i-1][j-1]
        if matrix[i][j] > maxlength
          let maxlength = matrix[i][j]
          let endindex = i - 1
        endif
      endif
    endfor
  endfor

  return a:s1[endindex - maxlength + 1 : endindex]
endfunction


" Returns 0-based index of last character of common prefix
" If there is no common prefix, returns -1.
"
" a, b - strings
"
function! s:common_prefix(a, b)
  let len = min([len(a:a), len(a:b)])
  if len == 0
    return -1
  endif
  for i in range(len)
    if a:a[i:i] !=# a:b[i:i]
      return i - 1
    endif
  endfor
  return i
endfunction


" Returns 0-based indices of start of common suffix
"
" a, b - strings
" start - 0-based index to start from
function! s:common_suffix(a, b, start)
  let [sa, sb] = [len(a:a), len(a:b)]
  while sa >= a:start && sb >= a:start
    if a:a[sa] ==# a:b[sb]
      let sa -= 1
      let sb -= 1
    else
      break
    endif
  endwhile
  return [sa+1, sb+1]
endfunction


" Split a string on another string.
" Assumes 1 occurrence of the delimiter.
function! s:split(str, delimiter)
  let i = stridx(a:str, a:delimiter)

  if i == 0
    return ['', a:str[len(a:delimiter):]]
  endif

  return [a:str[:i-1], a:str[i+len(a:delimiter):]]
endfunction
./autoload/gitgutter/fold.vim	[[[1
115
function! gitgutter#fold#enable()
  call s:save_fold_state()

  call s:set_fold_levels()
  setlocal foldexpr=gitgutter#fold#level(v:lnum)
  setlocal foldmethod=expr
  setlocal foldlevel=0
  setlocal foldenable

  call gitgutter#utility#setbufvar(bufnr(''), 'folded', 1)
endfunction


function! gitgutter#fold#disable()
  call s:restore_fold_state()
  call gitgutter#utility#setbufvar(bufnr(''), 'folded', 0)
endfunction


function! gitgutter#fold#toggle()
  if s:folded()
    call gitgutter#fold#disable()
  else
    call gitgutter#fold#enable()
  endif
endfunction


function! gitgutter#fold#level(lnum)
  return gitgutter#utility#getbufvar(bufnr(''), 'fold_levels')[a:lnum]
endfunction


function! gitgutter#fold#foldtext()
  if !gitgutter#fold#is_changed()
    return foldtext()
  endif

  return substitute(foldtext(), ':', ' (*):', '')
endfunction


" Returns 1 if any of the folded lines have been changed
" (added, removed, or modified), 0 otherwise.
function! gitgutter#fold#is_changed()
  for hunk in gitgutter#hunk#hunks(bufnr(''))
    let hunk_begin = hunk[2]
    let hunk_end   = hunk[2] + (hunk[3] == 0 ? 1 : hunk[3])

    if hunk_end < v:foldstart
      continue
    endif

    if hunk_begin > v:foldend
      break
    endif

    return 1
  endfor

  return 0
endfunction


" A line in a hunk has a fold level of 0.
" A line within 3 lines of a hunk has a fold level of 1.
" All other lines have a fold level of 2.
function! s:set_fold_levels()
  let fold_levels = ['']

  for lnum in range(1, line('$'))
    let in_hunk = gitgutter#hunk#in_hunk(lnum)
    call add(fold_levels, (in_hunk ? 0 : 2))
  endfor

  let lines_of_context = 3

  for lnum in range(1, line('$'))
    if fold_levels[lnum] == 2
      let pre = lnum >= 3 ? lnum - lines_of_context : 0
      let post = lnum + lines_of_context
      if index(fold_levels[pre:post], 0) != -1
        let fold_levels[lnum] = 1
      endif
    endif
  endfor

  call gitgutter#utility#setbufvar(bufnr(''), 'fold_levels', fold_levels)
endfunction


function! s:save_fold_state()
  let bufnr = bufnr('')
  call gitgutter#utility#setbufvar(bufnr, 'foldlevel', &foldlevel)
  call gitgutter#utility#setbufvar(bufnr, 'foldmethod', &foldmethod)
  if &foldmethod ==# 'manual'
    mkview
  endif
endfunction

function! s:restore_fold_state()
  let bufnr = bufnr('')
  let &foldlevel = gitgutter#utility#getbufvar(bufnr, 'foldlevel')
  let &foldmethod = gitgutter#utility#getbufvar(bufnr, 'foldmethod')
  if &foldmethod ==# 'manual'
    loadview
  else
    normal! zx
  endif
endfunction

function! s:folded()
  return gitgutter#utility#getbufvar(bufnr(''), 'folded')
endfunction

./autoload/gitgutter/highlight.vim	[[[1
245
function! gitgutter#highlight#line_disable() abort
  let g:gitgutter_highlight_lines = 0
  call s:define_sign_line_highlights()

  if !g:gitgutter_signs
    call gitgutter#sign#clear_signs(bufnr(''))
  endif

  redraw!
endfunction

function! gitgutter#highlight#line_enable() abort
  let old_highlight_lines = g:gitgutter_highlight_lines

  let g:gitgutter_highlight_lines = 1
  call s:define_sign_line_highlights()

  if !old_highlight_lines && !g:gitgutter_signs
    call gitgutter#all(1)
  endif

  redraw!
endfunction

function! gitgutter#highlight#line_toggle() abort
  if g:gitgutter_highlight_lines
    call gitgutter#highlight#line_disable()
  else
    call gitgutter#highlight#line_enable()
  endif
endfunction


function! gitgutter#highlight#linenr_disable() abort
  let g:gitgutter_highlight_linenrs = 0
  call s:define_sign_linenr_highlights()

  if !g:gitgutter_signs
    call gitgutter#sign#clear_signs(bufnr(''))
  endif

  redraw!
endfunction

function! gitgutter#highlight#linenr_enable() abort
  let old_highlight_linenrs = g:gitgutter_highlight_linenrs

  let g:gitgutter_highlight_linenrs = 1
  call s:define_sign_linenr_highlights()

  if !old_highlight_linenrs && !g:gitgutter_signs
    call gitgutter#all(1)
  endif

  redraw!
endfunction

function! gitgutter#highlight#linenr_toggle() abort
  if g:gitgutter_highlight_linenrs
    call gitgutter#highlight#linenr_disable()
  else
    call gitgutter#highlight#linenr_enable()
  endif
endfunction


function! gitgutter#highlight#define_highlights() abort
  let [guibg, ctermbg] = s:get_background_colors('SignColumn')

  " Highlights used by the signs.

  " When they are invisible.
  execute "highlight GitGutterAddInvisible    guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
  execute "highlight GitGutterChangeInvisible guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
  execute "highlight GitGutterDeleteInvisible guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
  highlight default link GitGutterChangeDeleteInvisible GitGutterChangeInvisible

  " When they are visible.
  for type in ["Add", "Change", "Delete"]
    if hlexists("GitGutter".type) && s:get_foreground_colors("GitGutter".type) != ['NONE', 'NONE']
      if g:gitgutter_set_sign_backgrounds
        execute "highlight GitGutter".type." guibg=".guibg." ctermbg=".ctermbg
      endif
      continue
    elseif s:useful_diff_colours()
      let [guifg, ctermfg] = s:get_foreground_colors('Diff'.type)
    else
      let [guifg, ctermfg] = s:get_foreground_fallback_colors(type)
    endif
    execute "highlight GitGutter".type." guifg=".guifg." guibg=".guibg." ctermfg=".ctermfg." ctermbg=".ctermbg
  endfor

  if hlexists("GitGutterChangeDelete") && g:gitgutter_set_sign_backgrounds
    execute "highlight GitGutterChangeDelete guibg=".guibg." ctermbg=".ctermbg
  endif

  highlight default link GitGutterChangeDelete GitGutterChange

  " Highlights used for the whole line.

  highlight default link GitGutterAddLine          DiffAdd
  highlight default link GitGutterChangeLine       DiffChange
  highlight default link GitGutterDeleteLine       DiffDelete
  highlight default link GitGutterChangeDeleteLine GitGutterChangeLine

  highlight default link GitGutterAddLineNr          CursorLineNr
  highlight default link GitGutterChangeLineNr       CursorLineNr
  highlight default link GitGutterDeleteLineNr       CursorLineNr
  highlight default link GitGutterChangeDeleteLineNr GitGutterChangeLineNr

  " Highlights used intra line.
  highlight default GitGutterAddIntraLine    gui=reverse cterm=reverse
  highlight default GitGutterDeleteIntraLine gui=reverse cterm=reverse
  " Set diff syntax colours (used in the preview window) - diffAdded,diffChanged,diffRemoved -
  " to match the signs, if not set aleady.
  for [dtype,type] in [['Added','Add'], ['Changed','Change'], ['Removed','Delete']]
    if !hlexists('diff'.dtype)
      let [guifg, ctermfg] = s:get_foreground_colors('GitGutter'.type)
      execute "highlight diff".dtype." guifg=".guifg." ctermfg=".ctermfg." guibg=NONE ctermbg=NONE"
    endif
  endfor
endfunction

function! gitgutter#highlight#define_signs() abort
  sign define GitGutterLineAdded
  sign define GitGutterLineModified
  sign define GitGutterLineRemoved
  sign define GitGutterLineRemovedFirstLine
  sign define GitGutterLineRemovedAboveAndBelow
  sign define GitGutterLineModifiedRemoved

  call s:define_sign_text()
  call gitgutter#highlight#define_sign_text_highlights()
  call s:define_sign_line_highlights()
  call s:define_sign_linenr_highlights()
endfunction

function! s:define_sign_text() abort
  execute "sign define GitGutterLineAdded                 text=" . g:gitgutter_sign_added
  execute "sign define GitGutterLineModified              text=" . g:gitgutter_sign_modified
  execute "sign define GitGutterLineRemoved               text=" . g:gitgutter_sign_removed
  execute "sign define GitGutterLineRemovedFirstLine      text=" . g:gitgutter_sign_removed_first_line
  execute "sign define GitGutterLineRemovedAboveAndBelow  text=" . g:gitgutter_sign_removed_above_and_below
  execute "sign define GitGutterLineModifiedRemoved       text=" . g:gitgutter_sign_modified_removed
endfunction

function! gitgutter#highlight#define_sign_text_highlights() abort
  " Once a sign's text attribute has been defined, it cannot be undefined or
  " set to an empty value.  So to make signs' text disappear (when toggling
  " off or disabling) we make them invisible by setting their foreground colours
  " to the background's.
  if g:gitgutter_signs
    sign define GitGutterLineAdded                 texthl=GitGutterAdd
    sign define GitGutterLineModified              texthl=GitGutterChange
    sign define GitGutterLineRemoved               texthl=GitGutterDelete
    sign define GitGutterLineRemovedFirstLine      texthl=GitGutterDelete
    sign define GitGutterLineRemovedAboveAndBelow  texthl=GitGutterDelete
    sign define GitGutterLineModifiedRemoved       texthl=GitGutterChangeDelete
  else
    sign define GitGutterLineAdded                 texthl=GitGutterAddInvisible
    sign define GitGutterLineModified              texthl=GitGutterChangeInvisible
    sign define GitGutterLineRemoved               texthl=GitGutterDeleteInvisible
    sign define GitGutterLineRemovedFirstLine      texthl=GitGutterDeleteInvisible
    sign define GitGutterLineRemovedAboveAndBelow  texthl=GitGutterDeleteInvisible
    sign define GitGutterLineModifiedRemoved       texthl=GitGutterChangeDeleteInvisible
  endif
endfunction

function! s:define_sign_line_highlights() abort
  if g:gitgutter_highlight_lines
    sign define GitGutterLineAdded                 linehl=GitGutterAddLine
    sign define GitGutterLineModified              linehl=GitGutterChangeLine
    sign define GitGutterLineRemoved               linehl=GitGutterDeleteLine
    sign define GitGutterLineRemovedFirstLine      linehl=GitGutterDeleteLine
    sign define GitGutterLineRemovedAboveAndBelow  linehl=GitGutterDeleteLine
    sign define GitGutterLineModifiedRemoved       linehl=GitGutterChangeDeleteLine
  else
    sign define GitGutterLineAdded                 linehl=NONE
    sign define GitGutterLineModified              linehl=NONE
    sign define GitGutterLineRemoved               linehl=NONE
    sign define GitGutterLineRemovedFirstLine      linehl=NONE
    sign define GitGutterLineRemovedAboveAndBelow  linehl=NONE
    sign define GitGutterLineModifiedRemoved       linehl=NONE
  endif
endfunction

function! s:define_sign_linenr_highlights() abort
  if has('nvim-0.3.2')
    try
      if g:gitgutter_highlight_linenrs
        sign define GitGutterLineAdded                 numhl=GitGutterAddLineNr
        sign define GitGutterLineModified              numhl=GitGutterChangeLineNr
        sign define GitGutterLineRemoved               numhl=GitGutterDeleteLineNr
        sign define GitGutterLineRemovedFirstLine      numhl=GitGutterDeleteLineNr
        sign define GitGutterLineRemovedAboveAndBelow  numhl=GitGutterDeleteLineNr
        sign define GitGutterLineModifiedRemoved       numhl=GitGutterChangeDeleteLineNr
      else
        sign define GitGutterLineAdded                 numhl=NONE
        sign define GitGutterLineModified              numhl=NONE
        sign define GitGutterLineRemoved               numhl=NONE
        sign define GitGutterLineRemovedFirstLine      numhl=NONE
        sign define GitGutterLineRemovedAboveAndBelow  numhl=NONE
        sign define GitGutterLineModifiedRemoved       numhl=NONE
      endif
    catch /E475/
    endtry
  endif
endfunction

function! s:get_hl(group, what, mode) abort
  let r = synIDattr(synIDtrans(hlID(a:group)), a:what, a:mode)
  if empty(r) || r == -1
    return 'NONE'
  endif
  return r
endfunction

function! s:get_foreground_colors(group) abort
  let ctermfg = s:get_hl(a:group, 'fg', 'cterm')
  let guifg = s:get_hl(a:group, 'fg', 'gui')
  return [guifg, ctermfg]
endfunction

function! s:get_background_colors(group) abort
  let ctermbg = s:get_hl(a:group, 'bg', 'cterm')
  let guibg = s:get_hl(a:group, 'bg', 'gui')
  return [guibg, ctermbg]
endfunction

function! s:useful_diff_colours()
  let [guifg_add, ctermfg_add] = s:get_foreground_colors('DiffAdd')
  let [guifg_del, ctermfg_del] = s:get_foreground_colors('DiffDelete')

  return guifg_add != guifg_del && ctermfg_add != ctermfg_del
endfunction

function! s:get_foreground_fallback_colors(type)
  if a:type == 'Add'
    return ['#009900', '2']
  elseif a:type == 'Change'
    return ['#bbbb00', '3']
  elseif a:type == 'Delete'
    return ['#ff2222', '1']
  endif
endfunction
./autoload/gitgutter/hunk.vim	[[[1
660
let s:winid = 0
let s:preview_bufnr = 0
let s:nomodeline = (v:version > 703 || (v:version == 703 && has('patch442'))) ? '<nomodeline>' : ''

function! gitgutter#hunk#set_hunks(bufnr, hunks) abort
  call gitgutter#utility#setbufvar(a:bufnr, 'hunks', a:hunks)
  call s:reset_summary(a:bufnr)
endfunction

function! gitgutter#hunk#hunks(bufnr) abort
  return gitgutter#utility#getbufvar(a:bufnr, 'hunks', [])
endfunction

function! gitgutter#hunk#reset(bufnr) abort
  call gitgutter#utility#setbufvar(a:bufnr, 'hunks', [])
  call s:reset_summary(a:bufnr)
endfunction


function! gitgutter#hunk#summary(bufnr) abort
  return gitgutter#utility#getbufvar(a:bufnr, 'summary', [0,0,0])
endfunction

function! s:reset_summary(bufnr) abort
  call gitgutter#utility#setbufvar(a:bufnr, 'summary', [0,0,0])
endfunction

function! gitgutter#hunk#increment_lines_added(bufnr, count) abort
  let summary = gitgutter#hunk#summary(a:bufnr)
  let summary[0] += a:count
  call gitgutter#utility#setbufvar(a:bufnr, 'summary', summary)
endfunction

function! gitgutter#hunk#increment_lines_modified(bufnr, count) abort
  let summary = gitgutter#hunk#summary(a:bufnr)
  let summary[1] += a:count
  call gitgutter#utility#setbufvar(a:bufnr, 'summary', summary)
endfunction

function! gitgutter#hunk#increment_lines_removed(bufnr, count) abort
  let summary = gitgutter#hunk#summary(a:bufnr)
  let summary[2] += a:count
  call gitgutter#utility#setbufvar(a:bufnr, 'summary', summary)
endfunction


function! gitgutter#hunk#next_hunk(count) abort
  let bufnr = bufnr('')
  if !gitgutter#utility#is_active(bufnr) | return | endif

  let hunks = gitgutter#hunk#hunks(bufnr)
  if empty(hunks)
    call gitgutter#utility#warn('No hunks in file')
    return
  endif

  let current_line = line('.')
  let hunk_count = 0
  for hunk in hunks
    if hunk[2] > current_line
      let hunk_count += 1
      if hunk_count == a:count
        execute 'normal!' hunk[2] . 'Gzv'
        if g:gitgutter_show_msg_on_hunk_jumping
          redraw | echo printf('Hunk %d of %d', index(hunks, hunk) + 1, len(hunks))
        endif
        if gitgutter#hunk#is_preview_window_open()
          call gitgutter#hunk#preview()
        endif
        return
      endif
    endif
  endfor
  call gitgutter#utility#warn('No more hunks')
endfunction

function! gitgutter#hunk#prev_hunk(count) abort
  let bufnr = bufnr('')
  if !gitgutter#utility#is_active(bufnr) | return | endif

  let hunks = gitgutter#hunk#hunks(bufnr)
  if empty(hunks)
    call gitgutter#utility#warn('No hunks in file')
    return
  endif

  let current_line = line('.')
  let hunk_count = 0
  for hunk in reverse(copy(hunks))
    if hunk[2] < current_line
      let hunk_count += 1
      if hunk_count == a:count
        let target = hunk[2] == 0 ? 1 : hunk[2]
        execute 'normal!' target . 'Gzv'
        if g:gitgutter_show_msg_on_hunk_jumping
          redraw | echo printf('Hunk %d of %d', index(hunks, hunk) + 1, len(hunks))
        endif
        if gitgutter#hunk#is_preview_window_open()
          call gitgutter#hunk#preview()
        endif
        return
      endif
    endif
  endfor
  call gitgutter#utility#warn('No previous hunks')
endfunction

" Returns the hunk the cursor is currently in or an empty list if the cursor
" isn't in a hunk.
function! s:current_hunk() abort
  let bufnr = bufnr('')
  let current_hunk = []

  for hunk in gitgutter#hunk#hunks(bufnr)
    if gitgutter#hunk#cursor_in_hunk(hunk)
      let current_hunk = hunk
      break
    endif
  endfor

  return current_hunk
endfunction

" Returns truthy if the cursor is in two hunks (which can only happen if the
" cursor is on the first line and lines above have been deleted and lines
" immediately below have been deleted) or falsey otherwise.
function! s:cursor_in_two_hunks()
  let hunks = gitgutter#hunk#hunks(bufnr(''))

  if line('.') == 1 && len(hunks) > 1 && hunks[0][2:3] == [0, 0] && hunks[1][2:3] == [1, 0]
    return 1
  endif

  return 0
endfunction

" A line can be in 0 or 1 hunks, with the following exception: when the first
" line(s) of a file has been deleted, and the new second line (and
" optionally below) has been deleted, the new first line is in two hunks.
function! gitgutter#hunk#cursor_in_hunk(hunk) abort
  let current_line = line('.')

  if current_line == 1 && a:hunk[2] == 0
    return 1
  endif

  if current_line >= a:hunk[2] && current_line < a:hunk[2] + (a:hunk[3] == 0 ? 1 : a:hunk[3])
    return 1
  endif

  return 0
endfunction


function! gitgutter#hunk#in_hunk(lnum)
  " Hunks are sorted in the order they appear in the buffer.
  for hunk in gitgutter#hunk#hunks(bufnr(''))
    " if in a hunk on first line of buffer
    if a:lnum == 1 && hunk[2] == 0
      return 1
    endif

    " if in a hunk generally
    if a:lnum >= hunk[2] && a:lnum < hunk[2] + (hunk[3] == 0 ? 1 : hunk[3])
      return 1
    endif

    " if hunk starts after the given line
    if a:lnum < hunk[2]
      return 0
    endif
  endfor

  return 0
endfunction


function! gitgutter#hunk#text_object(inner) abort
  let hunk = s:current_hunk()

  if empty(hunk)
    return
  endif

  let [first_line, last_line] = [hunk[2], hunk[2] + hunk[3] - 1]

  if ! a:inner
    let lnum = last_line
    let eof = line('$')
    while lnum < eof && empty(getline(lnum + 1))
      let lnum +=1
    endwhile
    let last_line = lnum
  endif

  execute 'normal! 'first_line.'GV'.last_line.'G'
endfunction


function! gitgutter#hunk#stage(...) abort
  if !s:in_hunk_preview_window() && !gitgutter#utility#has_repo_path(bufnr('')) | return | endif

  if a:0 && (a:1 != 1 || a:2 != line('$'))
    call s:hunk_op(function('s:stage'), a:1, a:2)
  else
    call s:hunk_op(function('s:stage'))
  endif
  silent! call repeat#set("\<Plug>(GitGutterStageHunk)", -1)
endfunction

function! gitgutter#hunk#undo() abort
  if !gitgutter#utility#has_repo_path(bufnr('')) | return | endif

  call s:hunk_op(function('s:undo'))
  silent! call repeat#set("\<Plug>(GitGutterUndoHunk)", -1)
endfunction

function! gitgutter#hunk#preview() abort
  if !gitgutter#utility#has_repo_path(bufnr('')) | return | endif

  call s:hunk_op(function('s:preview'))
  silent! call repeat#set("\<Plug>(GitGutterPreviewHunk)", -1)
endfunction


function! s:hunk_op(op, ...)
  let bufnr = bufnr('')

  if s:in_hunk_preview_window()
    if string(a:op) =~ '_stage'
      " combine hunk-body in preview window with updated hunk-header
      let hunk_body = getline(1, '$')

      let [removed, added] = [0, 0]
      for line in hunk_body
        if line[0] == '-'
          let removed += 1
        elseif line[0] == '+'
          let added += 1
        endif
      endfor

      let hunk_header = b:hunk_header
      " from count
      let hunk_header[4] = substitute(hunk_header[4], '\(-\d\+\)\(,\d\+\)\?', '\=submatch(1).",".removed', '')
      " to count
      let hunk_header[4] = substitute(hunk_header[4], '\(+\d\+\)\(,\d\+\)\?', '\=submatch(1).",".added', '')

      let hunk_diff = join(hunk_header + hunk_body, "\n")."\n"

      call s:goto_original_window()
      call gitgutter#hunk#close_hunk_preview_window()
      call s:stage(hunk_diff)
    endif

    return
  endif

  if gitgutter#utility#is_active(bufnr)
    " Get a (synchronous) diff.
    let [async, g:gitgutter_async] = [g:gitgutter_async, 0]
    let diff = gitgutter#diff#run_diff(bufnr, g:gitgutter_diff_relative_to, 1)
    let g:gitgutter_async = async

    call gitgutter#hunk#set_hunks(bufnr, gitgutter#diff#parse_diff(diff))
    call gitgutter#diff#process_hunks(bufnr, gitgutter#hunk#hunks(bufnr))  " so the hunk summary is updated

    if empty(s:current_hunk())
      call gitgutter#utility#warn('Cursor is not in a hunk')
    elseif s:cursor_in_two_hunks()
      let choice = input('Choose hunk: upper or lower (u/l)? ')
      " Clear input
      normal! :<ESC>
      if choice =~ 'u'
        call a:op(gitgutter#diff#hunk_diff(bufnr, diff, 0))
      elseif choice =~ 'l'
        call a:op(gitgutter#diff#hunk_diff(bufnr, diff, 1))
      else
        call gitgutter#utility#warn('Did not recognise your choice')
      endif
    else
      let hunk_diff = gitgutter#diff#hunk_diff(bufnr, diff)

      if a:0
        let hunk_first_line = s:current_hunk()[2]
        let hunk_diff = s:part_of_diff(hunk_diff, a:1-hunk_first_line, a:2-hunk_first_line)
      endif

      call a:op(hunk_diff)
    endif
  endif
endfunction


function! s:stage(hunk_diff)
  let bufnr = bufnr('')

  if gitgutter#utility#clean_smudge_filter_applies(bufnr)
    let choice = input('File uses clean/smudge filter. Stage entire file (y/n)? ')
    normal! :<ESC>
    if choice =~ 'y'
      " We are about to add the file to the index so write the buffer to
      " ensure the file on disk matches it (the buffer).
      write
      let path = gitgutter#utility#repo_path(bufnr, 1)
      " Add file to index.
      let cmd = gitgutter#utility#cd_cmd(bufnr,
            \ gitgutter#git().' add '.
            \ gitgutter#utility#shellescape(gitgutter#utility#filename(bufnr)))
      call gitgutter#utility#system(cmd)
    else
      return
    endif

  else
    let diff = s:adjust_header(bufnr, a:hunk_diff)
    " Apply patch to index.
    call gitgutter#utility#system(
          \ gitgutter#utility#cd_cmd(bufnr, gitgutter#git().' apply --cached --unidiff-zero - '),
          \ diff)
  endif

  if v:shell_error
    call gitgutter#utility#warn('Patch does not apply')
  else
    if exists('#User#GitGutterStage')
      execute 'doautocmd' s:nomodeline 'User GitGutterStage'
    endif
  endif

  " Refresh gitgutter's view of buffer.
  call gitgutter#process_buffer(bufnr, 1)
endfunction


function! s:undo(hunk_diff)
  " Apply reverse patch to buffer.
  let hunk  = gitgutter#diff#parse_hunk(split(a:hunk_diff, '\n')[4])
  let lines = map(split(a:hunk_diff, '\r\?\n')[5:], 'v:val[1:]')
  let lnum  = hunk[2]
  let added_only   = hunk[1] == 0 && hunk[3]  > 0
  let removed_only = hunk[1]  > 0 && hunk[3] == 0

  if removed_only
    call append(lnum, lines)
  elseif added_only
    execute lnum .','. (lnum+len(lines)-1) .'d _'
  else
    call append(lnum-1, lines[0:hunk[1]])
    execute (lnum+hunk[1]) .','. (lnum+hunk[1]+hunk[3]) .'d _'
  endif

  " Refresh gitgutter's view of buffer.
  call gitgutter#process_buffer(bufnr(''), 1)
endfunction


function! s:preview(hunk_diff)
  let lines = split(a:hunk_diff, '\r\?\n')
  let header = lines[0:4]
  let body = lines[5:]

  call s:open_hunk_preview_window()
  call s:populate_hunk_preview_window(header, body)
  call s:enable_staging_from_hunk_preview_window()
  if &previewwindow
    call s:goto_original_window()
  endif
endfunction


" Returns a new hunk diff using the specified lines from the given one.
" Assumes all lines are additions.
" a:first, a:last - 0-based indexes into the body of the hunk.
function! s:part_of_diff(hunk_diff, first, last)
  let diff_lines = split(a:hunk_diff, '\n', 1)

  " adjust 'to' line count in header
  let diff_lines[4] = substitute(diff_lines[4], '\(+\d\+\)\(,\d\+\)\?', '\=submatch(1).",".(a:last-a:first+1)', '')

  return join(diff_lines[0:4] + diff_lines[5+a:first:5+a:last], "\n")."\n"
endfunction


function! s:adjust_header(bufnr, hunk_diff)
  let filepath = gitgutter#utility#repo_path(a:bufnr, 0)
  return s:adjust_hunk_summary(s:fix_file_references(filepath, a:hunk_diff))
endfunction


" Replaces references to temp files with the actual file.
function! s:fix_file_references(filepath, hunk_diff)
  let lines = split(a:hunk_diff, '\n')

  let left_prefix  = matchstr(lines[2], '[abciow12]').'/'
  let right_prefix = matchstr(lines[3], '[abciow12]').'/'
  let quote        = lines[0][11] == '"' ? '"' : ''

  let left_file  = quote.left_prefix.a:filepath.quote
  let right_file = quote.right_prefix.a:filepath.quote

  let lines[0] = 'diff --git '.left_file.' '.right_file
  let lines[2] = '--- '.left_file
  let lines[3] = '+++ '.right_file

  return join(lines, "\n")."\n"
endfunction


function! s:adjust_hunk_summary(hunk_diff) abort
  let line_adjustment = s:line_adjustment_for_current_hunk()
  let diff = split(a:hunk_diff, '\n', 1)
  let diff[4] = substitute(diff[4], '+\zs\(\d\+\)', '\=submatch(1)+line_adjustment', '')
  return join(diff, "\n")
endfunction


" Returns the number of lines the current hunk is offset from where it would
" be if any changes above it in the file didn't exist.
function! s:line_adjustment_for_current_hunk() abort
  let bufnr = bufnr('')
  let adj = 0
  for hunk in gitgutter#hunk#hunks(bufnr)
    if gitgutter#hunk#cursor_in_hunk(hunk)
      break
    else
      let adj += hunk[1] - hunk[3]
    endif
  endfor
  return adj
endfunction


function! s:in_hunk_preview_window()
  if g:gitgutter_preview_win_floating
    return win_id2win(s:winid) == winnr()
  else
    return &previewwindow
  endif
endfunction


" Floating window: does not move cursor to floating window.
" Preview window: moves cursor to preview window.
function! s:open_hunk_preview_window()
  let source_wrap = &wrap
  let source_window = winnr()

  if g:gitgutter_preview_win_floating
    if exists('*nvim_open_win')
      call gitgutter#hunk#close_hunk_preview_window()

      let buf = nvim_create_buf(v:false, v:false)
      " Set default width and height for now.
      let s:winid = nvim_open_win(buf, v:false, g:gitgutter_floating_window_options)
      call nvim_win_set_option(s:winid, 'wrap', source_wrap ? v:true : v:false)
      call nvim_buf_set_option(buf, 'filetype',  'diff')
      call nvim_buf_set_option(buf, 'buftype',   'acwrite')
      call nvim_buf_set_option(buf, 'bufhidden', 'delete')
      call nvim_buf_set_option(buf, 'swapfile',  v:false)
      call nvim_buf_set_name(buf, 'gitgutter://hunk-preview')

      " Assumes cursor is in original window.
      autocmd CursorMoved,TabLeave <buffer> ++once call gitgutter#hunk#close_hunk_preview_window()

      if g:gitgutter_close_preview_on_escape
        " Map <Esc> to close the floating preview.
        nnoremap <buffer> <silent> <Esc> :<C-U>call gitgutter#hunk#close_hunk_preview_window()<CR>
        " Ensure that when the preview window is closed, the map is removed.
        autocmd User GitGutterPreviewClosed silent! nunmap <buffer> <Esc>
        autocmd CursorMoved <buffer> ++once silent! nunmap <buffer> <Esc>
        execute "autocmd WinClosed <buffer=".winbufnr(s:winid)."> doautocmd" s:nomodeline "User GitGutterPreviewClosed"
      endif

      return
    endif

    if exists('*popup_create')
      if g:gitgutter_close_preview_on_escape
        let g:gitgutter_floating_window_options.filter = function('s:close_popup_on_escape')
      endif

      let s:winid = popup_create('', g:gitgutter_floating_window_options)

      call setbufvar(winbufnr(s:winid), '&filetype', 'diff')
      call setwinvar(s:winid, '&wrap', source_wrap)

      return
    endif
  endif

  if exists('&previewpopup')
    let [previewpopup, &previewpopup] = [&previewpopup, '']
  endif

  " Specifying where to open the preview window can lead to the cursor going
  " to an unexpected window when the preview window is closed (#769).
  silent! noautocmd execute g:gitgutter_preview_win_location 'pedit gitgutter://hunk-preview'
  silent! wincmd P
  setlocal statusline=%{''}
  doautocmd WinEnter
  if exists('*win_getid')
    let s:winid = win_getid()
  else
    let s:preview_bufnr = bufnr('')
  endif
  setlocal filetype=diff buftype=acwrite bufhidden=delete
  let &l:wrap = source_wrap
  let b:source_window = source_window
  " Reset some defaults in case someone else has changed them.
  setlocal noreadonly modifiable noswapfile
  if g:gitgutter_close_preview_on_escape
    " Ensure cursor goes to the expected window.
    nnoremap <buffer> <silent> <Esc> :<C-U>execute b:source_window . "wincmd w"<Bar>pclose<CR>
  endif

  if exists('&previewpopup')
    let &previewpopup=previewpopup
  endif
endfunction


function! s:close_popup_on_escape(winid, key)
  if a:key == "\<Esc>"
    call popup_close(a:winid)
    return 1
  endif
  return 0
endfunction


" Floating window: does not care where cursor is.
" Preview window: assumes cursor is in preview window.
function! s:populate_hunk_preview_window(header, body)
  if g:gitgutter_preview_win_floating
    if exists('*nvim_open_win')
      " Assumes cursor is not in previewing window.
      call nvim_buf_set_var(winbufnr(s:winid), 'hunk_header', a:header)

      let [_scrolloff, &scrolloff] = [&scrolloff, 0]

      let [width, height] = s:screen_lines(a:body)
      let height = min([height, g:gitgutter_floating_window_options.height])
      call nvim_win_set_width(s:winid, width)
      call nvim_win_set_height(s:winid, height)

      let &scrolloff=_scrolloff

      call nvim_buf_set_lines(winbufnr(s:winid), 0, -1, v:false, [])
      call nvim_buf_set_lines(winbufnr(s:winid), 0, -1, v:false, a:body)
      call nvim_buf_set_option(winbufnr(s:winid), 'modified', v:false)

      let ns_id = nvim_create_namespace('GitGutter')
      call nvim_buf_clear_namespace(winbufnr(s:winid), ns_id, 0, -1)
      for region in gitgutter#diff_highlight#process(a:body)
        let group = region[1] == '+' ? 'GitGutterAddIntraLine' : 'GitGutterDeleteIntraLine'
        call nvim_buf_add_highlight(winbufnr(s:winid), ns_id, group, region[0]-1, region[2]-1, region[3])
      endfor

      call nvim_win_set_cursor(s:winid, [1,0])
    endif

    if exists('*popup_create')
      call popup_settext(s:winid, a:body)

      for region in gitgutter#diff_highlight#process(a:body)
        let group = region[1] == '+' ? 'GitGutterAddIntraLine' : 'GitGutterDeleteIntraLine'
        call win_execute(s:winid, "call matchaddpos('".group."', [[".region[0].", ".region[2].", ".(region[3]-region[2]+1)."]])")
      endfor
    endif

  else
    let b:hunk_header = a:header

    %delete _
    call setline(1, a:body)
    setlocal nomodified

    let [_, height] = s:screen_lines(a:body)
    execute 'resize' height
    1

    call clearmatches()
    for region in gitgutter#diff_highlight#process(a:body)
      let group = region[1] == '+' ? 'GitGutterAddIntraLine' : 'GitGutterDeleteIntraLine'
      call matchaddpos(group, [[region[0], region[2], region[3]-region[2]+1]])
    endfor

    1
  endif
endfunction


" Calculates the number of columns and the number of screen lines the given
" array of lines will take up, taking account of wrapping.
function! s:screen_lines(lines)
  let [_virtualedit, &virtualedit]=[&virtualedit, 'all']
  let cursor = getcurpos()
  normal! 0g$
  let available_width = virtcol('.')
  call setpos('.', cursor)
  let &virtualedit=_virtualedit
  let width = min([max(map(copy(a:lines), 'strdisplaywidth(v:val)')), available_width])

  if exists('*reduce')
    let height = reduce(a:lines, { acc, val -> acc + strdisplaywidth(val) / width + (strdisplaywidth(val) % width == 0 ? 0 : 1) }, 0)
  else
    let height = eval(join(map(copy(a:lines), 'strdisplaywidth(v:val) / width + (strdisplaywidth(v:val) % width == 0 ? 0 : 1)'), '+'))
  endif

  return [width, height]
endfunction


function! s:enable_staging_from_hunk_preview_window()
  augroup gitgutter_hunk_preview
    autocmd!
    let bufnr = s:winid != 0 ? winbufnr(s:winid) : s:preview_bufnr
    execute 'autocmd BufWriteCmd <buffer='.bufnr.'> GitGutterStageHunk'
  augroup END
endfunction


function! s:goto_original_window()
  noautocmd execute b:source_window . "wincmd w"
  doautocmd WinEnter
endfunction


function! gitgutter#hunk#close_hunk_preview_window()
  let bufnr = s:winid != 0 ? winbufnr(s:winid) : s:preview_bufnr
  call setbufvar(bufnr, '&modified', 0)

  if g:gitgutter_preview_win_floating
    if win_id2win(s:winid) > 0
      execute win_id2win(s:winid).'wincmd c'
    endif
  else
    pclose
  endif

  let s:winid = 0
  let s:preview_bufnr = 0
endfunction


function gitgutter#hunk#is_preview_window_open()
  if g:gitgutter_preview_win_floating
    if win_id2win(s:winid) > 0
      execute win_id2win(s:winid).'wincmd c'
    endif
  else
    for i in range(1, winnr('$'))
      if getwinvar(i, '&previewwindow')
        return 1
      endif
    endfor
  endif
  return 0
endfunction
./autoload/gitgutter/sign.vim	[[[1
250
" For older Vims without sign_place() the plugin has to manaage the sign ids.
let s:first_sign_id = 3000
let s:next_sign_id  = s:first_sign_id
" Remove-all-signs optimisation requires Vim 7.3.596+.
let s:supports_star = v:version > 703 || (v:version == 703 && has("patch596"))


function! gitgutter#sign#enable() abort
  let old_signs = g:gitgutter_signs

  let g:gitgutter_signs = 1
  call gitgutter#highlight#define_sign_text_highlights()

  if !old_signs && !g:gitgutter_highlight_lines && !g:gitgutter_highlight_linenrs
    call gitgutter#all(1)
  endif
endfunction

function! gitgutter#sign#disable() abort
  let g:gitgutter_signs = 0
  call gitgutter#highlight#define_sign_text_highlights()

  if !g:gitgutter_highlight_lines && !g:gitgutter_highlight_linenrs
    call gitgutter#sign#clear_signs(bufnr(''))
  endif
endfunction

function! gitgutter#sign#toggle() abort
  if g:gitgutter_signs
    call gitgutter#sign#disable()
  else
    call gitgutter#sign#enable()
  endif
endfunction


" Removes gitgutter's signs from the buffer being processed.
function! gitgutter#sign#clear_signs(bufnr) abort
  if exists('*sign_unplace')
    call sign_unplace('gitgutter', {'buffer': a:bufnr})
    return
  endif


  call s:find_current_signs(a:bufnr)

  let sign_ids = map(values(gitgutter#utility#getbufvar(a:bufnr, 'gitgutter_signs')), 'v:val.id')
  call s:remove_signs(a:bufnr, sign_ids, 1)
  call gitgutter#utility#setbufvar(a:bufnr, 'gitgutter_signs', {})
endfunction


" Updates gitgutter's signs in the buffer being processed.
"
" modified_lines: list of [<line_number (number)>, <name (string)>]
" where name = 'added|removed|modified|modified_removed'
function! gitgutter#sign#update_signs(bufnr, modified_lines) abort
  if exists('*sign_unplace')
    " Vim is (hopefully) now quick enough to remove all signs then place new ones.
    call sign_unplace('gitgutter', {'buffer': a:bufnr})

    let modified_lines = s:handle_double_hunk(a:modified_lines)
    let signs = map(copy(modified_lines), '{'.
          \ '"buffer":   a:bufnr,'.
          \ '"group":    "gitgutter",'.
          \ '"name":     s:highlight_name_for_change(v:val[1]),'.
          \ '"lnum":     v:val[0],'.
          \ '"priority": g:gitgutter_sign_priority'.
          \ '}')

    if exists('*sign_placelist')
      call sign_placelist(signs)
      return
    endif

    for sign in signs
      call sign_place(0, sign.group, sign.name, sign.buffer, {'lnum': sign.lnum, 'priority': sign.priority})
    endfor
    return
  endif


  " Derive a delta between the current signs and the ones we want.
  " Remove signs from lines that no longer need a sign.
  " Upsert the remaining signs.

  call s:find_current_signs(a:bufnr)

  let new_gitgutter_signs_line_numbers = map(copy(a:modified_lines), 'v:val[0]')
  let obsolete_signs = s:obsolete_gitgutter_signs_to_remove(a:bufnr, new_gitgutter_signs_line_numbers)

  call s:remove_signs(a:bufnr, obsolete_signs, s:remove_all_old_signs)
  call s:upsert_new_gitgutter_signs(a:bufnr, a:modified_lines)
endfunction


"
" Internal functions
"


function! s:find_current_signs(bufnr) abort
  let gitgutter_signs = {}  " <line_number (string)>: {'id': <id (number)>, 'name': <name (string)>}
  if !g:gitgutter_sign_allow_clobber
    let other_signs = []      " [<line_number (number),...]
  endif

  if exists('*getbufinfo')
    let bufinfo = getbufinfo(a:bufnr)[0]
    let signs = has_key(bufinfo, 'signs') ? bufinfo.signs : []
  else
    let signs = []

    redir => signlines
      silent execute "sign place buffer=" . a:bufnr
    redir END

    for signline in filter(split(signlines, '\n')[2:], 'v:val =~# "="')
      " Typical sign line before v8.1.0614:  line=88 id=1234 name=GitGutterLineAdded
      " We assume splitting is faster than a regexp.
      let components = split(signline)
      call add(signs, {
            \ 'lnum': str2nr(split(components[0], '=')[1]),
            \ 'id':   str2nr(split(components[1], '=')[1]),
            \ 'name':        split(components[2], '=')[1]
            \ })
    endfor
  endif

  for sign in signs
    if sign.name =~# 'GitGutter'
      " Remove orphaned signs (signs placed on lines which have been deleted).
      " (When a line is deleted its sign lingers.  Subsequent lines' signs'
      " line numbers are decremented appropriately.)
      if has_key(gitgutter_signs, sign.lnum)
        execute "sign unplace" gitgutter_signs[sign.lnum].id
      endif
      let gitgutter_signs[sign.lnum] = {'id': sign.id, 'name': sign.name}
    else
      if !g:gitgutter_sign_allow_clobber
        call add(other_signs, sign.lnum)
      endif
    endif
  endfor

  call gitgutter#utility#setbufvar(a:bufnr, 'gitgutter_signs', gitgutter_signs)
  if !g:gitgutter_sign_allow_clobber
    call gitgutter#utility#setbufvar(a:bufnr, 'other_signs', other_signs)
  endif
endfunction


" Returns a list of [<id (number)>, ...]
" Sets `s:remove_all_old_signs` as a side-effect.
function! s:obsolete_gitgutter_signs_to_remove(bufnr, new_gitgutter_signs_line_numbers) abort
  let signs_to_remove = []  " list of [<id (number)>, ...]
  let remove_all_signs = 1
  let old_gitgutter_signs = gitgutter#utility#getbufvar(a:bufnr, 'gitgutter_signs')
  for line_number in keys(old_gitgutter_signs)
    if index(a:new_gitgutter_signs_line_numbers, str2nr(line_number)) == -1
      call add(signs_to_remove, old_gitgutter_signs[line_number].id)
    else
      let remove_all_signs = 0
    endif
  endfor
  let s:remove_all_old_signs = remove_all_signs
  return signs_to_remove
endfunction


function! s:remove_signs(bufnr, sign_ids, all_signs) abort
  if a:all_signs && s:supports_star && (g:gitgutter_sign_allow_clobber || empty(gitgutter#utility#getbufvar(a:bufnr, 'other_signs')))
    execute "sign unplace * buffer=" . a:bufnr
  else
    for id in a:sign_ids
      execute "sign unplace" id
    endfor
  endif
endfunction


function! s:upsert_new_gitgutter_signs(bufnr, modified_lines) abort
  if !g:gitgutter_sign_allow_clobber
    let other_signs = gitgutter#utility#getbufvar(a:bufnr, 'other_signs')
  endif
  let old_gitgutter_signs = gitgutter#utility#getbufvar(a:bufnr, 'gitgutter_signs')

  let modified_lines = s:handle_double_hunk(a:modified_lines)

  for line in modified_lines
    let line_number = line[0]  " <number>
    if g:gitgutter_sign_allow_clobber || index(other_signs, line_number) == -1  " don't clobber others' signs
      let name = s:highlight_name_for_change(line[1])
      if !has_key(old_gitgutter_signs, line_number)  " insert
        let id = s:next_sign_id()
        execute "sign place" id "line=" . line_number "name=" . name "buffer=" . a:bufnr
      else  " update if sign has changed
        let old_sign = old_gitgutter_signs[line_number]
        if old_sign.name !=# name
          execute "sign place" old_sign.id "name=" . name "buffer=" . a:bufnr
        end
      endif
    endif
  endfor
  " At this point b:gitgutter_gitgutter_signs is out of date.
endfunction


" Handle special case where the first line is the site of two hunks:
" lines deleted above at the start of the file, and lines deleted
" immediately below.
function! s:handle_double_hunk(modified_lines)
  if a:modified_lines[0:1] == [[1, 'removed_first_line'], [1, 'removed']]
    return [[1, 'removed_above_and_below']] + a:modified_lines[2:]
  endif

  return a:modified_lines
endfunction


function! s:next_sign_id() abort
  let next_id = s:next_sign_id
  let s:next_sign_id += 1
  return next_id
endfunction


" Only for testing.
function! gitgutter#sign#reset()
  let s:next_sign_id  = s:first_sign_id
endfunction


function! s:highlight_name_for_change(text) abort
  if a:text ==# 'added'
    return 'GitGutterLineAdded'
  elseif a:text ==# 'removed'
    return 'GitGutterLineRemoved'
  elseif a:text ==# 'removed_first_line'
    return 'GitGutterLineRemovedFirstLine'
  elseif a:text ==# 'modified'
    return 'GitGutterLineModified'
  elseif a:text ==# 'modified_removed'
    return 'GitGutterLineModifiedRemoved'
  elseif a:text ==# 'removed_above_and_below'
    return 'GitGutterLineRemovedAboveAndBelow'
  endif
endfunction


./autoload/gitgutter/utility.vim	[[[1
268
function! gitgutter#utility#supports_overscore_sign()
  if gitgutter#utility#windows()
    return &encoding ==? 'utf-8'
  else
    return &termencoding ==? &encoding || &termencoding == ''
  endif
endfunction

function! gitgutter#utility#setbufvar(buffer, varname, val)
  let buffer = +a:buffer
  " Default value for getbufvar() was introduced in Vim 7.3.831.
  let ggvars = getbufvar(buffer, 'gitgutter')
  if type(ggvars) == type('')
    unlet ggvars
    let ggvars = {}
    call setbufvar(buffer, 'gitgutter', ggvars)
  endif
  let ggvars[a:varname] = a:val
endfunction

function! gitgutter#utility#getbufvar(buffer, varname, ...)
  let ggvars = getbufvar(a:buffer, 'gitgutter')
  if type(ggvars) == type({}) && has_key(ggvars, a:varname)
    return ggvars[a:varname]
  endif
  if a:0
    return a:1
  endif
endfunction

function! gitgutter#utility#warn(message) abort
  echohl WarningMsg
  echo a:message
  echohl None
  let v:warningmsg = a:message
endfunction

function! gitgutter#utility#warn_once(bufnr, message, key) abort
  if empty(gitgutter#utility#getbufvar(a:bufnr, a:key))
    call gitgutter#utility#setbufvar(a:bufnr, a:key, '1')
    echohl WarningMsg
    redraw | echom a:message
    echohl None
    let v:warningmsg = a:message
  endif
endfunction

" Returns truthy when the buffer's file should be processed; and falsey when it shouldn't.
" This function does not and should not make any system calls.
function! gitgutter#utility#is_active(bufnr) abort
  return gitgutter#utility#getbufvar(a:bufnr, 'enabled') &&
        \ !pumvisible() &&
        \ s:is_file_buffer(a:bufnr) &&
        \ s:exists_file(a:bufnr) &&
        \ s:not_git_dir(a:bufnr)
endfunction

function! s:not_git_dir(bufnr) abort
  return s:dir(a:bufnr) !~ '[/\\]\.git\($\|[/\\]\)'
endfunction

function! s:is_file_buffer(bufnr) abort
  return empty(getbufvar(a:bufnr, '&buftype'))
endfunction

" From tpope/vim-fugitive
function! s:winshell()
  return &shell =~? 'cmd' || exists('+shellslash') && !&shellslash
endfunction

" From tpope/vim-fugitive
function! gitgutter#utility#shellescape(arg) abort
  if a:arg =~ '^[A-Za-z0-9_/.-]\+$'
    return a:arg
  elseif s:winshell()
    return '"' . substitute(substitute(a:arg, '"', '""', 'g'), '%', '"%"', 'g') . '"'
  else
    return shellescape(a:arg)
  endif
endfunction

function! gitgutter#utility#file(bufnr)
  return s:abs_path(a:bufnr, 1)
endfunction

" Not shellescaped
function! gitgutter#utility#extension(bufnr) abort
  return fnamemodify(s:abs_path(a:bufnr, 0), ':e')
endfunction

function! gitgutter#utility#system(cmd, ...) abort
  call gitgutter#debug#log(a:cmd, a:000)

  call s:use_known_shell()
  silent let output = (a:0 == 0) ? system(a:cmd) : system(a:cmd, a:1)
  call s:restore_shell()

  return output
endfunction

function! gitgutter#utility#has_repo_path(bufnr)
  return index(['', -1, -2], gitgutter#utility#repo_path(a:bufnr, 0)) == -1
endfunction

" Path of file relative to repo root.
"
" *     empty string - not set
" * non-empty string - path
" *               -1 - pending
" *               -2 - not tracked by git
" *               -3 - assume unchanged
function! gitgutter#utility#repo_path(bufnr, shellesc) abort
  let p = gitgutter#utility#getbufvar(a:bufnr, 'path', '')
  return a:shellesc ? gitgutter#utility#shellescape(p) : p
endfunction


let s:set_path_handler = {}

function! s:set_path_handler.out(buffer, listing) abort
  let listing = s:strip_trailing_new_line(a:listing)
  let [status, path] = [listing[0], listing[2:]]
  if status =~# '[a-z]'
    call gitgutter#utility#setbufvar(a:buffer, 'path', -3)
  else
    call gitgutter#utility#setbufvar(a:buffer, 'path', path)
  endif

  if type(self.continuation) == type(function('tr'))
    call self.continuation()
  else
    call call(self.continuation.function, self.continuation.arguments)
  endif
endfunction

function! s:set_path_handler.err(buffer) abort
  call gitgutter#utility#setbufvar(a:buffer, 'path', -2)
endfunction


" continuation - a funcref or hash to call after setting the repo path asynchronously.
"
" Returns 'async' if the the path is set asynchronously, 0 otherwise.
function! gitgutter#utility#set_repo_path(bufnr, continuation) abort
  " Values of path:
  " * non-empty string - path
  " *               -1 - pending
  " *               -2 - not tracked by git
  " *               -3 - assume unchanged

  call gitgutter#utility#setbufvar(a:bufnr, 'path', -1)
  let cmd = gitgutter#utility#cd_cmd(a:bufnr,
        \ gitgutter#git().' ls-files -v --error-unmatch --full-name -z -- '.
        \ gitgutter#utility#shellescape(gitgutter#utility#filename(a:bufnr)))

  if g:gitgutter_async && gitgutter#async#available() && !has('vim_starting')
    let handler = copy(s:set_path_handler)
    let handler.continuation = a:continuation
    call gitgutter#async#execute(cmd, a:bufnr, handler)
    return 'async'
  endif

  let listing = gitgutter#utility#system(cmd)

  if v:shell_error
    call gitgutter#utility#setbufvar(a:bufnr, 'path', -2)
    return
  endif

  let listing = s:strip_trailing_new_line(listing)
  let [status, path] = [listing[0], listing[2:]]
  if status =~# '[a-z]'
    call gitgutter#utility#setbufvar(a:bufnr, 'path', -3)
  else
    call gitgutter#utility#setbufvar(a:bufnr, 'path', path)
  endif
endfunction


function! gitgutter#utility#clean_smudge_filter_applies(bufnr)
  let filtered = gitgutter#utility#getbufvar(a:bufnr, 'filter', -1)
  if filtered == -1
    let cmd = gitgutter#utility#cd_cmd(a:bufnr,
          \ gitgutter#git().' check-attr filter -- '.
          \ gitgutter#utility#shellescape(gitgutter#utility#filename(a:bufnr)))
    let out = gitgutter#utility#system(cmd)
    let filtered = out !~ 'unspecified'
    call gitgutter#utility#setbufvar(a:bufnr, 'filter', filtered)
  endif
  return filtered
endfunction


function! gitgutter#utility#cd_cmd(bufnr, cmd) abort
  let cd = s:unc_path(a:bufnr) ? 'pushd' : (gitgutter#utility#windows() && s:dos_shell() ? 'cd /d' : 'cd')
  return cd.' '.s:dir(a:bufnr).' && '.a:cmd
endfunction

function! s:unc_path(bufnr)
  return s:abs_path(a:bufnr, 0) =~ '^\\\\'
endfunction

function! s:dos_shell()
  return &shell == 'cmd.exe' || &shell == 'command.com'
endfunction

function! s:use_known_shell() abort
  if has('unix') && &shell !=# 'sh'
    let [s:shell, s:shellcmdflag, s:shellredir, s:shellpipe, s:shellquote, s:shellxquote] = [&shell, &shellcmdflag, &shellredir, &shellpipe, &shellquote, &shellxquote]
    let &shell = 'sh'
    set shellcmdflag=-c shellredir=>%s\ 2>&1
  endif
  if has('win32') && (&shell =~# 'pwsh' || &shell =~# 'powershell')
    let [s:shell, s:shellcmdflag, s:shellredir, s:shellpipe, s:shellquote, s:shellxquote] = [&shell, &shellcmdflag, &shellredir, &shellpipe, &shellquote, &shellxquote]
    let &shell = 'cmd.exe'
    set shellcmdflag=/s\ /c shellredir=>%s\ 2>&1 shellpipe=>%s\ 2>&1 shellquote= shellxquote="
  endif
endfunction

function! s:restore_shell() abort
  if (has('unix') || has('win32')) && exists('s:shell')
    let [&shell, &shellcmdflag, &shellredir, &shellpipe, &shellquote, &shellxquote] = [s:shell, s:shellcmdflag, s:shellredir, s:shellpipe, s:shellquote, s:shellxquote]
  endif
endfunction

function! gitgutter#utility#get_diff_base(bufnr)
  let p = resolve(expand('#'.a:bufnr.':p'))
  let ml = matchlist(p, '\v^fugitive:/.*/(\x{40,})/')
  if !empty(ml) && !empty(ml[1])
    return ml[1].'^'
  endif
  return g:gitgutter_diff_base
endfunction

function! s:abs_path(bufnr, shellesc)
  let p = resolve(expand('#'.a:bufnr.':p'))

  " Remove extra parts from fugitive's filepaths
  let p = substitute(substitute(p, '^fugitive:', '', ''), '\v\.git/\x{40,}/', '', '')

  return a:shellesc ? gitgutter#utility#shellescape(p) : p
endfunction

function! s:dir(bufnr) abort
  return gitgutter#utility#shellescape(fnamemodify(s:abs_path(a:bufnr, 0), ':h'))
endfunction

" Not shellescaped.
function! gitgutter#utility#filename(bufnr) abort
  return fnamemodify(s:abs_path(a:bufnr, 0), ':t')
endfunction

function! s:exists_file(bufnr) abort
  return filereadable(s:abs_path(a:bufnr, 0))
endfunction

" Get rid of any trailing new line or SOH character.
"
" git ls-files -z produces output with null line termination.
" Vim's system() replaces any null characters in the output
" with SOH (start of header), i.e. ^A.
function! s:strip_trailing_new_line(line) abort
  return substitute(a:line, '[[:cntrl:]]$', '', '')
endfunction

function! gitgutter#utility#windows()
  return has('win64') || has('win32') || has('win16')
endfunction
./autoload/gitgutter.vim	[[[1
277
" Primary functions {{{

function! gitgutter#all(force) abort
  let visible = tabpagebuflist()

  for bufnr in range(1, bufnr('$') + 1)
    if buflisted(bufnr)
      let file = expand('#'.bufnr.':p')
      if !empty(file)
        if index(visible, bufnr) != -1
          call gitgutter#process_buffer(bufnr, a:force)
        elseif a:force
          call s:reset_tick(bufnr)
        endif
      endif
    endif
  endfor
endfunction


function! gitgutter#process_buffer(bufnr, force) abort
  " NOTE a:bufnr is not necessarily the current buffer.

  if gitgutter#utility#getbufvar(a:bufnr, 'enabled', -1) == -1
    call gitgutter#utility#setbufvar(a:bufnr, 'enabled', g:gitgutter_enabled)
  endif

  if gitgutter#utility#is_active(a:bufnr)

    if has('patch-7.4.1559')
      let l:Callback = function('gitgutter#process_buffer', [a:bufnr, a:force])
    else
      let l:Callback = {'function': 'gitgutter#process_buffer', 'arguments': [a:bufnr, a:force]}
    endif
    let how = s:setup_path(a:bufnr, l:Callback)
    if [how] == ['async']  " avoid string-to-number conversion if how is a number
      return
    endif

    if a:force || s:has_fresh_changes(a:bufnr)

      let diff = 'NOT SET'
      try
        let diff = gitgutter#diff#run_diff(a:bufnr, g:gitgutter_diff_relative_to, 0)
      catch /gitgutter not tracked/
        call gitgutter#debug#log('Not tracked: '.gitgutter#utility#file(a:bufnr))
      catch /gitgutter assume unchanged/
        call gitgutter#debug#log('Assume unchanged: '.gitgutter#utility#file(a:bufnr))
      catch /gitgutter file unknown in base/
        let diff = gitgutter#diff#hunk_header_showing_every_line_added(a:bufnr)
      catch /gitgutter diff failed/
        call gitgutter#debug#log('Diff failed: '.gitgutter#utility#file(a:bufnr))
        call gitgutter#hunk#reset(a:bufnr)
      endtry

      if diff != 'async' && diff != 'NOT SET'
        call gitgutter#diff#handler(a:bufnr, diff)
      endif

    endif
  endif
endfunction


function! gitgutter#disable() abort
  call s:toggle_each_buffer(0)
  let g:gitgutter_enabled = 0
endfunction

function! gitgutter#enable() abort
  call s:toggle_each_buffer(1)
  let g:gitgutter_enabled = 1
endfunction

function s:toggle_each_buffer(enable)
  for bufnr in range(1, bufnr('$') + 1)
    if buflisted(bufnr)
      let file = expand('#'.bufnr.':p')
      if !empty(file)
        if a:enable
          call gitgutter#buffer_enable(bufnr)
        else
          call gitgutter#buffer_disable(bufnr)
        end
      endif
    endif
  endfor
endfunction

function! gitgutter#toggle() abort
  if g:gitgutter_enabled
    call gitgutter#disable()
  else
    call gitgutter#enable()
  endif
endfunction


function! gitgutter#buffer_disable(...) abort
  let bufnr = a:0 ? a:1 : bufnr('')
  call gitgutter#utility#setbufvar(bufnr, 'enabled', 0)
  call s:clear(bufnr)
endfunction

function! gitgutter#buffer_enable(...) abort
  let bufnr = a:0 ? a:1 : bufnr('')
  call gitgutter#utility#setbufvar(bufnr, 'enabled', 1)
  call gitgutter#process_buffer(bufnr, 1)
endfunction

function! gitgutter#buffer_toggle(...) abort
  let bufnr = a:0 ? a:1 : bufnr('')
  if gitgutter#utility#getbufvar(bufnr, 'enabled', 1)
    call gitgutter#buffer_disable(bufnr)
  else
    call gitgutter#buffer_enable(bufnr)
  endif
endfunction

" }}}


function! gitgutter#git()
  if empty(g:gitgutter_git_args)
    return g:gitgutter_git_executable
  else
    return g:gitgutter_git_executable.' '.g:gitgutter_git_args
  endif
endfunction


function! gitgutter#setup_maps()
  if !g:gitgutter_map_keys
    return
  endif

  " Note hasmapto() and maparg() operate on the current buffer.

  let bufnr = bufnr('')

  if gitgutter#utility#getbufvar(bufnr, 'mapped', 0)
    return
  endif

  if !hasmapto('<Plug>(GitGutterPrevHunk)') && maparg('[c', 'n') ==# ''
    nmap <buffer> [c <Plug>(GitGutterPrevHunk)
  endif
  if !hasmapto('<Plug>(GitGutterNextHunk)') && maparg(']c', 'n') ==# ''
    nmap <buffer> ]c <Plug>(GitGutterNextHunk)
  endif

  if !hasmapto('<Plug>(GitGutterStageHunk)', 'v') && maparg('<Leader>hs', 'x') ==# ''
    xmap <buffer> <Leader>hs <Plug>(GitGutterStageHunk)
  endif
  if !hasmapto('<Plug>(GitGutterStageHunk)', 'n') && maparg('<Leader>hs', 'n') ==# ''
    nmap <buffer> <Leader>hs <Plug>(GitGutterStageHunk)
  endif
  if !hasmapto('<Plug>(GitGutterUndoHunk)') && maparg('<Leader>hu', 'n') ==# ''
    nmap <buffer> <Leader>hu <Plug>(GitGutterUndoHunk)
  endif
  if !hasmapto('<Plug>(GitGutterPreviewHunk)') && maparg('<Leader>hp', 'n') ==# ''
    nmap <buffer> <Leader>hp <Plug>(GitGutterPreviewHunk)
  endif

  if !hasmapto('<Plug>(GitGutterTextObjectInnerPending)') && maparg('ic', 'o') ==# ''
    omap <buffer> ic <Plug>(GitGutterTextObjectInnerPending)
  endif
  if !hasmapto('<Plug>(GitGutterTextObjectOuterPending)') && maparg('ac', 'o') ==# ''
    omap <buffer> ac <Plug>(GitGutterTextObjectOuterPending)
  endif
  if !hasmapto('<Plug>(GitGutterTextObjectInnerVisual)') && maparg('ic', 'x') ==# ''
    xmap <buffer> ic <Plug>(GitGutterTextObjectInnerVisual)
  endif
  if !hasmapto('<Plug>(GitGutterTextObjectOuterVisual)') && maparg('ac', 'x') ==# ''
    xmap <buffer> ac <Plug>(GitGutterTextObjectOuterVisual)
  endif

  call gitgutter#utility#setbufvar(bufnr, 'mapped', 1)
endfunction

function! s:setup_path(bufnr, continuation)
  if gitgutter#utility#has_repo_path(a:bufnr) | return | endif

  return gitgutter#utility#set_repo_path(a:bufnr, a:continuation)
endfunction

function! s:has_fresh_changes(bufnr) abort
  return getbufvar(a:bufnr, 'changedtick') != gitgutter#utility#getbufvar(a:bufnr, 'tick')
endfunction

function! s:reset_tick(bufnr) abort
  call gitgutter#utility#setbufvar(a:bufnr, 'tick', 0)
endfunction

function! s:clear(bufnr)
  call gitgutter#sign#clear_signs(a:bufnr)
  call gitgutter#hunk#reset(a:bufnr)
  call s:reset_tick(a:bufnr)
  call gitgutter#utility#setbufvar(a:bufnr, 'path', '')
endfunction


" Note:
" - this runs synchronously
" - it ignores unsaved changes in buffers
" - it does not change to the repo root
function! gitgutter#quickfix(current_file)
  let cmd = gitgutter#git().' rev-parse --show-cdup'
  let path_to_repo = get(systemlist(cmd), 0, '')
  if !empty(path_to_repo) && path_to_repo[-1:] != '/'
    let path_to_repo .= '/'
  endif

  let locations = []
  let cmd = gitgutter#git().' --no-pager'.
        \ ' diff --no-ext-diff --no-color -U0'.
        \ ' --src-prefix=a/'.path_to_repo.' --dst-prefix=b/'.path_to_repo.' '.
        \ g:gitgutter_diff_args. ' '. g:gitgutter_diff_base
  if a:current_file
    let cmd = cmd.' -- '.expand('%:p')
  endif
  let diff = systemlist(cmd)
  let lnum = 0
  for line in diff
    if line =~ '^diff --git [^"]'
      let paths = line[11:]
      let mid = (len(paths) - 1) / 2
      let [fnamel, fnamer] = [paths[:mid-1], paths[mid+1:]]
      let fname = fnamel ==# fnamer ? fnamel : fnamel[2:]
    elseif line =~ '^diff --git "'
      let [_, fnamel, _, fnamer] = split(line, '"')
      let fname = fnamel ==# fnamer ? fnamel : fnamel[2:]
    elseif line =~ '^diff --cc [^"]'
      let fname = line[10:]
    elseif line =~ '^diff --cc "'
      let [_, fname] = split(line, '"')
    elseif line =~ '^@@'
      let lnum = matchlist(line, '+\(\d\+\)')[1]
    elseif lnum > 0
      call add(locations, {'filename': fname, 'lnum': lnum, 'text': line})
      let lnum = 0
    endif
  endfor
  if !g:gitgutter_use_location_list
    call setqflist(locations)
  else
    call setloclist(0, locations)
  endif
endfunction


function! gitgutter#difforig()
  let bufnr = bufnr('')
  let path = gitgutter#utility#repo_path(bufnr, 1)
  let filetype = &filetype

  vertical new
  set buftype=nofile
  let &filetype = filetype

  if g:gitgutter_diff_relative_to ==# 'index'
    let index_name = gitgutter#utility#get_diff_base(bufnr).':'.path
    let cmd = gitgutter#utility#cd_cmd(bufnr,
          \ gitgutter#git().' --no-pager show '.index_name
          \ )
    " NOTE: this uses &shell to execute cmd.  Perhaps we should use instead
    " gitgutter#utility's use_known_shell() / restore_shell() functions.
    silent! execute "read ++edit !" cmd
  else
    silent! execute "read ++edit" path
  endif

  0d_
  diffthis
  wincmd p
  diffthis
endfunction
./doc/gitgutter.txt	[[[1
791
*gitgutter.txt*              A Vim plugin which shows a git diff in the gutter.


                           Vim GitGutter


Author:            Andy Stewart <https://airbladesoftware.com/>
Plugin Homepage:   <https://github.com/airblade/vim-gitgutter>


===============================================================================
CONTENTS                                                            *gitgutter*

  Introduction ................. |gitgutter-introduction|
  Installation ................. |gitgutter-installation|
  Windows      ................. |gitgutter-windows|
  Commands ..................... |gitgutter-commands|
  Mappings ..................... |gitgutter-mappings|
  Autocommand .................. |gitgutter-autocommand|
  Status line .................. |gitgutter-statusline|
  Options ...................... |gitgutter-options|
  Highlights ................... |gitgutter-highlights|
  FAQ .......................... |gitgutter-faq|
  TROUBLESHOOTING .............. |gitgutter-troubleshooting|


===============================================================================
INTRODUCTION                                           *gitgutter-introduction*

GitGutter is a Vim plugin which shows a git diff in the sign column.
It shows which lines have been added, modified, or removed.  You can also
preview, stage, and undo individual hunks.  The plugin also provides a hunk
text object.

The signs are always up to date and the plugin never saves your buffer.

The name "gitgutter" comes from the Sublime Text 3 plugin which inspired this
one in 2013.


===============================================================================
INSTALLATION                                           *gitgutter-installation*

Use your favourite package manager, or use Vim's built-in package support.

Vim:~
>
  mkdir -p ~/.vim/pack/airblade/start
  cd ~/.vim/pack/airblade/start
  git clone https://github.com/airblade/vim-gitgutter.git
  vim -u NONE -c "helptags vim-gitgutter/doc" -c q
<

Neovim:~
>
  mkdir -p ~/.config/nvim/pack/airblade/start
  cd ~/.config/nvim/pack/airblade/start
  git clone https://github.com/airblade/vim-gitgutter.git
  nvim -u NONE -c "helptags vim-gitgutter/doc" -c q
<


===============================================================================
WINDOWS                                                     *gitgutter-windows*

There is a potential risk on Windows due to `cmd.exe` prioritising the current
folder over folders in `PATH`.  If you have a file named `git.*` (i.e. with
any extension in `PATHEXT`) in your current folder, it will be executed
instead of git whenever the plugin calls git.

You can avoid this risk by configuring the full path to your git executable.
For example:
>
    " This path probably won't work
    let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe'
<

Unfortunately I don't know the correct escaping for the path - if you do,
please let me know!


===============================================================================
COMMANDS                                                   *gitgutter-commands*

Commands for turning vim-gitgutter on and off:~

                                                  *gitgutter-:GitGutterDisable*
:GitGutterDisable       Turn vim-gitgutter off for all buffers.

                                                   *gitgutter-:GitGutterEnable*
:GitGutterEnable        Turn vim-gitgutter on for all buffers.

                                                   *gitgutter-:GitGutterToggle*
:GitGutterToggle        Toggle vim-gitgutter on or off for all buffers.

                                            *gitgutter-:GitGutterBufferDisable*
:GitGutterBufferDisable Turn vim-gitgutter off for current buffer.

                                             *gitgutter-:GitGutterBufferEnable*
:GitGutterBufferEnable  Turn vim-gitgutter on for current buffer.

                                             *gitgutter-:GitGutterBufferToggle*
:GitGutterBufferToggle  Toggle vim-gitgutter on or off for current buffer.

                                                         *gitgutter-:GitGutter*
:GitGutter              Update signs for the current buffer.  You shouldn't
                        need to run this.

                                                      *gitgutter-:GitGutterAll*
:GitGutterAll           Update signs for all buffers.  You shouldn't need to
                        run this.


Commands for turning signs on and off (defaults to on):~

                                              *gitgutter-:GitGutterSignsEnable*
:GitGutterSignsEnable   Show signs for the diff.

                                             *gitgutter-:GitGutterSignsDisable*
:GitGutterSignsDisable  Do not show signs for the diff.

                                              *gitgutter-:GitGutterSignsToggle*
:GitGutterSignsToggle   Toggle signs on or off.


Commands for turning line highlighting on and off (defaults to off):~

                                     *gitgutter-:GitGutterLineHighlightsEnable*
:GitGutterLineHighlightsEnable  Turn on line highlighting.

                                    *gitgutter-:GitGutterLineHighlightsDisable*
:GitGutterLineHighlightsDisable Turn off line highlighting.

                                     *gitgutter-:GitGutterLineHighlightsToggle*
:GitGutterLineHighlightsToggle  Turn line highlighting on or off.


Commands for turning line number highlighting on and off (defaults to off):~
NOTE: This feature requires Neovim 0.3.2 or higher.

                                   *gitgutter-:GitGutterLineNrHighlightsEnable*
:GitGutterLineNrHighlightsEnable  Turn on line highlighting.

                                  *gitgutter-:GitGutterLineNrHighlightsDisable*
:GitGutterLineNrHighlightsDisable Turn off line highlighting.

                                   *gitgutter-:GitGutterLineNrHighlightsToggle*
:GitGutterLineNrHighlightsToggle  Turn line highlighting on or off.


Commands for jumping between hunks:~

                                                 *gitgutter-:GitGutterNextHunk*
:GitGutterNextHunk      Jump to the next [count] hunk.

                                                 *gitgutter-:GitGutterPrevHunk*
:GitGutterPrevHunk      Jump to the previous [count] hunk.

                                                 *gitgutter-:GitGutterQuickFix*
:GitGutterQuickFix      Load all hunks into the |quickfix| list.  Note this
                        ignores any unsaved changes in your buffers. The
                        |g:gitgutter_use_location_list| option can be set to
                        populate the location list of the current window
                        instead.  Use |:copen| (or |:lopen|) to open a buffer
                        containing the search results in linked form; or add a
                        custom command like this:
>
                          command! Gqf GitGutterQuickFix | copen
<
                                                 *gitgutter-:GitGutterQuickFixCurrentFile*
:GitGutterQuickFixCurrentFile     Same as :GitGutterQuickFix, but only load hunks for
                                  the file in the focused buffer. This has the same
                                  functionality as :GitGutterQuickFix when the focused
                                  buffer is empty.


Commands for operating on a hunk:~

                                                *gitgutter-:GitGutterStageHunk*
:GitGutterStageHunk     Stage the hunk the cursor is in.  Use a visual selection
                        to stage part of an (additions-only) hunk; or use a
                        range.

                        To stage part of any hunk, first |GitGutterPreviewHunk|
                        it, then move to the preview window, delete the lines
                        you do not want to stage, and |write| or
                        |GitGutterStageHunk|.

                                                 *gitgutter-:GitGutterUndoHunk*
:GitGutterUndoHunk      Undo the hunk the cursor is in.

                                              *gitgutter-:GitGutterPreviewHunk*
:GitGutterPreviewHunk   Preview the hunk the cursor is in.

                        To stage part of the hunk, move to the preview window,
                        delete any lines you do not want to stage, and
                        |GitGutterStageHunk|.

                        To close a non-floating preview window use |:pclose|
                        or |CTRL-W_z| or |CTRL-W_CTRL-Z|; or normal window-
                        closing (|:quit| or |:close| or |CTRL-W_c|) if your cursor
                        is in the preview window.

                        To close a floating window when the cursor is in the
                        original buffer, move the cursor.

                        To close a floating window when the cursor is in the
                        floating window use normal window-closing, or move to
                        the original window with |CTRL-W_p|.  Alternatively set
                        |g:gitgutter_close_preview_on_escape| and use <Esc>.

                        Two functions are available for your own logic:
>
                          gitgutter#hunk#is_preview_window_open()
                          gitgutter#hunk#close_hunk_preview_window()
<

Commands for folds:~

                                                     *gitgutter-:GitGutterFold*
:GitGutterFold          Fold all unchanged lines.  Execute again to undo.


Other commands:~

                                                 *gitgutter-:GitGutterDiffOrig*
:GitGutterDiffOrig      Similar to |:DiffOrig| but shows gitgutter's diff.


===============================================================================
AUTOCOMMANDS                                           *gitgutter-autocommands*

User GitGutter~

After updating a buffer's signs vim-gitgutter fires a |User| |autocmd| with the
event GitGutter.  You can listen for this event, for example:
>
  autocmd User GitGutter call updateMyStatusLine()
<
A dictionary `g:gitgutter_hook_context` is made available during its execution,
which contains an entry `bufnr` that contains the buffer number being updated.

User GitGutterStage~

After staging a hunk or part of a hunk vim-gitgutter fires a |User| |autocmd|
with the event GitGutterStage.  Staging always happens in the current buffer.

===============================================================================
MAPPINGS                                                   *gitgutter-mappings*

You can disable all these mappings with:
>
    let g:gitgutter_map_keys = 0
<

Hunk operations:~

These can be repeated with `.` if you have vim-repeat installed.

                                                         *gitgutter-<Leader>hp*
<Leader>hp              Preview the hunk under the cursor.

                                                         *gitgutter-<Leader>hs*
<Leader>hs              Stage the hunk under the cursor.

                                                         *gitgutter-<Leader>hu*
<Leader>hu              Undo the hunk under the cursor.

You can change these mappings like this:
>
    nmap ghp <Plug>(GitGutterPreviewHunk)
    nmap ghs <Plug>(GitGutterStageHunk)
    nmap ghu <Plug>(GitGutterUndoHunk)
<

Hunk jumping:~

                                                                 *gitgutter-]c*
]c                      Jump to the next [count] hunk.

                                                                 *gitgutter-[c*
[c                      Jump to the previous [count] hunk.

You can change these mappings like this:
>
    nmap [c <Plug>(GitGutterPrevHunk)
    nmap ]c <Plug>(GitGutterNextHunk)
<

Hunk text object:~

                          *gitgutter-ic* *gitgutter-ac* *gitgutter-text-object*
"ic" operates on the current hunk's lines.  "ac" does the same but also includes
trailing empty lines.
>
    omap ic <Plug>(GitGutterTextObjectInnerPending)
    omap ac <Plug>(GitGutterTextObjectOuterPending)
    xmap ic <Plug>(GitGutterTextObjectInnerVisual)
    xmap ac <Plug>(GitGutterTextObjectOuterVisual)
<


===============================================================================
STATUS LINE                                              *gitgutter-statusline*


Call the `GitGutterGetHunkSummary()` function from your status line to get a
list of counts of added, modified, and removed lines in the current buffer.
For example:
>
    " Your vimrc
    function! GitStatus()
      let [a,m,r] = GitGutterGetHunkSummary()
      return printf('+%d ~%d -%d', a, m, r)
    endfunction
    set statusline+=%{GitStatus()}
<


===============================================================================
OPTIONS                                                     *gitgutter-options*

The most important option is 'updatetime' which determines how long (in
milliseconds) the plugin will wait after you stop typing before it updates the
signs.  Vim's default is 4000.  I recommend 100.  Note this also controls how
long vim waits before writing its swap file.

Most important option:~

    'updatetime'

Git:~

    |g:gitgutter_git_executable|
    |g:gitgutter_git_args|
    |g:gitgutter_diff_args|
    |g:gitgutter_diff_relative_to|
    |g:gitgutter_diff_base|

Grep:~

    |g:gitgutter_grep|

Signs:~

    |g:gitgutter_signs|
    |g:gitgutter_highlight_lines|
    |g:gitgutter_highlight_linenrs|
    |g:gitgutter_max_signs|
    |g:gitgutter_sign_priority|
    |g:gitgutter_sign_allow_clobber|
    |g:gitgutter_sign_added|
    |g:gitgutter_sign_modified|
    |g:gitgutter_sign_removed|
    |g:gitgutter_sign_removed_first_line|
    |g:gitgutter_sign_modified_removed|
    |g:gitgutter_set_sign_backgrounds|

Hunk jumping:~

    |g:gitgutter_show_msg_on_hunk_jumping|

Hunk previews:~

    |g:gitgutter_preview_win_floating|
    |g:gitgutter_floating_window_options|
    |g:gitgutter_close_preview_on_escape|

Terminal:~

    |g:gitgutter_terminal_reports_focus|

General:~

    |g:gitgutter_enabled|
    |g:gitgutter_map_keys|
    |g:gitgutter_async|
    |g:gitgutter_log|
    |g:gitgutter_use_location_list|


                                             *g:gitgutter_preview_win_location*
Default: 'bo'

This option determines where the preview window pops up as a result of the
:GitGutterPreviewHunk command. Other plausible values are 'to', 'bel', 'abo'.
See the end of the |opening-window| docs.

                                                   *g:gitgutter_git_executable*
Default: 'git'

This option determines what git binary to use.  Set this if git is not on your
path.

                                                         *g:gitgutter_git_args*
Default: empty

Use this option to pass any extra arguments to git when running git-diff.
For example:
>
    let g:gitgutter_git_args = '--git-dir=""'
<

                                                        *g:gitgutter_diff_args*
Default: empty

Use this option to pass any extra arguments to git-diff.  For example:
>
    let g:gitgutter_diff_args = '-w'
<

                                                 *g:gitgutter_diff_relative_to*
Default: empty

By default buffers are diffed against the index.  Use this option to diff against
the working tree.  For example:
>
    let g:gitgutter_diff_relative_to = 'working_tree'
<

                                                        *g:gitgutter_diff_base*
Default: empty

By default buffers are diffed against the index.  Use this option to diff against
a revision instead.  For example:
>
    let g:gitgutter_diff_base = '<some commit SHA>'
<

If you are looking at a previous version of a file with Fugitive (e.g.
via :0Gclog), gitgutter sets the diff base to the parent of the current revision.

This setting is ignore when the diff is relative to the working tree
(|g:gitgutter_diff_relative_to|).

                                                             *g:gitgutter_grep*
Default: 'grep'

The plugin pipes the output of git-diff into grep to minimise the amount of data
vim has to process.  Set this option if grep is not on your path.

grep must produce plain-text output without any ANSI escape codes or colours.
Use this option to turn off colours if necessary.
>
    let g:gitgutter_grep = 'grep --color=never'
<
If you do not want to use grep at all (perhaps to debug why signs are not
showing), set this option to an empty string:
>
    let g:gitgutter_grep = ''
<

                                                            *g:gitgutter_signs*
Default: 1

Determines whether or not to show signs.

                                                  *g:gitgutter_highlight_lines*
Default: 0

Determines whether or not to show line highlights.

                                                *g:gitgutter_highlight_linenrs*
Default: 0

Determines whether or not to show line number highlights.

                                                        *g:gitgutter_max_signs*
Default: 500 (Vim < 8.1.0614, Neovim < 0.4.0)
          -1 (otherwise)

Sets the maximum number of signs to show in a buffer.  Vim is slow at updating
signs, so to avoid slowing down the GUI the number of signs is capped.  When
the number of changed lines exceeds this value, the plugin removes all signs
and displays a warning message.

When set to -1 the limit is not applied.

                                                   *g:gitgutter_sign_priority*
Default: 10

Sets the |sign-priority| gitgutter assigns to its signs.

                                               *g:gitgutter_sign_allow_clobber*
Default: 0 (Vim < 8.1.0614, Neovim < 0.4.0)
         1 (otherwise)

Determines whether gitgutter preserves non-gitgutter signs. When 1, gitgutter
will not preserve non-gitgutter signs.

                                          *g:gitgutter_sign_added*
                                          *g:gitgutter_sign_modified*
                                          *g:gitgutter_sign_removed*
                                          *g:gitgutter_sign_removed_first_line*
                                          *g:gitgutter_sign_removed_above_and_below*
                                          *g:gitgutter_sign_modified_removed*
Defaults:
>
    let g:gitgutter_sign_added              = '+'
    let g:gitgutter_sign_modified           = '~'
    let g:gitgutter_sign_removed            = '_'
    let g:gitgutter_sign_removed_first_line = '‾'
    let g:gitgutter_sign_removed_above_and_below = '_¯'
    let g:gitgutter_sign_modified_removed   = '~_'
<
You can use unicode characters but not images.  Signs must not take up more than
2 columns.

                                              *g:gitgutter_set_sign_backgrounds*
Default: 0

Only applies to existing GitGutter* highlight groups.  See
|gitgutter-highlights|.

Controls whether to override the signs' background colours to match the
|hl-SignColumn|.

                                             *g:gitgutter_preview_win_floating*
Default: 0 (Vim)
         0 (NeoVim which does not support floating windows)
         1 (NeoVim which does support floating windows)

Whether to use floating/popup windows for hunk previews.  Note that if you use
popup windows on Vim you will not be able to stage partial hunks via the
preview window.

                                          *g:gitgutter_floating_window_options*
Default:
>
    " Vim
    {
        \ 'line': 'cursor+1',
        \ 'col': 'cursor',
        \ 'moved': 'any'
    }

    " Neovim
    {
        \ 'relative': 'cursor',
        \ 'row': 1,
        \ 'col': 0,
        \ 'width': 42,
        \ 'height': &previewheight,
        \ 'style': 'minimal'
    }
<
This dictionary is passed directly to |popup_create()| (Vim) or
|nvim_open_win()| (Neovim).

If you simply want to override one or two of the default values, create a file
in an after/ directory.  For example:
>
    " ~/.vim/after/vim-gitgutter/overrides.vim
    let g:gitgutter_floating_window_options['border'] = 'single'
<

                                          *g:gitgutter_close_preview_on_escape*
Default: 0

Whether pressing <Esc> in a preview window closes it.

                                           *g:gitgutter_terminal_reports_focus*
Default: 1

Normally the plugin uses |FocusGained| to force-update all buffers when Vim
receives focus.  However some terminals do not report focus events and so the
|FocusGained| autocommand never fires.

If this applies to you, either install something like Terminus
(https://github.com/wincent/terminus) to make |FocusGained| work or set this
option to 0.

If you use tmux, try this in your tmux.conf:
>
    set -g focus-events on
<

When this option is 0, the plugin force-updates the buffer on |BufEnter|
(instead of only updating if the buffer's contents has changed since the last
update).

                                                          *g:gitgutter_enabled*
Default: 1

Controls whether or not the plugin is on at startup.

                                                         *g:gitgutter_map_keys*
Default: 1

Controls whether or not the plugin provides mappings.  See |gitgutter-mappings|.

                                                            *g:gitgutter_async*
Default: 1

Controls whether or not diffs are run in the background.  This has no effect if
your Vim does not support background jobs.

                                                              *g:gitgutter_log*
Default: 0

When switched on, the plugin logs to gitgutter.log in the directory where it is
installed.  Additionally it logs channel activity to channel.log.

                                                *g:gitgutter_use_location_list*
Default: 0

When switched on, the :GitGutterQuickFix command populates the location list
of the current window instead of the global quickfix list.

                                         *g:gitgutter_show_msg_on_hunk_jumping*
Default: 1

When switched on, a message like "Hunk 4 of 11" is shown on hunk jumping.


===============================================================================
HIGHLIGHTS                                               *gitgutter-highlights*

To change the signs' colours, specify these highlight groups in your |vimrc|:
>
    highlight GitGutterAdd    guifg=#009900 ctermfg=2
    highlight GitGutterChange guifg=#bbbb00 ctermfg=3
    highlight GitGutterDelete guifg=#ff2222 ctermfg=1
<

See |highlight-guifg| and |highlight-ctermfg| for the values you can use.

If you do not like the signs' background colours and you do not want to update
the GitGutter* highlight groups yourself, you can get the plugin to do it
|g:gitgutter_set_sign_backgrounds|.

To change the line highlights, set up the following highlight groups in your
colorscheme or |vimrc|:
>
    GitGutterAddLine          " default: links to DiffAdd
    GitGutterChangeLine       " default: links to DiffChange
    GitGutterDeleteLine       " default: links to DiffDelete
    GitGutterChangeDeleteLine " default: links to GitGutterChangeLine
<

For example, to use |hl-DiffText| instead of |hl-DiffChange|:
>
    highlight link GitGutterChangeLine DiffText
<
To change the line number highlights, set up the following highlight groups in
your colorscheme or |vimrc|:
>
    GitGutterAddLineNr          " default: links to CursorLineNr
    GitGutterChangeLineNr       " default: links to CursorLineNr
    GitGutterDeleteLineNr       " default: links to CursorLineNr
    GitGutterChangeDeleteLineNr " default: links to GitGutterChangeLineNr
<
For example, to use |hl-Underlined| instead of |hl-CursorLineNr|:
>
    highlight link GitGutterChangeLineNr Underlined
<
To change the diff syntax colours used in the preview window, set up the diff*
highlight groups in your colorscheme or |vimrc|:
>
    diffAdded   " if not set: use GitGutterAdd's foreground colour
    diffChanged " if not set: use GitGutterChange's foreground colour
    diffRemoved " if not set: use GitGutterDelete's foreground colour
<
Note the diff* highlight groups are used in any buffer whose 'syntax' is
"diff".

To change the intra-line diff highlights used in the preview window, set up
the following highlight groups in your colorscheme or |vimrc|:
>
    GitGutterAddIntraLine    " default: gui=reverse cterm=reverse
    GitGutterDeleteIntraLine " default: gui=reverse cterm=reverse
<
For example, to use |hl-DiffAdd| for intra-line added regions:
>
    highlight link GitGutterAddIntraLine DiffAdd
<


===============================================================================
FAQ                                                             *gitgutter-faq*

a. How do I turn off realtime updates?

  Add this to your vim configuration in an |after-directory|:
>
    autocmd! gitgutter CursorHold,CursorHoldI
<

b. I turned off realtime updates, how can I have signs updated when I save a
   file?

  If you really want to update the signs when you save a file, add this to your
  |vimrc|:
>
    autocmd BufWritePost * GitGutter
<

c. Why can't I unstage staged changes?

  This plugin is for showing changes between the working tree and the index
  (and staging/undoing those changes). Unstaging a staged hunk would require
  showing changes between the index and HEAD, which is out of scope.

d. Why are the colours in the sign column weird?

  Your colorscheme is configuring the |hl-SignColumn| highlight group weirdly.
  Here are two ways you could change the colours:
>
    highlight! link SignColumn LineNr
    highlight SignColumn guibg=whatever ctermbg=whatever
<

e. What happens if I also use another plugin which uses signs (e.g. Syntastic)?

  Vim only allows one sign per line.  Vim-gitgutter will not interfere with
  signs it did not add.


===============================================================================
TROUBLESHOOTING                                     *gitgutter-troubleshooting*

When no signs are showing at all:~

1. Try bypassing grep with:
>
    let g:gitgutter_grep = ''
<
  If it works, the problem is grep outputting ANSI escape codes.  Use this
  option to pass arguments to grep to turn off the escape codes.

2. Verify git is on your path:
>
    :echo system('git --version')
<

3. Verify your git config is compatible with the version of git return by the
   command above.

4. Verify your Vim supports signs.  The following should give 1:
>
    :echo has('signs')
<

5. Check whether the plugin thinks git knows about your file:
>
    :echo getbufvar('','gitgutter').path
<
  If the result is -2, the plugin thinks your file is not tracked by git.

6. Check whether the signs have been placed:
>
    :sign place group=gitgutter
<
  If you see a list of signs, this is a colorscheme / highlight problem.
  Compare these two highlight values:
>
    :highlight GitGutterAdd
    :highlight SignColumn
<
  If no signs are listed, the call to git-diff is probably failing.  Turn on
  logging by adding the following to your vimrc, restart, reproduce the problem,
  and examing the gitgutter.log file in the plugin's directory.
>
    let g:gitgutter_log = 1
<

When the whole file is marked as added:~

If you use zsh, and you set "CDPATH", make sure "CDPATH" does not include the
current directory.


When signs take a few seconds to appear:~

Try reducing 'updatetime':
>
    set updatetime=100
<

Note this also controls how long vim waits before writing its swap file.


When signs don't update after focusing Vim:~

Your terminal probably isn't reporting focus events.  Either try installing
Terminus (https://github.com/wincent/terminus) or set:
>
    let g:gitgutter_terminal_reports_focus = 0
<

  vim:tw=78:et:ft=help:norl:
./plugin/gitgutter.vim	[[[1
321
scriptencoding utf-8

if exists('g:loaded_gitgutter') || !has('signs') || &cp
  finish
endif
let g:loaded_gitgutter = 1

" Initialisation {{{

if v:version < 703 || (v:version == 703 && !has("patch105"))
  call gitgutter#utility#warn('Requires Vim 7.3.105')
  finish
endif

let s:nomodeline = (v:version > 703 || (v:version == 703 && has('patch442'))) ? '<nomodeline>' : ''

function! s:obsolete(var)
  if exists(a:var)
    call gitgutter#utility#warn(a:var.' is obsolete and has no effect.')
  endif
endfunction


let g:gitgutter_preview_win_location = get(g:, 'gitgutter_preview_win_location', 'bo')
if exists('*nvim_open_win')
  let g:gitgutter_preview_win_floating = get(g:, 'gitgutter_preview_win_floating', 1)
  let g:gitgutter_floating_window_options = get(g:, 'gitgutter_floating_window_options', {
        \ 'relative': 'cursor',
        \ 'row': 1,
        \ 'col': 0,
        \ 'width': 42,
        \ 'height': &previewheight,
        \ 'style': 'minimal'
        \ })
else
  let default = exists('&previewpopup') ? !empty(&previewpopup) : 0
  let g:gitgutter_preview_win_floating = get(g:, 'gitgutter_preview_win_floating', default)
  let g:gitgutter_floating_window_options = get(g:, 'gitgutter_floating_window_options', {
        \ 'line': 'cursor+1',
        \ 'col': 'cursor',
        \ 'moved': 'any'
        \ })
endif
let g:gitgutter_enabled = get(g:, 'gitgutter_enabled', 1)
if exists('*sign_unplace')
  let g:gitgutter_max_signs = get(g:, 'gitgutter_max_signs', -1)
else
  let g:gitgutter_max_signs = get(g:, 'gitgutter_max_signs', 500)
endif
let g:gitgutter_signs             = get(g:, 'gitgutter_signs', 1)
let g:gitgutter_highlight_lines   = get(g:, 'gitgutter_highlight_lines', 0)
let g:gitgutter_highlight_linenrs = get(g:, 'gitgutter_highlight_linenrs', 0)
let g:gitgutter_sign_priority     = get(g:, 'gitgutter_sign_priority', 10)
" Nvim 0.4.0 has an expanding sign column
" The sign_place() function supports sign priority.
if (has('nvim-0.4.0') || exists('*sign_place')) && !exists('g:gitgutter_sign_allow_clobber')
  let g:gitgutter_sign_allow_clobber = 1
endif
let g:gitgutter_sign_allow_clobber   = get(g:, 'gitgutter_sign_allow_clobber', 0)
let g:gitgutter_set_sign_backgrounds = get(g:, 'gitgutter_set_sign_backgrounds', 0)
let g:gitgutter_sign_added           = get(g:, 'gitgutter_sign_added', '+')
let g:gitgutter_sign_modified        = get(g:, 'gitgutter_sign_modified', '~')
let g:gitgutter_sign_removed         = get(g:, 'gitgutter_sign_removed', '_')

if gitgutter#utility#supports_overscore_sign()
  let g:gitgutter_sign_removed_first_line = get(g:, 'gitgutter_sign_removed_first_line', '‾')
else
  let g:gitgutter_sign_removed_first_line = get(g:, 'gitgutter_sign_removed_first_line', '_^')
endif

let g:gitgutter_sign_removed_above_and_below = get(g:, 'gitgutter_sign_removed_above_and_below', '_¯')
let g:gitgutter_sign_modified_removed        = get(g:, 'gitgutter_sign_modified_removed', '~_')
let g:gitgutter_git_args                     = get(g:, 'gitgutter_git_args', '')
let g:gitgutter_diff_relative_to             = get(g:, 'gitgutter_diff_relative_to', 'index')
let g:gitgutter_diff_args                    = get(g:, 'gitgutter_diff_args', '')
let g:gitgutter_diff_base                    = get(g:, 'gitgutter_diff_base', '')
let g:gitgutter_map_keys                     = get(g:, 'gitgutter_map_keys', 1)
let g:gitgutter_terminal_reports_focus       = get(g:, 'gitgutter_terminal_reports_focus', 1)
let g:gitgutter_async                        = get(g:, 'gitgutter_async', 1)
let g:gitgutter_log                          = get(g:, 'gitgutter_log', 0)
let g:gitgutter_use_location_list            = get(g:, 'gitgutter_use_location_list', 0)
let g:gitgutter_close_preview_on_escape      = get(g:, 'gitgutter_close_preview_on_escape', 0)
let g:gitgutter_show_msg_on_hunk_jumping     = get(g:, 'gitgutter_show_msg_on_hunk_jumping', 1)

let g:gitgutter_git_executable = get(g:, 'gitgutter_git_executable', 'git')
if !executable(g:gitgutter_git_executable)
  if g:gitgutter_enabled
    call gitgutter#utility#warn('Cannot find git. Please set g:gitgutter_git_executable.')
  endif
  finish
endif

let default_grep = 'grep'
let g:gitgutter_grep = get(g:, 'gitgutter_grep', default_grep)
if !empty(g:gitgutter_grep)
  if executable(split(g:gitgutter_grep)[0])
    if $GREP_OPTIONS =~# '--color=always'
      let g:gitgutter_grep .= ' --color=never'
    endif
  else
    if g:gitgutter_grep !=# default_grep
      call gitgutter#utility#warn('Cannot find '.g:gitgutter_grep.'. Please check g:gitgutter_grep.')
    endif
    let g:gitgutter_grep = ''
  endif
endif

call gitgutter#highlight#define_highlights()
call gitgutter#highlight#define_signs()

" Prevent infinite loop where:
" - executing a job in the foreground launches a new window which takes the focus;
" - when the job finishes, focus returns to gvim;
" - the FocusGained event triggers a new job (see below).
if gitgutter#utility#windows() && !(g:gitgutter_async && gitgutter#async#available())
  set noshelltemp
endif

" }}}

" Primary functions {{{

command! -bar GitGutterAll call gitgutter#all(1)
command! -bar GitGutter    call gitgutter#process_buffer(bufnr(''), 1)

command! -bar GitGutterDisable call gitgutter#disable()
command! -bar GitGutterEnable  call gitgutter#enable()
command! -bar GitGutterToggle  call gitgutter#toggle()

command! -bar GitGutterBufferDisable call gitgutter#buffer_disable()
command! -bar GitGutterBufferEnable  call gitgutter#buffer_enable()
command! -bar GitGutterBufferToggle  call gitgutter#buffer_toggle()

command! -bar GitGutterQuickFix call gitgutter#quickfix(0)
command! -bar GitGutterQuickFixCurrentFile call gitgutter#quickfix(1)

command! -bar GitGutterDiffOrig call gitgutter#difforig()

" }}}

" Line highlights {{{

command! -bar GitGutterLineHighlightsDisable call gitgutter#highlight#line_disable()
command! -bar GitGutterLineHighlightsEnable  call gitgutter#highlight#line_enable()
command! -bar GitGutterLineHighlightsToggle  call gitgutter#highlight#line_toggle()

" }}}

" 'number' column highlights {{{
command! -bar GitGutterLineNrHighlightsDisable call gitgutter#highlight#linenr_disable()
command! -bar GitGutterLineNrHighlightsEnable  call gitgutter#highlight#linenr_enable()
command! -bar GitGutterLineNrHighlightsToggle  call gitgutter#highlight#linenr_toggle()
" }}}

" Signs {{{

command! -bar GitGutterSignsEnable  call gitgutter#sign#enable()
command! -bar GitGutterSignsDisable call gitgutter#sign#disable()
command! -bar GitGutterSignsToggle  call gitgutter#sign#toggle()

" }}}

" Hunks {{{

command! -bar -count=1 GitGutterNextHunk call gitgutter#hunk#next_hunk(<count>)
command! -bar -count=1 GitGutterPrevHunk call gitgutter#hunk#prev_hunk(<count>)

command! -bar -range=% GitGutterStageHunk call gitgutter#hunk#stage(<line1>,<line2>)
command! -bar GitGutterUndoHunk    call gitgutter#hunk#undo()
command! -bar GitGutterPreviewHunk call gitgutter#hunk#preview()

" Hunk text object
onoremap <silent> <Plug>(GitGutterTextObjectInnerPending) :<C-U>call gitgutter#hunk#text_object(1)<CR>
onoremap <silent> <Plug>(GitGutterTextObjectOuterPending) :<C-U>call gitgutter#hunk#text_object(0)<CR>
xnoremap <silent> <Plug>(GitGutterTextObjectInnerVisual)  :<C-U>call gitgutter#hunk#text_object(1)<CR>
xnoremap <silent> <Plug>(GitGutterTextObjectOuterVisual)  :<C-U>call gitgutter#hunk#text_object(0)<CR>


" Returns the git-diff hunks for the file or an empty list if there
" aren't any hunks.
"
" The return value is a list of lists.  There is one inner list per hunk.
"
"   [
"     [from_line, from_count, to_line, to_count],
"     [from_line, from_count, to_line, to_count],
"     ...
"   ]
"
" where:
"
" `from`  - refers to the staged file
" `to`    - refers to the working tree's file
" `line`  - refers to the line number where the change starts
" `count` - refers to the number of lines the change covers
function! GitGutterGetHunks()
  let bufnr = bufnr('')
  return gitgutter#utility#is_active(bufnr) ? gitgutter#hunk#hunks(bufnr) : []
endfunction

" Returns an array that contains a summary of the hunk status for the current
" window.  The format is [ added, modified, removed ], where each value
" represents the number of lines added/modified/removed respectively.
function! GitGutterGetHunkSummary()
  return gitgutter#hunk#summary(winbufnr(0))
endfunction

" }}}

" Folds {{{

command! -bar GitGutterFold call gitgutter#fold#toggle()

" }}}

command! -bar GitGutterDebug call gitgutter#debug#debug()

" Maps {{{

nnoremap <silent> <expr> <Plug>(GitGutterNextHunk) &diff ? ']c' : ":\<C-U>execute v:count1 . 'GitGutterNextHunk'\<CR>"
nnoremap <silent> <expr> <Plug>GitGutterNextHunk   &diff ? ']c' : ":\<C-U>call gitgutter#utility#warn('Please change your map \<lt>Plug>GitGutterNextHunk to \<lt>Plug>(GitGutterNextHunk)')\<CR>"
nnoremap <silent> <expr> <Plug>(GitGutterPrevHunk) &diff ? '[c' : ":\<C-U>execute v:count1 . 'GitGutterPrevHunk'\<CR>"
nnoremap <silent> <expr> <Plug>GitGutterPrevHunk   &diff ? '[c' : ":\<C-U>call gitgutter#utility#warn('Please change your map \<lt>Plug>GitGutterPrevHunk to \<lt>Plug>(GitGutterPrevHunk)')\<CR>"

xnoremap <silent> <Plug>(GitGutterStageHunk)   :GitGutterStageHunk<CR>
xnoremap <silent> <Plug>GitGutterStageHunk     :call gitgutter#utility#warn('Please change your map <lt>Plug>GitGutterStageHunk to <lt>Plug>(GitGutterStageHunk)')<CR>
nnoremap <silent> <Plug>(GitGutterStageHunk)   :GitGutterStageHunk<CR>
nnoremap <silent> <Plug>GitGutterStageHunk     :call gitgutter#utility#warn('Please change your map <lt>Plug>GitGutterStageHunk to <lt>Plug>(GitGutterStageHunk)')<CR>
nnoremap <silent> <Plug>(GitGutterUndoHunk)    :GitGutterUndoHunk<CR>
nnoremap <silent> <Plug>GitGutterUndoHunk      :call gitgutter#utility#warn('Please change your map <lt>Plug>GitGutterUndoHunk to <lt>Plug>(GitGutterUndoHunk)')<CR>
nnoremap <silent> <Plug>(GitGutterPreviewHunk) :GitGutterPreviewHunk<CR>
nnoremap <silent> <Plug>GitGutterPreviewHunk   :call gitgutter#utility#warn('Please change your map <lt>Plug>GitGutterPreviewHunk to <lt>Plug>(GitGutterPreviewHunk)')<CR>

" }}}

function! s:on_bufenter()
  call gitgutter#setup_maps()

  " To keep vim's start-up fast, do not process the buffer when vim is starting.
  " Instead process it a short time later.  Normally we would rely on our
  " CursorHold autocommand to handle this but it turns out CursorHold is not
  " guaranteed to fire if the user has not typed anything yet; so set up a
  " timer instead.  The disadvantage is that if CursorHold does fire, the
  " plugin will do a round of unnecessary work; but since there will not have
  " been any changes to the buffer since the first round, the second round
  " will be cheap.
  if has('vim_starting') && !$VIM_GITGUTTER_TEST
    if exists('*timer_start') && has('lambda')
      call s:next_tick("call gitgutter#process_buffer(+".bufnr('').", 0)")
    else
      call gitgutter#process_buffer(bufnr(''), 0)
    endif
    return
  endif

  if exists('t:gitgutter_didtabenter') && t:gitgutter_didtabenter
    let t:gitgutter_didtabenter = 0
    call gitgutter#all(!g:gitgutter_terminal_reports_focus)
  else
    call gitgutter#process_buffer(bufnr(''), !g:gitgutter_terminal_reports_focus)
  endif
endfunction

function! s:next_tick(cmd)
  call timer_start(1, {-> execute(a:cmd)})
endfunction

" Autocommands {{{

augroup gitgutter
  autocmd!

  autocmd TabEnter * let t:gitgutter_didtabenter = 1

  autocmd BufEnter * call s:on_bufenter()

  " Ensure Vim is always checking for CursorMoved to avoid CursorMoved
  " being fired at the wrong time in floating preview window on Neovim.
  " See vim/vim#2053.
  autocmd CursorMoved * execute ''

  autocmd CursorHold,CursorHoldI * call gitgutter#process_buffer(bufnr(''), 0)
  if exists('*timer_start') && has('lambda')
    autocmd FileChangedShellPost * call s:next_tick("call gitgutter#process_buffer(+".expand('<abuf>').", 1)")
  else
    autocmd FileChangedShellPost * call gitgutter#process_buffer(+expand('<abuf>'), 1)
  endif

  " Ensure that all buffers are processed when opening vim with multiple files, e.g.:
  "
  "   vim -o file1 file2
  autocmd VimEnter * if winnr() != winnr('$') | call gitgutter#all(0) | endif

  autocmd ShellCmdPost * call gitgutter#all(1)
  autocmd BufLeave term://* call gitgutter#all(1)

  autocmd User FugitiveChanged call gitgutter#all(1)

  " Handle all buffers when focus is gained, but only after it was lost.
  " FocusGained gets triggered on startup with Neovim at least already.
  " Therefore this tracks also if it was lost before.
  let s:focus_was_lost = 0
  autocmd FocusGained * if s:focus_was_lost | let s:focus_was_lost = 0 | call gitgutter#all(1) | endif
  autocmd FocusLost * let s:focus_was_lost = 1

  if exists('##VimResume')
    autocmd VimResume * call gitgutter#all(1)
  endif

  autocmd ColorScheme * call gitgutter#highlight#define_highlights()

  autocmd BufFilePre  * let b:gitgutter_was_enabled = gitgutter#utility#getbufvar(expand('<abuf>'), 'enabled') | GitGutterBufferDisable
  autocmd BufFilePost * if b:gitgutter_was_enabled | GitGutterBufferEnable | endif | unlet b:gitgutter_was_enabled

  autocmd QuickFixCmdPre  *vimgrep* let b:gitgutter_was_enabled = gitgutter#utility#getbufvar(expand('<abuf>'), 'enabled') | GitGutterBufferDisable
  autocmd QuickFixCmdPost *vimgrep* if b:gitgutter_was_enabled | GitGutterBufferEnable | endif | unlet b:gitgutter_was_enabled
augroup END

" }}}

" vim:set et sw=2 fdm=marker:
./screenshot.png	[[[1
1250
PNG

   
  
¹iCCPICC Profile  HTÉÇçûÒCBK@@J¨¡Ò«ÐC¤J	ETTD+"" ,èªET,XXìu,
êºX°æ}À#ì¾wÞ{çýÏ¹ß¹¹sçÎsî éK(LÈd"¼iqñ	4\?PöÎbððhjü»>ÝC¢Ý¶ÏõïÿÿW©p¸b6 P8ÂI1;áSIÙBQ ¨RÄo%ç©"¤@»Æ9e¥ã4É'b¢"| @ãÀX,Q
 $*â§e³S<${­¾ aÂlIû9Î·6MúK¿åLçd±Rä<¹	á}ùba:kÙÿyÿ[é©5L#ñDãë!gö -3XÎ¤¹aSÌçLÖ4Î<I`ô³Å>	SÌaùËç¦Ï

bÀ¡ØYÜ¥YãÅûd
ø)¼,yU\SÀ¶E³µ¶q`üN^áoÒTö­Û\éÍ2¬iÚÇ\Àñ eÓ>z Jù \ÍaKDÙ>ôø M )°¶À¸/à@ñ``È "òÀjPÁ6°Tj°GÁ	ÐÚÀpÜ ·À]ðHÁ x
A"CHÒ!Èr< ?(â¡D(@(ZC%PTÕAÇ¡3ÐèÔ=ú !è=ô
ëÀ&ðlØfÀÁp¼NÀ¹p¼.ká#p|¾ß¥ðkxP
(u>ÊåòA¡PÉ(j%ªUªE5 ZQ¨Û()ê
bHñ¡°)k)û))T,NeRS©ÅÔ£Ônê°ª½ZÚRµJµ³jRuº:S=]}«ú	õ{êßfèÌ`ÌàÎØ8£aFïÏ35¼4¸Ew5¾iÒ4ý4Ó4·k6k>ÕBkkÍÓÊÑÚ«uYëÍLêL·ìE3OÌ|¤
±ZcÕlõv¶ÑìÙÛgwÎþaí`n½ßú±ªMÍV÷¶æ¶lÛJÛ;vd;»Uv-vïì-ì¹ö{í8PBÖ;t8|wtr96899%:U9Ýw¦:;or¾êqñvYåÒæòÕÕÑ5ËõënninÝçÐçpçìÓïnàÎr¯qzÐ<=~òzê{²<k={zq¼x½d1RGo½­½EÞ§½?û¸ú¬ð9ïò
®~b"
i
ÆÐÊ¤«W¬ÈÈ?´¸:mõ¯k¬×¬ù¸6vmkNA~Aÿºuõ¢ÂûëÝÖWo@oàoèÞh·q÷ÆE¢ëÅÖÅeÅcØ®o¶Ù\¾Y¶%yK÷VÇ­{·a·	¶ÝÛî¹ýPJInIÿÐM¥´Ò¢Ò;ï¼Vf_V½¸K²KZRÞ²Ûh÷¶Ýc¼»ÞUÚU«>ïáìéÝëµ·¡Z§º¸úÛOüÔÔ4ÕÔíÃîËÞ÷bÌþÎ®; u øÀ÷ÒC.Õ9ÕÕÖ>¼µ®ÔYpäÖQß£-
1¾ãb&^ ("XíìäöOíl's)ÖÓÉÞg@@l,@&
   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <rdf:Description rdf:about=""
            xmlns:exif="http://ns.adobe.com/exif/1.0/">
         <exif:PixelXDimension>1766</exif:PixelXDimension>
         <exif:PixelYDimension>1394</exif:PixelYDimension>
      </rdf:Description>
   </rdf:RDF>
</x:xmpmeta>
}É   iDOT         ¹   (  ¹  ¹ èûäú  @ IDATxì½	¼åWQï»N$yN#d
22È   â
.yiíÓÜ?ó­ÜwXÞü-éRéõoßuëõ·ïÃµôÅöÛìÖÊY69oûkû+]Qªõdûkûmyûû|½à½Èº"["¼Üóö?ö?Ò¥Ò'ûûl+ÈÛÿØÿØÿàUíñ\òÙVÈHN¹-ç,~üÌ
.=X(/ãÛåÁ£ÚHÑ!¯:á¨r®3ÿÜ,ÿ¦Y?å­^¶?;ÊløLºör®³ÿèýýOw}äµ¢¼ý¯ý¯ýïÀ°. ûß&>%ÙÕQÎuö¿½±ÿµÿí®¼V·ÿµÿµÿøÖ`ÿÛäÀ§d"¡:Ê¹Îþw 7«Éÿr¿%pJ@¦¶®ÉÆYyäØd¸1Ú eú
Wx´ec¦~j'
¸ù
æÅ§"§Õå?Ð/ÔDºdýóú³ýiÓö·ÉÁþÇþ×ñÇ`-ÈWæÔñW[#3´ªwüéøuãøÛñ·â+¬l©?üüáçæ7µ>;þvüÝÖkA¾"§¿³FôÑ´eð©úxþïÁh³,% ¯ÕÊaÂD¯ÙÇi¨]ÚÊH¨~@·x§W3y@tÉÿ¾r|ZþMO¬¬xý5»&½°ýiºaûkÿcÿ»¯Tü*eÇ?º~Tú¡Ôñã/ìâlG¤Ô9þhqüáøÃñ¬ÄÀ¿ªF~²ã|d_%¥²±jÏrTu¶¿M2¶¿¶¿¶¿²û¢ÙÊ¶¿ùÈ¾fùHfN-K`$À"ÓBy/
h£4/JáªÑR]TõiÏõ*«eó+#äXþM|Zÿ,¤ZS^¶?²¥Ò¼^ÈçzÕG¸<`ûÓäÀ§íOtCúbûcû#["Èë|®WY}qÈ¶?M|Úþ4YH7¤/¶?¶?²%Ò¼^ÈçzÕG¸<`ûÓäÀ§íOtCúbûcû#["Èë|®WY}qÈ¶?M|Úþ4YH7¤/¶?¶?²%Ò¼^ÈçzÕG¸<0Îþ4ZÀÔÐÂ"Õâ"¯oN¨]Î:Õª.²µ^Y ãæ|·ù#Á&CË rè
 §GÖ¿&'¯¿¾ ;èÌ8½±ýAJ¶?èíoUþz±ýmò°ÿlGííÑÇ?d/±¿:þnqrè®
 ·Àá²ÿÈÙÙÿØÿ[7¶¿¬¦#KeZÀ>À8ÉÉ$£E^írfjS9;~ð)ÓF?RÊètùªo½ýÄPÙü$gRdcù[ÿÐéÅ¨u6ª>ºVP»Ö) ²××:"=³ý±ýÅ6 ¤ÒÙÊª^TÕº\O ~²7¤Êô±þ
yH¯H¥k#eÕ	/ª¬¹ @r¾*#Këß@§ôTº&9RVð¢Êú×2$7é) 2²´þ
yH¯H¥k#eÕ	/ª¬¹ @r¾*#Këß@§ôTº&9RVð¢Êú×2$7é) 2²´þ
yH¯H¥k#eÕ	/ª¬¹ @r¾*#ËAÿê¤ü±rb­ÜÌYQ¬:þ°(P;m'çÁÓ=%
Mð%[­UÊÐõ uú¬6þmtþ\6	 xå òæÒBÕÂgA×TU(³y@£¯ðsÿÜGõzÀ.¶ú­ÆÁØd4NÆÃø5¥QUr¿ðsÉª§#×üÍ¿ÉZr<%w¥Upñaù[ÿ¼þöWë%¯Ûæ°í¯ýýoó¢?9þtüoôó?x¦R¤xRÏ]Jçðó?ýüéçO?ê[ö2ÛOµa3UïçO?.æó§ü²âxéeµuõ»Ð®~è/}sò¢¡4ª*PÎöOtrÿÜGõèÿbòo£ñçKhXZ	°`XHòZ0ZÔi±jÑ¯©Fy]ôÉôÀÏ Z¤¿ØüWùðÇÈ¸hÝùCº<dÀ·bÔ?²}0ÿñPFÝÉyZþMZÖ¿¶®Xoè×íí¯ýýoÓ|¥ãÇ_?+~ncûôó?;K/üü5|ÿCëÇÏ~þöþC³ÞðþvQ>Äû/«{ÿûa>ñ~O÷YtºëÚ´é¢O'd7Á?¼
®ÚÄc1øÙ9ü9XÔá_¿ÚdP&ñ¯»ÑAñ3?ñÉóaóWù7Ý°ü¡O²qZZ/Ö¿&ÖÖ£×íí¯ýýo³?Â9 ±íK6?o:þvüôó¿üü¡·Hýü=xÞF7°~þn1¦÷¼ÿÀz8?Ñy.ì")@9pÈ¡zì¸¤²§¹ÿ¤øSüdTÞþ1ÃbIcX	°x¤Øyá@ÆÂÑBÐSª¾ê.@»îQ¦-zÔ¦hÐOtÔWøÂ_¥,dÑR ÚEvÑ!/~â%Ñ´áâi-r´ü­^¬fl=%µýmºaÿ3:þ¾Øÿ6:þpü'[êøÓñ'ö püíøÛñw[ØGÇß¿µc&tÃñ·ãoô Ð3i¶è?üüÑsÒlK7Ã:B>y
O}ÔMWüÄGeÉ_õà()õ»ÒÝ¤Ø,P9·I±QXµ´ ¥Èê«²îIÆ§vòh?øàÁKt.æ	_Íwøk×4óg~|³d1ø¾ÜùOÖ?Ëßúçõgûcû;×7Ëï*]*ÿkûkûkûkûkûkû
B§ïaLd³,-êÈ§ hñ×¢Q^eRõ'Í0?õ~ðÇ_úôU<hæ|^ôÐÎ  Ë_myþ8)Yö¥ämÀüzbù[ÿ¼þ]°ý±ýµÿ<\°ÓÿÛÿ6;ãøÃñbaÇ_¿9þB?:þtü©Í}Çß~þðóWóy-,tÿy±?¹'\ÄîóÙÿÆ_ö>H-ÿ×³d6nÿä	WYyé_Eè}hþ]}ÕN?yp»üÕîta:	 `,F)+JrªÙWYiVvp¤°ä)3ôÈçvÑ ö.ájà«R-~ñé.(ñd~ÊÓ
Èämm¥Ò!RûûÙìýý¾D`ÿkÿÈFÈw ?n Ç_ûî?áKÐ¥?kFkÇñ×À¶°8þ8ãt\>t%×?¼ò&4¶VÔ'·Ë;Îÿö0ûOhCG¸ä
^®ÏåhêãyÑCGü©çü¹îÌ<Wæ×-GóªäÏ+1óôç:ôg9ôÏò·ü%¯ÿ¹öÝë¯ùÜ¥ô¶?Z}¶ÿ¶?¶?9¾¶ýµýåÏþgé?íí%û_û_ûßÁ>ãÇ?VgüÏÂ_iï½»ßÞ-/\òÆ?ô_lþCÊXe(O:ÿ`,@ÑrÑU^4(SÊªE exêsñU*¼Ú¡÷Ñå?hªe®|@Å
]þ¹?zôQª9µí³Ë|ø.&Ícµñ×ÜIæ|(Í9Kä=ßëÿ¡cÿ¼þmÿlÿ1¡ýýýýß¡òücÿoÿoÿoÿïý,¡÷?ÿ:þÿòö¹ëiöWëþ/sXÿ§}mRÖöïµï>ùçþê7lÿ_rWªûB9ª¿Ò¨Z²óh:cíT»È
óRÞn
@Jß-£ChªLh
!P=e)êT¦M}³2f:ÔÒJ)3åé£+²6@ü+:´QG?ñ§|õÇ_tDCüEO42ÿ<x©¯øÓw)ùÃOãÇq=ÿiùKvæ?Zÿu¥CÓèå?þ[ÿ¼þmÿlÿíìÇrÜoÈ~|ö½ãâ¿Üû¢¾«-þc\õßúoý÷ú·ý<7`³
ÿ]q©u¿xhÜ´â¯±Ð'}iù7ì¿Pþ¼çË_}ïþòg.í´ó_lþ+=óG¦×ßÿ¼cýYÿòÆþ/ý³ü-$`ÿ×bÖ×ßäøÓögqâOÛ_Û_Û_ûû_û_Çÿ-îpüåø¸hÜþ§ãOÇóÙÂ¦ ôÑåå¿á»XüÙÏÏüóþ?kG0ßù«ïþ¬?Ñ`Ãøk¬uþï·æ}P¤ÞA1Î$7Ñ\I©#U½ò
 T( Ò ]ÜIü'þ,HåEÃ#¾JéG;x/æAúBs¾üÕW|j^[ç°qã/Z1¼¾òü3½¥à?Iþæ?Ð;Ë°ÐýÅÐëß`Ý#OÀë`ÿmldwÊgÚþ4ÝØøÃö×öW~G©ýý~Wì®RÛßf3ììXö¿ÍVðìãuÙ	êÈÏwÿÅög®<m<¤W¶¿¶¿¶¿Ãý¶Xëd©ì¯lýBý÷n¡Ïð^ÈúG.y¼ÈZÀ|¦á/>à¾òâI½@üU2:è@?Ø&¦yé¦ég%cÎº±´Óä¾Rè7§(ÁøDv¨~:ÐÎ2ÏÏ|¡KY|èAõàÒ|RhÒ>?8ÐSÑS½hæ´Ë?Ëþ¢5
$jR1AÁÁ7]©Ú¢ªâ:`S?ð¸áÈ6.¯ef¥}ÑQ_á©º¢Ù©øCs}\¤ôå¢<¿^øG·±ü·Æ§9ÀzÓòÔ:/~¶s¾üÉZþð±/7ñ6Ëßúçõgû³¼ößö×þO:`ûkûkûkû»Ï²=ÿÿÛÿØÿØÿØÿØÿ´}Êi÷÷gÿÏþ÷ÐzþÓÞ<{êÒ/éÀRú_öÝµ®#[Ï
æË~ ãÔI'é?¼§Ùÿ×ü»çÑ½¿¿O~µ!cÆ÷ÿUwþÀ<h>©äÙJÅÔùsD·O&}0óBiòMËNæ>LQh~dû¸Ô´©?
Ò¥ÑåÇ"Tÿn_èC<RE4£ªòVÿQüÁÓü3ñSÿ\ÖüñÚé«þÂU)m¤óáè}ú&t# ]þp?ã0ËßúÇÊòú³ýiz`û;×ÿÙÿlkÄþ·ÉcãÇ¿:þtüÙâÇ_¿ãOÇè @äøÛñ·|?üü5íó§bë¬;²)Ýýwê7Éÿw!ÏðÐþ÷4ÏÃ»ÆÍ_m¤@×vR7?ãvþâçèªmø?²µé8þÐ>h@Â9X&oºòÜLòk®WóW>·GAP~òR4áHyH¥4(eádºÔåzáFu?ÀÈíä3Oò\§ËzN'óæ~_ê¹ h,Ý~´ÏgþÓòÏ<s~ÿqóÎ´ü»æ<?sïÎ9ù#ó«ÿ`
EvRvQ¨MJØ­Ò¨_ø@'ó×¡/ýÄz^EÁ©¨'ê5VRh £øÎ(þÐÒiøÃOsÄ_òêò×k¯ÿ´óÿqó§Mc¿Ë¹0ö¥âOóoòE:×¿õo`sý£s^^£üí¿ýý¿ãû_û_ââSÇó{þCf}þ³ÿµÿµÿµÿµÿµÿµÿuü±Üñvg)ý´ºÿÄÏkß±riÿ?²¶â/x.uaü©oøºÓðøã/£øó Á(k,í×CP¿<ÚT&ÖÐ>n¨næ¤¤Ù#}òMÕÍ'=úJiÔ®~ÂÉøÊÃþ(¿AËb46ò¢£:ÑW|Å:µ«ÚÄ|åÁÇ ^äEGu¢¯¶Iü»ó§ÿ(þK1ÿ.ÿqóÍa¾ó7ÿÅ¹ÿÿ¾ö5\ ­[ë³ÍY_GNÙþyý#éì¿dhû7ÞÿzýyýeóZkÄ]úêHÙñnüåõgÿ'Û¢}A/ ép²¾(ý_{îñúßó§tÈþßþßög°¯dûW±ÿ±ÿìóä7çÑÇ?¤çôØßøGÏsóÕÿùðwÚø>Íþ×|ø##æG,/å£zìúèOP´çÐqå¤Däà{ÖÍCQ1¤ 7KíºaOÊØíC6õn6inW . þ<fZàiÔkâE4DKeñ¦EçÏxß(þ/xyÜüÁéÎ¹
äqj^´é¢õò§àg ý	à@¼ÆNÊ
¾ú½Qü¡'ó(kl¢E}æeñUº¿ü5Åà¯±Ïgþæ¿x÷ßòÿú³þYÿÐÛ¿BOÈ¯ÿ±ý±ýAwìÿçÆ¿Èµ$ÏQlûcûkÿÓV|%ûÁó'6bÒódgûkû+ßÂ:²ÿ±ÿuüÁJhàø«=§ÈF8þ<°âO´¿×¥{H:ÿ®úF¶Ò£¿hÄ¾¢n×þä1vùÓã¯ýøaüé­L:útùþÛåO@¶âG4ÄFþãøC·Ë_´Í_üóh}Û¢zuXí±JÀÊKèÌE7MJ ¡	^¾ªÏxÒW´,§Ì~2èà'õ|5ÿ¾*<ÅÜ.ÿ<ð p¨Ï þ´uùËÁéò>8ä¹ò|Gñn W
?ýÅúùòïú7y`Ú§á/¤yþÝ2¼ G= Üåä¯±¿åoýØ¬º ã#ÛÖÊb¯¯?Û?Ûÿ¶ÚllXÚzàÓþgîóýo{þ÷ü£Bküný.yÛßàõçõ÷_llØÿ²ý½ÿ&Òõ7Ý2öU¸äíì¤#è°¿þWqRée ë_«ÙÿçL7óÓÜHñPJ¼®ÿaÏúQûßÐºüT¦m¾üÁ§ÿ0ÿG]wC·^sÆ?ÈTPòyþÐÆþÒWó%Õøóx#<ÊÆ¨|æÎbr»ø'4V%0Àºc¥¬:®JÊÍÐMÐÍÊ7(û7Xõà«
ãæ6mºüÁ~V
ÑÑK~CsR_ñÎóg¼àká¹PþN­t»üóü5øk,3ý§>©æ-9ã/Ðö|¿ÔOóÄþûÃ¾æ?Zÿ-ÿ¶^¤ó¡.sôßúçõgû3ðUóµÿ¶¿ö?ö¿ö¿9þTÌ1Müiÿkÿkÿkÿ­@â	ì(öQÏé­¿
¾ö*s£Ég%ÐÍ'mµCü<á'£ø\þÌü0þ]âèý1¿ø*þ´]þÔi~¿ø¨:£ò¢7?|êÛæï.úÓWõäñø å¹ÆñvÿÕo1ø3Wóo÷Aúï¿å?ÐmÉÇú·xëßëÏöÇö×ö*ûjÿ3<þ|ììÐÇ¿MÅB?8þpüáøÃñã/ÅW?Ûÿ~8þÞ7þ¬îåæýgÅ¨´3Èævý¯ö½up¤8wü¡½qüé¡Ë_üºë>ÂÕX(W|Iê#Å]ËôÅ_p¢E}æÇ"x	Oc¤ ¬1ªî8ùO³ÿ
Üj©1J)W=ã'ß­§/7ÄM¤0*Ó. M4©§ÿ$þÂLC¾ÐRü)]þô¨¦ø6ÿ.áÐj_y`¡üé+h,¢MyxvçO.Í?²sîm®ü¡©Å
æ6?õøO?4 ÆE^ò§n1ùO£æoù[ÿ6Ìëo°l¶<×´öÏö©5;ßrÍ/I¦¶ÿMlëÌöÇöGëÁöw°.°ö?Mö¿ÍF ¬ü(ÿôüåø#lÃeoÀ±ÿ±ÿ>ØÿØÿèYÛ`ÿkÿ¬ñ¾q)ü4Óø_­³qöWërTüÏÿh,à@Gö>Ïî³êÀÕØwE> )ã¤½	64ãø3.Í_}$®þâç/cèò§Z·øS®:Ð©®aü£yõ Z­ÀØ$ !+/a#xÝDêÀðÁ ëEKôI¹Q(y.hÑ®.Z({æO¾« àf¦Ç,þ¢O\@i?mÔeþàr Ç¸6Äµ1®MqÝ£WÖ¼òü£©ZyþâK;ù.Õj.ÝùSÎób¥ùÓ_óïòÄKò¡¿êòü'ñ§WæÅüiSQóß_þÐ5ó·ü­µ¾ëßëÏöÇöwßøuaÿcÿcÿcÿ8þÝ÷ù8þþùO¶$?QgÿkÿËZê>ÿG¿{2°ýµýõóoó¹ÿgÿ³ºý/ñÕRÇøùúí5Oÿm¸Ì%Ç?ôÿtç/:;#¿ÜÞ»(ïZêC
/ñwæÅZîòW½RÉ_þ¹»þdàÅGü¡ÕçùSGu¢/Ü¨ê÷éú?ñ"åR
À`lªïòÏ¸àµÒ±­*`«Æ'ÁªNeÆNÍ7#ZÊ"Å
<Ç`¥ãFÓîMLÞðþKÝ|
Í`)LÏØh÷Bu¹ ï¿yÿÍûoÚþÛ6Â¾Å>¼³6Ò5å¦oùÒ¿|ñò¿û¹û¹ïÚµë»pG\¬øÞ=O¶uÃzL"6¨7_ôÔ(¨mäÒÌ¼GÚÅ?óñ§Lñ§ã¥èò§ ñWRøkþâMù«¯ú­hª¯è s(I¸Cª:	7ªú7¼p3ê3>7vRðès^æO>ßØ(VÈô¤P4.´èKj [  @ IDATpIñ×¨ÄZyþäEü¦'=éIg¼òW^õÓyÌcÎ»}Ûeûö;cÏ;p\½ã²H£È:@kqTÔZ2hX,0û¼j#L+v¥K>j*b¤4ÿupÐ1ÿE=®¬Uv!*ázÔk-¨çÃò·þyýÙþÈ"ÔÕPö¡ZÛßj+*ÿÓó3q¶'B5Õ?4_Q¿V¾ç^cÓaoYÊX±	AkøvÖDxÑÄð!Õ 'qJ·7:®ü,"Àç°n¶çzÚÕ÷Ûæoù[ÿ¼þlð¶¶¿<Øÿà[íW"þ 0iq«Ññ¯ã jDO/HhFMâ#þ£'ýø7J
z.n®h©¯pºcêÕG
×UäÌ_ø¢G:¿ðºsÖ¸àqx öçøà«Î<óÌó¶Æ¡\ÓÞFã)ÕnÆ5ype¯B¤õmZõ³WÇðj ^?}õêÌ_kR
F"KpS], <Ú"ß«æ	ú=½ÉÅa^F¯Ð¯K,+ÓUó·ü­^¶?ØLÛ_Ü\Cõ
ä2}tþ@6ôÑ-@<á¾ÝñâÏxòKVð 2pÔ_ü5ÜûÅaüõÉý-ºlLG0BøºÁùÆéÆÐÆxóÍ¥,aRO¾ntÚÀmÝÑàð+ó'¯1­Ë_<µòøtùÃoþðWü¡§±?)×Ï}îs¿ï×ãµçµëI'zb j¦î¬4¶5Æj<èÕuaeZàiEmAú;Ì
èQ\ë«oÐ§²kÕæ<ª@"cù0zCbýóú«v¢ÛLí¯ýOïA0<=lºñíÏÙp$¬<lÓfK0ôÖ[}Ãü¸jàõ,]ýO}ï?%åøÖGÞøíuqÍÆa^_þæoù[ÿ¼þllíìWMü¡K/
ªN¼ÿÐÚBk>Þè	Âû/¡hEï0H¿êIS?7;Òþ©¢òþgµ'Þÿ
y&Ó¶ÚÖÎ8ªY6ý$%¸jC5ªzDÚFÝv-p¹ è¨/eòôræ¯3ñçü¾¢Aþê3?õxAèò§.ÏEsÔ¸i_1ÐÀVl =Æ)áÓ¬(k¬*«KJý*C7çE<n<íÐÍüU¿h®@Z¢bIUWãzâ¥6ÆIe@(~Ô	WãR)ýÿ÷¼ç§ÏzÂ¹¯»ëî»ÂéÞëR=0ù W^>Êàñ·ßÓÅä4÷¾0!ôÇà{´´ (°i¤'HF¿õÏëÏöÇöwµúN­îÞ±£ÜróÍñvYüµ­°ã¼9Riq\g³æáÃÏ­]·¾lÜ¸±¿÷¾~ýöÓóôü=Øúwáª·mÁ <ð¥³ñ½5ü­¸fâ·jC#dà mv6*ë_ºP!pù}Jê	+êXÈóöÇlümºøFðë÷}H[ÙüÛ]íI­ÞcËßúçõgûcûkÿcÿ»ñ÷¼ÿâý§üüÁ¾?jh¯}¦äÛ÷ß¼ÿ"½¨ÊÒ4&*Û³£÷ës/ò`ÍûßkâµüÂÿ_þåWþqLls\ü%7_çäÛCÞfäµ1hÔzyh@Kô8àü£{þÒ<à)üF·þøÄ_ü4VÁñ×XE»aÆÈ£½ÚÚH+gz]>¢±¬)\-À
½FsÐg¦´^æoù[ÿ¼þllíìÀÊÄ{¼ÿàýï?iãÍûoZï?ÖýXï¿zÿYûï|ilûömÿñ§>å'Ãa_×í¾p¾¡ó^sÝ¦ Ï¦ íàâô±8\¹¯Î_¢ºCV$@ z]ùü£·ûýÄ_çÐ >ÿÕÿ¼¡ùkêÍ¾àjÜJ©_1ÐàWl =Æ½¨¯¯º4ga¨ñK¨©n*ø:Ó§>Ü\òRÈö<íÜLOýh·Ë_øÂc\àPO¼ÆK^$²}þ´×÷|þ¢K>HÚ·÷1P=
úbýóú³ý±ý­Nÿ±òþ!ìÙ³«\{Í5åE/ø±êÿðtEü_Ø0þ6[Ìí$Ýy7}÷¦rû¶ÛË
Úðoþ8òñÊ¿`Y=ýáDuOÔ¯Ø_Ç[j}«ýå§1ëÛuæoù[ÿ¼þl°é¶¿ö?ö¿+D@æýÚBÄ{
ß¼ÿÂîAÄ¿5ÚE:U>Þ!þ'ð¯Þñþ÷ß±ýÇ5ëÖl?÷ñ}JXoÇÅÁÎ+0
áAª ÕÙypt¡óðÙÚTôè¢=Ú2½Ì_<¡A^ç/Â§> AÈü3=õSÚåOßaøÔÑGóþZIàH%J=Ð½ñ*K*7ìÁ'õ@¸hR¯D
 èð¾ÂÍôÕþàOd+ä9P.)uàÚ¨Ï×X4úq0wúE}ñ¢];9ü°YØ; v
üÄÖT}Qt?Í9#þQÇÛuü e_¢k}ã.ôü¿ù[þÖ?¯?ÛÛ_ûûß?FÆ_,c¿ÿFççÏP?ûù{þûÞðþC5Õû/|1aÝº
VtôÌ]ü|×ö;ËïfÙùÇÖMAõ/¸è[È²mX7>ëÐgÊá·]\6Ýú7å'¬)><üc<L´öÆøvÞvg¹þÙ²ýg»:«25ÿIük°Û&UÇÙð{|õË[ÿº¬?qcÙtô!¾4>Sè²¼ý¶;Ê®wsyvyøO;ÿIü²K%óG¾¡B@ÜÏîý·ü­^®ýaQó¥o_suyÅª·À9­Ë¾ú¡¶ü«	è9ÎÊ8Àûö5ß.÷¾÷}Êz¾È>ýÏ[7oµ<¡¬]3±¡µ¡þ'hôÁ`Ã]ÏÿÂØÌDoWÈö£D}âíÅgADUs¥uk?*Rþkãí;ÞÑühùóåßþõ_Õ§ÜÿåÁ~ð¢Ýÿ»ïÞQ>ñÉOÖ/==øá)÷ÿû7ýAoêæUdªj×¿-[n+^øùªsOyòËG¶dú÷¯~µ\sõÕåSO.}ÌãWµþík_+Wëª²~ÃºòÌg<sIÖÿ]wø¸¡'OzÒËQGy@¬ÿ¯|íËåªo}»zÚ©åq~Ìíß×þíËåó¿°Üó§g=ë¹e]|Qî`²wï¼«|üc+·nÝZòO)8ã¶þíÂWüÂ?]TnÚ|sõñ|Ä÷5¿9ûgÿ»°ø£YÄ?ñóWp Ç«/F>6UµBÔM±ÿSãÀè[ãÏJ²õ³üõÏëÏöÇö·ÖUk×oÜXÎyÜ£ycîê¸¶ÅÅn ç®áñÕ[¤2u=¯Qñ£nuê£vú
 Û3mñ¤ü`¢ñú ñÒ@íð×¨Ë4Ä_4à	Cæ­þÝ¾à§øQ·¬ Á-+Ó³®$PÕ«à.õºÑÂPBZ7J8í¹^¸ÔëfävòR(åQnò |3
íö[6s×<§<ôÇÍÿ$þMM^^½Lëuìlßû¿¿ó7ÿkq¡ëÏòÂF:dý7¦­.¹¦ÃíÞú³þYÿcýa³wóSñÆÜO¿ô%(¥Tkß<ÊØnµõá	Êu7\_¢C¹»wÜ]ÿîïÚ±³\{Ý
¦CÞ½y[¹úÎ3ÊÖ^Ô¦GT1=Tl»¨M^O$·å}åÆ#¯*G{L}XÙçPáj¬½ê ®¦Ô=òÃmÛ²µºíôòc²as¨9äïÿ$ùO¿ù÷nSÜCÝæ¦Ó­?Ë?¤µëÏúgýCõyýa§ysùêo»üÌË_RÛ¾'
ý,å'_ô¢òG=ª®YÊØÉÿ=ðîrÕÕWÕ|íoÄÁ\ýY£ôò?÷ÿÎxKüMç¿©ì¿Eûð?¼¼ä%/©£X.þU0mU¾¿ßûÉ^~jùµaÿ/»Z\ðþrÙeW/}Y¼IüÐVÿÉãð/ì¼4æókøÂeÇTþ¢ïÿÖÇÆß~ë
Ló¿ìÒËÊú`åûÒx«àÌ?¢ÞWð5ø³aÜTþòØðùoß¾½ìØ³³l\»¡l:bSå¿-~Êíê«¯)§xR9éÔcÔÁý¿sû]q¯]¿6îåÉåc®óÏüwq0÷×Æ gÊâ þÆ\WþÛoßV¹ÿGo:*~v2§&ÿPÚoúN¼Ùvslà_N·Û\Ù²yKyëÛ~ûÿgï- ´ªÿñÙeYré%ºkAZXÊ|m¤»ABQ6PA¥KZéîîÎÍÿç3÷gï>ì.ß÷ýýÏÞ{OÍ9sæ{æÎÐ+Fjã¹jÕªÞßø/>ü§NÚmJßÝ{HêiâÐßàý}ñ7þ¿úéÝ«»Ü'úõH
åÑ$Ç6üÇ@üo\¾&'OÛPgÊ^Ï½K,ÑñGø7®]ã'N ÜX%=±M,ÍÃßàßº~SN@×sæ©S*ýgã¦õØ0§}ðÐîêÃÿÊÕ+rúäI%Ùs< ÒBøÿøè¿bùr÷ã*y
éÓ§>Wßºø?¸9sV® azdÌÙ²/Ø#XCQ\ÿ[àßÛwî7èS§À&;*:ñ*¬(cSßÿ¹>uæT©RIÆ¬$C>Ä`ró»ÿ#à·g÷Þ9PÊÜ*É7ÔÕ0û0
m×-´ù6ÆQ¸M>.ÿ]ÃÇQ`ô´ì ?tä°ÜºuG
<J^ü9þ£P÷qôÃXfÎN2Á
/èAYý­ÿÝüç¦|ü	§OóçÎHLYð1Þ0	gwEB¤Ü$^ù§2 BR§Ày¦øøÿ®`¾ ýÇO(§p(­ßxçMô?ìÀ8³Û3þþÈþ8sN²Âb8;Î
=Öå§?¹Î!ÿüãó©_þ@*øåïÝü3\+)YÒê0~Î9±J./ÏÊßJ=ÏÖui+ópºf ðg<ËXº³dGÓùæÁÅ[/ó»õÌË`u©(u=[ývµü|fÂ ,þXÖÊ|^,ù
+ëlÜÆ	Ó"Y1ë1øVécàÕàóÙÒ¬
T)gWäàË/öfäò¹R,¢¬<ºF¢ðv°%±ýì º¿þg#ÿ
þ~øä?ýýüçD41÷¿)Øt	vüØ1¯bÎq*ÎïÿfXÛÊ8ýÈ!ÆY>pÆýyÈõ%ËWJæ,ØôÄ6Då/öUGc-»Îb"P7` <,ÚÀB­Y²eíÛkÂ»|ï¿'+¯Bz¤µÇ üâü¿víÅjC|kÄF½p¤`z/øÚ& Mãº8ßfñ¥hg ¼ÞþÇÝTzõê!©R¤Vø&C1× ÖúõëdÎBb|6) ü7o«¥Öí;7ÑN(¡È+ZÊDÀg[úàü©kP69ëobÍ7ÇÆâc )ÜCêºñ±ð§OÿJ6ýFë$¸ïÄ9mÄ¿Îkôì³^ü©<t,æu£²Xñ"J7þ¼'Íâ£??®IþÔ©SdËÖÍùaaÍeÒ¤©rñüY/ýÓcã²N:ò$¬FN<-Ó ´9}úÎ ©g¦5mÜØ³©îô86»vu,æÊ+ÀÆqð§âtÚÓuMòo½õ®dÏÅÛÿËV¬ù¿ü"°îd ~)§%ÊJÿ4.44TªÁåýâOþîÑ£Ü	¿³sHûöï+ÿ9°ýþ'ù/!øQu´ïØtÎLbûïÞ=PNÏKP°

 OhhmUúPúöÿ%Ñ7mÚT(_éhåøãÒôî¹fòëª²~ã¸²L"Ã?Às
ÙùKø»wïYsæÊu(~ÊÔ!ÒäÙÆ°Üy±l±#|áþ9­¥öI±¢K!åÀná²xñ2Yµr·½üO2dÐµ¥Ø%ÊB+¶ÍP²fÊß¯çÎóçÏ %PR¦H!´b5ø·nßo¾ýN~ûý7kÿäVÂÏ3Î	«+yóæwüÕìç°¢ÂÂ¹#§Ydô¨QpexbPÚu(|Çi?äÌ&ï¾ÛN!~ýõ¸°]q ·ª¤±ÃAgÏ^aC>P6|9vèääZ'kòH³æa|ñÃ÷?àL®
¹WÚ¶îä%ÐÈsqÝ8±¿ÞtF8ÊÕV38âï@é7çI=3§nâóKvÆ;y	ôÂ3â5	`ðëþ|±ÑpTDe{ «¼ßî}eaûIMà9þPåüq¾,Y¶_´ÇHËÖPf»HóµÆåF2¬%¾/x ÍW?½|8úZEIÿ~ýq¾ÛUXdº@ÙµIfL¡ð7i"¥JQøGÛE ÙH9|¦jÝ
JÃ¢Pz%ÅÊòý7ók T®RQêÕ­[P¸õë6À:æa·w.á8CöÁüyä?ÿyõ6Èã
(2.^8þ°Ðx¶É³2ÊOZr KÿÜþ_øÑÂÂMpëzNà{Ì\¾<]Y>ãÅó¦-°HùJ&lðÃj¶/Nù$	Öìÿ¯fÎPWht\þc¿ B!Ðw×®½HÚ¡OKÐjÎzir×øÏÿiXÞò!¢¢å©R¥å9ðÇûßà'Öÿnþ¿úÿ86üIúá²@ÁÃ?ý²Pã§V¬	ÀÏÿ`yåµ×Õ:Q
>úéùªÀrÓ{ß@BÉl3WyýµÿHò\îÇöÿñÇeìèq°öº®üÏæ¸ñO2¥¤ÅÞñ£´ì	aÃ£Zö±ñ§Å?/Â^ô]ýï_
å*Xþ}Y þ¯_·¾T ÕZå7­8_ã¯VàU(®Ðÿ3gMBm#^dÈÐ¡Hwøï4Ü|6TaçÎRbé;â²Ãí_¸	L+¿®þUá»éÏþçuï¾óø »Ihü»ñÿ§Nù°Ýé|ëÿÅG:\þµ $¯Q£ºâ	çsò
yû7~VJcéÚ8@Iÿ§I¢ÊE??ÿ2_B¹ý«Añâ¦ÿd| ±më6489,Ìx4Óÿ©`1Ù·ß <9ò÷ØÉc2âÃ\¾B9i ¥¬ÁwuìøW]óþnøÄÝ¨®ùßàûÎ?cÆMò~§Ò¿>FÈ
y_ü§LúvmÎ;ï¼+9 ¯þ³CZ¶lÅÌ®ÃÙsfp.ÇðÊ¶-°`Çø{í×$ÚÿîñGüç}ÿ½,_±Rù¯xb²ù7ÿõì3æ vË?>ÿÝ?À"`¨ò/èïzÇÐ8Æ³@;w=&9éÒÈÉ'ÐW}Ö?à?m
ß]eì=ÊAd91D
äÄM0HÊ6p£Á(ÛDsÌËêÜbÅá²ÿxÍÑÑó7¾aM'7&¸4%bÔuXL=;DsÃ%¥gÛøy=÷V­oO*viçVáGÃ¥y§}	Á×¶ U¶ÿ­}q¯÷¿>Çþ~þ£LÀàUÀAL9Àâ!oâ
sî'7EéªJu&ZÓ>WJ$ýûöÁjaC:b!rÂâÀùò_±RñÉÇrâØ	Ô-ï½ß^rÀ-ÁfÏú¥yË0(ÅpÆ+°5ÁÔÝhZðqãFkîjØ ­S»:Ü¾EJo!q'JòæÏ'o¼þÂÆ¼iÓ/A­Ã5sgÎÕ)J/ZóYþäõVgàáëý XDK¿~}äÒkR¢XXu¤Õ¿®	à¾³S¸`Ëzü%KÈü?(þm_~Éá"-RÊ)#ÏÂÂà¯Y6Îò
Æ¹añ3_nßº>âiu®§ÿGâl¯#)ª3eÂ{µ%k¦lr¯K-}P[à9QChiâÿÇ´ÍC16ÃEMíZ¡R¤p!ôeÙ¶}3¬T¤%ÅA»v±!	]ÿ¶lßeÚd2£ôÂy!iS)þûÂ"m33BYP?üºoÜ¼eü´`¾â®{CyKXÒÊäI²yËNOÿÇ`?TªXFÒ¥Í¤ü/O~ÅT»vBéñOë»ºuëBneÈ£²í÷m²c×.  É'îÝº©ÚÝÿ
òÌ5SéÿôÓu¥0>Ö 9-"âð+/J#yïÔÉ:uzyóÍ×ÉIIÆô©þÇçJÿ$¯Oc¼ÂÇùy+>øJî¨¼ÐI;XîfÍUqç)ø`bÛ¶­È	)Y7O.)S®<ÃéávS$7P&"#¤{÷®jqJþÿ=ÐãTõ¤ÿÝüßüoð}çíP¦N<
­ñ®?6wæ,åÿ×^yIÆ«ã¯8´aaÍ´ÿÝëÎÿ}ôø4|sÉOóç+^½àÊÒ#þüÿ·ÖÚHrxK3t»?|¾ÇÜ½ÿA
ùßýïÿþ÷ÿû?d%$æØöW_þþù')Öé+­¢îÇ9Nµ6Ýr7]nuÄ:ËÇ{N}öã3ópÃ8«WÆQéÇ<¬qAøY]|fÏüÌÇ«¥Y{xe^7|<j^k£Ág},Ï¥¹áLáÏ{7|{vçayþ7±<ðOýa£ÿ­à&!lW"NÙ#ÛÅtk£Äã[Æå,»,óóÙ`2Ý[],gLbéc |æ·¼v5X0øsãÁ{¦Çqîº¾åå?7|¶#¿¼+V¯]Áó¼Uk)]*¡±(âÙøÃþ n;Ñ\PÁ%Å§ý%W6]M?ÝIf¬æuÒRøËHwðÔË(Ô¿z?HÁà1¼T«»ê)îßS e5»Âãvvöc}$ß@/Úîr2x¨AX0er3òmmÇyâ\½dBð.ÒQÔ	K¿ùcO÷tù3á%9Æ1ÓþbõFã|ËÎËËÙúh}	Áç$èm;kÆûïÄ©Øá3=$£4møûáûéïç?ÏØñ?G~¨ìàæÞ½ç/ýË¶n¿=Å\[6/ÞÀ|>êVW>?x*=Ñ_`ã8OÞ<^ÅQÆö%þbã¬c¢`ÍºQã\b4êk¯+ØÈÌÕq%%ÒY'¸{u[¾ÿn¬_·ñ_ÎwìÐÔ økà.oöôYøçü¤	ÁyO<_(¾wÄÆdÚÔiåå×_YÑ>X}MûR¶nÞ´ éÐ±6Ü¹ÁU¦á,±ß´ ¸ë ¥\d# ÂÆnëºÕøÊAÒ¹bPÌéó	àEiW¸nã¹ZYá>ð¨¸Âfuß>ý¡à¸å^1©Y³
+1Gúûò_|ø/\´P.øYÉóúÛoI¾\yãÀw8mqøÿ6tÿk¸>òô¿/|òBÐôoÝ&L­Xý?ê³Q²ÿÈ!}kÔ¨¾bøüÃÈ¨Ñ£tm6$
­je×©¥2#¤ìÞ³W.òÞ|ï]I4¹ºó÷6oÛÂVB&ÈÐ¡C¼ôõÅ²ß>%kÛ^û¿hr,þ6Â=éWÜPËÓ°V-µÿÝü7n;7®]/9sä·ßOñçø_¹j¥|ûíwZwÝE¨À £yäÏeÿ¡JpËó¦°½P³ÿ=ZDZ¶
C9¾Â IÿÜ´üÏB¥ß»o½­ÖtägXÄÈcÇÈ^ÐE7iºöÂ¿|á¬¿êøkÝ®¡Ô%ãV(P¿{·P4ñUã<Fná<ºÞ={aLÞ`9ûÆwúÆ²V½þµ¾ 9C¹áCë¤*_Ò§Mçå¿eËËóæin®ùßz÷Éã/ÿÅ\ñ1xðsäÌ!ï!ÝMÏ
Üø|ã?ÂvÆY|1¯-5O>1+ÿO:
=ò¨´mÝã2.þZgüQqÌ3 9öÏ¹ùÿÏö¿{üýù
^Ø`
Ç9S9¤6û	mÛvÈÄ)~MXsÔ² >ï×ÑmÎï!üV-àÊ²Î¿C®Äðï
eÊKó«ËÑúí_ÂZ*?Ú´ðÃqW÷Ý?@2eKÒÎíkv`þ3`Í²Ê^â_»&sèWÂ'þÆì¢ëÿ¼y?ÈòåËPg¬<;C«.|ã?¾h¯^µdqöÛ5X?¦õVX&Õ*IÿCÈ­;$IpÎÚzæqá¯Y~ûz¶$
îXSÇ@
öéÓWnÞº%3¥â«$	¢ÐOÌ~]³Fæ|=WËÐ-ea(Õ´	àÏ³ÂîÀýt¦´öÀ¬ÿ~ýiAxEÂ²¬uËÖòÛæ°û©Ò´é³RêÉ2^ü'$»wàXß÷ìÓKR&O)]:upìî-W¡Cÿ5 ÓìÙ3õ9wÞÜp÷¤Ã&Ãê04lÐ}	úãýÅ¡rcg[¹éOü'Nbí ËÁØÐe7ºñ_¾t|ÿã<T-:të±,¸¥ÿ#äcl~²`ã¦qSi¥edx¤têÖQá§¸ë7®JTx*[^yí5¡AÂb?TyòÄ	>â#_¹b%UG_þÛ
k¥iÜ;ô_1ciÛwlÙ²Êà!Cäìé³pûNºHÊÿ#ÇËÇ¤\ªOjÕ¥ËËói1ùß«¤Ä|éßwüüWú³\)eôAë×?|ôÒÍÿþË>óünñÐË¡{ÿG©i4tÑØÿþO~sxNÉé¢
_ßÍø/ÕüjÚÛ8­HäÇËäZæË<UJ¼h9éÚÞZ;}æ~fH÷KÞÆ¬!çÒIÝ´m0|´Jkû³ý/úß?|?ýÉ~þ¶J°ElÌþñjþòÓlsÇ`1÷:,yÏ1nwNãI½¨ C8ùT1'¯ÝÃ3¥8Mp1 j1l¦;º<Æc³sJLLýØÔúõØõ+hW<ßQ´P6`Ú¯ã
%FÀôß
Ë°©&Åÿ¤¿>úöm
Óø¯=ÜhfÅÆ¹ñß¢%KÁK?Àd
Çª¼àîÿõ×É÷°h¼Eº{ü³íÂê©Vò@®lqøoÊÔÉý8¨ß8ðÿÂêï,%)à*·\ìüñå?ÃßMºL%?Ü¾!
HüoýïÆòü¿
ÜÑ8ÓSùýOw¶nþ§\
J)Þx3:
wqúzÁJ:ü¿yþ)üÜ(UÉi§>oµ @ø¨;H¡ðc¬¶ÁIJ{u©<ddÁæãEÅ¹Á=íÇ[O9¾x¶êõªÏÇ)\®½,£ÊË4Uú@«øà³A°¥ØJ¾4òàßn,mÉÖJºÌõeDsÈhJ9»ZÙ8WTG)DÝ¸@ÕÏ]¢wJËã)«&
¤ãíÅ,ú³½áïï§¿ÿüãïÿùÃé.±T1Gx¯Dtd$³ê<Ád¾HpløÏ¾'¹sçUG0ä?=å¯)ß0µbÃX8êÜÅ\??¹,YsJûNP:!+J`µK¬e×Jøâ¾N£:¨ó*ñT¹vÝ:lÍÖÖa­¥(Zj
Pøl«60QS4ê,óTiò\/|m 5ÛË	lÐJ"ð·§)'aªråÊÁ²­àã ð©¨¼%\¡Ç
ëyAüÓü_dÑ¢_þ»o¾+´x[0ÿ'Y¼hÎeo¿ý¶äÊSáwêÔEû»L1·ÿ:¶q.é$Ø¨âEáTKGZ½8ðq«õþ¾øûÒøOhëÖÍj±×¿?6ÒÙß.üWÀ¢ã~ÐÊ:vìZoÿÆ1l®ü	¬KgàÊ²t¥?='ðÜ%ö£ÑßàgÆFö;ï¼W 5ÓIÿ;vÊÄñ~zÏàÜµñòßm5l¬jÖjpaæôÿ½ñÿÂtSÉÐgfÀf­ÁgéspÃøÁp(MÑîJ´JÃÙUK-?ýò°­ºêÒxÒ¿iS¸»+
MÃçö2aÂíÁú
Ìàhí5òãÿÐ§k¨uû+,Ç8¾X¤%ç"ÿlüñÝ»wËØqãÂðQHñb´C	Àß}>Fá7þyyÊy­Ì>q8¹²Jçî Æ«1^Ø©S§Ä;Y:(9y¢»ø{`Û
ã%­ÒòÄ/a	ºV­Á2 Ä5!Úÿ_ûÊØý8ë/2INÀ'@?7þL'ÿ:}Zþò³ö¿ ü,A9*¯¨{
.XûZ-ãÿùlðã¿þ"?/X\Ñòò^
ÊÈÏ>ÍK²dÉ¤'×tuÅt·ü[·É£|Cl+ô
S>æðe»nPãcº8»K®z*ë
ÿ2\º

@7ýO_ÀØ<Tk-_¡¬4lôâOø¾ôw¿3P:Lé_±\³5loÿG~<Rù¯&%5q¾h>ÖÛ`uGúî«äÉ0^°è¡¿ÁññÇrJZ
Ð9
þÊÿ´}tr?Î?[6ni_}¥üß¢e+)2þ~´gàþ/4b®AkpÃÿ÷£PÀgÈå"xÃ-9ÿ
·©SÇÏ5öÿwó¾+Wêãó-°Ñ
÷Y\v¬Y·AæÌÁ'X£ÁM¤Ç->øK/ï¡´¡@zóÖ±C'ýâí%Õúõ ·W°ø,YÂÐ^þ¤IØ¤Ep¤Ríß|ýµÂoÚ¸©<U²´âOøa9-¥Ë`Ó²Qc/¡Ö­[G(æ@ÿæP`Eóá6[é¥sý
ðÅçÁïOÂâaþ÷?Ê¢åKÑ"Ï>ó-]=	e¼ÿSPò3Z÷ÂÞ¡CV¨°ÜíÜ­«ÿdví0Þ=k;_ø6þÝü·Ê³/'Oá1S«½¡@H­ãÏ¾/ÿ±Ý?wÎYkÊç?1÷èÿÉSiñ¹VÉà6Êt/üa´páBmNízu¥JåÊN­(oð/\¸¨î(Yº`Áå`!¶eæ(ÜÊÁmh#(Ýòð	ø/%]¨í;BÁü!ÜXFHJU¥N½:
Ïúô§ÅÜFÈhôÙpEÆØÿ§¡Ð
(Ç_}XEVÄÐGþvÇ¹tÏ[®,Ã¢ÈþãÆÝ»öHbN	ZÜðñ(ýÉÝºwÓù'îºAyîAÿtû8¼rçâ±õ¡µjÃ­l
Ã[Õªx@ÿÈ}7|7ÿõîÕSnÜ¼%Y2gN°lÖ4Üõþå¦ÿ½àüg>¶í^ð}åÁõé(XÉä°®X®üWÄÿõ×_ùòÇÿÚukeîÌ9J¨°°0ô
#	ëF¹s[bãîbÓ¶1ó}Áç¤§à¬'´N(k
G0·Nô]Ù.Vâm_¸:zSNgzY"faþ%_jÜCVêçÑgåÛKc$$wZ=Ù´nzÜ¾Asd=í;kG¯HÃt¯Hú$Y´é÷Ï®ÿ+ýÿWñ÷Ã÷ÓßÏÄÏ1Í[DÝüõ¿¿&ÿNùCçÈÈ(¸J;,o¾ö
{ÒÓìLüg7;±	þõt½¦{ïÁüÚe?ýê¹ó7_¹Ù¥ýïZ=8ùXÒô¹1{mGßþ8c¨lÙÅ\;çÃLMtí]Ç+°ã93Ø¤$°7Þ|Sòåye#aAÅGáºÃ`	FÕ"¡«-\äÈa(F*>RHÚ¾Ôæ.øl3itìÈQùäOàò,®®
ÉË/µVøT>¬Ã&àlºÓ-¡¤Å/ü[PÄÌûµlÛ²E7¦XRÊFþq\ß~B7<®e«¯ð÷îÞ#c±YNøDø'O
næzA!Ãe3ÂµbgZÌE@¹UFmú¬®âÿzO	¥9à>F·kÚÖÿ|ÝøÁ­Ñ_«E/Aé@«;ºí*õTi	N
*þÄòIjEk­þ8ËÈþTFþè±ë
WÌS¾,S*þÑ£?Õ%á©2Ê2æÑ²wÏ>íWîäIb¹kÜÜÁ;Ï¬»7ý«"ÊBd!ä]øsEú:pX>k2à_µR5©S§6<ð}ñOÿ£ÿåWdÀÀ~Zm¶m¥Ð#zá[ÿOö¥lÝ¼MW¬PAêÁ=£n£!ä¿ÝûvË¸1ã#>ËAyÄ|´kÞqKhíZÀï¼Lqð?W¢?"pÝÅuÆÙW!8ãø8xH>§Âü6Czyë·%-?Ï³s·öxèO	1`Fÿ	ãÇë7û¿!¬õÊÁªÕ"8ðÏ='cÆ+¯á|³ÔÒ
öé?éT0çÉoozùÏ!¼ÈxÔ}ôÈ1	2°M$GîDIñ'ü¥KÊuHùÓä¹ç¥TÉZ÷Ô)TÒî#Xö[ÛxúÿÔòÑGáìËhI*
ð7øßý ØP.ÿóÁJ`§üb_EÀêrdöFÑ?´V
t«C?ún1/~X*hìÀ? ág£!ÓÀ%p¾\³f/h]F£¿øBöï¬üNø¨",çÜü7<½k÷.¥¿	iøþçNq ?æHB}w/þS¦Aá¼¹)ÀW,ñ¯cÐ/OÂE+û¿Øpû"æzÀrË?7|ãEîoîùgÎ= FÿôéB¤+¬H52Zà¿ìÌþs2èÏv{¬6øS17s1ÇßûíqÆ\v9	ª1ógXÄ|ä_®P«U©ê¿l1ÎLÿ½ÊÞ=úHH·.\ðÁbñ®?Èkþ÷_*ýòÃt$¨'(mµËÀÌ c¬i>ëÍÊÔÿõ·Ó4EÈÓ:ÿûùßÏÿþñÏùÆ%ßT¦9û¯~ùGÒ@fr1,8XªUªP·ñ»TÎf´Åsæ½éX+b}¶4<z;BÚËðgùíÊúiÞ+1í  @ IDAT·ÜðyOÌË«é]XÛÁt·Àgæµ6°¾áÄ+Ë1ðj÷ouòjåíÊ2÷V÷ÿHpû' XýH|D`u<ó3¯='Vy-nïê8Æ1¸ëd[ý$:Ëñyµö¹ëe~Æ3ðÞês·iÇÒÇ{¬Ó³#äm7ë³v°¼Õaíb:ãíuòÇÕmÞÅËW-½
F|°p¨$ô|ItÆÀöY³â´i(i÷øjúÊÙ+r °¶\KõU8|`fÕÇÜ¶î¾½IÖ'ùYÒdÊ/ªÑÍl»}¬ ¾JL)M«ç/J©¨ZR0ÙãqðgQ©Øs¯õ9ð	íQ|<ñÎ%6&±þwjDÌ?biäóÃO¸ÿýô÷óüýïËìd©bJ¨·þCÅ#åUºþÄJÕx"Uzâã)þÙè/àÎ9Z&A¸ªü§ÄE^goòJÊ]n«òÊjxFÿ¾ýÕucflrwÄ&S(ù²u,Ày.K,Õ´¼ùrÉo½£¹¸I·0³ÔEc-\T²Ã²  VNíXhpåtrÆ-â%ë³L¸ë*l
¯ýu­¶ç¹±
-Z°ð\®H¸3üK/./6o¦ó/éÁÍx¶ºqæ^Ñ"EÕådìûI|¶í§RÊ
vXÿ3ðÃaiÔ
£H¬¿z(¿¼öÚkZýOø¾øk	ð?ñ'ÖÿíX|Ì#IaôÅùÉü9JÎ?¯®!#ù!ÚVÊåâO<®ýôÈ!ùJà[×oj¹$ÃaÃaÅ	±_ÊÂEàl)Ow,Ò$Ré^ëi¸÷«ZÍíÁì¸ñps¸[û?MHjÐ®ªdõçk7q¶Û*9uêò;ýõS1gãÿÔésPp
óÎ %üÒó@''OÉÒ%K`]vSq"|ý(2ÛÆÿexYé³K)iÉZ²TI)øÐC8b!ø -¤ü=c¶â@úçC»K*-´Ï+·Â=KBº>VEJ.ûÜã|PD×5¿B)wµG¡P"ý'A.oß¹LKfåJ>³þ7ø&6mþ]¾úòK­§æòå 0Þä!^ÿlÿÛücã?!ø¾üzáßÁÇ}z÷UO§ÿôcýà03)ê¿üXfæ;ÂoÖ
4£¸ÿz¬¨%ý;´ë Ùa1gð7múM¾þVI¼aMÜ³;çz|@\, ûkÌ}úà9XîúÂgJ;Àg/þ%þ¬VïÉ¼øÇÿæE¯ö×é¦ ó·s«ÏbsJjYþñÔéÄ:ó
ºxÚg
9ÖqçÖmtUFâÉÑ>ô/þ÷o þlÿÿUüýð
øéññ?ÿ'.üãï¯?n>Ñå±£Gå­×_¡HÔØ¹zâFÙ]×8¹½uXpÙÅ3]ðó!´gÒÃD­_ÿ##{:Zðnæ
Ñ2çT]ÂægVl½ß®==ÝîÜ¹Ëä:¬ÎPÏØH.A/Ü¯]ÓÌ¹%2*çÆ52¸à3o¤=óll»ÇHéÓ··ß«3l¾õí#ÁAÁñÂD¹hÔ¹à§²tÑb]Õ¯WW*ÃÅÕ;Öà<oøuþ½á'[
|èã^Ú¸mÚ
2XiÀÙv]»öÄ÷-ä¢P*
0( ¬M
2ºÁøï¡¤u6Í1
ã©0ø3¢Á,WÊ:Ûâå%Ó1Xu1ÎouÁÎ4>³>«ñVÞâxeÇùÂ·taº>½ðÎ¼çË ÅÕÛ»à3=>ü¬¾»>~gñ²Una¡
×õGëAûÂ¯Üãç¢ärêr5Å¬ØUÆC/BÒøÄá[A-Å?T@WÄ²ë,çnü"ÁYK*¼ôºÛç!?á3_²n\¹.ágoK©T5¤`ðSâ/øµÿïE?|§ê?ý¹]Ìþäÿþüñóß_ã?îÕFá¼#ÈÛo¼ªs§FGhã/9s38üõO÷ÙJXÄÈQ£9XVÓ¥ ¬b¢ÐÿrÑ~A»=Ñ
àc6^/\¼×m9äÝvïI ÂF§ ¿ÅÊeºÏù)6
Ä·ÿýÛË-·ÝRÇI!ñ%/ù~þï]~Y¬lølîÇ{ÆMÀé#)?úÇ'Ç;ë~7VMmUoÏ{*;ë!÷?»Ëü_P» 
Â1Îò§±CýÇßàñÕ¯Åã¶±Jã
cêÑAÄbjëc\l ÇD6â)3§ù±!'Äe~tÈÍÏXÛüæAçÍüÓôÏËà}î\¼1^ÏÅwÐÖ¯²Î¦Õ/aÁøW<û?ò¢¶~åËzÈÆÇ;âf~ó+eò²kÊañØ)S¦FÆHé#$ãæLÜ*ëÖ­-+V¯.ë\|ÜSÊÆøy£¿cc¼Ì&ø:¶*(7ßUf¯þrºáªrø	eÚÔÉeÿ¼9ñR)þÝ¶M[âÑ)ëã¦Ý¦²vÒ)å¾éO+'¹[óïçÜIþdªûþU±ÂÕæ»Ëe¾Tm¼ªL7¥¾³`|Ü4ÛÃokà·9ï´!~è¯¿w]Y4ñòÈÉO+óÆU4ÿH÷æïs{¹ÿÎ#¼Úö¾`÷Î?yüåñ×Ý^þüÿPçß|þXÑ²)Þ1wËÍ7Ea®÷È½ëÏvùëQÝÙÛô}ùö×·GaîØxD7-ÌÕë/ï_"[ï
]û<ÿDË[ïÛ
á+¯¾²^^ú*§~FäºþPÀ~_<²óêk¯­×óÎûù²ôSêuc4ò(×÷ÿÍ½2
}SÊïýÁIñ.¥ùómçáþþÑ}ûj¿ÿäïßüýç¦¼ÿçßîêÐ}¡OçÃtÿ-¿<þòó×¡ýìó7%^ÿð³ê;æÅzCl£h½AÛö¹¬³ñ¶­5(Ã§õÃ¾öúc"}Zó©³CßÆ þ¡:úlú[	ë,ú÷TUn~ýÛöñcÌEHýNºþ:À}º¿CíàÖü¾H¹>×ÆÓ^[À¦H	 ö´èÙ´|ØélÄDn~tqðÌaþ6|ÛüÄÌO5Y"Ôæ÷À37¹ÅûÂ>»>SÓ`Í¾ø¿+uº\èj8lAá®ZÁ¡¬4äû/lãÄS/ý¸õ¨þÇÈR=;Ã¡d?ñç°çÐã%¿þ§¦còó8äù'Ï¿ûßõÖæxåòxtÜoüêPaÎOðpm=ÇqD{²ãºÚ\+»`=äë9ñmoÿ² Þù4vl¬¢Ãþõ7üAZïé^4ý\éÄ7rmP3.|o¶Ûê»øZ-qûç_äq&NOq´äâêùø/ñcbô¿±Zî¯ÞòWå¾û(zä#Ê+â1©£qüýÕ_ÿe¹ûÎ»Ëôò¢s^xÈÿß»ìûåçÿKÇ<:îõeÆÔxêýðùK<æðîxlãSöòÂx×Û¡xþûKÿ§\páÔÏßËYg?£,\`\qïò¥K.)Ëâ}ÿçÄûì~ÿu¯+ccåáhÿ/ýïKã½Ôóßú³Êü¸NÍ9£ÜuÏÊòå/w¹¹TL¦¯ÝÅã/ãñ©Ðõçºkcuî»ÞUñÿ¹sã]lñXçCiþ?ïyÿ!ï¿äý§8Ç×/é}ù­Qé>yÿ-	pú¿¿èE¿UÐ<yU óþCÞ¨GI½Õõ(ò¸á÷2¢ëü;qÂÄògõ¬ýõ±u«AéÅ1j	´ÞQ Ngæ¶m­ ô:öÚÒ*«(FxìÑ?ØMë¼µÍïÌ¶ô­ÙìÌ^;ç¯o¸öó#Ì«-2r·ù*|Tö	(]ò®vrÈÕk«Î~pË«o[v æw
7¾*Pt7=·ò¯øe¼ªg"×qõKß¢3±
H°ð£2
¹3à=°í[<þÃí¨ÁüÄ&ã¶à´ùµù/-þèÛ·myìçßæGÇ6%¶%ýüÅ[ß{Ç\WÜU´m½Øëóý>÷«M4]çY'ªV¡¢íþ==	káøGtÕ{Ñé?Û=êèÌø÷¥<þºÏVýØÀæç/Ï?|6N¶tjHçß¸ºÄÿõþ£Zu¼iÅeÝÚ5ÑßÂ}44ªzýã1Ð¡¨×¿à»ënýcÇy¼!ÑõÃ+Üâ=­¼¯õ°Ã/³æÌW¶Æ»Çjänÿ
Ó¦O)³fÄ{öùù?.¬YS¸ï¾úH¦NVfÍãààº×@"¯¿Ï÷zÈÇ8ðzßòþCþþÉß?ûæ÷OÞèN5½³'<ÿäù÷¸þL:¹<ëì3yå±Qà'?Äa
×Ê7®º; -ÁóËøÎÌ7¾	lR[Øn
ºð©ùÿ<þâC¿<ÿÔ3eóü[Oq^Èëÿpµ»ù×ßú ìî{ÃÃôý#ï?tç¢¼ÿ÷º3Qïã×¨zdäý·ø]÷óþã¡{ÿqâä	åÇ¬æn³ÃúØ6ÅFM¢~À[N5	dð½ªãâÞ¿ß]:úØ±8ñé[?1?~ÈÚú±±L[ÆÑ:>b_zçÔò!î>ú·øv'yúÁF!Ñ¾"&1ptg±Øæ§uGÑºcõC/-:ÁP¢*Çd+èôÍIaÌ1Òî,¿cpçæw,È%r¹µùó×Ç±Òb[ôÈùÑa35¶xåÅY·Õª\¦»I´ àÎ% 8ñNÞ×]Ôr(B2=,:¯ú®Ze`Ý®øÐ	Um)ó'þyüåç/Ï?yþÍëÏÎ¯¿õèàB\2ÛØú5`s}·ú	òD½¡ÚA'Tå¿1ï"ñom·E¤xw^\¼ÇG"Ñ»ZvV½O§ÐgþÄ¿ûÊ;óøËÏ_âíI6Ï¿yýÃ¡û·3yýåÜàGct¿ð¢÷â÷_òþSwðE=ï¿åýÇ¼ÿZ?	õC÷ë¢L<)
sÏxN²,¶Õ±
}éCÔ$ðãßABF6óóÃÕDB§o}¾ÍOßqaë<íûµù3ùÛúöúÒ«õ3ùÍIßq;zDà}EÄ,'I.äLÞIÑÊcßÝ~Ad<}'¨ g¬Ö¶µg§·ù±ag"Ì¯Ü¼¶Æ%ÔÇbË£7±°1þµ0÷©Ï^ôÙñ9TÉêS«eBMÒûó,Õ!@ý[¯è8`ßê:eW®ãß­ìéj#>êª´à?ñçËã/?yþÉóoòúSW®=ôõ7®­ÛâÑ\öÇÆg'ÞñÓ½.nsEad\|%ØFA-®¿cÁt\ü{}®Ç<Â²^CrÁÕ+3+â8ot±R®>êK4Wr®Ý(¹³µúeþÄ?¿üüåù'Ï¿yýÉëïþòý#¾¨äý¼ÿÂ·Ù¼ÿyÿ­
yÿ1ï¿òãßµüÉûÏÜ2eJyÎõì@äæØÖÆfAªÂR±AÔ
¶Ö@ÐúõóÓGÙÂ#×èi1ùi¥Á8ú¶ùñßÎ½ã4¿sÄÎüøí"é¾$&!híD¹²µ@aé¯þØ6´îxãµ¶!®rô-_Z}[=yÚ1µ1±·o~|Ûüôr|Ú±ù`~s³bnÑ9¯zõ§ï]¹*Ø¤D HD HD HD HD HD 87wN¹àï¡0·<¶c³FBqÚý¶Þ`ÁV{j7È°Kú·±ôGÚ9Ë·ùCÜ¼ñiµÃROü6?zsÓª#§sÀ^[l ûðÆ7§}mCôiS£õÇà£¯ãÊ\´ÈÜÓÇ§ÕÃ#PxÖÀÐJØb
mÜÚÛb1|"yZ¹¶Ø`;8nlÙ£c¡Û	YD HD HD HD HD HC ys¢0wþ{~<¦zcl<ÊÒ:³§¬-T!£N¡³;º+×¡§6aúõì âx[ìÍl?|ëgüàoZÇaókcÎ0­ÔÊõEáXZ=|yµùÑá7êDâ}I` ùtÛÅ»cKÐ+Ã2<ñÙ°WÞædl´c!6zWNçl2ÈùÐ7·öæÇNö.ÿÌãükk.â wLSÏs $@"$@"$@"$@"$@"ô
s®[S¦`qÍZ6ê
BëëltÈÉãÑ¶;Øí|ÓÊðkãi\jãcÛÚcÞ\q@ú¢·­½?ÎÇB\;Ftôyåñ¹b®X6@"$@"$@"$@"$@"$ÀA@ïQÏi^.Þ3Gº5êÔ'ÁC´è,PÑ×V?m¾Ê(~Y¶«åÍdZjÖNÔkï8Z{l¿­ÿ(u¥Öz7c[QO«6ø:1É}Eèäì3¡v§Ôî'O åÄGGÛVA£[w²Å­Öü_l x6tT'D}2ùÌ¸ÎX¬óà1¶vÈ!bà!c<æ×qÑó(ËE/>÷¼O¯\uº¤D HD HD HD HD HD 8x%E9j	Ô¨-ÐR°¥¾@íBomÂkö­UÐZëÀGVäØ±YAF.óêg}ÍøÖrÌROK,6eú´±¬ÿYo^Zü°e}uÄFOßüöÍ¯<LFH¼/È	1a@ÒjÇäàÝ¢Jô#ÈîÖ__CÈØY¾æqg·þäpæoãèCò[=}ÇL96ÎßüÆnóÛ6¿c
s·ÜrsÙ°~ýppïü'y3'ï-»·¼éÃß«÷øùåçqbå÷¾Yn¼sçEÂÝO!ý½zDyìÃªÛ»>su¹è²Û
rS§u«b¼v§0wü¢
«æv¶nÝZ~ðýïÆ9á/eòä)eñË	·M[¤Û¼yS¹úª+Ê¢ÞvN#èà¿þöeÜØ1åóÝVÞýkj4rç ÿõ¶¯ÖrnÛtÿgôÐ¶0÷ú~§\uË}Ã:µ¹w|úªòÅïß1¬ÝÃ-ÌÂÜÃxæKD HD HD HD Hzï{^ÌøæØÖÆFM:ÄMrj	¶È¬aÀ[´SOí´Ö"Zk´6ð­/u}ãìvùñ³Æa>lÓ7¯­¹¬Ç`«jë?Î9ñ ë?újó[Á¦}càL{ú{L)µ 9 VÏD¨iÛáxA£tca	;
nÖ$¨ÅP[°&
Ò§µSìhxì 6¿óBÇx­\zúì|sÛÛæ×½;Êñ8^lÈÃ;c+7ùÉ¡M°Õ¯~ð,[|Î¹¯þÏ{W­
vÿ¢&Å°Õåîíþ²äÄ¥±mÂn=Êò¡f³ôÔÓË¤I«Ù×_[|ð¾Ëì9sËñ×þêx\åM7^_ßk×7fÂÄeé)§
¼ówû7«üé+[Cÿí'®(_í½í/îñeñQ3Êm÷®)¯}Ï×wú@÷ßéÄv¡ÈÂÜ.ÀIU"$@"$@"$@"$@"ÒôÞ1÷ü ayl¼#úµêlðÈ xkêhõÑ5yë¡ªÔÊÑú c#¦uø6<d~ã 3¼ïsÈ°e.¢¥oýY½ùµAoÎÇ×qÊÓXÆF>"r#
Ò83H'%(ö*tN÷¶µö½ à!d· äØ¡#?þêÝqæ	Õvùºµ'.}|ØSï#vøßã¶ÚÑ·W;nókÇó!óªWüÞû_a	
sS¦L­+â¿iÓÆrå¾?ªÐ<ò¨£Ë5ñJVÌ
sðÓ,^<¯Ú
s?³ä¦"7&­Pà&¡uúÊ°¶òØySÞÕfÈ°ïn\Ù¨;mË¥
s|`y,å3ÕÛ¶Æ
Ê÷Ä»/ºìö¾_ËüæN/O\zD}àâëâ1;?õäå¥O]\~÷¾Yn¼óÁÖ=ùD HD HD HD HD 8H7gv¹àü÷¾ ¦·<6ÞÏãJ3j
Öl¹5
s¼Gî?¿yËvß°îåo¹¤¯,Ì½éÃ_áiýBÛ­[Ëß}òª]®<çÇ=ýsÝÆÍåÝ±bî«WnÿPÞcxÂÑ3Êu»(ìöL"$@"$@"$@"$@"4²¼)&´.6
SlÔ¨#ÀSCPÆMtúÔ¨¨Ç>:ù`+O>´Ø¸Ûçak­ÃÖ],êéc\c¾6ÈÜüêi!c`kýG?ólÌ3ßØÄÒf°ÅF2§ý=n	>R"2&eâÒÂÓÐCø8iúG',XØªÇjókOìØØ!ùí·qÐéëXÜYøbk_¿v®ðíÍO,rÁV2:¨Cß±hâsÇÇ;æ>~¨¼cnÚôxüäÝã'ï¿ÿ¾rÓ×{F&MGaZÆÚRn¾éÆrßª¡P{m×Ö<òðüÿïéÕè#_]Vþ=6è?ÿÔò´Ó*â`/ë%U6ÜÝ¸9í¬-Ì]ü½ÛË=ñ¨Æáè±K+KYUí¹SæÏ.òÇTùh<Êò¿ëÒrç*®oÛÓ[á	åø#xÕc)?ÿ¿\V×wÀíÞ1wÃTù#côæ~¯|ûú{íÛÎ6±¼ùç_æÍÔ×ßvïòµ(Î}íª»ûµì+ID HD HD HD HC^aîÅ1Yn8÷9ëÔ+¨%¸[yë8Ö%[¼C/á!gu±ÑÇº	2xûÁV=m>61ÞÚJ°wlèàÛüØàÛæ3-7ÿiÍlíS¹ùÑñA¿¯Éìu#q¡må >´ÊÚ¯¿-@:iü!dOx+¢m.tí¸äÍO¿¼%b×ÓæGG^dæ¶qÍ¯~æióÃ+·5¿yðfÄÆ¹ÂÜ±Ç-(Þ=ÞoyÔVíaAmÜ¸ññ^¹ËäÉ¼¯Ô¹Ñ¤)Ç*Ð³§ôwxÑe·/|¯{ï[|Ô(Øl*ow£AcÕJ<ÐýëdFø§-ÌýÑ¿|»\½wÌ÷¬Ê³s\ÍÖæNÂÜRaîÞ7_zû×Ñ_þèrÚ9UwÞÛ¾Rî_Û­ºlWÌ
s/s¬R{í{¾>ìxßø²(Ì¿g9Ýsÿúò{ÿüÍò@¯7lðpl~ÆÑåìG]×½±µ¿é®ËÛ>ye¹eÅV|"$@"$@"$@"$@"¤ÌwÌ]xþ{]1ÇãÆ¨X·° E_§¶`=¹:äðÜt§FAKâ}LÔ?Ôë9Þüô%yZìÙàÙ£ÌÔBàÑ¿­ÿ´µ6?uòë2/-:åæ£¯6è ó3omÄ§ìÍ°7¾úChÝÔ3H&Á <öN´íëG	¶ /}xÈ<Æ0zåækLlÍMËA¤Îüú¶ñißúëKìÅ9>lîLxHø6?rýhéR²>cf9aIWðZýàåë¯	v(Ê->áÄ2mz·òhÃõåúk¯Þ«÷Ó=TÆÓ£Pó«Ï;¥î¬y3'÷ÍoÂÉ­ÛÊØ¨´ÌPÐxDãm÷®­ü«ÖüÜµå@÷¯áæ7«üé+[Gñõkî.o½ðÃè/ãQ®FûåwüwÝ~ä÷Î®ìhæ¾ÓÊXÝv[ùÍ^x/tÕ-÷?ù·ïÍqLì.1{ryúiGÕB«1¥»î[W~ó½_/ãÑ¨I@"$@"$@"$@"$@"pp#Ð¼cîæéØ,FÑ¶DýAâæ!7#iÙ¨IXkhíB\ë´Ö%´oýÑCmÃ¢\wt(ý6?q¨Hê°c3zíiÙ¬+¡'uåm~cêKµó'?¤­}eøXg2º½&¸×Âíd´tN<È´­2
Q³µ°OÇ±;Ê(}u¢*ÓÂÖüömÍï1µq\Ø²óÍ{óÃ3&bÙ*ÃÞXÁV2¯cÅ~jlãQÿq(<Êò¸ùÇy^¹íÖ[Ê{îªüCý3¦+ÊMaQnC¹áº«Ë¦MÝcÊ$úWyBù=¾lÇ¾ü-ÔÂÜÜxgØ»~õÉ5,ïãÝs;£Ýgóz(ùHsGÏRÞöO¬i®½íþòç{ØïíSËôÉ|ìJÙW9V²ýÎû¿*ÝV~âGWµ¤?.»½¼ë3W÷ûÌøqcªß âÞs{lyÕ3NìúÞð¯ß)W.¿oÐ4û@"$@"$@"$@"$@"p!Ð[1wNLëÆØ|%³¤¶`Î"2xjðÔ%lá©]ÐZ§¶O­<¶Ä·fb,|%ôÔ/1¬oØ·En~d1Ñ[æB«°´Wo~ø3f¿vsþ´æ'ñÌ¢>VÙ^Á÷Ê¹çd[
ï0£¼¼r[&®<ØJÃÅÁ
b¥ÜXmmÜ°¡>¾rÓ&VÝî{zíOV|ÊÅÇTñ¤cg?;·[ÍÕ¾m¸ÑèþÃÍiwd#-ÌM?¶|ð·Î¬©ÖnØ\~ñï¿VÖoâã7D¬L|C<RÚW¹+n^UÞ+ã$÷©ý÷}þÚò_ß¾Õn¿}ÁæW}byÅ[/ÙéJ¸ßzñéåGNîÞ¹øöO]Y.¹üÎ¾2@"$@"$@"$@"$@"pp"Ð[1÷1»c³0g!úµ  .qÔÚ
Ø]R-Ê-¢ÜÌ^Q.
y¼SnÓÆ§(ÇàÞ¸£×®Ú¢PGqúã(Øü 
7;£Ýgóz(ùHsÄç¯<©ø(Ñó¿x}ùÄ×÷ÓN8®üI¼nÑQÝ*JWa¢á¿êqåø#¦×ñlÙºµ¼éÃßÛî84alùÛ×<±ÌÕW._UÞüÑïu9
:µ	xm- YÃ mý¢[kÔ%¿µdö=qÚm}%TÚ\ØÃxX7¾zíWkvòäw|Øc#9VãaËf^[õúíqKÐ.°!@ k' 9ùwÂ´æÃ ,~a
êº êè­³Øb>
^;ò·ñà¡v~ú¿µ×{x¨õ7?>Ä@g~úø8?óé¶èÍ=¹ãÏ9÷¼Ü²(D HD HD HD HD HÞ;æxåM±­ºï³¦@ý -ÌYO±v¡>>ôÛÚC[¬B¯?u
7äðµó#'.>þÔ9Ú|Ú©'¿²v<Ä uxãÀãC~ë?ÁV"?:Hxó}ß¸ÚëO^øI  iw± ÂAÃ3A'âäñXüà!xÈ´ÈZ°ÇÒù!òÐ×±°Aî8Mßñ[mô¡ô#7ãÇGÌO,ôÚÛ§ùÑé=¤×­qø¹ä;æ)ÛD HD HD HD HD HDààE ·bî¥1Ãe±Q£Búõë%ÁV.l¬Ího
dS{Æ6«¯¼¼ò;û³xÉIeÆ;Sï ¿âòËÊæÍÛ©§DAnÁÂEµ 7è°uërç·{î¾kPýD HD HD HD HD HD`¿D ·bî%1¸å±¹bãÖP¬ÅØR«°>låé+§î?õ	}íóêÐ[¡¨UàãÍylÙÂ×êßúr|äÍ{sÒÇÎñ°ÅrcÓR³1v!ªq±'§¾ù±Ûc"ØHCNI$8Ê¬ÂÇ6ú`-à`±£áÑAÎx6tmlm±³éÃ>­ÔÇüÆÂÏüÇq¸±A§q±9|àÍlåõ¥ãÆbÝÂsÎs«V»ÿÑô(¬Q:×á
s·Ä¶:6kÖ¬Q0x6kÖCZx|©yXçàqsÈÕiM+3¹iÉAìÐÛWGkmD]ú5xIÈüÄkeÎ9Ú9Ði7\~í9]#ùãF£õu2´ÄK Ài¢JÅ¶µÇOÀÐ1!£Xe>uô=èÚÊköi¡ÖÏüØ±µ9È!3?öÄAgZò;vâ@Æ4¯ýÖÞ¢!:í¨v-GY~h|åÜyùÆw¤Ý)Ì;¶LÜÅ£,:æØ2+VâA«VÞ[ß¼l»DãÆ/'xR<ÂrjÕßu×eÃúõeêÔiå#*³zE?gyå¾·ovD HD HD HD HD HýÞ¹ÅØnmMlÔ
9x'Â¾<6òúÑ"gâ¬#cck1LÐci6Áa1ü Z6w6­s1ùo__|þ´ùñgÛâX1÷áýqÅÜÄIÊÉKO+kV¯.<p_l÷%'.-&LØ­GYÆÜvIKO=½L4¹ÚÜxýµåÁxgÜ 7.Þi7¥¬]Ã?"ä§ñÈX=×AzEæ6çûæ J.HD HD HD HD HD`¿D ·bÎwÌmAR²°F­ZÄª³¶>µ
ÔWA´ÔÐÉ»Ú:ì!ú-µ1°±¼íãc|mmNc£7«s´m«ÇßúzóÃCØ²YÏÑ±Úüøßz}ííg¯ #%%<w¢àd]ÛA9cA'ðlm;aópÍO¡Ù¼´cÄ£/ÀÎÃ¾¹éKÚ¨cÄ¹s³±¨7.­[°Ûå·ß[ÇJ|þÔØæÇ¹ì+æä Vaîèc«£$þÝwÝYî¸ýÖÁTÙ_rÒÒ2mÚôú^:e¹y3JR"$@"$@"$@"$@"$@"°ÿ"0oîÜrÁÞÍ£,omClÖS,l9xåÔ) û´Ô $xdÔÔ!Ãú¶è±Q« z}Í¤z¨íÃcÇ¦¶åñ³æ¢-9SwaE zcGÛV½m°§mÉüÈà?~ðäom¢»çD°À8Ië$¬Ì§{cª;×¢kI S{âèOlüÐÁKø
zxÇM;dØ¹øéïxð3:|Û8è!tbAQÏyÐBæ77¹/>÷¼[¹ê¾j°¿ÿ­ÂÜ)§ÑÿÜ5W]QÖ¯_·GSç=sæÆSÖ®][®»æÊ=òOãD HD HD HD HD HDàÀ¼9³Ëç¿÷%ûØ(ÌQ ¢n@-:¼rk$Ö-,ªÑbkÍBÿõ	í±¥¶V?Y:
>Ô<SßUrLØ°a¯-}ôÅÚ1lã=­õ#â1È\]¯ë+Ãxôil¯ÉÀ{ ÛÁÇIö¡¼àÓªgRòÚÞ|¶ØA¶]oè¯vÄ¤àEc"s'Ðb!g<ØA-¯ã3/-:õøµ}b£Ì¾±°%§ÔòæéVÌb²¤¨vâÉ§T\ö´¨F!nÎ¹å¨cGjò¾Rî¼ãör×·W>ÿ$@"$@"$@"$@"$@"$û3²dÕÊ`áÊ¢-õOÔ*à©E¨gCÌz2Húøêé³Ç:JßØ´ÄÐÖxøËÇ1ÓJØAÇ1XkA¯cb<ÖX´E?ÈÓw,m;¶½&á&àÄtâÐâéã#ÁÖ89w }Ç(ôÍ£N;+³ÈÛüìÈüöÍÓiæa.bÛGlõm~ì¬ò¸ØRlÉù3lÛ8Ø!'væ'}ôæwÌ}øPzÇÜ1ÇÎ/qdL½Ûn]^VÜswåwõgÞa#:¦?¾®Óö¾U+ËòÕÇY*Ë6HD HD HD HD HD Ø_èæxå²ØÖÄF
ÔxæCn~äð´ü ¼§Ýn·mðÝvÆ8Ð¶rÐÊ±aâÚ¢(A5Vú±Ð·`­±hÛöm^ûì8ªV¯zwzÈm~ÇÔi»\Üú s	Ýpñ±ôæ1æ¹J¹SOD]í¶mÛ¶²»ï£(wÔÑÇçvtíÕWuëöì1ÛÈN"$@"$@"$@"$@"$@"ð0"Ð+ÌýT¤¼56npS;°VBMÁÂ-5w)µöÖH¨@ø£§?D5b@ÈÉe^ú~>nÓøø¸µ>èyBÔ:åØºËøÆ¡%;?l!}ÈïXá·s5:ýÃlï#%¶@æ¤Èá¤»S­ ÑbëX!_ú-ò!î?kÖüÄ#'ÄÊ5vã#®¹hñA×Êÿ{gowQÞïQ$!,¬!a
jE«­ZÅZ©Ê¾'!@Ø!ü¿ÏÜûLNÎ½ÜÜä}?¹3óÎ»Í÷wîEÏ73?òfLýCÕ9
z7ì&Ýh;×Gü¬Æ¶ÖOîüêypø³®à3gL3o«`±6mõ#¾äAõ6¿8tÇaÞ-øÃüÖDí¢Ísÿ¶¥Û}æì²ãN;W-¸¾,«(G#&M.{ì¹wÙj+à,åúë®)÷,¿{4¡Ò'HD HD HD HD HD xÔ<1÷òH¸(ÚýÑä=$å¬LSh[Ë=à/=sD~|Þú»Nôp!r¬uÏ±;al~lÍâ1:ìÉ¯?ëè[ñôc¦¶ÖKüÄ@èç\yÌOß¨_qSÄñ!pCôÁ:=övQÆj7(°ÆÄ¾}hæâÂ{âurYG«-ºV×¼öîÅÚ<Æõr¬uÛ»Wú6>Øv1C~Æ¼cbîì-à!qêm\}'Üe\\zG8::mz=gnu^§ïnáé»ÑeK¯D HD HD HD HD HD s"'æä2è!Çà$ÉÐÉ0°1Çuxôèä)ôUo\8tøµö1íä7&:ó3ÆÞxôp¬5ãQ¶ÚkKïZ«X3ûÖþò,æ°ÇulébÏÜèµ1>ºQÁGå<èd{
el1G/`êÔÛ£Ç¹â}÷ðÔÓ#>dâ°èg~}¬Ñ{l#Úµy©MÛcoþ66èyøvèèzãvæÇ1½ÄÜ¶bnÒäíË^{ïÛ.eÅ=÷ë®½ªGûÓrüøê~ÿý«Ê_:ÚPé$@"$@"$@"$@"$@"<*;:ÝMbNB®%¨^¡»w`¬°&?Ñúk#?AobèÇXBLt1´ÛPËbLÇø¢Ó=¶ècìV=Ü:lhÆ §á^ÑÆyëßæÕÇx¬Z6ê á( ÆbNQn Í¶èð§¹1ÆØ ´lf«¸Ð>Æ¶7N5üáZëOæ4Äº§Í¯-vèS#µ06G=sm#ÖßÍoò{?sð¹=ãsgo	ï9kN¾ãNàTnZ|c¹ãö[ë¸?îÐòÇ<¦<øàåòKÑO¨ôMD HD HD HD HD H68Ó§N-ç~ò+"ÑÂhspò!ð4çôÌ4ù	Ö$Ôà8´Ó±dc|é³åN~li
9â0[Q¯-½ùCUuØjÎÖ«®[7~Û9<ñÌOóë£íÑ­³¼_1ER»1É'ôêÓÚArá/X<u?ëÆ¡ó·óXî_m~ôÌÛÚÌeMäkó36¿µªÆr_Îé%ïÜ:ÅX¬mÍ!ëèÌßÖy!æö«,ÏÚüOÌ=¦Ì?(®±ÜJ¹â²KÊpuîð²Ë®3ÊÝw-+«Vñ·iM?aBÙoÞüª¼;®²\WY®	PÎD HD HD HD HD HÆ'æ^-ö@4¸¸±Mb/×±Si	9øæ1ãâÇ¸c_/ÒÆfÎ>kä`c
rèäLàà%à!XG£×}»Î;üá7èË CðgÜæSÁFvb~ùlÐY3ss¶>Ä×Çü¡ª¢¿û×Xëèèµuª5Ö­=u¬/¡7CLc»Qz@h0:|é±DÀÆzzÖÜ4s
zcÄp
½úÖqwd¶mLÇöØjO5tæ!:øÖ/¦uÞÝã+£=6sÄÞüØ·r¶ù±QïXÛvNíÖ¾s·ºIÖ¯H*xJa4×9íÕÓÎCa¢q|hÆ`ÍÓc¬Ñ¼Ú15?¶Æ@ÇÝ6ÑÈïz«5ÓÐ#ø"Ì±ÕüØ±N\zÛ8Æå¡kç:öÄÀ;ãÆ°
v®36ûÅ~Ûh3ãsç.ÝDNÌE½)@"$@"$@"$@"$@"$@"0J¦Oï;Yb+#ï¿ w  · §!ÏÞëô4|Y`>¼
µpÖ N")ðêËÍ¢×¶:Æl´'¾¹Ì/ëÆ¢7?=?ãÓK½ù%Æ°e]ó£§!æaNÐ{?Ö¨1Íº­Ok.òãÝhs;;OÌ)@"$@"$@"$@"$@"$ÀfÀ 1÷Øæâhs¼± Á$/N>=ëð4^.B[æ4âÊUÄ°Ã '>¾ò$1¬ùá1ÌÓÆÀøø!mlìäGêbü@G|÷áÐá=6æ7>ùÅ!Õ®ãX;1ôî¿*âñßº´Yç@ëC| Ä2&=kÁt
¤8lAi8sºaÁÀß
-ÒL.~Æ:s61Gà#øý;m{ôÄdÞ¹9YÃÇF<s C°E°%/=qi~l?;ó³ûg®¿¹1íÍKoMð5bÃuîWÜ8Å[:'¾ÕÖ
ÈñÕäúk¯SGË3¯ky{ì¹÷v#ÁQGUïC/^\þéÿ¹ýqh¼GëåïÑâc¼k,%HÆÞU¼ï²ùêW¿Zþç?ÌÇ´HbnáD HD HD HD`F`ú´iå¼ÏtLlâúhüËxÄ~`6À´zxçp­¸FÏxòð4NÒaÏÁ{èX7öØ(êíÜ:{ÙbÓÚÇ9¹ð5¿'ËÞ¸øµz×éÖ´­øásüÝvæ·lF%ÝIG`(ÖMZ¬´Ø@òX¼ÃÞXY ìÜ¡ª"`öøj­~Ä¦±nî=£GÌAOþ¶Ö±3suØÒô³§k¡7G«=bÝôzm<Ö±3?y'FsÄq¯;sé²»b8öåY/ÄÜ	Ë¾ó¨~ðÁÊåþò7¿õÖ[W¢pëq@»Z61·ÓN;Õ+=5÷ÙÏ}®\qÅÄoëwuÈÙçS.¾øâÎZ÷`úôéeîÜ8é§¬ø ,÷.ÝpÃ
	þÁ ×Q.Ï¿_ÿOãÂþù¬*¿õüç½öÚ«N¿õ­ok®½Ö¥ÚSq¨¬ÚÏÝÆ]6×Ê¸VSÝ²®õ¯ÿýûÓÛsÏ=ËÜøýåï ¿ÿ|oÏa·ôûûC¼~ö?ÒwÌÍ1£¾_«lyö´n©W/ï·_álsºÿÜ»ø»Áß¿GúûÙ/ç@"$@"$@"$@"°y 0}êrÞé§x%_AñÕ1_xÑ«çË_Æò(^UIß~I¦¨«0Ç/ÑúÏæ	U'?côÆhýÛ8¬c§8×½´$\õÓ1~
>ëè[cË?QëØ!ÆÀÖZ,µ5~uZ×^W¿Ö£Þâ»ç ÆE³Qzt>$Ç±Ü_k¦×¿Ío=Úá`à~mÏ>êÝuãk]ö®Ñãßæw±ÌÑÆGç¶·còb«,¿0¯²ÚÖõEÌí6cfÙyâé¶[[n^¼V®nÅs÷*;¾³îÛo+;î4@l(bü¯xùËËðZ
_¤~ü¨ãýâÖ×¾æ5uiö÷þpçýªüÁÌÄ?~áüV .»ì²òû·µ¾äÅßô¦jþãü¤|ñ_l];ãW¾òåñ{\ÿíßý]%`:ëiÀÉ/}éKË~ûî»Öx7àÂËÙg]î²¥[æräGT2¨{9_ÌùË_.·öørþoÿæoêØ0üÔ§Ê«_ýê2w=ÖC~®%ÜP' ö"ëø×½nígø¾÷¿­/äûy~ýÞ÷Ö4|á98®!£¹qÕªUå¹ÏyN[JùAèÿ}ðÆCã3ûòøÜ!¼ãíþ¸nóÙ¾ÖóôÿK.½tXýNº9òþ¬gÕçÙÆfç©}m¬½ãEñÇßøß(óÝ² >{_øÂÖ"®ÁìÄNè6r~Â'ûî»¯®{ì±å ¬¿ïýë¿îù{ÝÈ;!ìÈÑ³âwAmýëÃcÿþ´Ä§_ýªW¹V ¿ño>Ó­ôóûc~ö?bîIO|b9òÈ#;é.¸ |?~×ZÙ?óÍäÉ[ugùûµðûÑ~ÔÑ
Àç2ëK.YÃzÿàµ¯-<ÓE|^ /NÜ}ô£]î{ñ_\þ´§Õðÿø±%KÔ1'Þò·­¢.êõóÆÉ¬wýÙUÿú¯ÿ*ÿ
X«VOÃª£çý¥gyf=¥Ùêó7ßþÞ!³9q$@"$@"$@"$.ÄÜ1±ÑxÇ_Þñ±9<=Í/Õªrô§îüÑWþÇôÄ§Aó£c0ÆÇüÍÃyüôöÑëÎ-½sÖë`n-Ä26û06cõ1¬cæ­¾Í:I|»C!NßÅy´qãÌY(A5V¨:qXwÓ8Æ`Ag.âYk±UÇ:6¾1é×ñ!ztô­-:D=¶øX7z¾¯^{lX·füYmVsgnIÄÜÄÛ}öÛ?¶^êI£k®º¼ú±õÖãÊ~ûÏ¯'f ®û_ÅIù
/dÉ-7[Ü\IºGãäÃ¾óSsM^Kùÿñå»ÿýßµ¶öïãê6åøÒ¹ûº@®ËãÚ<åsÿ|¹üò÷¨qR
t4Æ4ø	zì¾+­Î==kÆÕVþXæ"
Wü=sÞ«<yrùã¸òÿv(¼k¢+Y¯«@sêÏcJ"$@"$@"$@"lÚ4'ænÜÍÿÃO©AN.1üDÛäj°Eo¬v|õ3®<qYÃaN;z}å7Ìa
¿û¯xùË«#'I_'¢¸bð¬x?$W"ýÖß¯?5ôCLáß¯ø7p4Ä\?¿?ÖÝÏþ»9Nþ(=§#=]zÃåäøÛÎIç
'¤ðøÇW¢±Âu¯Ìä¿)@"$@"$@"$@"°e 0xbîèØíÂh÷GKðÆ6y	Öà Áä#£Ã¾9¢zÄ¸è·s}[;øôôm,rá«NBk1\Ã1'zÆÄµ.ãàkNuÎåcðc!':×Ý¿ùñ§!Öo>ü£ï[LÒO 7kñÎ­M»æF¬ÁÀÆXS·6>½qÞ|ÆÐõtsQ¯czìZÛViõØÑðØkók
{Eú­¿_jèÂ¿_éëç÷ÇºûÙû{aÌÕpÅµ¼/|áMQßÉ»1®îíEÜAîýæÿûåEñ·_¢Ââ8%HD HD HD H¶ß11·(ÚÊhð^1ìÑ!¬CJÉCØ³·á;¾ÚÀYð/á,°g[9kã6¤<¾ÚÆÖÅ1ùAoþvÄ¸î¥í1":b[gklæÖÓÝëC^kE×î-¦ë&èW(H(Ú¡C,¼}`íÆÝ"­ñ±|l­½]7?5éþè°m^L«!Öô·>|ièÑ1ÆÖüÌÍ¯¶m~ñÁýcXãéO~DÆÆ7¿þØnmöqåcÊüâË­>"W\vI5üCÞÂÞ[m5`ÛËbëq[ýæÍ¯K«âúÊ®¿¦y÷DÒötÛ#ûíxÝSßGÇõw8ë~w'Æ8-äÉÿùáËW¿úÕZz{æªU«ê<ðÀÛj¯Öda}#ÿ_Åûî &ñröÙg×q÷)_.·õ½ê¸ãÊüùÏw¤qa·àÇI&	ÌÍëçù­obÜÿù¬S÷3hOf
ÿ~¥b®}f£ýû×Ïþ[bÓÎzV>ê¨rH\eª|%þfÿ0þvwÿè÷òß¥^rì±ÇÖ¬ý[üüi¿½üR$@"$@"$@"$>Ó§N«,Oñ*K¾ø0csáh_~ÃOÀ;0f]Î#Uôg¢?¶þpÄÑøpÄêå­	c9V!.¾Hk@31ù°5?:üÜ_;¶vtä0ÀFþvÝüÚÒÓz×ñ¡u×ªu¯Woëv3XÛ²@è¡}@èØ=ö
ÓLÏ­
'ç 8ç=ïyåÙîRé~b¿õ÷ëOaýSõ1è#íh,¹ýGÌA¾9elÈØÓN;­\Û\W
WUB@bí³÷Þb¬ñK_*?þñ5­=¤ ä aðÝï~·~qË½Ïyö³ïÁjåCÿ÷ÓyëK8÷ª ÷¼ª¸8ºêê«ËÒøRwwí¿ÿþõóÀõ³äðÃ/Ïòá³òíï|§~AÍi£]âèÃõ¬2sæÌºîÍíóÛÄóEþòJsJóÐ'<¡¤¬-^¼¸N-1~´ÒMÌò÷ÇÉ7Hn>;
u}ñ_tZ{ÖÿÕ¯îè¨ÿÂü Üï+äúÖ=÷Ü³<å)O©ûásÅç¿ûTªÎGÇ»Á9øà:]±bE­Û½"qÞeÇÕJ{Í&ºïÄgøßúV]ô(.÷@ÞõÈ~ëï×¿bªn²Ïýs£ýý±ì~ö?1G|®6åÔ¤×s
¿ÖoÛÛêÀ­Þ1äÂ)SªêqgQ¦XÎ¯}Ík*2\\H®º¼1/¬ùâ/°¾è³þMçâIþÍßåË¯µÍÑ>¿
ï¬ ¥§{I¿õÖßÚ7ÖïÄ%7þ± ÿh @ús¥*ï`ã÷·û=£ùý1O?û	1Gß#gNNt~ík_sZ8YÉÉáÝfÌ(â÷º[®ß¿¡>{­íÎ;ï\ÿ¡§ÕùÜé¼óÊOâiJ"$@"$@"$@"lºL
B'äÄlI9|¨ÇÏkt
U]cîF±Ã5tWø«aÇ§Ý£qÈo\ÆÄ0¯9°µNâ"¬¡3sÄkøs¨±ö¬36qÍÁñ¬+U°Çn»hye$$@"$@"$@"$@"$@"$?Ó¦N)ç~Ê1±ÓÑî@[Oxg@'YfßmÇ=B-:x
ÆèÈËøê_èc^yìá9Ú¸úêÇ{8ýYCð§®­WÎ8Ú¢CèÕ·ñ°ÓÖxÖBm£÷+Ol"{ÔgN7ìñgLs­Ý´ëæhÁkó³Ncx\óh$sÆÖOóäv½õEßËk6OÎ±ýÌ16ùôu]B=ö}d\eyg^eP¤$@"$@"$@"$@"$@"$7ï;*v¹0Ä×^Á pYJËw°ÆÁ§%½Ð;gÌºþÌË¸N~®ÆÛ@Ì10Èå:b Ø:óWEü þ¬1¦GôÇ×k6Åiø`£=ùÑ3'.sÖµu_¡êèôg­o!Q¿BAÎ,
Mµ`to½gLs©9@ª7W÷uH²_@éÍ
ÆÎ]Uæprr.è%ÚÃÁ½öôÆf
y[b»IÑæÄUgäUDJ"$@"$@"$@"$@"$@"°#0xbî¸Øæ
âÜÌÅ¢£ë®;¥«qO~ÅâcÑíF&6Ïa ¾ÛúêÞÜoÏàWãÄR]Óyw,æ>`â"Æ§7&c×a~|Ð¹WÆºö*Kb ocXâÄ¹qbîì±~bnû¦ÝvÛ½0!J¿÷ß_®¼ü:êÇ{ï[&OÞ~¨åµô]rqùÕ¯$Ï<øqe«­ü½[Ë¥£»ö«:ó$@"$@"$@"$@"$@"$cAbî¨ma4OÌÁÀ=È¡0¦Á)È_´ëèà èÑ3öví£'f+Ø#ØiK±ùéá:±ùcX×Í×ÓØØëñN_Özü
cb m,b¸Ol«µaìQAú7M,w£lÄõv#í»Ajqî¿VZàðP3?:DR"u}µen]½êD­-U#øÛöá¢§ó·ñ;×Þz¬S;ó1·19ß17)5¹Ûm¥®ssæîU857yøáË¥¿üy¶Õrðã-yÐ­Öwî]±"¹+»Õ9OD HD HD HD HD HÆÓ§M+ç}þ¤c£¨ë£qb/Ç%bX=¢z_«w_1öèÃg<8Ø»nêÛ¹½q36?ö:sìäQ3f/èÉßÖG,ôôÆ5ú¶³5l#Ø(øæGßX`?A$Ü¤ÅºIx2Å»1ì©ÀÎ©¯àÚã«=¶úÆ:}/±.sÐKªY~Ø!æ¤'&=ñiØëO=ÌÍßíKUôa-þÆ£GðosÂvÍ9â¸×±tÙ]¬)6}Ç2kö=k	1÷ØÇ>¶l3ÌU»ÎØ½ì'ñeKï,Þ°F®­¶Úªxðã«îöÛ[,Yc½@è=ü0+%HD HD HD HD HD »L:¥wú)^e¹** Bààhå/øþ[8	I56ìô¥wÃÊ½`¿<sù
Ç­¿cãüøÀyÐc+7Ã:ÇO_ö¢=cýðqO­¨ëþéÕãG<zò»zóÇ°éÍÏl¬èF-êWÚbE­80Æmñè¡Éq,wÀsóèÈKcbXO÷Þ°õºHýè}ôú¸ªZ/9òwç1?=þÆaÇ1¾äGcoMì5}]Uó3q1ÇUçÅ«,·ÙvÛ²ß¼ùÓhËßíî²÷>óÊ¸qãFteÝõ0?æp`ÙvÛñÕâúk¯.÷Ü³|
ëcìZá6ôæ³0ùa~mÐiÇ[bÒÌÃZ9Ñë4ò×æ¼­5ÅZä^ÐßØÖ¢½uµú6v#îÝÐ0$P¸×Ô¢kãÆ³Pj¬PU{zÖÝ´à #1£C¬A`­5ÆØª£ïoÌXª±dz­=>æ±fìrHÀ±NCô3?söØ G´gl~ÖÌ19Æ;sK#æv1³ì¼Ë®àRn»uI¹åæÅuÜþ4yrÙkïýªjáëË]Ë¶Ë9ND HD HD HD HD H69¹WDá|1~_4x
ø9¸9¯ ©&§Á~¬ÃÏ ð¬ÁY 31±ÓO¾FC=s×ô%ùcØáUÌÏº5CÎÄXôè¬9¶æW¯,U[Öñk÷-¢ù±¥¡7?{PGl}b8z!`¿B@P(:$ RIuó·ã^`b' Ä"=~^ÉEÎ«í6±fþÖüÄÆNPñEgmø²Þ8æU'?q=gÆÁ!¿ æ¬·y­ù­MLñ#>÷8ÎwÌ3ß1GÝ²¾NÌqE¥ï»êËÊªUüíYSv2µì1w¯ª¼áºkÊªûWIÛM*ÛPVÝ·²Ü{ïòÀ¬é³D HD HD HD HD HD`#0-Þ1wþé§%.Æãpðð`rðí8¦{ëÀ`L`ÝÄàËt8
tr%ØàG~Æð#æÇ¡oÇØÓÔ99ÇüØ!¿¼ùY7?còËÿX[¨j.ìÍÁG;sjCÚ´AÇ|Ôb£Ä z1Éb±·	º1ðÑ{í¡3F £ÍNðuA3sÁ4v=yëGüv®=¶öøÞºÐ¿Ý'~ùÉÓ8^eyötbnâÄíÊ>ûí_1Z¹re¹æªËÅk~ÚôË¬Ù{¬¡k'¿þõ¯ë)ºEº½µÊq"$@"$@"$@"$@"$@"0v<1wTT´(ÚýÑ$ ¥Ziçp
|­|Ü:}ñcMD^Þ-qà7ðÇÞ:bXçæ7öøÓÃÎüê´§7kæoÁXWÄüÍ¯sÖô%ùÁú¨ÄD£rt²0¦l¢-Ò
Êje;IXÂ}	àÿù¾3ßË;{'çñóÎ9ç9Ïv~ï½ysÎkø1FOÁ.zÛP5~Nqô%ó>( Ìaã
r¡íÂÐ!.¡dñ}³Ï¡´ñøoÑm@tÞüÔ$ø0XõÍaëCèqÖÏ¾ê7?sÖGàÏ¼ë0?:lX¿þÑmêB·Z\uýÌßÌ?ïÛüùrå¸µ×)Ó¶ÚLÊC>Xn¾éú¦ßËëoP&MÒ¸kîåî»æö.}D HD HD HD HD H¥ÀÄ	ãã(Ë8Êrv\ÅçHÉ5 AG_9¤&ô× uÎ¾$ñ7&}ý£ÛâhôÁ¾<6üý:cyúæGg~tu[9ålð'=o~mi¹Zçñáj¯?T#Ì«³u½,íBTôPß t,{Å=àÑ2
p.<}õèäTàEàj~yô¾ö	Aôúò&èô3¾ùiÍO<æ±%&Â<zÄ9úèmyÄüÚÒÂ¯ðÞª:>¾ÖKùì¹Óâc-­»=§ZÂ|xBà^ÅE1KëÅÓGj»zñô¬öÇ^úÆ¨Á6qã¸ÎY6ìÌ©õ¢çÆ£§O<mAO>Æ¬¾c}BÕÌ×kÆÆüôµu-§>vÌM9ðÐ#N·`at}é[©ÌØ1±\8yÜUñ>8ÎZv~Ánåá*7Ýx]GÃm¶QÆåU}¥ÜróåÁîïhÊD HD HD HD HD HD`Y@`âzë³¾{GYÞ×ÃqÁ!ÈCD·E&ÁmÀ+ òØÁ/È±Ô¶Ìë'O-bK>lµg\±ù±3ý Ä©ýSb=æq5ÑG
Bnn¹ïÞ{Te$@"$@"$@"$@"$@",Óôï;8»Xà)jÞÒ
N½vÎ1çÀAxädâ¡ÃÎQ×7zæ§zs0c~úÄÁ¸\ÚßZ°a¬öcócÃ¡5>>Ä@ê|úakúÄeýÆ`Îæ¡u>ºÝ	FCCkQuÁ,À©¾ËÂk}#¦Z$`¢#®cr_â1Ok,ó{ñ±¯}×AÐÖqÔyü­8ì3¿vÔáN:âLê¾ùÇã¬}vÌ:oþòñ¹¨÷9VZ¹¬à1cð=ñDy4ÞU×åsRR&MD HD HD HD HD HF@?1÷æpdÇÄÜü
Ü|:ù½§àBhå£9¹
t1Ï<|uÀ{ÇyçSóÄ0?}ylkalâ[ëÄubbè61Q×^ó[7vñ£çBgíÑ¹Ô	Fîý²cÒ¢c1é\¨ÉØÒÏä<-s6u_|æ½	æ×yc×:ô:bq½9Ñm¤9iæY'1ÈÏ¸Îßxèç$â£EpFã¤$æ,òG"$@"$@"$@"$@"$@"°Â#ÐåÁ±Ð[ãhàK¨uöá*à)$¶cÏ|í§
¹Qs*ÄÂ9ýõ#¶±¢Û¬bÐâSû[£>Æ
UK§?s=z
¢p`QH,ª^ c¤}¡è]8}.I¤zsµÏY$ùÖüØ0Fðclýä©9kDo~ZkÓ}\õZÈsÄ3»?ckÄù¹ !%HD HD HD HD HD x¾ Ð¿cîXï¬¸ æààOä èÃ! péËsÐbÏ­ÄmûqybÈ}ÐGc'ÇbNrÐçbÎøäcÁ1Â¼üõ¾ÄXæg;ZçÖ|´æ2¿uágþ:9È/Ñ¹ WqqM¼ºpÆ.V[l«¯d0aÑikæ¼ä0-¢=±èsÕ6ÄRG,ÆúÒjkº%&>kÆPW¯ú\Kt[1ÑiG×b~æÍÝfäY;.²<mÞüèSD HD HD HD HD HD`F ÿsì»-®Gâ°bÕð\p¶pÚx² s1ÕØ2.>äS=F/B_¡/A.ÄÄÂXvÄáRô³V|ê8õØhb3ÏØ¸¶¡jæ¥-zla­Æ tÛó/LF.&¹ç3uÄ£ ZGZ¨cd
ïîÎ²úêcË:ë/c#ÿÊ+¯\}ôÑòè#| ³Ã
ª:uj9êÈ#[«;öË_.sçÎm³$¥|úS*cã÷Ä'9&~·ð+yùM6Ù¤¼ÿ}ïk{×]åØc]¦
çþò Êzë­×Ôõ¥/}©Ü}ÏÐÿtËóýéZýôéÓËÞ¿ëî»ËgQî¼óÎ¥n©ÄÝaÊò·¼ ýø¢§ÊßwQÿ D¸d.1wç7Kô£%ìÂ¢ú»H.@"$@"$@"$Ëã¹ÊYß=î(ù¸ø]ó Kb)ºøÀ\=6\è¹äÔ;GÈ¯{tá3õ·ÎÛºíØÖ¸é{cìäQÓg-èÉ_×G,ô´Æ5úº
UáßÈSN=uÔïñVûý·)¯xÁfMø__=·|õ'3jåØÕ9->¯Év/Þ³¬ä³49rw[ÿ`u§>HD HD HD`Å@`âñå¬Nð(Kz Bàà¸ìË_ÀWÀ?`'!©&Ñ¾´£Ûp/Øá/Ãcj_Ç¨ã_ÞÑb'7ÝfL<c²íéëùkÿP7ë§UñhY¿ë 5t>­ùéãS¯èº÷*C1
EÖâÀèS´Å£$û1ÝÏÅ£DcßzÚ×FN¤­7VçCÕÔ-Bþö<æ§ÅßÑmÙÒÇü}ó£cý´ú:ªFÌÏÀ>ÄGY¾¬e9.5¹5×¢Ôgd8ÄÜ©Ó
»æ#±uõè¸«eÒæ[×{vÍ)?ôP¹éÆÑ}0lìe­ÄÒ?ð²Új«îÃ¾øÅØ5øà²Væ2UÏ+^þòò²½¬©éÞ{ï-ÿ;|§TË]ó\à¿<;Ë*1·ç_\^÷º×µ><òHùþ÷¿_®¾æn´:Ëóý-F#Î{ìÑü!ÿ^ üÛyÚi§+¯úkF#÷hÅ³ÊÊå3µkºÑÚÍïí|ç²rË]½ÿ÷÷½¿ðº¥MÌ-­úGß$@"$@"$@"ðÜ Ðå[#û¸>£&®ààhyÎ­:ìxúèiÕ«ÓÏ1öíW¨?rÁ±`kÞö¶ÎCßüÔf_ºe±b
¬]W1zâÃ{Ñ;ÝVnô~øÐ;.	¹è¶êiÃ:õä%F»Îu©·Eï
wñZ4cm\8cæJPªÆy-8ècúèkXëb>¶êhÛã3¦X2½ÖóX3v
9$àçBô3?c.ì±AhOßüÌcíè³cîe[mõÕË6ÛÎ(ìF{àqÝ_¶¾móÞ¦ás,z(Ùvû
ïCn¹éïÛf»ñN¹¾ã3gÝzs¹á!'r¼ehî»otßo4 IÿàÏ_¸Y9üÛ4£]<»tÞÍÌR·"ð7¼¡ìÖ¤Ùâ]B¿ýÝïÁ*WÜügbgY#æÖÓìÒ7n\ó!7o^ùÊW¿Ú¼¿oi}jçû·´0é%îøñãË{ßó÷ðKÿöoÝK®¥åû§ÛnXöÜnÃòíÿ½±Ü÷ÀðÞ37T-Ï&1G£]ÿPkË¹D HD HD He~bîMQéíq=<ü\
ÂWTÓ`N?æág3gÎÄÄN?ùyõÓXænW1?óÖl9cÑ¢³~ÆØ_½þ1ÕØ2_½>l}Ì-zó³uÄÖ'ºÝ{
DBÑY 9¼JpÌ¿îw;%D~ÉEÎ}Îc2tüÄfNPñEgmø2Þ8æU+?qÝgÆÁ!¿ ÆÌ×y­ù­MLñ#>¬ÔäxÇÜéËú;æ(Ù~G«w»-ZôD¹öê+ûT?9FsZ¼§{.jüx0xÎ¥·-õrÆÛ¼m°D¼ïÎ;ï\lcË6ÞxãFÿP«óçwÞÝWÛÝqÇå©§øh²Aì°`WÞÃ?Üè¶ß~û2!ìÎ÷HÝrË-
t´ÌsüôáGÌB[÷±çRO<Æä¤OócC.üò2ægÞüôÉO-ú3hgìZïôÑ1?µiq×b]Gb­1Éb±÷tcà£?öÚ	B=¦ FàÑ'ófÆi,ìZn26ãÚøõX{líñ7?­u¡7½Nüó§=q<Êò´eqÇ¨ÛÑ"æ6ÙtRÙp£>âè»ï*sï¼½NÓô7wÛm´ñ&Mÿæ®/=ïQÛpüØ²Çô
r¯ï¶õvèºýþ¯SûÒ¾´ð
xñ¹Ï¾E¨w²¯u|øCåýÃ!æÆºË+^Q6Übêbß?Æçw~üaÌeçü¤<ÿ¥$@"$@"$@"$#A ÇÜ[ÂgN\üµ»$QßÃègÕc8xlåäÔésøØÂg0ön~ì¬#ºÍØüÆ ¯u½ºè6ÎüýªÆ{lÛíÍÏ¼u©ÇúÑ"æ§OM~ÕáCZ/æºu Q/¢-Ò`ÃBÀ¨ÁBO~åâhÑ3/ðÑ ZmK\cag~A&¾ùþ3ìÁ3ë	uk-®ÉµÐr[k%züÖ`}æGOÝtÄ"?b,¹oÄÜv3vl½îú×ÄCþ(` L¾Mì0X»Ù±uõÇäc-×âè©Ø)Æî']"Ì
Þþ²éåÕ»O.=ñTùËï(?ÝqcÇ¬R¾ü7/jL>vòïËm÷=\^±Ëfå»M*Æ­^¾wÁ­å¿âMY1G®ÏÃÃÒZ¦1÷®asýõ_m¶é;SbÝÿØÇêpÃêSµ Éñ;ñxøÜéá4ó<äåôïÿïÿ1D½o2L|+ìúë¯/ßþÎw
$ÃhÊç(E /Ù±¶Yì@L¾üïÿ¾ØÎIê?ü°ÃÝ:ú±;]¯
»Üþõ_ÿu 1!ùþ÷½¯°SùÃþPNOäcÈ/þçÊÿÄ¥þÆê¶Øy4HdÈÍÍ«í1!>çÄ;Ó^¾?Æèåþ-{ÉK^Ò®æúßÿýßrî/~ápTÛ$mì|ýÜç>7lbß%ï<ê¨Öçd°ÂøÝñ­o{Àg¸ûGWÂ,Iø>p¤£¤²ö½Ü?b°ËøÐx¯¿÷ø?úè£ÍwJ¹h?5JvÁ"½| ü`å?|ô£Í\`ÂmðÇC	÷ß%üZ¿N?ýôfÇðP>ËÃÜ¹Õâ=¶{Å¯¬»=H¹Î>«ÜßàÊ/çD HD HD HßT;æf$O© ¹^N$ºM_-¶ÌË CóàÒË¸ò øµùI<üå7è«3?:bÓ*äG£=10{ì¬#ºM\ybÕ¶æWOnó3±FëèÓvñÓà]¸¶\aK¡ô-CÆè)ØE SoªÆ±Ò)¾ÄbÑG9l¼aæGc[úøßVíÔi+¿ñ\§uià¯½cZó;§ùbnr¼cîyµcnÍ5×*Ó·Ù¬ríÆë¯múí?fì¸K³Kãø«~Þ!Ç.»zçÖÿøt¹/¸ßyÇmí®=O|ßÞeí5áy|êéòûæ?Ù¦ø¿ï+ÛOPÆ®ÆG­Oæ=ðX9êë¿s8*-ÇInÇÕµ;P8j
ü<|/Ðª_ÀN©çìcCV?Z	/çCÕzxyÄuÜ:&6u-µ¿y±QÃ:Qû¡'í£-öúF·çÐ'BX´-1k&ºùa°n|õñf1× Ô¶ö±Ñþ\.¾qd@CÕs MßÁ¤àã«ÔöêhÉ¯ØÇ{ÇÄ®wÀ1g<ê¢ïM§O~ÄL=b½Éa_?q1?qÌ­>kDj¼cîçÓ;æ6ÝlrÙ`ÃbéAÖÜ>'Èµ¾#!Eõc§]vmÅÃUÞ[ÕIî¾kn¼/ëNS]ëvÛjý²{O¹k´ë®5ØFÈ¾ðz<H»ûÊ%7ÜWþpËÒ{çX½¼ÿý­wÈu"æx¤
Ò1Çn£Ï|æ3Í{ÎvÞi§Á@ AÂñþ³ú¡-¤×Ì3ìÃ~vìF:áùÈ±hûÞ÷6ï]Â¦}×ºÑ£>º¬Zù}ôþa;~ØíÂÑÊÉAÚ´·¹c¼êxÀ®|ç»ß-×^ÛdÖf$mMóIAð@\Ù:ÈPv± ¼C#éÈv=BdCýçqÇY³f9Ý´¼wÏ$¸|6vBAÖÂq¥Öd)»}þíØc÷ìù7Óøq$¤ÇòÕ¾u¤ø×¾Ýökb§~kÉ:lýt|Î^¾?Æèåþu"æøýw@Ëáp_Ïc!°SêcÿôOÍï^ÍO}úÓi:Xî>¸@`#ïÿñÿ¹ØçdB¼oî#þpcsÜñÇ·v¡èåþ5ãÇ>±³÷_ºM=-ï{ûÐ?ØÚ=Ê÷§~g/÷w¸q.ß?ÞËùío»N]êÏ×Oã(Õ_ÿú×æGëû; h5ÿðßÿ}£aí'¢ÖX¯Lî>A ò
äê	ßü¦Ãå¶Ûíµ¯-mÝ·|Qì*¾àÓËñ@µð¾¹ü6þ°á¾ÛæÔÓÙOD HD HD HD`b<9ë¤ã=ÊbNàô¹äYh+hµþúÚbÔ>újÏ¼ùà.ô¥ÅüµX':l
ï¶zóÞÔë{å¼í!A¸5²ÖZ íÞïóÈÛn»­ÉçN»á©#Å¿®¡Û~Mì°ãó×±[®]þ1HZvBJäDMØ6G/÷¯ãÞð>H.Qv8^qÅ¦[*íäØÕö÷¼§}×Ýw##|&Á
éôÙ2Î.ñKì~_½[¹^î±Ôîï[cçòÍøuCõ;ªû·ÑF~àMÜÄ»ÿxÏf»øè´[u´¾¿í9ëñÑñ{]È?ÇÄíïø«m9úöøÝÏºØ}Ë±¶¼oyÁ¹ÕýÝÂýß¿fìÕq¹¶Û®¬¿'o])@"$@"$@"$ÀHèß1Ç.Ùqñ98.^ÁGÔÌÉ{Ð"èØa×ÞA}°á"-zlÁ9â0^]ícì´A'!Î¹è6µ0ÏeNôulÇØØèËu!ôY+9Ña_[k#b~æüè£ïYLÒK +xÎ­M=çB¬ÁÀÂS×6>­qÖ|ÆÐõtsQ¯}ZìjÛ6Rë±ãÂWbüêhZê7?:óÓ"®¾ºÚ=¹ÑÑbîysåZ±Ka«éÛÆ²K¼7kauËMM¿ý;
Rr		¡Wïåþß//ã,w}áwºùv¾nyÜ¹çÛRõrÿòÑ|¤y!¿ ÷ow"Ü»ÕV[5ãN»GûûÛ$jûÁ1¼Çµ£±ÍmFÌm_º_³Ö¹qß.ùáV¨uçbD HD HD H
(:;¤Þ]Èü?ÅÑÉ£!÷Æ{¾ø¯ÿÚ1äßÄû L«ØìèØAù?±ò±²ð>.Þ5¦°FîÕpHÔâo^[HUÈÕN21×Ë÷Ç<½Ü¿¡9â/w~%ÑÁ>ÖÐk»óÎ;·¾ÿ;o/½´ùýï+$ï%äý#õ«÷rÿÃn0HÅM6Þ¸;h÷¼ñ¾7¥ûGÆ1ÞL&ÿÞAPBúo²é¦eÂøñMÞmÈnXv¡Õ2Úßß:¶ýÃâÞmúáå¸b-~¾É`ÄÜ6úâ²mì&Ff_uU¹üÜ?ß Éõ&@"$@"$@"<ôeyp¤m¯àÃExúê£ÛâTàEàÇNA ³OLxZôðôúò&èô3¾ùi±CÇ<¶æg=â}ôÆÄ¶ÎÍ<b~miáWxhRÇÇ×zÉ!?=cZ|¬±u·çïTKOÜ«X±(Æbi£xúHmW/>ÕþØkCß5Øæ0.c| ×9ëÂ¦9õ±^ôÜxôô§­csÐ"èÉÇõÐw¬O¨ùzÍØ¾¶®±óÔÇ¹)zÄ©ó,î²/½sãÖ^§LÛjëfÅÉoº~Èo»Ýeõ±c¼{2vÃ]ÞÑvÃ65s·Þ|cyàÑ#È6ß`­òéCv-k¬ÎG oýÏ
&Ä;æãAùqÁ'À¡È;À-ÈÈ3¨£Eà+|ð¿ åBo!7ÝÙ¥
lb"õG×Ã9sâc<m¾®_òó@Ï
.Ò¨è%¸´sy8~Â#'ëXØ¶pº¾Ñ3?ÕóÓ'6ÄåÒüÖ
QwÙ9?)ÛÈÕ!r2HD HD HDày@?1÷æ â¸xXw ¡%¿Á· Æ{	OÁÐÊ;G=sø2¯ÓøÌÃwX<
qw1u1Oóylkalâ[ëÄubbè61Q×^ó[7vñ£çBgíÑ¹Ô	Fîý²cÒ¢c1é\¨ÉØÒÏä<-s6u_|æ½	æ×yc×:ô:bq½9Ñm¤9iæY'1ÈÏ¸Îßxèç$â£EkÒòDÌùN75¶áÈk¬Y¶Þ¶ïÈ¿EwÁ]9·
x
-ÆØ3_ûi>vôå*¢ÛÄ¯ ¿¾´\ø3º­~¸H»þµ½qû<áüëº6úØ«3¾1K~kDègþÚÞyZíéX,jÄÅ{sh
ãªç]7EkÝFÄó´cì¨¿ÄUtPããZ­S?ìè¸ñ©_òÔ1c8 §qhõ1¶æÚ¾^óäæÂÇXCÕÔèyÊ3åC8uþ¥OL|y±cãôÏ@o¥øßc=ºÔ>\pr'BkY}õÕGãÁàÑGÝôúÇ»'cgM}dáP~ÝÎµs?øÁP_7&¿qk¯Ý<^°àÙß)
ÙÂyvË\;jÆáÝPø/OÂç	rÏDÇ×µ¿sîÙXO·ø?µ
¹Qs*ÄÂ9ýõ«cÅtbÐâSû[c]×BðÑfAµ¸ [æèkO~|Ð¹pA
Ulì°áÂ¶è ®ðWÝèõC~|Ó'yÍáqÃ¤±ÃÞ<ØæðãBëK´1Oß8Ä¥oZën#ØcÇöåê(Ë¦úü±Ô¨¨ãx³Ë~ÿûæ=r;ÄÑg¼÷Ì¬çsNsâR/h	!`i,°;ïÃov¾Yîµ×^[¾wæ§«Ýó©ýðßÿ}³+5ÏãzÏÝi©ênFHN~ÿÅë_ßmïø¤?ZÂýzÓßXxÇ£2gÎrâ·¾µÔwMï¹lWw
ëM_Î>é#øì¸nA>Â
@'YfÛnÇ{[tðôÑ1ñÕ^ÑÇ¼ò-ØÃsÔqõÕ1öp"ú3àÏe~tºº^9âh¡U_ÇÃN[ãY7~µu-ïU("X,Ev*¨Î.ØâOË¹zÑÎ£¯ÎÏ<ó´Äcç[##øÐ·~jD× ×óµ/úNþäDórçkÐÏüèècO_ç%äÐcÏ¹Í£,çåQEtÐAeÝwwØ±åHJÞÔ~ÔeGãgYÄÜ³x¦K%Øö¶·½­LÝbVÆ_Æ;¶xWaJ{Æ;É^ïu¬cF~ä²rì`ã8Wÿ¸?\~y9ýôÓkóQé¿1ÝµÿøQB¢zÚiÏÉ¶£² $@"$@"$@"¬@ô¿cî-±¤ÙqAÌÁ!<ÜG¥Ô|sá|jÒ½cúÌëÏ¾óäçhL¸
@?1wp,sv\î;{C¡Ï§ QÏ£ EOßÝiÚ3FOÌZ°G°Ó1?}óÓÂu8&&}óG·7_{Lcc¯/>Æ36:}Ch¹äWè©cÃubÃXµ
cú¬=ùëúÖ¸æP_·a6À1¿ùi~ô=öDbÉEZ¬´X'sY¼ÃÞX<
á?`á¸ìË_ÀWÀ?`'!©&Ñ¾´£Ûp/Øá/ÃX¾Â~íoß8æ7ÁÎ[¹è6cüôe-ÚÓ××TûºY?­züGËú]­ù£ÛôiÍOl¬èºõ*u1Æ¢ÈZ}¶xtPd?¦[à¹xtä%1±G¬§}mØz\¤~´ÞZ}US/9ò·ç1?-þÆnË>¾äGècoM¬9}U#æg`b£,O_^²?~BY}ìØæ!é}÷ÞÓ,l°ØY×è
¾®>9Zu>Hç¡}ô´êÕéçûö+T¹àX°5o{[ç¡o~j³¯MÝ2ÇX±Çää"{øêWqÞë~ÖgÒ_ý°Ûz1Ãvj3$4&EÖ®ÇÌ+À=qá½èn+7z?|èÿ?{çggUæÿC
kì®}wu÷¿¶UQ±®®º¶µ!JuU°¡+v±¡¸"½	I4JHhþï;ó½9ssgrgîMÀó|>ïsó´ó{ïÜÀûs^rbÇ%!ÝV=íqC§¼Äh×¹.õ¶è½Áè¬Ûü¡j$ sÚV,ÈÏ<:l».¹;u¼slºYÙvÛíËF'FÉ±·vùòrÙ%6ýá~ì´ËneÊM^Iñç{«#zõ_)ÁDqðÁg>ã­ÕqæåÜsÏm³³2&M*3¦O/ìÄÙlêÔrÖYg­»'V^ÙCGsÜqÇñGÈwÜQÞwüñÅa¥;-*úðÇás©¹¿þõ¯å_üâWL[æý÷ß¿uäÝXÊWN<±\vÙeûÒ®Í÷¯/ ô!ÈP
U¹ûî»Ë)§Ú÷{eüÕÕ¾êÉ»Ãÿnû&ü//º¡|úûvª&æÌ_nsMG¿Ûo½µÜ¿g«KÆZÿêª'ã&@"$@"$@"0^$æzæÄÅ;æxØ 7 ç Ç½<}trôáVGìcW»ì´¡5§yk~b_tÚÑÇ\ænS§9Ñë\ä'®ãº~æk!±ÉolkÑ®Z_ÇÓ®ëÖ¤];cH
¡p¯©E3ÖÆ3f ÕX¡jìiwÑ8Æ ±µ.æèc«¶=¾1cªfÍæ 55c§`ÏØõÓ"ú1ñÑ#ÚÓ7?sæ}vÌ2^¹ÉA¬AÈMÚqtCÌÍµsa×[7ÂS]ðç!»:zõï&ïÚh35¥7¿éMeÃ
tr%ØàG~úð#æÇ¡­ûØs©'crÒ'ù±!B~yó3o~úäÿ±¶P5¹°36}íÌ©
ðØÊ7È=¨Ó?æäAä5h½°%üþØ[Gt±ù=þ´ð#æG§ 3¿:íiáùå[ðçB¬«Î?b~úæ×Ï1súÇüÆ`~Lb¢19:YCCÑé°a,tØAD«^ ,(þ.¸­¶%®±¢ÛT{â;õôÝyÝVú®ÅÖµÐÖõbk­îC§Î¥zòõPÁ5ÑGbîäñHÌ
Ä>o¾y°gÇÚá7oÜx¾IäæØ¸ùñn£wÿñ9éô9!g»øj×7íý«/:ÕeÚ®þýqwí¾ûîeZ¬LØquk|nø½½!0\];^;;ìúµãw.Þ»mù]¾9~Û¥^×X×Ï}ãþÝsÏ=Í:ÉÁïÐ=¿;¼?î¦njOÇ'o[þùþ©Ñô¹í¶Û.þ¸cBs/ÇJr­á(DÞíp¿>ýÏt¬{¤ÜàÁwÒæ±Óÿ¿;üþwÿ{¹u|þø7¸ïÜÛqï¹ÿ|þ^î_s-¶(»Ä÷þNqï¹ïäåûöOúSc¶÷Þ{7ÿVð»ñ³ÿ¼ùn©ýéöû§Ýß1?v=ú~@ÃåXÜ«ôÿnOßËIlpý­,Ýâós_ü~§$@"$@"$@"
L½ÙÆbLQØ.Ì)Øh.Fß8<Õ­ã9'æÍ³ø50µ=6J]}ü°wLìzsÆ£.úÞtúÔP¯1Ð#Öëyûú¾Ä1?¶úLþ¬xÇÜ)ãñsQÛJÒ/bn½öi½îòK/¢ct»^ýWé¥íZ~À²ìîûÊOÎ¿®|/vÇm´Ázåÿð¨Æõ'ÿ©\{ëåðm_úéeêä	å¿¾¦üO\ýUsäz< çaa-3{]ÄÜË_ö²f7¾sìNx×;ßYëªO
ÇÚ~ìcB,qÄå Ç<¦1©	[}l÷ÝgrôÑG7CHÈZþýïèHjuCÌõrÿzùý±~ÞùO±ëkbÄÊ]ìJÏ;»Qk=ùSÝeµ¾¾Ä9!Çv¨v¶Ç8ïLSú±þÑð¹b§æö±v8ùäý×¿«"æ÷¸Ç5±ñ~úÓ³üc}m;ì°røÔÄ\;?üáwMÌð]úÚ×¼¦Ù-<RQ|w~åÄ`ÐËý#<¿ÿ«~9Ò±}÷o/÷ì²>6Þëæ÷>»b.»WÕÕµ1jìDzùþ©ã¶÷Ùaùö·½­ùæø£þxe$á>ò]Ègxq|O?ýôfÇôH>ãa®WbnÃ8Ùààøã)v-×ëûýg%ÃüFmýD HD HD HLgGgôE²S£? Ï%ÏBËX@«í$Ôð××Vî¢öÑW{âîB_ZlÉ_u¢ÃØò?cÀÐ¯}ÌNÑ9¼Ú¢³nq©Çä±NkÀÇxú¨ÃF{t£÷*Æ H±pVNêÚÂOð`ÑaKÁgÞ8¶¡j@ªó{Óh±cÎØÖh,æ ¿È¡:Zk#ña¼è¶üÐcgìv{ll¸È;a°Å1?ñÌ-}âótvfì{He9iÒÆe×Ý÷¥ÇÄÑcW^~IÓïöG¯þÝä9á[¦Läã4 ÷ÞwùÓUÊ#wß²Qüß_o-{ÎZ6ÚÐ[]ÊÛ×|ö·ºô¥åþöq\[»°Ã#þ:s3g×½öµÛH;æº!æ~î¹åqä×sÿþïË>A¤(¿]>ìvyqìÄa7òÿøæoM,iAÇ®-µäXµ§=õ©ÍÑ~Ì³ïc±³ª`Ôw´-u9:MyÑ^ÔÆí j¹:¥d÷J-¬÷±+aÿ\xa3Pâ½Ï»ßfWbã0ÊýÂ¯&æ,ûðÛßý®!bØ±Æ¸éqdû±nOõ=i`gÉw¾óò.hÂ°£êñÀÖÏàÿ©ÊÎAûû¦þçfÈïøñïëTmhóìg7»ñèùË_.W\y%ÝPÇÎí¶ë®Ín?&»!æz¹3{øý±øzmìLúÖg[ã?c`<ðÀòØÇ>¶ó°rs¸c
ùÃ?üáÍ>°K]¤;ÇÎÉ'Ç®1H2¿_;é¤¦ï^î1þáU¯jüã Mú³5µpo!ìÌ}nüûÂýówÃü½|ÿc¸öq4éc&í´öv?>o|îËã3|Â	'8·m/ÄÜñ?ïùeø®B/½³Ìÿn37îãýejx°K|Æ6
ÒYäò¿ø¦?D HD HD HºC`pÇÜÂzn\¼cáA¥<sò´º{âk@ï ¿>Øp=¶Æ`Ì¹G¯®ö1vÚ Cç\t[K}Û16æ''6è¸³.>k%':çñeÎüøs!Ø1~Ø¢ïYLÒK bPÅS`]0±µ©ç\5xÅâ¸^°ñi#°´æ36Ô¨¯ «¾Qè°«mUë±3¶ÄùÕÑ"´b?b~ZÄuÒWWû¡Ç-[) æRGYn·ý²åV[ÇÒc7ÕüyåÖ[l]üèÕ¿å»lQã)÷vÓ7ÑeÑË´»µüá[Ë¯^=ïk/ ÒÃwÈu"æx;5^9vÛ¼?HÜÛoß}	¾~h	éué¥Ù1ýÜØó¥/}iñÀ±`ÿøÆ76Çbi÷¸VwÜqÍÎ%R¿íío_åv{pôrríÇmîïF:&0+_ýÚ×Ê%dÖ·½m'æÆ_;1Ç{Í>ÿ/4D¨99¢òýÇ_Þ»Ó|ßïÙ5É¦øÌ3G¦å½U|!'ÁõC±ÒUá(U<0õ;ÑA¸½#î»Qø5@Þ'#W!Us½Þ¿^~¬ÿèø]Ù7~g«äH×vq7Ö}êSÍÎÒöù^Æ5±ÃïéIA¼@((kùêøfÈQ¦§J?Ö_;òïd>»ÞÉJ'bcpÇ2B8!|.Ïc!VðÙä¨UróÙdGéHïb¬ë`'(>Ïþó­ãµcWå[ßòfø/~±µ[E/÷ÏøÄÎBÞÿé.4õ´òÿGÅºûüëwörÿøÝæ(a¾?x/é'X§.õçëqê/ùË!óýøþ°mÀpÜ.þî¨ÏÓprH¨ü!¹ú¥øCñ.½sxæ3Ëö»
IÁÿtÂ¹ ðôÕ£S@îÞyìô:ûÄÇ EOúné£#¢ñÍOk~â1­ùG8G½1±­s3_[Zø»ãªããk½ä óØs1¦Eg-­»=§ZÂ¼;!p¯bAÄ¢¥uâé#µ]½xú Vûc¯
\ü·¯Ès`Ã<s5Çyýè£3-ùÐkÏ¸c;ócgú5ARû1v]Öc~8t±µ&úè±AW÷­/ÔC|g}ø¯nÇLB°^Åb;Å0l¸j°w1Ì	6}_úÚÔ-ó ²Ê<Ñmô¶ê±Ñ¡µomè±Uê>6ÖÄ<¾Ío<[mh±Áz]v´ÎE·±EàgÄ æ¦yl¼cnÿõ8úÑ+1·×Þûõc'
÷ßÿÉÃíÂ{ÿ8¯Ó¶vÛÑ%v !;ÉpÄ\?Ö/±ÃÎÀ~ìcÒ7;p!ün9lÅ»?ïåî÷~È~ûíW^ôBNÇAl³KbûO|byR\£õkôrÿÁn0HÅm·Ù¦;l÷¼ñ¾7¥ûG'ÄQ®O<Êï!(ù]Ø6¾¦n¶YïvS²­~}ÿÔ1Ûû/cw<ã9¶ùÁ&c%ævôcÊìØ
;¦ºÅxrÆ4ní-BLDúr"æ×V½qÑ£ëÔjC<¥ÖáÃUóOÌ££e
OåëüØ

­¾i}5°aÖÚÝF_?Zì¬1qr36¿k¯×ÎüØáã¼ùx
zÆÔk~æXR6þôxÇÜ×>vÌM²IÙyÝX¹#ÈýõªË~·?zõï6v;l¹q9þýËÄ	×¯üäòóæ7ÓG=fÇòÇíÔôo[zwyÛWÏ+7/á(à5#«"æ  ^û×4Å\xÑEåäOîXØ?¾ñ­Ý<üÐÊâxà]Mý æ.wÏ|í¤:æSÞþw¬Õw¸vx0
åÏxF3n'å0?FCÌõzÿzùý©ËèDAV<æÑ.OÏÄ$äO¿¤b§ëï1ÇNB®ÇCâXÆ§=íi-x'ïF[]Rã0ÒíùgÏ]^öÒ6jëwwÜJ»ÂÚ}ÚÇ½Ü?vë±ka0ÇE¶ïJcîà.Ïæw±ûGìÇFlÏùc»YÙ!zuìNãÞ
»àÞÊ±îZïãË}÷ÙNÛLivÔö«¿ïýáÚk ·*b®>ÎoÙ²eÍíw#ä^õªWµª]]Ä	>ýÏk¯]£zgÄH;ÃZE¡ScÁÑiÇ¿ÿý«rÄGòZ¸pa³ã¥ýÝwì8a7;FóªUPsØ¿±s{ÆNÞGò9°3îßc'¤ÇBT@FÑ~ø#ivivw4Ä\¯÷¯þÌö÷ÇµHÚòÞÁ{ïå¼¥~ÏÕÿÄ»ÿïtìôBìôcý½;5aÏKv­*-ÉÊwâ½o¿÷¿­.á³;eÊ&<!ÄÒªüÞ÷Ï>rþ_þRN;í´nüÈïCû÷s/÷ïÅÇ[öÚk¯&ïeçs»G v¼ûG¼×¾öµeÇ3ËòåËbÝ´ÃÕØ×ÒÏï:®ý8íö5ô]Ú±së­¿AyrÜ¿
ëôVÿ^ÚÅ»©öÛwß&ï6b;àvÞi§Â{¤Þ¥vÙe5}~ð5Ê+U	¡ÇCô]ã¡®;Mÿæ·¾UþøÇ?jÚsÛNÌp,ø#ß{ìQ^úÐmüçÄ;ênwBqü)¸qL%÷,ùü´ï*ÔwÆ
î-o}ëºâýAãõH­á¥!ÉÁ°$~ÃBÀ ÄÚë_÷º²]ì~D ÙwîþðÔ3^²#î¸w¿»)]ÅÿñÑ[êc{Æ 1·:&1$ÒãcÇbºã÷Ê+¯,_>áÕFâ»à5<Qs#¥f×Ûc}J"$@"$@"$ÀE`ðs/¬sãCXG¡Ô|sá$|jÒ½c9ýÓqü	c`4Ë9tÄ@°#?cb èÌß(âyðg>-¢?¾ð?ò'ÌØ\ø`£=ùÐ3ÆÇüÚº®ZÉ¹D½
¢p`QH,ª^ c¤}¡è]8}.A¢OR½¹Úç¬CÍüJk~l#ø1¶~òÔÂ5¢7?­µé¾B®z-äÁÆ9bCÌ¿Ý±5âCµîsQsÊ@ >¢ã½ÎûÓ÷ÈíGñÞ,0uÖYÍqk ¤Q¥HbiTp­dø­I*vç½ò¯hv¾Yï»úÆ7¿9ìqÂÚ=Ú·üÛ¿5»Y3Çµþ<v§q¤ª»!9ù·ìÙÏzVs´%v¾ã~¿ûõüç=¯ðQeÞ¼yå¯|eµï7ßÙNw
ykb»ÉqÍ£,OÎ£,D HD HD HD HD HDàAÀà¹cc×ÄuG\p
jj¡j¸¸.Ä>-¼\~µ£/¡^{ù0i|;o~¸æ}Ý¯íåÇ9òÓ7:y9tæ§%:ü:õ8WÛÀkELl§	m­w¾ëÖ"ºvè`(LÕDåÅcïâõÅ{Zý£Vtø»plë5´û`g<rak~ú'Ý¦o.cmë>ñÌ­ùë>ù7¿µ1FÌÏÎ7¤öÐäiïüâ;æNÉsBm"$@"$@"$@"$@"$@"ðàE`pÇÜbóãâ¸1x,9¸	úèä'ÐÉ0zÄyúÎÓÇyZÄyâÓçBIßüôñås11õc!µ3¶úóØ8ñ±Ç>qlLÆä4®}ÚöZBÕ¶JÝW×uK^ÅcÑíLl>âÂÑ~]1 RccÑ[àm|ãêcjæ´aÜ±7¸ñiIßyctÔA,úºú(Kb ¯cáC,qbÇÜôØ1wZî$RD HD HD HD HD H9ÄÜÑ±Ì¹q¹cîîA>üE==}w§iÏ=1kÁÁN[ZÄüôÍO×áôÍÝfÞ|í1½¾øÏØèôe¡å_¡O¤E×
tct^ÆßÀ¯]ÌoLâá/¿a[bÒ·n#äG¬×ÍN©íÉeÌc'ÏB=õ­ùÕËxÌ¡G¬Nkoºùaðnl³1-Ò·Hü£§`N½m¨?ÆJ§8úyDAPæ°ñ>méãg|[m´S¦­üÆsÖ¥
¼knÆ;uÖávÐ±.%HD HD HD HD HD X<Êòè¨u^\wÄÅÃox8¾ztr*ð"ð5?Ã<z_ûÄÇ EOú
}ytúßü´æ'óØa=â}ôÆÄ¶ÎÍ<b~miáWî«¯õC~{.Æ´øXcënÏß©0ïNÜ«X±(Æbi£xúHmW/>ÕþØkCß5Øæ0.c| ×9ëÂ¦9õ±^ôÜxôô§­csÐ"èÉÇõÐw¬O¨ùzÍØ¾¶®±óÔÇ¹GûÊS,ZÝñ/ý æöÜ{ßæÊ¿ýíoåþRî½×ßËÎëgÝ.»ÍîHÌ];oNY¸àÖÎ©MD HD HD HD HD HÆÓ6ß¼ñµ/påü¸xG<Dt[dÏáyìàäXj[æõ§À±%¶Ú3®ÅØÆÁÎüØ~MbÔ~©±óËÍ8ÆÆè£Ç]Ý·¾P7zóÏúÐ¯nÇLbÂ19:Yl§
61Æú£ká9ñ1¶ÆD_×/ùù  çÂ½væWg,óÃC¸¶>PÄBô1>ÆT­ùõÃs;<Þ1·×Þûõ7Ø påÅ-`Y!¼On½öi¼D{å¥wrÔî
Ùlêæeæ;5
â\rÑåþû;Ç[á½D HD HD HD HD HDàC`pÇÜ£vÜü¤|c¹úÚ×}æµn+Nm«9à)x¨}çä9lÍoìÍOa¬àÈ)9¿9àMÌoXØ(õØ´ØÓbk~úÆ7?6uçiÇ,sAÇN»^«õ.0QÏÓPû|¸Ì×ÞÖq£úø{	9ñÓN?tô¹¬ÓZ´a¬_t[Hµ:qÐÑW­¢]=öÂ¶Ö21ú;>T¹ÉS6);ï²[Ë·ß^þzÕåM¿Ó'ÝfïÕLÝ~ûmåê«®èdÖÄ#.rÕ;ïJÞutJe"$@"$@"$@"$@"$@"ð !0¸cîèH?7.Þ1ÀSÔ¼<¤z	.ícÎðÈÉ:6ÄC-¢n`´â§zs0c~úÄÁ¸\ÚßZ°a¬öcócÃ¡5>>Ä@ê|úakúÄeýÆ`Îæ¡u>ºcôCCkQuÁ,À©¾ËÂk}#¦Z$`¢#®cr_â1Ok,ó{ñ±¯}×AÐÖqÔyü­8ì3¿vÔáN:âLê¾ùÇãL>;æN]°ðÁÿ¹é3fi[lK?wÂñn¸ádÓÍ¦gíÜL/¸õæ2ÿÚyM·ÝnzÙjëm¹UÙ1@*D HD HD HD HD H5À 1÷HÉ99¸	-ù&¸øtò{	OÁÐÊ;G=srècyøë÷ óÎ1¦.æa~úóØÖÂØ8Ä·×/:ëÄÅ<Ñmb£®½>æ·nìã3FÏÎÚ£;z©Þ{²cÒ¢c1é\¨ÉØÒÏä<-s6u_|æ½	æ×yc×:ô:bq½9Ñm¤9iæY'1ÈÏ¸Îßxèç$â£ELkúC[§ìµOc¹þÀÒ/½øÂr÷ÝÛY&N;æöl&ï¼ãöØ
þüH]}ìÕßÄ%¿5¢Gô3mï<­öôG-5jÇÊÁâ½9´qÕó.ÂÏ¢µn#âÃyZÄ1vÔ_ÇÇGâ*º
¹Qs*ÄÂ9üêxu¬jæð!->µ¿5ÖùÑYÞ±`T°e¾öäÇ¤P5s;ì¹Ð1â
õÑmùÔk4ùKæ5¶ÖI\9tæaÌ%qÆ~æ®¯=óôC\s0G<ën#Øc·q\ú£,ÙÑÆî·õÖR®¼üÒ²t©ï³lTàÇQ¼on$°7ç0öD HD HD HD HD HD`ü"°ùÔÍÊ'}éè¨pn\wÅÀÅCnù+dm»c.ìZlÑñp>:¤Ëøê_èc^yìá9ê¸úêÇ{8ýCðç2?:]]¯q´EÐª¯ãa§­ñ¬?ÚÆ,ïU("X,Ev*¨Î.ØâOË¹zÑÎ£¯ÎÏ<ó´Äcç[##øÐ·~jD× ×óµ/úNþäDórçkÐÏüèècO_ç%äÐcÏ¹£,¬%GYî>{¯²ÑÄ
9¸êµç
SõBÑE9gñØ»x}±ÁVç¨þ.Ûz
ÂWTÓÀfvø^:s?ãäkä1Ô3×f,¹¬Ã¯b}ì®Ùr&æ¢Gçúãk}õÆ©ñÅN\½?|c¬/
D¢sÔðTÃnýzÜ	Lü\UÄy=$/,zt®É¼Ä0Þ-õcØÔ'76A%k#zóX?T­úäõdë0qõ}1Ç^×uíè¬ïÚÄ8ò6=1wf>cHRF¿}ûÛË.»îZn¹ùæòù/|a ±ñðÇ<æ1eêÔ©eÌ1Í®»îº²hÑ¢ò³ÿ¼Üs¿j£CvDüG²Û~¼¿^ùÊW¶
}üã/wÝÅÇ~J"0zxx|>ýéOoôü \pÁ.n¯=÷,|Ô£÷ñï~÷»rÛm·
§¶¶¥?¾L6­9)6qÒ¤rÎ9ç»ïæ-7¸H­]»¶|ôcÜñ~`yÔ#Y^øÂ¶Vºð²ËÊò F§LR,XPvÛ­ïWïÌ³Î*çw^Ëo¤tüG
Çnót·µ«¹«®ºªô¹Ïõ.cm@MÌA´A¸
Æàÿ0 Ú&®ÝàßËBë½½¯1÷¼ <6®F~ñ_s¾ÿýûjYg;#p_~nçífùD HD HD Hî7ô;>¼8ÄWHÂÀCÀ'(Hôêù?¥¶9Æ1½qô^ÚCÕz9ü°#æ¨óÖ9ñ©×âúÛ}ðCÈ#RÇ¡§¾ka³|ÈEO36hcÂ<õé{óÕuú<ñÓdÃÙÌÕÛ\ÌYll
>ú¢#æÆG4ThDóÅÀ(ø50µ_¾õz¿sr×'à°u1öEgL}Ä1zÄõ:§cãÄÅúä±>¾Æpülv<cî´Ñø¹ÉSö.ÓgÌ%n.C!ævÞyç8É4øUûp`Ù+Nâ!k×¬.K\3 Ð¸8%6ïàùÍI9»ë_ÛøwÊÞSË~ûÐøs­&§÷:¶p{ïßÿ}¹ã>ãÅÐÊñ¬<ä!åO|bëÂ¢+®(ÿüçQax®Ï{ÞóÊã÷¸&èÜ_þ²|/NémMvb"ôq'×rò\¤}øÃü«¿ú«rn|ÙÌë°-äÿ¶Às¸9»Á¸5jÿ$æj4r<Z¨¹SâÄÜÅ[81ÇöÙgf+üqGÊûúóólî4HD HD HÞ·¢}Êç¼ÊbNþ1M¹VûI¨o¬½ÜEc¬þäµÜ±ôøR¿×rËÿ0GÌ!×SÇX¢¿
zêêËÜuK=§ët
NB©ÇÆ^^;sÆðôäÃnNÆÆÇ°±Ó?cêK±ó:WmgL<¾ÖGg}tõ_5ùXõk»õõ¥§!ôÚ¡µ¯?TÃ/ª³w½<ÌíF±ûúÂ
åË/`w2mÆ¬8A±w3½øÂóã/ÎyKô.C!æñô§§>õ©M±.¸ _ÎÖÂ^_frZiKrùå/}ùË6_¬IÌm$|¹:£:×¾¾x]ºti»º§y/û1÷Íøb0b©Û
½ \Æ^öÏõ|1pý_`"\ãV |©Ï#-£ÿ^ðc^ðæ¤cN}ãì³üOkõ¨G'<á	LËºøâr­¾ïiA:?=Ègä¶Ûn+ßþö·Ëö]9ËÆi¯Éû¿ U8ù9R2ø?:öÇ6Þ#¿ûÝïâS:'G×ÃB \ýJü+["æý¬g'=éIºv<)q{âGý^öO|/Rsæ ãÔ×ZrÍßsýìæjFì\CùÉO}ª¹öRúSO_ÿïÿ6HÀg'§MVÎ+nù|SzÅòúµ¯}mÙ¿ºðw¿ÿ}¹â+ÏZj>éOl_kc_í'³XC¯õÿúol]g¼råÊòÕ /yÿòýô85ø°8XK'b5r)rp\ÉiCd8Ä\?ø÷Õ-j~8Ëi4äüóÏ/gyf3öÇk^ýêÖõË?
ÒSÍü.ò»açïÞoûÛæ¤)í#)½¾~½|þÎ9³¼áõ¯o¶³¥sC!æÄd8øÄç§u³OD HD HD ØvðØ³¿rWY.v[48¾ ÷Kp¿ìÛW@ä9ðÁNÃVxÌ±Çùì©^æµÛ<øY?ó0®	Bü:¹ûr=ÖAç_×Ä=>èê±ëõXó¹>âÌW÷ÚïJHÖ«¸ØNyZ

½±»Æ¸²6L­Óm£ÇÏµ3'B.æÖwïõ>ÐY?b´[ß9yÉ§ gÎþ­<ÈØhÓâsg­y ;ìð#ã»ÝrçÂñàd=ö,³çÌk®³äÿU«n`l%  @ IDAT(kW¯nâÆÄ3Ø¦¹7~÷¾/uç9t<n$d8ÄÜ¯~õ«ø¨O¬Õ_rÂàó_øBÇeqU _p"Æi¤ÓN?½£ÏáËÙxßû:ú´+kbîûqäçÕi}ß$§Xû{ÞûÞ¦×ÖK?û
i'æØÏ¨ â WØvÑ_§5¢lÿùUßNÌØrÒ¬]jâmE
ûô§?=À¥¶óõáxîWnMzÅ+ùlô´ÙÞÛ^øý±z6Z¯õ>úèò¸£j¶Ù~Ð½pÀåÍó7N·)1Çsä:=Ôg¬òo8ÿ~(\9ú¶·¾µöGþNôi[öúúõúù;ÒÄÜpñ÷u°ëáü÷±Ù'@"$@"$@"l;¦Äü}Êç$æøÜÛ£Á'ðe¹¼Ü¼<:z¾!Xùz:xzcðe¬u©/aýPµê3"øÚÏµc#¹³cÚóXuâ§Ý5RÁÏÚØðcÝúèÃf.øØ®ÅEu ?ÐÅ0eÑäu.
õ}ÿðËoâªÊoÆÔR4ìô|ÆÚ·q¯¯_¯¿³gÏ.¯kP817\ükÌFêó³ÎãD HD HD HA ÿÄÜK#Ûòh<	>¯ !Ðè#òÌÓë_µÑ#æ©}õÑOçcmôøÛ3¶éo}bæ
q6s27±¾crá£ÔssK¯õ]µ­OÃúup|xQ{wZ¹ë¸¹Zï¦È(µ±:æÍe½ö¾Î£50&Þ&hÖ$N?ãÐ1¦¹N×¢sãbØäÇR­®et}ëWÏ©a}ò:ãY$bîÀiq=å>Sl.¾º¬]»¦oéäÜÔ}÷ëáÆpãÜwÞ)ðrÑÿ7b'¾jbî½q¥Ä\»L>½¹
ëº/~éKå²¸¶+ï¸ZÍÓ\ñ·v«Jë/¦9Ã©NÖRS+\ûç Ù"s<ìü`Ç-=ã¦cÀÛrÿÛã*ËûÿÄoß¸nòÅqò
+ÈËú4ã»þîïçáñïre<ÛáO®yvÝ¦l»üÑËë7¿³g1×-þB×Ëç§9²OD HD HD Ø6ô;.²/æ5p|1ìÃp4H+8	ô\úiÃçðE_f×¹ð!:|û¾T¿Wª¢¯50Z1yð!/M?ê»|?ÂÜúøÐò ôæ'H]Ï8|­Á¼ìßØÌazí1ìNH0bzU/
Bb9þØë8}Ð3Æ±\EðÔ7F5cØ×ùàAü¬=ÎøÚß¼äCµ>ózmñWg~sú®=bõkíôú3¶¸¨aV.Þaa´Úî& ¬Þ>øÆ0=â?Ö_ç'BÁ91îÕu/c7¿/ª9ðS%czcÌ¿õÅ¥ö¯÷Ú4bÌå<TÍÝóØÏ<æW¾fí½_Èà4Z¥EmÚT.»ô¢a-gÅq-%²|ÙµeÕ?ól8	9)7{Î¼&äëW×ñÇ##Ýsõ³êgÿlé¤ÇðòÜ?ýÓfÑ«V­*ÿÄ'6Û@ý<á|IìÛÉýoobn{à?Røñåx'â/ËzìcËÆ{Ï/ÎùâyâXóìg7c®§äÊí%ÝàÏi'NÍ 2åº¼N§rê¯s<«+Áñq-æsó¿ûÝï
Ï¦kí_¯ûoßÏpç51·¥ëwëë×¯oNÕµº%æzÅgþå+^Ñ,Âë$;½êµÖã^ëÜqå#hRÏgûmÂíÂïí{ÈEF1÷8MþÜþÓä¼8%Çi4Nè^}Í5ßH§m!½¾~½~þî½÷ÞÍ°·%KÏ~ö³·Ésøx²­¹n>?;.6@"$@"$@"$#@ÿ¹EâÅÑ æààäàIàÐ£«¹yâä4°ãWçp<äc`Ã GÇÆáGl4|ËúµÝÄæØµªÑ¡KÁXëüþ4ëâë?¹zr86/=_×Bâ^¥Þ°Qç©!¸Ø 
¹ð¡a3Þ¸:WÜÄ:Þ5ÖõÑu-$	qÁl¨7`±þÔ'¤PµÀÆþ4tø¢±!^}[ ×{4õeÎÖµ6óKã¿uðµ>ñØ£!%Ú°36yÞuÅ°üñãOÝWYî§Ûê?Ý¶qÃrùe4@líÇìæ	{ìQ.ºà¼®S÷Ý/U3­ÑAx-b¾I¶0Ù1×<·ëa+Ç{lóe#©êEx`ùë7¾±u©Ó³Ñ >øáT¤§	:ÉÞÿþÖÄÿñÿþ_Y×è)GÆÉÅÕ_þò\%¸=¹Üÿö&æÀù¾Æ¿Wüø2S`Ç)¸/Å{/ÈkáÁ7Æ{t¿}÷mÔSeâÊF²áío{[4æ.¯ºlâW¶q:ëïÐ÷®¾½ôÃÅ¿&¦~ù«_ï~÷»Êóû{ôóWê'Ï1Û7¾á
î/â'k-ÈË`Z{áÙ]Ô¨Eøüæs\éµ>W¦ruªBÝ WB>4éï®ö3Ï:«wÞ½ÀÂºÏÊS?ø½Gø]X¸pa3¾;þ
ëøá~TVÆÉÀ^_¿^>ÙÇÄ5Õ\ð¾þéOÚüáÿqÒ~}ú®õnâõçG¯ø~¸u,ãúùÌÏ
MÕ`´o½gLsY#sTo­vëd³¾Ò[æqÌ]?ujÁæÑ[Þµ±B
cyrÐkr9yhq®Õ5bÇVÏ]=BnìÌÍkª±ú¢ÇÇ®Õ¬óöúØºv ëÕ:ÆlÐ:wC®lê+Z¾¸úas¬ÍØºcìÚê;RÛSÃÓlæ²Ç±/¦9}èõõEDÔ¾Ì©m}æsÄúÄê3>ÆÓ«,×ÜO®²d#ÛC8±!xO|)tÇwÄgÏýK8ÁÀuÏÖéö-äP ~°/´G#2#µÿí½·í¯øíîÔ¸Æß%åÁÈN¹AÀé+V¬ØìsâFZ7\ü'LÐ\ûÇþoß»åË·6kãÄäXò¾öë­±½ðÛÖûwußNÌ}ë[ßjÌ\ÿÈuÀ<7«ùã­	äï7½Á°ÝZì½âÏé+N§q
Ó÷}õàÖÖÐK}yóýàsÿïÞùÎ§ëãÚÛO}êSBóøÇ?¾<ï¹Ïmì\7Ë	l+éõõëåóßA^¿;ã=ÌÉZÝí%ÃýütªüþòoÇýé¿;\ö@"$@"$@"FúOÌIÌm5Â=ð¥7\ü\=zù	Æ48
jj¡j¸¸âÞ®Á8æú1¿P¯¿üF¸4±Îµ[.9ñ¯Çµ¿üvâ°Q±ùÐÉÓÈ¡ ³>=yÐÔõ\¶Úßú}Q÷æÄ|Ð×zíCî]Ä:8
¦z£è¦´¹xüÝ¼±øàOo¼6Öx7o½öüÌG-|­Ïð$ÓbØ¬Ç¹¾õ|ÖÇ×úuÏzØ­ïÚ#Ö÷!.uLG_ö19©?&Úì81wZ¢ìD HîÏ$1w~õz_ûã:ªÏ¥¬k^o[¿¾ì×rbý¼ÊóÎ?¿yæµ{D HD HD Hþs/.¶)<ÜctòèäH°#'ÑÎX;cüiØéíägLCÌÉØú¥É¹XËÆaGÈçÚ»Æv|­OÄüøã87'sj×1}ûZBÕ¾J=V7ä½&nß`â#ø7 ±ëõ Õ17½µÞà×ó©±éÃ¼=s_`ò"æ§7'cíæ°>1èX¹#êê«,É¾ÎE¹ÄsÓâÄÜyb.HID ¸ß#Psç{nùÞ9çÜï÷>òÈrTtÓ§O@ÂÕYxÖê/ùËòó_ü¢y`mËq"$@"$@"$@"°£#ÐOÌû\Ísp'pr(ip
òµ=zÆNÓ9zrÖ?¾ôõ[®Ã99[?Ýzí9Í¿±ÄÏÜèÅÐÓäW©sÃ}âÃ\µcçøt-$éUÜ4¹\¼e#ÚëÔ`ìYsÇÄÕRGõÑÑ ºjF»±ú2w]Ö_[ao}|ë=ëH«ó3vn½ëqúY¹kãiù¹@!%HD`@`Ò¤I
'éRD HD HD H"S&O.gå¤ãcïWGãËx8¥6Q
Çu¼cóX_Þ8z|åFbØÌ3½èÏØ8bÜSêfÿôê#½¼yXõcØé­Ï|\9Ñu-$êUêÅEÖâ2fÑ.ÞÍÓ× 9uKïæÑQ<æÄq=í{Ã×ë"£÷E 7F{¨õR¡~{ëÓo¶|K}1þ®±ÚCÕõ8ã*Ë3ó*Ë£ü$@"$@"$@"$@"$@"ìÐô_eù²ØäÒhë£Á3ÔÄ|\=|6zuø#ðÑÓ«WgsüÛ[¨8jÁ±àkÝö¾®ÃØú¬Í±>u¹âSFýö<ð)¬C^E»5×ã69\=>J{}õCîëÍ9¨Í66hN
,²Þt=Ç® sôä!öED¯=­Úè}ó¡§&~4	¹¶ÖÓ:õÔ%G»Î}©·GïÎu[?T-Ä¦yèÅúØÑáËÜ}AÌÍbîô$æD HD HD HD HD HD`G ;>¶¹8Ï3Csc@GOC/ÏÀX"Ín;â¿Z8e§½5å,¬#ça}rX_tú1Æ4ëÇ°Y5Ñ4ê×æ¼^?6ÅµÈ½ §¾¹]þ®«Ö×ùôrï0#yXwóººhæú¸qæØJPÍªÆ»tä1ctkX×1¾êèÛó3LM.^×ë¸füjHÀa§!ÆY9
r£,Ú¡C\¸ï³ÞbÒ_`l~r¾ä[µ[5Ovtäª_¼¶Þ^éú±ÛiýÖÇæúèâ±SõÑ1gÿÆÇ°YºÝ¢ÕëÇf~×d-ây`ÚÑzånA2Aó,·o^Wn+#çÎ_vÝu×!]eÉi·9órÓºµÍµÍ¤ÿGm_½zUY¶tqm.<Ïnæì9nã
âJËuQ#%HD HD HD HD HD ÍL41®²<«,DÛ
>)@"$@"$@"$@"$@"$ÀhF ÿ*ËãbK£Ý
¼¼vüô:ÇäÇ GOÆ
cytÆßúôÖ'v|­=¢1zsâ[×ÆX__zøÛ£Õùu½Ô vüiÌéÑ¹æ®»½~§µûÐÄ½"q±ôÚX<c¤ö«7ÏÀêxüõallk91«ÍuáÓÉÏÆ¸^ô¼ðèO_çÖ GÐS9ûaìÜP5özÏøX±¾î¹vÖÇ¹ÇðªÓW¯]ÃÑ/Ã!æx>Ý¹7ºù¦uå«¯°Á}÷; ì·ÿîÆVë/kÙyþÜáG>´¹çÈ]|áùqZÈúss_ÆÂxqâªÌ/<¯à$@"$@"$@"$@"$@"V¦L\ÎþÊI\eÉâ·ECaLÛW@ä9ðãp¶ÀcÝ8y
¿8·§¾ú3¯ÅÜæÁÏúøqMâÔqÌYâz¬/7ã×Ä=>èê±ëu£·®ù\zóÕ½vâ»vÜäb;å0|h5@ø»lÍ!±>u9 @VY'Þ^½ÄZ
Ü|:ù¯½§ !ôòæQM®bNócqðäÑ®9ëÂNë3F°ã[sóßµ¸ObÑ¹NüáQ¬Ã&'9êõ¡7Æú®?ÅüÌÑÓÐ¹ö_êÃ¾7M¹sÒ£c3©-TÀdîéÍç¤¢O=&»/õÅnîZAG.^@_6RçÇÇôvöI3õWõÍ^Ñ&§2!Ú´ã
Kä®»î,×.Y\nºi]yÐTögÌqÚÍSt×¯\×UòÔ'{î5±Ì>hn3¹áúåÎ;ïnZ3¯¯¬$ÏÔ}÷oô×\}eëúäÏD HD HD HD HD HD`"Ðåq±´k¢A´ABÉÏÀIÐàjc¸
x
-æøc¯ãôAÏ?Ær1lrÀWPßXz1Öak\ç!/Òg|íoÞ¾{ùê#õÚã¯Îüæ /õ]#zÄ8ë×þÚéõg<lqQÃ¬\¼/=ÂÂhµÝMøâ³i}bØøÆÐN8Çõ×ù¸a*sbÜ«ë4?Æn~ÖH,uê1PÓ<ôÆ_ëKí_ï;µiÄËy¨5ºç±1yÌ	¯:}ÍÚû¡tØá.»îºkÙ´iS¹ìÒØOGp;tÁá»[c¿bÑeeým·ð8ir9ë FÇ)¸K/¾°Ü}7Âõ<K¡Ön»íÖx7ÄÉ¹qN6}f\{¹O3½âòeýzOýê}"$@"$@"$@"$@"$@"0zè?1÷²XÑâhs|1 ß O]Í=È»xrìøÕ9cÃ|`Ììèå2Ð5ÃNæäS©íæ \4Ç®=T½õñ#ÖºÆ¡#??Íºø:Ça®ÍKà×µ¸W©7ìbÔ¹Aj.6_lýÜ,>ë\nZ» à«
¹ð¡a3Þ¸:WÜÄ:Þ5ÖõÑu-$	qÁl¨7`±þÔ'¤PµÀÆþ4tø¢¸"^}[ ×{4õeÎÖµ6óKã¿uðµ>ñØ£!%Ú°36yÞuÅ°üñÛ=Úy%Ï5{N³ÙÕ«n(Ë®]ÚÛìÀ´¸r¿F½tñÕeíÚ5ÍwùÐÖ³éîÂmÑå6WZ+1ñæ$ÝÝwß].¾ð¼rÏ=@$@"$@"$@"$@"$@"N&OX¾yÊÉÇÅêDÛ
G{àËoócO  @ IDAT9ÆpsÆòôøÓðØ£ o·§!Üc9~r,Ö¤c6óSCævù×o=sY9Büèµ1§½õè­e}×Eõë|Ö ¾XÄpøB^ÅÍ¹hòÕgîfõuÃöÆºIævtvN_Ç`óÅ uèýÉÅVûK¹K¯¯yêÄÀòC]½Öç^bØÊN?ê¸ëc·~}R£qå«×¬E?êå°Ã\ Ã6mÚT.»ô¢-®wúYeò½[>\Syk<oîî»î*ãÛ{ï©
:óS~HÏñØWÛÈkyLl§	e­·Ü¥·CCA «¨ :)û<öN^_l°§Ôß>Æ'm=vìG.lÍOð$Ó¢ÚÇK[ÛºN<óckþº¤N>úÍïØh#ægåRûiò´×I~¶S¬;~²¬s"Y&@"$@"$@"$@"$@"$@÷¯{Qx.ã®8à9 °ä à&¨£@'GB>rèû©ÛO{ú)ûO1&uóSÇCÎÅ\ÆÔ~x¶c Ð­ù{làSÛÆ¤MNãZ§lK¨ÁV©ëêÆ] _qÀÄqÐíLl:âÄÑz=>b ¤:ÚÆ¢4·À[ÒøÆÕÇ8ÑÕôiC»=mO0qãSºýÆ0?>è±¨#êê­,¾±Äå_³cÅÜ7Ös1×D HD HD HD HD HD`­F`;4@X+æàNàäP¨sÀ)È_Ôýèà (ÑSwuö´Ñ³ìì´¥DÌOÝüp¶IÝüQmúÍ×ÓØØëñN_úJùêÄ@êXÄpØÐ&VmCÝ66=Aú'M,ïDýõDê	PwÅ¶uüj©ÃOBÍüè8 ºjF~}µ¥í¸:¶Qm6¿ù±­O.zÆ!VÇ§n[JÇã8µ3mÇ²IÔgO¦gÌÅxSD HD HD HD HD HD GfÍYNþú÷Ëã`Å<ÄRTA¨Ç=¼zû(ùã`6|Æ=Ã¥ý¡nbÛ¶4.mêæÇAçA;yÚÔzò×ã#zJãC}]Ù[Ú6
þæ'¦ùÑ÷%° KNÒÁ:I+ñd.ïÄ°7¤ Û6¦¾k¯öØêGlú);ã2¥¤ãÀ;ÄÄ¤$>öú3Úæo÷®Fô¡-þÆ£Dð¯sní¹Ï;üã,]FJ"$@"$@"$@"$@"$@"LafÍ^N>öh·²¼3¦
AÀ%À/pX¿¯ÀNBRM¢
Q#ðä'?¹<4Þï:É¯~õ«òÛßþ¶S×ÓÍØlÃòæçì[ö3½|ë7WÎ¸bÜcÜ ~|ñ×¾n¥öþòò§:Âîÿø²²nzwÞvkùÝ·¾Uî½Gpt/ý¿ûlËëë9åSÊÿüçO ü§m¶Yyê+_µÒ1]ðë_ÿðûvyý#@"$ÀG`Öåäcr+K9nÀQÀPçg¡¤­@ Õvjøëk)wQûè«=qÍw¡/%¶ä¯Åq¢ÃØò?´cÈõÔ>æ@§h/§¼ÚÒvÜâR·Éã8>ÆÓG6Ú£ëZHÞ¯A2îÄjÂI];Pø	¾`,:l!øôÇ2T
6äÝh¸Ä1?ñÌ-uâCÌÍsf+ËéÓgâMnÎÞxÃõ1üñÉ¦m^6_Y¯³îºåî»î*wÅj%KÇÍH`ô|Ñ¬¶Ùfò¸Ý­,[¶¬qÆÝº¥}"$WqDÙu×]qwÞyåëÇ;áÇ<øÒ¾´ìµç£éòË//ÇpB¹õÖ[GµY:Þ÷Þ÷
à1yL9ðÏlf2Ù¹
Ï[ÕÄÜªß ¬á «ëÿ»ä¬3Ëùñ½k¼2Hb®×ñw¬i$@"$¥Ì1=¶²<­,ÄÁèá<àÉ3¹tr"è¨ËSÐÔ7×õ'¼ý´©Ã_P;cR×?ªM?¥>ØSç 1õ:m~êæGg~tu[9ålð'Ýo~m)9Jûñáh¨ºwçÕÙºÆv¢ô*z@¨O:&D½ÀâÃð(éÃÑ:zcÐÆ1^üõ	¦O!9(é#q¨{£ÚÒSG`ã¡q¨{ÑakÝqZßú±l+æ_¼diT'ÌµU¬v×qPã!æøs}XÖYgæÙË.½¸ÜvëÐ?³<_gÞÎ»5[[àªEWØ³ßü>%ãe­vyÑ_Ø¬n@TüuáW¶»{|Ä
¦âYÏzV9`ÿýYÏCøá8ÅfÓI¦>÷»ßýIB®§>OÞ[1òÂsùÞ÷þ÷¯°Zøå/y9#nº]|É%ã:É¬zyÿObnbä¼~'Æyì£ÌÄØo;cãò>¼l¼ÑúåWç][þëç÷}JV1·ªÆß7 k8@MÌ+æÎ]E+æzÅ¢s½
zubÂcP¢'uº¼	:ýo~Jó~lÍO?zÄ>êèm~ÄüÚRÂ¯ðÐå:>¾ò3ØsÐ¦ÄÇ±ÐvÜíù;%ÌÇ'îW±¥´ÁSGj»zòÔ¬öÇ^êÆ¨Á6qiã¸ö9.l:ÙSÇ:ñ´µmJ=ùh3ê¶õ	UÓ_ÏóS×Ö¹Ð¶ñ±mîAqÂâ¥Ë¢:±dÃ ÏöØs Ón-7ß¼,Ê®»íÙÜ`1Ç3åvÙmfR7-[Zæ_qÙ	ÖýßX-?¢¿ßü#
ÇP÷Æ«X-UØaÔ%1'waLãÖ~Ø"ÄD´¡NLb_[õÆE®S©Mt·¤ÖáÃQóOô££$?s±ÕêÚÚG»#úZÕ³¼_(pâ1Iåa?«ÇêÍÐÔ%ôóSÒ'pÄA ÿLëüØ

¥¾néøj`Ã¬µºº~Ø9vÚîSHnÚæwîõ<Ð;|ì7¿mâOAOñ¾¡ÿÄKõÙñ¹LÀs´]º!Æx>Ü.»îÞ¸ù¦eåË/nm·/Ûn·}£»áúkËÕW-Ñß©ÑMþNþýèz!æ¸éòÂ¼ Ùµ@hñ°ñ¾ùÍQ£Ú¾:ÏË;ø 
T'<ùá~T~ÿûßwênH¼g>ãåQñl©õckÒv+@N:é¤'nì½ûÈ#ÛÍGmùîw;dvØaåþqÃùQÌïWgÑ1ô³ãòý÷Û¯éûö·¿]Î<ë¬v½¿ã&Àk_ó&ÖYücùÖ·¾5"®½èEåÁzPÓüà>Ô0öQ>ñ	O(OyÊSÕÏþçÊßþú×ò¤'=©õ|Fmo¹åò­ÿA
Lnú¿ë?þ£I®\ËõÖ¶lÅ
	úä8µü:ô?hÛ¢uÏ PzÞó2­¶µ±ðÝï~·\×F.<ô!)/÷
,¹ÚßC }ñ?§íR¿þï-oyKÙf`RG9gÌ
Üee÷Ýw//ÙËÆåÅ~~Úim{yýÕÖÔûÇ ÞÿkbîSþtCnBÌÕ)}Ê)§^ë¦Ï/cõ{ýôßq¬îrm¿~Å»×óÇóty®"²4~ÅõÛþÃ~¸ôW¿ºyoã:æ¹»üØ¤^>?ñù5¨Ïz.½s½â_çÈõñs§íkåÏ}^X©ï?çÿêå²ê3¯î_Óõ^®_Ç<ïü8æÐC-Ûn³a[%ßÎ9çÖ÷ë©LÌMëñ£®N?æl¬$@"$k)³âG÷'{Ä¿Ö»;ø8y¸yyu|¾òèà-(õÁº6ä%?7Égþ¨¶òSÁÿÚÎ±ÓGcÛ&®>íqÌÏ8±³ß1ÁÎÜôaG~ó£§®oT¶8bk||{ÕsaGCA×I8h&TcîÚ7LaRmýÑµÇ°ÏøO[c¢¯Ç/ù¹ Ðs`^;ó«3yÍáÅ®­X>æÑÇê±5¿~Ø²bnÇú9Ú.ÝcüS=¿D®¿îrÍÕW5u1Ç6l0ÄQ^rÑåöÛY±;¶tìHÝ÷vKÌ1ÿÀjµ±ä¢.*ÇÄ?Þü=Ha%ØßøÆ²qÊ¬ª
B2¤ã?¾Y¤ñssÕ*
dË½÷ÞÛ¬XPÇ¯¼?þñXõ1³Æï¥¬o,Az|"nzu×yÆ/iÏ~ö³#ØÏù#&±±¹ýã?¶®sü¢~7$ñæ½ï{Í¾Ë^çàÇp@ÿúT³bïoxÃÊzq]A¾±báÑoûiêÿä#$òá *æÅªââ£É§ÿó?[ñF³¯_çÿÇ¿ÿûxÍ[vÜpx
*ÄÈÊ×Ó'>ùÉ7eÙöíÿVRB>q>:	79 ¤þ÷ÿþ¯ÕÝ¯¿Ø±©?b®ßóÇ*ÅÃ`wÞ\÷¬Sç8)éçºb%Òïû_¤Ç?Ýß	bµÓ#z}ýÕC®¹Õùþ1÷9>³ çwl»)]Ïâ~aÛÖÒà×ëç±û½~úÍ_Ïou××öë¼û9êoï^¼W!g}v91~À¤ð#'ú}f'y|öÕÒëçÇ >¿õùQÏ§[b®üë¼¹>bîø~}kì¸0£úJû~uÂñeé(«ïÛmWW»×ë×ñõûýöoxýëÿkGsí?pßª´Ä¹pýðÄg1ßáÅwùO<±Ù1fUb±D HÉÀð¹Ç¸¹a~KÜW@£ôf±|m¹êÚ×uúµj+Nm«9¸éçuû(ÍonKí)­Gµ©S"ø#rJØ!Æ¤
r|Ã¾F¼1ÓtÄ,VÆ\|ñÅÍö_¬eûBäOúSùFü³?i¿±ùû?ü¡Ù~<î¯[åw±ÊÕzÿÛî+¤|ô£-íñú:(Æqvæg6Ä¿Òæ¦í.±òç©±½«7nY9ûõc5tó<F9wnà²­%[ =ãéOoÍÕ¬¸Dê«½øëÃuå+ví X­tCÌ«Ûó÷O¯xEkûÛýìgÍª2°¤°»?ÄùaE¬[ ¯ß÷?ãôRr3Ð­tyBÀ#Ñ¡´5íZz}ýÕ1jbNýêxÿÄû¿Äãæúáºcäõä?øàËôám~ÙµôóùE~¯~ó×sYÝõµýúï~Ïß^ýªWµ¾ãpÂ	­ïOÏ|æ3Ëc¿{ñúÿ¯Ï|fï?½~~âókPõuÛ-1×/þuîZ1çØÿ«*/®]*Ö[½ò '?¥l<üýçêK.)g}ÿ{N²×ë×Á÷ûýïu¯}mk;}¶³ç»(ß¿øÌ`·Ä®µLUbÎ9®ÉëçïþîïÊÓö4R.ïð_ùÊWZí¬$@"$@)Ã+æ
[1êpäG6+÷°{{f«Z_gÅ
ÿv<'Z{¼ÄÜ}ñ£3ãq×Ï¿¢5Y³ç ugüpî§_ø|«o¢Tz¹~{?ßÿêïì¶ÀÚßX¿¿CØÚr"É VÌ15}ý<îqk~H&¶|ô¿l3ËD HD 9n¶\ÄÜü
Ü7SÑaCÕòp%vô'ª>|éWi|úáCñc¿}´ýÄ0¿±éÇ¶ÚÆ!¾cqø¢sØÃ£'ªMLbÔãC¯ù7vñi£ç@çØ£Ú½Ô	º÷^îÁ¤1)Ñ1Á´/T#À¤í)ç	²>Dº/>ýóëK¿±kz±8¨6RÇÇÆýÌÃä§M\ûÌo<ô}ä'}èî¨ÎêÄÜ&lZvÝ}ÏÄÜç%olÀÏÉBÌÕÿô±ÂçË£ü:í= ¿Äj´ããWÕ'<þñÍªâñOéÉßùN³²¨ÏÍ¡Ù±biáWÖêR¯zk5ÒañüW1GæÚI|^ãà¹c«CX±òÿþùT¬dÇzEàócÔÃW4²ZUJ¿ç¯¾10(b­Ù²oUK?óç9h*¬ºPbµ"ò±jhÏj[WæÁÅ9à\pòßc£äb}ci#yÌHVÓ¼óßþm °Ô76¯_øâ¸¬{ùË_ÞÔë×Ï_du
ÏêT`KJê£É³õ¬rÀþû7ÝÿÏHé$ûï·_³"}ß_ôþ.¶Xl÷¼ûÝzÐslÏÕÞ®·ÃcÅ+çÈ£¹:¬¶àíJ¿ço§v*¯zå+p"æØ_Ü¯éwþÌXéË£#£äÙSÊÉ±µêbG¶täÍõñ,@~Ù¬Ô7fê-"í§ä9=lm¼û=ïçTÞÞÔûùSßØ¬I]vÙ¥p=!§²µblM¸eõ±9V±÷?ÈD¶ñd%!ÂV³lyÔ7FÇZ
1ÿzQn°r þu2ãvBW±7GoÌ°ÑF!¬Ù-íVDb5a}cóñ|¼ÿg õ5óÓþ´vúé~,by?6¶³|h<Ï´¾'4m~~ÚiåÔSOm´õÑ±¶ý!>ï5ÈAC0÷ëßkûÓ+1×ëù{û¿þkó<ÞùqÃ¥ñl1Ül¼kl¶¾^ßÿðÔïíï5râõgÜ[]ïæ¶¬çßÍû¿Ä¿°Ï{ßk¸%?jáÇ-È?ô¡ÖVÊúüêõúTþ]Cúü­-×ï ÏÏóå¨
+;ÙÊy´-,µëåóc_«âó£bnÐøçD+ÇCÌÝ?6úÉçvhÿ£:¸lß5Scó;nzÆl»Ýj÷rý:Ö~¾ÿÕ?ØâÙÑõÖïÆ§|El¡î÷úùÆµÍ¬b+ËÉ|ý¬Iì3w"$@"°º¨¶²¼:ró¥N^ >®AôYFµé·M­ü
UÓG[ ±Ã}è ®ðWÕO=Gãß¸Ôa^s`ë8ÐÎ<´9$ÎèÃÏ£Õµ§ºqkúç¸¢ÚöØmÇÜÊ{ísÿxFÐÐ¯/¹øÂrûm#·à>cf;oçn¾î_b+*.Ñe2s<
7¹¹ØIê(ôÿ[lÍÇ*£A
çâ¡}h³eà¼yóVÍ/·ÙZÄg{aPo±¹Ã(ÿ+?ë°r¥~æØxpýç>¿úÁïÄêä±"ëºXõÜç<§<úÑnt'Äö¡¬ Tqþêç
ð^¶]\+3¦Ooô<[ÕxõµMGõ§÷¿Ê½ïj·ÄÆ ^º&æV×û¹-{}ÿãG-ü¸¥FÌ
|1~Ù»:Å­ÉyÆg9YÇ³xæóv\ý?ÐW¿êUM¸sÎ=·wÜqQ¾áõ¯o­f¬W|hTßXÿA<gí×¿þµ]«´ìwþõÍxVercòþûî[þÛÎrö/xA3þ¯}ýë¨wíi?7fúg76Á6I¼"Á¿ØÒçê±í$}ûì½wCÞa31wÞyç¯{,&+Äòw¾³yF_}cµãÕåê&æX]ÈuèjÀz,ÔYÉ{	[ WÆûþ7Þxã±ëØ f¿¯?Çµ¦Þ?ÌOÙëû¿ôBÌ
NrØa5+èûf<KëãZÈÞ±ç8!lÇV£=§¡1ãO½5±Þ÷þ÷a½jºþ1E´çð³xæ7/å+åâW\ÍÙïù«çnl[ÕNÌìºË.å¯xEkÂëwþLª~þmVT²­+¯z¥ }¬­Iä~nÌ³WÄÍz$QÇbí²þúë7+I!qÑ9ú>óÙÏÎv©WÔ+ãê«½ø·ç¡½º9ÍÎªVÃjÜÑNãíçý¯S¼^u½xý1Þ@ÌÕïÝ¼ÿ÷CÌ
ÂìÛeçïí±]æôa|x.ö¯zå+[ÛX¢HÄÜ æÏjÌÇ>æ1N¹! §<å)
Å~Ï¤äypúé§7Ä'7:ôÄ'¶NïxÀÕµ¬ÉëýÎ¿&rS}sB×gðÑñrlÛsøú¹1CÌ^e76ð'§ù°âëçqc×	7ðøÇÙ³gâXÄ¼þØöM¬ÄxèCÒzÿäæ.¤§$UûÕný±xô£EµÄë×ÉÌå.hôk»Ó³û=ÜÈ9`ÿý³w. ÕÇ©?ûY¹6~¯âýÏXý½äì÷õG5ùþA~¥÷ÿ~9òöóù5ë§üâfÙþzþs|~ðoØ½JËµõúí÷ü=>ÞãöÔ§6çqúô§[7£ùÞÅJ:~ üâ¿(§ÄáJ?øüj¿ÞW7?Øóù¿E$
ßóÀ¹(~dqéðÀhß;)ø£ÚH¿øEØ§*1×Ïõëë÷ûÃ3ñò¸Ç>ÖpÍ5wNüÀÿÏÙö
&¨bªsý\¿ª~¾?½,¶°÷Æµä5Ù|¿ûÝ¯Qýà?ìø#í×D9U¹§Æø?Rádì$@"$Ë^1wxh¸1~kp
j
\7Î½ynÞ®A?ÚÚQ¿P¯½üF4¾¶í7?7Í-b|êµ½üýøÑG~êÆC'O#ÎüÄARçs<öÕöæòZ[â)bBYëíwé ÆíÐÁPèª'*NÊ>½×ì)õ·±¢Ãßc[Ï¡Ý;ã[óS<É´¨6ãñäÒÖ¶®ÏüØ¿.©~ó;6Úù~ö:ÔÖgÈb(O{äß(bÅÜñeÅÜ{îS¦ÅÍôÛo¿­\rÑÐ	'7Z¹ív;ÄÓËFÓ¦µ;ï¼£Ü+¹®»öêÑ\WÐ÷ =*Ü±ôckýúyeáXUÆê©z>¬ ûUZL¾²ãíge+w¶EþírA¬P;5¶xkJ¶U{N<¯>Þh"ÿØÞsày!<ßjeÂ/ zÞóÊ[lÑ2åãe±úfech9ôQ!ï;ßñ&ÿä£W´~Î7ÉyñË®±BR7ðæfÝn»ïÞlJßqÇ_Î9çÍØó {dMÝ8ègþnaÇy>2¶3­Wd«(Y°úU µèËê,H½N¶|à®÷¾ï}Íö¤ìºÑM×É¿ÑÄö;¿øå/Ë)A8#»Ä3!zë#ã×À
+bk©o¬öâO,eppUG¿®FÌõsþ?*xìð¯Ý!lYAÀ¹ÌÝ,p¸_lsyÿ}÷maÛéïxÿ«çÚK1Cpr£ðñÃO>¹«0ý¼þ&ÂûíöýâëOð£NÂW¶tåäõßé9¨ý|~
Ï]ì4_ûU®í×o/çïÅ/zQ³bs0ÖçW½eåe]V¾tÔQ­ÓÖëçç«ßÏ¯A|~Ï/Þ7ÞÇ#VÌë×þúNôr,bîi¯~MÙ(~à³ôkÊ¯N8¾ãTuÐÁev*÷ÅûßO¾ðùroüØk¢H¯×¯ãïçû1ø)ô¨øÌç<ÒÇ÷©Ób{c[ìC¿_óãB¶XHÒ17®­ã»?Tã;ß¿ßþ»?¤$@"$ÀrWÌ½(4âàK<<utòè8à%èÃG=b?uû©cÏA?%b?ñ©s Æ¤n~êørÈ¹ËúÑÏ±ÓvÔú±5?qãc
bÛ´Å¢®£kþvJ]W7îý'®'B]0±|êý èK½1 RmcQ[à-é|ãêcèjú´¡Ý¶'¸ñ)IÝ~ctÎ:¢>èëXä'8±bnv¬ûÆdY1ãíYX%³áFu×Y·!åø¾6	+P¸Ñðl$Vª¬NÙ2©­c=Î7òÆö©&ãü ùo×Ä
ølá$$Õ$Ú°ÓÒvTî;üåahccLíëuóS8JìäF¢Ú´gLæ¢=uýð1íêfþêñ#%ù¥ù£ÚÔ)ÍOz.ÄD×³¼_£0ÈZluíàÑ	B
Ï0ìdºD`²!ÀóEßø7í¶Û®üà?(¿þÍo&Ûr¼©ðù1É Ïá&@"$@"¬Åsóãàsppprpè(9ÐË3PjS[¡±]-¬²ÓÒræó0?1Ì¯
9$àèç@ô3?mì±AhOÝüôcó¨³bîø$æ(%ÄB»ï¾{Ùzë­ú<«êÜsÏÍí¿oFYÅÌ1£!¤HsÑE»îbññK¿þãÏ´ê-7Úh£æÙ³fÍ*n¸a¹÷Þ{Ûù-[¶¬,Z´hÄs$Wýh2C"°úð5pþùç¯þäq­C`*}~¬u'/'$@"$@"0é&æ^_ÇqÀSÀ/È1À¥ ´xI59
6Ú¢ÃÃQ7h¨±OÍA§à×ÀÔöCþÖã±ö¶]¯£Ïxº':ùO2uôãµMëúùc~lõÙ8ê;Å3æÏgÌ)@"$@"$@"$@"$@"$ÀG`Öåäcr+K988
øêò,´´ÚNB
?Á,E-1~ãXª©ÎïI£Ä>c;FcÑùEýÔQ:6âÆjË=vÆn·ÇVÁ¼
ÏTÛ`¡]=/¹èrûí¾ÿ4&+ýÃsèö}À­,1Îs+,
Ü|:ù·½§à@(å£>¹
t1O?|ãà¦>qì·6ã¢æ§Ðm-´C|Çâ<ñEç8±G1OTÄ¨Ç^ó;nìãÓFÏÎ±Gµ{©tï½ÜI9cR¢c2i_¨FIÛ	RÏd?%}6u_|ú=	æ×~c×:ô:bq=9Qm¤9)ú'1ÈO¸ößxèû$âì£DlÇì©JÌ1Á­¶Úºì0gGªð¼º¥Km·ß¡¬¿þ7Üp]¹zÑ»ÜtÓÍÊ®»ïÙØß{ï½å¼sþ4nß4LD HD HD HD HD HÖÃ[Y¹¯¢
êèÈËøê_èc^yìá9ê¸úêG{8ýéCðç0?:]=^9âh¡T_ÇÃN[ã9nüÆÖ³¼_aðÉ2ÈNª3§vøSç°¯´ýæ¨Á«óÓÏA?%ñX¹æÒHÚ>Ô?cDh× ×ýµ/úNþäDèópåsÐÏüè¨cO_û%äÐcÏ¹­,OÁ­,ëUm÷Ýwo¹rÁürÓMËBm»xÆÜÌY÷kmoyÝµ×k¯¹*à[Ö[oýX}·G6mãÆBb.%HD HD HD HD HD ?cîÅ1Öq@ÌÁ!ÜÜG¥Ô|}´á|jÒ½mêôëOºýägkL¸
' tÑ	âä xààQºÚÐd|Á'Ú·O:2]à ìó2âH/r²)]Èa¼øÔGt«®J	 '²Í¸£
$ßQQMÎÃ¯ÎKø)%/¾C^×÷¡(ôa^Ù§NðL³jöG'¶x}}²¯ìû:ö Ë¾|£
¼Jh_z%#=FÊ4ñÐ.ê¢­^@ú)¥ºèÒ!ûÈÃtQóKY¢¼×º'fÌmm3æÎ3æH±T%ûÍ
Õ½¼êÒ#ûÊ CÎ^åF¬ÛÈI¾ºäQ¼¼¡sÿ)G}ô_ý }«æ:¥ìSGùNpEuÁ;#]8éAmF§å<8ÁIu#·§ÎÃ.z¤~@þû¯¥N¥dD7Tö övdyé°j:²Ø¨Ã/è?4Én¨²OCus,eyæ²eîI|D"@D "D"@D "D"@D "P)­¥,ß`ÂíxÀò>qE¾\%ùhÂÁ Rxá$§6üÅÃPY[äXàÝbéíP}|S]<¾F[ ÔÆ&özÈ§àò*¢Ë&m_·fÖ!ÿTÂ#(Ú¾ëÒw¦k¡#:tÐAéÄQ¾Ó¾
8ôHup|P`å4êð
GYÔ/FÊºé¯àù JÀAç $'û´9à< ~ê²M6&Xs§EbD"@D "D"@D "D"@D`tG {­õrÚAüräR Ú y%ÕÓ&9èäg òÐÈYtÂ'9åkÇ¶hEì[µW}èòY63.Jpò6¼²/¼äy¡#çû/ Ù¼ìÓáÐ-«VÖ'±¡@RI	8è²ïëeÁOEUÈiyHN,xpòIz¡¾®²oÕlÝÐTdÁÉ7d¡Ù7TÛ>z53O~Hr öuÑîíÊwp²/ßSäÐ¿Sl¹3{ÌÑé@D "D"@D "D"@D "<#0Éö;û²,°Ä¹	òä
uô@WÐ¤¶)]ðdx Ú^ý¾-~xñ#/ûò¼ìû~"'}ìõ¡GKY3æ²(#@D "D"@D "D"@D "0z#Ð1÷zëáB;VØ¡$I)¾MN<¼Ê7(÷ d¦<ò:àEù
òð@çæx´¡K:8éS=ðâ§íAº¥>ÙOz¨û!|£­~ÉÙWnFmxåuððóuùgè]éà¥Ï¢#_	d°pKHÎéPÀàáð_¦`S¥._B§M HVÉU3^¥ðð T]¾WàëðÈ'èÈÒ}éS)JxÇ_õI|¢Y5óS@>ÛúÀCl¹¥#{ÆÜML[l±%ÈÆåðÇpîÕWäú@k­µv2uZÚxÒäR¶^Î¿ÉfñRÀª0ÎrS§ÏÈ	¹"õ±ÇM·ßvkºëÎ;¤FÚÏÞóÒ_üâ®t}ø#éo¸ø5eë­ó­oÎ=÷ÜàÈ
FÒ÷§ÊïWSqHÏPÅ$Ü?ê÷PÓüÀÖ
|bÿo,X r»ô¹Kþòôãÿ¸MIÕ}þºMÌ)F³UE~0«È~Óåú6^´ÛÕµí¶iÚÔ©¹Mrñ%K:ÙøëÙ7ÝtS©>1÷C[1â¯
< :ÚWÔ!l"#}âNðÞgd±Ï ðâ}á¤KveC¶/(tÉH§ððÊ¾äà%Û5µÛ=æÆ®7&M9Ùx,Ýxí]XAÕÐÁ¤ÉØl·é¥ºIÌ=ÁÉ½ór"$Ö
BD "0
#Ð1wumË[]$OÁCà iEN¼\â
×]½H¹äÈâµ²õm¶Ù&Í>=¿¥{½¹{ã7æû)+ið§pGÛ¨ðeÆÙí%vKÄAUXæ<ù·åQwÚ]<Mÿ:ñ#½ýöÛ'6åMkc½Û®½[m3n®K-g#¿(ËÙßo;[Òd-irÅÍÀ¹î¸uú/ÝUÎ¿d'O¿»ÛÜÄØ~.,¯Âw¸ô3ÿ½/òø¶ÿ®2pÂñC½Þ¿êúÐÔýëwS{ÃxóÍ7Ï÷u×]7-¶qÿÑ}µèëÄóµÎ¾,Ù4°÷æZö`ßÈNËë4qý
HÌy` ä¼óÎËËcz¼ê$^fËíðG70ß¾oobv/ò×iWX~ßûÞ)Úíf¹&ÎÝø±û«l9¤	&»Û$~vî¹éÏ¶LRPX^a{Y<ÿyÏkïÑ([¨iÏh(ºý÷:«þà±ËìÙ³WÙÛD6{u|ÿ?è7¸¬}UpþÄ'?¹JÂÛûDDÞã.»ì²túgäzÓ½Þ¿êÚoâþ±%<à´ÑFºCBáÿ÷Ówö_Á"þX_¶ý,t)càò¿>þñÜä^tla¯Ð&¯?Ùì¥$!yÐA¥Í7Ûl1sW\qEzÑ^ie¹&ý¯òý©j¿ß/RÕ¾]7þÒÓkÙÔýóÏ~ûúøå¯~þeÏ/|áKïÃ¼­?wîÜ~®Výþy%$_õªWå¥÷0õÀó3ìw½¬!èf`ëiO}j^êsk¿c¿»è"©ÈeÕóßÔõ7\¿¿
BÝóW÷ú©òûïSíåNÀ_lß ÙþAeð:K^i/£Ï|ö³ý^jâùk¸¾ÿz Ïu(®úüZ÷ú¯ëÝó_×ÿºòºV«Þ$_÷û:ýä'>UvZRöTúÄÏèúÿðË_þ2ýêÄ±JÌUí?û¡³/°Ô^ãÿgñÅ^ò`Æ6øÊ¾ezQ®©ó×îhns$À>údí¼èÉ=ÌCÝó_5þM=?û¾ðÛÿÙÏ|&£x¹ìäíþú««{ÿÀ¯:¿M=¿ãÃÿ ^
.¾D]ävD "°æF µåAÖì ÑFJùò	Ê)xêä*øS¤Ämø¡{9ñ§uÿ'
7c®iÿ«|ªÞÿøýªÛÿºñì|
xÉº~WxfæÙYÐÄù®*e·9V9ôÐC³	^2ûöqÇõ3Wçü×ÏÏý:b
p­ý÷<é¤DêXúÄÈÇmºÃ=4M>=óûÿj%æêöÿ¼ÔÁ¹ N?ýôöÿÇ½ìei¯ç<'ãyÁí¿ÿçúýwhâüeå?ºIÌlyë¿ÿ{ûe?Ú¾ï?±ýß=Ô9ÿuâßÄó³ïêÌÜä¥\ÿ[//ýõG²Yõe°¯=»ìùìggÒíùø¯%ÿµã÷£çß_wxîtû=À·%Û¼£¼9@9	êàÈkàÇJ«fºÚðrPW.DmJoKràÄoÕ¶
_xai èõü
*|´9à(áÇ upØ dKú^ò5ddWyøåx$+9Úð<4 yÙóþbzÄ ÞëO¼Ò'¿ð­2 ¼.à<NÐY,sÈN6Õauyê¢ùN.>xÞ>tèècæ¦FÒ¡.ÿñ íìé^|<6h:4s>HNöÁQ=É^sS´¥,²|óÏN'GW×pÿ½¥ã¿|Q×üU«$æü²E7/,¾»^¥í÷£óÄys¯J<°¯èu`Û?Ø±³å@òaÌÿ³µ×Q§¶ÖKgp}¯º?°þs{þ·6[®l3ëA2ü§ü¬¡flw»´ïN´79M8TÐËÀr½lÔ9ÿMÄ=ÝUpÞÏ:ûì<3Ó÷?·[Û-gMBq`ùøNH×ÛLË"°DÎSò&)Grh¢ÿYûèåüûAU®I®Í2`y¬Àå6ô4{«Á#çÌÉºØò®ß´e^7Û²[;¸e1?e{P²${%½Úfçñgõ¿ìÒâàxnà£×ûW]uîÝÚö×xqÆ³µ0àÏÀ¿XýóÅ§³íû!ëOº»)ýRBÅLßrË-sb[m
ÿ{ùþ4m¿×ß¯ºöëÆ_ç¤jY÷þ)»~`ßfî9,YÙtúþñLÃ³^ºè·ßUø4³ß[È³}Ü#ÙÛ³lW¿êéQÙëõÍêþýßÞÇâýÙª×OßOì6=°Úëó÷p~ÿ}²ºìÙÝ&Yr¢:í¥
o¯Ï¯^/×þ7qþ«úïåTï¥ÿÈ4uÿ©úýßÜUÊÌI#ºYÏ'FHÌØf®!à&K6}ë[ßêkªÿü?á¹UÛ(¨¦OZi¥¸ev®ä£×óW¢¢'OÌ
àyYsþÐrÛï1×TÿQÌråüOf²%,=]õ*çO²UËns¼¬Á÷¯´ßtÑ^ÕóßDüë<?û¡6çôz¶åÙç_ÿæ7ý^Üô×/l²ôeì¸ÃíåÞ}b®ûGßºÏ/e}GüØn¢ïp'DFvZ3æ6/çÛÁ@??ÚäO N ç 6uå9(áçW-å((4ô ÊÓ C¹ê møcMlPç&ýØ -iÐÑ%}ÈË	é}Úø(EC²G)[²/¿}¯O6°¯XXµwÀ@]Pçä4ú¼ã´ÕYñªÃ*%«NÒ è´Ú^N6d?º¨sxt	.Ú¥¯ôøÈðÄ)Âù~àúbÕ¶NpâÃú"ûÐeßª¹Ø`KY±xÉRðÂ¦[LH½õgMØc¤KX>úÏtóù¶,×²üvô¶ÇÜ¤ÉOl/KIríöÛnÉ¼Ý|l°Á4}Yí7²o¼áºtß½÷t#Z§×m=Ø
4á¯ÚNÞtÜßªÌ`ÙÐ'?éIy6³dßaKõ°,áP_ÿ½Þ¿Ô§ªeû6IË[Øþ&ÝÀoûÛôóóÎëÇê{dÌOÛlau8Ïnm¯^p(®?¯°:÷kîÛÀ@3©ßxÈ!iöìÙÏ'æÂÿn¿?8Ó¤ý*¿_uí×>!5>êÞ?eÚìuÚçL¼Å²Î÷}ØðKmtj4°oÐÿ·
T=ÿMÅ¿êós§¾òÛÀ*$Km¹^H$&ð×_Ä\÷:ã7u_(#Ç_Z3æ{È"@î¹ò´à©C£Î¡Átðä¡Ú9Ñ#·!yêÈÀÈ¾Ê>ìJû´åudÿàø lANÙ§-ûÞÉQÂGºÚ²/]^:>Rª.>CU¨&Ý' ºè?qrP<ðð(ÉD]mh
2¾àJ
kVÖ¤Ä_¢ÑïáC0fÌ<?á@§Ä3ãH`±÷
lmµõTûcº~{ fì°jwÞqÍ k>)W¿úÕéiO}*ÕA¡,1§·ÃZ>Äïqô1ÇäÙl«ÈÀtüòIþ`Ü`f~aË¤$X*Á=ÊA·í·ß>ÿAÁÿ²}äøsþ
Û/åvôG]üºËf!±¬äUW]U¦¾%²vÞyç®tÍXâÁ?A§Ä\Sç¿NüÅÌ£-ì®Þ¼ö}¹ÆÞÀ.;÷§J]ËËìûÍì¼ýÊÒ
XÖ¦,oæSEWYµÿuÏ¿ì3ðÀÛ~4fÐ±<ÛÅ_,ÖUJ]ôo-'ëg$d³X	ðö-oá6	uï_u}©{ÿà­è}_úÒ4{öìöï>é¾AB¥ráKÌ±ì%÷! ¸ìMFvø¨zýuP×û%Êi× "F³O/´$ÿ´ïÐAuòrKÜ¡ªÿM}ªÚ/ö£×ß/É×±ßDüåG/eS÷Ï]lê[×GYâv úþñûÉrÕOµg)ÿÇ6e©ZÿÐÍÀò~yUÚÌÈÿ%¨=Ô9ÿ^Oëo¸~ñ»óWçúQìêü~òüÉ32IX÷U¬ßÖÒãÚN=í´tÅW­½ü`çïáúþ·;afòüÄÝ<74Xýgç_þêWù%l}Ô}~õº¨W¹þ«ê?²uÎ?òªú/UåëÜøþaâ~Wê[±|½}çü¤'eô@9,úàó³IYbUúÿú×½.¯xü@ß_¿\ê`}«zþðÙÝ¬p±^kö*¸OÎSúÚî6õµ¯y
t@uø<0ËN<²©ìH¯ì£CöÅN|ÔáE'ì[5û)à%ØG¯µ½ÿÐò]Ò}é/âÃã½>ñu]Êh×Ñ#8®ÎUNÓ:N:RP¥ËPº:­àCtPÈV~A£¯pEýÒi¤¬K^ù
ÙÏð	°¡t@r²O~xÀâ§.ûÐd
NbC'¤pÐeß×Ë	.%ªë[£ïÄ'¤ê¬+'ûVÍöÑ
9³ü¶³eYÒú»ØS¦Liw¥=ÙB! "DúG`í1wö)'dØv#7AÞ¼`ÊI_ðukæÜrÈä#¨s.èxØrà+9ìS'?"ûÈ ¾?ðè£Mêè}x°`_yÙ.ûÔ±¯ü|3T¶tSl}|8ÚATV`èP(uH§$gá×¡ K2_|
oS·NÁ£è
tÐV0¥>@ÛË¡ß·Å/ ~äeR~}ßOä²¢>ôh)Ë3bÆBeD "D"@D "D"U#ÀòìÛ¶­KÎy]§zjbíò°%KY²LòÉ'®7¯1°9/|ÁÒ>ûìS
;$")åÁ·É)gWùå,rÐQ^R¼è!¿<üòÃª¹-ûÒ?òäGd ì'~JéMöoA_ÞòìS}É©
pÚàtH¯òÈAö¥}È+¿!*ÑI]¥U3`@×A[öx~lÉèð)Ï.À+ûÂ£Kú ä#2e}ÏLÝ|Hy7¼x¤C%RÈÑÃê8áU*ËÑé,º QPhðèÉ>8dh«¤ô«ø7Ö¶}éS?åxÀsòäÅ¯6¥ì&>ÙNð$æ¦Øs1cÈD"@D "D"@D "ÐxÆÖ]wÝDâiùòåëM
ÇfÎ®¾úêÑÔ­!ë×ßÇ{,Ï£D"Á#Ð1w°qÎ·C9$ÀÍ|@	$JáÉ/ø®§©uJÉQ*á%º¡2WN>ètx½^'<Þù_ä@ò'^¼Ï?ÁxTR¬U3F:z ê¾´éSLú°=~JYbýØu²¥6Nù H  ñCC£.=Ê*hJ¢éd@Tð}`<¾OïêÈÁ¯6ºý8hÒ_ÔuÒ©cÐI¦¿jcCuÉ).²ÙW2ã¬>Ãö;-ö³HD"@D "D"@D "D"@D`G`òÆ§³N9^KY#§@üuåY(iH y>%Ô¬Jå.¼dÅ^Ù#w!YJx±ïA~ÝÊÿÐ¤C¹/#àâWN<vÅK[~+.¾ù)>ÉøÁõ¯Ò8#ÇÕ1p®(ä|À
>téQi¨$o_'>hÒ-¥É/lHN8JùéCôYµ->é.òÃ+»c[%üì£Oöá¥~sÓlÆ\,eiD"@D "D"@D "D"Àh@kÆÜ¬ì`9r$¸ ò
:È#@SÞ Ç;r
|×<>éVbûÂQø#ûàdP?©çåÀcåzv¥,-@D "D"@D "D"@D "íhí1Gbn¡ZÊ¤y@	0JÜRàÈ1xätCmhð³ÐrÂÁ'^ÚªS
d_yÉWvá}õì£Rö­ÚéFÝ0aºé¿@rò§XJ»òïtu]¢ .à:Óê8@+¡$çû¨+HB(9éGÁWòÍª9¢Ë>>)È@.ò¬Ù¾µ\¤ülÿ²MþQÈCW?d<ô_òVÍ~[×ï?4éO²<{ÌM¥,	S@D "D"@D "D"@D "DF&o<Ñ²<¥,Øñä<È% J)× N9pÔ§ø$ä× u%©Ð]:©KÞªídà§®<<ò;Ô½.Ú t yê²NöÁù:¼ 8l*g<ö=]öÅKÉPGÑCõRÞT9·ïÒ­B'¨à	?Aàè%ü
,2à	%4x ñS/´¤ÏëÀ¾?ÁÐè
òð_PÅ'ðà.9å)àTb^ñÓö ÝÒìÃ'=Ôÿ?{o¬çuÖyí»µZ¶¬Ý²¼ÉB 	ÃhèaHâÚifzB gºz)
jªºgYºn
ïfkû+(ìæú
Hçk­a½§ÛÐÍc'ÎÙ9S¡7gû{÷öØìO9úíïÙï¸«!`§>óÚuu­¨ß1÷Ñ]Ès,,3fÎ,'N(;^|¡»Äh~Ì;¯Ì­kfÍ4yr9vôh9zäHÙµkg9u
HÇ./)Ó¦M+(ì{d @A  @A  @xX¼paý¹{$æÖö¼¶QBÞnAÞDA;â×É¿`ga·©jì2¾ôÃ°?±öG!þm³ã£µ=SÇþ:ögNâôO>}â8cg§ßþØÑÍ­jwöÔ²>¹ãwáDáÈÐÔõÍZ`ìÝæÖN¸@a ¡&ÂÙ|lý5ôÙëkMìíÌäÒ_ ì,b°gmÖ²¯=üe¨©½_(j!æØÇkj'ÖþæËs«.ï»bþ²lÙò2sÖ,æ/G+±öèÃvú¹~L4¹¬\µº,\´x`Ø±cGËÖÍÊÁ¼Fwô2ïùåÚuë»ÃÇ{xôÉA  @A  @A  ð*!0üÄÜ;jûíuñÔü¤|g¹tã[¿qUíÕic±<1êúä9Üío
ÜL 6ù_{	OÁBØå¬£\6ÄÖÇâðÔÑ¯3sá§ýÑüÄ¶ÂÙ:ÔwïI.6ç$Å>UíjR£»9öwnâësÆÎÂæìU»´
x
-ÎÄãoóÁNº\EU»ðô7E=«ÚÓÛzð ÔEúóÌoã­;qÿ¡?ÒÎN¼6ë[ºôwFìyöoãõ³>fq¨1'6	ïÃ0«õ{	?|.mLU;1ô³#cþ¶>9WUí@åLwuNóCpë3#¹ôikÖãÖa7ÇZÄÚ_\ÚøöøéÍ"ÇZ«©Ñ;Ï¬çÕo½ëîïÚ½ß9¥%æþæ¯?°íñ/óæúÜ´iÓFõs|¯O·!ãûê þAÄ]çh~L­Oà?µöo%Ä\Fô @A  @A  @¸~bîuÆÍuAÌÁ%À#È7ÀÀ#`ÇÖrò.>9G~âÚñC=0Î~ìrØÈ'æ'EgjÉ©´~kG-º³WSgÃnâÈµ¯yØ¨Ï²/±C8k§ºuÙâÆ-¨´vm^ÏÛ8/Kz[ËKë`òbõaÓÍ_Bt¾qæÓÇÚìú­ÍÝöCàÀëÀÙ?Ï~ÔgqÆo}ìÏªv}xbnõh¿cîR#æø~ºu×]Ï]Ë¾½{Ê¦§6vº?®ºúrõ²kºã/<WÙ¾M×À}ÍÚueþoÇ/%W.íôsá1 @A  @A  .BWYòZ¼}uÉKÀ! rèØàCààð¹Wµó{f'VþF.Ä3{ÛË<lèì=ÐéÏ²[¿¹Úzr'Ø8³#ÚáQèES¡1,|æ×Öªî®69Ô`'§ÍwÆ¶?¶qÅ/80jÅ¸ãC7þä`óâTM=°#E<±Ø ®È×^Õèí­Cr9£SÃ¾öÐgÝÒÅobíO>>òXÈÙt6üèÖ¡.ºuØ«ªOÜºÆõ*ËKá¹É'°2JyáùgË³ÏðÊÜRø9^s9mÚôîüÄcCüËÎ4âÇÊê5×v6¸MO=ÑÕÆbnT9 @A  @A  ÀEÀ¢ÊÇ?øþ;ë[ê:\nA>Â
À&YæÞÇE<ÂN,6þH½¬¯Ýºð*9öo!£­k®y1B>ËþØlí¼r.Ô1Â®½­G±Ösnòf·P|¢ÂðÁerÐ@-pöôÂ^|t¾öÒúíÑ×öÇÏÂÏN=\óÑHÎ9èÎÏçäÖßæbOOË'ç¸yöÇNb?sõKÈa''æV½­¾Êrçeø*Ëz·²dÉÒ²|å*ÔN8PvïÚY®¾fyáÕÈ/>_Ùöt§ú1uê´rÃMõ5þÔ©SåñÇ./?^6Üz{bnj± @A  @A  ÀÅÀðwÌ½£Î¶¥.98£uÁ pYJËwàãÇÓ^Ø=£ã73º~úójL¸
jjÕÔqüaÜ?«³óÇt¸ó8.¡ÝxùÒåzÖo¸|Ö$¾ÕÛxùüäá£?ºõ°ÉÓàC°Ù:ØÈCÚ~Î£¯·ÿPÖéÄROöÖ®Ô»C:a@  àj/*^JÃïåÍ%xvóõ1+6ò½8±íús³½µ?:àI¦UµÇ³±­N=ûkÿvG§~û;gÄþCìÓÐÙ¡¡>ý:5éÏ»*×Ö'æî½Ü5kV¹¾¾Ù¿_yjããÞÿ£}*nãÈ»k×­/ó®ß~ÞóÖ-Êî];Ï @A  @A  @¯ÃOÌ½½öÞV×Ñºà9 °ä àÐ±ÉO`cÁKà#G;¢]?:ñ,üì~ê£³k¢Û\½¬i~zÎÎÙÐüÄÚ:õ'>ñlMÎbÑêØúg!!Nium£Þi0Qqxê8t{tÁ$FðÑü, AÌEoç£@jãl-v{¼;>À·®9Ö©®ÎgçþZý©XÝèú­ar°yWtD[û*Kj`okÑZâÄs+ês÷]nOÌÍ_°°¬Y»®^¯;^(ÛÞÚéý?]³¢,½êêÎ¼uóSe÷î]¾jõÚ²pÑâþðóCÌ¢ @A  @A  À«À01wgaK]>1w÷ ÎS¿hýØà Ø±£ûtñ±S³ââeGìnv¸ÏÔD·U;¿ýúkZxsÉ±µ±agÉ¯ SikQÃ{ÃZmºgbÆ-¨xij9¼å"úÛ´@÷ÌâY¼VZàÈP³?6DWËÈâ7×XÎÎ5hNlÄºªÚ	g|ûÛ~¸ØC"­­îÙvçqNãìÇÙYfW}Ååøs³fÍ®OÌÝ\¯WêSpûËÆ'ëôþ¼ÊWZ"?úp9|øP§ó*Ì)S°L6µÜ0üDÞúúÊMO=Ñ¾ôÒKõu|d @A  @A  @-*÷à}ïª=UOÌñGm8¥ªvâ»µÃÂÎwÐ®_±ñØ8Ãgð½PòUíìì±æ¹[3ºý«Ú	6âäQ8£sìômç³»uíA|ëç´±CÓ3s&ßþÄÚûÄ'RDà½¤ÃzY%®XÝ	&;¬
 ·µSÌã©k9,üm~=öÄ¹]RÍ9&±';5Ù©ïÜæ3ùöïÏ¯®N!!RÑzìùmÏ9õ¼ú­wÝý¡]»÷à?§L>¥¼åGo.'O*~e{Ù²ñeãÍ·ÜV¿7nZá{Ý}øÁsÎ»áÖÛËÔ©@SÊÓ[7];w3wnYwÝ
/ @A  @A  ÀEÀâÊý|¿¯²<R BààXêòððÄòwI56âÌe÷\Õ{!|yÎòêm¾ºuì/oB;±r#UíÎäË]G7ïÔæWswvíäQû{vûWµÓÙíN1ÎCMlã
MTÚa¬Å­x0tvxlÐ¤^Ý=ð¼<6úRÇÄ#ÎÓ7b}]¤yì~ìæè¯¦n^z ôïïcvò­QÕ^,:¹ôGÐw&îÏ\ýÕÔý9¨CÌñ*ËæU]WùÇX¹«ÖEô&æ5ê÷Í<q¢Ì®¤Ü%K;R;^¬¯»ÜÒ=bî|Å@A  @A  @#Ã¯²|gmk]¼F¡%®ààØá3ð±k#@ÇÎ®]yï_ÕÔåÑXûöïmtû3º1í³âéÉ¢øæWÑoOÎ­^]
~D¸VxÊÎv{ÊYØÇºö§ýÁf:±ÔdÙ¿ªÝöÄn6j²èO]çv~|³PËÚô·¶³O«µ·õõnÓQ'%:Âà^ÞPælç ÕZÕÔÅ³ã÷Ò:Ö@Ç8À:>tbµ±÷×·fuuµdz;9öqfâzHÀág!æÙ3xb°#Æ£Û=æU'æî½T9¾×mæ¬YåÐ¡åÇá^ç«-/óç/(3fÎì=!wêÔ©räÈá²wÏòüsÏ·F@¹~DrA  @A  @A Kabî'ë¬Ûê:\<ü\
ÂWTÓÀg~ø^6kP8óäkä1´sÖg.µì_Õ¯büÎl9k±cs~ÎÄÚ_»ùÕÕÅâ'¯½±9ö'ÝþÜAµÍ©êøDA±9 =ü  $àðÛ¿ÕIRK¢<_É3YôéuÙ¿ª]jãTr±9¹ø°[ÇþÕÔëO]ÌsëÐß_ ÎøÛ¾ÎÍþÎ&¦äQf]+ëwÌ}d4ß1GÒ¥,'O.ÓgÌ('MîH¹'ôR¾UfA  @A  @A  0zÕïûøßgÍØRÄÜ¼¼@_hõzì¸løÈCà#ÐYðø­IÜ±ºà(°ÉCýÑáGìOÂÞêÄ³´S3=Ñ©cbèÐ_^ÆþøíNùg«¦®qÖFGÈ1ÎÆ°#ög6c°q·8À¸ÔDj»Ëä°Ä»ÝäO¼qÐÑÀhûc<têà4kpLk°ó!pnó¨ß'1|û³;vû·÷$O±?}úëQÇWYÞw©<1çÅ² @A  @A  @cG`ø¹wÔÌ­u­KRªö§ Ï@¬|Ü6sÉÃ'"¯Áî":ðäïUíÎö·ñä³ÃØÍþÚg·>ûË·ÏB«íC>btûç¹ô±¿5ðKl4®äá$ãÈeÚ!½ 1øÀhÁÂFDµÚÊï[ÐÚXêZ«ª=@§¾ýÓîwUíõA÷.îÞ½XgõÉ9l}Ú^Æi§?OÓ
1Æb#åÅÐ­#ZMèDóÃÀ)ø-0müP¡í<êäïÚípø¬Ç\è~èèôGüÑ±#Îëêæý©cbÍUõµõ;æîýVø¹z×HA  @A  @A oi/\Xîÿà=¾ÊbNþ %ÏÂÎY@kã$ÔÈ7×]î¢Í1×xêÚîÂ\vbéßsb#Úò?kÈõ´9öÀ¦/§¾ÆrvnqiÏôqNg Çzæh#ÆxlcOT¬Áãà^¬%´õEàÀb#ß:îÕÔÔö÷Cc'µÑZø ¿èa6vg£õ¨a½ªöò°gíþxbbXô1¼Øzö'ús«ësye"@A  @A  @AàrG`ø¹wÖ{n©ïCàBà\ðøä=Øl<a×
º¼	6ó¬ovûS?±ÔDðcGô¡c·&±moüýe_9VW[\ç¥üñ,Îìä8gçîï?h>:¡ðDÅ¨Å0Ë®áÑ6®½<:µùÄnl{X39«Ï¹gOs;<vtêëÙìvúqæ>èÍ©¦ÎßÞû£ë]8ëg>[ý¶»îþðÎÝ{ª	A  @A  @A  .g/ZTîÿÀûxå¶ºÖ QÕ·¯Ès¿ ÇÒxÄâ7OXÄ~ÄÏ¹k[8ûgô $ió83â<öñL3¡c'[«;_5wvûZÏù°[¯Ýõ?.±á¸vP
y>kr7±¿:µQÚ³5Ìe'ÖþÎGoûÓÖ°Û£M¶|Iï  @ IDAT,>¶¬3£
FëGPu~¹ì×¿·uô1:ù.A³'yÆ
÷}úÉrÿç·ôÅ@A  @A  @¸~bîÎ:#äôÛð-ïÁÎ!­à$°Kp§??ám-b¨Xÿè®­Fv{à´?:u¡.Ë8ú;1Í#álbXuvëC
õOîO®^8«üú?ùö2kÆÔòw=W~óOS³W;LÃ%§Øgv:KÄËg1÷òaÊA  @A  @A ¼r?1÷ÎÚqs]süqA¾;¶{wñÉ9bð×ÖðêA rFðcËÀF>qô088|,r8ûDgýÖ Z,ug¯¦ÎÝþÄk_ó°Ñ!Å¾Äz&á¬êÖeG·Px¢Ò^Øa´yAz ª6ÎË£ÞÖòÒúØùÕM;6	Ñ|~ØÆOk;+9ÖfÇnLû!HÀQÓ:¼;Ïþø|ö#Å¿yöq>|ÆTµëÏs«/Öï^É³nÜPÉ´eß¾=uí-×­¿±L6mT¯²ä;åÖ­¿»½{vÍìt´þ;wm[7ëêöéÓg6ÜÚéÏlßV ç^mùÎ7Þ´´üÁ'(;öþ{æûÕÎwKq1w)~j9 @A  @A ~WY>S}ûêËC@ä$Ð±ÁÈ[à`Gð{f'%WAmÏìm/óäKØ{ Seÿ¶~sµ;/µåNÑB/j´
µaá3ß<j[«ªÝ]É¡;9m¾3cÝ6>¡ÀæB­xw|èÆÓl^\ª©óqö¢ÄÏÂÄùÚ«ÚËiïhú[öµ±ÎI]6ûpfIá#ÏgÓÇnêÚõ«ªOï¼¨_eÙMÛü¸¹>7Zbï[µzm=è8¾¯âDÜÍ5»\ãÍÛÓ[ÊÎ/vz~%WÌ(æÎ('NÖ'ÏóÊÍëÍ+ëëB÷:^ßsxDñs¦¥óy°s¤ì:p¬GFOÖÍ­ßG·¯Ö|©Îðíë%WÌ,_~rGyxëÐÓ¡ËÏ.w\·¤Ì=½{-èçy¾©p¦bîLLb	A  @A  @AàÒC`ÑÂåã|?¯²ÜRC`Á-È'H¼Á3`,sïãÌ"a'<:6z ö²¾vëÂ× æØWxx¶®¹æq&NÄ||ù,ûcC°µóÊ¹PÇXl»ö¶qÆZÏ¹ÉCmÜBñ
Ã3eÈAµÀÙÓ{AòÑYúÚKë·G^Û??;õxrÍG#9#ä ;?3"[[}P>=|.ãæÙ:1ýÌÕ/!x[õ¶ú*Ëá«,ëlgÈX9¾nÝu×w5öíÝS6=µqD½«®¾¦\½ìÎÆÓp<×ÊÜyõ»ë¸Û²ù©²g÷®Öýüö÷eéY]Ä¿xÿË¶|èñvÏÏ¿©s<¶mOùå}eDÐÿs÷wKF~¿ çú¹y³¦ßÿ7wuö<VfÏR¦Oå!ù³.¾TþÛ7­ÕÔí¨vD<;2± @A  @A  p)!0üsï¨3o©b? ò6¸"Kiù|árZÒ»gtüæsFÑO^	·Øcè4ÔK6j ÄYß?c³?1}ÈÇÎO.ü1b@
¥¼øâóåmO÷bT-^RV®ZãñýÔ©SÝSt[·l®>àÀª+çÿë~GwÜøx%¼>[^:q&Fïþ¡Ê¾vy÷¯?úµòõM#J\wõ¼2uÊÐ¯ümk~Êm,ÄÜ_}u{ùÐßn,ÿüGn*o¨D ò_ÙVþðË¿úñ[Ëí×.îÌ?ÿ»/ÏíæÎsgbKA  @A  @Ãß1ÇsüaüP]V\~ÅtÝù#­1pðúªÚÅâÇNäS{ÆN]mUí»<5X=¨EyÔäLöÎæ9«3Ö°®N{¶?;â¼­ë¿Í5;1ÖpVk06Ïm
¯ËDÚ×dvü(ßûeÝSj@ñÍ-»ËÿvßWG ò®,ÿÓ[oíl<ÕvÏ_>6Âß1÷ÈÓ{Ê¯Ü;ô½u<q÷Ë?y{Wö³?WþÝ<Üé?TØ»»>¹ë`È @A  @A  .cïÛV¯¹¿.y¸<ºg}ÕÔ	g899ìmÔáÝxvkãCì!¿u³>rå\ìOqµÍÅog$ÖÄ¡³Ý8çáXXD=µyÇù³½Ô8KHó2ìÔæ"^ËcÃçEªÚ³¸·`	æÙC Ø%Àð±è¥ÝÝþøÉ~Ù|Ô#3ÒÆ¡Û?äÂ¼Îi_ëq&¯­S]1Øú¶ùÔ¤6qsëZ]_eù¡ËõU¼rùU=mßÞ½eö9½×XÖûõUÛ¼ÊræÌ§æ*£W¶?½¥<éÇDV}èóËµëÖwúñãÇËÃßüz§çÇ3¦M.÷¼çMeÖ©×~¾÷w¿PÛsú5ÿëOÜV^»nè¿ô'ãßÿgñsþæ³å·þì®è-«_}Çk;ý£yª|ìs;ý-·_SþÙ?¸±ÓCÌu0äGA  @A  @1ÃOÌÝU¯¸©®uÁ)HªI¨USÇ-À%°uvx¸ó8.¡ÝxùÒåzÖo¸|Ö$¾ÕÛxùüäá£?ºõ°ÉÓàC°Ù:ØÈCÚ~Î£¯·ÿPÖéÄROöÖ®Ô»C:a@  àj/*^JÃïåÍ%xvóõ1+6ò½8±íús³½µ?:àI¦UµÇ³±­N=ûkÿvG§~û;gÄþ<ù´9C¡>ý:5é?£®µõ¹{/Ç'æÚï;qâ¥òtý.¸½{÷)S¦Ô§ÝE¯ì=E÷üsÏçÝ.N£Þ×VbîJÐ!<ôrìØ±Qç~+¶ß!÷G_ØRîýÔÝµ¯^0«ü»{C\IÏ-/(ÿò÷ÿþ¼pûÔÏßþÄÄÜ}~²Üÿù-]Ïsç>A  @A  @A \F?1÷öz¥mu­Knü69|äÈI`Gô£ëG'ÑO}tbMtû£Ës±5ÍÃPÏÙ9;:XûS±>ñÄÀ§ ­ÉÖUgï¥:!Vium£Þi0Qq`ê8tÿ¥ÁGG¼8 æ¢·óQ µq¶»½Þà[×ëTWç3s-Î~ÀÔE¬ÏnMtýÖ°?9ØZè6B|5°·µÈ¡8ñÄÜúÄÜ}Ûs|ÜMn-Ó¦
øbá$$Õ$Ú3ÝsU;î8òåa8ËW¨·ùêÖ±¿¼	9pìÄÊTµ;g.w1Ý<r¼S_ÍÝýÙµG=vîï=Øí_ÕNg·?:9Ä85±[(4Qi±C¶âÀÐÚá±	Bzu÷ÀóòØèKk8OÿÝõuæ±û!°£¿ºyéÐ¿¿ýÙÉ·FU{±èäÒA'Þ¸?>sõWS'öç 1Ç«,?r¹½ÊrÖ¬Ùõ¹»<°¿l|â±NïÿÁ«,y¥%òø£Ã¹íµ¯ë¢ãiºArÃMÊÌ³:×SO>QöïÛ;(ì[Ú6kúò¾÷¼©Ì¬;Â«,ùn¹'O÷üÎçË}ü{ÿübîü%" @A  @A  p>_eùÎ·µ.þ(ÏÐWð
Ù^º=ãW3vêPÃû!b×_Õ^oìþòa§'q,	¹ªöæé¯vúR£ßæ½´»c÷ÆæÜö¯¦Hâ3Î:ìbAüØåì½ æVUbîÃ1WïU6Üz{:Jyzëæ²kçN÷Ç¹sËºën(|ÝK/½TzðkºÊ)SÊÚk×bN<Ù½
ó`ßwÔ-_Q»rèi¹äóëåT%"g"ðßÿðåûn»fã½P~ããßa;×!ÄÜ¹Ð/ @A  @A  0:¹wÕèÍuñýNppprü±;»<:6¹	t¸ü:q­ð1ìö³°uíO
ÕïûøßgfK]spðð`rüá¼Õë±ãä:ÈCà#ÐYðø­IcuÁQ`+!<ú£ÃØß?Ø³·:ñ,íÔãLOtêØz!ô±?~û£ÓYÌÇgíÖîÌ1±?³ó¸ÅÆ] &RCØ]Ö$%Þ%èÖ Ç|âö FÛà¡S¿ Y³`Z8sGýöl<±ñäÛÝ¹°Û¿½'yýéÓ_:¾Êò¾Kå¹n¬ßé6kV9tè`yâ±¡'¡¼ìÙö«-/óç/(3êÓo>!Ç+'9\öîÙSî³¥vñ×,_Y.ZÜ½Þ²
øt<;g­P#ß\w¹6Ç\ã©k?¸sÙ¥+ÎjËÿpF¬!×ÓæØb¼
vúËÙ¹Å¥=ÓÇ9ë£ã±Yh>Q±C2{±pÒÖy/X Xj>~ë¸WSRÛß8|ÖvFkáü¢yÚØ:Ö£õªÚËÃNµûãUaÑwÆðN<bêÙXtêCÌ­®OÌ}K¼Ê²Þ5@A  @A  @Aà[á'æÞYAØRß1 ÁÀ+¸àðÉ{°#ØxÂ®¼ùæÃ¢;vb­Á|
vmm536}Uíq.mOìmmÏÄØÄ`cqæ^:w¥'6ýäâ³?ù,{r&XìL¤5Æá°ÚÆ´>/â~ ÔÂ§xn/l}vë¬ÄUo3+èöj?(lÄµ±õØIk'ÎÚ{ô×Æ°3ý±ÙñèÚÚ<ìôÆÆ>³.¹¼Ê²	A  @A  @A  p¹#0üss[ëòUNð;÷ )
DSK2K?Oµv=öFp2ÏÀQßÍÖö'VPØÍõÎ×[ÃzO·¡ÇN³s¦BoÎö÷îí=°Ù8rôÛß³ßqWC:ÁN}æµ?ê 3ëZQ¿cî£»òÄ\H~¼ú{õ?L@A  @A  ÀåÀâëwÌÝ#1w´Þ×6ÊCÈ;À-ÈÈ3hcGà+rà_ä/ØYØà-äfªÚ#»¡/ýå0ìO¬ýÑåeÈ£çìø¨cmÏÔ1§¿ý8ýÄO8ÎØYÄé·?vts«Ú½µ¬Oî¸Å¡Æ]`8Ña824u½Cs¡{·¹5¤.%PA¨p6[
Ü|6ù_{	OÁBØå¬£\6ÄÖÇÏÿîðÔÑ¯3sá§ýÑüýÿ<gëPßY¼'¹ØxxûTµ«Iv>ìæØß¹S¬Ï;³WuìÒ6{öé.å ÖdÇÆeS_5 ³d·~v|1­N.9~?ûßÚ­
^·þÆ2­~ï×h9¾SnÝúêëÍ÷ì.7=Ùéþhý;wî(Û¶nÖÕÛo¸iC%ï^I>uZYÌë-«aÇÑß]ýLBÌI¿':n~óOÊ)g#æùÜgËã_øa½×|¾ùíï¨¯H¼ª³myðÁúÄÎ_öüýÊ¥HÌyç7mê^¿ÉwêF¦NÿÿÙ;Ïh¹ãÎ· "çs	09Ë¢(æ$YT°-ÉaÏ®?ì9»>ëÝý´¶%Ù)fDX¢Ä  rÎ9çrë×ïý/z3/Ì@ªÒ¹ÓÝÕºîyÔý£ºk¾û½ÐÈZèÓ×^Ë7e íÊo~+Ùv l1y*è¼ë®½G¦çNjçv}\£³=þüÅÕwýùú§{SòýÑË/Ûj4íÙÌÕ7ÿéúË¹å>ðx<ÏgÀ3àðx<ÏÀê3æî²VÛ0pØ.^wC` Y¢ï`1N
zÁ×>óÒgL_æñÏÖ`|Tª|i6 äd<ùûÀúÌÑ§¤®¶ÙT°Ad$ø±ËyÉj]ÆÊxÒg®lÂQ¹D@Î JÀÊ_(|->IHñå+Nqd%Vþa¡ÇXñã'%æ#|ù§UlÒG_®t-øAFsØÿ|}Æ|5gÌY¬[\]9ÎëÝ§_Ô+TÇyu PAàÎ¶Ñ0ppÑù8q
?xiÛ¤yópüØ±°Çªq *£¨¿×®°mÍÚ°×@Å|0à<«#Ú®æv6Õ¦å+Âöuk£82]ûMZ4»6oëÞ3Ø¨°jÝ±U5
Ì5³ïÈ5ßùNýà=áÕG.ºú síºuî¦ÞþÉÍ<«Ä{åv¿  W~8¸© sç_ÃIÏ
FLø>¤¿gÅ~÷rQàß,phÑöûÌ~7/;éyäwg\g¦ÀsM«ÏH]4cºè3å>¶Wû¡8.´e©ñs!çÂA¬Òß¯tÜ`Àg·0þ®»> Ä§>þóø=.7ÿéúKæÊ}þXC©?Ñ­0×{ä(Ûêöê?tæ½ýVXþát<ÏgÀ3àðx<ÏgÀ3pVd ú¹»,Øµv°Kñ/p!¨c xæ¬eAÀ§t_}}áØàä[È`±Ã%bUÌ3-mæË®ZcåèJ>2²¡Xe8àiï¹INK6`iØ# G*Pµ Åsâ3LèæJ9õ5'ÝÔ}æ5¶ÌCé¼Æø tÓºàË¦úº²©D+Yô±Je3'ÿ!Æü£+æÖïõ5ÛÊrÇ¸%AçS}¹öÂù
¹Éõ¯$1ÅÖ?xiÌ1v$ÙEO>e=üÃÖmõuCi!ÅMùàÖìZ7ó/9æA¥úÜzßCÏm·­ðQÎ-Ãù:ö-uÛöé7}ô±XÍÑýÚm+º_`óÏ¯0nG;®Gõp÷ÛË×¶õ`×î=Â9ÕUd[·nÈ§£ÆDVñÀrÝº÷ÛhJêmVµ³aýÉº)§ÕEÙ  [fÿ"ËªUqû±1×\¨¤ØÂð£ûùÀàÃ|«ê:ïÚëB÷Á£+gÏ¶j»7ÃE_ý£Ð¹_¿Èý±G³ª>£G[EÀ5I|VÏÖÚÖT)±õÛê
ÙG
ÌÇïØÊÙ6Æö4FNhÿh¢kÿöÛñ¾"S¿ùñ#@Ø¡Ghðñï~û5såÆÏ9CR 6 µÖ?bâ¤0Ð~[ ¶â|ûé§r~OÊÍºþé/<¶[eb!ÜpþØ8V»ûüa°Ô¿èÖÌ±­ì /B,WÊ)Þz<ÏgÀ3àðx<ÏÀÙä¹u;[Å	á%80
úkÎXó¢¼¾0õí0EFò´²­ÈÂ¾A9âaNr²¡9Ê0ùG9lKWëmÉÉ&rô¹tÓ´úÈBOñ«fKüLU¢5-Û,D£eñðÓB¬I±¨M¥¤!(=ùP"h1Ç¥_óòÏ<1ÉÆ´sè!OËJåèË?ókñ*Nù=Æè¥vlu/JãfØ¦ªÓÇ¶²|ªÐVìòÿ¸kLÒóÄ6p&>¦ÌZ~ûáÚÐ´QÃð×·ºµk·îÿõq{¹}Ó§êÌgÍõêÝ·`ÅtTÒ¢ÑcÆf:¼ôæee!Ú¼icØ´±ðÇBòuå¥/©îaK½-«Vfêiµgx½öè#q.æ ¼^ù×ÆszÆÝtS {ý1Î;:j//´3¬&Dþ¬_ÿÊÎ¡[ùxÁa×¦Í'U!!ÀùYW|ó[Yõ	þuX>0Ç9]3^ü÷pÜ*FDMíì¦I÷ÞkvZDª6ÎD`®Pþ;Øg°±]y®q¦ÕÄ{ïù=ì/{ÿý°òÓÙÏaÚã¥øÛNRÄùx-Úµ
<ù§Å<©?Å£¹T^þM5l"=rBò5_çVAÔY¡ ÀTºP%QÒG^.2ÈÓJ_sÄ
}-Ùt
;l²|âåý¨Ñçå°>d²ÛÃAÛò²¥':wÍl®^µ"ìÚYÔÈ1TÇAúbÊ¶Bçq@/Xy1¥ÀÜöuëâKiø)VØõ5âÜ«®B$äsYÃÛ,»||ù/Æj>ùÀ ÜV«4Ë§ôÅ7/ß´Çg"0GÅá2«Ë§k¾û½X}ÅKZò_S[¾n±1/ñ'?ð`6
ÌÉØÄ>ïÍ7sÎ)Ì&ÎéæZuè®xðÁè3Û9ùtË_üeUU;åËçÏ1 ëJuþóGW?ôP§:ç:¥ç42@åÄéÜ^û}(Få s:/m_þÇsùÍ[·);þJsõ¿Ðâê«ßsØð0ö¢©ô·.ßö¶UªªÓß/É¥¿O|O ßnk£ã@¤ç)êw¹0W©ø©\Õ6¼ µü}ÐúÇµ­§¾ùO×_mÍJ`®>?'ñâaì7Äp9[­A×/ªªÀÔ¼õx<ÏgÀ3àðx<ÏÀÙê¹;-æuv¶ K8}xÂ'àqK0pøæék>ò\ÌÓBÇ>}.H6éË?}t¹¹ÈlJy{±b 1¬üc}äO4MÆÊEÚúr¢´/^[K
;
:]}%%>Ä<	¤K?$R<Æ²E+ßJ¼ZæH¾ìJGvl*ÎIq¾-ÆºÁØdV6ék^6äxZ+}H< Bæ lÀOmá[ÊSKë÷´¹gó+æØ½ÿsÿØX	·|Óð¿öÛöC{¶	wOõÊ­¢[½e_øÛçg]ûÉSGõæÚÛþ={ÎöXeYó-²m,ám³­,×¯[K7£FVq/ÑÁÂ²%ÃgñøTQ§Î]B÷½â`ßÞ=aù²%ªHsé©ñIvPÛÚzùÿ)Ásé¶il?ÉöÐ¢éÓçâ@Ú²~MÀUL-íL"Î%¸lc9 f¿öjV=si5_L>ÒÓÏD`nêã½ \ª`ÚwëWÄù|:;*Yb½» Eî¾'ç<´ý»vÅíHÙ2´.T`myQÏ|TÕFõæ:ôè.¿¿ë¥UÌ¥Ï0[±RR
>r¾S·Âð	BËví2³lúÎ³ÏÄñ5}'¶*Î:õé.½í^Úò÷W-K+àê²µ&Û«¹÷/ÍI}ãOué¢?ròälD¶]W}~e¾íþç·¡?ç×ãö¾©L
ÌíÙfÿpà'Òé¢ý0×¬Uëpå·¾ùÁNUsW»
f{ÚOí7ªTüØâLÆI÷ßo[çþ£B[X"O¥ä?]ÿê¹sgb¢.úv]»Å©«ÄóWêßOI¹6Å¿«üÃÛÉn¶J^'ÏgÀ3àðx<ÏgÀ3àðÍ¨æî±5¬¶Ks¼ü_ [ Ï¦ ü"-|ú iäÃÇfJÈCÈIúòOËK~ü#Ë¼üåÛmä¥ìÉ6<é2Ñr	_¡
Å	Y]ÖÄB_þMo.|âÚ§¯±thâü1V,Í­ß³¦3æúui¶ì>A9ÍhP÷Ö¡_VáðÑãa­;·rÓÞè88Eú srla	?~,¬]½*ìÞ½+44P©1×¾C§¬â-;Ê
éÔGLcDîé¨´¡l×æMblS`í/y9Uþ  Ö¥ò'Ó±N½¹ÌÙvyP©[Ñ.2QòU­m]³&Úãü=ÎE UcÆÉ¼¶]ºØ`CO ÌÙKìì>¶ZÅ>÷*ôÝ;ÝÀ[¾^ûïÆxölÛfàÐã±_ì£ñrïâ«oüÒS[þ¸oÎªd§¶ßC~SJ9ÎÙýjpÊê§À9ä8s°qí·¿ElÑzÅßã«TüÑ°}¤¿ñð¨ì}ë©'kÝÂÙRò®ÿç=iQìB£¯¼*ô3&ös¹
<¥þý$Á%TN²íomÛ&*Þõx<ÏgÀ3àðx<ÏÀV|ñË_<|¯·Â.*æÀ!À,Y7|H|d¸às	w_s´ðÙAcðÎ>¾aÝÈ§ZÙeL_þ­	.È	GaLµÀÇoüÑÊ®| Î3RÙ*Î£/ÿÈÊ?ü²HcD×"¬«`KV_S2iyMSÛÈ0µèH»ÒCùTß).ÅMÿ4ä´ÈJ^úÄùÏ×·©HÈ !KPQöh!ôSîÕçk÷}û©;w1ÆS]9a#FFÕUK,
öü ¶íÚ>}ûGÀÚysr*âFÚVxûMoé¢^}úövV´xáüpèÐÁBb%ñôbq¯û5Õ¶2,DTÀ¸AæÚvéÎ»öÚø²ï|ÞR;çk÷¥À\m[
µåÆXêýS\¥Ä/]ÚRô/ùúm9÷(µW¬¿xæÌ°hÆôé+¶¥jBõ ¦R`ê³«þø³³
¼¬9ZñÀ'>-<éi|þe¬¨/0då7¿MýÐbS_2iËcbÐ\øÏ·ÎBÂ[4/Ó¾
!*£V|òq/Ô^vyrñÅQm%ÅÅèTséyz»6o¶J'ñË¿÷OÁ¿tiKÑxÁa!-xç°ôýªm{#£§£ìs²
Ò¿K{ìlÑ·|2©ÊÖÂ#&LÌ²DÅ#g«:y<ÏgÀ3àðx<ÏgàlÌ@50w¯Å¾Ê.ªUÀÀ&À91À£å/><aôÁVÔG.%ªì$C+øMZÙceþ<ÉÑG\òoÝ§|Â<|qá»º4fNÄ>úØmüË¶b1V$d¸R~j¯JªrZ¢Ø!×â%¨ KFgÌ<RReËXQy-ZÉÙ RJ¬âb>²âÑæÛM¶ô*VøèÈbFNpÌsAÒÆ\È#<}ùgN>ZY¹§¿lÀ\³fÍ­bn8ë¶*¸½aÙÒÅ±ÿÁVli	-Y´ L¶¦êh[æõèÙ;Îí´ª5«WÆ~ú1ÄªòZuçÐ-÷i:Uv¿Ô æ.´3¼º
í*SJ¹JÅß¼M²&4×ªDÛßFÎÇ±óÒûwîLCÉéÿr¹J<¥þýdñ)0·ÍþQÏô^Èr~ßaÎúFXùÉ'Ù¼w<ÏgÀ3àðx<ÏgÀ3p¶d »Ãâ]g×A»À)À1¥@!pjÂ4óà3¸s`ðdÈIOxpñkNºØëf¸ü3¯åClÑÂSüñ¥oSQyôÒõ!IGþå/ÿ¬A<lKÇº¥Ë%§ ñ¡ ¨D´ ùGVýBÉdN	ÅvhÑÓöÜXøðìJ7\òoÝèÛÈ)&tá)t/;òo¬Ì?vU§8d=ÿz3úUìðä_±)§èaR^vÆÜs_¶3æXàQcÂ9@k×¬
;ì_¾§ÔÂÎ0pH7Ù¶óçænW	ð4bä¹¡PþV:v
={õs»wï
«V,ýJ}úb±"ÀÜ-_
Óy¦FÀ»¾÷¯\`xË}þJýûï9@ÃñwßÿCÉoÃ¶5kPuòx<ÏgÀ3àðx<ÏÀYövÆÜ¯|ôxµ] s¼8wà:8	Ø0	ð´oÃl9ô tèsñRÙD-éÀ(à	+A=üÓt Ú´<øØcOúØdðáõ1/ÿÌË?}üô$'Û)üÓ-$ÿÄ&»ðL
 d¦
y]Jºl #}ä%§$¤cúÉHýÃSòècy%M6+²DËMFbêa?KYHòèË?­â/ÿé:ÑÉ?~òíaG[Y>ûe«#½z÷
XH¿¯m.áÛ¾WL?+>úÈÎú{7ibgÛ]÷½ïgãbª¸~óã(6ù½ìöÛ3 ;_ß¡O_-pæUJåÄ_ÎýKc _jü²SªþÐK/
 Ì¾A­:vàFæ-ÂÛ>ôà=~TcK´æÕU}©úýÎ+6,]bÀÒüiW(<CÜ{@Y¶<5XÈÅÕ=+íönß¦>þóB"GeÜÈÉc±µ¢J%N êð=Ø
-ù>nâ\»vv¦mkÞºR9ñ×÷þÕS©ñËf©úT6µ´êéxVýïÙºõ¤3çä#mæÅ¿_àï}©ñ§k©D¿Ôüã»Ï_9qÒmÖªµý®Ù¹V5{Ü.'ÏgÀ3àðx<ÏgÀ3àð-èÐ®]øåh+K^rñ¢ü>pZÆ" ´TNúÒUêHWòÌËØtiÍ¯8m*Êb[ø:lëIuäHòÂTàãW²·òñ£8:²'ñ<¼zÎË%Ù HQàZX
8(ô|%ÄÂCJ>ó²£ÖX1I©Ý4ZämÅ([Ì~áCzâÑ*6ìÈ6dÏº|äd;_Y2\øå0$ù·nWü#Kû s}¬bî¬ÙÊÒâu:2P«Kèæ¨.ºö»ß«Õ­sµ¦è´	PwÃþYô·oçÎðÆÏ+ê{ÀXæ&MóTp.9³¨¬Ox<ÏgÀ3àðx<ÏgÀ3àðx<U¨®»ÛF«íâ90	 .<C8sÂh!xü+U°xàÒ2\Ø¢¬l0fNx
|ñRÙ@N2ðÈÁÓu3Ì%õ	?µ­12òOdàq1f]}ÖOxG9ùGBF>£,ü²INÊ1
ØÆrÉ¬Yaç[Î6°-%Ùf-
ò ôºÈðÏgÀ3àðx<ÏgÀ3àðx<Ïg `ªÏ[c¶t7ÑB`¥à1¤2è	tBKcæ³Ðvâ!']ÆêÓä_8t%+¿ÈË¿Öþ±A+ÿÖÍHv£¶á¶Y¿Hz'¿~+¼tm²Uçåi¡­Á¸ %_5{" ZP~"Ð}l|oÖIÔ¼üóð°Þ<f¡ªÓ?sè_þS|´úÌkòÖ/}ëÆ¸à5¶+9ÙWLò>gÌõþCÙÊd8)ÀÜéY­{©túw~uÅ9fÙ&îÈ¡CñL9ÎÒ­[¸0|ôòosä}àðx<ÏgÀ3àðx<ÏgÀ3àðÎ@vmm+ËGÙÊrµ]ìó K	k'L}áÌA)È$}á´ó /
{ÌË&}é[7Ãh¤<}áÈ@Âwè§¶CÌCèÓxò/í#ÁÃ§0ôñÎË¿di¹ ZÍ£Ã¿±êG2^?­ÂÒébm-y
$¤7¢E^E>É£eHòôáËcô ÙKmà?½ÁÌ°!´Ìa;ôu­ñéÃÑ%=ìÐ×C¬úS-þåCz²CH,Íí¢bîéí;vZ×É3P¤ÀÜ²>óßz«Î+¹eºàC~çÚuë8²>p ¬øø£°ôÂç%YÈ¦ó<ÏgÀ3àðx<ÏgÀ3àðx<_öToey­s]ûì W sx!G_|xÂTÀEÀR|yøºêc>6èè7'=ÙZùÇóÈbb>¤9úðeÙÔ7óüK|å]©}t/>Ï ÏÅÅÂXqçû/×0\.) l¥ÕÁÓR¹tñôIXª¼dèËFlù]Æè\Í).d
ÉÉ§t/|n<|úØ¬ÆòAÁÇcÖC_cé+Î§kFFþéKVka¬yâ£b®Ï­÷}ûí;wY×É3P4oÝ&´íÖ5Û²re8vß°ºsuËÓÔ9½{mÚs5
Çöí
d!µøCVòSmÙANþú)@ê1&HñÈ¿°QLôá#/í+>cG¾üÊâ/{i«yôK"9,I¹ZIÁ²¡!Ã&y-9%>.}É¤-óI `üX7òÕ/`-M8ú\b£¬(í#£W<ò/{j%Cúø×$G«9ëFYxzê#)&¹·ÞggÌíô¹ÿøÂ3àÀÜ~< ÏgÀ3àðx<ÏgÀ3àðx<ÏgàKê9¹ÕvqÆØD_Ø0ü!/ 
9d ´Å&ö]È¦ì¦zÂ0°	I¾0ù¬ø²^¡V2Ø¥<t¸Rüyx´¬µ¨oÝúÕã4Fø)a«dÂx¹P¤cE.ÍS=Þlf¦/ÀIzºá´Ì)qØH
g³¥þURh¥«- _XËªÛèK9ÅÎ;¾Ë¿Ö®ü#æå_cqg"àcxå	ì@MíêigÌ=¿Ã+æbBüãÏs_ü=ð<ÏgÀ3àðx<ÏgÀ3àðx</o:´kggÌ="`î°­-ÏCw [n"A<Z¼BüEø-<pa3ÖÍÀ.ÉàÿÂ0äYù§/\=ü§r9ìÈ¶ÆØN¾ù'Nä4<úøc9ÍË?|úÒµnkØ}tK&U²jEÃ ±«E(h&F¾S]Ä¢(È@ØK^¾
*
ëF¼ÀÅ¿ti¹ÐOëfýÔ8v¡|=é§ò²[¥qÿÁ?ÆFyñd_6°Åü§ò§<ýzª·b¢ àush!ãJçµÝ|-ëFRBô`hÒ9âOí£¾ÉG1:Z«âMe`r²OèÊu3.¶Ô§n
ò¯¼¤òétdc»ZsSë÷ùÚ}ß~fÇÎ]Ì9y¾ThÚ²e¸ö»ß«uMß}7,õ^ÜßüVh` Þ¡ýûÂÌ_Çð÷é^zYè5bDÁ/ûð°òO
Î9³pxû>ûìxX=gN8rð`aAçz<_hZµï.þú×³ÞøÙcá³ãüçgÀ3àðx<ÏgÀ3àðx¾<¨®»ÛV´Ê.^|ò~Á7#ÀbÂ]Ð¦Á<r©
Ìu³ß¹s×¨Èlªäh©ºÓö£N,Z8ÿ¤­ªúô¨«}f Æ¼9Ôùey]lºLùH¹¥¼LVg£g0×¥_ÿÐ{ÔÈðÁ)q}u5óçO~ÿ;
ÌUêûwº×P?æÊÉëz<ÏgÀ3àðx<Ïgàôd ú9*æÖÚuÀ.V ¾À A2ÚYPs6eAÌð)ÃB_D_86¸ ùÀ2ØÂ&cìp¤§XIí¤cÅDayÆ²«ÖXqN¶$ÙP¬²Að4Î÷/{&RÓúkÐHÄ¥<ú,Pj¬)d±PK7WrÌ©¯9é¦>èCÈ0¯¹´eJç5ÆªÙdK-2ôu3eS7V²ºð T1¾å1Ät%ÓÜú½¾f[Yî8C·²$ð[\]9ÎëÝ§_T/TÇyu P!à.NùhfUG³l¹`Þ"¥³©fjÒ¼y8nçÖí±jÊ(ª¤àïßµ+l[³6ì5P1 8ÏêÈÁ¶Eçg¡ëÀ¡¹Mµiù°}ÝÚ(L×þBÍÃ®ÍÃúEòÍÄñW¬r
«Ö;YuPÓÐÐÑýö¼ìÛ¹#ë$E«Rð¡ZñÐ¾ýá øëdçý5kÕ2=r$ìÛ¾#n5øÙqýSCæ:öêóß¸i³¸þík×½V-yº¨EÛ¶ayÖ}È[ù¥kñÌaÝÂU` Á½{Ë¾q{ÔÙ¹qcöÌÓ±_è£>ÀÏHë£Ã»w2iUmB«j9@³BÏgÝò¸  @ IDATgÇ½â³ºÏþÁÎM­ºf~´Ù}Ð ø¬q¯Ì·ì9lXrÉ¥][ØnX²8,>=V½_¨Eì
Å»å/ÿ*¾ðÜk/ß1À s)}ÎÙvV¥VÐðöú?ùÓ(vÈ^Ð±­§­ðÚKä¡^*VlmGEÖ¹W_½ÎQ°Á¶µkÃ7^7p0ê5|D8ÿúë£8DÇ
Wâ~"A¯>üppã ú¹ó¯¿á¤çi¶ÚXõ èd;<ÀÃÁ\ZTo9ß¶Ì[4sfZ¤¶éÙlï¿ôRØ¸li:]çþ~3Úù
µ1ÇËþðÃ|µ¢ãÿéãwZåÆ_îý+7þrõþQÁ	ßô7Pól±øÑï^.
ó-1Ã¾bÙïæe'=üÎòëLÃJ}ÿJõ¯õºþ«¿ýP(O}üç'ý¾Ë>Àóußÿ8$l[	ÌûüC©?Ñ­0×{ä(Ûêöê@¡yo¿øaìûgÀ3àðx<ÏgÀ3àðxÎ$gÌñbó/pc£ ¯±æ100ôàÓ4¦,|ÉÓÊ6s|ß`9Ùlh]l£'ÿè 'mé2/ÿÌd9ú\Ø¥âaL-úÈBOñ«fKüLU¢5-Û,D£eñðÓB¬I±¨M¥¤!(=ùP"h`0Ç/ñÕÊ?óÄ$ÓBÌayZÆP*G_þ\WqÊ¯ì1F/µcÃì/ÂoªMlc«¥]}l+Ë§ÎÄ­,-¶¨>ÀgÄ!ß°!Ë
>Ûî±ýD5 %J& µK¦J sTØð²¸Qi«o	ÈoÔ´i|ÑE¡ßór@´Å³7/Mùæë
tîÛ7\òõÛ¢ú6«¤þüóù¦²q½¹îÝÃ»îº5sßúuÛ³_Ëæº.¼ùìÅ7ß*R¨XÒËð,8ë0ÿáo~c`ñe4\tqhfU£"*QW}ú©UÙ½+KÅ§½ö{ßM[´¹òo¿úéN¥jïËN¾ä©æä²øÛyÿÊÖÊÕ'ßüÞ\rÛm±JWùg»W*Û÷JDõîÔÿÌ*{÷µ)0¶Ç*[w¨ªÍÏßïú/S©ï_©þ	¢õºâÐÿ¼óãZ
ý8aÝ	Ü|s.3Pj¾SPÙÀ\Ï1ú÷ÝÚ¹ã.#&ND4Òâ÷fÆJ\½õx<ÏgÀ3àðx<ÏÀÙê¹û,ÖvñbLA  5cElczA¦>-¸/ß¥ÇXrô_/yá&u5Ö¼üóB9ÙD>í§òÄ!YôÃ?}Ù'9üÓbzPêOñh.ÿ*­6ÅH9¡Mù¯s« ê¬P@PI`*](}ìkQSðÈkñôçB^}ÅÇ>-úZ8²±n×X²²/æä>ÉfÝn.cÉ¦}ìÉ?²ò¶ôñÇ¼ük
°¶¶>À¶:vìzToÇóêvÚÖ]»÷çTWmÝº9l0P¢®Ô¼y0hHUÏ{»tñºªÖKN/¥ ÆËÏ-«VÅ- Ç\sMÜny¶0üèåßFÑ|`ða¾Uuwíuö"u°Ì³g[µÝá¢¯þQèÜ¯_ä¿þØ£ÀÖgôh«¸Æ0ÏÃê¹sÂZÛ:*%¶d[½a_A7.]ÞòRf;æÄ c»Å*±Í!, gàà^¡ãÒ/¥­0'¿1ÿ|¶Ø6
}.0.°t-|ú iäÃÇfJÈCÈIúòO+ÿÈaS>¥Ç¼üåÛzÒµnf_¶áIW1Òr	__dS[ØÐ:a­T&õLÉ¡rIÆ×BYæÓ¤ ¯Æê£R8ô¨É?<.®e^ºe¬¸
Å	Y]ÖÄB_þMo.|âÚ§¯±thâü1V,Í­ß³Øs?¼yx?¢«ØÓd[¢í=x,´m¡â¼ÈÎù·zgøg?ÉáUzP
0GÛÀÁCsk×¬
;l²úÐð£ã¼[0ïÓpÌ@SAéE*Û
cÆYr q¼åÅ0sÛ×­/¥á§@^Za××@s­òÊæ"³¶Yvùø(VLäsr[­Ò,ÒÏ{¬ïÍ_</RÖ¸RÀË¬Z.®±ÓT_ñ,¶,¨&üÀ@¹7l«½È&tR` HÆ&öyo¾sNa6tN'0×Ê¶¼âÁ£wÎP\nçæÓ-ñT)Ví/?>Ç®+
cú¬>~ÓøäVvåùt1ÊVqNÄÌ}ùGVþáE
°#J¼©`µX\°úZI¨ESÛÈ0µèH»ÒCùTß).ÅM+PMq $´Ø¤Å¾â>ñ /ÿùú6	t dé*Ê-~ê7Ò}¾vß·Ú±óÄù`6°­ÔþÏýcc%ÜòM{ÂÿznvØoÛWíÙ&Ü=q@Ö+·nõ}áoví¯Ú
§êÌµ·ü=zö7í±Ê²æö"^ÛXÂÛf[Y®¯ãV-8h(ja÷î]aÕe±*>R`.Ýb2õ5éþBÛÚzùÿ)ÁsÛöñï~çÙ~í¡EÓÙpfìkËJ5sTH´´ìVvQuØÆ*ç Ù¯½U¤À\ZÍæmDøvHYÝJsS<ì- à¦U%l÷V­8&Ü}OÎyhß8È¡u¡º lÛHE[ðQ	TÕëÐ£g¸üN*áíÜXµÞìW^)h¾Øsé3ÿÒC)øTÊùNÝ
Ã'L-ÛµËâbÐw}&¯yè;±-TqÖ©OpémßÈôÒÎ¿ÿ»¢àl©À\ZW­5Ù^µÜøË½iNêªK¿ý'g[$²õìº"çWö?ÿü¸
j¬?/ðÂJ¹ï¾Ìù5sõÄv½°íÛe gTÌûà°EÓßÜãÅøL«+D}Hàb!ÙRx æÈ)¹-DÅ¥B²õá5´íñ8ÇÜÓQIYú\silÉËñì%; b]*2ëÔëiÀÜ¥sø\d¢:å=«Z£jb{BÎE UcÆÉ¼¶]ºØ`CO ÌÙKìì>¶ZÅþM?üQ.ôÝ;ÝÀ[¾^ûïÆxölÛfàÐã
½`[øÉO¹÷OÁÕ7~é©-EÜÍ7gÕM²S[Ëï!¿)¥ÀçlÎ~õÕtºh¿Rß¿RýWjýç^uu</.}VXðNU~Z´m®üÖÇßíBÎ)0÷ÎsÏ´¨7úJ;£nLÕu9À\¿Rÿ~[
Ì)VµlûËº<ÏgÀ3àðx<ÏgÀ3p6g z+Ë»m
ö³Uî	jÛ®}èÓ·d·óæÍ1ô§#Ï
/©&¶ñì±Úw¦ÙX{ÅÎiS``¡¥K4-êÌ8¯9bdÃ«·IeÍ}~ÛÚñæm>©&MÏ.y<ÃÇlñ'MË¹¶§ÎFÚMvf( `Ü"Öü°VÏkUý9ªTÙrâ¬FUõ)Bm¹ñ§ç'zÿW)ñK¶ýK¾~[Î=Jíë/93,1=g:Æm©£P=¨Ô÷¯TÿZÎÃ¤ûî«â»öªUó]5ù@µ!VJG}ÌÿûQêßOÖP0Çü« ¤JðÈAþ?gÀ3àðx<ÏgÀ3àðxÎÎTs÷Zô«ìâÅ9/»Á¸ØÅK1x´\ð3ÐDlyH}äR¢ÊN2´ò)ÌB~dWþ±!ÿ'9úÈbKþ­cOøÒM.ücWÆiüÌ¶dÿ²­X$WÊOíI®Î­ÖY¡ vÀµx*hÆÑÂ3O¢TÙ2V§e^VràaG6èÃ«¸£¬x´ùöeÓ¦¢-!½>:ò£áC ó\ôä1òÈÀ$O_þVÖ§bîé/0×ÌÎ]<të{÷î	+-ýü­ª^ò/[º(ì·J¢bòÐ>D/[\L´"üR_,V¢bWYED£¦MãZ8;Ê«-+WZµÕþXØØæºÁ;sl¿øþ
æ$­îA 
¦JÑÙÌ){÷/Ã9NtÜÎ6äìµ¥VésÌ*½Rª0Ú¬0Q¶aéðÁ)©©¬?ñÞûl+Á.qüêÃÐxbË»üjÊL©ºCÅßôç{wlÏÊÆ<_.¼0;.VÂi°{ÞSgÈ¢4®÷~õKÛ¶nE!±ÈwãM¡ÇÐªímO0×Êîù<}m[»6Láù¢±h¢Üø+qÿK)ñK¶ý1×\úÍpÿÝçÔO¡ó!s1püQªR´_©ï_©þ+µ~>Kï¿ôëX¹ÊÙ7G`¿E)ÌUâù+õï'ëÈæ¨ú^eÿ8PÀ>ÕËÓíÜ½BÏMï{<ÏgÀ3àðx<ÏgàLÍ@50wÅ·Î®vS/cÐKZÆ¸@5aÌIy½$ `Ìl`9é	¯!>cÍI[òoÝWæ³|3-Zx1²ò/¾ôm*Ê2^º>d!éÈ?²\ðå5méX·tÂ`¹DA ð >t H ÿÈª_(Ì)¡ØP^U¹NÕÿÿÙ;Óh;Ïò<¿
³wÌ½¿æÝ^_tKAJõÒïáào{Ðf.yøäAä5X½¥üùÄ;G©ÃÞþÖ"|VøûcS°Ù_ñ¬ÖÐgùò¹çêûØÝþæ¹Çg.}ìo
l¼	6/ëÊ7.ö·&õÈß°+5Ñ]KþuúìíOÒÇÓË9ð'ÏB­þ"ÖþÚ©e=|Øg$g®³AóùañùÄ.Æ®îä±ÇÎÀv×2
ì/Bw!ÏEÌ®Êuü#¾/ìp¹ÏeÿA æÀ hÝyç¶7Þ8@²Ä|.ñswrõr|Ý÷Î}è°¿C¾O!âïÏ?Y;½ç¡Iå.
Ã¥+Vd¤Ñ\òÆË¶½bóæáy]ïþêÕ9WüeÐú¡øÉ¡dw<.T^_3=söq¦ÏË£&¿ñçÿûYa¼ü¾|Ó¦ÏýÁûvÖ»¾ÐNßtvo|ßø?owßrË oyûÛÛ¹¯{ý ßtÝuíÞÛ¿_wïÚN\zR;±þó¹pÇÝç?ú3ý­Ï~¶ÉF}KYVã<ÿßÐ6^rI 'ïÊ4@¸{w#ÞüÕ¯ï2ë{Ãïí<Ì#; .}÷»¹»ø¨;YÁèpïÀt~zNúù;.ÎoIóO+rõÕï|×ðØTþÞQü{ìÆ¿ÿÊðjï×3Ï?¿½þ_ýô`âq¾<Öw>²þè3iÿ~ÆiÎß×Ù\-Gäpï5þµ?õSmý
yPäâ`ØÇæÀýÁµAh!ã@X8.À|+uÔý	ÁNMlÔê?¼Ú6 X3ßùìéØköÎg±ø=ý±Óç×vôÖ7£þÌXßþö¢ïÛøRz%ý{¡'ï¹#õ¾ûÖ[ê¯??RH|/Ü÷¿öëC·GêNÏÿþï¶ó9¯-bîGß1ø¹óæøÃÆÆ@A  @A  ÀkV­¬GY^Å£,·Õµ¯.8¸DòL®6ty
|b>õà8Xõ³G¿`¥~k¢_ê£1xtybû ÷µØ#øòÑíÍþØzX=ålÈ§ï·¿±¬\«~r¸Æç/ÓÂÄâË;º?Öö ø; ô6ÄJ¼ÀÃðXñÝìÉC¬×× ÿãS¨aV|Ô¢º`©#;:v/ó¨î/±êÎéJ{gVDfYQwÌ]³k÷Ü*$,£ãN·üâûsþ7\ßnùú×3./ïþpÝ1Ww!<ÆÏfÏÝÏ<rvI=RÇlòh=<¤GÝ`È @A  @A  æD`öQWs{]Ô¯ çÀ# kÇ&§/ïÐó3ø±#äªS;5ÐtylæYßþ¬ö§~b©àÇèCÇnMbûÞøûË
¿Âcãúúä:/=ägçbÏJ³°wîñþsÍRáó
O+D-qXV}ôqýáÑ¬Ï'Þtkô`ÛÃºìÉ\}ÎEÌ\qö4Çy±óÁcG§±îíÁ`§{ÎîÞ2
.UÞÁ:ÚñÉU`C¬i}üð!ÎïAýúØ3~jØÁOl/ì­C}gñäbsNâáQìSêPý|ØÍ±¿s§X=v.lÎ^êÂ¥o°ðìg28XL}e:LöÕz~@úYñ!Æô:¹ä øýìo.~k÷6ì6jñúá:H_{²"ø9'5èÏºúìo=ì>8}¬ØSêZbnÀ"?@A  @A  @A óÌ>Êò:èuA´ABÉÏÀIpÁ%ô6u¸
x
-öÄãïóÁNº\E©C
=¸ú³Ð}Ô³ÿx>{g$/wÌ½ì´mÝº³Ú²åËkìú¢µnøî éÇqÇ-i6nj«V¯3ìÀýmûÖ;Ú£>2§Úü9N`üÈ_Ð~ì²³Ì/}ïößÿòÆUy±ó4l@A  @A  @AàyC`ö¹V­uAÌÁ=ÀÈA Ã! pîÑå9Xç"VbKuÜGDrè{âäXìIt.|Ö§1ìüò'Îo?økÙ=B
rÝë·?\>kßë}¼ü~òðÑÝzØäiäP°Ù:ØÈCú~Î£¯·ÿLÖ35¥"&¬½]ÿ¼WwÂ«?¨ z(}O¼7âYÍ×Ç¬ØÈ÷àÄögÏ!Îzô"Öþè'Vê0.{c{zö'ÖþýN?üöw6öý¹ó
K¥ÑNv.yíúXùë=|Æ³«~×2µÝ»Z=ºýG°y±'N=:gÁNÿ~>jagµ®=´÷kË!F!ßþÔ´?ö©Ä§) ë!ÖC:,qýÀêxkÁº °{kiÁu%×xbÍ£6~Ö¹Ä¹ìÁ*©æäØ¬Ôç"Þ|æaoÿñür
Uñ<:vVíÚÌsOüøU¦!^p,ÄÚw|íû ÛÙÔéW|ìgpOO.ú×Oayýödßëµj8+1Êxíó^ûÃÌ;i,^Ð
ÙºßãW=vêPÃû!b×_ê¨7vù°Ó8.H/ê#ö¯vúRcÜæ¹´»b÷ÆæÜö/ÓH$ñgV± ?~lÄ²÷\sûä±JÌ­^³¶µ~cã}qÈC>ØV|òè1Ø¨GYÞuGYNOýHA  @A  @A £Ybî5ÏÖºxÇÜ6V.ìòèr¥:Ü
~D¸^¸ËÎV{ÊYØGÎÃþÔ°¿1ØC'\ö/uÍØÍÁFM.úS×Ë}??>ÅY¨emú[ÛY'«·÷õ÷jÓy'&:ÂàÞPfog ÕZeâYñ{hÁÁFk cCA`:±ÚXÇë[³\C-^gÅN}8pø¹óìÏxb°#Æ£Û=N-;æ®99H5a<ød»sÛÖöà{ÛñÇßÖÕ;æV¯yùè.º÷ÞÓî½ç®!ÖÓæ['kA  @A  @A £Ybîku=^<ü\
ÂWTÓÀg~ø^6kP8óäkä1´³×g.µì_êW±?~g¶µX±9?{bí¯Ýür
~L?Saæg?:yÄ»§v>ë1º::ý?dtìóº§ºyâbêØXs¾¹Þ1wÍ±ö¹:WÛòªKÛ	'ÌðwnßÚvïz óHN>åvÎ¹ï{òÉ'ÛõßýçeÚüCe@A  @A  @Aà(@`ÍªUíÚ«?æ£,!æàà(àÐ¹äYXÙ+h}ùæºÊ]ô9æO]ûÁ]ËJ,ý{qNlÄP[þ=b
^ðøä=XlÜa×
vm}536}¥8¾'ö¾¶{bìOOb°q±ç\:g¥'6ýäâ³?ù\1ödO±Ø§LSãðØLmczq? jáSÜ÷¶>«uVâª7Ít{õ6âúØÚÒÛ³¶Äýµ±"¬ÌclögE<'º¶>;½±±.«bî{ek ÝxT%ï;@ØmßzGô÷ôùGê_A  @A  @A ÙwÌAÌm¯ËGYB:Á `¬_KJacècÈt"Ë=>bá,|\¦¶þKyëVØoöýåaÌ5Ï¾ÄÚßóCj°Ú¿ÔXz¿äy©ÍlyÎ3¾R}u®þÖ×Ji<(rq0lcsàþàÚ ´q ¬EàK¾:êÏþÌ`§&6jõ^mú¸HçÇgOmìµ?{çóLÄâ÷öÇFL_ÛÑzRéär1+b}ûÛZ¼cnãKéQ\¸¥-[¾¼=öØ£íÖoä|Ï)g¬;«vÚÊ¶tÙ²ÑrO?ýtÛ·ïñöàÞ½mç½w±Æ´ùG,gA  @A  @A 5«VÖ£,¯âQÛêÚW\"y&×MNº<>ÎB1_^U?:ü+õð[ÝüRG9Ä£ËsP\¤¯5cñ£/×CÄþÌÔëÄ"Ø³·éýö7aÕO×øüeZX|aYsG3!ÂÚ? bþÂF.+ñ~°äpa<V|Ä Æ£c·{òëõ5èßÀøjØµ¨îXêÈ!ÆË<ê ûKG¬ºsºÒßæYYVÔÅs×ìÚ½§Ôc[,YÒNZº´-9nÉ@Ê=õ¿ó;÷´ùóë¨ @A  @A  @Ï³²¼¢:l¯ëºà#àà\xtíØüB^Þ¡çgðcGÈU§&<+vj +èØèg}û³Úzø¥&;¢»5í{ãGìo,+üÊºúúä:/=ägçbÏJ³°wîñþsÍRáó
O+D-qXV}ôqýáÑ¬Ï'Þtkô`ÛÃºìÉ\}ÎEÌ\qö4Çy±óÁcG§±îíÁ`§{ÎîÞ2
bWúk<û^¬mâìOuÐ{8¤ÏcÏóØ_nÆ=1Îl½î|eìöµóa·^¿ê'"±áDÉ³I;W
¨ôH $ôJþë»çþnöÜÜ{ÎÉ$¬õùÙ{¯¾·9ëì}:r¨³¹ÙRqEÛ©rÐ×ø/Z_|ú]2rtám®ðéo²Cñ²­üHF,úÊIñS]úÒ<úÊS¹H±ì¬c ÛµÒW,ùaL_$]¥¡øøU¿õÇ|ö¹W,]¶\úÞ:#à8#à8#à8#à8#à8À.ÀàÃu]xMok*ÓTÍ!5ÕUÑW]CcêÔ\ äc¯©îA?èÐb.5H¼¦ÑÖ¿â+>Å§ùÅ·ô¯\Ða,;ô!ÆVþ±ÁÆºA¿Ì_>ÉâÐJnÝ|2H~hT0PÂ G)}.Où©Ut~5&¶ba?ä´ò¥øz±Q[õ5Z6õ#â#Ç^¹à§/=ò¯8	&i_ñå1:òÓÛúc­0w¥æ	'GÀpGÀpGÀpGÀpGÀpG`G R;Õ¦ùæ¨¨ ¥ú
&jÔà©~±ÁúªsP«hUwñ©VOùGN½Cyà?KÆ¼ãCñéCÈÑM±üà_¹hØÂSèSGQëFøHó/ÅWÞèä1|xÊÝºS që­LJÈ'-<&#0%3V30k´ò§HrZdtÒ>¶Ø@Èõ"(¾lËwÊÁÃ/ ^ëFJý££´ræÉ!Äg_É_þà$S!N2ZxP_;F{a.báGÀpGÀpGÀpGÀpGÀp]ÁlÅÜ¥qÅÜ,,6PªÏPà òÔ§VAB-Æè#Oí¤>zôU«°nô¡"li9°QLëVû©?ê ø²v²Oõå·ÉbkýùCinôÑOþå¿ÄWð!Ù)~ª/9­ôé7LJªaÃÄ@ÉëÅ¡H#kzñ´t¬Iè!9-¤1zäúÇF+ëFP³Å-å);ôèpù'Glú´a³òC+ùBWñKªÎ9±9°/sÔ{ÚxÜIgså²å+99#à8#à8#à8#à8#à8À.@eÅÜé6ÅÙvP£@Aõê$ÔàÃKkª»hå:ÈÑK}hüQ c!¯Z<ìÑ#ìÐ£&ÆZÑ¦±äò¾8ÔWîÆ<ø¶+;xÄÐç`L\t5Fb,>>Ô_Z½Üã¢NXÉ§	¾@Õ¤¥§É¢£~êK\ +t%'><½	éCÈôbKOöÄoå|ÓÂNú"¨ OùaËJÅG!S<t9#â(?dÒ±nÏ¹qþ9àprGÀpGÀpGÀpGÀpGÀpv}­,ØlWÙ¡Z5H5	úð¨¨n:-\cZtU¿Q-DcÚ4ìT/¡>þ9?õ\¶â+_|«v¢i!ñ©£iM_èp ½ìð-_ÖóÇ´Ø¤öÊQ6òkjùefB)ijÑ>ñ±§$cEcM=ô9à!Gá
{ñ­[µIç(?Ä_úøP\Å@WyâBOqs¨p;Ål©/}äôå¿ÊËºÐG¯¾eÄÿ8#à8#à8#à8#à8#à8»>¿¾ì§gØLçØñÔ8¨-¨ Âux*©Íê1æ@¢Eu
úð)ü/¿Ôk Ù(®ê8èSçHýÊVvÑ§&"{döæ«~¤¢?õtåOyc[nÂyQ"y`²$Y+¡8ÅÔ5AìésHNZrÅHÁKã#ç@N?V®ii$cúÊ!Æ)È©<µ_Ë2Z9Çd§øðè£)l%WA>ú¬{²me¹Ô·²4(GÀpGÀpGÀpGÀpGÀp]Ê3æN³YÎ±Â5õvP;¨QPÈ¥õd©1@Ø¤E/øÓG.{ÆôUølImR¦QS,ÉàáBOþñÁSüÈ°?ÄÁ}ZHöØjMaúØ #}âÃg_ÆÈ¥«y«Ê=²ÂD ¢DB$ÎE$&N1(|M>&I¤ø)Ù_Ò*>:!ì+â¤L9ÂW|Zå&{xôEÄàHçBt$Ã79ÅÏÚ3VØÃ1g 89#à8#à8#à8#à8#à8/*+æÎ´ùÎ¶Âµê'ªAÐ§ QsÐ¾ê´ès «Âj´Y~ Õið¡Ú}1zª±(&1ès b¨Æc¹ê'Ê_ñ¨Èâ3ð­dA«x´¥øÊ;ÅOý)ñu'%MNIã/M±&+]MX­l5IÆrxÖ6µA¦CI_ô9R|/Æ²¥®ü¤->±¡°&â¥ó ?ÍÅºUð¤GÍEñ+¾uã<ÓÏ¶²¼jé²åð;<
ÏºÉ$ |1ôSÒABGE&ú# Ø¤}d+;^htCi|úÈ±X|Á/µrH~±SLùÂøð¥§9â[}½ ´v©øð±Ñ;ÆèÈ/cÅòîv;ù¬s¯^º¼c®ëÛo·XëÝ§s¨R½¹£FaÃG»-[¶ÄUr´¬ºël+ç 7'¦=^´UxY0pP;nB\%i<oîl/Î	oGÀpGÀpGÀpGÀpGÀp:4É3ææ[¢«íPZËU£ ¯±dÆÄjª¹ÀW¡
`È8%¾ZÅGNN§1-èÓ2R=úâD¾ÊSqå1v©FtàÚãßèõµcmeyyGÜÊrÐà!¶Úm¼¥¸-ÕSëÒµkºï±¨F1îé§¦5ÏóB=Âø=&Ç­-?3î6[cöêÝ;LÞsJ\)÷â/Úê¸ya¹m}IAoðaaøÆí,Y½·i¾g"Ûÿ8#à8#à8#à8#à8#à8Ê¹³,±Yv°5.p«µn$jÔ8 õi©{PkcéÑWýB|é«¾a*ÑVcÉu¡Zâ£É?ýT_õäØ!#>}ù§:
}|@©/|hè0ÆWªC_ctrN&/%¯2ÉÓ¤ ¯	ÆêcR
v*¨)><
]iE¹l¥ËXyÕÊº:¬1½â£¾¸ðÉC´Ô?}eC«|§ô±rémýÑùs_3j¤0Çóé&NÚ3Ú¯Z¹"ÌùT3_»YÝò¹Ål«ÊùUy§NÂ¾û·­\»vMñä´ª,íLÞsïÀóïw¥"ï;#à8#à8#à8#à8#à8Áë.½àLKl¦¬£AMA%ëF|ÕÄR}E~ÐÇzÆÆJ+¹ZcGß«_Æô}Æè©Â>sOü4?|Á§_Å?mM­.cöOÅ_`'*,iJVT²*<)×ÄÐ/Z ¬±|ÊVàªÅVúèÊßÈikòRZÕvèAIOZüs /{òa¬øY{E
ä)Ìñ,8ô»timñ³ÃÂMÛMò9VÄuëÖ´(7
p"l)ÌQ [»v­æ¨Y;zìø0Ø=úðö¼9>ÇN#à8#à8#à8#à8#à8@ÇD`ðÀáºË~ª­,×Yº°M-úúª_P¯ þ.5	Õ£li5¶n¬½ ½ê0U¯P?µW_~_ul¸øO®j#ÖcìdK~Ò§/;l4§ÔÞØqN´âk´Ì_ó U|ëÆ>­âÓÇåOx¹	GE)MF¾H2%>I+yx!I}WÁÓäá?ò>¤|²sCWÛEÊV/­l$7VÌñ³q{ù°nU>¶Äè£¯?2ÙJn¬HÏ@}
sleyõ®¸%2dX5f,ÝH<¯nù²¥a¸=?®kW^®{îÙ°`þ¼ØOÿ°Í%Û]nÜ¸Á¶²|ÄD@ÚÒUwOÍxÒ·º¹GÀpGÀpGÀpGÀpGÀp@e+ËÓ-¥¹v¬µ:CZ¸¢Þ@­z2ZñÐ¸hN>­øâÉNcô³±¢±¸h®âfÛ4}Å'7õ¥¶ÈÆÄä ~ÖõòP]ErÅdöm}(?µè²ñÅ¯»M'S·QF: |(`d:ét\$ ÃÇ>4a½ð%·n56|½ùà=ä¬[Í'ë<ñ,Oó_-|½Àð·â«J*"üÐ
â#.cÍÂÜX+Ì]¹«æl~gÍ;>®~c+èXIW(èQØ.oz©±nÜø=Bÿ#ÖÓ3ÂªU+éøÀpGÀpGÀpGÀpGÀpGÀèHT
sgZN³íàsÔ¨MPCPÍ<Zøª3Ð§Ú}j+È!õÑKUvÒ¡ULÕ,G~/xÒ£.>9ßº1OÅ/xøä >~uhæL¤\ð%ßÄoå"}t8R~êOzu·
Z·Aø!×ä¥ª¤KGg ª|+êÓ"×¤<üÈ}xr°Ê}tÅ£ÍúOE_ªô*WøØ(rFODàs@²S|Æè£>}ÅG¦ý¬Ï¹+våÂ\ïÞ}Â¤=§Ô,ÌÍ;;,[º|¶¡~öº	'G»-[¶%KåKú=zöÃínÏë[µËnYxÇpGÀpGÀpGÀpGÀpGÀè T
sï°tæÛñÔ)¨/¨Æ@-bQWPQM5
;mÉr_lèóP2Å·nod[xÊ
xc5-ÕÅ¯|¡§øÿL|úTSEcÍE­æBæ®rÅWê8i,éO|VÓÕ"tñE|H6*Ì]¾«æxþÛÞS÷Ýº5A2cúaí¶ÊÝJÏ³yóæðø£[a¶6uïÞ=ôík»ïuëÖu/¬
Lªßä¡éoúØ¡¯1¾ÓpÈä¼èëE§O|H/2}øòÕêËN¸(>~]Ùô²þ{ÆÜ»Ú3æúÆOhÓaéÅaþ¼¹±ý3bäè¸M%ü¹³gåËeUZ³RnÂÄÉQ¾øÙaágZÔu#à8#à8#à8#à8#à8#Ð<p`¸î²µ%9j
Ô(¨ÐçP±Zª§ö²U«ÚEj#[éãWñ¨]È]â§¤<á¡oÕCòAÍ~j£ðDÒG&"®tá)oá£<6ò'ñÐ>¼àEI>Hd¸&ÄËÀX ]||äò£ÖX¤4¾^4ZôÉ·r/d¿!;ñh~äògÝª|ôä;«®âò4Å·nÌW9ÅG>þ)Ì³s»ÜV½zõ¶sûØô­[m«áýìqã÷li	MâñðmOY/MØcrØ­ÿ¨þä´Çl{Kéä8#à8#à8#à8#à8#àt\*+æN·çØÁ3æ¨IPà¨gè LuZ+ì¨5À£î {Ù Ã/ZøèÊcdª§À/µô¤O9xY·ZsIcÂO}kâxD¹äØ"S|ì9 t1vèÂ/L
RÄ>HFÉ`0¾¥Ê4å  _ÈD§Zù°*\¥úÒ!GÙ
tÅJ_(xè¥º6òÑoö/-DK>Oñi!Í¾x©|bÃ£íi¹]n+KWºß¡kW aÞÜÙaÙÒ%±¯?}úö
wÈW­\ûýlËÁCF­-[¶9³+Mæä8#à8#à8#à8#à8#àtt`[Yþ­,¹(¾ÎjÔ ÏTk§<úªS Ò"ìñ§ºäé«H?ôä¾ì­[­ÑÈ}úªs )ýÔc9=}Å§øðÒ>º<bªf=ñS¹âK¢lþÆjä¼1«ÚÚédÐoM9 ÂôÇhÑ°ØpÀ<Zdè@Ò§_>cÉ_êøéLÅ E/üÐ×hÝ*>|²Ã}½éÐU_yª%¾bÈN~h) Ko;X1wÅÒeË­Ûñi}Ýºuë×¯O<þH«	SP£°F­5¢`7wö,S¶­>n+·ybE;'GÀpGÀpGÀpGÀpGÀpG`g@ ²åë\;·zÈ©¹@ÔèO5ê"ÔÒúrø¶êã:-||¤âé«nbÝªü+>­âã¹ê3ÖyÂ$£r!~9¤øÒ¥¥¾²Ál xØ*_b¨>1-6Ê±òÎÆ¯©×G8.JJ_$£di%#yúPªN>¥öèK¾|¤`+ü2Æp%S^èÔÒSLÙ(_ø¼ððéãOº+-x}ec¬(OçâÓ®æÂXròcÅÜ¸Ï:çÊ¥Ëw_{MzöêÖ®]f<9ÍÒß>
ssìàsÔ¨]Pcè«6¢Hö¢¸
Uèéb{Úâª]È§ü¦vªaà}|âCñ¥+¾üÂW««ò°áHëOÈáÑ¹¨oÝmúÒq#üðp^(	pü1IÒ!9«ÇÒÛU é«à$;½à´È~ @áàÙli|t
­lµ¤òK5µêê6ú²£EO¹3ÆDlÆ¯¹§ó§øèa#¹âk¬gÜJ$øø'_ÅGe`£ís×,ÛIVÌÅ¬ý#à8#à8#à8#à8#à8#àäB`ðÀö¹U[oNØ¶QuÕ¨-¨n¢:x´õ
ê/ª_ÐrÀ£n¡Úu«Å.éøªa(>ºO_uìê)wdøoñ#¬Å'Oô$G{â@è1Ïä¾l­Ç¾äÛÜ¤¤r;¨*$_MBI3¡ÅNmM%P0Ðð	1=¼¬Éù®|ÂOsÆø¼às _z/|)®bèÍ`¦Õ7¾ Ù(läS|t_vè²bnìÎô9wrGÀpGÀpGÀpGÀpGÀp|TVÌfÖÏØ±Ú( Q_PÑHõÆªuÐ~ÚG.=ëVý¤ºÒQêÔ|ÐQ_2Õ9Ô*¾| ¯øô!Æ"ì Õ$Ã^1¨(¾úøBGå}Zt¾ü+>:©ÉisçvP1¬¾Óhr)_ÂÀHåô¨ú¼¹/Û¦~$#úØëhôd>òT.Òa,;ëVßÕÒXò¾¿è¤õA®réeýñ^TÞ:#à8#à8#à8#à8#à8»6sgØ,çØÁ3æ êiÝ:E+jðUàdÈ©¹@Ô ´ådêüÁC$^Óhë_ñâÓÇ:øåñ:e>ÄXñÑáðÑÊ?6øÒx²CW1èãùË2ùPZÉ­pPÉ­JfJà(0¥/ Àeâ)?õa¢jN`ÂÃ¯ÆÄV,lñV¾_/ 6êc«¾æAÑ¦~ÄS|äØ+ü°bNñ¥GZI?Å´¯øòÇùém}VÌ]¹tÙ®ÿ9«#à8#à8#à8#à8#à8#ðF R;Õ@`Å9j*h©¾BÚõxª_hÛKê­êò#>2Õ*àAò)ÿÈ©(êø\2ÆäOBnJåÿÊEóÄòD:âX7úÄG|Ù(¾òFO$ÿásÀSîÖmÒ [oµ`RJD>iá1)±ÉX¤?½@Ó"¤ö±ÅB®Añe\¾S|¾xõâX7RêÅ¤3Où >cüJ¦øò_$
qÑÂúÚ1Úsÿã8#à8#à8#à8#à8#àìòT¶²<Ã&:Ë
m¡T¡&ÁA-!å©O­:
[ÑGÚI>}ôè«VaÝèCE0ÙÒr`£Ö­öSÔAðeídêËoÅÖúóÒÜè£/üË~¯áC²SüT_rZéÓoTÃ×CG*×$ôâ3iéX7 ÑCrZHcôÈ?õ
WÖ f[ÊSvèÑàòOØ'õiÃf1åV6ò®âT?rbs`#_+æ¨9÷´ñ¸Î:çÊeËW srGÀpGÀpGÀpGÀpGÀp]Ê¹Óm³í 0G-:ê
pØÈ[V*>râ¡ËÁ¹ìGñIÇº1>+æÆù3æÃÉpGÀpGÀpGÀpGÀpGÀØõH¶²\`³]ejÔ Õ$èÃ£¢º2ê´riÑUýFµiÓX²S½RúøçPüÔrÙ¯|ñ­Úr¤Ä§B,|¤5|¡ÃLö²Ã·|Y7Î|ÐbÚ+GÙÈ¯©å#AJ	¥¤	¨EF_úÄÇ&.e5QôÐç+ìÅ·nÕ&£ü_~éãCq]å_<ÅaÌ¡Â2ì³¥¾ôÓü*2ü)/ëFB½>vøVÿã8#à8#à8#à8#à8#àìú8 üú²a3cÇvPCà ¶ z
oÔà©X¦6«Ç}]xÔ)èÃ#¤Xò/¾üR¯d£¸ªã O#õ+[Ù1FìAØs(><^¯j.ø.<VüÔzÒ?åDn¹	çEäIÉd­RàSÖ±§Ï!Y:iÉ#/9-þX¹¦¥!lè+r§ §òÔ~-{bBÈthåsâÃ£¤x²\9øè³bnìÉ¶åRßÊÒ prGÀpGÀpGÀpGÀpGÀpvm*Ï;Íf9Ç
sÔÖÛAí ¢FA!KÖ;1¦Æ a½àkL¹ìÓW
	8PRT:ÆPv¢ð5qú$}rdâ+VV¦<TdS|J«øè0°c¬ü2å_ñiìáÑ#qÐßæ?kÏX9bCÆàä8#à8#à8#à8#à8#à¼T¨¬;Óæ;Û
sÔ¨¨ADÍAcúªsÐ¢Ï®
[ªQÐfeøT§Ájô!Æè©Æ¢Ä ÏLþ¡:!äª(Å£^"_ÏÂz´1&­âÑ*â+/ì?õ§ÄÖmP49%¿4qÆ¬t5aµ²Õ$CÈáALZcÚÔ^b(-$}|ÑçHuð%¾ËVºò¶øÄÂ|Îü4ëV}Âq4ÅG®øÖó$N?;ØÊòª¥ËÃwrGÀpGÀpG &={öëÖ­«)s¦#à@gûïýè©ÃÃ=O.ë7òï½#à8;þýµs¼N¥# gÌ±bnkíPÁÊº±¾ÀI5µÔ¤£%3QÔEZ}jÒ1|Õ@èè«H1ð¾T´ÃHvÊÔO:VN´¾3_µÆ2ù.|täC¹ÊyÀÓ8_þL¥qRÐÆ-·Z¤	âR}&¨D5Ö:ÈÄg,¢¨¥WzÈÔL¶iú:È%K[äP*×ZÍ&_jÑ¡¯S>õ"ÑJW/"<(ÕeLlÅg1[éô¶þl+Ëe¾%99×¼æ5áà®Ï_þòp×]wÕíLLæÇ<¡o¼1<ôÐC&ý¢øµï0@¼Dù×O~2tíÖ-¬^µ*\tñÅ;ÕEèaÃ÷¼ç=ÕWîßøFØ¼Súï¶[8ô°Ãâ<þñ5kÖì¼Ù	2ßßÿÞö|ÿ¶Õçÿû½>üðÃþ{ôè¿,X¦On¿ã°eKú/WóW¡=çß<r¾QÙ¿ß;Ûüó¡ÖvVí_GùþØ·{øø÷
møa¡_ú´ò­í¡úrdò#=ùÌTª5ÅÇ=|Ë¹â+Gtå=úäC+=åÃ>$_ôÑ$SLñ¤9ÿ¦Êé¢&Co&¢Ñ2yxÈ4ëFR.jS°²SA«2b¯VñâiL!Ãú´¡T¾â#§¸¯òT\ùc]êÇÑø"â¦öøÄ7z}íg[Y^ÞÑ·²Ü­ÿ0bÄ¨Ð³W/KÙB¹~}xâñGb{Ý=5ÊÎSXìEÙ¼),xf~X¶tI«.úíÖ?01tîÜÜþÅ_³g=m+*V¶jß¨*=ï¼X@Äö¢.
ÓgÌ¨éí>ûÏÄ»QøÑ~æØ	¯ÓÎÀ!Cæ^vÐA¡Wåý¿+æ¸ÐÎ÷BEñ/jßQpx©æ¡ûåvÓÊW¿öµ
ôÂüÓO?.¸ðÂ*ÿZÉþù¡ýÞA\üÿâ¾TK­Mxü=fôèøÏöÃõ×_owþë´­MBê4Oþ;óû¿TðJrÖïß²?ÿzh8%Y0í'Â3óçÁ©S§îÝ¹Ç/«¯¹&<ðÀ5kÏù×L AfÙ¿ß;rþy>ÿ
'4*b|Ç£Ãþ0­ÍñV)¯8*L¶êÙÿ%_úÌ3á¾®/ØÎ­Ñë?üÐÍVÙBë×®	7ýøÇ­©7u·ÿ{ì><ô<(ô²óÝ~{Ý7J³ÉPEíL·4õî½zÃìÆËÁvîTV/]þù»ßÕËÖÊ+òþk4´0·dÞÜð·_ü¢QáØ3Ï²÷üîuÛÝý«kÃâÙ³[ÔoÏùgØß_Ù\Úcü®w¾3ì½÷Þ1ÔÃ¶:jÑ AÂ§?õ©(m¯ÝòZjyy~ÿ
-ÑAüËþý.rþQ"¹]5eÅÜYlÜiÇÅoÕTP3V¬-PKàÔ§¥îA­Av¥GÒS«:.¶c«zGêÏØ±>L>á¥ýT_~SQ|ú<ÕiâÓâvP:¥ú
¹© <:ó3Â~ûíÎ7/üð?¬éüØc	¯ýë£lý°ÿ¤~Økwf»"pôÑG7¾á
xQ!ógßã_vpä>}ß}áÑÛoËhl;lü·R'Oþ©ç¢ö©¯öêüú7ÑUCnïÿãMá¹ÙsBç®]¬Ø;9°±gåëe;[XUTf¾yßæPvaî÷ßýNx1s}ªÑÐo¯ù×Ê­½¿¿jåÐ^¼lanÝ\ÿ7×§¹¿Ûs³¯»îº6I1Ïï_$ÓiüÛâ÷;ïùGÎinVoþÂÜÀ;´bÚ	µÕPèsPSPý"Ã£A¾.²K1||¦>ti!Å§¯ø´Ô:4Æ'}Å·n+^Ö§|£/[läO¾áÉDË¡ú
}|@©/|hè0ÆWªC_ctrN&/%¯2ÉÓ¤ ¯	ÆêcR
v*¨)><
]¼*d!­t+¯ZyÂCWu#1°W|tÓ>y(~ê¾Æ²¡U>ÊSzÇX¹ô¶þèú¹î¶íÅ^S¦Æg¹­Zµ"¬²-#'M/ÔS1rT¶û¢ýçÎ±;z_Ì9zLjÛ\BÏ.ZnqPùÃóìÆMGëì9CÓ|¼Z|ãbÅ}ö«ná3Ç¶´\aÏ¬+N;í´p =?oÛ}ÿ?hæ}¬ßnûöCmÿï|÷»Íä>Øµ(ãÂPGCÄsíñ|@[ØËw[·e^oë\wÿo³ßÙCì÷úm½ô·»îÚÒ®æ'ÿùý_øK´Sæç¿=çæ?ÿã?"ÜõÍÝß/EÚÏ¿ò|þw¥×8Ïü;â÷ßSWì=,\rë°d7²·
qdÏÏ^{í8Ygu6«¸Øwßâgx{ß¿Yùþ,­²çÙ´ô@uéÁoø­½îµ¯
«yj=Gí{÷oú:µ_÷üðýÏÝ"ÙïïÀÊÿèìcÛø36ªOûÛ_ÃsmáÛ9®ýTÝÍ¿]cØ­rþÌVkí¼³u5=
LÐJ;|QÿÿÌíÌ?+«ï11ôÐ?ÂX±¸rÉsa9ÿÿ&¸eíXÙËþG^°ë ëì÷­)w·óàÞvmdãúuqÞKìÆáMÉwïþ¶í÷vÓÿþ÷0í¯wÆ~öÏ>G_¡Sýã·¿*ñ¯Êýþ«Ø§
ÆèÈ§ôS©Å§%>öòj#ÖyàO>ÉOúôeâ§öÆs¢_s¤%¾æA«øÖ}ZÅ§M:|ÂËM8/JdD$Æ F¤<<¤¾«àiòðùT|åºü
)>vðô"ÐÊF~õÑ°ÍÆQ|ZìåÃºU]úØ6ý
nõ©?2Ù¢«Ö­Ù§0ÇVWwÄ­,I:KõæøbßwÿâEÄµö éOn-h¥>'ï¹wàùuMÅ»ª".>böö~ôáíü¨þ$Û&³wo ´ÃNn}øm¶øiÒÎÿ÷o{xÙË^p!ô»ßû^ìs¡ô=ï~wìS4ûú7¾sÈFâ¢>¦NÚl_wôÈù1Û:ð{0qöâêX+¢üË>ÝýóÞ{Ãµ×^uÇ§zj8¨òÜ¯|õ«Û½XZÓÉv\>åSÂ^{î¹Íxm¸ûª«®ªyqh]<ù¤Bÿÿë¿ùÍoÂ³5.®åþ'¾¸øÃý(¼Óè;aüøfÙmÍÚcECy_M²~øàâÞö¼DåÂÜ#<N8áÈnÂ\ÑüÓ|óà_¦}êk{ý3Ï<3ì·oÓÆ×_}øËwÖ4yE_qäQÆþöìsRÞ÷OYß¯zå+«ï[þô§À3*^ýêWWoVP®\P¿ÖòÏn÷+y6=±g52§)Ì¥Ä7ÞxcÜÞ0å1ÿ"ß?õ\?ôCÂÉ'\Å²Öûb:pk¿°÷×=÷ÜSK\÷O|"ì^)¤ÎêyÆ\ü(L|þüóÓ­öÏÿüçÃva%Ky??Y?ËÈ¿Èû_ùrõ{îáöl@m	.ílûí¾ækZ¼ñ'ÕÍÓçÆé¶óÀèÑ£·1§¸{§}/¾¡òÜÖßÛïø_mR¨Ï/~¼±òÿýüïiçZï}Ï{ØÎ_
Õ·Ú*Zwþ<Ïç@LùþÍÞxAòCü`üþâ{ç>r³T[Qßÿ¼ó×ò~ÿñùW¶:÷àÿþÜçjþ_ú¤w¾éA=ôP¸ÒÎåEyñ+cþe|ÿi¥íi¿ãë¬Àb/J«)¥ÏfûÇokE|7¾ò]ïýì;8KÛ{ÆÅ7|ä¼¬Yã~ð}+m-ÊÍÌ1§ãÍyôðàÿX3vº]ãÍ\P-6Í¿¨½íd¿¿S96·wºTÉ!-«Øî»ñ{ÚïöÞ¶å$ôíÀ5)G¾bÿÃ×Ya	53êð¾÷Wzºø¢}Fáèµø`ôÇëwã¿/â°?yß²§¥8y ýÊÖ­\÷IÿG(\ß{ý>Wa=¹±ûîg[Å¾&ðAÞq{xÚ®µÊ(Ìå?Ïsä¹ÐZ»éü6»)<[t8|­<-æOAúÏü,¬±tBHsüoªÿn±ÇºõÖ*DÛ+Ìåýÿ¡ß?ÜQçïeä_ÆïwÞó½ÀyÏßd_´Íe+K<Ïµ»u¹ø®¨7ðeHË2Zñt±
 PÄkx.«ñÒ³ºéCuæ(Ê[æ¸Sçø@¼·µ9pçðQ¼QðáÂþög~ëÛßÞæ¢Î×¬Ð±â»¶GÕ¢+
¦iì½0Täõ'Í¢ø±á¼|$®J¨gÚÛ¹GJ\1W4ÿlÎâ_¶}Ö_kã­ÿv+ÈC¿e-kq>ëÐm|V°¼ÊúþHs¬àÙ-Ó/~éK-æëÄþ»âüØdUÖ{VàÊïí]?Æ
sxë[ÃÐ±ãªðoÚ¸ÁVõ½º'çtí7ùÏ?»¸YaIianÕÒ%a·ÊµÉÓ7ýøGVÛ-ð¾÷EÑr{DÈ_ì¼°5:þ]ïªú½íçU¶b¶(þ§÷Æj·÷þ^÷^½ÃQvóq¿»6Hb÷=¿¾.®d¼½ÂÜ¤C
¸¢Îöû{ÜYgWq¡hûäÝwIüoÓÂÜ/~ùËê#g8ÿý­ãzþöeWÌùÿ¡ß¿yþ^Fþeü~ç=ÿàµ-rþ}7ÿJaîLËa¶v'O¬P Þ 5x´ðUg Oµ	ú*rkª}ôRÚh|@´©âÈ¯â£¯øÒ'=úèâ#Í}Å/xøä >z:4NóG&R.øoâË·r>:)?õ'½º[­Û EükòRUÒ¥£3FPU¾õikÒ~ä><H9Xå>ºâÑfýË§¢¯®Ö*gÅ Uå}Æ?-$;ÅgÌ!ÿð!éÓW|dÁmð¬»bW+Ì1aO×Óþ!Ùh'£Û]oMP#ÙJ»OÍxÒg×´Q>}ã8K,ÏÌ[58hp;nBu¬ÎSÓkÖðV.½ÕN®YÝ -´í~e«×>üáÇ1£)q±+Ko3»C*vÝ¸øú°­Pößo¿À]ÉüøB÷ÚZ¿LVÅ³m¸jmÅ\[æ¸øûþ÷¿?H¶ÔdEÏ3b»à³[]¸]nwk}µRL#ïvX\ÂÊÀØuï»ÿþ¸J>måËkm{2]øaåà¥]YtaW0¾Óî¨>}zÜ>$ÜÍ±(Û¶%5za¨ÈëÏ<â÷áùêvpl§È	*«äØNì5¶êI+AYÙ¹¢ù+/µâ/;µEíå§ÿñÙÏV/ÿÈ
GsÂ>Øøsÿýß±eåÓçÎ?¿ÙV´EÞ?e}¤9Í-sïºûîXc«
L|\o[¬Q°)tb/|þñÏ6]í"#«xy/ClÁÊOQó/òýÓÚùÿgÏk9î¸ãj¨µRáIoyK\éDÅ¿²k±aVô8Ì¾_yOClÓBq%»ò:
üáuÕM){Úv¸¬)Ì)|#ßßü.î1aëoüé¶]
<ÜÄÂÅ¬fÚ¶Ðé-È|~Rßyúeä_äýOÎ¯¶ó×TV=­±;êk+/zøá8V¤f¼¸0Ýo¿Í¬Ü/¸(IQÏ!DAñlÎùÀ~vþÃûï@Q³Â\Iç?EÞ¿EÎ~þÓ->ùÕî|þÓM`©pLÛ"óç=Âk¨sÔ+¯¼²úþaã1ïâóüåìç/Í£~ßï"ó/òý[Æç?/ftP8õïæóÝwß}±þ&¦8nxã.è
»¯ÿQçÅ¯ùýþ#ÿBí·mEí÷êîë~¥á6í³G(Ø9E¼/ø¿mäõ2ì>Üü4ý9tüø0å¦Ý¶Wáû{pr#Ô¡o<1P\îùõ¯í¹e\¿ÛJK3["Í?}FZÂ\ÑüÚÌ^ö V·AÍx6ß3O>Ç¬H;ä
ØÐZ+¶Ürá±ßZamY'öò¨ÇìJ9	ÒÂE1
ªµhÕçâ6µdEæÏ{äèSVÄáû^ÛQ@ï©Ç&U®-±ëW\øµrx)òÒÂÜþ×sÞûÞ0Þ¾ÿ ô\·µÂ\ÿÊøýÛçïeä_ÆïwÞó^ç"çoØAyó¯æ8oÇvP§àH5j)¾øWQM5
Ûýäÿþ/v"£òlþýÓ£.¼0>ó-k+CæÛ|%.8±Qwïíë_o¶¥VzaÂ«´¢(½«íD±oKjäÂPÑ×_óÈ_úþaµ!ÛLeÿr]ìÞÿý*®¸akË2)oþµrhÿ¶°¯å³5Þíâ¥
'ÿ´6[=¦Ä6ü=a«fö³UÅEß?éë_äû#[ã"ìÿÙAé¶f!¿ü¥/ÏÚêª2qØ×úü³­åû+w³]É¾üå*~eÌ¿È÷O­óüfdÛúR°¸ÍjnZ¨Eéçí*Ùö/KÚrî{ßÿ~ `Út mL1j´0WëõkäûûüóÏ+ùíý¼i[£¢Ö|ç5?1¼ÿ¹ùå¿í/Þg|fgÏÝ,u¶9þøÇ>Ï¥Àó«_ûZi[aSÄ}ï{ßãñÀVÙgArcÛ|ÒÂ\_ùUÛèû·ÈùOåÍ6àýÌgâóCÎóP£ó'7ð¨ÏV±¬Àâï].ÞðÚRÓ3óäU¯MÑßÿFç_æ÷oÏ½¸dõXÅø¯üddße+)~û»ßÅþñÇ^g7@üVðM¶µçsNì³sEKÏln¿è°ò'Ïü|ÿ¥±;BÒ¡ÙÇTSYl[ß}í/«ã´n£XÏ§Ô¶µ~úÜ·íæ²~^ÿán¶
seÿÿÐèïß>Ï¾gÍû²¿=ÿ(óü-Gq#ù²gÌýú²aqæØAaÚuê*©&Á?Ãiß±ö v­ésP@.èm°<ZäØ>õÅ×?á´i}ññÇôñ£øè">óC®øÈ>ñÉEöÈ éÉwÊ§øô¥C)>¹É/<Æ¹I	äv`ø@´:äS )YôutùÀFöèKO ¤cú`¤ñá	<úøA.Ðä±À/ô Z^dt Æ©þÓ±ôÑ¤½âÓ*/øÎ;â'ë?ÜêÃVWí+æúÙ
&N®þ.±oËíü0ö°»¡
sEÏÊøü¯Yãûå¶s¶g+cÀF+-ÛcKáPô÷¿Ñï¯2¿ó|þ5ïF[.>ò|NV]²JÕúÐ»mÛû)É¶úü³¥»p.ÂoÒÙ
~ÚZÔ(~©<ó/òýÆî}me¹²zê>;aeR-J
Ã|^^û~[­mçP-l¢Àþàâæ<[(Êæî²ÿ¯¶%UèãÿVÁ=c[À·DõæØ­0·GÌ_¾ø.?Ú¶teõD¡lúôoÚ)Ä·°RÍÛla¹©ß0h}Î~ò´X+ûÿFÿvôù{s4Ch4ìËþýnôü£Ìó·,yÆä_Y1Ç)síXoNÊ(J¥¹øA]ÕT{O¶Ø!ÃF-õÆ:¬ýð%=zÊÃºq¬øòA\å?øâY7<Å¯°¢úèfõ¹òÀeG)>}rd§±xØV²Ü¤@¹!>ÒÉ´ÔÐa¢`¤`ÁCB|ir´ðxë6-ÕÅ¯|¡§øÿ/ðèSMi>5µ-â£«\ñú ¾rP~~w;j>ñE|H¾T»|W,Ì1ÑÁCZmÝíÒ´Ç®^¸l·Ñ½ÙØ^üÏ-^XAÇJ:þq1}Z,Î
HP[æÉ?'ãFðoûZ>·ÇKEÉ9VÎAüÃõ_VHRQÕ^¬H}ÿõýæØ÷R{QzbßÒüÜÉk.4Ò/cþE¾ÒóóçÏkíµeíÙÖ¯5bàØÉüöxÖ¶$¤ßÔÈ?äU¿t^\`þÂç?YéodªíýüdýçÉxEÞÿ'ÚÝæG½â1m¶¾ßV^awË³Ý
ôÛêònÛ¢¶bk<=öÇvd¶]©Eé´0WÆç7¯÷oÑó2>ÿÊGæÈíÆ9Ïâ.îÚkKÅ,úûßÈëOÌ²¾ó~þ5ï<-ÿ;ðâ$72pQÿ|kyvè:;ßæ¹:l)ÏE,V´²³BKÔ(~òwþE¾ÿ»£µ¬&Ûd¯½ -¦ÖËn4:áÜ÷Ey­sCmß#ßú¶ö¿ûö·ZÜÒ.Oa é
¸z¶Ö,#ÿÁ£FÇg¿è¹Fó'fJyì÷µÏÓÄÝ°:rþã[F©oblw=|ëlÊSq³­,Ù2ñ6;oÜÚkJ8Ä3	=eÿo<ö;Z5`Åý_õê¨óO[]»`ÆôP&þ
ÞÈûo+ö¦7GS¶°¼éÇ?ºÚ´0·ÜþoaµÙ°ñã«¶lÇúìÌ§«ãZ´0wçÕW7qÙq[Zg_Yg[oê«m×ÜÙg®Ýÿþú)JÍûéy%[Yò;ÈcXI®íÓ¹ÞÁª¹OêSÑ8}Æ\ÿ?äùýÛÑçï)yòÇ¾ìßïFÏ?Ê:K±(Òo$ÿdÅÜl©4pPÔ¢ â<ÕD¬ûâÑ¢¼Ô)àAÃÓ!¿ªÔúÒS|ùÄöªo(Z|ÒWkÝHÄðú`¬øØR}b)äèaì®âK/ùCRØÔ{Tªç×£Û|¨%QúJ;ÆðIX'¾ZcE;Æ¢Z~d/äl¢ E^0Å
äõR£ßÔ/¯¯lØ[X*fÑßï<ó/ãû7}ýêùþÒ|´é6ÚÜLÃyXº;¾§ÙjK.¹$hu »%p±²%Ê¾òÎ¿È÷_KsØøløÆó>S­UkïÂ\O»AèµïkºIt=ãò¶_Ò*eä?Øna»>¨ha®Ñü³ËcnÃõ×ÒxúßÿnÛNÞÙL®óÈÃáÁäÿãfÉ`¨Ý¨väÛÞ9-=».Q{ÚN@{utdQZfçeâ¯X¦ÒU|mkÍØPZËÚq®|ûenwûÇ´0÷ûï~Ç
s\ÎOÌ?em¿y mÃ)Úb¿¿·_~Ùvç ýZ[«0º	>?á÷ïö8H¹²ÿÈóû·£Ïß# ?yòÇ´ìßï<çe¿¥Xé7eÅÜo¶*ÌÙ=±æ@"ý_$Zñ©/ 'Jeê£CVv´*xIn¬Hð¹¨­øÈ!ùHý¦>ÑIsIí~T?Iíà?µ!:jéËÖº$c@?}|ÑBjå/Ó¤ÑÀ_9kÀdU&¢d2&)xYB&BGºðÈC¾èËO×
ßH4}½~
Lª(ÍG}ìÐ×ßÝì?dòG^ôõ¢Ó'>Ä<ä>¤|5F®¾ì_¶øQ|teÃÓ'Ø3æ®Ø1gskFÜqÛ·o?C«S,¬{am7a¢mEÖ?ä(Ìz÷î%Çí«°ås±­[h+èD¬Æ£ðÍxr­ÚþK²m´dÓÏ­\LcwÁý¨»¸¸#%¹¸\X1Ãv"ÝÝ>?iG¬ã¹"<_ªõ|,åÛZËøl3Âö÷®î°7$+ua!ÿûÍÚÏ5HW$uÂ\¯?xÁ;ÃXµ¶ðì³Î
S§NzeæäÊü)za®¨}&º\c»6îÞ¾ew¤?kw¦¿åÍoGØÃá¡+mûZV@ÊxÿõýæZzÎò.»Õ=75psC-j©0WÆü|ÿ´vay,_±"|ß.l·ô»Îß½>8n96~üøTû¬\¹úkZ|6Ð69ücA"ø¥)¦ÏLjíwW6e|~ä«¶Ñü³Èû?Ý"[þ¶×þéÖ[Ã-·Ü²=µºä¬päN[íñÒ-|S§ØU¶¼Lse|~Ó8ôyÿ=ÿ)óó^ÙQ9¶e·;ÐY¡®ò¬­Ú¢¿ß¼þé~ÿæýü§94ÚOçÊ6Ù|ßd7Úq1m<à¸sÃÙV¥lk¾½Ïê³g*ç¼ó/òý§Ø;kûF{fXÛU8ÏKWØõ´Ïbºúg¼½7ÝÚ+æú^õî÷D(Ù¹ÆW]¹]Xæ?ØOqÝ-ÌåÉ?`û#Nyk³×(õ×RÿI[­þÄ]k&NsÚ3Oß·u»ûfÉ -JQd£ØÖ±ZUsÐ.úiXcç¦eâ¯Ø¦ö:Â{W¹	zÝ0ðàÍºÚZkíF¡;.¿<l°kP-QG*ÌõèÝ;>³P¹n¶"!Ûòì=§mh©0Çï ;_iûtvhÒa*ÌýÿCß¿}þ"'ìËþýÎ{þQôü-Å¢H¿üÛs¯»ìÂÓ,Þ\;ø¢¦@ú}ÕYh( ¥z*¨a/[µèA©l¥\ñ¨]È]â§¤<á¡oÕCòAÍ~j£ðDÒG&"®tá)oá£<6ò'ñÐ>¼àEI>Hd¸&ÄËÀX ]||äò£ÖX¤4¾^4ZôÉ·r/d¿!;ñh~äògÝª|ôä;«®âr%Bñ­óUANñÑ¥
sãlÅÜ.»¥Í¯UÚgßâÒr÷Ä´G«ºâöºuLçùÕ«ÃÓO=Ù7qò^MÅ>ã¦[a6S*i®rm¹·P#~è_`u~úé§énC©O.vP¸ ûÁ| öyôÑp¹DÖ¢tË(Vð­°ê2èðÃ'½å-ÑUú øz}SpdÄ^¶:D1gÍ°¥'Ïµ`Å!²©ûìwèì*9æRôõ/Ïo[Þ@­meêñ|CsXÍ¿VE/Ìµ¯S=¼ô.½;ï¼3ðÌ?u<((óÙO©èû§¬ï´0^8Osm«¾0ÈS+cþE
KÙól'xÝÍêµÏ9¸Ð~Zz¦O-\Yaý²:=ç	½¥öl>çÙ÷Q-yyücA"ø¥9òàöìc5sæÌÿÏÞyÛUT{| ¡"@:$Þ{.Eª(@Tõ!öÞÀúl T¡|" ^H#ô$ oýæÿÉÜ}Ï¹¹gÏNr¬õ}ûÎÌÕfí}ö9wÿ÷ÌÓÏ8#ínX×µCgïßFK2ËÄ+¡Ìõîñö§#×ßìÀUÍ¼üÆ×¿V°.¡_ÚK5/6Yv5Ý÷*½¿Tñù-·ë7÷÷Oÿî Ì¥º×ÙÍ°\Ueî÷w+ç¿YÌeî¿e?ÿÍbè
?}Æ¬jD®gËÓßeßAüïòñµÍ¨9÷¼óÂÁðÀ²øPÑOÙüÎý¯ûüÖNA;¯¸ÜÝ×tîµwXmøðØ?'¹em©û>qd´?Å@Ý;.Ý4uäÆîqÆÒ,±ØR?×Ùï¯½ÚA¬Lü©2úî¶{XÛ»óWÜ;.µ¯:³ Ô»é¦ðÔý÷E:´t÷8îóØåûüº3Nou²/ôNG~2,k«Ù@Wýö7á=û_¤Êü+ÀV¹Al6¨½<ÝVI¸ÅfµBE`åD'<ô`ÜÓõÐT[bþK/iºôkzmÍës[ì·XÅ^OéÙ±ö¹¸²ñç"[ëéï½ì®<la³ÿHfÿ/`¶¾{¨çþÿPæûo^ÿ~gÜ¢2ñ£«ùÿE¾Ó²ìïÔFßo©~N½øk3æ5í } àø¢ÐÁÍ>á<*5Àã¡ô¥¶(á#+´éÿ ¾x©l 'xäà©ÏªuÌ%õ	?µ­62òOdàqÐn{ÒVg¬ø§~t5Å
+ö¼é/O'k×_u£`nÛnÚR,Ã~Åe1Æ7Í|¸ãÿ­½N§g0
}Î9a¬½ùX¤Üë§ªûÇü
ÌU1þ`)}0ÏliÞºzÈ!a[~JôvÏÿ§Ýû¤ë}GaÜ;ì°8¾Kì>{_ûl#½2¼Vþ±À~NþÒøÒsùÍ?ñ¤ÒîõÜÏOC£%eâÇUÎ?¶kÛLôOqD±t³}FK«SµÝvÛ-pïX:ïÔSOí ÆHg
Ì¥9«ê÷O+×/þs~ÿTñùWÂæ%0ÇoSö«ÕïÀ¿^ye|Gçß|¼tÀKest?ÄOsZ9ÿø¿Üûoz-wõþÿ\J÷_Æ/Ø±¬>ÿ¤+m¨^Q­æOzeÇsÿïùµìe{²ï`ßí³1pÒæ40·hÛóÎîÐ[öbKèÍrãgÖËaB,×wíéì Ì|ÐöRÛ¦¶rÍ¹2ñcOTFÛ·{}÷&ÈÙ
ú ð	ô±®A©~ÚÔÁ/(±G¿lR¾Uc?¥t§.>H~¨§¶hCôCèSxò/­#ÁÃ§0ôñöË¿d)9 Jõ£ÃQßX­·¦ÕX:²­ÒORáôÁc@È+±èpÀ'yô!I:|Ù ${©
ÌÜ~ÇáJ{ ?¤±¿u
ôÌãlæº_D¦ýaÉÈá¶Ú[oi¼æ±vùôQõü½bKIßnç­Ú½}øÖÛÔf¥~¾ý¦&gPeþo+Àòëí¸S²ñÆT#=i3³ùÜ¤ ·ù>ûÆ¼²÷¡Æ×0è¸Ý¡#Âòµ=ØùÞâ³5eÒ¤Ôô¼1gçh;»Æ¹F Þ¼}ôÅÜÎÄ×¾Óí¥õ[mFK¡¶PFG{|øÃq?zVpâ9Qw¥ÙsÄý)æÖ4NsUÿÿÐê÷ß¼þý®¨l5~ôªþþnå÷GÕ¿ß²økKY0Ü^·</×v@ØA]|xzÄCrpúµ=<oã©MpJd±1ëK¼­?ôd_þ)å{ô#+ÿôÃÔG¾l"ú¦ÉR¯ð¦Kj]äñ?úç M	O±ÐVÜEÿb1ñ®sIa`,¥ú:Ê¥§NÂR}ä%C]6ÒdËìÒFäªOq!ÓHN>¥£xásâáSÇdÕJ>þh3êjKÇX±?32òO]²mõ3æpøQN}yºU»?Õ÷³·ØûOçSèïµBõÆ?øS§¼^}ezüQ±¬-Ñû+ÅÁò mâø§Â+Ö×ÖZ{½°xmÖÖ[ö¦ç´iSãÞ6ËjIû§zÇbyt6±4²Ý*¯`ÛÙ²	¬-â­b(b
0Ç8fÆuFA»f2,¡³úÐáuð§(ÇàO=ñXÙE¹*Ú­sø@Ûu×];uýõ×ÜpCzð¥/Å¸:àÅ4=ìg¹(ªxsçSüd`ìýXêòi{«âÁy ÝxÐ§ø»0w¬½®·ÅAüf{=ÿUä;=¸V¬*ySó&·ø`TreÊ*âÏÍ®~qw¦³³ÝvKî]ù¼½~£ûÇüÌå?XÝyÎÏörË©hV{Ñ1£à|~ Ö0ô`FÄçx¤R ïUÀ	{ÍÍÎroEÊÉ_Ñ÷0öelÜ±&{ö¥óùIíäÖËÄû-1óÛ`t5ZþvÍ5Ïz:ÄmÝ0Y¶5õÏuû¼Í YuÕU#»øýûùÍ½~	ªìïÜÏ§²À\Îø9'¬øÀòK¬ó"IJé+ÎågUé¹ßß9ã¯úþ[æóæºL=Ý§ýtRîß³¥+YNºÁþÿ¸ÎþI)'©êeÆ_Åý¯Ç¼j¯e{iÛbËºûí¾w«³#fmõÑêû¨5çÁý8[ðÑ;n¯,aÀË9¶ÞnVa×U¿ùu³îÈïÝ¯Øæcëôû÷¡\Ø³+¥øµÿ_v:òÈ¢¤6Ugßùw
ÿ,g¾ý­oE ¢¿8ùä.Y/{ý`<÷þ±ýówXíú(>8ïRðB<8$þf{TaàyM{pÏq­ñçÜºò`øÓåÙh3£éª«®¢
¿iøìcã?j¯+Àr«ob³2-7"öØc¯=%bW<$°ìßO;µh*feÎø7Ùs¯¸ô'¶Ýz­fÓXÆ³¯­½d«i ÎÍ	â9Í?>þ/ÀïÆól_;­1'üåÚL_cïÔâî²¿ÝË¾öÕ¯Æg#Í~[UõÿC«ßq^þ~W­Æûý]Åï*¿¥¹èJ='þÞ6¡áòQg
{Ûü½cpá`ÂM¨3G	ñÀBüEø%<~L±jì~ñ/CþêòþS9ÅNvd[mìH§hGþ9õ#>~ ähÃç@Nýòºt­Û¶dÝÒ¤ J¨)*]
 h´!á´©sP|ZW%$;©¬dÔÇD0dTW%ò*©ë¼ü·ýÐ·F=JaJÈB²IÜDþUÇ2¢´-Ò¥DVþ1s@È¤6ä?õ[ù#ã­è4mXpê\Ê× °©d¤ýÔPÕ¹¸ä¯X¦vÔ§Ä¢¯CIOô$'=xÔ9§bméY5ÚGP-õ%;ð¨$«¶äÒ6>ä»ª/iõA0§dxéðxôðO»Òß,Å§%aO>å8cvAÏÏ3àð4Ë@W¹fúÎ÷x<Ïg`öØÍ9þ¨sËÍáÇïÈ	XXq9{k.áðx<Ug 6c¥¬&Ú¡©ðà)î h&_ äÔG?>¡·R[È`²`xm­YÅzä:vÁ.äð¯X¡-=ä!ÚòRöÑÁú²òA»_6è
F<
RÀ(%
}ñ­ZOz:FÙÁ?º´©cC~åC}²k"QyùAVþÑ§=¨Y]@ýÔe»ÔeRqY5òÈ-m/eSâ<ÏgÀ3àðx<ÏgÀ3àðx<ÏgÀ3°àg`Åz+F5ÂF:ÑÞæCà [ `AÀX¦²(GyYxàÔáá/Ù_vÁU éÈ¯ðäÁ9R»ÒmäÁD¤O>üÃà¥ñ
sÁdáAâ§ö¬ì)nô b+MÏ%'KJ'°>uõ¥V¿|¤ÉKýÓÏA?%ö¹¦©´!t¨+~bh§INûS]øôñ	Ñ§C3çôäud ù®úÈÁGs°¥,§úR
'ÏgÀ3àðx<ÏgÀ3àðx<ÏgÀ3àð,Ø¨í1wr¢ s`oÛv Q dR¼>Ú`:)è_mêôK6ua êÇ?Kcm@òÑÖjó¥>xØ}l@ðä?2ì~Ð§:%$}tµÌ¦r
KÑ·ÏO÷åéæ§sè±z<ÏgÀ3àðx<ÏgÀ3àðx<yÚ¹Ã,	vðìüDu0ÌAmêÂ9(ç@VÀ0
Êbv á4ØöA¢0ùÄuúdÂX¡
?<t£ð´]b·ÿçùpÆß3Þáròx<óo6Ùd°ë®»Æ\sÍ5á¡ê6ùÊ¿z,¶XxíÕWÃÙçõ½Ûj!dùåm¾yxï½÷ÂÝwßÞxã8öÐ×[o½°×^{ÅAN2%yÖYÝbÀÚýnË-·}úô	K,±D¼§<ûì³aìØ±áæ[n	ÿý/?ËS®~sËÞãðx<ÏgÀ3àð,¬¨Í;ÜÆ?Þ×í S ÔRiÕH`üÓ¢\T§ä!5XôhKºðñ%/|ÃD¢®ÚêÇÄCqùû#û´Syá?ô£Gþ©Ë<á4ôAðä;ðÚÈ·÷§xÔÊË¿©FMd±'RN(S¾ú»\*.+4TèJ«$jPêSðÈkðÒEyJé«Xá¡¯#¡¨ìáYù§Nò¦YµF[²i{òÏ ÿiIôË¿b£
k¬±Fì3fL8oÔ¨rÎÿ3 uÐAÅÜ{ß}áÒK/ç:òÈ#ÃZÃ7cÜ¸qá/¯¿ÎÿÁ)W¿£Eçx<ÏgÀ3àðx<j3æ¶\L¶ãm;À9 °AMP'|0úÐ&R?uõSG~JHýØ§ÎÉ&uù§.0ùMéÑaO±ÓVÔ!úì@²<2à)Ú²I²«:e1cEBVÖÅër\RÀØQÐÅA)È(ùÔ!
^e êOºH,j«^JiâÐ &ÿð8 ºRD~éJ¶âj'<duX5m}ùG6=¹ðC@ZjºÚÒ¡T<SròG[±,eõ~¾Çe¡Ò_ùPX¬§,ÃyKxk¦>×|Ð6ÂS6Ãîþ§¦Ö¿uÐáÜÏL}³ÎógÀ3àWp`n^e~áó»ß~û­lAèÖ[o
ÇsL:uj8ùSÎÌÍÕ¯;ógÀ3àðx<ÏgÀ3à(d ÷+ËÏ;ã0c³sà`
ÅÐð!ñáÏ!ÜA|õQBÂWdyx´Á3fÖJõ«4v´­¶JÙ¥M]þàé pÚÔ|ü§ña>¥ìÊøiibídiCÈÐlÊ?ü,R9F,i
VT°äKÁk`ÈË 	V[6¥«äªDWòÈJÛôS6"Å%ÕzÈAòIMJìs /}â¡-ÿE}ë$È¢¨({ú©Ï¥­=pÿÃ:ÚË>u7:ÿË;%k;íGüê.ï-7êBÏÅ
Ì²sø¹ï"#^i¥¢·^zi.zuWs;Ý	càÛR¸,Ë¾'tRxÿ}ý$oËÌ§?ýépÅcx¢Cªrõ;tgÀ3àðx<ÏgÀ3àH2Ð{^áòQgi)Ë·¬
âðÕ_W? &!PM@rÒ¥TÛª{A}á0´W¨ê«.;ò/ÜS"+lÄª±tä©K)Õ7v?¥øèañkòoÕX§êè £x°	¯4a(Ò`d SRQ'hOIH¤ºu×§ÁÃÃ/vdyHñÇ¬¥N¥tÔo¬/> üýÈ?%ú²aÕº,utñQG^11~ú¤«~cEªÌ±åÅ¾eÌQ·ûó#6	CW]>ÆuÒèÃã§u)Fs~`ÜÔ0|µåÃKôÓßxÇÁ9%ÆKÏg`eÀ¹yzwìX`3Ð¹e]6|çÛß¹8qb8íh)ï¹ú-9saÏgÀ3àðx<Ïg`¡Ë@m)ËCmàì`5p¸o k Ï R<ä!pêð)ÅOzj#_<õðÆ¬üËÔuù'6Õ%ôÑ)µñÉÿ¢ðâ®¢~ù¤Ö­m(>ÈþÅïr¦ËJAlè`²I $ ÓA§múEJ møØÁ¬_ýV­û¯>>ã gÕz<E;ôÁ¿Ø(ò4.ñUÂ×	§¸åßXuHädR¹À?ýð¥­qÌ
ñBfû>?>.ÿÔÞòÓò½zEW^y%p`k­áÃC/³õÖáYmÜ¸qá­·x1¤1-½ôÒQ1-¾ÄqÏÞ$Ëyí]tÑ°ækÚª+Æ-²È"aýÙgyyçw:SÏîÃ>}Â*«¬Zj©¸ÍT;GFNrÎ~¸n ç>4#9§³-üaÏÆ±Ô´iíTîg	ï½Çí·rÆ/¹ç¿Ìùëe×<GffL¶½:£þýúØ5ÙYr®|:40 Æ4Å®»'ísÏµ·ÕV[}÷Ù'7êüóÃ#<ÒY¨Y}Ïþýûízã;Ù>»|~]ö2dHl÷/®o>?Ü7^|ñÅNã*sþ0XÕõWöþ*çüç^ÿi­Öùþ!EzõÕWÃôé¯PUþ¾»Ò®úþÙê÷gz_ìì¾Êï³ªïß®ä,iÌ-¹äaÝúÛ}è5;ÿÏØ÷/¿cÞ~ZÚS:®2ãïi{òq
;è  T$:}ûö­w]zé¥áÞ`÷Óü$êÔzÚiáøD<hP]
ÀÁUW]îøç?ÛñÕàÙÇ?ö±°Î:ëÔAEõ±¥ïF_rIÓë;ï´SØm·Ý¢ÊõÿøGø¯ùÛe]:çµ×^ýùÏá±ÇùX2î½öÜ3li{õè¡Í,	öüèÑ£?k­µV8ð T#´¼êê«ÃwÞÙ¨;7Ü Èöß?,¿|Û¬Ë¢A¿üå/áàBÎù;ì°ÃÂzØBWÛøn½í¶¢ëØÞÇ@m¶Þ:Öÿlù¿û{ÊµÊ`_ûÜç¢Ú=÷Þ.»ì²&>øà°ÑÆ¾þìgíÖç_ÎrÏÙó÷õ¯}­HüêW¿jx~ÆßýÎwb¸\Ë(ÌæÈ½þy8=bÄ°ÊÊ++%õûÇÃ?\ÿ|Î)`òÀkÖáÂýY,]tQã)0÷ëßü&>\K	 ÷k®	·Ý~{Ê®×Ë?TqýåÜ¿!÷üç^ÿÄC'pBX¹¤vº²Ç\ùO}¶R¯êþYöû³û'ãÍýþm%g©l{Û^~ÙiÇ~ï_|ñÅñET?wüÃì^óéO}*5Ù´~Ýu×n¼±]®¾å~~sÏß¼þü+^z<ÏgÀ3àðx<Í3Pæ>nía8ø0°6ÄbjÂ4èýà3³é³'ØDNzÂkÚ~ÏâÓVt±%ÿV­ã*òO¿bxèË%<ÅOYù_úÖeéG/²täYøòOâa[:V-OÌ%§ ñ¡ÀÓq È?²ª7J&}J(¶°CäÄÂ§dW²[ü[5úÄ6r	]x]úàËü«î»§8d=ÿºhÓúUìðä_±)§èa¿§ým¹}9RÒ=éàí·TîUÔþõØaü¯×fÌ~¶ÞºW»oÜ¯nC·f¾~|ñaì3íßØ¦íµ×ÀÂÃ7ÇgØ3Þ¾/vÔþÐ¡=àfôs: øÌT[ÍfÕ5£ßüö·qYÚ#
ú5¢ÏxÆL*èÔSO3ÉµÊÃ&¶¡Î¹O}òõë«Ìå¿¹ç?çü¥çí]iàw#Z½õ"pFà) ªÏ_ÎõÏL­/~áa	aÚ:ßfÌ=\ñ9f{Ì1A{5T9²Ý=HÀY^.`³í/L4©]wÎùÃPîõ{ÿÎ=ÿ¹×»dl°`£"ºÌåæ¿dÈQ­ûgÎ÷g÷Oóý¿Ày~·ð(wü­ kWØ1ÅsrõGîç9ç¯;|þgÀ3àðx<ÏgÀ3ÐyV´=æ®uÖhÀØ¸¸8	Ø0	ð´nÍz?}èAèPçà¡2:²³Á(à	+A=üSt Ê´<øØ£OêØdðáñÑ/ÿôË?uüôé$'Û)üS%$ÿÄ&»ðh&PÚ)bC	¢Ô!JE^.èHyÉ)	i:D2Rÿð<êØ¡_I
3Þu/øìg>V_}õèîúë¯ou#Ë9 ; :è®»îõY¢.%=Ø %cÇË)2Ù,Ð>.²7×S:è£
àÈ
oö tÑ£O8p
qÄ¡õ×_?ê°\åm
`®Õëà«8ÿ9ç¥<y 
A¯Hò/ØÃð
×µFöÚÛá;çß^zå­8e¡âC{xéL¼Îº,Rú`ù'Üa3ä·=ØXúá~Xvú¦½aÞËÞ4Î±Tì#×ØNËD±äOúÓvbé%Óûß_ÿº]³ÆGl«m·Ù&v³ôÝý<ÐPt­·Ë¥Ñù[êò_¶D¦½¾ðùÏÇsâ±WËv²$&õ¹IìµÅÁ,AÀPöýÛñCa°Ô&K^rÎl¤Ëé¥3 ¿k@@Yf±aU4xðàp-cñ;þªÏ«ç%BÉ1Ë¢ñYg©¶©S§ÖSüI[^mxmÿÆßýþ÷aòäÉõ¾ÜëÿS¯YÌùÌñÙkD ·Zò­J`n]MËr»PqïÈFq4â¥À{0²GeÒYþìU×Z=9×³`sîß¹çT}ý7ËkWù9À\«ß_]ivreï¹ßUÜ?[ÙïßÙåevý)0Ç=ó×¸Gq¯ î ð ªÆ­2Àz¢2úU|~ñsþºÛç_ùôÒ3àðx<ÏgÀ3àhÞ¶Ðå£Î<Ä¸ìà¡,øuá,´E h© 5ô¥«RØEª#]ÉcWþÀ.¤K,þSRðÁ¶ðÚlëIuäHòôð+Yx[yIÛøQÙxÈH^Ëó\
½l)Ë³XÊr¢,wæ 	<Ö O<êÂ)èÀ'DÒÇpõÓ¦ÎÃjJì!'Ô¥oÕØO)ä©ç ê©-ÚýúÔåüÃKëÈBðð	¦.þÓ~xÈIVucEúÑá(Æ\Kª(6e[¥¤Â'	é	Ç(WbÑáOò(éC<uø²A=HöRøOO0}"lÈ%}ØÂu@«ÖùÔáCÈèv¨ë¢CVuÅ©ÿò!=Ù¡@$¥ì`ÆÜS§5^*ÐúæÃpñì¸~ßpðöCÂ
Ë°Âi½mKU¾m\øÛ½Ã{ïs4§í¶Ý6ì½÷ÞQày{hÅ,9ÞÆg×¸ñãã~díó`9Ý{ª³nÛm·]Ø{¯½bS¦Lûh¥#*û`iv{î±G4Åò,SYx8ÎEìÜÚfíe±øä7n\Q´TÙBÌ&NXn´Ñ¬Æmí¤vç0Ç~_ûêWã8ù £e,ï¿ÿþ0úKJ±3%ö-ãÒ%4:ìÃÅ~\Ð æÊÿ*ÎÆº-ey-i	=fÀì¶ì¬>×Ås.Üëÿ0[¾t=[Æºü+Â]wÝ%Óõëþ;ßþvÜgfÀÜðáÃÃ'<2ú0g9ÍF×hòGàF`®ósÿdH9÷ïÜó¯½þ¥_e9¿seî¹ßUÜ?9we¿sÏ{
Ìu¶·lzM¤{ÌU5~ÆQXKÇ_F¿ªÏoîùëNÿ4§^÷x<ÏgÀ3àðxfe ¶åãL²ãu;x¤Ìc0ºøðÀ pp]d lò>6ÒÓÔááìË?¥üc~á3Vúz«>ñeÿ©oú!ùÇ²à+ïØ¤8/>ðG?}´)á)Ú»è¿Q,&Þ5Âp.) l¥TÁSR¹tðÔIXª¼d¨ËFlù]Úè\õ).dÉÉ§t/|N&|êØ¬ÚòA	ÁÇmÆC]mé+ö§cFFþ©KVc¡­~âcÆÜÀ?êÂ©/·ßÇøNói8É'jó0°Ï2õ0ëÖ1/Q7>^yS÷ÖzwÃf³0«ÛØhö ¥Ëûì³OØfë­£Yö~aÆËíÛdÆo»kæÙÿügøë_ÿÚ.²Ö¶dì£± Kq6Û'«Ã¤!Ð}ï¡Ö;ì°°ÞºëÆ®Kl¹­ûlÙ­*(]"e¼XÎ«H=zô_:þøÀCH¨Òä¿¢¯OÚ^\Ãk{q±g¡³Ï9';¶(ÝNsã¼ôt fÖ°}î>SÛçUs9ç¿ó§$23 ½!!*@1ÊÿâöEC&÷úç³Ëgj´üµÖZ+ùOPTå¦ÿïÚç±C>ôP¸è¢b½øÏù(w9À\ç/÷ósÿÎ=ÿä8çú/£*Ú)së­·Æ»ÙÍÍg¶[íkõþûýYÅý1ýþm5?Eù£ßÌ-Òç>÷¹0pÀÈ¾Î¡¾Á£ª?¶Ê kèÊèWñùÅÎùënåÓKÏgÀ3àðx<Ïg }zÛj^wKYN¶}ÀÀ8 ðH@êàÈÐÏÁãèÀ£M¿ô¨Ã=ø/yÚ)É¶ì GÿìPOBä T¶Æ¥xä_ØÚÈ*&êðÖ±#_~eOñÁ½´T?ú¥HK)×l#J2i×`èS²©CèRLZÒOèbÁ$OÉ§ýª+6ÉRBºP¨#£hË¾üÓNÉP">ñjL©¬ú¬»k±x sý8Üö³}t,ºÈÂÅ_Û±>'}%sýØðäs¯Õy]©pÂ	aå>}¢è#¶  ÊtUXö°%ÕlùÆ,1õùã«Ï&k´À  @ßýþ÷q6_dÔþ}°ÄÃú/Ûøú± WqÉ?¼bvË32PÄ=f-ðPYp#Ï=7.Û¨~Jãl«¬¼rdm³ÚÆÚl¦*(n¿ãpåW¶3Ë¾/ì3¶u
`Æ¹ôM[®±W
W¿ûwîùÏ½þë'¨ÂÊüÌµzÿ¬âû3÷þÉ©+ûý{ÚÀ\£ïàmmÍØw èöòÍ¶®¨ñc«°¦Êêç~~å¿ìù«úóÏa{|øÃq?RfÀsç)'ÏgÀ3àðx<Ïg ?µs sí`9°°0:Ä<ú3>T!§|iö]È¦ì¦zÈBØ$CØÉ/»ðá5*%cÝuJyèp¤øýð(ñÏXT·jºdÕG;~JØ*MÏ%@'%{ t¨ÙcéÉ¶f=ÑÔ¤§NI¤p0 õ¬B)]-©øÒÄX}vuéQ"§ØicÂ7mù×ØÓqÀäÐQ¿ü«]ìàÓ&^ù§;PO;úÙs£§ù¹á¹_;\póSáG/5,Zñðª3TyôÑGo³dTJ9ÀvØã
»ï¶[Ô`Æã
ç «(;Èøô	«É¦ìÓÞ¡8°õ«6qÑ
p
[´§?Õ|êÈQVaÕhC t)9ÐO«Öë©=pìBE=é§ò²Û¦1ÿÑÌ46êÈ'û²]ü+Føôä?W?¥ä©·L
ªeÅDAÁëäPBÆök:ùZ2V¤èÂP?%¤6rÄÚGGÀUcRàârÔpÙ'FtñÚ´f;²C)ÙBVþT>ýøæ@G¶Ô6VQcfm½û~ÔÓ^û3Æ©{fàë_ûZ\æèXnñ&
do¹íl9ReQG{îÂ±g`.eÀïßs)ÑsÀß?ç@RÝ¤gÀ3àðx<ÏgÀ3àð4Ì@mÆÜ¡Ö9Á9°pá
Êbv á4ØöA¢0ùÄuúdÂX¡
Õ,¨¨®-PKàäi©{PkÐ¾zðÖ/«o}#Tj[ûZcúD¿äK}ë?cÇñáõÌ:5dÆ§Å2ì 2ù8VêÄjOtñ'	m)w¼ïÖ$ú6è¡(D'åÉ£ïäµE}Zí#WdØ;qtË9tÛ §?b¡k|xÀ³l'¾º%?ã£kü²'ãÆ77úñYù6#8Ý<>¿UbÅÜÉ¹bN²MD HD HD HD HD H6]FWÌ=?f¸<Ûã ÎAËµ	xdÖ'Y#akÈ!ÇáGqZÈqüÃs@ú7><¶Ö\¥OíðgîôÍb]ããÒ?úèPOìë>1õ+OÛKjBW*ye}·hJ&î`¢#øðH[ø2?| ¤2úú¢5¶ÀÛ2øúÕF?1T©C¿Û}O0~!ýÓêÞq}dä/xHY¹%>¾°Á8±bn^¬;5WÌI@"$@"$@"$@"$@"$À&Àhaî¨æÒ8\1GíÚ5xj
Ö/ÊqdÔ hÃ»:M}úÈñYúzêÒBÆ7>-µûø7~°õ¸ñº}ê}m±Ñ¾iËDËa}PéÎúø*uàí£34á¤)9i|¼e")' ïÉÅ¾<v%ÀagAÍøÈ8(tYÆµU¾yõÊºÁÖDÂÞøè'9yXH+ýÃÛ×Ö|ÌS=ãÑ7m·1=cnÖ¬ÙÕVÓ§Wwß}wuÝµ×DúýÑ[nYm¶÷»ßÕfmVÝqÇíÕ
yXWqÜôK>ºµó³EGê¯¼ï¶LßF]øð`ú$QÀ ÉrÒeqI è#Ç>°'¹ãÁvb#÷âCNLô8,ÈÛÉ§ÛcÈÝ2ç¥Ü¹'y?D²Èzú¡â3]úÎj×îQ;e*æ¶³C5÷âÚÔOanëm¶©ï½o½Rî{îÕqU«V®¨6ß|ójÎ;U»ì:·vÌ¶¬¾»ë.Nýj§äD HD HD HD HD H©ÀhaîèÈfI<cµ	jÖ¨1 £å@nµ	xn°3É£W«ìÔ¡5¦5ãè×øø0¾:ÈÔGÆ¶ÎÓÈµAOâã×Ã~?c¹àKßÄ×·¹¨G)/ý©×wkÐ¾
sÔ&¨;P7° fMë%Ýºö`­;z<õ	Æõ;â FÌZ	:Øúñ½¡O[òès(Ç}bÂãÇøè"¾uã3n|xâ[ÿ1·Õ±ÐÓ7<zÆT2>¹©þÐdC;C|­>ÉdÑ÷t}`£=úê	BÙ £LðàñÃ¸ é¾`ê=D¿´ÃÙW]H}ìOk^È_Î;ÉøÄéö·²<u*®seÛoal³Í6«<èàzÛÊÕ«o©.ºà¼ÒM_¼÷~Ï¯)ÞÙÇô<û'@"$@"$@"$@"$@"$Àè¹DËâ¸=D¥J*ûÔ¨3 k½ÁÚ2m±cÌ:u
Qú*'h{'\VêâW_Áv UÿÆGO9¼+ïíÄw.¶Î¶Ì]suå28e,õÕt½]æH|Hs'mj9#GaÝêÕ«£0wîÈÌ»þÎÛ}a5'eýûßUwßíë¼Kq´¹Þ¸¤4HD HD HD HD HD`ã@ X1·$2^=µunSC°¸ÜªðÊhÑEF­:2È>2ýZßÀ®¯Oüao}Ã¶ø·
(cèxÂú¶ðØéßVõj'¾þ§y©a¯¾}Zã;¦ñõÂÜüxÆÜ&·b x>Ýô­·ÕpwÄVgÆÒÎ»Ì­vÙun-¼ø¢âyv7Uèêea®ì&@"$@"$@"$@"$@"lT®;:^9¶¤~@¢¼nV9õô¤rLxZíh-x9¢[AqH¥ßÒ':e.æß­ë'¥ò²þ.>Ð±×6Ø£¾}Hb2"ð¯Î4£îÉÖ}*AÑ1	uaÏáÄàõc4D59fÍÁ àÀú#FþùÈc¾}|+àÓyÁ{ÒáyáCækòÚññc|tµÙ:øEñ¹7ÅgÌí6÷jv)VÕW,¯®¹úª÷«é,Ü£ÚnÖìZté.ªn¼ñ{¶Yë	K
D HD HD HD HD H6æÌ]~â'ÝÊÂ5jÔà9¬³ÐÒ( zÔ°×ÖÖÚEi£­úø5µmiÑ%~Iæ|[ÿ¡éÃZOicdúÖTW]úæ-.e8æiØèOeè¨l`"xSÒI;±²à¤¬(ì_° ºø|Æõc¢¤2¾'=Æômúbâ1´SFknøÑ>ôlÇ9zúîÖGWB¸[¶èCÆÇñÑÇ?¹±bnÛÊ2æUÍ¹mµhÏÅõv÷Þ{ouÝu×T«V¬¨à·>½Úi§ãùr3P­çÐñ<º(s¡c@"$@"$@"$@"$@"$SÑsGFKãàsÔ(pAÔ<¨#0fÝBÆ
;j
së¢&ñ×å;ÇD HD HD HD HD HõÀèVGEeqÜõê
Ô\ êðÊYS¡.BÝ¡¬Ï0ÂVÔ1hã^·nL;ýÖøøc]|B#G®OtËØCÆWú
Ûëþ±5_bXA>-6æBß¼»ã÷Ê%Ôû#7%ÂÉ,­c$zåäá¬´G_x}`C¿ô±\ÇÌ^zÆÔÆ|sâÃãO]ûÆ >ó·¯MêñrÎè^]çBßqòcÅÜ#9ö«®vêSÛ±¿(ÔÞÙë £ûíÕùçµNýTHD HD HD HD HD H¦s¶ß¾:ý`+ËåqÜ5ëÁvIÔ6¨+@Ö9Ð£¾`¥,à¡Ë¸vÖ)Ðl®úôKÒ·~Ð3>zú/èA¥}òÌÇøÖfì£cNðÈÑAVòæâZn\ýrý­ãØEÊxÔÈd{ù0t8JÐw2	6<-¼:eË8}  Xe`k¹­rk%àØs@æ®Tòèãæc|ýÙªCöÄwNêÑ:l­ÂNÈ(ÌÍ;âxÆÜªMÅ\=óâ+åí¹¸\sõÕW\^öf³0×&@"$@"$@"$@"$@"l®£0·41G
`%Y¨B¨lñ?kúÔoig

­¶ni~%°¡ÖYÝ¯-zæN?±éß¹ó@f|ô°qÜøöñ?	9}ò5>cø¦Ç1/1÷Å÷ÁsöX\m»Ýv5wNloykÍOô's¡c@"$@"$@"$@"$@"$S9³gÇ3æ>iaîöÈm­CXw ¶`ÝÄ:2Zz
m¡¬ÏPà PÊä©UP§°°E}ÆK;uÃ£o­"ØÚE0mi9°1f°¾ôG¿P·ö¥¾~G,ÖÔ?Tæ¾2ýë¿Ä7GävÆ/õ§U~`2©
±ðQÖTðcÚko}[Ï|ÐbSÚ£6ú

YRYï`>5²èÜ><ãÚÓ·â8ñÙÚdÞH,ÇáBOÿø¿Äâ`Ï<-¤=¶n³)øçÀõ>~é3®®ó
QG¦=c@MH	E$&UN>Ô=QäNÃIÂ#}Tn¬î1ó°Èf|¥5>:ô!ìè?qJbÌÖÜ´G/£qÐqßæßmOß±!Æ}æs1×¤D HD HD HD HD HDà>Àè¹£%qP£ö@ýÄ<5}xë´ès kaËm÷~ ë4ø°öÑGÏ1ÏÁþaúãÖOÌßxÔKôe|ú>Ð£u>1hGk,ãvÆ/ýøbìàD¦ääLeâô¬ºNØV['IbÄ¤íÓ6y2aZH}|Ás:øR/úÚÒª«²Å'6Öô¡¬ù9`;>©Gçb|Æl=OâÌ­,O]±rò¤D HD HD HD HD HD Ø}Æ+æ.cu¬5õj¶ÔÔqgAÇb¨ÖeµxjÊ>rk ð¼u|p@ÆÀ:ø²hI;sÅ¦ôSöÍÂ7ãôõk¢zL_ê"GGæªò@f¿;¾þBep2èàk,ÊñGB¥	¨}'dè0¦¾DQË«còi[ÆÐaÜ±²e*ÇíÃÕlú²EÞ©OO­ºDdP©KØÆ§Ñ­:Û?ÿðØÊrene	FI@"$@"$@"$@"$@"$À&Àè9s·Åd©=Pp£AýÀZ-rëðÔ4 äÔ,ÂiÃ5ÇY¡
2ãÓâvPÏ|+õ?bµÆ'ºøÄ¶;Þwk}ôPÊ
¢rÌäÑwòÚ¢>­ö+2ì8ºåºmÐÓ±Ð5><àYL¶ÎÇK_ÝÇñÑ5~ÙÂqã}Èø¬|JÉHnÄß*E±bîä\1'DÙ&@"$@"$@"$@"$@"$.£+æ3\ÇíqPç e
<5ëå82j´Èá]¦>}äø,	}=ui!ãÃZ}|Â?ØzÜxÝ>õ¾¶ØèOßÈ´e¢å°¾¨ôç}|:ðöÑpÒ4¾LÞ2ÇËwäb_»Jà°³ f|dºÊ,ãÚªKß¼zå]`k¢ao|tË<,¤þáíkCk>æ©ñèË6ÁÏËgÌ
I@"$@"$@"$@"$@"$À} 9Ûo_þOS½$VÌQ ¦`a)ØCÊÑá@ÎaÝA¹c´õý >õ;G[ÇmC\û¶o«_úðÆGBæA=ë(ôárâùá9­~¡¼lCm.}	{ããÓøÈ	6qbaÉI¬4YOÆ2y'¾¾(j°}}j+¸¶Øª®vøæ`¶1h-ªvèAÆ¤Å'-þ9Ð×|è¿Û>jÒºØSTÔ-}óþÑ_pø1Ç´rÕõ'%@"$?øÁÕ¡ZÇúÎw¾Syæ$î}1ÈvÛn[ýÑCZÝ}÷ÝÕ/~ñê[nt9ÿÿú?Èü7ôÉâuI~½èÇ?þquÆgôjMö·¯}µÅ[V7ÝxcõéÏ|¦ºí¶ÛZó½¾í´ÓNÕ_üâNN8¡~Ýu³1ã¿À)&ëãýoCùoH´3V"$ÀÆÀÙ³ªÓOü[YòÅD-ú¼õêÔÐ¥&aQÍBzÚÒÚ¶®½ ½uúÖ+äK{yýßº	6Ô<hÑµ6lÝÇN[æ¢>¼vØ8§Ò>Äõüic?Zæï<hlÍÓtÌÈ&5¥2}dIö¤M  ÉÇp<'¸øÑ'úùtÏ
yXWqÜôK>ºµó³EGê¯¼ï¶LßF]øð`ú$QÀ ÉrÒeqI è#Ç>°'¹ãÁvb#÷âCNLô8,ÈÛÉ§ÛcÈÝ2ç¥Ü¹'y?D²Èzú¡â3]úÎÂÜîQ;eªæ¶ÝnVµë®»UÓ·Þ:Rµµ·ß^îY5¿®?;ì¸s5w·Ý¢ 'L#wß}WuÅåË«+®×Å[lYÍÛ}Aµí¶ÛÕ½nE
s]¶´º½Å_ssSçÕ¯zU'Þ§?ýéêÂ.ê]÷§GòMo|cµÕV[Õý|ä#ÕÒeËzê¦ð¾À6ÛlSÍ7¯âü³fÏ®¾õ­oU÷ÜÃ¿¤D`ò((%­;î¸jëx¿n¾ùæêÇ¿~
\¡Ï~îsÕùç?Æõýîw¿êïßðXÍ·m-ÿÌg?[]pÁct²À3ñêQ|d
4èùìüÛ?èü'óea®ô³0×?V©$m¿ÿmèYßWóÏïúJËx@"llÏûÚ:*²_9jÔ¨X ³&A}¡ä£[×¬u`QçàÆ6ãúÄÇqP£@f­ìO}ÄøØ@´%>rüÑ'&<~± â[1>ãÆ'>¹hÏ¤¾K¹sÐFZÈøä¦2úC	í ñ!@´ú$EßCÐõöè«'e2>2ÁÇã¦ú©/ô ZN2:ýÒÿe_}t!õ±7>­y!7~9Oì$ã§Û~ÜÊòÔ©¸bnZlÏ¸Ï¾D1ìæêÆ¯ãj¯ÅûÖÏé§0·ëÜÝªvÞµÆbù²¥ÕcoFÎ7¿Ú1¶¹®¾êÊêª+/¯yþ°ÒnÁÂ=êþÍ±]åK.^ëyt[NVí»ßu¡âÞÙ¿ÿmÇ¾
ÔÐµÞ`íA¶Ø1fÄº­ºø¡¾=úælÝ7¾¾ÐÇúñIÈ¯L}Z}8f|ë-Øs@æUÆÁ2>¼ñµ³Ï¶Ä1¾>4ñ¨Ñe2$mN Æ À(ÁB(}´
½.A+uñ«¯`;ªã£§jªdúÎÅÖ¹Ðù¢k®ø*}§¥râÝs1£.¾icaî¤©XIuìßý|`ß¹=ïSÍ1³ºóÎ;«sÏþ}8*á°¢°¶ßÕnºéÆê/lØBsç]v­.m*Y1×ÁØ¹gYÇê¥7_÷½îµ¯­Øîó¯Î;ï¼«×ÆØ.±²:õ´Óªßýîw±nfÎ9Õ¢EªÙñ|1.¸ñÜK/½4+ºUë>Øì²Ë.5ÏóV®\¹N½Ë/¿|­âeO£!Ûo¿}5þüjûgrylñÉ6¬`XYÈ³Õ+Ûë®«®æxD¼3fÔçT=0\¸pa-;sõÕWç¢9ùï³Ï>ÕÈÕ¬¢¼.b_qÅuþ½æÏO°þä)O©öÜsÏºû½ï}¯ºèâªÛËG¶híEÃâ§/U´×^{U{và	îÄûõ¯]«xàÕ¼x$sûá~TõZÍsÿØÊv¿}÷­8'ìÑ¹*Îç¼¼ßF;èëÇÛÅ¶5«îÞpÃ
¹=öØ£Zï¿¼ó>ÂÿÍk®¹Æ;mø5¹þû-ÌÍ;·~>ðM7ÝT­^½º>:á9|väs¯[&rU~V þ?C½1×/þÝñyÿnwüAû\_|n®ºêªq?cÎ9³þL½.½Aß¿Ú¸~Éi²>»8ý~~Jóæów÷Ü=ÿÚOöùkãý¯
sôTGÄ{»ïß÷ñÿä'å4â>úèêñc~°óo}kÏÏ¥c
yÇtægV§Äg)¨,Ì
sMóozþç°ù7ÌEoóLÍðºpL,"Ü/iØøøh2ÿ6^¿M¯ßøÉ*ÌñÇcv/VwçÆg-[Ö·_ë]¹Ç<æ1õNLø?øAõ½ïßn£ö°Ã«ý¨GÕ>þõýï¯W|Ñá3ä«^õªê~ñ¾Êû¬WXB!ú¯øñ? ,Ì
vbÿóÿ¼¾)îZÄ×ç¡Zó·ÜrKõÿñÕ¿ÿ}ÝçÕ/ÕÜT~çmR×y7V±åëÿ÷õdVì°"kù[ßþvEÁ¤
èäøq-ÌÕñgü±iúþÝs¶euþßô¦Î>ß¥Eá¿[n¹eõÖüÇºeç·wÜÿ1MÞ¿ÊsÕäó÷d}þ &ß§ÂüË÷A?3ÿ&ç{h2Ïñ¼ÿ5ÅøM©IþùÿÇyßÿÌ÷+Þ·¤â;ðg>ó»Ù&@"l"®;2¦³41ÇÍso2SWð ÀuZ+ì¨5 £î ½6èpà9ºú ÏõÆ++mô:È,È!s,Ø:Æ9¼ômãmé3/¹:È°µ57|@ÆgÂyc2HGNVðH	ã[rÌ'1&Ù/'¬Zý,­ñô¡9j+èÆ"_yZôJÝèÖTÊÑãÀÖÂñÑB´äo|dÆ§'¼²Ò9±Ñ²ÂÜ&·eÌ«Úmþîñ«õ`«+¯X^]sõU5ïV¼-X¸G<jv-ºôÅ6
ÏßúØÇ?¾Ö3SÀæïßðZçüdgµU-?_¦/B«°ÓRa5¢«¯Þý÷Ù±übÆV+òDÚ;¶ÖäWÛbß&Å´:¨vÉv?é±ÍÅÕ'Gñêü`EÁg<:î¸ãêw\;oNýnE2,~ØJWçÅj¾Ï}îscR+¯¯oÇVdÿó?ÿ3fâé?¾å-µ=ÃâÕ%KÆè°M7ßùÊ|þùÝïnm+Õ¦¯í¾±Â*æR>Oï<þøêM±º­ÙÚ ßa_¿M®ÿ2>«Mß+XÙXRy}#gÅ'[[Bmá_;kðgØëMðkò¸¦-)fCæýÿ×ôü÷Ä ù³3|BlÓWÿ£¸ùÎ¯ÁYt|¼)>GÄo:ÿÒ~Ø×/óhrývã0¹^×ÛZ¾ô¯þªN­)¾Jmà×äõÛ«0Çg¶Ãc[m
¦ïkìvÀÚ$/÷·¯}íò3Î¨þãë_¯ùÇ?îqÕÞ\å³ Åñü×c=¶æÙ9Àgæ¹Añoãý»	þõdþ9ìéOïüðéñ0¶.múØ:?vøìg?ÛnúþÕÆõK2õùØM>¿OùOýüÝôü4ço$5yÿÃª	~k¢¶Ç
éßøÆÂÏÛ}SÜÊÏ¹mµhÏÅu÷×]wMµjÅú&þV±=àN;íÏjM<çÑõCÛÏÙ¡¿ûÂZywNÜÔãÊú!öÇüÇcssÕråM~Ê/E¬ðúô8¿n£°D	ú}¬F:ùSj¾­/Æµ³!þp³¦®ö æÑøÂ¿ï¥3ì	|½rñîå3#×ýl(+×ÀGU¼
vêS¿Ïs&svØ±7Ý	ÛóÎùý/Þã)sÃcñ>ûwFK\R]¿jåxê­Èyèòßý¿ÿW±ºFúïXeôXmÔÞøÆ7V³ÂúLüçÈõ"ÇvÛ!þÓ?ýSÍ/Z´¨zYl#	5ùÅ~í`?Æj>¶;ÚzöÅ;~MÎÓØÆ_ClYþz½üböNXëtØ¼&ÇM8èmo{ý<ÃºÓÂ3gV[rî%µC¡-áû!®×·¿ímµjyû±-uÁ/rlóõºé]®tìõ|g<ãÕ£ùÈÚ­KóÛßÖ|÷G>âõv;Èÿ=¶ºü¿Ø"²
Û9òÌ
óoòù»éù÷:¬ógü²äý»&øqÛâÍ*üÿ)ç>hþÚ¶õýøâÇ	¼$%@"lzneyTÌlYüzÿô©¹@Ôà#£¦ Q¡îÀ8zr<>©cÐ"ÇGùæ8vú7>­ññÇ8ºÆg9ä<r}¢[Æf2¾º´Ü¿#Ò?¶æKë3èsÐ§ÅÆ\èwwü^¹zã¦dBø"¥uäá¡R¯<<öè«¯lcè>6ëy¡ÓKÏÚ/rN<rxü©kß´râÑg>ðöµ	Q=^ÎãÃ«ë\è;N~¬[pÄ1Ç²bÕõÁN}´0Ç(Îí´ó.ñ\°­ÆLÂÌæoTÕYgþ¦óë1Eç~÷Û"+·OÜààñ|QÌ¹
µÐUW_]ýklWÕ/5Áïÿ÷õ3¸®(_ÏØæmV÷-´ ¶D¡øVR¹
æÄo:ÿ6^¿Ì¿Éõ}IUãúoÇ;ÊT:üxÏ¸m¿&×Yë$;Êð^ýoøÀZÛrwë5éÛ0òÃ®ru2¾ÝbÚÕ=l#Ì#$sÃàßÆûwüCÓÌâs®>ÜsÏ=+vP÷çÓ6Þ¿Ú¸~Ém²>4ýü>Uæ?Ìçï6Î?ç¬ó7}ìßAÞÿ´?mÛnÍ*üÿ)14m|ÿÓG¶@"$÷
t´Ö$hµS.dK<l´£_¾õñÑÓ<ñËÚ
²Ò>y@æc|ìÙGÇà£¬äÍ/Äclõg~Øé¯lÇ~(ÂYS2Ù^~ ôc
s¦OA`ÆúfõâÛn]]-X´gl´]]£07qscÏÅûÄ3É­_È®®.¾èê(<lÚ+n¼dôfÀÒ¥K«|ô£=Ã²R*7µ¸¹ÒøÅ/Û1Jÿ<¿².ß2+æô¤'UÆõz¾ùNÔòàl¶Úu]&Rëñ3w&ùÅiÿòÞ÷*Ó¿¨^9ñEÿÁ~p½åÔÂÇÄ§ÃsËØZÄgÃt+Ïèºé¶kßããWø¿Æ¸É
E?&IRo1ªçxt;@Ã[pÒÎNËÀáiqñÑZmÝÒø%°¡ÖYÝ¯-zæN?±éß¹ó@f|ô°qÜøöñ?	9}ò5>cøØ×f^<cî+7ásõLÇùÓ)ôÅóÚÎ?ïìq´Àø¾G<¯îþön¿ý¶êâÏ¯W®kÔò@ù+Ý%Qûè89ÂzSgëð^Tú¤ Ga¢ ôò½¬æÏ:ûìê¤Nªùî?¯ú¿é¬æbßõqÃ©
GÞ§ÜÆò7¿ùMõÅ/}i­pMß¿Ú¸~Ij²>4ýü>Uæ?ìçï¦çßj²ÎñËv÷?íÅOû6ÛAó*ÿÄ`Ðüµæû¶Ù&@"Ü·]1÷57ÅoÃ4ê¬gÐçW¿ä£ôSêªãu
j>èÈ;F¾-¼úÆÇ¢/aYSrLô©__èHe_ÚÒ¢k|ó#¶ñÑ)}¿*Î³Z[»Wbø.'âäJ¹Â£`ãð*ÏÅe¼î¶ôã9Àcï!hÆÄN=íÁs§¹¨C_»`kÿèRT+cé¼¤®}õÊ>1_y-¼¯æí±¸Ú6¿]pÞ9±½å·×ÂøÃÍw3gn[î¢ÛWÞy'ü
Ü@¸ióÁ}¨^ÍTâÏc»Y£7 Ø¾ç
HÜä|ÙK_ÚÙÆy9üÏ¢ÿc¶úÖ·`;Ä
,½ôÕ
sdÀ3º¸!)±U%X÷Ú«³Rñ¯|õ«Õ/ùKUë:ÜÜÀéG±uEOzâ+cR«X×qSÿÏ£x¸ßèVKøåDge|)`ï|nð%"æ=á	O¨7 Vlý 
¸(ÂRxÂã_Í7¯÷ÏT*Ì±Må³õ,S«Wu\|ñÅÕ²eËêyóçÏ¯/^\Í3§ÖáYI¬+ñÞ1æÈx¶Í:¨qC`±ç{T{Äñ,7¶¶ÚÀ/rzä#kãýá¦ÖyçW}ïûß¯®ºêª1jÝ7Ãø"øxFÛµñL:¶O%o¶©ã:a.\´mQÓ×yLæ±¦¯ß¦7&Ø²­Û$^·gEuVlizp<'Ñk×ñÓ¾øÅê·¿]ó6ð×÷ m×SüÍ¹[ÿguJÅëÿÿyÝA÷Äÿö^Ï>lÓóß4ÿzr£7?T)écÿxuil©;5ßtþM^¿m\¿ÜÜvtûn0âÿ-ÿ!^Ël	*ÝïË¿ûÝïì¶Ò6)@ü°orýOTÃ7Û±jÍmÀyÿæQm~~*oä³üq?hñÂñÃ»#Üÿ¦ïßMðgNmñÿþ
å©F¬cE+ã&¢å-­(Úõ¢ð zåN¯±^²K/¹¸.þõkC6haÐ=ôÐ	Ã?"ÿõ¬¥Ã¬×½öµõM¤µC@ÁB7Ú¡Ç¯±Å¯éÚ$~©÷âØF¹ODmØêò²åËk5nxqã`ãE,
}æ?
säÏÝÄJ6n
MD·>E5nGÜTå¹(ãù¢ðÊ³Àxæ
søß+~õ/~qç½gÑ±¢­Ü½a©|N>ÊgÐò~ú±u%ÛC?Ïü8¦¤¦øã«ÉûwüËy´Å?1>K?¹ø,ÝÏçÝ&ï_M¯_æ=??ìçwl'sþm}þnrþÁ`2Ï_÷¿¶ða©IþÄìÿ?Mó/qôû_iÿ§<¥þ¦|y|Ïæ$I@"$£+æY-ÂµêÖ¨pc9²²ö`Ý;k£Wú°Ï~ðG>Ä8rkÈ°GÚ¡GÆ8°¡/ããúÀ_òæ¢ZÜøèak\íáBÃ¸èÚG¢¯òú¥ÐpÜÊ	2'HÁeðzNùÒv\±Ðurd^ðc|õ´'¾i×7-ruÊÀ ~Xd|Æ!Æúkgã3¦N°uVÌ-Ø1·Ï¾TÓãfÂêÕ·T]0ò&3±:nînó«éÓ©AÆ¤ïÍjûQ[¹rüíö?à jËÑçÒÔÆëøsñçÇÖ|7¯Ckøá²0×ëÎãyfU¿>õYjê±í!þó+Z«eË9ÂM$êÜØäyt÷Þ»ÞJ±N>¹:ë¬³Tk­åú¡OzRõ<¤ósSdK2¶ªì¾¡Å§=õ©Õ0¦ Eþ×ÆÜ)H²U":PwaÎí?X]ÂM­^T>/æÇ_ooÔKoX¿lgåß®sçV[^Ã¥¯óbÛ÷bÀ~¶qäìG~xµíèÖ¬ø³?ÄüzùhßÓ£¨øÑÕRÜðcu+-yr3pF\W;Æ68ðÀÎ¹é^1å<ÙèYñ¼2V8Rð<l«vÎ9ç(n½mòúy@lzôQGÕ9õ*<µlÃ&¯ß6®Î_êÿ|^$)²uÚcî]±­éQ£øP\enj·¯AúM®â´ß ùvëòçüÐNDãæÚÈ¿Éùo÷Ù¶ÿ#ÐxÏ-mÚßdþäÒäõÛôúeèãÿs?4Èç~ü¡Cáùóc ½Âÿ>ñì/®aÞ»CÚ¿&×?9æSnJáß(´EÎ÷ùãb;ërEýQ±U´Ð)ñ£¦3c}Imà¿aß¿Í}2?xð¹éÍozS-â%ï9árx\¾ÉûWë&ûó9ðtÏïØNöüÛøüÝäüOæùkãý¯
WØ+¶z9Gý[úðø0®1Óo¨Ôzè]ãcÏvÐx¼6Æáõ_xýÐW°5¡ÞýãØ¨¶²¬³â¿¦ wo|¨¼óÎ»âFÅôûñ<¾èB<ÛÕbýÒ3êgÝ«Ìøew[ö¿¾eu
9hõ^ÈkÄ3«?skÄ{Ü3æ¢æD èçüÕ{ÞÓÊ£L®Û¼"NÃq%§øö4×¤½êþ ã97ÝyfK?ßv$@"${(ìûÈ?þcóüÓs>óæ$#ÏãÚQk¹ÏýÒöÐÝeÙ@"$@"$À¶´;3VæG{?`À98g,ÏA=
úÖ5â ò4Äû`0ÇNÅä`LcÍøäcÁ9Â:±ÇùàKe~ævô®áGzóÑËüÖùëxæ ¿XÄp×½7gÑÄ«gîfµuÃöúºIæëè6í¾öaÍæ¡G´'cZmC,uÄb®/½¶Æ©{bâ±fuõ>¨Ï½Ä°#&:íÈã^ÌÏºùcØì<#¢qåE+VæÕ $½GàÙñ<§ßoÑøöùºõëË¾q­#×©pEòÛë¯/_|±ÓìD HD xRèê¿],ÿùsÎi®QW}"$@"$@"°§#Ðþ9NÌ-¶>[_ Á!ØÃ1hãÍ®ÅRcË::¸Æ| ùTÏÑË0VËcXØKÒ84E?kÅ§SÏ­!6ëÌkªfÍXÚ¢ÇÆÖjê@ç¼5¿ñÂd×Å¤»î¹Õ£.xTë³Auî¬ÖÔ3W µ|qµcÍ±kúÖ9#Ø°îZÝ³ÔëÎÉái6cÙcÃØÓ¾HôÚú"¢Cj[æä6?s9b~|µã)§ÄU+ó*K0JI>Bàè£*Ï
nÊ)H¸:<Ï:¼úê«ËO¯¼rgàÔv9ND HDàDàðÃ/¯}Ík:Çl.«|ÉW¾ÒS}"$@"$@"°7 Ð~bNbncì	îÂ
)@"$@"$@"$@"$@"$Àï cÇ)~ù³gÆVïÆ9x8¥6Q
®=¾Úc«±i¬Ów%ÖezI5ëÀ;ÄôÄ¤'>
¡p7¯©E3×Æ3g ÕX¡jìéYwÓ8Æ`±µ.Öc«¾5¾1c©%Ók­èñ15c§Cu¢ùÓ°Ç=¢=có³f1æÄÜ{
17jÔè2dèÐòè£å>À¾º%
ú¹O9º!ýÐÞÄÜ|ÞÜVr$@"$@"$@"$@"$@"Ð/h?1wf7?ÄWHÂÀCÀ'(Hôêá°Sê5ÇØ0¦×^ÂËõP5^N;ÖcÔqëØÔµX«
6Ú¢ÃæÆG4T¸&æÁ¢à×ÀÔömÚ~Öõ8Æ{çÄ®OÀ±f<êbìÎü/2côõ:'cýÄÅüÄ1?¶úðÀ¶ñ¹úû3æ¢ÎF8òèns³æZößDû¶Ã¿~9ãxáàÁåð¹G5q×®]Sî½ûÎ¶$Ýü9sö!eD\µÜ}çíe]y×Í0i$@"$@"$@"$@"$@"<i=º\zÞç¼ÊbÏá(àÓäYèë×!Ðj;	5üõµ»¨}ôÕ>Ü:òÁ]èK-ùk±NtØ[þ9b¹ÚÇèíåTÐW[æÖ-.õ<Öi
zuµ1°Ó:×bØÁ¹Ô9Ñ×±cc~rbÆ}!Ù+9Ñ¹/kæÇ`cNæøa¾×bÞ"ÅX<Ö[zÍX/ ±XS×6>½qVâª¶×õtsÕ/:ìjÛ6Rë±3¶ÄùÕÑ#ôÔc~tæ§GÜ'cuµzr££
<vðr,5-ëúÉS`Ø[í×blã`g~ìÃ¸&±Cj?æÔXùåfccMÑc®[_¨½yg}èW÷®ãß#1aÛ,¶«
Hë«
8l»Fo~sÛkOï8ÍÁSÂ1&sxó;gÁ©çÆÐxØ ÖGnócSÇ0?}Åà=ÐîØUaÄ®7âæj½"`ÔëÔ1o.óµöu×¨1þ6A3'~Úé1Í:­EæúÅ°-¤ZË8è+Ú:×®ÃüÄu<,ÆÓW9©ûgÖQwûm7×K;sZîÈ£iì6m
ÿ[wÍ§	Ò HD HD HD HD HD ècÚOÌaDãs<EÍ{À#@ZÁI àÒÎ5Öá\ø	¯¬caC<tØÂY êÚf[ª7+ægLlKÓüÖ
Ü|:ù¯½§ !ôòÆQÏ\:ÄÆg>Ä:à=ãºkÌ©ub1Â:¶µ07ñ­Å}âÎ:±G1OÄ¨ëC¯ù­;ÅøÌÑÓÐY{w]ê»î½ÕMY1éÑ±Át-TÀdîéçä:=k6õ_|Ö}Ì¯/ëÆ®uètÄâôÅa#u|lÌI°Î>iÆ ?sâºf~ã¡W\s²´É¿«ÄÜsÊ#G6@ÜqÛ-q½åf\ÿ0qRyhõª.×V=lncþP\e9?¯²¬¡Ëq"$@"$@"$@"$@"$@?D ý*Ë3¢´yÑ Ú ¡ägà$hp	µÎ1\<ÄsìY¯ý´AÏ;Ær1lbHéKOÃÇ1ì×ñàA´úé_Û·Íc+ÿÃþº6ÆØ«3¾1K~kDègþÚÞuzíï²XÔ.;VïCP­^w¾ølZ6" ¾1\§GcGýu||$®bØÚJnY§~Ø1pãS#¾ä©cÆ´SNãÐëc,lÍ/.µ}½ÖÉMÃÇXÎCÕÔèÆ|Ú)g½åÂ«V³Öï¥ãêÉMâêÈvZï³Ëþ#Fnøm'Ûñ&&Mnt6l(wÞ~K§u&ÃïW9ôðx]¬ßqkyüq`Ü*Ó#öÈ£ÅûX¶u1G@"$@"$@"$@"$@"$@?D ýÄÜéQÚühsp	| .ß O]Í=È»xrÖ±«c8g
cybÐsbIÚ¦èg­øÔqê¹5Ñ#Äf¹qíCÕ¬K[ôØÃZAè·æ7^ìºt×=·zÔjc6h¡ÎÝ5`Ãzæ
¤/®v¬9vMß:cÖ]«{ÖzÝ99<Íf,{lûbÓ^[_DtHmËÜæg0GÌ¯6Ãc<å¸Êrår%IID HD HD HD HD H!Ð~bNbncD{pË?±G/?Á§ wÓ59×ÔÉ0g6ùíÛ´[ó3·ÆøÊÿàÃâØ:i~ææw?Ìõ£ÇQgçôæ7VíÃékª	zæÝæE±ØDýÂY 6Ø!ØH21vÎàSY\ýx¡±aÔùÓXÇ`!ºÚGÖãâgNcáG~ôÚ¹Gb;ö¥Gð3§ùÑãã;æØ¹ùµc}p´i§õÖW¬Ês$@"$@"$@"$@"$@"ìÍTÏ[û\M.!GÁØ¹k¡j9z6â0G°E¯=½±YCÌ!¿Á:kÆÑÎ®á+çb~|°S­/ëæ·FlcõÐkg=Ì#Æb-â9Õ·­öðg½©èäæfèÍFÜ=GÇa#Öb_%hêg  cF.õöægÌçaxØÓ3Gj;Æægr
)@"$@"$@"$@"$@"$Àï cÇ)~ù³gÆVïÆ9x8¥6Q
®=¾Úc«±i¬Ów%ÖezI5ëÀ;ÄôÄ¤'>
¡p7¯©E3×Æ3g ÕX¡jìéYwÓ8Æ`±µ.Öc«¾5¾1c©%Ók­èñ15c§Cu¢ùÓ°Ç=¢=có³f1æÄÜIÌQJ"$@"Ð}ã/és'_Þñ@Ù´?³)À@¾÷×*+MD HD HDàÉD {]ä\mC4x
>øcKAü0^ARMN5ýXAà%X³@gbb§|<zæ®éK,óÇ°W1?ëÖl9cÑ£³~æØ_½þ±ÔØ²_½?l}Ì-
vèÔÛªñc®tG_b±è#Ê6¾`æGs{Æøß^íÔiG~ã¹OëÒ=/>¿öÎéÍïvæ7&z¹)ñ¹~{bnÿ4Üð8APKw¹Q£Ç©Óf4§äjÿz¼háü]"çP=|nFjãA«Ñìzü¢ßû½ròÉ'7>ø`ùÄ¿üË^y¤ëÝ÷^ÛüödbÄöäú÷FbîU¯zU9áÏlÞÌW^ye¹ìòË»ýÆÞÓß¿ì[>ücË	#ß[ý¥_{ïï»SÒfÌ,Srd¹öÛßn0­¹å]rI·±Þû+1wè	'Õ÷/+ËæÝÛc8û1÷D¿{R:&@"$@"$@"ìVÚOÌEÌ&1Çððð	½zøìzÍ16éõ£ðr=T ÁuÄuÜ:&6u-ÖßjBùÚ=ù­5M
6xÖä=èt°k@ï ¿>ØÐE[c0gM>½ºÚÇØiNBk1lja½Î¾íó}³/1{%':lÐákomÄ@ÌÏ:cô½ô&<
DgÁÄÖ¦^s#ÖàÀÆXS×6>½qÞ|ÆÐõtsQ¯czìjÛ6Rë±£á+±G~uô=õùé÷ÉX]íÜèèy`Ä\¿½Ê2êë$Gyt·¹Ys-ûï?¢lÞ¼¹Üzó§~ùã|ÃçÕÄ_»vM¹÷î;;åj8°!
âeÚ*O1Çjþª#Ä|0|Ùµ¶ñ«;=´3¦pÀÍÃå+V%K¥KGydìûì³O2eJþ%/~q5kV3ÿþ÷¿_îjyÐ¢E¶{µ%ùy6ÝÄÏªâu[±|yy0ùw&ãÆ+³gÏ.3gÌ÷Ãþù®»îºÆõÈ#,ãä
{ûñWtyh¿¸JõðÃ+ccNÝ¹î îÕµ£õ¾À¯+bkæÌeÆôé
üßOý]ÆÆûß£OÞõ+ã=0/ÈN~îHFÆßä±oä¡j±ø[Ì³j7nØPÄ{¿c7nÜQ¨\KD HD HD èögÌAÌ-æRN~h!Éäf| )¡¶ÁOÒ	[sÖ°³àfå'ÐÕN7Ô½9#æÑW?óbk~÷ùAoM1ìãººÇ<èMm~ÖÓÚëC^kEÇ¸ÇBÞ
Q¼º1túú«7î& ´V °5>¶/ùÃD×ÉM£&ÄutÄª_¼6:@±Ñßúð¥¡GÇ[ó3·>}°eÝ}`Ã6µLºÐñÐ3óS+b|óX<¸mj½Êâ[¥»ÄzyÔ1
1ÌAÏ±ÃØ0zÆèllú±o:l[§=ùÍ¡qè!©ex4NÌ]°båªöé.1Çs|¸Æ)»î¸µËÍM:½gÙ!7ßx}á%ÝVFS¦MÙ,@ÄÍ»÷®B-ÈAÌýÑÉsÊËR6>òhùáõ÷ïÄé¸¡ýãg69ÿþüëÊ¢åëÊzpyéqËèý¯^=¯|%Z_	ßn×»ÞUÉ¦là[éñæ×Âbç_pACp¢ïæù@æv&<ð_>ùÉm¾}ÄG³¤ðpNNAþñ{uulÖ!%8`óÞüææ´v|H>Nî)\«úO|¢<§úJú?-^3È¥©-
×µB<-S,µìÎýSGoêÄÜ;ºAÌ½ùMo*Æé%¤ûXuïNk']¶'ÿÏã©²3bî¹Ï}nCøjÿ£ý¨|ÿ?pÚ«þ¯xE9ñ9Ïib|òS*÷ß3æäé;ãÙYâ}ÍûÜz9÷WïyOcóÃøðÀ¿ûÛ¿í2¹¾ÝÃîìÅïÎCñ2ã©Çt"Æ6Äï;~ÜÍ77dCk}AÌñ·ï×¼¦8uZGx®Ë|ìÑÇâÄÖÖßéãwÚ¿ø²1ÞçµÙ¡AlíLrÿÇç~1Nq­îdÊi³çyVäLwäÚ¸âxÉ][O­÷¶~rÖÄÜËËc·%­mSü]ÿßÏã´£P=ôÏ,ÃâòhüDöñ:>ÒÅJ$æ6ÇßN(®¾ bû+/¼ íô¢èÉõü7¼±µ
±øûËûªeñk¿óíBMýEøûñGñe¿n¯®;î¸£Ä%$e«ÔÄ''Lh»z¼Õ9¿ÝlN  @ IDAT§?ø¡uµºD HD HD Hí Ð~å±Ì|0 ¯ çì±ztþÿ
ïÀ:vÿsÎ11á1èÑ±Âyýo~zóulÍÏ:zÄ5ÆèmuÄüÚÒÃ¯pU\_ë%ùXÇÆµ0·îÖü]ÕæÝ÷V,Xc±ô®Q<c¤¶«7ÏÀjìµalls9>ëuaÓ9õ±^ô¼ðèO[çæ GÐ9ûaì\P5ëõ±1?cmÝs×©¯aO;õ¬·\¸"®¦Ú¤»Ä{áùtC@ÚFÞzóM¡Î2aâ¤2ñ Iòî»îçÙ­íl³CÛâ[ÞwÉ·%¾©>÷)Omlbîï:±¶õÊÌ-ñaêuw¯(Ï8ôÀ&çoîY^2ºÌËÙ&+Öl,o;ççN{ÝòªW5'ÅÄÉ´¯_ziÇ5wããª¼§?ýéåÄxN²:È)¿ùÎr\©~úéë>ãÃàZîk­Z?{FÄçD_sÍ5åºßü¦¹RoáÏ_/ë1!Ù¾yÿåóÎ«C?~ë[;®ÏüA?úñX&vúþêW¿jN*ÕWøè'\~/N ëâDÅ·¾õ­rÃ\ÇLøy}¶ò¿ßDm|ó¿¯¤/ðØ²&E®$Í«_ýê2ªý° 8ïüó5múÝ¹
èMýÓâê¼w¼ýíÍ>vtb®;Ä\$~'ï¼óÎæ:UNrý)rýõ×.¾¸ócGÄÜK_òrÒI'uØöÕI9rJô´×½®~%NzekIMÀA8¾óOÿ´±¿ ÈõoâweL<¹@è!ÌÓVa¼3b®?¼©sw	×=Î>ö¸2+NEÖÄ
×)ÞDÎüø=ÂéíI_spBs:N7Åï¿ûî¸½I	ItÜË_Q·D^të­å7qr®iGU§µøý»à¦Ë¢øË)7®r7ej9<È_®WD¸oµ<÷3Êèm§×,°üöÿ·¹~Âé°g=«LÓhµ´s½­Ø51g®ÕAðÌ»þ·eÕ¥ep|ÁâÈWFMXngwÿúZÍ¶é÷Óò2.N@*[âo'Þðe¬HÌ9À¼ûÚkËqÊzÀÀ
×ZþÉÿq3å*°}øÃ.5ÄÓîÞoê¯_ß¾ æºÂïCiNTWòþSº"æø}sJ\Ë
áð¾úF\Ã
éÜÂóåþò/þ¢	ùó¸¾ï[q	yþI')ðá6ÿf9ñüÅ·¼å-Í§]=3Å§ÆÑÈÎ¹Æ¨úñd¿«ÔOúk'ÅT§j¹*ñîxçÅ4;Þsg/yû;çÁñ»éêK..\[Y×L>?N4q"|îsAðt>õ;ûøãËêûåÖ®Íý½àMoî8}÷Ï®ãJL£vâiÜÑFq¢®&­Ð÷WÛO«2çÄ×ößO}U+1÷P\y|õW.éô<¹}ãÏW¾ëÝå;úd·^:³9Ïxz¼Æm_6¡~NÍqòÍ51ÇI¶kâÌi#c'O)Ïi'Ðy|ï??ãRÓ×øÜüù÷ëNëL}f¯Ï~vùÉùçºxÖå6OÓê\¬_ú¸)¾üQ×írí®ò¥/¹Üq-­Ä§|ù[\?O+¦?'åþ&N÷ÖÏ­ãä8HD HD HD kÚOÌAÌ-¶>|\ÂÀI°VDvØ uñä.iÜÚ[ÄO´AGLb_[õÆE®«^XîZ­æXGGO~öâ8Ûµuy]#úZÕc!xo¢HÀÇ&)ÊæúÀv;×cÚ4c	'ý°sã¬	qÖh0u~l^ßA16úØvnc¬vÖÎ8±ß½×û@g~ìðqÝüÎK<=sp0?kÄAFÏ»då^xbnÄÊYsë,ùàqùòÊªxã!qÔøñâùr[¿ùÎsèx]-câê«)S§7*®AäJLüù0è$æ¬xÎÁ#ãysãÊ<sê¦¿ôóËµw>Xî^º¶¾¯&/xþóSiÄãºÆK¿ñædPo¼OaÆ³v$>¯8<÷ª¯¤®ñ¿ÿû¿Ëqò áÊ«?ÿ³?kÆÛ#­©«Ónõ©£ÖÓPMÐögÆ©§Ä·ÿÿþÂÓTíK}ÚYë®àW[ÇiÆi¹VùÛ I9õIô·÷w§ûÃþ{S_s<G®«çðA^rÓtà§´s¼7x'E>@æ%Ïtëk Wà-S%çÄ5¥ÈâÚÎÃ*"äÃñ½5q¥"Ïº{Mn¡¦¿ÿØîÛ½!æì÷o_cº+ñxÚóßøG..fÚÂ5ÝÞs?¢'Å·ÝV®»ü².3ÿÊß/`F~ñõ¯q4¿w÷×tþóÚÿ)/xAyÌÓýöN¢gtÖ:RÕÄ\_Õ_süÝüâô`_ÈÀø÷urõóß~zÁùAdÞß¯¹[â9rkýÉÛÓwÔ1X¢¬±Ô¼þß/÷µ<Cë£&NÜæÌÖ<Oö¼þR'ùý×pU4_p@nS¤\xa'³ão¿³¸²2%HD HD HD o¡¸ô¼ÏIÌñÁÅ#ÑààPäàäMËË cÀW øà+AOCoA¯¶µ!/ùå0ÌªüÍþµµ³Fc;·f|Zã:±sÝñA°37kØ1gÝüèëÃf.­ùYïXT+'7¢ë&,
²ï7¿ým3nýñì¸k´oÆ_Ä[}-=Å¯&¶¶wêÿÆsØ¸¨aÜößúgÌQÞö'ÂVJ_û§|gûÝñFH8äýø@ó<KÆ51·xñâ²>H}®T¸Îõ¶ L(aï`ÀI?p~=Ï.T./¿S\\	Áý@&úÄ¿üËÛô=%ævÇûwâDDÍsO?£ÓóÈ8E9ÃÝÞsGÆë9ëiÇ6©¸:qñ­·tvæÓÖ\ãÈâ?úa\ñx}v(9YÇ#¢qj#ãË-HÄÑø»pê«Ëøxÿ!?þÒ¹eíòåÍ¸õÇÉoþ?gÑ!51×Wõ×Ä×i^ÿîúB=§§¹­\SzÕEÔÄÜÏ
~kÆdob~ÇÄÂF©çÆÐ[ó[¹ÍMÃüu0Ù51ø®ymkÝUaÄ®7âæj½"¢`ÔëÔ1o.óµöu×¨1þ6A3'~Úé1Í:­EæúÅ°-¤ZË8è+Ú:×®ÃüÄu<,ÆÓ÷fb çÆÇ3dÂ´C vöÝwhÀSÊM7ü¦ãÄóY³)ûÇ©;dÙýKËýKùÕ&O&1wòÑÊÛ^zXøÎûjj}P[]ç\~[¹âÆ¥Õçý8Õðº¸n¬U¸ï¿üeó|>øß@ìýM|PÜ×m}2®Ëë®p"ï¹ñè±ñ2ÏóyW]ùó¹ïÇsx÷þõ_7ÏPã$ÞÏVC¸¦k¶fÇ~Èçã¤ä[-gÄI8O7Õú¯øÉOÊÿÆsúZzÄÏÇûÀ?ØeYÛ{ÆZØoê1£ï¹LþÇíÉ\Ê È?ô¡Ó51×
<ÿVþõÓnØºÖWóW¼üåÏäÃlþ½ëïìÞ+^=ÝrS<[îüxÆÜö¤§ÄÜîxÿnoO~@|q`ÎÓQ¸
±²"HZ®%\Ýr­²ëö½%æ/|È¡ëVg|á¶«¯êdË,öÀóàöÍgu2jÜnÿÙÕÍì¤7¼±/P ýû¿m÷´à³^ûÚràÔiÝµßùN\eÙFàôUý51Çsò®¯þ>4IwñÇ¨8}äIÏ/cÛ¿{óì¸xFÚñìÀúosÐûßÏ´ZmM÷Ì 0'Äï*äûqEcëU¢#âoÞÓ^ú² O'´ºÆ{(W£.¬	¹ÑnPðájIÿVsÅóªí\Î3Zÿê=ïiªäï4§ëÿ¨¹kâÄá×¿þõÝ°£L$@"$@"$ÀÞ@û¹3b¢yòúA/
N½v®±çÀOlnFcaC<|±mûP~«.TD[s°h~ÆÄÁ¸4íÈo-Ø0×{¹ùÝzâ ôÆÇHO?lÍÁ¸ìß¬ÞõFÑè1½EÕ³8>íª_@Áeãµ¾K$`¢#®sr_â±No,óûâã_Çî¡¯ã¨3?ëø[qE3¿vÔÞ<æzl~ã1ÇÆ8ÃcÌ¹W¬\Ãþ/»ò¹ÖÝ@Èì¿|û<>8â%ãôÛ´³â*¿
_
ÙÞï9®æ:`åïbÌ)_¥&æ¶w%µ¶Ù'@"$@"$@"ì:íÄÜiáy_4>¤âz%´äWø5¸øtØ0÷ÚKx
B/ï`õ¬áËºbLã³ßað(ÄqÝ5æÔÅ:1ÌolÖ±­¹qo-î_tÖ=<ybØÄ$F]z}ÌoÝØ)ÆgÎÚc¸ëR'Øuï­lÊBIÍ¦k¡ê&s7Ho<_ ×éYC´©Çøâ°î`~}Y7v­C #/ /N©ãccNzuöI3ù×5ó½âDkôè°6ùwkvÜò£èo¿íæÕñlºAØíª,\0¯¬Z¹bWÝº´zà~åCg[
W¾ïì³ÓlÛ#;%ÿÿÙ{8»rÿÞéRIh@HD
A@¥¤\v¯ýëåÚ ±àõÚEDD t~éÒÒé	¤÷ø?ïÙó9=9ì³I6Ëó¼^ßg6s²è÷³3cþ¶+{èjæ(C?ÝR~ÔY±UÖ_Lý)f|n?üÑv!v{Ùn/fvk×Þ"æØ-Â®ÉùçÛQ¿=òHxåW4¬²6½ÿ ü^âX9ÛMw
jÝ*ùHxT(1~ý÷OÎb>Õ\[v£õ;~xÜÑ&R:ÙUöü]cãeÅsííxÈcìHd³úÌm
ÛsëåüH|Ëþ0aþä»ÉåitâE&Fú")1×ãð#Â¡#GFýZ;
ö¹;ïýôG»=ÃÐ3ÏÌªÞ°Q¦OãbëWÐB¹ô<b±¦ÉÉqb¹¶KcPýÕ/Ãåü÷wÈh#@3Ç¤þû'W¤´½n3Úêfä.Âñ¹ü1¿wRaÇ;¿´óþeûøý.LÅ¹
M6
V.Y&>ûlX½Ý¤Yã¤S1WÇî°ué¥¡¡ýoå¶îµÞXåhÍçÉúê_ÜíÑIi{½ÛÉ¾WÿiÿÛ@»é¹ßcsSá_ø?øÍo»ËCKó¾#à8#à8#à8U@«-ÂÃcocçÙÃ_TòÍâ ¬xt"ËÔæÚ1æÁ¡Å<}tz¡­\/½âÂ× òQ^ñ8Øó"+_ù1ÆNDþÌ!øó(?:]Z/9ÐG¶¥/>JóKÆÃN¶§ºm*
µ,/VXE°XÌWP
rjÁZ þôy4.ZóÊægGkÛìQëf¿dªÆ)Èé<±ò¡gÎÛ0æ¦eNvÎ_~Ä`}lÅ¯æ©/õeÇ\³ì(Ë5ð(Ëæ-Z®ÝzÄ£V,_Ö®YûÜ×ºÍÁàIysf56WÙÄ\eêª*[©<ã3²á¸{kÖ¬Ya¾PRRzÛÛÖ­KûÜhä$;áÊÛqs¾Ý­5xÐ »ÝÞ0!¢={ô=ìA¸Ë£õ#GS<@Øñö½ ä¯îÛ8ÒOëÜ¹s×\bît#î6LÓy[^N:5<iÇ­åã×¯_¿pñEeý¸GïE»ãf½ÀæøCê>æcâËGêºñ§?ÝeW@Ö¹ÈNeñ#]±ÄÖþ^±õCJAN!¯Ï¹ qÙüñQ£÷°¥ÂçÇîIUÝ1»cøïÈn£É¿^L§ùUG¡mJ¤ãYû7ôÄOÆpÊºÄõØ{ø :4Úócýûåß=Â¿EþÝ ¶{ºûi|cqÀÎö{¦ÿðÉGÌm´? XhÄÆò-½Ë-wG÷q§÷£ÕkÐ0´)éº
OýéÖ@rÌÐx#ým¶Óbm»Û¶lMíw~ooiw¦sè8!ôÊÜÓÉûéÙG4lÖ4ôëÛÑÂ©¼ùØ¸°0óB_Lý[1ÇNÃ)Fæ/R¹?ÚQîb9<d¿£$ì;°ÌþÛIøáBíCÛ®Ý²nµÿþüãæßïñxMÅÛ-w´rW©£*ùm¶û¯·íèÔNwæüë_ÃøñãemËBáGÀpGÀpGÀpö
;æÎ³àóìCØb?%IùæÃI ø¤¤zé3/Æôhü	(Gé¨ÔNsè`§øÄ@Ð)TØòàÏ}ZDþøÂÿ`#AldO~ôñaÌ¼lµ.Seuòg®h!Q±BAÎT$JÀÉ](z->I¤ôÊ;§:D²)¿ ¥U~l#ø1VýäI9Õ^ùiUüÑÑ']y°Ñ±!æ?×±jÄ5ú9vÄ±3nw²pÁ¼ iWY©éÄwae;ÙÒãÖòá¹u»jÓí¥kyõ%;6°¼X'Ù® îÜBÈqQ@r4^ÌÞãÈJ^
qÄå¹Ñ³{;¶ HR9é¤"	¨¿üOçÒþvÄÙc?^eÇ¦±éW?|%¶±?×_lýì»úk_+÷;á¡ªïÏïl7Ù|#${#G/{9ý¶+Fß-î¢cG[¾»USeÚô=üÒ; Éù=;ºãägy&ÓqùÑÔvëpÝcn9îvw²¿¾¿»«©:Í±CªCï^Yb*Ý1WÑ:ßgGAfþ°A>}f$Û1|._;Ë»)Ï?Ý=Ìq'Ø1ÅìXÊ~ïo±?²hØ¬Y4É%æêØ®½¡ö;¸Mç¼!ø¿~ÕªÐ´U«8Ï®<vç¥RhýQ1/wçÍøNÞ{õ{Om1Äw°{N»Xî3»îþeÿí\:wTÕ¦å øoÈîä)û£§í÷O>qb.*®sGÀpGÀpG êÈì»À"ÎµbîþD}8ÎAcúðp´Øó`+bKmîqü#¸úcì°AôyS|â0VæÅhNùàKKù#äÁVsÉA«|´Ê¥üª?åOã)ùu+/$(V´8M¼´pÆZ¬lµ`µòÕ"#Ì£CX´Æ´©sú0È¡<´ìE'µ!tÄb,_ZÙ*NÚ5Å.]õi-ÖÍÆD';òh-ÊÏ¼ò[7®<Míá(Ë{W¬\¾Ú÷º5°7n3§îØØ]ÑìëØ©$4°]ÈM­è¿Ò¹+WD}eÔtbNx°³k:v
5Ë¼ÈÅb¶í¾ÉÝxüÄ'â]s)¡Çáeö×÷¼Ðã¨Ilû#FzvÃ±»R| #ØQksÜÀ/>ï»ÿþðÖ[e<% Çrawæ°CÂO¢:xâ0yÜíSYü ^Û:! òÉ¥\úôéïüÁ
Äæwp£ÝTÃ}wW{ukl0êK÷HÊ¤õ¿üÀaùù©*öÛãA#GÖr/$c¶{nêK/%¶:WØÑÖßv½u°;éï_ùM{åe;*³í+ý=KÌ|ýºÙ%ß#víÍ|í_v´æ0Äv6#ÿùÏØOZ?1:Ú¿ï!§áòiªîzÅ¡¾ýÉª%KÂ÷Ü7üÐ³ÎíºwG²ãm»ý±@*5
~{Z·~ýt*öß{wvfG=§Çîb´ì*g÷rºCØA÷ýAËk¯½VnÚ1×çµß{Ú[n pGÀpGÀpGÀÈ@æ9vÌ-°Ý
"¬°ç%:Z8Ù@Àñ¢AsÖ¶Ì£ 
­_d$¼}É+´Y7°ßa#
Ö®×®	;ì÷Å"ìÀåß>ÂÝ®ü÷¿"¢ßaûòwTEêrGÀpGÀpGÀpjs"æ¸ßîÿ³Éÿ?`¨EO9ú<pzxpòaNæ¤ãÅüéã
&Î]ÀÄFàÓG´p AäK?­ )cÅ¢Un¯9ÀW\ù(MÅ9Ù0ÎÅX0qÅ§ULúWåÇu>"]z%1Ð§±ð!pbÇ\gÛ1w¯ï3$\j
ÇAWRRRKÉ]7/½ôRxþv¹+µó¾#à8#à8#à8#à8#à8517ÆÖ3Ïí;{BNAüE:=}íN=côÄL{;ÙÒ"ÊO_ùiá:4&&}å·nW¾Ü½|ñQ<ÅF'_æZñ+ô¤±¡ubÃX©
zDzlxÐów^s´øÅÁcø^Îß°nÔÓ"ØÊO­â2¦¯üÖN
ìÄ£0¦ÏZÐ7­OùhW9°Oç#©m©fgÍñW~l}Q¢	"àµH«ÅªXìÒÕ×Â&-¤ §±±0µøÈ¸òÃùÔßYQ]ªV¤êÀ;D9iIK|Õ-êÁ_ùsým*
6ø ØÒTT<Zÿ4gcw=óÂ/ÜµrÕjæ]GÀpGÀpGÀpGÀpGÀpG #ÐºeðÐØ[uåf[* ¿À£¾øø
ølá$DªhÃN¾´[7r/Øá/±ø
õSõGùÅàçA­¸ëÆ1~òe-²§/?|´¦ÔßÔqý´ÒãG<Zñ>Ä¡å·nìÓ*?}|°Q=ÄDW°¨XIQ,LEcJ¢U¼O¤¾©³z-y£Ø#ª'wmØê¸HùÑêC æMë%BþÜ<ÊO¿bX7kK_ò#ô±WM|øÌÉWó¦¢üÔã(Ëûü(ËÿpGÀpGÀpGÀpGÀpGÀpj4£,Ï·EÎ·g£=ð)qß ×@Á­tØ#ðôÑÓJ/ü4Æ>÷1Uô#¶ÊÛ¦yè+?µ©/´e±D5hLNòçÆO¡ñ*WNÆiß1êS$7¿ônÓÅTØ)ÇzX bR(`PdºètÌ¼D 0FObhÁúÑkÞºÙÜèõåCONìxDÈY7[OnæÐIO^bäê´.éÕ¢×Nu+¿©²"9Ù)­° ?óè°e¬uAÌu1bî'æ	GÀpGÀpGÀpGÀpGÀpG #!æ.°eÎµ;æàà&àÄ9À1 £åA/¾8ëÆ>Ü
óúØ¥Â.;ÙÐ*§8åç¡üÄP~Ù }lÉ£üÖµ)'zù #&ù«Gã´~æ$ªEÜzò+¶j½êJõi<ÙU¸Õ*ìP!q(ÂµxªhÆ²ÑÂ3PU±Líi×¢:â(}tj°ª9úØJG_1m*ÆÓ«ZÑã£<ª;	9DÀ1ÏÈOùó`
$> H%pÌ+ÚÏ&vX"ªðÓñ|°èÑ©&ÅÅ~={ßº1?±¨ø¢Smø2^qßTÙüÄÕÎ<Õ¡8ø!ä×1ói^ÕNùU0Åø
tÆèô(®ø
Ú¨Q£PÒ¹shÛ¶mhÑ²e7n\øà|¿+rîëõ[µjUøÉ7îóõ¦	¿xJpòá¢êùIKÂoÿ>5®ò~³'~þ¢w³}×øÃÍU£:L¹×ÿöÿÂY³ªCYUR¹k×§þøÇ*Yh}ýý-´N÷sGÀpGÀpGÀp#ÐÚÞ1>4ö:ÊbNþ>xZÆ´ÔNþòU+î"õ¯ì«|¼Ä/-¶¹/BU§ME[bÿÁQq=©r È>%È+[ìT·pIÇäQªÅtØÈ]¥äÅbP$Å¨p-,%¤Ë
?/° ¶ÄøÌ+ZSEÒüúÐh±cN±U£b1ùEùIG«Ú£xÄP<ëfýÐc§Ø¹öØJ°á!oýL=¢üÄS~lé««í«¶GY6iÚ,rlH*%æZ´lºtíwÉ¥þiÁü¹ås;r·¾³Á^~ÏYsQÓºª{{ sþô§Ã±CFH_xá0î±Ç*ïÉv\ç¨Q£¢ý²eËÂÿýüçÜ¨}½þêDÌÕ­S;üðóGîíÆÏí¿ïx#¼ûÞº
þ{2l×½GèrèÀ0þG¢iJÌ-_¸ ¼|ÿý{
q@ÎWWb®Ï±ÇÕï½ÞónÁ¸V'bnoÉGÀpGÀpGÀpG `2;æÎ· óìáx'8.^A<sâ=htì°k@ï ù`ÃC,ZôØ*cæà3G/]ê£ØÉ9t³n¬yåDÆÖå''6òeÌºú¬è°A¯ZÕFDùGð£¾hQbi±Ñ©`bË&ÓBT> ÆDãtÁO«8VÄUj/j¯@W.êU»ÔÖQR=v<øØ#¿t´-õ(?:å§E´NúÒ¥~èÉí;sÕò(ËV­Û.Ý¬Ä]¥"Ä\CÛeÔû¾q§»/ZV­\aGSÖ­Û´
¢x¨¡C¤O?°táZ¶-à|³nQóäæ¡&óè~x6:@Ôqª9|y¤£­ò3V}Z¶ÌkØÐGMêoÃXºzöàËC­â+¿rmh]ªëQõê×}úìF[»vµ=kB¯Þ}ã½Q!æ:tìÚ¶ë aáüyaÅ²dHÇÎ%F´óï¿·$¼·dQìëG½zõC¿Æ!G^BÎíO9õNá?NîKxäµyaìs³÷g9Õ"÷FÌ
Úg?ûÙpÔ¥w=b»¢^~åBC~¬¿ºs lß¶aX¿¶áögfåkùC¤Ââ­ÿðár'æª1§Ïæý9s÷ü­YZñ{Q«1ÇZªêû+\¼uGÀpGÀpGÀpý@ë-ì(Ë[9Êr=íóK@Dk@'N}ñÌ!ðù× Õ<<}øZâ1¯ôåoÝ8O+ìéç`!.¾H«TS:Olò£KûØ"èÈ)Îò§óÊ/[ZVóøðäÖoªÊWÎ+¿uº,[ePÑBú¡cA´ØX|xÐ-sØ ²§^1ã(^üéÌÊAË±C_ u³zúèlôÈ8ôõ¥ÃV}Õ©üÊ!?Å¡@¤Fö°cîî+WY·úKÿ+LÌõìÝ'4iÒ4lÛ¶-Lô-XvJ½zõxëÖ­
ôíu±·¼,±WÆxx)zõ§ÆL¼Ø7~Á^Ë
6íÛ·ñ¹måÊü»óR»E¶;ÝV­ZþM"þK,êîÝ»nÝºEý+ÂìÙ³Ãûï¿/rÛÞ½{®]ºfÍåËYæGÌcíÈ¸3F~cïº+L4)oÖ­[r·´³ùµÒîc/Ë©ao
ë\Y»vmX½zu®:;®U«V())ÉO=åÐ³gÏ8~òÉ'ÃÌ»´,XPeG[6´{ÙÙÆ¿}nÙBòtÒZ7nÜ?íÏõç#æzôèºÛ÷;ûÙ÷èÝwß
­|
¼¼óØIÐ#èÔ'&/iÑ#}¡D_¼u³~¯ü´ÊO<æÅÏX7Ö©Ó^µ?ÍÍ<¢üäÀ~e«=ZêP½ä óÌñ0¦E§Z«îÜüùj1ó	D,Q±´£xúHj.>¥þØË¾b¤`+â2Æp5§º°Ég§òQ½èù0ÑÓ'l5VZ=ù³úËÇTq>]36ÊO_¶ZcÍS;æºuáîYa/J©(1YÀ1[¹qã0széëÜ5ö>¤_àþºRònBé&öB¶g¯Òjóæ¾VÛä}%m[4G÷>8üsâ°~séï~%-Âõc%üâÿM
¯L+Ý}qPíZá¨ÞmÂäù«ÃºMú½Y\¥]»êÊ+cño¼|ðÁ¼Ï=÷ÜpøaÅ¹ÿä'eÈ¦ÿèGmüÝM7.º(tïÖ­LåXÆòvµmÛ63&´oWº³1u48qb8ùä£:1qxÎç>PÈÀåíèËûí¿­[ù[õrõÕWv¶\ÙÓs
Jó-C·î=ã`Îìa³íhÒ¸I¨o»6oÚ6lX¿×GõR6oÝ~{QxÔvÇ5¨['üêKCc=ß½ëÍ°`ùpòaÂ'êZ6©þòÒð=U!ìN»²ÄÜ¥\úØî$»Ñ:wklÇF'ÛéQüÊîÆZ¼xqé6¶ãËÿõ_¡¾iZ¹ËvÌMLvÌñ¸ØÈ@ÕW^éÓ§ÛíÅ7/¹«Z¾óío¦7iìêLÌvÚiaøñÇÇrñË_÷2w+rçâíî¬:+ä>/v~ëßöO?ýtxÊÉþ\¿¹M7Ç;ýºäªâx¾íÂªnR×ÚC9&t?ìð2ÄØ&Ûq9ý5#äìûÑ+UAÌñ»óØÏ|&Ü¥k6<Çe~°ãÛ±Åõ¤¥²ÍHígÿ|[ØlÿÎSékY#¶ö$ìÒzöö?
oþÒüØ
ZùêHÕkfÙÝmôåGjgLÜ_kO×Nù±ÃGóÊ¯1q'AÏz9½éäíjg»cîþ5lÇä~º¶g½Lb/'ËBEíÚwí;týY3§Û}vëb­ì%lInÙqnWì¢?o®M¥°çZV~|ÛW¦
üK9»£C?:wî ´Cì8Î[ÝÈ9HÅÝ»G[~þù¡±íìD !CRy×å¬*bñðÃçsNæofvã¤ßp@Eî¾ûî,Æ÷çúEÌQÂ÷Ü9ô ûLÎ>ûìÀw	áTv\Vá(Â^GzÚ÷·nBLsâL#ræ¾óN^BNõW1×Çewé4ñÙgÃ¢éÓâè¨O5oÇ¦L	ÿ¶s©t4(vÒÉqÇå¼ï¶;]nØ¦¤Kègä/ÇB"AÉ·TFØNÙíKÉ¨µvlæ[ÿøG<6r«ïqÇÛJ.1WlýÄN9åZmGïÎyû­°jñPÏDø±BvíÃäç³Þ/³]ÚÚöëj¿wzCÐÙHÉvû·Ì7|éKDÌi9küø°tÞ<#iëDlEô-6üÆ'øqìçp'æ·#à8#à8#à8#ÖöGÑý£9îèàÅ/2áPÄ;ðÒ[¼xéôB¾Á_ñ´<èxÑ-nÆºÑÙüâ0ßTÙüôÅËàj§Ú#bkÌ:äGù©3åT#yì9â0f^ùÑÓ¯uãX8bæg¾ QQ9'N*EWPÑ,(F¹S_3 
61ÆòGCsÊâÉV1Ñ§5ã«=6èe§üÒ)ò*¾æýB_4âÊG1¥ÇVùécÇÃþ.5õ¹Nöò·M¶¶D{ñ»xaXúþ{±¯ì¨èÚ­G`gÂ®¸µkwÞÅspÛö¡c§Î2/·]ewüÌ7§ÜùB&êÕ&±ã)´¶ycñ¨ù#­Z¿ÅH»åáõËÃ[ïîzßP~¯Ýk»uë®¸üòhTÄG;6L7RNrÈ!ÿ¸ôÒ8ä»úSM4?»íþïç?[;0cdÕ {ù/¹ËH!¶Dú÷ï.ÌÎåì¦CÏqÛ(¹ãÎ;Ã#öfG~gG"{"ærk¸öÚkCCÛ¥|ÍÿüOlsmªjÌýrßøú×c¸Wìø¾¿ÙN$äÄ},zê©±Ï}¿þÍob¿w¯^á_øBìÿü¿(÷ÎÀ}½þË÷ýãXËË¾ô¥X÷:»;ìþ0ö÷÷}<ÁvÕ7ÒGÂQ³^=Ìðvî+<;õ+ã}p|ç^ºÿ¾À±©pÌä¶#aØ<õÇ?îrb¯!CÂê÷Þ·#+ç§®±ÏúF^riv÷ÝS·þ1{$&÷¨
t¾ U/òå¶iÍQ}üõ4åÄOvòCGGuªÙ0uc|l!ÕÒ\¾D¶Ë.Cù«~Cëw«©Ä\Ó¦ÍB÷½ãq¼8^¾|iXewÑ¯o$GÛ¶íì~¹;¸ûè$í;t²u¥;66oÞ,ZÖoX?öRºCÇÎÙWKß_bä_Ù×SLËÝ»Ss»o®M8ch×2¡zun?cYµßU+)1VÄ÷Èå»Çë{ßýnÜ	Æn¦oç;ÙE=:³]1È¸ÇDVv2Óéh»B¾bG+JRb.%íØ¡÷§ÛnYbyÇv!Ý}Ï=eæ«rP1¥ûú '¹÷mo
5÷Ûqè<;Þñ&;æ¹Ä-í!?´;×ÚClW×glw"÷µ}÷{ßm¾úöõúSbî1û=o»åråÛFr6³Xì6äûWU»sóTfÌ}j'^tqÖÒå;*r{15ÈÓ)ëÜ¯8òNÞ|l\,!9}tèù÷óê_4âhn^»òÓÙïøáq:õ?täÈÐãðÒ±åíDknw7~ìÂÏgC§Ä\UÕsüwòÝU!Ù¿¯QFL6Èì%æówßeDfé¤ÄÜd»GÝr¹ròeÇÝwÔ1¨cMËEÊÇ#à8#à8#à8#@fÇÜÓÏ³G/Åá)x8H+^S£Á%;Í1çÀOèÈÉ46ÄC-"]éhçOéå§OlË#;ò«lË{±òcÃ¡U||¤ùä­rÐ'.ëWæCyh5oÝÂ U!C«¢ÒY
8¦ô¸,<Õ§1l*KÒ	LtÄÕÜÊ/ñ§U,å×úøª¯uÐ"´iéyüUqêÚ£ü²£ôÊ£`ö_ñc£8lÉ`ÇÜ=+VÖ¬;æl]QZ·98t.éªánÛ©ß)sg\#ïØ5gÌ^X´`Þ./í6kzñ°#gÊ¤	»_Ìäù'ôgÛ­LG^Æ>7«®ªÝ»w_vYWÄÜOÿ÷Ã
#Eså«_ùJè¹;éºë¯÷bs©f}2/üÓ{Îrýÿ¿o|ÃvEÞs×\sMh9fï¶?ÿ9p\>áþ9ãDVÛÎ¼ÿøÇùÌªDW(1Avýu×ÅövZ(=ß¾×¼ø¿ÖZþMHzè¡ðíâ:åSÂÈOKm7;Ë}½þ+o'ßUvb»OÑX^ýûJQ3âü1eî#cäG>VD%æÚçÙó#c*N\8erÞ´=ì8YqDÞyæi;âñí¼v(ÙY×Äî#lj»Æ8±¹ýqäòöSOyF#ÇÚÝgmíû<{ÇíaÝòå±ûcÔ¥ÿ¸I¹ªª?%æ8Nó9;F¶*¤C¯Þ¡ÿÙÚÉ1¥/Þ{Oàþ@$%æ½Ý0°;îre¸ín9ù?Ü½ç¯µíô>>³;×wÌå¢æcGÀpGÀpGÀpGÀ 1Çñ^ì«e-ñ+Lpð	è°a¬c/á)xZñ#=sø2/QLÅg¾CuçÑ¼æSxåWlæ±M±â_µhø¢SØÃ£(ucLb¤õ¡ò«nì$Ï=:ÕnÝÊK òÞ;=X
QLZt,F`jÎTeÀd¬Ò*> ÍÓ2È&íãÂ¼>å/óêÐ#èÅ¨ÇºQÒøØ('-Â<ëäQò3&®æ_ñÐK4'"Ns´è¶u®ÉÄkk/ëÕ«Ï0+ìÒª]»=¥ðMðï]È·¬q9vä53É%öÊq©´zÔàáòOô~3­5÷êÐ,ozljxî%¹'îÝ«ã(ÊCxq G
"?¸á°Þ^N#)a÷ýk¯
N¦÷o»cnÙ²eágÿ÷y3é_={ös)1ÇgÜu¤;é¢"ùñù/s|? e$23ù¤±íNâ8MÉw¬Ï.±½!Séoól÷ÒM¿ßyÔÞ¨i­yðÁx¬åh#k¸pþá°Á#N|6W^qEàXÑ§y&<õÔSåÆ¬Ì{®_Ä¤,äl>©®ÄjmhÇlüØÇBÇÞ¥Ç­¢8^d¤è_0"&ÿ1¶ÅsÇýÐ¶[7Q¡vú«¯i¯¼µe'Ýá¶Z*"3Ç¿¦duÉ¥qw~ýî·a[9ÄüÑg|:tÈó)1Wõ;%æ Dg¿ùêJK&MB#º9b²RòÞìYaâsÏeïÖVÄÜF»÷ûûòIyÄZzÿsùs#à8#à8#à8#àdvÌoHÌµb.A|<	/2Ð£K¹ñ.øÓ`»4ÆÌx¼|e0^\:ü±#ü°#s<ø0&ò§ó±xÔWí¦:ôÊ¾Ê+?tÄG°çQ^l5Æa,=1ÔW\Z»ÀÅJº`#HËà³ Ùi±Ø¨ÆÒ¢5/ñG°Õ:éÑéKHaN¾ìäOÅ¦Õ¼bÓ¢Mú!ðâÔ5ò\cNùÏÃyù)ò3'ëÆ<ìëZSïc{,Ñg/~§M´'ó]æÓ£2ß[²(¼ÿ^Õí^ërpãpÃGõK?ö??=#<öÆÂXÃÙÇuçèûk7n
wÝuW^¯/ÿ×N:Å¹ÿä'aµ¹'¹ÑÆH!ÄÜFötëÚ5úïî(ËÔûá¸')Cÿ{©={ölº»¤ ä !1··¤Pbª}ûöák_ýj,ëÝwß
QÁ,(-@-sôeO~|ÐiáÉTq± Ä{tÌ¡ýÀ_zëf}Ò5*ù>1W9°UÄEC§<yÈ?sø)gy}Ù3O_q«ÌOuY7
öØ5¶§ÆeWçGPr%²ôý%aÉâEy¬v¯êTÒÅî8k.V,_º{JÌùXÏðé¡]£Çù«Â÷ïy+ë]Çà¼ñâ!¡k[¸Õn7Òn\´ËÑáÞ6îoCæÍnº)ÿQjßÿÞ÷B£F\UBUsÍ=üp$bäÇâ}çÛßìzCRb.½{îïãÆ_|1ñÜÙå¸FmDÛËÿÿýÙÏvNVq¯Pbª¥øßßúV¬fÑ¢Eá×¿ùMW¶k8võ\wíµp[`;ä¨rvÎÜ¹wl¦ÙÎ­¾}KYÝJ}½þDÌxw?ìðÐ÷¸ã²ú-7©/¿æÙQ¢¶UÜ¥v¢,·ßK/?ð@ìWôG¯!Gv2ÅþíÌ|ýµºF»>VcßcýWüË.ä!ÜcÇ}pHJÌ
g@rð¹vy°GhñAOA]éK¬¹_zÅ¯Aä£üâq°§4®|åÇ{8ù3àÏ£üèti½â\#[t­ôi<ìd«xª?Ú
+O,"ó§Z°?}Í¥Ö¼r¤à¥ùçaxü¹û6{Ãº±NæT?5"SÓyìò¡ÏçON9=äçC~ùytô±AO¾§¾ÔV§ËYvåÀQ J÷v?ÝßL:Ù·ä÷OY|øQaÝ{6kæ´²Q~B
°Å½p£¤|sá$|RÒ½Æâ0äÏ¾8ÍÐðrvò)Áü Sþ¨°ä!6sôiùãÿ#þ9bldO>ôñQ~Ùj]6µ?sEDá,@EA"±¨tÜ¢×Âéó$úÔÈ ¥W®Ü9Õ!Mù(­òcÃÁ±ê'O*Ì©FôÊO«Úä¾<éZÈæ
;zõîk»áà.í_íBYµrí³öRØ-ì,²ãâWá1»?[HÈ³ë3fÎÍíeýÇG
ÜCÊ?ýiÜ&]1wÌãüd8!sãé3fvY-ÂáöB¿uëÖ¨³rßý÷·ÞÚIÀ2$|æì³³óU	¡µÍÈÞ¶#ã:%þõ¯aüø/®¥/¦e§Û±CfC4(Ä1wÅM:5ö?0l_zé¥¬]¾Îùç?²Þvp¾=aB${öèzØüùöÛãÑqP?R"p)9Ú­ÛÎ;d÷Í¹p¯¿¦sàt¶£ý$L>bnãÚµa¡Ó{È·ô.·ÜiìþHî´ã~´z¶K¸MIçÐmÐàHm³]µOýéÖ@rÌÐx#ým¶Óbm»Û¶lMíßmooiw'¦sè8!ô²Ãî§[d¿6kJúõí÷@*o>6.,ÌüB_Lý[1ÇNÃ)öÇ¦LV¸JµÅs=:*<ác1'¿¿¹p©ýþkÐ´I$Sdv
«¨§nýcØ¸fUÚæþ.áhavqGÀpGÀpGÀpý@æ9vÌ-°#~ Ä'À/ðÀ!¨cNÔME[æÑ>äS:F/¾¾xbð ÊA,l%Ò8<ù©V|Ò8éX5Ñ"Äf±âª5US,Ù¢ÇF1T«bP:só+T^´ò;=ÒGA©>T¡kAªæ¤g,ÔÒ+;æÔ×|Óôl×\Ú2¤óC»ÙK-6ôõa*¦>$ZÙêCD¤¶É­üÆòã+.+9Ó²\Y²dG;ãv'Ì³{áå5»æìºÆKïqËkdÊ%ÚuÛ
1æuªk;Ôze©tÇ\úì®ÿÆ8;
ÒîL¥ïqÃd;&»s-Kû³°b»²ø"·yÂFöGå	ÿ~·ÉÜ°Y³hKÌñÇCXoÓ¹$or­_µ*4ÍLìÊcw^*Ö¯sørwÞ¼ïä½WO±÷ÔKÌÕ±ß#/¾¸ÜÏ Ât»©Âÿ{î«,ÙSYÍ²ßÃ''¿óí`.(°;9#à8#à8#à8@ÁdvÌã¯­á ÜxÁ .F-zúÌÑçÓ@ÐÃ;sØà£9éÄ0¦6ò«-ÕîÌÏXõÐÇWüêC`¨ÅT~ÆÊ¯õ0-6tÊ¡1­ò+VêCiÕ©
%(Ì»Ô"b±ôS²ÁÁF$} ø¤}æ W~|ÐØ0FÒüôyÇ`!ºÔG6Ì#r*~äG/;­Øêë¥EðSNåGäÖâZ7_vÌ×³§ëY~ñ¾öó@>}íN7{é»qã0szé£ÝÕÍî¸J²;ß>üå×þ+[i»àv'!ø·lÕ:@Ô¥²mÛ6#äåËváÎ×>GFÞy¡í0ðB#¹­÷!>þñ8u×ÝwwîbÔñ9:ùØS?¸á¸,µóSN9%5r ~ýúÙ©evïÔ³ö"~»}cÆúòvac¾ìþKwÈáÀºlçÆk¶doÄæwp£ÝTÃ;õÎ²;µetÜû7Ûð}ÒùÜÇpê3$ÏµvfzÜÛÅÇ.@ä{ï
­í÷ÛÓKïºÌGü¥yªºêWúE²Ò,=ëìÐ®{÷xÄè?nþ}Øn,
éQ:-ÜµkV
·$(VT0qTtî¢&6>¢"_úi}Ä Hé+­rxµÌ¾âÊGql*ÎÉqn,Æú(>­bÒ×¼b(?>è¨XôéÒ£,>±;æ:Û¹{kú9[§#à8#à8#à8#à8#à8#ðG CÌqGÐ<{´cîîA
}8ñé<:8Zôôµ;MöÑ3ììdK(?}å§ëÐôßºq^ùrc*6öòÅGñ|ChyÄ¯Ð'Æ"Ö
cú¬=yÓúVqût1ÚjvÖÌåÇVùÑ%*° ^T±Z¬Å.-X}-L`ÒBjp; Sì+?|xOýmÕ¥ºiEª©±C´ÄWÝò§ü?×ß¦¢`-}HEÅ£EðOsráV×3/üÂ]+WUþÎ.º8#à8#à8#à8#à8#à8À@ë-ÂCcoÕQ­r*.~G}ñððØÂITÑ|i5¶nä^°Ã_<cñê§þê+ò7ÁÎ[q#ÖcüäËZdO_~øhM©¿©ãúi¥Çx´â}C=ÊoÝØ§U~úø`£z®`!P±£XÆ,>E«x-6I}SgõZ<:òG1±GTOîÚ°Õqò£Õ@+Í*ÖKü¹yÅ°nÖ>¾äGèc¯øð¯æMEù¨1ÇQ÷ùQ#ÿá8#à8#à8#à8#à8#àÔh2GYooÏF{àRâ
¾®>9Zé°Gà!è£§^:ùi}îcªèG.8l7·MóÐW~jS_6iËcjÐ<äÏBâU4¯Ó¾
$½®øÈ{Ù	tL4?:G8Ì4Å`,0;qêGüt,{lÙã¯ü´ª½ò§ëÄO¢üäÉGey¯ïdÞ:#à8#à8#à8#à8#à85Ì¹ólóíÙbH"H©TÒ1<¶âÄ=H'_ü"^V¶ÄßÀ{ÕaÝ8V~ÅÂZøåG'A§üÒÉV14§üâ[ðçATWDùé+¿ü4fN¾äQ~Å`¾ Q¢3N*!¡h©`Ã)Xè°R¬tbAñ×SÐR[â*u³ÊøÊôôµóÎºÙ<ôµµZmZ/¶ªU;çÐ!äIsÉNzò³.`ËÉÈGÄÜ]NÌã?GÀpGÀpGÀpGÀpGÀp@²cn®­scf­âI µàDn¡')}éh±E×OÑÅ¿_®(¿bñÊ¡ôÕZ7
ùÕ«$µ'ê`;ñ,Ô>Ø*¿ôÄR<æÐ#ª|kFù¡à±-ÏF1ÔR(}cô¬E ^­©¢cI¾8ò%ó|¢ e}`ÊÆjéã§øje#;éÍ4_ñ´NÕ%ô|øþ²×Vù5';åWLôs%vÇï9GÀpGÀpGÀpGÀpGÀpG #Ù1w-s®="æ8Bþ >A"Vzøì$éúØÐ§­/Í*
zq2Ø1(F7MZêÏµÁ!øÔ}Ê?aKlÔÒ¯u£h}â ôÓu0FOj+ùSÁ*éVÆ\¶b1¦¨90'ÁF¶èðçÑÂè+PSEÑH4}L
üÔ¾4BéÏ´õñÃ^cb§;àS<ê¢¯>ù}ÈôÑ#ªWcr¨/?á¢üÄQ~låÓÐúÝí¹»ý9CÂÅpGÀpGÀpGÀpGÀpGÀ¨á´nÙ2<4ö:ÊbNþ>xZÆ´ÔNþòU+î"õ¯ì«|pò¥Åü©¨NtØ[ücD1Äõ¤>ÊN"{q*èÉ+[Æª[¸¤cò¨NÕâÉG:ld®ÒBòbE1(bT¸NÒåÀX [b|æG­©"Hi~}h´Ø1§ØªQ±ü"ü¤£UmÄQ<b(u³~è±Sì\{l%Øð·~¦ÅQ~â)?¶ô1×ÕvÌ0GY¶hÑ2ÔoÐ ìØ±#,_¶ÔÊ¯Ô­[747ß:u
µjÕ
[·n	kV¯q*ÁÀ­ß 4kÞ"4°üµk×6m
6nëÖ­­h·sGÀpGÀpGÀpGÀpGÀpö+sç[óìá98.^A<sâ=htì°k@ï ù`ÃC,ZôØ*cæÄ§ .õQìdN:ÍY7Ë¹¤9Ñ§±5ÆFùÉ

±Ö'ð%ß²Z@ÔoÖ$äàÇF­úÅËÓæ7¡·týøÈåÒàögîúÜ±øÝ1èØ©óó´¬Ûð|ËÅZëÛß^Ôâsóoä[Y7¾r£Ç°ÔËÒSbnâ¤ÉiþEjVÛ¾mK·äÜÜùÓ)S
º¼	6ó¬oFûS?±ÔDðcGô¡c·&±uoüýe_áyu}r]/=ägçbÎHkaîº[ûw¶Þ3¡pÅQÅ¸XF},©ãêÍ£XO¼1èÖ¨Á¶u¸ú\1ÅÙÓ×;:õunF;ý³tçædSñ×{&ÆþèÆºæúYÇÐ¼ç}ªíà¡¬ÞX2|ÄtËUÓhGÊ×á´tÙÄóâzBÌÍ='M1«ljÇ¶­©­m
bGúk<óZ¬mâìOuÐk8¤ÎcÎ:×c¹çÄ¸&tìÄ`«u×ÍÅn_ë¹>ìÖ«Gýä÷IlØ§äKI.¶³FW
væ¬×þø¨Ì×Üü¹?n¿OÌ¶|é)17hÐ tÛwÛV8q<½°nMK¥ÆtÙòç×5È»§;ÄÌ5'ÍÙ8q·qÃºtìèÑþ@ @ @ @ @ 7S&MÊÏ{Pbît^ÿ|ÉCÈ;À-ÈÈ3hcDà+rà_ä/¹°Á[ÈÍdµIvC_úËaØXû£ËËGÿ:Îµã£µSÇÖ:ögÄé'|ú Ä1ÇÎE~ûcG77«eî>¨e}rû,.ªÏ.%º¦,ºnÂE³¡{×¹9¤(Ä ÔD­µ>{c=c­½^3¹ôç ;1Ø³¿6kÙ×~3äÔæ7µsìc5µkóåÄÜüõs,´UzJÌ
Ü|6b{ÛKx
.QÞÁ:Úñ_±¦õñÃ¸xêè×Çuá§ý­ØZ[ú®Å}Íub¬Ô¨×Ýû»nâë3ÇÎÍµgµ÷R7è}öå6åB¬ÉÍ¦¾lê &s7Èh=_ ýøcj\rü¾ö7¿µkvµx}q²Z¤®O=üìËôgN]}ö·vED>FlÈØ|Í¨ÄÜ¸qãÓ¢%Ë
¡±vàÀ¾t°­­l#FLÓ§ÏÈÏð:G2$ÝQWËéÓ§R{Î?cÆ¦MÙ$ë¶nÙl¯ÃC@ @ @ @ @ n8.ÝÊòþ¼°ÍùhàK¨mêpð[ÌÇ_ç8t¹¬`æ2rcÏ¬6õº<uÖ<óëxë62.ó?ì©×N¼6ë[ºôwØóì_Çëg4½×â¢zX%¸x_FqÕ~7áÏ¦ÉjñC?#â8Ö_×'Gâ*«ÔVrËuGº[5KºfvèiFs¬E¬ýÅ¥¯÷Þ\äXËy65ºçy¾à¾>ô©öðÝðÒÓgÌ¹)S§¥¹ó8ív\³útæïAù8â°a^ÊÉ'ÒõëÒ@ÚiØ=g^;z$mÜ°^W@ @ @ @ @ À
bálÀEA"±©zÌÖbwãè\n52Híöjõ¹I6û(£ýaÇÜõÓ§|®»ý]ùØÐzpÕ{¡1ú¨
6û3RyHÝÏõè«ãíßÈº\Xê)bÂXÛõ÷xt=Nè$PpÕD7¥ÏÅïæÍ%xFóõ±Vlä»qbë=´æg=zktÀLËjY/.sckzö'ÖþõN?üöwmÌûsò
òµ#vtO§Ï;5k!!ÎXFÄþèögëpNMtûgµøí×ZÓÚÄKõ¬Í\|#ü
:5º5Ü'1Ì©UÇ ;'¦ÏBþ¦w£lD½zènµ8W'¯8ò$Ôì¢«fdñk,s×ÕÙ:±ëÕ"ÌòíOlýâbgiu}tçæ0º×iý»ÑY{3=c.¯7$@ @ @ @ @ úÀÉÓ£}ì9}S¾81§ ±Õ"ØíÄpaçwÐ®_±ñØÃgpF~#«ÅÎk£u£Û?«E°ya N9:{ÁNßz}öc´®=¯ýÌ:¶a¹¼fæäÛXûcï¸Àþx7ébÝ¬%®^°ºLFH- ®k§#9ÆS×<r¸ð×ùyÚ×åº%Õ\ÁÄ!öd¤&#õ]·ù¬|û·ægWbÈAET´#B~ÝsL/¸ï}²ýà!ü!@ @ @ @ @ @ 02ibzôá{+ËSy«T\üºü|ü±pjmÄËè<«{!|yæòêu¾ºuì/oB#±r#Y-sòÌe/Æ£G{ªó³¹ìQ;yÔc÷¡ë±VÎhtrq=ÔÄÖg¡P¥^µXd-ÎÙ(:vñn±I=v7¾Ô±&ñëiÝ±Þ.Ò<F_FsôgSY/=ú·ö±?#ùÖÈj3\ú#èÄ»&^||æêÏ¦"ög¢1Ç­,?3ÐoeY/@ @ @ @ @ ÀËK·²ü@a[¾Nä¡&®ààá3ð1j#@ÇÎ¨]yÎo½²©äÑXû¶utû³6ucêsÅ58§'ý[ëÀ§°yýöd^ëyZj¸>GbÖþÚ{<ÖéqRK 5¼Ø 5Y(`°ÈzÓõ¿" Ì±SnØ»þ¬6{c÷;=ãËjs=­uðaÓN_j´ÚÜvGì¾ÀØ\·ý³©)ø³£XÐ?6b»/¹ùûTs@ @ @ @ @ @`#pû`Þæ|ñ98¸	898l\ØåÐå ²Zt¸ü:qµpÊÎF{ÊYØGÎÃþÔ°¿1ØC'\öÏjY=±\ô§®ózýø×"÷þÖv-Æ»®Ú^×3®Ç£êqBÔa!,ÜÍê¢ãÆã(AµV6xFünZp°QÇèØ× °®:±Ú[ë[3»J-^×û¸fâzHÀáçBÌ³?s.âÁn|öuNÌ=Ä@ @ @ @ @ KÄÜOä]îÈ×É|ÁSÀ/È1À¥ ÌxI59
lsl^Öß ¯UìoMê/¿aGj¢;fµý×k
yÖ§àK¾eµ¨ßþ¬I ÉÁZõ§ÍoBoéúñÛÙúíÏõ1"äãwöÇFû7?«e]Øç«^?>ë»&{Ï3ææßÌ·²|Íí+Óø1£Ùgúö³käÜèÉóÓØi½õËÅÒãíéÄÁéìC­î25qv?{U§¾®Gv­N'íêÊ]ìÓ¿±û×­Û8ÖÎZåÂù3éìÉ#éØþMéüß/[£R¢Ï AsÜÆt¢}ûeäY	oÈ%äÅÚ)~¾7-­|ç¿(·oK/|éw_®½*Í¿÷ÇKí-ßùT:´íÉ¥ÏRôoz}ºûÖé·ü£töo½Èüâû'þýÄûG¼ÆÏøùÙ»ßRßâ÷øý!~ßâ÷øýáúÿþÐÛ××2~ôÈiúä	iLÉm8;Úé´ÍÌ)ÒÈ|$Ú3Ù¶gºp²¬ãÜùóiÛ}=+ÜÇ¨åóç¤³gv½në9×¹sÙâ4#¯Ù¹¿-­Þ¸¥èñåæ@`ÈàiåÒÓiÔH>ÊÏÛ1,íoçcük+[YNÌ·²ü8·²Ü¯SùâÍ.<kÀ_Î]RLæËk0êó@§#=ð[Ýü¬?£9Ä£ËsàC¨K.R×jX~tòµ?6ûc«ublôäÅ þµßþÆ2r!úÉáj]6õN,Þ»¬Î£ëÍam7P±BýacCÄ,9\Ø1ñèØ­Á<Äzu
mXúæZHLË§ÿôWëÅÚÝ÷ÅÔkbîÈîµiÓ7>ñ¢´«¹_ÿx:ºgÝÒçF(:}ÊäôØ>Æf"ü×ÿÝLð'Þ«eE~àß?ñï'Þ?âý3~~ÄÏÏøý!~êÍ/ñûcüþ¿?ÆïñûãKóûcoÞ«¯e,Þ²p^;cZ<YGi?r´L'OéàxÅÊeiÊñlÝMþî§Ó³|¤{¥pg®¥óf§±£yúO>BÔòyãý·5²ìÙJ¬A¢±/ÄÜî¹#ÎG¿)<}:}ýÉËÚ#ÆéÖLÈ½îiü8i¾þøèôø3ïÇk¹êêV÷çºÛòu,_üÃWsAàÐµcsqü#w¨ùüþã"WðØ©® có¾yÖ·?£ý©Xj"ø±#úÐ±[Øº7~ÄþÆ2Â¯ðS×'×õÒ~øçbÎÍµ0wÝ­ý;[KïP¸¿â¨Åb\,£>ÔqõæÑ¬Î'ÞtkÔ`ÛÃºÌÉ\}®ÎâìiëÅÎzÆ:·#~ÌÙºss²©øë=ctcÝsý¬sÞóÀ>ÕvðòÉ±«ð®Ù¼-mß»?o§!=%æäÚøµÓ±}/\ÊNéÅ ¦ÆL]½åçJ¾ò{WÍæY©¹óçø÷1
væà`|ÔAx1÷Çí7Ù9~XóCÙ°}WÚ´swÑýRs]>zRºå¿Ø$ç
uÀ«OÌmøêÇ:¦³GoÆA¤U?úièðÆÑãsùùp«ÿâ_§ü¶ëX­3b®>vJZüúN#ÇO/æ¶ÍßMÛ¿÷'ÍÃ¸åÛL¶?Ýô£µ"-~Ã?iÚº"æ®ÅþM®ÄÜµû¹ñáåû[/îPôÈ±céUï¾?Ê·èN"?ðïø÷ïñþYÿñó3~ßâ÷Çøý¹þ¹ÐªÇÿâÿñÿîÿ­ÿ¯çüuwÞÆj|föôúioû¡í9EÔwËêÐÍä
15ææck­¡ÏäXÏXkb¯×L.ýùÀÎEvãì¯ÍZöµß9µù
>Ü'F]#ñè^ÆÛ\¹B"§¤ÏÌáMì¯N-bzn
17xÈ°B,ÀwdBnJó¤!ëÝõì_Ânî=ïéðÌ½ÝÏýMÚ»æKeK=!æ õ¾öüì>¸ï|3åï6ØøXÑý7ÿUHã¦/ÑÔ¹=êáLÎ½ûÝÅ¶ñë6eRzìOJãò/Fü2ôæ÷ýtù%í[>Æä¿d;üÚ÷>öì?ÐÄ¥V"?ðïø÷ïñþ??âçgüþ¿?ñ!_üþ¿?ÇÿâÿOñÿÇûÿÏõÿå¯·Î­&ÏUÚ~ïùõ©ý*wæéÍúÍÍYR¶ìÚÖo¸ºÜlÄä#$d«lÌÏã¶ ÝÉ[_yW!æ?¾ûÜÚrKÑùó Zx6ßs·¤½mTûÑfågÛ
.Ò
N»qúðËÃOÈäÖµ¡6b¾lË¦b¬=pÚ:ÄPË8ú»bG<ÂÜþÄp!ÔA­O5ºyÄÚºìßø¬aFýYíPàZu]T½`6àåõ(¸l¼¶×5²«IÒ	&6ê:§·½È¥~FkÙßurÕÝ#ÂX×Ñfüä»êÀØß8ÖÝ>öZ·¿õcÞ±91÷©¶ü)ÊÚ½mª7ÜÈûï¾=q{.¦¯?õl§±ÑSbîz·êGÿ¯4xðÐt0cCJãó	0N¹q;KNµJO¹q3§%oüpIoÛòxÚþø/ºÄÜC;Ó¨	³Ê©ºSG÷¥µóÛÅÏ-<GMÎçgêqÚâé!æò	¶;îû­VH:_ÌÍð½5óo~5bnÒ{Òü{ÿaâ£HMjCþ)Ç©ÂaùD^OdÓ7>ìX'æ~÷_ýjþ«wíäw?ÿóý>ôéæ§þðg?~ù£ÿ¾è­_"?ðïø÷ÃûB¼Äûgüü¼ÄïñûSüþøSüSHñûsüÿ!þÿÿ,o-_^êÿ?·,çºN_yëò4iü¸t.îúÊOçÏ§.¦±£óggh:	Ã0:sÖÏø{·´¸û¶æóç{úùtìäÁuVñf#æ~ ßYlT¾%g«ô{Û«îN<§Óm§ÎÉ'Þ:ÿ×åO­ÎÏý»LÙ¯~ä6îlÆç¶õ)>NÜñÀÖ»ñY/·åâ)¿Voç¾ ÛV¾GhãK@Ìqbeg¾ æøUBK~|pð	ØaÎm'å9à*FyëhÇG.~ÅÖÇßá:¨Oýú³.üÔ°¿µñ[sëPßµ¸Or±¹NâáQìÕRõú°c×Mb}æØ¹°¹ö¬ö^ê½Ï¾Á¦\5±±ÁÔMÀdî­ç¤bL­KßÁþæâ·vmÃ`£/ /NVÔõ±'#}rYþÌ©«ÏþÖÃ®èÓÇ
ÓÇÛÓº¿ýíµÌÏ·@oªlúÆäs=ÿ%Ï¼uñù_øÙô#o{Sú±ýBzòùµú¿ÿ®ôþså/~ÿÝ8ÙÁù_|ÿÄ¿xÿ÷Ïøù??ã÷øý©þ1~ßãÿñÿ'NÆÿo¼ÿ?×ïÕ/þöWßÓ¼÷yg¤ÖµlÚ¹;mØ¾«ÕÜåüsÓY3ííiÛ}]Æ¶:n6b®^ÿôÉÓ]ËSo9þ êÉu:ÜNgÍ½rÕ-¥Þ±üÙÇ*¼Vo~ÅXåµûN¾&$h-£FH¯¿sUþìrP9EÇsþ<GÜmK¦ÙÓ¦nÉAVáF<Ú¨7§[kÜ,óëJÌ5neùÍ|AÌÁ%À#È7ÀÀ#`ÇVsò.äÉià'®®áu¨Ç¬ÌürùÄÑÃ<âèXæÔ²í·yÔâRwíÙTlØåR#×¾æa£>B<}uNÂ\;5Ô­Ë×g¡p¥Þ°Ñæé!¸ø 
.ósþ:Y·½³Ã·ãÉüì¹NNÔ7=­|ç/7Ó1çÆ Ä/ä¿êLºóß]Lw¾Èo ÐFÝù¿ÀºûéÎß?ñýß?ñï§»÷î|ñþïñþïÝ½Gtç÷xÿ÷þýÃ×s:dHâgµðbÈÃÇN¤Éùô×ÂüÜ2Éºg7lN»´×á]êo¼çö4røðrºêkO<ÎããÕÉËã6;öî¿$±<ËíF¿÷TÓ?mÒt÷-KËÛLò¹Î¤&ß¾»z]:tôX3lÁ¬ééóÊ[>óÂæÄ ¾k%ýô
tlô@ìe}íÖ¯AÌ±¯<ñ®ÇsÍcN<ùøò¹ì
=¸ê½Ð}Ô³k>s×H=ngÌ½æö#Ë÷:¾ÚqMÌmþÖCéðgK._¾6Û8
tçú²©s899ìèu#Äb7ÑÚø{ÈoàÇgã¬¡\jgrS¬m.~û»Fb­I:us=ÌÑk¡è³§ö·_ëMõ±D47ÃHm6âÆÙ<6|n$«E\c
}ë|jRZcóµ ßÊò×ãVfÏL3ò}æ{FoÜ±»G÷wæÁÜ_Y·uGÚº{oÑ¯öåjÄùõ©9ns¸óÉ?oí/1W×^÷ßI'ílÖ®ñ³V¤Åoø'ÅthÇ3iË·.z÷ÄÜ 4cå[ÓÌ[ßÞ¼-ã¯þ~:¶oC³ôwbnP¾âÍåâñósý¾o#Ê­¯ÁC§;îû­â8°ñ[ù½~fßÎ§ÿ"í_ÿµbÍàD6~íÁttïú4bÜås­ÄÜ ÁC¡6zò¼sáüÙü¼¹ßëð
®z£è¦ô¹xâÝ¼¹ÄÏh¾>Ö|7Nl½Öâ¬G/bíxiYí@17¶Ö©g¾ì_èôÃo×Æ±?'ß:§aiôiÕ©IÿùZOÌ=òb«0²
[B"m¿¶ïO^sÅÐ/¿þñttÏº4eq¾
[BöDÚ)ädËÃ·¾ò®ÚÔ©Î¡¯|¯ã£\ì/1G
Ï \¹p^9åÑª@Èñü¹õÛvæÓ~5w9·tÞì4~Ìèæóë NýmØ±+q{Ò.o|åñtï§ÛüÊ·G§'WjÎ¯²bÆ4eòäôèCû`®É7'æxaá$²ZÄ\;1\Ø¹ä´ëcDäW¬C<6æðg/ú³¹Ôvîh]æèö'ÁæÅ8yæèì;ýëõQ;£uí¡½sXXæ1
ùö§¦ý±÷K\`H,¹Ië&]¬Ä½\¼#ÞZZ ìÜæ
®#¹Ækµ¹ð3v&®Ëj®<â{2Rú\ÄÏzÛ¿5?»ÃXò!­Ç_÷äðûøÐ'ÛóÑfeíÞîÐ×Û#ËãÇN'N.kí.#Üw,_&åãÎÛ÷îOk6oë.|@úxZ-/æoüÃìfÁCGÛ?Î·û<{²kRözïoX&0/æÛ^8&]8ÇÏ+1æ$.§èÎ?×ßù/×{íÑ/@ @ @ ÀØQ£ò-ÙÕ tìäÉ+;6Ðö;öÃË6:?SnX>Á'lGó-29¤ÑSá3á1£G&Ç§Ï¤Sùêé£zÚ#âR*Ä\¾íé£ü}ù
jrøÌÃ?ÀKà³Àf
DbsôðTÃoÿZïLâZUäy{H^XìØ\uÉA/ûgµô§6>A%k#vëØ?ý©ëÉ<×aòúû
1Æb#Ë¡[G4èDóÅÀ)ø50u|£Bãk½uòwNíú>ë±.t_ttú#¾ÈèØ×ëêæý©cbÍõEùsÔÏË¶@ > ð~ðu}Èºòó_|ìò$´@ z@¼ÿô¬
QÅ¸xX/ÚÆÔ>7â|¨Oq^oØúÖX«:ÞÖh® Û«~¡°WÇæiÚNÜÿÏÞ{ÀÝUUéÿÒ{¤ÒH¡7DPgttgQ@§Î_GÁ.Ä»óuFEqfPGG@i¡'H#tRHÒþ×÷ÜûÜ¬÷äÜ÷½-!e­çÝ{¯½Ú^çÜsÉ~îÞ[¶ìá_<JxäüSB'uñ¼||Ã£ìfÀ\­,D"
ú 2I_¸¥úÁ<¨¤Âý²I]úV­`4ÒAºpd á;Ô½-ÚýúÔåüÃóud!xøf>þ}¿üK¢T?:\ùøUÉx}ZÅÒ~0HÈ¶J?IOü
`.8uñái\Ü~äDð!xªc>6¨¨ÃÃ$=ÙJùÇýÈÊ?ýð!õQ/ÈzßôCò/YJðívyûè*^|A6%:¶âÎû/ÅÄk#7K
[£`)ÕGðÔ!/çOy}ä%C]6|²åCvi£CrÕ§¸)Oé(^øÜxøÔ±'Yµå?ÚºÚÒ1VÖïÇüS¬ÆB[ýÄÇ¹Ñ^òÖ×®ß`Õ 2Ð¯_ÿÔµ[·´k×®ôôÕGÿ¹/¿ìGÐñÇo#wÍ9§¥GtNÏnÛ>zÇÙ¸À~Ü8²W4e`ÿÂ·¬ßº-­Ú´%­Þ¼5í¨8¾nüètþè£
mÜ<QºuÉÂ¾/Ïæ;3 wúÕ©=c_°gåN¥×ÑÄxë;qÈÀ4²wÏÔÏ&í·îÜe¹ßf¬ZÖláMÓ[N0Ð=æ÷G³t¬Ô"VÄß¢P	3S÷OÃzé+V¥ö¼÷åÃ³®Í;w¦»¯*;àx~ü÷<µ:=g?(¢cúõIcûöÎºVlÚ{zÿøÒÝÒgÅµÈÀû/ÞÿHQø<ÿþá»ç#öÝsøa¥þâ©K'þ°:½ªKGOd 2D"È@d 2È8`1w=[Y.³k]`Â!¬ZX Ws ¾ |##LRzâ!©Ä:Ò£íI¶e9ùGNv¨ãßc+ð¼mâü£OmduøÈÀóuÅgì6º²§øÐ=_ªýcÍ-²£!Ãå¼CMBºd|I?mÀLüX5ã«ÉSBª+6ø~æÃ×QLÈ¡K[þeO¥d(Ax5&ÉQªÏª,<=ÕÀÜ/±3æÖïRYtûá>}û¥áÃJÝºwÏ¢Û¶m[;»öÉ²ýpHR
ø"éÏ¾äÔ§+»§´ÎÀ¼+ïzH] ÔµÃzvO¬æùÍüÿZmÔªøkóV,ÕLüXlV¿8ª½Çý©ÒICeîX¶2ýûÜÎúÚópµ=ÐÜµÒ7fÌ.{¡õæßÿ>^uuîk^yôlx¿Y¸4ýÚ®ý<0Xø/3çÔææØ=ý¦»§£ûôJÿtÂ±©w6M(¦üû§X*¸È@d 2D"È@d 2p0d ¼b`n±]1Ç4XD ?ÿëWUÈ!ùì	»MÙõzÈBØ$CØÉ/»ðá±î
y:\¢%þêVÝ£.YõÑö1Â÷­	ãÍ3J8ö$AéR?«ÇüÍ¶f%ÑÔ5s)=ÝpJú8ì@$ÙJïY%RºÚRñùÄXeuuéQ"§ØikVß´å_c÷ã'ÿÈ¡£~ùW»ØÁ§M¼òO_iv6¥nVagÌýûºX1G^ö ^½ûd\¥Is	0§LÚåµ¶ÍewÛ®ò@æFÙíÆýtÞÙ
ªaeEC ±«A(hä#ß^×D2bPJd lB´¥/oC}òìIV6áûÑÅ? |.dàKNþÅ-ù=¦Zy °IG~¤#â#+ÿÒC´iT1GJö¤¥£ÆìÙa æ
ÓrÈ1t`nhîé5ãFe[rÞo¿?»ã<¸{m;8QOÛs¨­:oÔi°éCLþ-nÈ:¹Ï}jêe«JÔÀ*5|Y
gÚÙ~°Õáý©ÄÙo(Ä9x¿~bia+Ä ?i[
rüãxÈÐÖ¶ü#³ôÍR)ÜAv¬;ëGÝÝ»mÊ>ýL"(pì¨_}´~ìÉ¿lÓ -;ØW,'ºð'òLÊÈU3ØðñÁü+näD²O><ÅnÕúÉ;¨_{·R ²I	Á(ê3VdÒÖ )eO7HýôAñutÑè×MéÒ/Û-n nU3òöOJ~ÆÉ%ø§]õÉ¿ìÁ©ÿØPei¦/¥^VÀe¡F:¹/½ôôlxmãõE{Ë	éÄ¡Ût»MæýÈVÀ<´ªÈÐÙÅ&¿tîéMø2ÜÃ&Eÿ½`qbBUÈ~iüÿ]Ä{|7±2èâÉãÒpåè!,þkþ¢=À)<~b¦ÂJ À«&ÙcÜ ^ ®V`îóv&×N:¨MÈÿÿÞ>Û¨ç>*qv¹¢5þ­Ã¿^>ôÕ
Ì\cçìAÜOOÕþÔÌeÏËg¹cÙÊôïsLo:ötÖQC³¾+lÎ<`vì~ém'Ø*WBÊÐÜòê¡I¶%¤è{³æUÀIìS
ëÎ=ÃT­³EÀ9VÀ}êîÝÀÌ¹#g`¶J¬fdËÎéÓ¦÷¬[u²X?uB¦Â¶ÚÄ¯ðò¶vÙ¤îõ¨ ·¯©`n­­LäL¶Ô""qÀML£< ©sFKL®û³Ìé7x2IëWÐÈO­ÀÜ}ÞoàTí+Ù¬ã$&í¡ö¹·x{¸Pg+AÞqâ±U%íYÜ½{êd+zò¨Ç9Sós«Á=møôç¶Òp Ô"ÀiÀ9@:Q~bü[eúíK«Ù|¾$/ÿ­l«f ß{Û½yÛ|ÑImbâÞæ¿Ùûß,°Ó¬¾òüwÆî¶W s~¡|Æ í"×\³×®·Uwý*[ÏJ_å:ûL_y×CYÓSß9'½½¼úíj?iïzùêk4~Þ;:ýøÊSV¢Þ<BÍþä}¶ÒvLyÜ_<¾8ý}DÍæß¿`®Ùçq4úýnGÀÜ©öL~ë=Æe~WþQLþý=O|ß_eÏ¶åÍ÷ÌùlE=2D"È@d 2Ü(¯{r] s`	àÂÀIDÏcÂ]´rúó6Ô¦ìÑè/,úÈáCzÈÐÇml	Sñý²¶¸TWìÆÊxðå9tåWzð°!Ï%¿ÈªD[|l¨.»r
T	Æ í,¨>ëÊdéÇ´6u0À'ß]ñ¬|áØàä[È MÚØáIO±"ãíø¶üSB¶ìª¤ßëJ>2²¡Xe8à©ímÀSlV­ä´~ÍÝ>@äyÔ U[RÈÐ'>mn®äèS]}Òõ>¨CÈÐ¯>_Òù~µñ¡Õl²¥êº²©D)YÝDx¥où§
`.KCüD"È@d 2D"DÜsËlÀÏÙ%)
.paÔÕV±2¢
57g÷ô~½ÓËmËR~X `ü©»gd9­(Xeos<;óÊ;ÔsÄÐlü~â­;w¥«ïÖoÝ
`®Ùçoos¤wàNVùìÜ_sß¬ìÍüû'ÊÈûØfßÅ¼#Ø¸{Oëý×vd 2D"È@d 2|8`@ºù×_l#[hcà`
¬|H|d¸àsi¢K|õQBÂWdyx´Á3vKõ«4vf[m²Kºü#ÁÓE9&¥G±ÀÇ¿[ð)eW>Ä÷¥µ¥
°nE§ `IT°¤ð$U¯!/[Ìø`µeSºJ®Jt%¬ô°ÍE?e).ù ¨¦8ÐCOJlRbyémùÏë[WFÒ¡,úÌæÊ%¾÷ÙÓÚ£/¸ä­?Z·~ýAd ¹Ú9Î­aÅÒàò§¢´î²ý¶ÍÛQ½xÛ_1W¤/lÁøô­bí³ò` æHÖp0d@ iÅ¹wÙV~mK¿Z¨è9V|ÔVU{8ïmÃ¶mP«§ÏLOèñ{­ÑðQ­²`l9	Ø3rX¾|u¥]
¼¬>Jñ4ÉÔuøâ'=µÏ_ÆÊôðÆ¬üæKïºüêñ%}´EAm|rá?oÇãOÈ«_>iûºdJdDyÿâ×\úÁÔ¬Ä.-J2Ò[¾M¿H	 
ÕiÐ'=úÁg p	úÀ,àÉ6ðáâÓVt±%ÿV­à*òO¿ba&²E	OñÓFVþÅ¾ue²ô£çÇ,$ùG¾ü3ñ°-«6NlR"Än   8úåß×-UèiÙ7><Å$»èPïbü[5ómúTtá)6té/;òo¬ìjeâô üë¢M¿÷«ØáÉ¿bSNÑÃ~7»FÚs7Ås¤$hÉÀþÌqN×ûËÛw¶G^~nÀNÐþy­®ì3}Åªô»'W&¥aòb8 oºØ¶üc»Qès÷Ì¬zÆU&Pã¢q©rÛ·fÌN0ºØÖ=áèÊ¶ðbb,E"dÀ¿ø1À­¶âÕº¬Ò&ìØB¹Ú·ñþi$ë¡D"È@d 2DÌ°3æ~vÃw/²èÔ w 7 &LXúº5³)6aèAL»Qç _6±ÁöK`ð þ©Èé´»q"ëÊpä¹èçÂm|RÇüÓ/ÿÂeä~ù§á?ÍX¿²ääS2üdàÑn@ÃLJ¥.ÙT,òºtÙ@GúÈKNIðmêÉðþá)yÔ±C¿&´LÙB¢ä&#ÑözØ÷mÉ#I}ù§T\ðåß=üã'o;ÚÊò'±bN)rÈÀþÌí¹êÏ Ûþ­mÕæÏ6dÛÅv[ò±­*[¢¦ÛÙ]?¶3¼ZA~b¼ÈÞvÛrîû>fÙù"Îhä¬F(&Æ(#z3àß?ÿ·hyúa(bëÞ¿µóÿt®¦ø¾÷ÏFÔ#È@d 2D"ÈÀÁò¹7Ú(ØµÍ.DR|LYá
A/Oò/ØC_øuñä¶)Eø¯lÐÿjòøRØ@N8>ý,ýøßòO|H1¢S4öL¨?2^l5ÙPI Ô$z´á°O|ÆÊôhìH[ôCÒQPúÑ
8úd¸¨ë¦SÇ?¤L>¤xÕÆêÒS^ä;ò¬tº[ýh;cîÇqÆe"(24?1Þ©o$k¡xÿÄsD"È@d 2D"µf``ÿþéæ¾£­,æÀÀ(À¨s	g¡¤-@órÔÐ®Ja^GºÇ®ü]HYü{RðÁ¶ðÚlëñ:òO$ya*ðñ+YÚ[yñmü(NÅìIG<d$¯nÂy³$I0
\óxùD¡§ä+Y$²ØPòéÆÊäýë¦Q"Gl+FÙ¢ðÒR±aGö°!{V­èÁGN¶óòÈáÂo×r<$ÿØd©c`n´­­,-AÈ@d ÙÄÄx³ýÈ@d ÑÄû§ÑÌ^d 2D"È@d 28ô2P^1÷&ùb»8cWÐ@pJ+ìÀà;H_:Èpa>²²A>á)ðÅó:²dà	§>«V0ï¾·­62òOdàqÑf\uÆOxêG>ùGBF>i£,ü¦IN1
AO ²\jÓ,¶Ë9ìÒVR$ÿÂa¤+YùE^þ5tð
³Aÿ¾_þ%KÉQª®|üÆªd¼>­bi?$d[¥¤Â'	þÁc@È+±èpÁ'yô!I:|Ù ${Þþý
:|]ÒÃu=tÈª®8Uâ_>¤'; ÄÒÃ.VÌýxíºõV
R}Oòr~ðÔI×G^2ÔeÃ'[>d6:$W}"9ùâÏO{U[>(!øø£Íx¨«-ceý~ÌÈÈ?uÉj,´ÕO|¬}á%o½qíú
päÀ±x Yú¥'YH%þ<mO²-;ÈÉ?r²CÝÈA^6q@GþÍ¨b¢x¾®øñåWö|Ùó¥úÑoä°!å²-²¡!Ãå¼CMBºd|I?m X%?VÍø*Å°æ>¤Ø¨#+òudýGþeO¥d(Aÿä(ÕgÕLêÈ@	`nÄØsëcÅ\øpèÑ¹sºúìS§¸úËKÒ­KV´é¼üä)©éoÜ¾#]ÿðÜ´ýù¦ßµmìïïsG
g³yÿÈ*)ÒÕÏ'ÖÄ*«Û¨K9ÅN;¾iË¿ÆîÇOþCGýò¯¶Î¸3àcxåì@ÝìagÌýûºX1%¤Ú.]º¦Þ½û¤.]»¤Ã?<mßº-mÙº%mÚø\5à »æ¥§u8»¯J7Îy¢Ü5çzÑ9=»m{úèT^(möÓÆ½z¤)ûF÷¼d½=ÿ«6mI«7oM;ª ¯?:?z7àäÝ<Ñ@¦ï?ëùñ¢±lÞ±3ýìñEiúÕ©½O¾`ÏÊxM§T41ÞÅúN20ìÝ3õ³Iû­;wYî·¤«Ö¦5[Ø¼czëñÓ	fºÇüþhöZ$Ñø[Ê!a¦ß9QS÷OÃz¨{Z³GÑ1ýú¤±}{g]+6mN=½ü@iHnéÊ³NÊâZdàýï¤(üBÿðÝóûî9ü°ÃÒKGOqÌÈÔ¥þw±P½ðýS,ÜÈ@d 2D"È@d 28Ð30°;cî;æ¶ÙxØ¶8¡w [n"A<J¼B]á\ðÀ-(¥,uÉàÿÂ0äßXÿÔË ¾SìôaG¶ÕfÒÉÛâDNý?ròMr´éøÔ¥kÕ¬­<"+ûè6L
ªaeEC ±«A(hä#ß^×D2bPJd lB´¥/oC}òìIV6áûÑÅ? |.dàKNþÅ-ù=¦Zy °IG~¤#â#+ÿÒCs£â9RRL;Fúôé³É­<Ì-]º8mÛZÛäx^?Úûw<07Ý3iîºâ-_=·)Í^Û¶OÀÜJðýÌôû÷@sÑ>|pºdÊøwÏ&Þ?|Qº×V`åi¸­Ðxñ¡öñ¤þ*A20÷´ß9;5Éo+ÎìÅëxO`îìÃÒkÇ¶ÕzígbÙ?Ùê·×¬K?1Px}íÑg_rJêc?,Öwå]µ'Þ¦ï{õìXÍó'µéo¯ÑªøÛóÑQ_3ñc»Yýâku+>¿­i_Úû©ÒICe.ðèãUWç¾æQéGÈä~³piúµ]ûy`°ð_fÎ©9,ÌÍ±ï¤oÎ]ÑÝ§Wú§M½»ð¿ÅTôÃbÉàF"È@d 2D"ÈÀò¹7Ú8ÛÅêLL21e%ÐHxmaÔ%ïëôKÎª;^V2òNæêê£ùV)yJÕ­Õ)!ô!aJÈA²II7ùW]8²oËt)±¤øð-ÿÈxòOÙ0ÉxÃÊEaÛDó|
3Jï§®ªÎÃ%ùÒÛQ1PG_&èINzð¨s)NÅ"ÚÒ³jfY@5ïKvàQIVmÉù6>ä»ªw·ú æª¶e·nÝÓØqãÓGha©ÉpÒíÜ¹#ÍóXÚµ³ýñ¶Ö£u dÀsÿc¶\µÒÌ²	Û3ûé¼'³áÕ:±¯\ü~ñrè«YX¾Ä ¦¿46ëÛß9¶á|bÃsiÉ³{[ùñ¼ærp¿þÐì´qGiO_ÊÞb è}+¢~bü
ÃKÝ9S·Ù·/]m]ÙÇb;v`¿ô:Û´úåñõÏ¤¯>øX»ar¿¡U¶
$|	l<ðm{	NÁQ
wñéVMÙ§¼CqçQ¿úhpùÇD?²hËöÆ.<Å<8üX5³
ªnE§ àus(!ãòýn>U3RBô`¨R9â÷öÑpeÕ,©ypKqJ9êJ¸ì#ºøñ6­ÙÆ§ìPJG¶åÅËû1Ðo.tdKmce1jÌìe4úKÞzãºõmÏÇBðP§aÃJC
 ÀQÇôëXqÃÝõÏn××ú»î»Lÿù4y`ÿÄX³ì<+­êe+}³U?}º­WÆÙÏ¶ìãª>fv>ü°ì|­Õ¶j§½­÷ÛV[`FÅÅx&ôïkçuÉâ"'6<[ä®e¼Vs»6®ÔËVÿB[ÁðL;Û¶l eCÜ³?³38û­³8ï×O,M3lä'm«Mì#7Ö@¹÷:jâ¾¯=T}ÅV=ÀÀÎ {Þ AÎ²+"-hÝÆ.Oy¼å3ÖVYÞY9ò¨ÝÁg+OÑ[
V :»Ø$òÎ==;G	_&$ý÷Å	aVø³ö~iüÿ]ÄÊçÝÄÊ 'KÃ
+ ¯.0fFLp,ØK ]«¹ÏÛ\o>n|:iè 6i ÿ7Zü{ûl£n?ú¨ÄÙiLäÖ8Ê¹yø÷Ox­û>?ÜOO¯¾j´`î({^®8ã,Ì;­Lÿ>w¡BnS¾éØcÒYG
±ó ¡f¹f?bhôûÝ¹SíüÖ{Ëü®ü£üû{ø¾¿ÊmËïóÙzd 2D"È@d 28¸30 ¿ô³¾{r±]lÇØð +É4x_ÈËÑæÒä%:ðÀ)¨ÃÃ$_²/¾ì×@Òá8È·+]éÑFLDúôAèsÉ?<ð°#Yx¥øÞr=ÅDl
 Ê½ìüÄ>ÛíÝc+ëD=Í>Û²Õbß2èÇø>kÏO{çAùú}ÌiÅ¢?ßMc ù`øcLZó§Ø>ó6¡­ñ£Ë*Äëî$]}ö©SLó\³çõÓ/>¥²Ê¥"«¼ûéékåm$yî¿ò`õsûrªí6§x~©P-À7võKNÉÆÊûå=·Þã»ö¨`6+X=ñ{=ÕëÕgÅÝçì9Ð9i_²çBÛLÊ&g£}üÌíy8<±êç$¿¥eã»­|F¶XÑùµóÎJï¾åîÊê×V}~õßñ¿û¤)i­¶såbX:ÀÞEíóõË~là9ÞMÕÞx|É?ÄjÙmke¨Ï_£ß¿ø¯Ì½Ê~hÁ1ÖÛ9î}jMÖÖZ9V©ó#¾¿ýX±À2ed 2D"È@d 28ø3P^1w±t] süüDõÒ?KÚàÂ9(çBVÀ0
Ê|v á4ØàúÈQh#'E>ñA>ÙG¶b¤
»ê®W]vò4¾¼eàþpoK¶âdÅ+ñüyhm¥ÍÍvÏÀÍ¢ÜÔ2±ÏyYl§Ç³ÀoGT0g«	Y
Ì}ÇÎ½°§ÕÅø`,E"È@d 2D"C#åsæ¶Ú¨Á ÜÀ2ÀÅ¨/|:Éòvy]kV0õ¶!}êØ@
ø¶M"V£¯¼ìúJËo~Õdëå·°ù¸TDÚù|ÓÌº>üÇûm+»Ö¬ºøüÿÙ{0¹+í¿@9ç Ê!@"ÈÉ9¬a×66àµ×9oôûóãÿæ]ï·ÓÚkp$;,¶×L"gPB9£#üÏ¯zÞÖîNBóøNU:é¾·§eî;UuÉéµvþR×$¬<á¸µ¶íb{â_ìsþÕn»4>gwî®¹ÖZ9¿Í§ÿÖ\iÅv·mRÚ^leÇVË[ÈC^ê<¬pÖ[¹J¥y4f%ÞÛì\«Z|ÑëìÀ[í;mÿb|'øU;
m @ @ #-+æ®²{[h×V»àDªù¬p¼VãBÔ§÷kcÙÑ!½ìÅoIöÕXóÊ¡üØ"OßÛSlñcüôxq(è8èðC|>Õ£9o¯ü¯ý1±%DÐz½æ«nUDÕeSþFé_7¥9½n>ó\Ø«¯úÓ§Å_7­l¬ç5­â9å§x"Ó¬ëÑÃe,[ß'òc«|¾¥O>æ_÷ÀQ~V¾!Þ§ )ä)íüÝìg+æns¨|)7~Â¤Ô«waÛ«]»v¦ùsgÛ¹rú.ï÷rj_NbUw·ªýí¥>²Ü^$rÆÝsë6Ø¶b{ò9¬2°zß	s*s*ß·¯åÕ9_²ÕE¬ø´måÇ/I³äNÌ	Î(Ù§@H¡ßf«ó~½`YºÛ¶z;/Íz±ïcÖBÌù3\¹&]ûÌ|ªØÿÓSOôÍcÎ>ã4/"¼N}¶·ûf/´³zÏ×9#' ¿­ìJ[}Çê¥¹Ú§è_{2á,#ÐÞm+©:^svÏñg/óÕê¤EÌñÂ÷È3k7¤o<þ\¹2Zé­¿YÏ¢ê©ßßL=þï°ßµóZÎûò#OÏÎôqKû<¿Ö¿)¯°XG*'K~4ë÷×sµäoÖýs[þ³ôGÉgþ
A½Ù~Y¼¯äû«Qb®¿zÿýåK9~ïX1ùáéÇ¦N|)<¹f}ºúÉ¶+Éý÷O6¬ðí0µm2ÿwá©ý1a@ @ @ ¼*hY1w¹Ýì2»ØÝâ à&è£?N	sø@h¾æécÏÅ<-¢yâÓçB¾òÓÇKr)¦ü
ÿ¡[§ÚñW
rÄR®wr»Òóóf§=MÚv°BÚÕõ¾lÆVl?Æ6dÈ<#/¾þØsy¿¬p?<YQ+·UB¶­¿pö)yÈzåÓL9\90áËàìÃÒÇnE2qnØÏl{K7m³^ìKR1ÇJ¿´ïH{«´ØÎMH)1çïa©Ï5¸g÷ÔÍ¶õ¤?oÃæÄJÌöH¹ãmWHa¶jG²}ÏÞôK[ÕyÏ²FfJÛºõ/ÆÙvîÏï,¬xdâ§HìHx1þ:Ûô-¶e&Ò1Íü&æ @tæ_HîJÒhýÍxþª­úåK[?++!ÂÎ^Éï<¨ñG½Äÿì7²âµÞüÍºàò÷òðªÒìuÒÇMÌHú3<´sÍøüÕûï/÷á9¾¯¾h«ã n=®ØýÆ¶>ýmêÅÿx}iÿïg>ÖlßX
»ÓÅviÅÜ	o½Ä¡ÐçSáçÑñÚ=}4DöÑÓöv²¥E¾òÓÂuhLLúÊoÝ<¯|¥1{ùâ£xN¾Ì!´\âWèñ±¡ûÄ1±¼
Â¿:}ZÝ~8åm,ËmeÉÉ¼ÿ±ü1ºo4&¥¶ß{ºüÊ:çRS÷p"ætãÜÓ'JçWJ?ßÔ/Û¾8üËðF^ì+6m-Ä_	ÉªÏÙª>^FÙê¿ÏØçßQ¤ûØIv~â ¶Bswúla«>N¹þ'N¦ê_"÷L#ò~n/Á·9×¾×WÝíø?Ù9ØðbüèÞ=Óßyb6cN>ÿëv?Sê@s<·Ö^äÁ^èw$Ößç¯ë©_¾´õøk+?~òÔâûg=^×ÙõcÍúý­7³î »Øjõ>ïT#:çÖ[mU,+±÷Ùïß¥«dñikÆç¯Þ©ßs¥«Tõûò§æ¤GWïÿ÷µôû§`Õú'Äòù{Î\pýÂmKkIsB"Ú@ @ @ 
[aR@ rãëÛBÊín!åvú¤wPïÁfsï=~R:ux«´ª3»Þ<atñãæíüsðròÛ¶k¯[¦Ä9T>å¸Ôµè¸æÙ­V}7Ð99ÁyòGvÛäý¤Jº}f~YÛ¬ûÅÀÖ©Ãïógd/¨«Õ®·­,gÙNFÆ}ÜÈ3_{)1ié+RmöúMi£·Û^èï°-h·°¥j	Ù§ø_¹¸°=*cV±m%gEU#¥/ÆýçUT¬ziOôbÜÿqÞW}¦
ô7íÇÌK côÄ!nX½æ­[Ì^>ôäÄ·ÄG¿4sè¤'/1Juº/éÕ¢×F§ºßTE	ÈìVXytØ2Ö}AÌ6bîÆ æ9îSgÛ>«ZY¸`~Ú¼i?ÙP­ß²«÷Å`39Î­aÅÒOåî­ÈVÙ6o#zó1¬¼e9_¯ã¥$[0®ÝÁv4W^
=ÿ~Ùþ¨ =¹uÑ2ûC%ÙÄòñß?ÒE@ @ @ px"ÐBÌ]iw·È.Î3à88t´\èÅ3ÐaÝÜ[aQ;/¬²
¡pÝ¼LU4cÙèÆ3PU±Líi×MtÄQúèÕ `Usô±¶4¾bÚTÃ£VyT³g°g¬û§Eä§ü¹="{úÊÏr°äs71D­eêqÓR®ûWü´m;?wvÚ¶ï°CCþíüÓòÊr¤*ôgÁýå¤ö×ô4_¼àôÔÙÚßÚ~¶YCÆõëþâ´i¹ï·dl@þÝÈ%-[j
Á¶&ÛÏu·Ï%["n³Õn[zÙ³ ¶ÝhWµÒHýµ>ÿöjª·~Å¬×ß_þCü÷a	!ßtfÛSûß>ûìóùÁfå¯÷þöýË×ÌÏ_¹øètï¿wÙÕì±?ìøê%g
ðØo÷ MeÁ9ñ â5huaHø
ÈJ{­J¿°,;ì¼<¿Â/^WB-ô@ Ðþûgöºék¶B·¯eù¶IcüÚ{üa@A @ @ H·\w¶²ãíü}.ñ,´þí·¡¿|Õ»ð>ò½¹óñ"O¾´ØßêD
=g/!/BzèfÛENÐÏÎrëºuêö·a×®´açî´Ä¶Üó"_ÏÍÿb¼£¨¬àµbMºdì¢isE(¢5"à¿öÙwtpþÈ£R7Û¹ïjP
@ @ @ ZVÌ½Ûîf±]1'ÁðÂL<sâô¢+ìàÐÁ;È_>Øp=¶Á9ñ)è¥ó>lÐC§9ë9½­16ÊONlÐq1æ¾úÜ+9Ñi_æ.åd¶è%i$1(FÅS /Ø²ñsºÕ @,æ$ûV|ZÅ°"®¼½l¨Q¾]¹üB·µa¯ÇN±Eì_:ZzòÓ"ºOúÒy?ôäFGÛÝ.¹ØÊÒ	@ QüñzbÅñzP@  øþÏA @ @ @µ´11·Ä.me	éo £EàDJ¡cð6øtÂKcæ°³ÐvÒa'Q\ÆêÓJ_<|e«¼Ø+¿îòVù­[Åe¾o1":bsÿù©ÒV>äU­èü½)VÕ-
ÒR´n¢ÂE(©øÂì~!´R ðS|b¾È7ëf5¯üÔ$ ña±üÃ³añC¨Õiª9|ËÕ¯üÌ©>ZæuÊî_þÖÍu¡ëj¯9ÅWMÊ?gÌ­,)$Æãc@ >âû§>ÜÂ+@ @ W#ô·­,¿ÅVíÚi\"òL\:q"èè§`ñ$üÅkÐjÎ¾H*â1¯ôåoÝ"G#ìéçÀ¿CßÇb0àO_ùÑ)?:ßÇAGNq6øßÏ+¿li¹ZÍãÃUZ¿©j¯Í«¼µ¿,[7Ê< ¢ÿÐqC´ØX|¸Ð-sØ ²§^1ã(A~ÿC9h#qèëZ·¨§ÁFüC_:lÕWjÉ¯òSZDjéi+ænX·~uC@ @ @ @ @ @àpF e+Ë+ìØµÕ.øx8¾ôèÄ©ÀÀ;x~yô¾ê=1èKè7A'?ÅW~Zå'óØa=¢9úè[yDùeK¿²Û._ÕKñ3Øs1¦ÅGµ0VÝ¥ùËÕbæÕ	D,Q±´£xú·ó7OÀ¼?ö²¡¯låP\Æø ®æT6åìS>ª==}âÉVcå EÐ1÷C_cù*Ïû{ÆFùéËV÷ÂXóÔÇ¹1]õ×mØhÝ@ @ @ @ @ @ 84p`ºåÚ«ÙÊr]ÛìCaÝ"·¯çÀ~A'ð°e^~â)°EÔ[Ù3ö¢Øòc§8ô=AâýS¢z_ÜÆØ¨&úè±AçûªÏÔY¯¼§úÐ+o5]¢u9·8©Ør16\ ìu3Ì	lú¾ôeã[æ dòX7ëÕJ/bÍ?¢Úèc+ñ}lTóªGùO­lh±Áüº'ÙÑjÎºÙúØ ª	bnäeWÙsbÅ\F&~@ @ @ @ @ 1-+æ æÛÅsppp,}q#âD À¼¨ÂÄ·Ä$¸ÅT\ï'lèQ~ÙJ¯¸èÑkeC<×áÃåù'æÑÑrÜúÖmÓ­æûÑ{!VÝBðF¢H¤(]gõØ6,M_üôÀipÄA ³Ù|~l
­|µ¤êóÀYqu}ùÑb§Ú!7cå×½ûû@§üØá£yå×XgÜIôÄ§^åg8Hw»FÚs?X+æ2 ñ#(E s~}Ú½{øµ	@ @ @ @ @àÐG`ÐvÆÜ5"ævYÅlÛ(B¼ÜxñÒÑ"z1üøZ.tðâf¬[$»dC^òÃP~l¾xüÈïíT;sÄQl#Ò8ÊOØi{üÉ`Ç=vW~ôôåkÝ<Ö}Kññ­[TTÝZUC&®nBEsCåö¾fP(°A0?ºÒSN|O¶Þ×/ùù  çÂ½ì_:ÅR^åÐÁ\(b!òQù(¦ôØ*¿ü°eÅÜè8cHB¶tïÑ%}ô¯/h;Q¢yêeé¶?×JûÞO:u>2mÛºÛþ{4íÞÅ¿=¯qá4uúQeoøÓã.-;ÊòôîÛ-òôâ¾·ÛõBåíC/ôJ^qR1ù÷¾z_Úg¿·!@ @ @ À¡@Ë¹wYMËíÚb&^bÂ/4Á>}Ùû¾æhÅñ¶²Ñ<6êk{µôuÉ^ùñEKðCÄ)iN1Ã(¿úÄÂFâÇ!_Zl_õ[ù±ñ1ßç0ÚDÁkójk]®0bûÑÍy½nÃÏÓ êóáR¾ÒÖÇÑ5ÐÇ_@SNüd'?tô¹T§j
O!j@ @ @ èsï6»EvAÌÁ%À#o'G@Îsâ]ð§Á<v>ÆÌx`æÅaÐ"øcGùaGæ¸°eL,å÷ó±¸ÔWí¦Ê:ôâR°ÃWyåøö\Ê­ÆØ!¥'úK`W·¸Qñ7¬b¤Ó
æ¼èÔ2G_öä×Ó$lnT  G-:Þ â/½u û{TòãË>1W94§¸fR¬]y°U~üR©/¢yúC\ú£:ÑK°gÜË®ØÊR¨ÔØ89õéS %æÏ¶w5ëÐÜswüò¹ôÄCËÚõá¥mÏ^]ÓÞ½ûP(¬búë·§¥Ö§ukÚnaÐÝÎ³Ú¾}wzqßKiwÔ·÷´`îÚ´lQá<Â{¥q§^½»Ú¶[Ò§W­çÈNG¤Av¶Õà¡}òc¬D"÷uÛu:²{èP;ëHëlÝ²+mÙ´3QÓèñR¾ÝÒî]ûò¶ç¾`+ù¸¿<R+17rlVI±êiÙâ
ÏÐ¯«DÌQã¨qÓýñ)¹ÜUËlUÏ·Ú®êÑ½ÔBÌñ<¿HFïN6ìPV­·[³rsÙÏgÝQ'Øó¹gÅ+´ºfâ±ÃÒ°£ûäUlÞ³0?)'Og^0>
ÞH 
¢pn@EA"qSþ#¥7^7NK7I¤ôÊU:§:D²)¿À£U~l#ø1VýäñÂjD¯ü´ªMþèèKÈÁåï<ØhØsÊ_êÏX5âCþ?Î3jÎ;Âlß¾=ÍS8¨5n{öµsö×äp¬°f+Ð*É
äÿîWïKyH{Ä\#õ³âìÊXa°&[iJØÆyVM#¬¸4¿¿ÿº¹?ÜG½ÿ~âÛ1wÊYcÒy¯iîZfé@ @ @ LZVÌ]i9Ù1ÇKBøqôá8éç Å[[â(hKç§!¸úcìÄ±('9ès1§øäÇ
Õg_gµwJ¼ujêm+©ÙO­L¿þÂ×RbîÉ¥{~77½öK¦S8ÛJs©­¶Þzùô4vâà¬ÿîWî+l'2"¯8{êåyUÖ«·æ­àFÙ¶¬$Ñ_V±²Hâ9é èî·¿¬à<¬w:÷5õ³
²Õ¶ÓHzêÑåyRéKÛj9>'oï©E²áñ¦;5»4Tq\1w´½Xg5R/1ÇÚ¾í'!"ÙvÏÎ[Þ9½øÙãóÍ*P¶'lO:Ù¬Ç<ÂÎq­VBÌ<:k­vYTÜÊïSÿçâÄ3ïkþóöÂ¶;N^ôÌUªs2#ÝêØ7½ýÔ£gáûêg7>ö¸íÍV¬æ4Z£Ï¯ÑúõVJÎ¸pBdfÍ7çéÕyÌ,¶*ÕJÊçìX9W*ÓÜêów'D<[«BÐðý)OL}õn7òû¼11µÕ­¿ýÉ39\{Ä\£õsïøÓ$6¤µî!VÞxõ­þFñ÷÷ÙÏv°åä<û7à¤3Gç)¿ÚµÑÏEÌ)oµÿ~bß1wÎ%ÓiçSØVÏ½¨N @ @ @ ph9csKíâÅ+²Ã/pñÂH-l´³ æl*Û2Zôá, ü=q¥³nôâ1Á(±°ÁO¤q¸$òS­øø8~¬ü´êe¬¸j÷¾²Eb¨VÅ tûèTuk%­Ýs¿/Py}nPj¬R
¯Zñ÷÷¯µ­¹&|þêý÷:Ësöÿº.yó±éSFæ[ásu»Ë­@ @ @ /-+æDÌq>/
çê´l@ñ¾O]\ÑSmÒÕ9þÅ"çÈ;Çì#9?¯¤¬ùÊ?ÞSyb4?úna{B¿m¡_a7í´éâ7}K¹jgõÑÙOÌf·ñÆj>¤»åºGln}ó?üïµ«·ä³üüîWKÌ±âðáû·)ç~n&[yIþå¶lãÔaH¹ïmf+2@sZOÌU²Ú_rN¡æ|[1ç³z¹AC{¥÷|ì¬U¬+OÛlSYiµS©}éË~«É¤{ÿÍ!Ârý£­\;w92õ3r£µèm!æt^«ûþë_îôaÛôûöïÞpý>¿Ò¢j©¿Ôq­þ-øz;¿ñßuYá~ø³øn±ç¼Øýáfþûß«ÿóî|.¦Q¶ë)9þ0â
$p=+æ¨ëvn&'YòËgû¡`à\ÄÑã/Ê+­ÆÄ¶T8ì¼×Mnu~Îâì¾=»÷åøø»²k¹ß½MÌ±åëÿü¼\ÏÚ5F}½}r|­o×èóöµÖ/?µõø¿éíÓ«§£çÏ÷¢OÌñ;ô»ÿ}ÖOWì{bJÄÆ¬.Ö2ð<ïùxae¨'æU¿
ôßñèXÙ{ãÕ³:ÜÂÛzð÷÷Ù½¢dQâ"üËôÓFå~kb®ñÏ¹r¿Ã9¡ý(÷ï's­ZþçoV|¢
Åï~õ¾Vg»AÈH¶$wýfNñlDé?ùÙ2!
)È¥¾(¬hkç;JÀZ«~Ä¹{ÚJ«³sºvVã¾½ÿJÕPÚ6Z3jª§~ùÒÖã©½éW©?ë®é~[IìÅs¶Tõöê{bÊs¬>{ß'Ï)«	§3Ë<1×¬úUç~ØÎÜpf&ßµ¬ëHêÁßß=Ä\3>"æjý÷<Ú#æçßÂ¶·lÛ@ @ @ ¼<´sWXöÅviÅÜ	o²Ä¡ÐçSáçÑñ²=}½0=côÄô=liå§¯ü´p¾ò[7Ï+_iLÅÆ^¾ø(b£/s-øúÄ@|,bè>±aL,oC_clê4*ºib©xÝ(7¢y#þèë©EcõñóâÃOò£ãèâAÈb^¾²e¬ºÊÕ[]ÖÍÂÁ_ù±õ=u(¿O_cùÐªÕ);åc¬ZØmd1g(Ô!¬;~ÚIÙs×®iö³O×¥zW1Çª»÷~òìÔ½Ga1éº¶¦'m7ÎÜÚºe§mcùbêfsbäÝqJÄÛ/þüOÊ¯îÁà+ÿp[Ú·þÁC
¯¼á4xhaVô¼\tÖ¼ò^^^nbÎ5ïÙÕmûÊÉ»?tFq+ÁÒlú©Ïî_MYêÏêÐ}ïá´þ¶[ÊÏ×igM§¬<äeýï+=SL~¾®Úª¦íl[÷Æ?:!süðìz ¹AöÌßó±ÂË­·{~DeVl­¿ÏOÅÕS¿|iëñÍ[§¦ãOÃðütö¥[ÚÏçC|õ´"æìóÂï[5â)OÌá[ºzMñ<1×¬úÛ×#]{¿²¡­¯b®¿fs|~ØR÷Í¶S«»Y½üãkI/Ä¯üs~ @ @ @ 0hàÀtËµW_iH,°sð¼Ýhý¢° 7uQ
l$×MªXÝ¬ÅÎ¬¾nL`ÒBj°D©ÅGöÄ>\Ì{Eu©nZjªcìå¤%&-ñU·ü©å/õ·©,Øà`KFDñhü}Î^6séU¸~ýÌÔÀ´OÉ+höìÙ}º<yTcÈæ¯$bnÆãÓLÈ÷Â*¶¢,%<ùÌÑé|;Ï	©DÌµ·ý_Àùxw0åBÌ	/§62Í°ç"Â=[RÎ¼s~Þ®R+»^nb³ÛÞgÄ.²Ò>?7WXåõÑ¿¾ x/¥ÄÜÉ3ì³õºÂgÏP_;£«KNiÏ¸lÑôÔ£ËÒµÛs6?ì[ò¸Ng_4±ÕY¬beÔãvc&bÚ8g]4!qÞø<X0÷Ûrðñ
)hbÎ·fåfÛFïµh¢ÑúñüTK=õË¶ÿS=÷5r{oºwQî×úã@s,Ø¼ò£3ZìÔå¹fÕO\J¾rrëÏIÏ<¶¢ÜTQWþsÍøü5[gß=l]Ézöû\M.bãYQ@ @ @ @à !0h@{gû-meÉù:T\üúâ/à+à°©&¢
öËw¾|oÚ´aÿÊÖlÔl«Ôöí(Yá9óÎç[Î!"æX)Å6Ï>±²½çúìi«æNOÝº¾CX]´pÞÚÉÌõ¶ÏðÑdTÆ/ð§6JS	mø~yÌVl°"¯£³Ëü*¶.hÚ¹sO5v@9v`ñM}Fëoôù©ÚzêoÔüd#þ4ðýóèýÓzÛþïH>Ï':2^ ^¿ó{Ó®ü_ýr ¹AC{Ùj¶9?=1Ç¸Ñúùfe-Âg÷ºÿ¾?mZ_øýâ³ÁJ:rä¡{æÕ¤yPæG­Ï¯Ä\£¿zÿýäöÛ#æg{Ï+>tfên#dçö=yU­ÿþÊñ#@ @ @ 8´sï´Ëìâ?úá)àÄ1À¥ xjâ4óz9ÂK[æxyN1üÄ×Ç±æäK,å·nWQ~æU³r Ã_±hÑ©~ÆØ*¿ôò·©lË<~þþ°Eä£üØr¡W~jØò±nýBÀFA¡èT 9ô   @7 üØª_Læ(±C_áíHáÁ¢G§W¶]mNù­s;Õ/:Õ/sèGùMUÌO\j!êPüòëÄyWµ£S~Õ&Lñ#>ËQFÙs7Çs@ÒZu´½øÊòòâ/¦ÏÏ³Õ7mWK÷8xÚz_,6ãã¶_ßþ'åîÛ$Ðª¨¹r1ÐA °UØúµÛ*0ýá@Ì$+gCÙ·E3VÌi+ÉjÀ_±dcb%^ú¿çc3*~ |Yù¦ÏÏM¶jg­nC:Ù¯yëqy%Y©¿uóÎtÝ7fÙêXû·Ý¾5O>ct^Zî\ÄJ1ÊéÙò²«N.WÎyµ8Í¼ãù¢I¯Þ]Óþòüâ¸Rg¯|_ýÇÛ+MgýH#àØöSDv©1Äçí¿xÎÈå­¦©¿ç×ªÔ[¿âÔë?ãÂ	ù kÛGî_îùÝ¼Lz»IÌçâ7Wésèê­m\ßõÁÓí÷¨ðo+F`)!âÏþñµä³®S+þÍ æýüÕûï'·Ý1ÍèñmÕãÉEb?à;¬Ñïb@ @ @ Õ 0ÐÎûÉußºÂlÛ17ï o LüïÛ0sâ:ðCxBÌ+&1vÛGN\	6ø>üòãÐú>ö\Ò19éGù±!B~ñ2ÊÏ¼òÓ'¿øÕfª;Å¦à#;å
«³"ó®ßÎ¥@ @ @ pZVÌ½Ë-±­àDAJyñc8xlÅ7{N¾ø1'D¼­.lÃ0ü±WÖÍcåW,ìñ§Q~ttÊ/ìiCsÊ/¾.Duù<ø#ÊO_ùå§1sò%ò+óuÕåÜâ¤Âr3­"uØ0 vQåoP,(þºa·%®bY·¨ì¯üØIO6U¢<u/ju/´¾^lU+±|òø\²ü¬¦+'Øü|DÌ]Ä\ö~vïÞÃ¶¥ënÑ¾;oiÙmÌíGÇýöÈ[n·3½Ö¬ÜlÛ[úï×ý¶êM=ñèôº·swürvîÚ;¯îêe1×Ú
Í<!Çh}[Î:S}j§ÙV¬¦
90ðâÙCÊ²²ríÉûÿô¼ÒnÝ[ÓµÿuEÓm«ËómËKä»´Z±VÑ©Î	îþ-g±¢;¶ñÇ?W8×®­deµj-v#õ×úüÚC¤Þú³^~ÏûêºQÊ¼°zKEÂL¹hY½iÂÆ3½lRoýÍ.¸^ü©£¿Fê(çË_¶¶Ýc=W«ÿ×WÎ!t@ @ @ @p+æYÈí-ay{ÁÅË78[èÄX7÷¥£Åy¸x
tÆèt)®ør/_1¿ø
Pæ°ÑS~tø0VK?ÅW+ÙIo¦Åü§ûT]²AÏÃGð½Æ´Ê¯9Ù)¿b¢egÌÅ99d¨DÌì{Ù*«ýÅy¦
Ú*Xn­Ìõ°1EyPäÀÙ¢ÃK7F_qÄ*æD¢éa0)ð=0Þ¾¡ðÓ×£>~ØkLl¿9Å£.úzèôÉè!ÓG¨^É¡¾üòGù±³3æn3æCCc¥ÅÛßwj¸,~~]úý¯çth?ùô9yT²-°m,¼gaZÉùs-ßè¬þdgê±Ea÷ÎþºSed	@ @ @ @ ^
øú\âYh[Þ¬Y¯õJ:ô"Ôð¯ZqØ(¶ZÙÛT1Ü|i±%¿Õbÿa(¸ï£è$²§¼²e¬ºGuª|O>Òa#{t5ÉÅ HQáº1O8IW
~_`,:l!ðWµ¦Ê ùüzh´Ø1§ØªQ±ã
ºàïA c\:xùË.bÑ¢ÇV13'>½tÞG1°
ô[6~N7¢ô ÅDcÃO«8VÄ·
"Å¨XZÍQ<}ÄÛù§`Þ{ÙÐW¶r(.c| WsªrvÊ)Õ>ñd«±rÐ"èÉÇû¡¯±|Lçý=c£üôe«{a¬yêcÅÜË®úÀë6l´nH @ @ @ @ @ Î80ÝríÕle¹Ì®mvÁ!°nLÛW@Äs`¿ ÅxØ2/?ñØ"jÉ­ì{QlÅÁNù±Sú Äñ~©Q=Ê/nFclT}ôØ ó}Õgê¬W^ÅS}èÏ·Ç¿.QÂº[Tl¹.öºæ6}_ú²ñ-ó ²Jy¬õj¥±æÇQmô±ø>6ªyÕ£ü§V6´ØàO~Ýìh5gÝlÁO}lÕ17ò²«ì¹

Î¹²0»¶LN?æÏYÐß¶w­#à¼1ôèÕ)Ü2ãâlòïýçóá¸ýÞº8#à8#à8#à8guÄÜ­&vÌAÌÁè¦ø@Á-ð?¶èÄ_èØKx
.V¼âHÏ¸
tb*>óð!ªÞ8×cêbÊOaÛT+ñUÖ/:Õ=<òX7Æ$FZzù(¿êÆN¢øÑs¡SíÖm¹¤	Zî]ïÁ¢TbÒ¢c1Ss¦Ê±H«xºA§eMÚÇyÝå/óêÐ#èÅ
Mç4"óÙÕçÎGeÇÎaÜýB¯¾]Bg#{!iwí</Ü6­ßÝ¬%ÿöG.	÷¶+l
s_¨	'Nðg¦^ªª;æscjß¾áÍCÌÙ_Ú+¯.»jhhÝF¾ë1¢·aí.#uç=»åNä>÷gÓC»öüØ.Ìo~ufEãÃöÛ¾ý»vòtíÖ!Ì|lY8w¿
z±þñ©,ºþºø¥ú7³Ì²ã÷¯lÅ¼Þý¡Âð1½bæ'~¶ÈvòÅ½rÍÛFK¦¯<¿&<ûøòFo&%æÖ­®
öØu²Ë²4ÿÇà!ÃBUê¬Ã"æÚµ¯CFTÛ»jNU¶;ë\:1Ö9Ö9ß¹»«®©
ì~ûúw(%xÜë¯¬ÏÞ¹ÚÚÎ«Îq§J·ªY=ïÑ«YYxG!Fç1÷¿¸.´­lw³=ÿäòFìât&^2 Üð®ñÙ×^^^½6ìÜq ð¹:²:\sãèÀn.cAð?MyWÕ×B®msLûpñÁÑÝ3]vJ×ÓQÿ)6bPLýi¨RýÓXg¢:~ÿÎDÝåÊs~çå°Ñvã|Aàl'æÎ»à58#à8#à8#à
UÝÃÃ÷|kÙÕØuÐ.8.¸Zø+È2µùv¹°Gh±EOA9åR|é¾òÇÁ^uÊF¾òc=üCðçR~tº´^q.Ä-:Vú4v²U<ÕBmEÁK§K
JSN-XÄ>æÒEk^9RðÒüÌs1OK<jk$cúªÆ)Èé|ê¾?9ætiçkò££yÂ[_|5O}©/;æßjGYîð£,
ý®ÚaÝÚ°ckÃãó ÚÛû¬8N?FØû~ºvoV-ÛÖ¯ÙcõèÙ)Ý3tê\iÇþí
qôá8éç Å[[â(hóç§!*±£0ÆNr>s¯8l#ÌKñS>øÅR~Æìh59hV¹_uá§üi<å ¿°°nË¥§¢ÎX­¬V¾Z$cytÖ6õaN7ÊCÈXô¹RbIG,Æò¥­â¤-1ññQéÒuPÖbÝlLt²#Ö¢üÌ+¿uã:ÉÓÅ.²¼GmlaÒ¥0C°äUqrû¶­¡g¯Þ±¶s¿÷77V­[Eë#LxØ	1
Ng>º4g

"mTG©éHHsd*ë¨£ÀÐ§yÄ×;².CFÚn'Ûp¤áwþã¹ØO9v{Ýe»àÙü1ô	ïxofw»ã¾ûµç¢þ²·
<pVkÝ(<LKàBÔ§åa-\üË>±d§{ñÖ¾§ñËP~ÆâÓOíyü>õ!èÄÓPNùi?$Í§z4Ú+Æ«>&¶ÄÚT¯ùf·*¢ÙSéB¢¥9½/_l°§¿æ¨þZ8¶éò}°S<ra«üôOduc=º¹eö§üØ*ÚÒ'óÊ¯Ú#Êa&2cùd,2yòûÄ$?g¤
\p
È¼Ã¬kÙ²ySØ¼©þÈ©ÓMÌ('X3>=%Nzï£ù;éR»÷}ì0ph¨úæWfv_JÌ-·1<öÄ\ú°¦9ÞõtéCÂøIým`ÐÚÞ»Õð°YO­Ó)1ÇqvÓv<qyoüóÓáðAýí/äÑ2]996üÃ¶Üb§Ö=08)ðP÷}½OP²Áv@²÷\5%)1Àû°x8
GrtjK¤eÄ\s¸sÔuÇï_ÉIv§<|ï«ñÝ~è9¦÷"yPÞØnLlóæ{O^úþ6aÞÝÈ;ó8jø_øë¢k¡ß½3MÌqäë§ìÈ@dûV#¾Ñ49TúØûíJ½±`ûÑÒúå§¶ÿßwavwâªåþów1ãwèñ.J§íë÷¯ØüåZÿõvt#kA^~nuxî>Ýìßáªøw»ÐNçìÞw¨KßQKÌþù+ößOjK9ÕªòÞoÎÛ6óÿ;.#à8#à8#à8À@uá¡ïßuU°Ê.vÌÁCÀ)X²nôôØp¡çï ½æhcv¿`=:|Ñ­kG­©£­Æj1}åÇA§1v<}Öüi}ÄBO«¸Ê!}ÚY-c	þÊOLåW=²kq«[ì8èÆh*VT±Ø¥«¯a¯XZ ¬±b*ÀU¯ì±±¹§-$ªK9hEª©ü°C´ÄçÂ^þÔÃXùóým*|`?¤¢âÑ"ø§9;ÙxÈ-·ßñÚ¹ïÏÁøÍ,={ö
åOu¼ç]]HJÌê¨AHÈ¤\»Îb0ûQbníläýSätsÊÅî§kÞ::ßGª¸ûséüÍá9##Sb`ÖS+ÂÏ¬ÎúÛi	1¾¯Xb.=&á+íÝ­Zµ
½ì¨Ï®uGI²C<é»­r#W9âbÎüõÒì»¥ÿ¿¼.¢Qüé©¡ö~G	Xk×ÏéØ1WÕ³cø ÈF{Wãß~Y©mK­¿÷OÅS¿|iñ¿ÅÞ½Þ£4^cýÙ3Wl'q*)1ÖØª©½úåúý+6¹ÖþÅºwÿÛ³ñÝjÓo²¶ÛIwJký¥såøüké¿¬¡)byþMÈ{{zþ[.#à8#à8#à8À©¨®ên!¾¥£,Ù- AÀ%ð K}ñððØÂIð?·<Ñ|i5¶nä^°Ã_<clSöi4òÓåÇ8´üµÈ¾üðQþÔßÔqý´ÒãG<Zòk´ÊoÝl
L ÆèC-X7½æ­Í^>ôäÄøòçÇaôä%F¾Në^-zÝ`tª[ùMÌÉNqhùG-c­bn°s÷91gH$2xÈ°PÕ£~WK2Õd×¹yaí":}x2}DÄ]:EYhWÒä)Ã4{Ò1×Ôñ{éÎòò¼rÊùBÌ	']6ÐîÍ,a#)g=½"W©]å"/i	1Ç»Û>nÄ.²É>?4²Ëë³:=»|bnòTûl½-óÙâ3Ôµ[ûÐÖõÜjïg\¿fg?w}Ø¹=óÎHÕmí¯åú«®ó®GÞÅÎ¨yö.ÇHÄdr;W^7"\qÍð¨\µl[xä¾y¹Éètsé;ã¶nÚcÇè½d/Ü-µþrÜ?UVLýò¥-ÆÿR#c¯¾qTóÜËíÆ5±ßÒÅcåúý+6¹Ö^éZV/ßnGÊîÈþ^¦óSlK%æÊñù+1·Ãþöpt%_¹ôª!ö¹]êü9ëmÇàâìØ;#à8#à8#à8ÀD »Ír®±w.ÀÀMÀ!sc@GË^<}qÖ}¸æõ±K]v²¡UNqÊ#ÎCù¡ü²A';úØKù­kSNôòAGL.òWÆiýÌIT±ü­Zd
_=,KF¨â¦9lvÕ_Ýw[ðÀ|¼	ìlD¶lÜwÕå,q²ç31'XÆNìíëÜµ}('17ÆâvîÒNiÂÀ!Ua¸½S$[»ªþAô>ÛOªò^·kÞ9ök/=»:¾ë:§Nªzòç«^Ø}³{'ÿ
xSåÚW±°S~L|ågNzú§,Ö1Ñzèk-jµÚ´^lU+±ÒäIsÉNzò³®`K,ò#ò1÷'æ2À4÷§s+"Q^/nx×øÝ#¶ë¢3ì(¿®Ý3;N
áÊNýFhWÔ©¹B1ÐA pTXíöý­3s	ÄÇ%ì8´¿å tdsÀg;¹RaWÜG>7µÑÏ/ÇÔéósÿ·^
mwÒÆ¬¼ñ·&Ä`iÌÆúûö
÷ü÷ì ÁÂ_äÉW»RóÏlÌ¿1=GBÞzûäì{ð³#ÏÜÙ5aÖS+³&:W;ÿhZvÜXç|ÿù¥'úFÀqì§ì|cÏ'¾8Ì³!gªúK¹9EØ Øú§Xÿ©×_"¬mJæ¼P}|y$IS»sc¥®?ÅâöÏN12:s<,ÇºòÞµÆ¤Ä\©¿ÓIÌ±îÁÃ{[n]Æ|1¿a¥þÍ!#à8#à8#à8#ÐskÌþ@¤È-tâD¬ûÒÑbË<Qà)Ð!£Ó¥¸â7ðËåWLâá/~C9Ô¾ZëFÑCâ¤1+?~Ô\ªyìÄ³+½°U~é¥xÌ¡GT#>ÖóCÁcÛb¨¥Pú*?Æè)X@'½ZSE?ÆBqäK,æùDÊ6ºaÊÆjéã§øje#;éÍ4_ñ´NÕ%ôÜ|ÙkL«üò+&z¹Aö9ß1r-sÓñoì®ùÑ÷^)¸ºt'Ê7¿23¾?«]ûði#8ÎìåçÖÄ]C8ÆÃýKcÇº(,°ã4KßÇ«ox_QJ°Ã§vÇþðÂÓ«âQqØ s¯½¼.ì´]*WLf;U*Ãq#ôÚØñ	«mOÙ;zöî>cûG)ÄÜgþxZèÐ©2E<p-$·Ì¸8p$'äÊ]_sTg!û3¥ãhÃ·ßrALWì;æÒãLOU7GMþìÁïdgÑÁÃ«³!øülµc9^rÈê0uú8÷ó¾8¹æ­£Â%W}vÃ­¶ÝeìÞ«´Ïv{ÛÁÖÑî;îFïýlþú¡añëÅíùÑ¹k»HîL°wúUØïGiV´åû/#¦y7âì«"ÁXà÷¶)i1?; ®7=ÝÅ	°Îv²¾`5ö¼bë'g±÷ß|)¶~Å)Ö#_¯}ÇØ IÉßþ=ÿä°rIf÷¢æÔß'¼óýÆáL;Î÷T;åWß?b_uÐ²þ4Ç#ÒØ{GeÿßØqËßxÞï·kþß@öºÇfwYÊç¯Ø?©ìT;æ´ôx_tìÈùè2M{ë8#à8#à8#àVêvÌÝfIÖØ¥ÿùæIÀCÀ'HD ÑJ¿$Sú´ò£á¥ySEAÏÃ0ågQ4n´Ô_y±GüIêü©y°QK_¾Ö¢9ôÐ'-¢VñÒ<üT°¸40ÕÍV,Æ"'æ$ØÈþ\Z}Åjª(húºL
üÔIZúøa¯1±ÓpÌ)uÑ×M§O~D7>zDõjLõå'\8Ê­|ØÎ4ÌÞ1w¯¿cÎp9-@tïÑ!pá{§×ÖM{ìxKým*rüEýÃÛÞ3!NBÌ=õ%±_Ý»sÜÝÕÉbn·{vBNU¥Äu§ïæ
/IÅ_¶=j=WÎöÙGÀpGÀpGÀp¦¨®ª
Ýs·²ãÉmáèsg¡Mlðp.µ¡¿|Õb¤>ò=óÊw!_ZlÉêD
Sb®©ÜìÔbÇË@»ászm,d§íÌüÞÎj´¨ÉS{[c×;×\GÀpGÀpGÀpGÀpóºs¶uÖØÅ;æà ¸x]ðÌ÷ EÐñ­s¸tðò6\Ä¢E­b0fN|
zéRÅÀN6èDÈ¡Óu³K}[clØ ãbÌºú¬è4/sÊ?r2Æ[ô%£â)0-Ø²Iç´Õ @,æ$§V|ZÅ°"®R{ÙP£|ºr¥7
v©­
G§ÓK¡ä¡XØq¾È7ëfs1§üÔDAOLtÄJo
"Å¨XZÍQ<}$µKOÀRìeC_1R°Cqã¸S]Ø²SNù¨^ôÜxôô'[AO>Æ¬¾Æò1UO×òÓ­ÖÂXóÔÇ¹!·Þ~Ç};vî²®#pv Ðµ{ûÐw@·XÌÛÃÃ|]#PÙ®M4¬mÙ1´­l;öí=öî>¶lÜåO¡#à8#à8#à8#à8#ðæA ºGðÐ÷ïâ(Ëõví·°â!¬%à6àñØñP¹ÀcÌ¼üÄSè!Zòa+ûüÀ­8Ø)¿u³õÑO	BìÔ1u ªGùÅÍhj¢ti_õ:êWñ´Nô¶Ç¿(QÂ¢ëTl¡® ìµæ6}_ú²I[æ dòX7êÕJ/b-.DµÑÇVö±QMÌ«åW<µ²¡ÅòkM²£Õu£-:?õ±ATÄÜÀ[o·wÌíôsÿá8#à8#à8#à8#à8#àÇÔí«±wÌÁ!À]À± ôÅ KEDvØ iKLâ»PLÅMýÄa
ZùêHÕkfÙÝmôåGjgLÜ_kO×Nù±ÃGóÊ¯±Þqg&QÐz	â ííhï{°ÖwÌE@ü#à8#à8#à8#à8#à8#p>#P]Ueï»[ÄÜa[+Ç6ï · ÞD<t´|üøZ.tðâf¬%»dC^òÃP~l¾xüÈÚ©væ£ØG>ùq:±Ó<öøÁ1z.ì4¯üèéË×ºq¬uKññ-ZTTÑêUC&®¡¢YP
r§¾fE	(Ø ÄDË]~Í)'>'[ÅDÖ/ùù  çÂ½ì_:ÅR^åÐÁ\³(b!òQù(¦ôØ*¿ü°eÇÜàüwÌ-Ù²GÀpGÀpGÀpGÀpGÀpGÀ8Û§:Ôíû-k]{íÁ¿ ÒH|cqôeöu³qR[Ù(<6êkN<ZåWì>ÂX"NIsø+¼ò«O,l$éX1h±§ÅVùé+¾òcÆÐ<mÑ¢àE¨s,T±Óhq©^"ÀHçéPõùp)_~ÆÑ5ÐÇ_@SNüd'?tô¹T§j
8BGN¦±A<tØÂO ÒeFõ?¥W~f>q°!.ìÈ¯Z°a,?ìÆÊ
âlÓWÏ ²*Õ§~ðTÌÓÇ¾¸
ëÆy`ò¥åÂ{úi<¸q7ù~òOíW1ñU~timô±Nñ¸äW]èù)j¯yZÙÓo±¨¨;&*^7¡0®t^È¿éØHKÅ E4ÆúÓøøp#$Øä[ªS~ØÒà¯ªØIäK,õiå£XØ+¿p=c­	ÝtKcSemoo×[n¿ã¾Ú»r¶î«hÓ&ôëÙ#<y2lÚ^ VG xzWuý{WUë7=ûä9ý³¡uÛváøáýaõóß'ósC*;V¡W}4[ì²Çÿ=Û÷Î@¶íCÕàÉö÷ëxØY3÷ú<½1yVGÀpGÀpGÀpGàüG`HßÞ¡_¯ê­Ù´%>-8ÙÒ6«sHvÌ}Ø&ÖØ)/3aß ÇN\}ty`J«yZ¸Z|5Ætò±nAàùåG8æ¸°eL,q*é¼b¨Õ¢¸Ø"ÌsKa_åº|åÕúßLcLé¡¾âÒ"ä.Z\ª¤V1ÒiäÐâ| ;üc£~KÖ¼ ÆÁVsè¤G§!}9Ý|ÙÉ<M«yÅ¦E/ìüù ÈG~é>ö´òÇØ¯6æ0ÓÀ¹!çÊ;æ&úTWQwØ°mGX¸rMìûG X¦LºvâD×fÏ_CÎ]ðî¿ÃÑC{ÂÂ}É,ø;7¤]^aÜÛÿ$»¿vmXþäÇUúÐ}àÄ¸ÂÚ5¯µ/?x¯Öæ8#à8#à8#à0Ò¬]eeØµw_¨Ý³·ì=x@Ú¿oÁ¸KkÖÈ¹??m	ZgmÏªcáÂ±Bïêã¡Kçá±·´
?Ú%lÞy.Þ¨a& æzØgíá{¾5ÃÜjì:hÈ$¸ñ	V<:Æô±¥ÅVcëFìÐI°åÏ?~raôÊ¢\øÃ §Å6+_SG?Æi~q-ÌãÏ¥üètð'«\Ä­âÐJÆÃN¶§ºm*
µ-/U("X,E*H7[åÔµ@üési.]´æ#/ÍÏ<ó´Äã¯­|è«~jD§ §ó©/úBþi~Å#?Ö ?å`ùÓxô¹ð¡Væ±E°gÇÜà[í(ËçÀQ£´oô¡öxôàõùÍaöÍQö
×!$JÀÉ_(z->I¤ôÊ?§:D²)¿À£U~a¦ùTò¤Âù8ÔF,Õ&t²ìi±'-¶c|°GäOÆ¬Mz|Ï©wÌY½¡c{JáÀ¡C±mîQa2ÛÂÙ-·b]óI½ææ8v¥Ö_ªÿé\Û»KÇaêãbê#GgæÎ'ìÝ©81¢áýr ÀNFäðÞ\¸±=#à8#à8#à8#à#~={d+Äûü4»Xï®¿r_4.w§ÜQcöíoºu9ì ¸Ù³·uøöº'yÔ_$;æn³Hkì_?à!)Ià2TscÃ9Z.±-é°EÒxÄAà'È%tÊO,ì°AÇ\9ôÄàb¬#Ì;ÍOÆð$ÌËúy[æVùh¹åW]ø)vO9È/,ðo± TÑâT4ñÒÂk±²ÕÕÊWd0aÑÓ¦>ÌéfCyhÙ>WjC,éÅX¾´\]yÉ1òVÅfN}ìµëfùüXÑ#iÆäGØ17ÈÞ1wÿÚQÁ%[vdûçKgÜÐÁaPßÌCñ«jÂ­ÛÏ©¥Z©þçXÍ(6ý+HÚBG:1× ÝÄpGÀpGÀpGÀpóÞ=ºFÈYÕ¹DÌåî³[ß¶'e_â>Ò*<õB§°lue8~¼gz"Ls8\}ÙúüE×°asé»æwÌ±cn­]s"µÈ	WÁW¡R
­æÅ_0=cú©zx	[²1U6öâÒW~ùâG~ÆØqI°åR^l#´éXùiêb±âª5U¯lÑc£äÐ:Ð)f~~Õf&-%m¹g½GZ ñ((ÕÑg!*Tc-H5h±Ò3@TéÃ ;æÔ×|Óôl×\Ú2¤óMæ'¿1é
öl	û·¯n2ëÁ²aßµïÓÃâwmj×7Y{«6mC>£B»NÕ¶Þv¶cmkô¨-æpdÓ_T¨´­ì÷£Ð}nÓ¶}\w~cuäë·¤þÖ¶Ö¶qú¹i,®ôÚÉwÜ>Ç5ü<ËÎ[GÀpGÀpGÀpGà|GçaYiÏ0S9¹ôù[ZssòÜN:t8óL¶½÷®ªKçÏþvîÝkÄQ@Jãç÷}~¨8Ý;w»ýÚU¶Ï81mÏþ->9MñÎö¶U«áªKË'
¯.j6b._>öÛ;Cî¢DBxôÙNaá²Ìrù¶-';æDÌñ¤<SPbµèÕ·nì3FÏßêú_\}q"Özl9åB/A§ilôâO}ÔW~Õ§ü±ühÓÌ+Gj£üúÐWíêËxEå\çD±X@G§eÁ­hÌ Á'í3¸òãFcÃIóÓçb%:|èRÙ0WùC~Ì«ÍiØ(?s©ôÄeNkdL~	v>:ÅÂaÞzû§Ø±óôìã^a[oµ4ËX';vg ë=_¨_[¶*lIvïM8.tíÔQ.ÙvåúMaeït¹ñÉYûSuxqnAb¨Øú»tì`G%i×mÞ¯Y[°ñÃ½{Æ¹ßÌy-KàZ©þi±Cíý|ÃìÝ~jù²µvW`bc$éÐ~}¤(²lípÌ¸1C6y¾ù+VÇóºós¤cüYRµüûö!j6m/Ò-/%æ>þoaðå
U&å8v$¬óã°kí«9úÝû17þ~Ôm_9+¬ûpÎ¼.}_¨vy.øéßåxoùRhc$Ò]Âò'¿\ñ¡Ð}àríãGÃÚ»Ö½£o1×µß¸0têí"¡Fj-P'±-äeÿIï²\¹¡Cv¤ã:Ã±ô3-ô¿ðqjãü_FoÀEïÎÖ,â¬}é~#èÖIm{½6ô3=mYe]g÷ñþ7¢,±oû£ 	zòä°èÿØNgû|ßó÷ö­ÃÞ-ËÃÊgîÊÎÑ}ÃCÇªÌç?Ø¼ÈÞ1·ðÑTÕh¿¥õó9í1d²}ö?ýÛFãj¢Uë0é·ÿ1w¬y9¬{ùòÖpGÀpGÀpGÀxÓ!0iôðÐ§GæKÔk7oÍ>C:¹brs¯»ì¢HÌ±¾,	2Õ§:³~Ý|Å-X¹&lÙQÿüXsjKy~ØÝHÀ	öB°ðeÿE«kÏ!ÏGéßçhØ µmdIågVzíÔýáâñõ¯tzrV§ðÚâÂ8µ¼wÌñ@]âà¸à.ôP¾Æ<åÂ&õ¡N}]ô\|±=-c P\ëfó1Onæ¨¸ôÅÐ:ÅJkÁNxò%¦ÖÆD1±£Ï_£êÁ/ÅJ}|SúÌl?ÓE"ÇM¡%6 ha´,^Ài!¦¢ZÔ¦`	4å§VOã"ôjyjR>iÕ+?Zl§OMê[7Úëëè5GêR/sÊK«¸Ös´~Ê¯ZñE áÚQ?8GYòÍÉãFeI¾YÁÎ¤¶bùÂ»¾^_¾:g7ÛÕ¶³	û|9Ä\)õ7Kÿ±?¹ôÈGî÷ïÄ9»¹¯Ï¿¶°à®³Ûn;$!:!
÷ÿPÑËdÛys1ýØmÇVr¿wíÝ6åòÍÅö+úBÖÂüfûÎëËW2mR7b`¿0b`ÿh³qÛHð5æ bNóìNÛºô7qg»ÝDºäï4êÐ}íû½èÚÔ¹æs¹ùgZþe°#?ÇB"ù9"æz¼*°ëÿÙ0ï'aûYJS6%æpíÚ°Åv1¢³}·~¶îælýGíøÄ%¿Î%ÇðK¹4Î/Ø1¢5ñKâtªÒ`Ç_õ©aÐä[£Gu²#p÷ùqÜÁv±
¶´/]³[**8*:Q JÇZ¸n|±MëÃà¤c¬X´Êj9|[D6ôK6´i>|¨Wyå¥E°ÑÍ'|D6ôñUNÆôÉ§<Ù62ÈvÌÝ:vÌ]kÿpñY!0Øf4EÈDºéWCÌ¥¾|»o^°\x)÷ØÁÔ.íRº¾Bÿh)OSÄlh©¿Hé\ïäÍ¶ÿ IwÄ]5i­âî³s_op¤e>1)÷Ê¢e9ÇQòA¼qÊ%áñÙsâ;Í¡>GOr¥d«½qÞÒ6«å8UvËqv6kõú¢ø®¼ÆSb#+W=ÿ°ok}Î=Ñ×ÿntç]eõÏÙP2cn(1W(?DÏ¨é9îÞ>ö¯Ùüs}'¼5ôc´c§ÝZ;¶pgÍ¬_Úb;Þ¸7Íï5Ã>ÛgGU®|öîì<6ìÔâ¨ÇÊÝFb,|broåÌ»ÂcÉ·³lÝEïýç0ïÇF¤ÙÓ	¶,¾'ÎtËúzc.y7¶ì¢[ðóé#¦}&té="Æ[ùì·ÃÞÍù;úZñ¶#®²SUæØÈý}6tÊûÑmÀF}4jOEÌR?ï,ó_Ä<[l÷Û&Ûôyexñ-±¿oÛÊ°â7ÿûªQ×}>öýòrv^F¥ÿpGÀpGÀpGÀpÞ\<fdèUyF¡ç¼oî\ æÒÛÓÒç§)1wüø¸K0ÝÀÀbMSpÏÓ$åx~xÁ¡¡¯ê²ø"}¾è¹à¬×}ëO<Ê·;ßÆ7_»7_UëÚ<ÖUÃÚaÖØ¥s<\{B½xõM}áq¢v§¡cL,D6Q®/6â._ú¾ôá<4oÝ(Ø)6óä±æÔ2ÆV<Å¶éè±áJk$ÆÂGëÅ^ùSúcS´¤TÑ"¥âµP¢ùt!éè¬jÑØTQ_*Ä-~"ÔÐ)z¶:¶nôAl½ZÕ#;ZÍY7tÊ¿n®ò³~nª
öK­¿ÜÄ\KëÏ_TKýùþa8ï+$é?/-\wÁ¥v)1Ç×Éq-^B{
®l÷»å ùZ"é7x¶±÷ê)½[ÿ*»ÊonÜMf»®ª»é^(C`Ä¬1F:!ù»Ù¢²îGswÌ­ûP`X¾Lxç_¶FlqãüüMvº17àâ÷^¶[9qâX¨}¯í +|t(6Þû/;Ê|¾¼þð_e	³|b®Ðn2ü{LÊ¼Cnÿö5¶ëì¿rÂ¦Ä\$Ï~öwö¹SÿX×þÂð«>cíXýRX÷Êrâj0øòÚûØ.Ãü»¾8½âÃqní´[3ëûrmçÞ£ÂÈiwÆþVÛ}¶Ñv¡5%-!æJ­ÿßúÛx\'»+W>sw,¢UïHXÚ;
É-
q"ùsí$9ý3¡s¯ÑbLï)+71·ðç_
GîNªËtG]÷;vãà8xí¡?ÏîHK9Èc÷Ù»Ö2¿ì[õ¬í 3}S"r§)t®1bîÐ­ö·¯¤¦Ù~ú~³|r£;P».,{òkYß¦:é{Öj×¼v­/LÆ÷qeèÚ/óîÀµ/?°äìZ³uñÿcv$¦dvUFÞ!¼£îÐ-*Ø¶+µþáöÞ»®öþ»cGü?±	ïúëÐ¶}ý·ªÖ1»kÝ¼Ð{ìuñÍ;7eOü{ÁÚ]é8#à8#à8#à¯pL#ï8ãSþ©Qo6bÓ°82_.0Ö^CÓ)ªxqnö(Ér<?äñc'sIxýÍ¦íµaKíÎpä(ÉKú÷9Þÿ=vJYýºx®Sx}iûzE½HÌUuÝó­X¨õvq<7î .~K}éáOèGáQ)-öù§cbÉ>õ_¡ØØ!ÊOÆØOþj;	ö­XØÁVõh
§:<|ö?Y_s·0A  @A  NZøMçÈ­E;ê?û¿áWjn_é]¸¸ãÕSãwÖò\^~"]1·¿ÎÙÃµW]1üÁ_|bMÐzõ3×ß4ÜuÿÁ5mO4ÅÙ{«)÷Õ3åö¬þ&sðÁYSîÇýÜ¿5;lWÌñ¿Ño­AÃf?%Û+v$ä?pöal¾31 ýÜ~ô&º?vècßÃ:ÐAÈ!ââ½1\3kq1A8æg6ú¾Ö"¶ñ¦ktÈð!³£ØåÉDËGX-lMXdß:0:XÈ°ãHê&Ý3rô_ì u[âKùÔ½vÖíW5ÄL~fmyÖ½^äØ²?cá¶ðÖgÆÀ^ÒZ¡¹_y6s>×FÜmuuÜýu/àÇ«IÅ×O>5Þy#MºeslüM¯¹¦®AúÑÏ|al6!¸oñêÇp«ÅN­ÿÛ®½zØ³û´1äôJ-¾ø¹\ÞËb´VcÝ2õã'mÔú8ñ°þ[ï¼{øÒ-_1Ü|FÅ/nüÊWÇêySÚªÆoê+.º`8ÿ¾á¯=2|ù+·¯ë^Þ<8ûSC½/÷¦sïåßó?»Î<oÌ}ëÇß?ÜË_<ÿp;I'g¾àÊ¹ìëÕ;eÛ©ÃUu{ÆÓ÷_<æ¦)sÃÿËá±zÝVQoÌæ ·Í|¦[ù¹'·ëÐs{ÍNË6æÀ÷¥û
oÄfÝ2åÎ%ýXKâèÛAÒG8ð¾ =®yµ%5[ó#òê±1{Õ9/>¤Ì¼Îèàñà±zÌ=%¼¸1÷¬\1wÕÅ_øBó.ù&w×ÿr¸éö;ë~¹G6v8ð^°ÒTÁù¼º¼ætÏÁÊïº~l¿ãÞµTÇèê_6\¸ri:W}å®{êê§Çç»½°þgôWub>Òfëï_¤äºþÖ¯·µä>É/®&Ó¾3>òÏ®ÙlZ¦þÕÈËí¦ák_>{6±,lxàì×ê
:NLøBäõÝ¾mÛøàÕ~úGýo¡­jÌ¿¿þ÷ÌK®oi­FáÜ ÝuÐoÿæWW¤~òÉáO>ù¹£êëöS~³¹s_üá¢WÿÐ+­nÿìo·AÜ¹{ßðÂ«ß2ì9ç#R~þßþºúê¡¹l«17½bÜjó%oþãsÒXzôáú÷ÏxÆòeiÚ#Î£oÇ	
:	máÏpcðÆ±Z¢ÔÙÀPodÚ^2?2kluÄ±ª¯3rx_ôEq1Km®7àôc&_·#62súó)¾¼1÷«ÏÆ3æ®º¤s»1WùGâvÜ#¸_~êöíÃðºoÖdÍ¦ËÿúØ·âã@þú«_:~Y-
D³«Úzo³õoãª³k_Q)]57ÍKÝ\Axæé³éÇêJ>^hú{eýi¼½øÂmÛxË,&°»åö»êª¹)mUc«ò®¼øyøõÂ_wý|½é ½é«wÔU}·/2[S¶ÙÆW¦½ì-ÿ¨íuîÂOzl|®Úî½³Ï·{|ü¡»æ¶Ïfc$4¦®üÎÿ|Þ{äÞ[?ò¯Æ[4ÎXYÔ[+MAò.z¾ÙfsäãÊ°¾â?ïqQ
ì[®s#Öà@,të¾aã3[`»8æbtc ªyCæWÆ¬\Æoòã£çd
Þs,ù¾ú7>ñÄ¯{mã+g­ÆÜ	·@A  @A  N2Æ+æÎÞW·²|7·²<P«øûô y{
rS¾AelÈM"`áÃ@Î1¡©Üêz<x_TòËckíØÃ=¿ûP-zë"¦ùÕÏ8î	[xbaa=ùÐëk~ó^:®ûÕûî?Xì¾t×}²KÏßvíÕÃºº
újÝ¾+á}+bWi¼5ãëÖuKèc½îÛI®Z~ý¹½þ¯?bÉVHcnpA  @A  @Aà¹@»åV]·ÖøZ«DOÞþ2{*6®ìÕ XCøÒ» O!GÎì0¶ýÖæ§q¨>èÈ¯}{%%ë´z"Ö;ÈXðÄ!&D<x1zþ:ëÆæ××}¸ý°z~ÖÄ[,~é åhAÄÁPÇêv}óð ^ÿbG0
2zlq±1.~®5u;yòÃ÷z¿u¨Çv×:°Ú£Ãê9»rqÔ8Ø8£ç¹Kßú®ï}íÙn[Ñã¡/¿üùóã*Ïðø¡CÃaóUWÔ¶sÇ÷¦y÷zÙsNôú+8¦ç'iÌ=?_÷ì: @A  @Aà¹À¬1·øà/ý<·²¼­»³Eß ¢Ù¨§¿
xbø0ÃÆiäÄÐ1xÞ3¤­1áèØ5zýAÈ±#.u¿Øy~sôüÚb'Q/o:îùH<bAäìk÷5*ëë4¦{$¾»j\\ÏûÀý[|Å\ÅÓömÛý{ÏN?m×°}Ûöáég®w¨+èxÝÓÏåÜå9Åèõ?§ÀL1Ïv¾oØsÎ¥ã^¾óúá©Ãý»ýyA6@A  @A  Ì1wv=cîlÌqËHCE>}~¸·oo¿>?êÛsÀ_ûúâo\}Ã{ÖÔ@ßÂüèÔ;Ò"?â^;òÞ¾ñ°íqák~ã!ktãÚÇ-q!ówýL³Á-jnG³	ËÜ×ÖÜ®Ë|Nlº11r
1³¶ãâ«6^5'.Ú£LÆ|ø@øßÚÅàVþÐ»~ü}÷| ¿PA  @A  @A  p#°rÅÏ»¥M9z}¯cÝ{#ðlìqÐÀ^1ékÀ#3n±£¶ö;Ðw_×ÈìÀ»¦µùëCÚÏuZ«½ôÈÝ#1bm¾n;}Ï)Ï¬vÌKEnÜ°O/
27×ÑÎÍb#Ï,[= !Ó_pñA¦×O L¹ñ­µTc,óÛ(3y òßüÈzb#c&.d<ó2:ó2CÈÎ¨qi]1÷ÞÜÊHBA  @A  @A  NnÚ­,o¯>T~={*6½3ìQ`#Ï¬>M7{Úhi¯Bsaqìi;Ï¡~äpíÎ¦¶æCk÷§øßx=_÷7/ùz,Öø¸|°eÀ3ºò/GØ
²`ëäÑÁkO~|¹qA.Ñ¨CnØaÏ@-+Ê»Ø¹½|ÏÌüÆBÖó£o~dú #.ÃÆöÚ:c¹f6.:sG¹
A  @A  @A  ð<@`å¹­­Þ\ãñôèÐ @¿¢÷\cÇ@'oÃçÇ±õxÄèS=>ÝÞüèð³Çb>fb@Øj]×o³Xú_{ÖäÇFkfüôX/Ê?µ¹s°±(vãDàÍ£xCo|7«­vÖ×M²Ð÷¬±aÖÇ¾J5Ú[½¶È:é^[õÆ §yûøY#³9©×XØ ÝoÏ¯¾ÇÀ^[®»¸1÷þ<cXBA  @A  @A  NnV1Çs·Öà9DöèU0èa8££¹DÏÁ&ú¶è±×Ö=:z(Ìø^ÇÞþ6=¾±ôc
ôèyØW@g¤ÏðôhÆAÝ5~ýôðÌèèg¡®Øùy·QGýÐñ3;ÌÁÌ°Rì¼xÈøöWÎðæG
A  @A  @A  NfÎ9{ßðÁ÷¼[Y~¥·²¤AFß^ý¼rú'ô3ì£Ð`cÍ½¤¿kf|´'®qìWtöæÇuÏOÿzÈÙë(ñèË
dÓë,vÔ»9_ÖÖ(¬Í£Y¹>=?/@1Û 3OF2¹Á±lÔ;®ÍÙ_à¾g58¬%ã '2bãÇü{j\Z¹÷§1WH@A  @A  @A ä¬4æ¸åÍ5xÆ}zôì-0»GuÞÞ2¯zÃÆ«È3´óÖÊÌi/5£¯±Ûì}`C­èðSBn~tøbG,û?Ä1±#ÏY¼µC"õXº^<ÔãÍ$ø× pYhJ
¡pæ^E+ÇkÊÞX%ÇòN¿þâ"ï/ ¾æÀ¾ÇægM,Á6~÷1?:ÄMö¥-2È½â§X·yñó7>1!ühì©ÇÝ5.Jc®P @A  @A  @x °ÒûáÚêm5¸bÎ>=¯c
E6äØ×Y°as]îÆ;òØÛãíÏf3?ñÈÉzg
A  @A  @A  p#°¿1÷¡÷¼[YÞRãñôFì[Ø £ÀÐAÌô õô+ äðö#äíe*¼ý
PA  @A  @A +æÞVû<P1zÌÓO`ÐpôýôkH>ö7ôW{âZ ã°Æ¯×reÅL¿Ñhc~íõUN~ýÐG^?f¨÷^¨
A  @A  @A  pr#Ð®»¹vÊ­,é@Ì4ÇèEô¦=ôô'ú ×¾rlà!xtÊkÏdo¼Ä´sÚß07r19;ÏOnËÚùÉmÍæGGLøæ7³yA={G®­![,v)ç'c8S(¼EbÆZpÝzåÎè3$uÌòèà¡>Ã8à"^Á½¶ø!7®:eÔ(_ì¼Vk&1}¯ÈyÃHØ3Ü33?äæÐ¦DóèöÔ¸$WÌK( @A  @A  ÀÉÀÊsï¨Þ\ãÑ÷F}Éæ3rz¼vô.ä»=uøÙp#±ÓÛÐ6ÎèèwL©ûÀ×59Á0¿ñ{~dc?ä´éöðÖ­>ØªC¾l)ç'6b1XS°A&Mói^±Ô®Pã0ÃF/1ô[ô¢ñÂtÒ?ù«cÝó[gG9kòÛyÑFLó;÷Wù«éÄô»k\^Ïû@1WH@A  @A  @A äsöÙÃßóÿImóÖ4æèØ?(vÞ¡Ü^	3½äº~2lô!àmú;úG;äÄÒ¾¯ÍONìYC®MÿE;tÆ¥×b.c;w{}ÔõuÏ5¹ÍÏ?írHxs,²G¿."ùfÉP³QeñMßàÛ`Ã{_bè¯6æ,ö(@|Ñ©El­±Ç22j¡!mÏ/øÚ`ÏÚ8ÄæNØÃæñ©WY¯
 X´õc
PA  @A  @A ®;å§>óÉ?ÿÈÏÝsç×Õö¸%M1úôh.1Û ¿@?Á532XÌÚ0kWìHÊ¦1\øÑÃè¹Z-qúÀÞ:ciÃZ¿n«
A  @A  @A  NhvìØ1ìÜ¹c¸óÖîþ§ÿ¶6s°M9ú%=~|ï¥ÀÛ@ÏyµXçÑÓès-çÍ?uêÑIäFÞu=¿zb^	
2qÓìÐ ì ú¢`ÇÆÑkËì&÷³£?[sF¾ÊÐ#÷²JóXvòæï¾=?zmCØjOä1+·>k"Cy±óÚá±#û7Ï{á·}÷[~ì¬ý/øsôsTPA  @A  @A  pB"@SnÇSî½ûýãßÿåÚÄÝ5®ao^}Èþ

òE¡¸NnYwäÇ/ ©CîFõeÍÀ
ýuÌèÏÚ8Óüè:ðè¡¾/bAÄcËü½nt¶ò^/9¿|Ïo\c #ûÂÛebG\ø]5v¯ÌðøèWìÈ×ú\Ïý1w9¾ÈÔ[79ÅÚÜ§±;æ÷u¥.ôã3kWìüõ4ùÅS¹¹ÌË,ÁcïÁÈ¬ßý£çÇamè±eLóh$ì±càÙóñòcü«¯?¸1ÿì=÷_>9þäøï|ÿæücõ<ïEóåü÷óïüý¿¿fKñ÷éß¿|^ò÷çê÷
1ò÷gþþä"çïïüý½ù¿¿=??Ö÷O}ÜÆcïZÇ_Îçüx¯ñ»ljï÷i¿û÷±°ÃÆ¾þÆ#GÏg~f÷Àù±y>â>J4êµ3¶ØÐp£çm+¹R2ó4¯2öE\;óø:`K}¬!óc/¡CÞÏ§ñÌEiâù¥-3ÎºL½5?:	{¶òèàµG§Þ}Ó8Óü¥íõÃ¶ÇÓ;÷¿a"Áfb(ÍRä¢l¸¡2í\ë ø¬o½êK4v[ýÉï¥Æ '¼vÆg­®Øy~bP{ÇÖý£GÇÐAèÝ?9XCäïþÆcð|Ä§ûözÉII?ì±ãj:ÞàæGï±ÁßxÖS¢£ödí¬ægvÙýÃ3 ÷ÈxÖomØ@Ôåë-ñûë¯?vèYsÏÏ2¿ùz~tñÍoÌãå§mÍûX¬¡i~êÐo$?öì¹ï?ù?ïßyÿåóãO¿ùþÉ÷oÎ?ê±(ç_³ÏB?Ö9ÿïü¿ãçßw9çü+ç_9ÿÊùWÎ¿rþó¯Ù÷jÎ¿Nîó/^åeÎð;Öù'¿u¢çX
y¾:ýýÝ4?¶~þløt| óãïùÇnó{dè±Ç5zgj;TÃµ+Ñ¼~ýñ£6ÈúYëKLÎ% raã^ÐMóhümüÄfèSìHøû·~Ö=?kã0«w_Ìþì±Ì¡¿¯k÷C®Ç×Æêztä4¯þ¿~î¡T£=ù!ã1ëO<ö¯Ìø%e¬­~Ód	DA¾0dulÐ¸Qü?AXób1#3þðú6Wp=DìnOæ·f¨çÇ5±Ýù{~üYcY«¼ù±3?:×Ø3ôG±6?kr`7­
&ý÷¸|ÿäûÇÏß'|æ¶êøão­ýýa~rñ~¦ß4h ôþN=DÓ÷±ÇóõüØ*ï~æÇ½û/väk¯
Á3üýYÿýs½çøAÇúýýô÷WdòcG,óÃ÷ï?ô9Y=HîÍ<ÌÄX÷[WâKùÍÍÌñ_óÃ_9ñ#z~ÖÚ Çä <µ1»g@Êá­ûGÞó ³NåØLócgl÷o~ìáCÍðd®ÕÂ!þÈÄ¸¾þÖÐóc¡3?>1µù±MåÖ6lônÔojO
a#n^V/2ô çj¬±R0ÌÑÁÅgú°Æ¦ç¯åX#:ãLów9õAæGÇÌïÌÎ½öüÈ!d=?ñØß_- õØ·¿ÙÄ´(¿6ú;óûÁS®=ñå7ûgFXk5~æï¶%c¡3tú_¹ø[ñ¿>ÖN,ñ×cu}ÏOcÀ[²iþ¶kå_ëýO¬cåw/Éüóþ[ýÌæó·zìåØq,Éñgññ?Çß£Ïx¿äû'ß¿9ÿX=?ÿåükvÜÈùgÎ?sþóOÏrþóo¾+ýý¥ØüýQäï¯üýå9#ÇJ>|olò{ê2ÿrÎÓ¿?ý}ÌÀQ,ý¾éß?ØN?¬»kñ/vþ;±qÙûàÇß­	½ró#³Fc!ð£©YºîÓßÄÁ8æaöØòbGê±ÐAâù­yÏßñ1ÇZùõ3¿1{~âCÈ ÷­ûG®¹¿2÷À¬N?ã1#cX±ã±¦øªgî>æÀæ7¶yð[(j³DPc ³@rP<Ü}Ïïæ÷C,A)vl1óÆ²Ye~äÄ"'±vÖà dylðEÎ`M>ì}AXÇ=ÁcK~Íf%ýÈPÏcMæBß=_lÈ-û2¯sÆüø¸_'uÌû#µ ïùc-Ä$?D~÷ïþÐËý£7?º¾÷}51áìÏZà¡¯ÏüÖêëoþ÷,õZkóÇüÖbLbøþÃ¦ç'{ÖvQ~tØ1»ÿbçï?tkåïûäa'®Á?ï¿|þfÇçfÇR
?ÿÓWÉ®6Jnbª£t­øêÙÈÿ©¯/ÛdÕáãGìêC³~rÞ9vÒc¯ù¯q5ÆðéN|õdª¬;%[þ«¾OÏíðÓ!7)ÜÊÅ?çãÿzý[?»þvÿíù³çïÞ?s@nðêþïÌÜûW$TÞQ¹ùÇæöÐæ_uV:öýç|'uÇ 1ñìýûÃÞ¿lþuîgê¸Öoõ×§Üükó¯?9ÿ9Ak»òÕùoM£äÎÖÛ¿úPëÊªÇïþ%LýÊ5f:³>eô!?üt%Ã~?MÞÁ¾Û3¾dñQíÙ7ës,ÉO|²Q|6³«/¶<ÆÈDY»z±K¦2úÃþ'ö´Ò}êQýµüñÇcÿú@øìåÿQ½Q}×úÄ×O]ßoSÆ~ÛÀ¡ÈÃ¶AÍ â£Wr®¾lå¶^ÕîG&ã`Ý~vÃ»¶é |½&v¿ÀÕeãßÄ6Þd)f¯ñã£ú&>¾¶¦¤7íõ+¯>cAÏäëËFcÍ®Ò¸úùîÑ}?¬ÆÞ+ÿé~<üë¸Í-?ãEÅÎ{óþK>¼g¶Üâ-eøêé¨ç?½IäÃÇ¯ýYüä²©Ý¸ÿÛÿcß¶V­·xµ[WÖ;j-]×r§Ô®ñØýw®ÖÖî¿ÝöÆÞçÞè¯ìý_4÷Q÷ÊÞ?gl:K÷þ=ÏòïÖI+H{ïß·kFkïß½í½Ï½Ñ_1Ùû·hìýÛzP¢Í?Î8lþqýLþÕ~ûÊþ+§9Wèù~ù_?éIÖ:D¾=_[ô©»7ÓfN÷iò3/mÏè¯/ü)ßØîL²Úl8µçZú¯öÈiÌJ6<WùdÂÑN¦ºq'üæ>ýâ¯S>ú±»ÿõ3|}ìøþ½£z#r_ÿ?ÇÊ`ì¢Æ\ü³÷üËcãü)ý¿
>OA) é
LÁ§,ÐÙib#^òµ°ÂÈFøtëÃCµñ«ºÚÌá%_{M}ÚàøÊtáÆÇüéÏ+ütò#ý½E]"kµã)çØÙlþ¥¿>%^2ÙKîèºã½RòÑüÃxéL|¼0ØÿÙúËNcÍ2Ýdæú|íüø~±ÉOíIÎ]±ÝøçýWLZ/µwýÙý÷ë}=ÿöüyì£=ÿÏ;³óD¹÷ÏÞ?îî½÷þõþ³ùÇcO8'Q{dó¯3mþe/CXk¢½±ù÷ÛsS<&µv:[7ÿØücóÿ^þÕ~ïü·Ç£ÎgûÿÿB3ÿL¶3¢ün÷OvÃ¯/ÝÚJ4ùÚlÓíüÉ&£/ôôáõ£T}ÊôW|º(~g<»d³>mÎ±¡ðU<eºÙøxáÕiã×Wyö8x7~zaã=c,þÍñ!Ö|Òòó~óvJOcb3å¿ToP_RzG¸Aæ4ÑxJOÖâ	l¨O}¾Gó¾hô¥ÏVÁI¿	£¯?ª?|6`EÙUâ®Õ§>ñ³iBý°uÕ¯?ûS_e¿6Ù|ýáÃ*³¿C¶f?ñ¤²ñ]Ç-ýa¦°nö²ÿÉÒEúÕâ§tj§¯&ÿÒ7¯~òôòÌÕ~ãoö§Ï>;(ûùßú9{ýÍYøl¡i_{ñkéÿ¹îvýíþÛóÇéð8_÷ü=c±÷Ïy«ã±>öþ=ó¥Í?Îüoó¯slþyæâ6ÿÞü»\Âzûcß?öýÃý¹ï_ûþµï_NÇG~Ý¹ïûþa-LzöýõUþÝú)÷¯=7Ï_6|Ë:ê×ï»x½ÿ~ºìÕ[=ýðñÛë¬eê  @ IDATäËégN?êÒiüLöÕ'~6è§-eD§OüÆW¿6=þÃ¬?ûë)~ãKÖÄW¿ñ³ÕO-¾¨#õðÕÓWG³?ý_?ÞÔ¿)ýæÿ~<ú³ÎÆäéûbô'Ýl¬Ön²AQ
ª|M/]íúêÝ¦~ü&SY¾vá'£LWmý-ºÕïÁºol<möÔ=-*?BµAê]V=üâ0ñÙøÚîÄo|üøùÈ¥7ñéôLêÙgã>~þM¯ø²ÂVçw>ê×§ºdP6ÕóEeóÙüm.-vÅ^øá({zä>È¯Þú»âOÅÄxã®ã]o÷{®¸Ø?»ÿöüÙówÞ$çÙ±÷Ïãßû÷\¼Íÿæ®Ùükó/ûcóÿÇ¹Y¥,6öL|õÍ¿6ÿÚüËNxý±ù×ãÙükó¯îùýí±cÎýÒ³ßÎõÒ=[ìþ§~ÿp|w¦Z3ÅEÝ¡éCxêÎëj®¿you^ÿ¢¿àè£M2lâM[øÓÎÄ÷ý?ré%¯lÜú§®zT=[®zöÈÃÄÏÿdô}Mòôáì;Mü|0W ;ÍÝ{ñoìl¢?óÏÆF&{dÃôûBñ'£NøÐÃï©ÞÙtToíÆ­ýmè§íKNÂÂ/pññÔ9]]
:{øñÔSfW?[_%§MNY=9.I?½Êôâ{ÜäèeÕVÇ'¯lì±`ßQ½Ë{µ7ñÉDìç^ã#ïAÏðÓ!Èð?ÜÊâÓ¸ÈfW]¶j­þ³qKød'>9~6³þìNyõðs3~öÉ7ÿêáÓ{Ú?íÇT_â_×B²W|¶_cÈ¾Mÿ§¼¾9ÞéÿâkV|Ä©oüë¾õ¼ëï\»ÿÞ'{þÜ=0tÿîýó¸¯­½ùÐæç>±&6ÿÚüË;µ°ùçÄbóïÍ¿{ïÞ÷óîÜ÷¯ólp>xäGuóï#1Ø÷ïÿ«¶÷Úw³,¯¿×öæ39¼ò_2oê×û,¢7íëæ{®ÿÆNö'~ø%Ùë8ÉÖ¯ìü)oËncÊé¾©ÏïëÉöc:,ª?Êü×'xÿhÞd¿1ãgüg·ù$øÚá¯R¾O'ÿ§>ðÕ'>9Ê^evøtËç0É«çÏQ½ÕH?Ê^¶Nî7þeø§h:°0Ñßdç¼àÍú-°L6+×&ãøú©ï`Ýä&ÖÃ%7ùÚU­·/úêoì¿3XmTvÈk©?×R;aI.ú-æxÊðÉÞ¡òËØÈføÚT©>Êç|$xµß¶c9ÿú³ÝØðÔQXÕeødQ|>}ÿ?ÿÿÿÁÿï\ÿ»þvÿïù÷þý³çï¿"°÷ÏÞ?"°÷ïÛ½0ón±Ñþlþ½ùÇælþñÞûÿæ_n·gîÌEöü}|OÚûgïßÿÍù¼ë§üg}ÿyÿÑEcóüoã l¶ñò7{É(QüÊøÙê¯Îg÷>Y¥¿úQ½Õ'®2Úúgðó¿øüxðÙÖFáVÆ§ëÉÿdñÈ*»ÕQãV&£DµGü³÷ìON9ýÏ>~øú_áïZæo¥9Èo5|Ëi?JJA(ëÍ2øM8;t[¸óÿL`´Ù«}º]r×þbÐ±1¯ÿ¨ÞþU&YvÛ 5ÊþÙäÿùK­H?ôðÓ%#üuþÓ]6Èz¢¯àç?]zÏðñßÃoÙP²#þs/ÿc)ÉÕ¯Îÿ¯ÏÓ¼Õ[Éë)þÍSýäé3ÊÿôÂonZÉMüæ&ÿ³¡ä?ÝðÉM½¯ÿ¿ßúgãÿ¿ñßõ÷X»ÿçã?{þîýs
?ìoÝÌïúÈõý·¼ß_¿¾ðËSô±Ç}'ÛJºü¿þd®Ï®Gýl^ñóÝðê»øäØeâ«ókò¿o,l4Võì³û§8ågýÅcÆUßÄ×gìÆwÝÿÅõèºáOÿØ¡;ã>yöà#rù~ýá'×ØµÔ?rÈ¤¡ÖD=uJ"^àÕ¯²ISÏ^xÙmrMºJ4í×nüt®ýõ9Ç7uj§Ã¾þøÕõ«+á)=ÆHv>Êu2É¾ÂÏ~ÊêlÔßâ=ólø³_±6[Ñ'ÝìOüô§,ýdù\ÝZd+£ú¦²©ÄøúaOülêË¶~ë¿z²é×NWùÝøs,á-¾H?æ_]ÐÆÿíÞ±fPñùêúßõ÷8vÿ=ÎHkªxÌõµûo÷ß¼»÷ü±;öüÝûç\{ÿ~-ÿÞücó}ÿ:ßEË·öýï<KÇ¼_7ÿÜüsóÏó;»sóïó¬Øüó¿ÝÎÊëªoæ\³lúµÙ$çùÌùK=ÃÇêp®ßã+[(Ê)£î1ö|²û¦«ßÒj__úøádÚ¬®O=J?ê«$f6È6¶ôÃg\8ñÓmlJºÑ3ü0Ê¹Ø(ì²5í0gÂGtÒãÓ§]_øÙh¬ÚdÐOö¯,>ÒÌ­ã»þdü»ìM;9\ÂRâõÄ×¦3ûÕñZP:}>Yrêhâã¥O,ª^?zê~h²ÑÔQ¸øðÉ%3ýÂ|}á'­£ëfÿ_,êOOû~|vÐ´.½é?¹ú®øýê®ßØÓÓFµÃÉN~O~²SôÈçóýÙÐFsþã±þ´O}½Ù¯>ñùÛü'°®øÉ}Àgsñ üsâ)æøÕ7þý'ß±þwýíþÛóÇ)s®=öüÝûçqçÚ{ÿwíæt?lþµùçæß÷ÿß}ÿÞ÷}ÿØ÷YÖ¾ÌüªS\ªÏ~õ==ÅK"6ÅM=ûþ)4ã.þ¬&ÿI¾râ×Ä	Ìä+YÄÎ«ÝüéþQg«>%yM¶ðW¸,ðfÿÁ¾ï_%3K6<¾OCÓnítô±«zzê|ëwu|2ÙRjgó~2é¡¦ÿ³¯ÿjÿ~GõVO&]tÅOoâ7ÿÙÖGïÛiøÛXÀãçB((9ÞÄÆ$tÕÃ#Ã>R4öýC÷ß<ìo,äÔã°n¯Øiã£ðÕ'~zÙïuÊr6AüÆÞ"vèÍxª{`g3ÿ§q=Ã'ÓøÔ³=íì¨£dðY¼ðñÕ§^ã~sú×%{G×Í²áã±Oá'M|ýpõáÏù?÷9¿â§ñãOæ=ü«ÿ¯ðÙø)|vóeñÏÿÆ×ßî¿·çogÆß=ÿöüÙó·µ´÷ÏÞ?Ïò¯½÷þÝûwïßùþ×±ùÇñwÐï¾nþµùW{ió¯Í¿6ÿz{ÏÚ~>ÿ¼]Fýq®zöýÕÝýûÇOî9Ôõìþ÷
¿<bâ³9Ï¿Æ=çâã÷=î_v¢tk7¦øág«ïÞáè¯Ïxðç¸²w°o|²QºäÕÉ¢+>~?<urÕê]=Dæ¯/\2êázz2ôülñÿðð²To¤/ÙÇËñ¿:ÿÈé7{èWú·Q~ÁasËÑu«êçTc¨®ºl PÐòäê/Èý¥/<raâeÿ¨ÞñM`øø(ûéÓã#¹êGõ&gÃ;üMöèDÙ¿ñ)ÓKNc©1±añ(;Ïð³Ì©qþ~ÅnXÓÚ«zã9­1øÙm®êSê+æÕ³«ß&<ª÷¹WÏÎ+|öò<rbÎ:9vÃW¢xÙWfû3øsé¾Ã.Þ_Õ»FdãÿÃ®¿soïþ;ã`e´?:·Z#{þ<î=wü¼ÿöþ9ÏÖîZ­öQ¼öWkhî+òõ§·ûï<fxíú{ä»ÿ¬Í¿;kÄ¢s$^çK{hî+òõ§·çÏ?ÖÈ\'­ëeÏß=÷ûÃç¿?u¾¶æ¾²êßó÷ÅÞ?ÿÞýcmÿ¹^«[¯¿{þOÛùþâInâÃõüÁÚGµÛ_?ÉèÏ¾dg=ÝxMþOèW×¦²®Õ®±éË®~þ(áÇ§o#ûÊlë3ü+fòÙ­®ïï~lDa©O|íðÓÕn^g?½)&ùÆN±_ñõ¡iGÆ6ñõ¡ôö~Óß9ßdòn¦IÈ¹Ú°£ 
L"í 6Q¶êMÞDùaL9ñ@%{&MülM|áIl¶&>>¹ü'ð_öÉà×>ªwü|ÌÄ'O&ü).=OþÕv¶Èj²eÌEIG/ÑÍ7ý}ê°1e´#òlÐøxáÕ5ödÓ-þïágüüÏF6÷b7åá¢7ð¾¿±6öÅ¬!1i}5gÚÿ·{[lPk¨55×u1K®õlº»þvýu[»ÿì=ÿ­gÅ¿{ÿt´¬
.ÌRç¨G½`5!ëFøìÄ/8é³W^|<U[=òl&½ÆØ8û¸Zdt§ÂÇGÙ±(&¾>:á'½|¨Ì¾vødÃ«_{@Ù}Múìy´ÓS²ýßxëøG÷ÝNøxêôè4f¸ã`ÝÇÃ82¿¾}çã?Røéãe{âãEøù?õÓÉ¯ðµ?ÂñSøüXü÷çã¿ëo÷ßãlí,svËß9ÿØØógÏ÷îß=÷üÝówÏ_÷NëÀ½öþÙûwó3ú÷O{hó¯Í¿6ÿz|r§ô¦;§{§Ò¾A{ÿìý³÷Ïãþëþq¿ôÍ }÷Ùï¯ìµÏÙ:ªw~íW8êúêm_Ç»âëãO?|íìuf6.tÉà!ýsmtÆN|¼ÆÇ¶1Mý0Ãøa5fíêGõOWß¿­Vÿ3üì[ÉÒNæ~±I_¯þ³Å¦GYõ9F¼(übØX¦~ºtâ_ñÍ3ý?m±§M'üìÐã<ßCÿq&:ät
TrøòBÏ>3ØGóFÙª­Ä+Àaà§Ï~g+^zúØ?=ýúu_]?[Å"ÿÂ¼ñ?=ÿ*ÎøÙ
;Ütã"oüÿ~ºðÂÈ¾qó¿ñ'{°n\|6ñ¡WñÇºäµ=×øgëèºõÃ"§ò!»Å§ñW×=Ï|þLüýË¼ÇÃì¯­þøññ7þ»þvÿíùsÎjû¡súïÿ{þæIb±÷ßc]íýæIlþ±ùÇælþá@=òÍ?ÿûËæßç~òwóï}ÿø»ï_ÖQß_?óýó+û¯÷ 9ÿÉ?ûþÚyyýþk¼WÿñÂU§ÂWöô{èä?¶M_³î!~O>;úÓoxðc/£z³ÿÉáCá+þÕ.{x_ÅþÏx¦n:7ýç£ñåwc&?ýOÁ'ë1ÿÿ¨ÞNr1ñæxó?ÜtÈÃ2®dðÔ{èÿvðOPË!Bxoâkf²õg-ýä{Uúáª©mucDÚÙ?ûÆ×xê}LWüdù¯îAaÀcsâ76rä_cø³?ß7}:ù_§áÏ¾ðÙÁg|®öÔ¿âkëþ§Ã¦zãðàGú'>Ú<}}êJýÿ:ÿá7ã__v´^øGõ>Þ+>»áÿÆL/ð§ÿõ}>ß>òñÍÊ9ÿ3»þÎsÄzø;û÷ß?{þ>îlçlgìÞgÎ²÷¯U±÷¯ýÐÞØûwïßÞ6ÿxä¤ö¸ yØ/½ÿák+7ÿÚükó¯Í¿öûËyGâ=Çç'¾öæg6ÿzÍAæúùû×üÊú#ÿìûoãRÎû<
£õ~}ÿ"Óüó·üÖÌ?Èá9[ò_ûÿÿ9±IfâÓ×Ö®øñ¿~4ñ-~%ÿ'>>94ñOÎÛË?;;ó^4ñÕ=ú'¾û/~ñ?X÷ùSGõÑ'¯]üñòÿ¨Þú¯øé59ÿì¡0ÔÉó×8ñ³/»äé~;5Èo7|Èé:zåhüd9ÍÉPÎ ÓñÔW°ýBnâg|­_[Ý¥cbÃÀ7¶'>vðÔ³E6y¥~º0Â¯NúÈÂ
ï#ül-þ¹þ6þç
]=Þ>ê»ÿÎsÆÙÑ]°çÏ¿{ÿìý»ùÇyOlþåÆ|ìòL%ê.¯lþQÕ:imX/õ©oþqî±Í¿6ÿ²öþÝû×¹ùÇÚåJÔ½_)7ÿxÜ±Å©Ø×ÿ¤û7¿>;ÿä_ù¯¯õ6÷_wóe¼Ö6jýÍ1LúõÍ¹§
dmeöN}t5Qµh|mé°¿&^:µÃ>ºîZ]:»ìçÇ´¥îÑÎÄW¿â[ü_í0`Cáç?òðáìé#ÃNõÆC@½±¿o3ÂÂo\ñùzm:sÖõ±¿W|c&OF=ÒÉÖÑuÇ#~ñO.´ó1[ltÕwÅ'£/ìâçïÄo¾[üs>7þ»þÚcí%{h÷ß¹.Í?oÏkdÏß½:3ºW­½ùgùÏæ|£³ÃÙücóîØÎëcóÍ?¬ÖÆæ_¹+ÖÚüsóÏîÍ?Ï=áïæß{ßxöýÓÚ@ÎÎÏäßµÏî_¼Wûý+>ìö©þÚê¨oÎêþóø:áQG?¿ÈªÓ¿1G&»ÉâÃGáG&ül4æWølNäØeÃF¶ÖK|ö"cM'[úÂËÿÚSfâçs¶ØPÇolÉÃ¯®_»wÛ£z#x­?ýpÉNüÙVG³úùrê'lû¡c:]0
\Á»vcJ~dõ êøxý¸"XSßdhÓó4Ûs¯L.Ú0[ðúÈyðÓQê#CGÍvºÅ0}|=òâÉ®Y¦¯EçIú1ñ;~üüa?ýäØ|Oé3Nº§q4^ýjçßÔkÜäõ³ì¡ìÓcK¶râòûOþþô+>;tÃ­|neþ/þÆ×ß¹ì3ûÃ^Úý÷8cÅeÏóêüßówï½7ÿ(ïªÜüë¼7Ê3Ý¨våægÞ¹ù÷æßoþíþ@ÎGõ}ÿØ÷kÁý¬	ß¿öýãíÞ(ïªÜükó/û¦<ó¨ÞèÚëå½û×4èÕþù;­?:öjÆÑ>úxSN]?R¶ÿñ=Ævõ#ùì"wj<Êôú1jê©»úo,{Êi¥£DÓÞgðé°ÛïónÄoþÂ76ÞÙz;üOÿ:î0^Í?t²S÷¯8Õ»^øÅzøÎ·Qü6Cì7)9Æ¡&D©ÔkWo|Úêõ«°dÖÝ®zqÅ×f±a1e;}S;úáÓê×VÏVøaN|2~~õâ~öa¡ðkÓ§y}Åû¨ÞÆ8ñOcÍ&ÙìÒWö©GõÃWÏf~°Qüéè÷4^õ0«+é{ÿ£z'ý¨ñßPøê_»1³31g~cg{Røxl}îâÿ:ÿâ²ñ?×8ìúÛý·çÏûçÿ±Möüýë¬øìý·÷ÏÞ¿lþqÍ¿7ÿÚüsóïÍ¿åûþ±ï_ûþ¹ïûþ¹ïï}ý;ïßÎkÎùQþ¡UªÏï¯Æª¦ýùýn>©{¬szÕ+[ÿlM
\ødÔ³S^xêÉô¾ÎÊVc	3Ý)§^[?Ùð´;Éáùþ?ÛÏð³©¤õöWç¹ìßx®û÷w::ÉkÏ±Íý+¾>¶zþgmD?<¥67ûÃ?%Î¿xöÈf÷¨~ø)V% W%3û§~ÁÆ#£-(µ=ÓNíu£øÉ¤{µ5ñ)_I^]ÉºÒm}Wüuih-åÄ!ý«Lmýè×ØÈ!md¨~õdÔõíÆSIV}â³uÅ×Nî¨ÞðÈñ_
·Î3|2ô=Gõ>ðó3|2?üêá*ÓøxÚáV¯?ÝÏâ·FÒ=LÜm¨/þcþ7þ»þvÿíùÓ¹[¹çïãÎØûç¼»÷þ}äòñpvFîRÏæg6ÿ:Ïë£3D}óÏÍ?{ÿÚü{óïÍ¿7ÿ.ï®ÜüûqgvwnþùÈ-ånþýÞûGgµÒR/ÿ,/yuþÐ³ Ö_m¥Çû>uv¯NF»>åÔÑú&¾±Îv2ÿ¹ÑÄW§Â¯}Å¯­øa5V¶ôgoö«SÖï_§ÅSÒEÊlÖ½éï%þ|ÿÄGÙ
¿y¾¶³IÞS;ül³©o§Í
_]ÿ­¡ðÆ#9<¦Ó_PrXýI,L|?ôXHýà5qØÔxïó½É+ÓQ'^>ãûÏJöÏ@ÉN¼ÆJ.ùçÔ={N{l¶âÅOãü*þÄ¬®'»ùO>ìéþô_å¿zxä`Æ#Ïgíæöû3øÉâw¶£Wøø_Å¿Æâ1æxã/'íú{¾ÿwÿíù³çï#ÿèì´/ºS®÷ÍµíIV={þÆI{þîù;óËòÏ½öþÙûgïÞÿ»;÷þ}ä×|ãÚvÃnþqÆ@,ZCÆImþµù×ãløÚÙö5úìùß½úÊÿú+³[»²³U%O½69ÚÉöûu9ïÿ£ù_áÒ¡?ífªOY½ïûµ&»á7¾uãÃAÊ¯àÓ	;¼Ïú«içêÿ39¼tì=ÛÿâòQþ}ÜlÍ8°Y[ãTÂ×õú¿¥üÄ~e.9¿ (»E'øxä&Í éòéÓurW
¿IVÔ&WÙ¦.½â7ñm<äØgêv§ü96'^¾ã¡gøÙË%9D_ý=üé?°è «îoñ£ãi,W|v²2ýJzÉÑÝ£M§xOýðõ©TïõøaLýbW½è=üô¾üâ?æ¿8nüß®kp×ß±°gæþoÝìþ;×ÍgÎ¿=öüÝûgïßÍ?6ÿ(ïîÝükó/wÃ¤Í?7ÿ´Ðæßûþ±ï_ç·F{¡{sß?÷ýÓØ÷ïsÈ#£êâ£Þ÷±újþIç½óÇUáÕÁôÄîßöq}§æ©7óß8dõ|{â';ñÓøÙ8Doöµõ÷#`²?ÿõEÕ×{ø0ÈE×ö+|ã§mzT:dsþ]?¹+5&:0ÌzqSÎzØû&§ÔßXØSoÞ+ÖÿkÃúÊ±1þÄè³ àÌS»	PõdSü!{%²&\zXð/»ë&_;ü9n6é_iLøêéÏENýìe[®øp¹	?ácåuz3°³ÝlWo_*ÏÖãoã½â§?Ç1e\²W|²lÖ÷
ÿ¹éÏNzJ8mêlÕÅÔnïáfóý{ñsU,ÄnÖ7þgvý=öqk¤=·û¯Hå?çZÙó÷íùº÷Ïãþßû÷qÏ87:[«ïý»÷¯µ°ùÇæóp~FÖÇ$m²{ÿîýÛZ°^6ÿØü£ï/mþe
	@ßxÔQÁR/XdLd²úÔãÓAJ:ÿYÉ;ñÃ9ºï:J6²×"ÔRzÁã#;0:ê­­|8ñÃ¢£â­}ÅÇ'ß¯æGõ]|ãA_
,è>ýäú[-*%L6Ù¿â¥/sÜIiÜù,>yþFýx?ÛJ¤Ï'N2ú&ÿþ!r£«|ôÿWüSëí\²Í[ùß¸Èëÿêøù¢äG:Úl_íá¥ó
eVóOÿ>^:Å7>zÓÿÅ?rP±ÜøïúÛýwe{þìù»÷ÏÞ¿y\¹ró¯GÎ´ùççòÿÍ¿÷ýcß¿öýsß¿Ï÷çá~ðõáqî÷ýþ°ßþÙï}ûë]÷3ñïÛÿv¦ÅSÆSÒ»ÿÏð±û·üÎle;=ãe}_{êh³åG%õúêMÞ³üdâ'Ç6ðõ±×%ú
>Ø	+[ÙfsâOðÓ?ª79ýWülTê'_ÂwÅ§v:ñÒ©ÍÖuþÖm|Ê9fí'þ'i¸ À¯®¼.æ8'¢:y?Æ ÅÇ«Ì®IEþå9õ5iú<L§î?±l¬~
Ý+~ýú&.¼4oxdèÀ&Sý¨Þ0õ_ñõåczÿçàå¿~zQuøêgþ?Ãg¾XÀ2>þÕú(¹xÏ±¤ý|jþ¯øle¾úuþ'Nþâ©#:_ý=üÖEóûþÄYü3Þÿ]s_ìþ{{þìù»÷Ï#ÿq¿ÎûïßÇþÍ?Î³óUþ7ïÍ¿6ÿ²_6ÿÜüsnþi=86ÿ~äb±ù×æá ¾¿ö~¶ù÷ßÿè¼ýìùÛwñWß_­Õ¾÷ndîà<Ëÿá{
^¶*óQYíù#ÙÑ¼ÿ ¦þ;øé4¦«ÿìÿ,þÆN6g;óÉ§âptßc Îøù__±"~%¹ælbg³±j£iO_:ÆÈîgñ¯þªw[ÓæâkeãoìúÛýw®kaÏÇ¹çïÞ?{ÿnþ±ù×y&ºÐ¼/Ë{ÞÂ³ùÿ}ÿ9×Bï]½Ú+ûþqÆh'nþ9÷Êæ_mþµù3áïæôçþ¥ó
ß3}'¸æ¿c³$cóþ?·Z©ÏC'»Þå§:ùìÅWÕÕ¾ÊßUGá¨÷+ã£ÿ3øégßüû|:Óÿb
æùMíæá¨¾±§/ùâ?ñW¢i«1£_½G;ÜÆªïÇ©ý8Ð_ 9§Ùd	ºÅ?[¿örêJTi¡ Z_|mNøM½lM:WxWY8ä!´_áçÃÄ'MÌêN²ñÂ¹Êâ·`ÙÖOÇ=ªwþôJ>¬+>ìe3ÙÆE'Þ´=üH%_ýjìðñè}oÜ¯ðÇWøa(?|ö*ÿ±þÄgõæ¿>åÆÿãõ_¼må®¿]ÎMë!jmh_ë»ÿ±*f{þìùóQþÑ^j?Uîù»çï¿3µ}²ù·HìýÛ9Y,6ÿxìÍ?n[dßÿ0lþqÆ`ÞóûOçGçIåæ_mþõ¸SÚ'sÍú?uÿÚ»ÏÆò
ß~6s¬sÿ§×¾¯üàñGß3|ýÉ«Gd[Cáë{>yºWvf=üY¾Ï6Ù(\mv³\2õM¹dè§>,u¤/~:x½+F}ú¯}ùß*ÉÊÆøÙ®¤¯î®}Ù¬ÿGÊ9¸x4J}M6ä
Hrø~üB]MüÙzØÑÎöÿ¯í­ì]ñµ'¾1[vêÛÄ¯Ï^ccÛ¿ ¼â¬»ÿú²ýâ©£â§Dég+WøéËõÆ}/y}?Ùý;3þGóFÏðud3üSúsóOÞÄçÛ{øtò_ý3øäÅßøïú{ìÿÝ{þìùû¸ÿÏÛâqkïýóÈöþ}äM­eùF¼ÚÙüëÃænþ¹ù§5ànØü{óïÍ¿7ÿ~ö=íÕ÷WçÆ3y¹y´ùçã[¡lþy®gù§uöl=½·þÜ[ZoñØë]¯øÓ{ÿ\íÑ¿â¡|&ßú×?eÕáÃ`Çù;íMý£ëÖ>zDi?ÃO>YíliÃñÏ2{dÒÁKï¨ÞiâcÖÎÞ¿ö?ô¿×XÂÏ¯)ßñÿÄÇÏÿð»Ú#ûc4úc 5Å¿ ;b|ýÙQ0|õÚt²{TïÇCÙW§Sò><¼l¼ÂÏÞÄ7®ì°`Ä:õùñ-ÿñÔûA®Ýéÿ´¥~õÿ3øôÈÁ,nêWÿßè¨O<õÙ&ÃÂþ§ßÌÕíüg/ýðËl­°ßØãÃ3üÆ~tßcñ
ßX7õÆO÷À7®Å?ã¾ñßõ·ûï<³öüÙówï3×úÉûïßÍ?6ÿÚü«ÜsóÍ?¼knþµù×æ_Íïîkâ;¿?mþ¹ùçwäl kT}~ïTm2óûïßÅ?ÌÝ¾³*?o,ïáç¹ë÷çþÙ°QwvøOöÚøôéyÈfkbàe§1õýùèz£cüO.*ÖtÃÃÓßò^XéMÞ{øÙkÜáMnú¿ØÈ¶±¥CF]ñµÉ\ýNþ'ÇVzxÙÌÿbC÷G©ý(È0ÎQ[ÙªÔÅ²¡¬ÞÄ
"Þ3ùO.Ì£z`ý¨RL«Âø.Öþû©ôéEµ³nl é'¼hâ'«/]<õüWâÑK>Ø³æÁ¾ùäPvjÜóï+|6ÂH¾vøáV"¼oRºÉäøú£÷ðõ¡+~þóîgðùäãýøsÖiñ ôó?c>ëÿ]»ÿvÿíù³çïÞ?"¹Ñwæ_óÎõ½÷þÝûwïß½÷þÝûwïßòÊ+üï?ÓÎ¬oþ±ùÇ1ÿ°Z»­ç¾¿·¯WÏÆQýô÷·öaºÙ{l20~ø7ÆñçÙù¯¯qg«2üd&~<%ù+~6|ríS»2ÝlûîÝïlÖO>¥'_Éh¼'2×XO7{ùO/ü£z£ì$Mm4¿qå7
¿zøÏ¾ÿ'3ÇvÅÏß¸Ã¯dóÇ¨ üÀÅð5ºDåô5õ+«àuçéK­or°¹x³©ßÄÒ÷°¯DWÌô¼Ù?ñ§~öÉÒ±S?Oø¯L}uD6_µÕe¶âÑ)d³çEòÉª#2êS¶XêøéóD/êÅ¯>¼é²/üâ§õßüë/¾yâë_üëÏ>ÙôßÃÏãù7ðóñ7þ»þgÞÜ¿ö6úý¿ûï<÷üÙógÏ=Ê9÷ü}äçí³÷ÏÞ¿¿¾ÿüÝ÷Í?6ÿðÎºù×æ_mþµù×óï¿ûþÿ=ù§õ%sß¸wÊ?êýû
Þwæÿl#6û>û
~³­~SþK¯ïÿl±7í7~ýêHùÌ¼yÿ¦K=ÊføôáO6[ÙÈ¥G¬ÙAéÿÿwðÔQþÅ+~ì³¦êé«GáÓÏVúdâMýt³Åg«ñeló§~í×&ËVøä¦~õ}£úá¨?¼Sëÿû7È"àð§ÓÛÂÀï1¹êX][Ø³õ°=²aÂo×G8ýì¶ô7¡á¬[ÿÄÇè¤ÆÿøHù
êªýlæ?>ªß¸éy¦ÿêxH¾2ôØ
§Ø¬Þ{þa6Â÷# øTïtÅÏgørþg(Ûù?ñÉNÿÓQþ_ñë#«<ºâëC??ãßÂ]|QØøïúûõüùÎý¿ûïÜg{þ=îPÙó÷\{þìùsÍÿöüý¾üsï½D`ïß½÷ýï<üÝüëÅæ_mþu}ÜüóçóÏNâ>Ì)ú(ÿ!ójþÝÆlÉ«Û7Gõþý»>w-½g¼>2ù¾oèÿ÷xúF}ÅÇÿ¨ÞqÈÕÂÇïþolõë£ë»×ïïé6ÞgøÚ=6ê(|6ßónsÅÿ÷ð18]='~>Ý7Y¥þüO¶ß_ØCÊtäùöôë`ÿ<5°Gúáó° ÐAÑâ%ß$U6S>_%9àZg?]©:YDG_¸Mê{øS>vÔKüu[ÌáÒm¬a+ÃU¢lÕøôÅsÚ´`'|þx¯]¿që3|4ñKgâÅ¯¯'ÿ*_XNrWürè«øt¾c_?È¸ó}úÃ/´øg¬þÎüãÆ×ßî¿Ç¹³çSaÏß½öþÝüã±Ê'7ÿ:ÏÇÍ?7ÿ+lþýëûï|_{ïýÓNÚ÷}ÿØ÷}ÿè½«róïGî5ÏÓÍ¿þüüËËß»ÿÌ+úÌù×÷Ý«ÝgùW9Xs,ì¡yÿÒ¹î¿d²§ôÌüW½ñGÉÏ}ülþÓ	ÏØQöðõ×>ª7Âk<Wü~g¨î3|z¨1CJ¼ì^ã_eréÌïïì¡ðÕóÿ>Ó.ÙxùÃF<eüêéÄ'¯þý[Û#2}4ïüêÉ^Kºl<£øMx!Ùlé· {nU=Ùð´Mpêô¡ø?ûúÃbÎúÄeWþ´w4ï6Õ#27L¥-8á'ÆÑu£d§þ3ü«¼v6É§Í+¾¾÷ðõÑ
ïZ^ñOéÇß¿OwñÏX^ã^{ã®ÖÙcå=â¦ö;ë×ßî¿=û¨»j{þìùcìù{îëßâ²÷Ï~%ÿÜûwïß½÷þgÁÌ;joþ±ùÇæg§åãoüÍ¿6ÿrüùgwØõû«µûÕü§õÞ¨}]ÿñ»SõO|ý+¾±¦£í£y§ìWõÿÉW×÷
_2/{ÆÌQ½6?ý?{Éè÷/ØP>7/xÓÜÆòJaãg3ÿ§lø¯ü'Knåÿ5®é?;Q6õª¿qeãìýþ6î
úß8§^ñ?LÜlõÿ=üìúÏv^×ÿÄã>`>Ã'Å/3þâÌÆ5þô£üjÓÿdþ±Óÿ] £@)g`­_{ò®6ôm2ÔÀdÓíì· ªn<2Õ	?ÌÆ¬6ìÔÎ>9ºÊtê]¤_;]¼Ïà7ætÓ¡Å/ÆìÕF¶Äú07Æ­ì?Ãýì{ÐÕí¯µ0ÇJ®öQ}?ÇÞXßÄ7Ö«ÏâÃ¼êâ±¹øµ³ñ·*ës×ßcÿïþûõÙóçíÿêü·§öü}+Ýo{ÿìý»ùÇæÎgÂæ_nÇ9¹ù×æ_Ö Úüó×jóÏÍ?gÎ=ëåÛíÚöÒæ¢°ßöýcß?ú^û»ùgkè½ï¿öZwú³ó§û}öwváÕO·'|?(K}Ù¨}tÝõ»2ûúÕôê¯ÏôiÃYwÞjAÙQoüS¯üÑIoáÙ¦÷Ìÿ){¼Ñ½â³5ñëþ~üü?ª7962h.
ü¿B
~öóù¸ûíÆ½øÿ]çnÿ·Gvÿ=Î=¢;ÿ÷ü}ÿØOí­½ÎXìý»÷ïÞ¿{ÿ:7ÿx¼º6ÿÚü«wØÍ?
], ¶Að¼§`ÎÉßb÷Í­/[É5±MÖ´E÷>ÞÔog± 6W¶Ò×wÅo1éCÚ9ÿÓÏÿ©£¾ñ¨·ð'>O}xQü0¡´ëÓ¾âã¯¯~öÒJ'«ü?»ä¯ñ×÷l¸ëF¯ðÃù|áVþÿÒÿÅ?×ôÆÿíþk]|eýïúÛý×¹S¹çÏñ÷o÷OûlÏ=ÊM¬ÖÅ¿Ï¿öþÙû§{§ò<}Ï¸ìùû8c÷þ9×DçìÞ¿µ±÷ÏÞ¿íÍ?6ÿøì÷¯Í¿6ÿ*ïªü7ò¯¾ÍºÓ#ãùüÞg×¿33¿+'>;½ã]ó¯96:l\ñõçcrÙ7>Y¤=1¦¾lÂ^  @ IDATïô³<Âïü¯®dË`©§¯¾ÍHûÿúéç«2å+ü9~:WÿÇÑu³×x^Å?üÆ_äã±ÑØÈI.~¸Úÿ*Ø@¤@5®&$¾±ª÷p`N69TÀg ¯òMXú-úMløtÉ{ðÈzü Gü¤ä¯øÉ³~¸õ±«²WßÄOï|ü%~õüÊýùú'¿¾gø¯üSØ?;øáL?ÂÏFºÚéúlEäÓ¼gñOÿ#|cú»øWÿsñÏõ¶ñ?ã`½>[ÿ»þvÿíùó÷Îÿ=ÏûÆ:rìý³÷ïæ86ÿÚüË:@JçBïPî	¼Í?6ÿ°~÷ý{ó¯Ç¾²6ÿÚükó¯Í¿ýa¹'ÿ Ý?î6ô,ÿ)÷yvÿ¥wjXêaWv;ÿû±lÎ?{3ÿª¯1èÃë{v¶à p+ñÈOÿÙÒßùSy°îþ«ñÀÈO¶&~ü}#òxd"¼ðñs¸dñ]|å?»á¿CôNá+£ÏFøìì¿VÈB¯&¿É*pÑØñ´Mv7'D¿ëy²ÏMxöé#ýõÍIÔ¯Oÿÿÿÿ;ä¯øùÀfúêÿhÞÆ>¤]¼æø_ùÅêùÉv}ìâ+ßÃúäù¢ÄGÊWñg[þÕ;~v§ñ¦ÿSÿ«øt§þ+üé?ÏâWþ/þÆ×ßÇû÷ßyßX+{þìù»÷Ï#ÿççõþßû÷¼_7ÿø5ÿ¶6ÿÚükÿë¡½áü¼¾ÿmþ±ùÇæ8Ð<?7ÿzûýkóÏs}lþ¹ùçõûw9Æ<?:Oêû(ÿhõýø³ç¹0ÞÃg÷½üç>=vë·þÿï_¶ðQøê_]¿Òß¿V7ÂkÓÿý!>ôûýD»±5~íùûÇgð+gû?'>ÙðÕá¿2éËüIð'>1C>ø'ç_øk
	LÁ*È,
#~¡Ä«/}?D5IùX_ò-´Cô¦¯MºÒC_ÛÄÆ-O}-ègøl¡ðÉN+>ÆÿðÉ¯õ¯ÛÅ(Wøùÿ
ÿ¸áÇÎ_>
_»ã?ýoüxé_ý?º~ÿ+|ü¯âÿ+~ãý·ðá6·sþëðñ7þ»þìçü»ñÿÿ|gï¿½ÿ7ÿyìwxÈ_¤ýüûUþËÆÞ?¢°÷ÏÞ?ý¶÷ÏÞ?{ÿ<öÃÞ?{ÿnþñçç_ò{Õýå>/7ü·ó?ã0&ß­£ÆxT_ædúýÞùÓÿ»0²Íÿú®þ×>DÞà¯yÿ³sÅ×Fåßd®øldºú_,ôÍùz¿±Ð	_ßÏüÿÿøô&~¶uÖæü«ÿù£,^á7F6êKnâëOö_'ù¨à(Q ^`Ìdk7dãå]ýñÙE&~,
_¿v¸áÕÎÆ!rÇy¯?ÜÊt'¾zøé\ñë7¶i£ñ*«OÿÙCáëËÖô}ÿù]}?FAñ¦®ñiÃ	·ò~c:TîøÅ{êLÿÉ>Ã'ÿ>úó?Y%ÊÿÎOàÃüÈÿÅÌuë_ÜÌY±ÑVÿêüÓÛø±1]ÿõÔSîú;ãrb÷ßÖx¨ïùs®gUMñêþ­ï_8ã³çïÞ?{ÿ>ÎÓÎåÞ¿g\ÿ>îñØûwóÍ¿6ÿr.nþùÈ»7ÿv;gc¹Ä¾ñëã§ß¿`üÔûÐWîÿ~ä¢÷Ìÿr«9æ¦Óz
_Þ~=È ië>dåÿ×ñ"÷üOÑíþË>{oý³ô5ÿø?rl^óoòéN|6´:ÊùWø;¿Ó¡ÏÎlð·¶z¸éÖ>Dþ]jàÿî(èÆs
?äÓ·1þ~6*§­Å>ÿÿÇZ¶Fæ)6øí;¥ö³õßº«¶výíú³.<H9ïgkf×ß¹Ïvÿíù³çï¹öþÙûwóÍ¿6ÿ<s(9*åÙJT^ó¯G\6ÿ||ãhÌ5³ù÷æßÎgÇæZÿòï¾ÿåüë~å<Kã;g{^Ý?Åø>[Ý÷Ú(û³ÄÏVü°?9:úÈû1ïºÿ¯ødPã¡÷Ì°«¿úWÿ§íð>ò?_ÂÔ®>ý¿ÊiáÂ¾6"JüðÔÿu2È?
1PSG;ëxµÓmôµ 3ðdðè¨×>ªw¹WøôP!üäÛdð²}Å·Ø>&Ûû3ødÓ	?Ìì>merù¥]=[l\ññÈ²§è¥Ýgø3FÉÍñ\ñÙ~/ùgøtÃk,µaO·vöò÷ðßónxÆ¢xo1Úøïúk=ìþ³#g©ú?çÑÚpZ/Îè= $6ÝYbuÞîý³÷µÐzè¼µNöþÝû·õÐÛYb}ìý³÷uÑÚØûwóÍ¿6ÿÜü{ß?öýK´ï_rrÆ|ÿdûwóãûÌûOwïÒèÿâ%s]ÿâðÌ:ÏÞ¿È¦3ëÅ|8×ü+>â-<ú_½q¦FzëöïÄ¯¯ø?Ãßòé²÷üü§7ñÕÑíH_ãÏ/}Ù¿öÔÍÆ¿RØDÆÓ¼&£ LAWoøWëÓ¶¦=}}Qí&zÊ§OvNvøäûÿcÃ÷#Ü´þÁ¾SøõMù6aýú`xò?uãÓÚlWìð¦ü+ü0ád£¾ÏÆ/dé¡+¾6
ëÿWüìT	²Qm%òsþõë_ý¨¾ô?;Á7.\òïáëGì[gßáÿâoüwýíþÛógÏß½öþÝüãÌ¯äYå|åÊæïûÇ¾íûç¾?¾¸ûîQçõUT»rß?÷ýsß?ÿ»ïöõïîºó¼øÝ÷?e§ò£ó¶³ç£ó§3=Ä~÷ÿì·²®:çnÊýÈ{Ç`ÿê?Þõý/üúùÿ?ÜÊÃÔñóð)~~(ÙIWü÷ö6Øà^ñkÏq¤;ññÈüd0"W4g¬UMÄ¤)¾ÉU/èM½&K=wúÊY§ïi¡Õ;%ÑøÚTÚÆ>ñÙ¿?»Jöð'¾6J¯:¬_<ÔßÃg«±N|<xõ¨Þ)üúág3øèfS}bª§þôÿè¾¹­÷ðÉù,¾ñ6Æ.¾_üÙ ûÿ¿ñßõwîéÝoÏÿÎ =Äy~tþïù»÷ßÞÿçÙücó¯Í?ïGöC9÷¬çûÇÞ?{ÿìý³÷ìý»÷ïÞ¿{ÿö}væ³þ¿)ÿè\üNÿËéØþLþeO~¯UªÓ3WuÒNÎdÏîÿ+fòÊëü×wtÝíâß÷¾¢×7ìt×.VÕ³ùìûO,{p´Ñ?ÿõ{ÈgëOeÿl'¾:ýüy½ú¦­µnà*[c&ÄÇÓÐÚGõV¯])øM6ëê2MÙl¨_ñp2C=òléøÓþÑu_¨>¨R}â×·LøìM|²É±æ	7äô¿²=ù Ìÿ£z£ðk_ñµMüé2ù]þÔ
§\wF¥¾lë¿¶Ãìû×3[ôØ+ÎtØ$Ò!n%l'K7b~2WÿµÑô|øáyßX³3íÓ¯þÇGþd*Ðs3ê&¨`7yÚ&Ú¢¨NdvÓka]ÛÉfîD&
'½ðÙóCÛ\lCN;½øëÆ×Fá+£ÏàïùüÄËnø×2üÆ¶2|6ÈMûÓÿYÏ+~~N|:ñGøÉ"÷X%÷þ3ÿÃÉn¶âÏ6ûÉ©×§èõ*ÙéÿwãyÅÿÅÿÜú3oÿÿ]­öü	uã_$6þÎ­=ÿwóÞ¿gÎY^òükï¿½ÿ7ÿùõ}Ì-3óÿn½ÄÞ¿{ÿnþ±ù×æ_îýþ³ß¿öýãñþá\üÎ÷öØïä_å·åuÙ?ÛÕÉNºâódÍÿì'üÚÙñ»Jîl8W|qNÿÿÿ¾y?%ÇÛáÅe2Éi£ý}ã³øù­pçx`%§ÈÏøÏïùû[ádÜ´w4ÿ2À?
®1^ÇZpõ	nÚd5	Mr9ÔÄWWúQÃ¤Vfó`Ý)|%©zãfoÖÃ<Ø÷ñ>Ã÷£VöáÏ­ä'>löõCnc2¿;YõIÎÔOí?õáø#ÿ§þÿÿWü0_ùÅÏïÆçGc©ÎïÅ;ÿÿsïîú;÷Æ±Eîôwö?#»ÿÎPîù³çïÞ?{ÿnþ±ù×æÎ÷¯Í¿7ÿßîÉ÷QÙüûñMÊùÊ÷qÜ÷Q8ïÜÍ?7ÿÜüsóÏWùgkã<1Î¿ßqÿ8w¾òý£3Û^áw(ÙöT§ÊÏæ³üëÿøôl__4ññÓSöÝ=]²êW2^DgâËý(K'Ê0ê­]å3ükþ9õ¯ñ×Mö´ßÃ?ºÿL*°æè£jRgðJ2Ñ@¼ÚÉÌEÐä+³UÿÔS÷$£rô£ôj+ÉZðúÒ×¢Îvýè}¡M|ü+>ßðÐwàó'ÌgñÇkäíQ½é5ÚùJ6=%Ê«ÿïáOÿa\ññ¢0Åþ<Ä>Ïzcøt¿hÿºþéÆÿÍuýïú;÷Oû¬øX7í­ê»ÿçëÓ?{þ{e¶µ²çï¿­ç5±ùÏælþá<ØüëíýPÎY\´7ÿÜü³u°ù÷ãÌ°G"ñ¤½ùçæßûþñö~ÙüûgÞ?ÄuÒgÎïAÝíåÃô<ïÝÿé¼:ÿ²ñêü£oâÍî3üú­ò`ÝÆ¬Èy®û/ÜÊ0³ßØ³­M¦~e}JÎÙ:ÿâ]ñ³ÓûçÕÿìÒU§þ³2üCìÿÉ£ióäü¡çO'Ú,Æ¬>Ç®~åÏÉdÃäôX ÈdGM¶6>{lLÛµßÃ'ÂoAâO_?,4ñ³wõ?>ùÆØ¯ÔðÃ&ÿül_ñ+{áwõÿ#ü÷âÏ?Øõ*þÁóÌÿgøäòó#ÿÉ}7~þ¦?µþÿ\#âõjý}eþ7þ»þwÿÛM{þìùÿÏß¿{þîù»çï¿{ÿìý»÷ïÞ¿åÿÔûx{þìù³çÏ?{þ<ÞKrôßùþ)Ñ³ï¯ÅÌwí?ß?ûýwâ÷mïÍï+t}ç§>¤?Ê%>;ÅgãUüµäØöð?£z#m6â_ñ?áWþûOgæÛïúÏþÕc
ß¸^áO~øtóW½6Ù?8ù_ l¬ê·ßªO¤¯~ül%«ÏÄÙxSöhÞp&þôèL|u<DGì´yµ¥=ñÇGÊ«Î?á§SûO¿±¥{õ6Êþ=}ôÊÿtùcñÃ÷Yÿ'>[??cu@ÜÇ|õÿ3øÅxÚ,&úù?eãßÙõ÷öüÙý÷ñù·çÏ×ï=÷ÒÞ?{ÿìýs®½÷þýêûÇÞ¿{ÿ~õýwóÍ?ú.°ù×æ_mþÕ·Í?Î»ÁZLäXÅE]ÞùüëP¿UÏÖ{ùÿgð§­gß¿ñ^ýþ_áLÿñô»3kÌúÈÎB_²Ý3JþÁGñÕ³U¿¾3|x?é4iÿ>L:è>[õ©Gìe3l%óÇü_!' ×àâ£"¹@øØDàk¢L$bsò>]í&=ûJýýë;¿«ãÏ_¨éÂ$ëÿ;Îh|G9®&ýêá³~öÙc7Ùðó%üCä]ÿ;+>;Óÿ+þô¿yjlê§ãW|6>/NWÿKñ/.Ú0µé¼òÿèú2>£þOâç³qT_üsç¼üÔüóÿ®¿ÖÂî¿Ýî=ç¹°çïÏä9ÅyóÍ¿öþÙûgï½7ÿ¸¥·÷âÍ?6ÿ°¾ûûÏæ_oÏÙÍ?ÿÌü³ïåÿõõïõý»½ø^þk}²áùèû³X±ÝùýÛ÷çÖº%þÉ=ùÏîæ|ßÿûþ
/]íúÒøúé£÷ð³ðqWüÆÍ~º~ºWüüÒ?ã6êô²1ñgÉ>Ãÿ¬ÿW|öÇ+ü9î÷ð{þ+'Þ´a¿çÿÔû
þÓÎâ?æ½9øîùßøïúßý;{þìù»÷ÏÛó°{§rïsÈqfþ7×Íæ?gÊ[;â%N¨üsó·ûm®#õbW¹ûï±vÿÝ¶ÒmOÍuÛÚ±^Z;»ÿkgÏóþÚówÏß}ÿ;Ïgæ<G;C;?{ÿ>ÎÐ½qÐuÝÄk½´~~òþÙ>þn|ãÎÏ®cøÿ×ývmOììAõ½¿þWù{Oÿ«ûïèºçPù¾>D=ÃÇO>}òÝ¸Ì×+ül¦«DñÕ¯øµ»âgC?|òáãýñTðþøþ5ÀÆ{´&¢EØ"m¯òÉe~¿<«ÏgNl8ôØ@0o²ÌÄ·HcC¯ðñ[X?ß8Ð+|}¯üòS_ùÏ.j¬êxÉÍ¾òÿ~qË^cÈî{ø×øgã+øWÿ\ÿóÚõw®gû÷ßß?ÿöü9ïÎî=÷üýlþ±çÏ?å)¿îù»ç¯5°÷Ïù>·÷ïÞ¿{ÿ>îÕ}ÿÛ÷?ûaßÏ;ræK?ÎÍ?Ïõaüä÷W(åk¿»þèÛÓh®gcÿà´ÿÓ+ÿñ}ÿ¿3æ>_Qòêùß¿\Ã{ÇÆßÁÏÆ3|ãxµþÓ;Dn2ÚdM{Ïd¬>|íûÿ5àÿ*»àçC¥à«È&B[ýÙäÆW²G&[GõV¿Úÿ¬lÁM|õ6Äuq±
ßø§ÿÿÏÎÿÆ×ßî?§àyfîù³çÏ?yÿîù»çï¿{þîý³÷ï¾íûçænþyærãþþµù÷æßÿüÛ>øï¿¯Ö¿oÚ¿»ÿõ³ßÉ}~ôý&bìbäÿ¦ÿ5JòÏü÷/ñúã¨Þd®ßÿÃÏ¶ò½ßæØãð³ñÿÓ_uz(_³{rÿ#
ß_èC´ÎÿäW0¯ð&~É1þ·ß¿µ¯}Öùì/ûÃò¿âOñèXþ!?Pßß^8r}Uý7ý×üþ¨~¾Ìõ¯=ÎôHýu½z~uÝÓÏýIÚç5ýÔ3Ì?r~ö»Uÿ°êúYÇ<þázæéCgýó^Îó¬áb=r-qè¿æ3y¶³Q0âÊÐjóÁ²'s\>$¾%9hêW'úÿw\sõ#¯9NÆÎÝ«úÕk{K?÷Â~²÷ô#÷ÌùÙÓ½oé÷üÈ~þ×Îÿ~özöüéçÉ¾nÿÈ¼öüÃ?ûËÿ¼ÿñ'¨ø³pøüSü)þ?Äâïæüß!@¡ú·ü»ßó¯½ÿc#ø¾^ÆÞ¡ã*ÿ,Äæä7.ô?ÛÄ6ÿËÿ#Å3æ÷W}¥ø+^cµ8ßG}ÿÅ§ gòÏ3úÙûüyVÚ°khgüçÌìõýûû ò¯éGï3çW?ûB´Þ;-gá¾Õ}O?rÐµó;·$þ¢¿óÝònÕâÃ¥õ¡:çÅ×ä\¼}Zh®e²HFc-óÈj¬skrðAÞ>-¤Ð÷þ>Z?û²ç#ú¹ÏÃ=rÝ:?û2§üÑýí@¬'ûêäüìuMÿ¼ßÏÔîôÿ÷ùÿöìïeLûHÿÏÿ?Åßâï¹þ(ÿ¬WË¿å_rÄg¼TTTTT¼üþSýUýUýµkêÅ[¾ÿåÛSßß°YôÈ÷çYÿ)ÏÚGôOùó÷ÿ©ÿ¼ßÙ¯fý,ô~dæ÷úÒ^HýôÕ¾¾ _ZHüXç~³uþ"ô7þá0?nC|àÓàáû0gr¯éò5|[I=
D~ù§üßè'ÆüÃï¯³æ}eg[üù¸øÃ¿&&æ³?q·¸¿1½ì³ëïÙÿ3úÑË~×ôìß~®Öï¹ÑÏÍõ»^Lä}ÛWv¶·ô»ÿe£¿ñ ü÷~í9ãÅR<t[çÖEbÞ5´Èé ®Ï?Ã¤eÎñ4*÷gµÝÿ{\È9tïOÿ¬ñÔÏê£e}i¡[çÇéÕ¯äÝ¾|ïÛóÓ2wOÿ­ó»ïÔÿèùÕÏnéç^=º9ÿGêÿ[ççþ¸÷Ï:ú{þÙÿË¤®Çò¿âOñwÇIý|ùHþ¿Ë?Wð¬þØõmñw×ÿÅí'ÅeÅßòOùw£N7gÐ'ÄçÖûõÇ«Äêêó«¾Ôûoï¿ÿjýI~øLûç»ï[¿¿áæ·£{¹O}öZþãÂ¿?ÜÊðÝëµó¢BÎ5×ôÏïÿì¯îçµïß¬UÅþ-ýGôO9ô;úç¿Dþ¾~ùÐmyØ>´Yèñð<»|¨´ÊÃWÖuåa ç=CVýö§¬ëÏke£g­ÆÄ>Ð-ýêµ=ëõ¹cöuôªÞÔï:Zh1òèwÏgõ£Ã{ ÿVýÞÿ=ýå|~t~~ÎþöþÙ_þ·l _øÌøWü)þÊ?ÖjØTü-þZ?ö;¾
{ðëôy¯©9îQ]È2v/Ç·ô{>îÃ5G÷r×ô³§úçGõ£Sß¢û{M¿ó´­:ÁÌþgé
yNáÿÒÿ°ìoÛ	6Âõhü¿³ÿËËÿ6®ù_ñ§ø[þ)ÿÉÕ¿Ë¨ª¿vPýUýYýÝûGï_/¿¿Ýúþå»¦ßCøPï;¯ôþÙûgï½ZS¸¿7þÞúþÇºkßÿöCßßÞ«ßóó K&aWî/ÿVüeei¡sýOú?àÇðt0Îë1È­Q1ÆØ'YæåiDëÂcL²ÇèÎû²Çùßq¹ÇÑý­y×Ãg<õ[DÐª_'VÞõêÎ÷èg½Îÿý¬yF¿úÔåø­çV?òÿô/<Âÿmþý=çÿù_ñ§ø»cMù§ü?·O~/îÕ¿åßòï3ïÕÕÕ;ÖVTTTUîXýùóêïù>ñùÿòÒrüQÇ|aîÑú9h®¿öýùkõ/?¤17×ÃõkÎï_ð&¡êc5ú¹o÷c,6òeÞ¹£û³þkÄZcôásA$%1<pcZdÓØ0D×±sÊcdXGßõG÷·~ùgý=s´ú½GöP¿r´ìÖ1¾§_È«³p9÷þ·_S?÷1÷û.ýÞ[úmÜ³¿ù¼Þk>ÿðÜÿÃÇ»ìï}ñ?ÿû3ò_ñ¯øg]OW\»VÿÿÊ¾ïÿËÿïyÿ­þ©þ!TUU=öý±ú«úë³ë/|¼þÝõ¿ß[ùýýý­öÏ?ìñ\ÔíÙüÃÚÂÿØê÷÷wî{^{ÿDyëoÇ®gçÇ[×èø0ÿùÐ9÷|ðÄ¼i42®Aã2ÎìË>Ì»V½¶®e^§qÝÔ?õÌ5èÂnéM?: ¹×kú=÷\sÖ¯Ì¼÷kúßr~÷¾§½ÜÓ¤çÃýpfÏm;Ïòøÿçÿ×çÏþóÿâ_ñ¿ügÞ·-ÿïz­úgÕãGø÷ìåo­«ªªªªª¬{l«ªü^Wý÷g×~[>{þþ«-ÄüO®ÿ°Ù·|-þébü[ëÖ}dýå}¸§öÀ½¿÷­¬ç¶u­ëØbÿyèæÀã hò5`88£ÜÑýÝ×XK­k4,ÇêyM?úpúkúöÅp»§è~æ¼/ÏO¿X<£,]gË}Ùÿlý÷Îîô¯gÁóhoÙÏìçþÛÖÅO³¿ü¯øSü!.pA´Åßëõñ³ü³ê:bÇ­úóú¯üSþ)ÿÊ?åßêª¯ê¯êÏêïÞ?zÿðËw.c#õ¢s?ùý=¿]~ÆùÙó#ëoöó?âýÏ{£´g~ÿ{¸~îå<sÿ,	ð¿ Ëù1*@Ö æ>äGû´ÎiPÈHÌ¹Æ}ÕÉTöñ+å®éÇ¹è³^ýÊËGkÜ¾ú^Ó,ëÔá^ð
úûoñ¿ø_ü/þ÷mÿÅr×[¾ÿþiù¢ ìûOúþ|Î¿ø¿'|þìÿßßýþÈïêKMtÖïø-ñ=ÿIÂ@¢mP-øÐNÒ©04wÒu½F<Äåhèk¼ô¹Ô?ûóÀµèÜë~Áb­kèO³M¿vÄ^È~~u¦_$Ö³ÿì/ÿ[¾@<ð	ãÄGÅ¿ËÆc_ÆÅ¿âñ·ø[ü-þÊ?dÅòoõGõWõçÕßóýe¡¹ýqï½ôþÑûGï_ÿþA~ÿøO²®÷~d°È{flßß.¿þ|ôï\¹¯üAåá×á1C\¦a2O!)OrÌ6ôÛjl´-s|bÎ»²÷ôcÈÈz¹­Î'1{Ið¹>KÿÜ_­?ýáý}­ÿç;¶?ÅâÏWÖ_Åßâ¯µ}ù§üSþ)ÿ>ûûGù·ü[þ]ßñ¸òOùç'ä¾µcË³}íûû{íßÿM%9?C¿{r¯]ú>ó÷ö7£ï&^" ÁÃÕÑ¦
O¡EVãeL2Æ58æ5z÷u|Ç´rk´þ:Çu&ý©>ÿGóêQV}òçøXú©ú¹ô·cZî¢Ï5é£ÎÖw£3ýáýMïÛ.~:ãñþkñçìoç1ûçù_þ'l*ÿm,?ÅßòÏÊÉÄÉòïþß×UÜÿ;×[ç1Q×¤òÏF£üSþ)ÿÄÉòoùo¾}ÿøû¿ÿèÓß]ÿìjcõ>£þ?¸q^ì¢ïüÜ1O¬ÉÏüþ1Ïu,ý·éú¿Æ>½FeËÌ«i´²ÆIÂCFcÕÖ4Dùs½zy¹Ä¸Ýs­\ÏúÑ§^×3æ²V¯=é«õ¬£U¯û<¢®wÝ³úD¿g§XóúÑé=ÐOøg_çÿù_ñ§ø»kòOù§üSþùªú»ü[þ-ÿ{ÿ&öþ_ýYýYýYýù§Öü¿s_öñçüýöè÷göøú=¹·|÷ÿè÷w¿ëÓr¡Öõ¶ë2G+Ï?×#2ô
ãâïÆÇø*>¶ÆXç'ÎÁûWã¯xÔ@\AÀÀÀAdúÌ+C;e5Ó¿eS÷7åéO¾c×(;eèCé_8ð×g%6âþÙ¾¤ML{¡?ù]£ì¡åþæmC{)þ%ÚÄôúïØ5ÊNúPñgáÀßâÏÂBÛÐ^?Åc61ýþä;v²S>TüY8ð·ø³°Ð6´âOñÇX¢ML¡?ù]£ì¡ü-þ,,´
H;Êþ6&àshc^£çù6¤ÑjW´òoÙÙ-þ±ôBÎko´ãì/ûËþ¶åÅb#>A[ü=@8È<b"NÌùð ×oh!Ç¬+þlLÁC\iÅZÏ8ßâK/ä¼xÓBÃ?ûËÿ¶åÅb#>A[ü=@8È<RþÙ6¡Ïx¸oi!Ç¬+þnLÁC\iCâxÆù­ÚëÄrü'ã¿î´¿!_3H06ØÐÄd
Û6&ðë_Ó¯&ÎËrìåcñ xÓcçÅwâ*ÖÈ8/oÊ1økÚí´·ìï%â£M¿X:/oÊ±ÿåÚö@ÿÂ¶|Æú×ô«¥óò¦{@ùßÆX<h'ÞôçØyñ¸52ÎËrÌCáþÚö@;í-û{øè_Ó¯&ÎËrìåï÷¿dC þ*´Fc¨­ÉÈ`*_ù¹Þ}£u}eKÿÆ|ÀC|mÃãFâBÿl?Ús´Ù(,Êÿ¶ÍÈÙ~ò¿í_úYñ§ø£_à3ÚÅ5ÿ)þÊ"0Ê?þvÎlDLë_¶ÅßâoñwÇQýBþSþEåCùWØ¹F?)ÿlL@É8;[ú)þ,<À\¿ýJ+þ  ¨IDATlh? °H[§³ýèg³¥ï]ò¿moÕþ@ü8z3XrÈs@d,ÑG~Iüy)ë~î£<cúé?@8H|Äkâ´$LøgØö¢Lß£Ï¼­6)>2û);åÄÞ9åKñoÚ öý-?Ñ§ð#ýýüTv<«Ó(þèS`C§é{ú­NyxÙ_þWüÁ+¶?é+ú~¦xå/qycñGåÓGr^ù)·$òÌ)¯ÜÔ­^[÷dåáÑGr?e§ÜH?ØØ8Á²âygþÙ_þw8ÂAúþ¢_ÉW&ÿ+þ·¿è'3÷ÐÇolõ)|Hyxôô3e§ÜØ{2§¼r¥_Ýµ!ÿ(A9Ç/ÇsîÝÿùÅ`
øË éx¸uÇçÈ9[<ÖX°}ç«C~úAbØÿK»íVÛ6ým£eU»ÕÄÒ¾3Îþ¶½MÅ(ûÛ>(&ù_þ7c}íÃ1ñÅ3ûÊ¿åí#ø4}¦üSþÑ´òoùwæXûÚãsg_¹òoù·ü»ó-~7æSþµü³Ðèo@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|+ÿ9ÄObÉB    IEND®B`
./test/.gitattributes	[[[1
1
*.foo filter=reverse diff=reverse
./test/.gitconfig	[[[1
6
[filter "reverse"]
  clean = "rev"
  smudge = "rev"

[diff "reverse"]
  textconv = "cat"
./test/cp932.txt	[[[1
8
The quick brown fox jumps
over the lazy dog

¢ëÍÉÙÖÆ¿èÊéð
í©æ½ê»ÂËÈçÞ
¤îÌ¨­âÜ¯Ó±¦Ä
 ³«äßÝµïÐà¹·

./test/fixture.foo	[[[1
4
one
two
three
four
./test/fixture.txt	[[[1
11
a
b
c
d
e
f
g
h
i
j

./test/fixture_dos.txt	[[[1
11
a
b
c
d
e
f
g
h
i
j

./test/fixture_dos_noeol.txt	[[[1
7
a
b
c
d
e
f
g
./test/runner.vim	[[[1
162
"
" Adapted from https://github.com/vim/vim/blob/master/src/testdir/runtest.vim
"
" When debugging tests it can help to write debug output:
"    call Log('oh noes')
"

function RunTest(test)
  if exists("*SetUp")
    call SetUp()
  endif

  try
    execute 'call '.a:test
  catch
    call Exception()
    let s:errored = 1
  endtry

  if exists("*TearDown")
    call TearDown()
  endif
endfunction

function Log(msg)
  if type(a:msg) == type('')
    call add(s:messages, a:msg)
  elseif type(a:msg) == type([])
    call extend(s:messages, a:msg)
  else
    call add(v:errors, 'Exception: unsupported type: '.type(a:msg))
  endif
endfunction

function Exception()
  call add(v:errors, v:throwpoint.'..'.'Exception: '.v:exception)
endfunction

" Shuffles list in place.
function Shuffle(list)
  " Fisher-Yates-Durstenfeld-Knuth
  let n = len(a:list)
  if n < 2
    return a:list
  endif
  for i in range(0, n-2)
    let j = Random(0, n-i-1)
    let e = a:list[i]
    let a:list[i] = a:list[i+j]
    let a:list[i+j] = e
  endfor
  return a:list
endfunction

" Returns a pseudorandom integer i such that 0 <= i <= max
function Random(min, max)
  if has('unix')
    let i = system('echo $RANDOM')  " 0 <= i <= 32767
  else
    let i = system('echo %RANDOM%')  " 0 <= i <= 32767
  endif
  return i * (a:max - a:min + 1) / 32768 + a:min
endfunction

function FriendlyName(test_name)
  return substitute(a:test_name[5:-3], '_', ' ', 'g')
endfunction

function Align(left, right)
  if type(a:right) == type([])
    let result = []
    for s in a:right
      if empty(result)
        call add(result, printf('%-'.s:indent.'S', a:left).s)
      else
        call add(result, printf('%-'.s:indent.'S',     '').s)
      endif
    endfor
    return result
  endif

  return printf('%-'.s:indent.'S', a:left).a:right
endfunction

let g:testname = expand('%')
let s:errored = 0
let s:done = 0
let s:fail = 0
let s:errors = 0
let s:messages = []
let s:indent = ''

call Log(g:testname.':')

" Source the test script.
try
  source %
catch
  let s:errors += 1
  call Exception()
endtry

" Locate the test functions.
set nomore
redir @q
silent function /^Test_
redir END
let s:tests = split(substitute(@q, 'function \(\k*()\)', '\1', 'g'))

" If there is another argument, filter test-functions' names against it.
if argc() > 1
  let s:tests = filter(s:tests, 'v:val =~ argv(1)')
endif

let s:indent = max(map(copy(s:tests), {_, val -> len(FriendlyName(val))}))

" Run the tests in random order.
for test in Shuffle(s:tests)
  call RunTest(test)
  let s:done += 1

  let friendly_name = FriendlyName(test)
  if len(v:errors) == 0
    call Log(Align(friendly_name, ' - ok'))
  else
    if s:errored
      let s:errors += 1
      let s:errored = 0
    else
      let s:fail += 1
    endif
    call Log(Align(friendly_name, ' - not ok'))

    let i = 0
    for error in v:errors
      if i != 0
        call Log(Align('','   ! ----'))
      endif
      for trace in reverse(split(error, '\.\.'))
        call Log(Align('', '   ! '.trace))
      endfor
      let i += 1
    endfor

    let v:errors = []
  endif
endfor

let summary = [
      \ s:done.(  s:done   == 1 ? ' test'    : ' tests'),
      \ s:errors.(s:errors == 1 ? ' error'   : ' errors'),
      \ s:fail.(  s:fail   == 1 ? ' failure' : ' failures'),
      \ ]
call Log('')
call Log(join(summary, ', '))

split messages.log
call append(line('$'), s:messages)
write

qall!

./test/test	[[[1
21
#!/usr/bin/env bash

VIM="/Applications/MacVim.app/Contents/MacOS/Vim -v"

export VIM_GITGUTTER_TEST=1

$VIM -u NONE -U NONE -N                      \
  --cmd 'set rtp+=../'                       \
  --cmd 'let g:gitgutter_async=0'            \
  --cmd 'source ../plugin/gitgutter.vim'     \
  -S runner.vim                              \
  test_*.vim                                 \
  "$@"

cat messages.log

grep -q "0 errors, 0 failures" messages.log
status=$?
rm messages.log
exit $status

./test/test_gitgutter.vim	[[[1
1217
let s:current_dir = expand('%:p:h')
let s:test_repo   = s:current_dir.'/test-repo'
let s:bufnr       = bufnr('')

"
" Helpers
"

" Ignores unexpected keys in actual.
function s:assert_list_of_dicts(expected, actual)
  if empty(a:expected)
    call assert_equal([], a:actual)
    return
  endif

  let expected_keys = keys(a:expected[0])

  for dict in a:actual
    for k in keys(dict)
      if index(expected_keys, k) == -1
        call remove(dict, k)
      endif
    endfor
  endfor

  call assert_equal(a:expected, a:actual)
endfunction

" Ignores unexpected keys.
"
" expected - list of signs
function s:assert_signs(expected, filename)
  let actual = sign_getplaced(a:filename, {'group': 'gitgutter'})[0].signs
  call s:assert_list_of_dicts(a:expected, actual)
endfunction

function s:git_diff(...)
  return split(system('git diff -U0 '.(a:0 ? a:1 : 'fixture.txt')), '\n')
endfunction

function s:git_diff_staged(...)
  return split(system('git diff -U0 --staged '.(a:0 ? a:1 : 'fixture.txt')), '\n')
endfunction

function s:trigger_gitgutter()
  doautocmd CursorHold
endfunction


"
" SetUp / TearDown
"

function SetUp()
  call system("git init ".s:test_repo.
        \ " && cd ".s:test_repo.
        \ " && cp ../.gitconfig .".
        \ " && cp ../.gitattributes .".
        \ " && cp ../fixture.foo .".
        \ " && cp ../fixture.txt .".
        \ " && cp ../fixture_dos.txt .".
        \ " && cp ../fixture_dos_noeol.txt .".
        \ " && git add . && git commit -m 'initial'".
        \ " && git config diff.mnemonicPrefix false")
  execute ':cd' s:test_repo
  edit! fixture.txt
  call gitgutter#sign#reset()

  " FIXME why won't vim autoload the file?
  execute 'source' '../../autoload/gitgutter/diff_highlight.vim'
  execute 'source' '../../autoload/gitgutter/fold.vim'
endfunction

function TearDown()
  " delete all buffers except this one
  " TODO: move to runner.vim, accounting for multiple test files
  if s:bufnr > 1
    silent! execute '1,'.s:bufnr-1.'bdelete!'
  endif
  silent! execute s:bufnr+1.',$bdelete!'

  execute ':cd' s:current_dir
  call system("rm -rf ".s:test_repo)
endfunction

"
" The tests
"

function Test_add_lines()
  normal ggo*
  call s:trigger_gitgutter()

  let expected = [{'lnum': 2, 'name': 'GitGutterLineAdded', 'group': 'gitgutter', 'priority': 10}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_add_lines_fish()
  let _shell = &shell
  set shell=/usr/local/bin/fish

  normal ggo*
  call s:trigger_gitgutter()

  let expected = [{'lnum': 2, 'name': 'GitGutterLineAdded'}]
  call s:assert_signs(expected, 'fixture.txt')

  let &shell = _shell
endfunction


function Test_modify_lines()
  normal ggi*
  call s:trigger_gitgutter()

  let expected = [{'lnum': 1, 'name': 'GitGutterLineModified'}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_remove_lines()
  execute '5d'
  call s:trigger_gitgutter()

  let expected = [{'lnum': 4, 'name': 'GitGutterLineRemoved'}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_remove_first_lines()
  execute '1d'
  call s:trigger_gitgutter()

  let expected = [{'lnum': 1, 'name': 'GitGutterLineRemovedFirstLine'}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_priority()
  let g:gitgutter_sign_priority = 5

  execute '1d'
  call s:trigger_gitgutter()

  call s:assert_signs([{'priority': 5}], 'fixture.txt')

  let g:gitgutter_sign_priority = 10
endfunction


function Test_overlapping_hunks()
  execute '3d'
  execute '1d'
  call s:trigger_gitgutter()

  let expected = [{'lnum': 1, 'name': 'GitGutterLineRemovedAboveAndBelow'}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_edit_file_with_same_name_as_a_branch()
  normal 5Gi*
  call system('git checkout -b fixture.txt')
  call s:trigger_gitgutter()

  let expected = [{'lnum': 5, 'name': 'GitGutterLineModified'}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_file_added_to_git()
  let tmpfile = 'fileAddedToGit.tmp'
  call system('touch '.tmpfile.' && git add '.tmpfile)
  execute 'edit '.tmpfile
  normal ihello
  call s:trigger_gitgutter()

  let expected = [{'lnum': 1, 'name': 'GitGutterLineAdded'}]
  call s:assert_signs(expected, 'fileAddedToGit.tmp')
endfunction


function Test_filename_with_equals()
  call system('touch =fixture=.txt && git add =fixture=.txt')
  edit =fixture=.txt
  normal ggo*
  call s:trigger_gitgutter()

  let expected = [
        \ {'lnum': 1, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 2, 'name': 'GitGutterLineAdded'}
        \ ]
  call s:assert_signs(expected, '=fixture=.txt')
endfunction


function Test_filename_with_square_brackets()
  call system('touch fix[tu]re.txt && git add fix[tu]re.txt')
  edit fix[tu]re.txt
  normal ggo*
  call s:trigger_gitgutter()

  let expected = [
        \ {'lnum': 1, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 2, 'name': 'GitGutterLineAdded'}
        \ ]
  call s:assert_signs(expected, 'fix[tu]re.txt')
endfunction


function Test_filename_with_space()
  call system('touch fix\ ture.txt && git add fix\ ture.txt')
  edit fix\ ture.txt
  normal ggo*
  call s:trigger_gitgutter()

  let expected = [
        \ {'lnum': 1, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 2, 'name': 'GitGutterLineAdded'}
        \ ]
  call s:assert_signs(expected, 'fix\ ture.txt')
endfunction


function Test_filename_leading_dash()
  call system('touch -- -fixture.txt && git add -- -fixture.txt')
  edit -fixture.txt
  normal ggo*
  call s:trigger_gitgutter()

  let expected = [
        \ {'lnum': 1, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 2, 'name': 'GitGutterLineAdded'}
        \ ]
  call s:assert_signs(expected, '-fixture.txt')
endfunction


function Test_filename_umlaut()
  call system('touch -- fixtüre.txt && git add -- fixtüre.txt')
  edit fixtüre.txt
  normal ggo*
  call s:trigger_gitgutter()

  let expected = [
        \ {'lnum': 1, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 2, 'name': 'GitGutterLineAdded'}
        \ ]
  call s:assert_signs(expected, 'fixtüre.txt')
endfunction


" FIXME: this test fails when it is the first (or only) test to be run
function Test_follow_symlink()
  let tmp = 'symlink'
  call system('ln -nfs fixture.txt '.tmp)
  execute 'edit '.tmp
  6d
  call s:trigger_gitgutter()

  let expected = [{'lnum': 5, 'name': 'GitGutterLineRemoved'}]
  call s:assert_signs(expected, 'symlink')
endfunction


function Test_keep_alt()
  enew
  execute "normal! \<C-^>"

  call assert_equal('fixture.txt', bufname(''))
  call assert_equal('',            bufname('#'))

  normal ggx
  call s:trigger_gitgutter()

  call assert_equal('', bufname('#'))
endfunction


function Test_keep_modified()
  normal 5Go*
  call assert_equal(1, getbufvar('', '&modified'))

  call s:trigger_gitgutter()

  call assert_equal(1, getbufvar('', '&modified'))
endfunction


function Test_keep_op_marks()
  normal 5Go*
  call assert_equal([0,6,1,0], getpos("'["))
  call assert_equal([0,6,2,0], getpos("']"))

  call s:trigger_gitgutter()

  call assert_equal([0,6,1,0], getpos("'["))
  call assert_equal([0,6,2,0], getpos("']"))
endfunction


function Test_no_modifications()
  call s:assert_signs([], 'fixture.txt')
endfunction


function Test_orphaned_signs()
  execute "normal 5GoX\<CR>Y"
  call s:trigger_gitgutter()
  6d
  call s:trigger_gitgutter()

  let expected = [{'lnum': 6, 'name': 'GitGutterLineAdded'}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_untracked_file_outside_repo()
  let tmp = tempname()
  call system('touch '.tmp)
  execute 'edit '.tmp

  call s:assert_signs([], tmp)
endfunction


function Test_untracked_file_within_repo()
  let tmp = 'untrackedFileWithinRepo.tmp'
  call system('touch '.tmp)
  execute 'edit '.tmp
  normal ggo*
  call s:trigger_gitgutter()

  call s:assert_signs([], tmp)
  call assert_equal(-2, b:gitgutter.path)

  call system('rm '.tmp)
endfunction


function Test_untracked_file_square_brackets_within_repo()
  let tmp = '[un]trackedFileWithinRepo.tmp'
  call system('touch '.tmp)
  execute 'edit '.tmp
  normal ggo*
  call s:trigger_gitgutter()

  call s:assert_signs([], tmp)

  call system('rm '.tmp)
endfunction


function Test_file_unknown_in_base()
  let starting_branch = system('git branch --show-current')
  let starting_branch = 'main'
  call system('git checkout -b some-feature')
  let tmp = 'file-on-this-branch-only.tmp'
  call system('echo "hi" > '.tmp.' && git add '.tmp)
  execute 'edit '.tmp
  let g:gitgutter_diff_base = starting_branch
  GitGutter
  let expected = [{'lnum': 1, 'name': 'GitGutterLineAdded', 'group': 'gitgutter', 'priority': 10}]
  call s:assert_signs(expected, tmp)
  let g:gitgutter_diff_base = ''
endfunction


function Test_hunk_outside_noop()
  5
  GitGutterStageHunk

  call s:assert_signs([], 'fixture.txt')
  call assert_equal([], s:git_diff())
  call assert_equal([], s:git_diff_staged())

  GitGutterUndoHunk

  call s:assert_signs([], 'fixture.txt')
  call assert_equal([], s:git_diff())
  call assert_equal([], s:git_diff_staged())
endfunction


function Test_preview()
  normal 5Gi*
  GitGutterPreviewHunk

  wincmd P
  call assert_equal(2, line('$'))
  call assert_equal('-e', getline(1))
  call assert_equal('+*e', getline(2))
  wincmd p
endfunction


function Test_preview_dos()
  edit! fixture_dos.txt

  normal 5Gi*
  GitGutterPreviewHunk

  wincmd P
  call assert_equal(2, line('$'))
  call assert_equal('-e', getline(1))
  call assert_equal('+*e', getline(2))
  wincmd p
endfunction


function Test_dos_noeol()
  edit! fixture_dos_noeol.txt
  GitGutter

  call s:assert_signs([], 'fixture_dos_noeol.txt')
endfunction


function Test_hunk_stage()
  let _shell = &shell
  set shell=foo

  normal 5Gi*
  GitGutterStageHunk

  call assert_equal('foo', &shell)
  let &shell = _shell

  call s:assert_signs([], 'fixture.txt')

  " Buffer is unsaved
  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index ae8e546..f5c6aff 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5 +5 @@ d',
        \ '-*e',
        \ '+e'
        \ ]
  call assert_equal(expected, s:git_diff())

  " Index has been updated
  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..ae8e546 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5 +5 @@ d',
        \ '-e',
        \ '+*e'
        \ ]
  call assert_equal(expected, s:git_diff_staged())

  " Save the buffer
  write

  call assert_equal([], s:git_diff())
endfunction


function Test_hunk_stage_nearby_hunk()
  execute "normal! 2Gox\<CR>y\<CR>z"
  normal 2jdd
  normal k
  GitGutterStageHunk

  let expected = [
        \ {'lnum': 3, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 4, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 5, 'name': 'GitGutterLineAdded'}
        \ ]
  call s:assert_signs(expected, 'fixture.txt')

  " Buffer is unsaved
  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index 53b13df..f5c6aff 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -3,0 +4 @@ c',
        \ '+d',
        \ ]
  call assert_equal(expected, s:git_diff())

  " Index has been updated
  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..53b13df 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -4 +3,0 @@ c',
        \ '-d',
        \ ]
  call assert_equal(expected, s:git_diff_staged())

  " Save the buffer
  write

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index 53b13df..8fdfda7 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -2,0 +3,3 @@ b',
        \ '+x',
        \ '+y',
        \ '+z',
        \ ]
  call assert_equal(expected, s:git_diff())
endfunction


function Test_hunk_stage_partial_visual_added()
  call append(5, ['A','B','C','D'])
  execute "normal 7GVj:GitGutterStageHunk\<CR>"

  let expected = [
        \ {'lnum': 6, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 9, 'name': 'GitGutterLineAdded'},
        \ ]
  call s:assert_signs(expected, 'fixture.txt')

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index 8a7026e..f5c6aff 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -6,2 +5,0 @@ e',
        \ '-B',
        \ '-C',
        \ ]
  call assert_equal(expected, s:git_diff())

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..8a7026e 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5,0 +6,2 @@ e',
        \ '+B',
        \ '+C',
        \ ]
  call assert_equal(expected, s:git_diff_staged())
endfunction


function Test_hunk_stage_partial_cmd_added()
  call append(5, ['A','B','C','D'])
  6
  7,8GitGutterStageHunk

  let expected = [
        \ {'lnum': 6, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 9, 'name': 'GitGutterLineAdded'},
        \ ]
  call s:assert_signs(expected, 'fixture.txt')

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index 8a7026e..f5c6aff 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -6,2 +5,0 @@ e',
        \ '-B',
        \ '-C',
        \ ]
  call assert_equal(expected, s:git_diff())

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..8a7026e 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5,0 +6,2 @@ e',
        \ '+B',
        \ '+C',
        \ ]
  call assert_equal(expected, s:git_diff_staged())
endfunction


function Test_hunk_stage_partial_preview_added()
  call append(5, ['A','B','C','D'])
  6
  GitGutterPreviewHunk
  wincmd P

  " remove C and A so we stage B and D
  3delete
  1delete

  GitGutterStageHunk
  write

  let expected = [
        \ {'lnum': 6, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 8, 'name': 'GitGutterLineAdded'},
        \ ]
  call s:assert_signs(expected, 'fixture.txt')

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index 975852f..3dd23a3 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5,0 +6 @@ e',
        \ '+A',
        \ '@@ -6,0 +8 @@ B',
        \ '+C',
        \ ]
  call assert_equal(expected, s:git_diff())

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..975852f 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5,0 +6,2 @@ e',
        \ '+B',
        \ '+D',
        \ ]
  call assert_equal(expected, s:git_diff_staged())
endfunction


function Test_hunk_stage_preview_write()
  call append(5, ['A','B','C','D'])
  6
  GitGutterPreviewHunk
  wincmd P

  " preview window
  call feedkeys(":w\<CR>", 'tx')
  " original window
  write

  call s:assert_signs([], 'fixture.txt')

  call assert_equal([], s:git_diff())

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..3dd23a3 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5,0 +6,4 @@ e',
        \ '+A',
        \ '+B',
        \ '+C',
        \ '+D',
        \ ]
  call assert_equal(expected, s:git_diff_staged())
endfunction


function Test_hunk_stage_partial_preview_added_removed()
  4,5delete
  call append(3, ['A','B','C','D'])
  4
  GitGutterPreviewHunk
  wincmd P

  " -d
  " -e
  " +A
  " +B
  " +C
  " +D

  " remove D and d so they do not get staged
  6delete
  1delete

  GitGutterStageHunk
  write

  let expected = [
        \ {'lnum': 3, 'name': 'GitGutterLineRemoved'},
        \ {'lnum': 7, 'name': 'GitGutterLineAdded'},
        \ ]
  call s:assert_signs(expected, 'fixture.txt')

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index 9a19589..e63fb0a 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -4 +3,0 @@ c',
        \ '-d',
        \ '@@ -7,0 +7 @@ C',
        \ '+D',
        \ ]
  call assert_equal(expected, s:git_diff())

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..9a19589 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -5 +5,3 @@ d',
        \ '-e',
        \ '+A',
        \ '+B',
        \ '+C',
        \ ]
  call assert_equal(expected, s:git_diff_staged())
endfunction


function Test_hunk_undo()
  let _shell = &shell
  set shell=foo

  normal 5Gi*
  GitGutterUndoHunk

  call assert_equal('foo', &shell)
  let &shell = _shell

  call s:assert_signs([], 'fixture.txt')
  call assert_equal([], s:git_diff())
  call assert_equal([], s:git_diff_staged())
  call assert_equal('e', getline(5))
endfunction


function Test_hunk_undo_dos()
  edit! fixture_dos.txt

  normal 5Gi*
  GitGutterUndoHunk

  call s:assert_signs([], 'fixture_dos.txt')
  call assert_equal([], s:git_diff('fixture_dos.txt'))
  call assert_equal([], s:git_diff_staged('fixture_dos.txt'))
  call assert_equal('e', getline(5))
endfunction


function Test_undo_nearby_hunk()
  execute "normal! 2Gox\<CR>y\<CR>z"
  normal 2jdd
  normal k
  call s:trigger_gitgutter()
  GitGutterUndoHunk
  call s:trigger_gitgutter()

  let expected = [
        \ {'lnum': 3, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 4, 'name': 'GitGutterLineAdded'},
        \ {'lnum': 5, 'name': 'GitGutterLineAdded'}
        \ ]
  call s:assert_signs(expected, 'fixture.txt')

  call assert_equal([], s:git_diff())

  call assert_equal([], s:git_diff_staged())

  " Save the buffer
  write

  let expected = [
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..3fbde56 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -2,0 +3,3 @@ b',
        \ '+x',
        \ '+y',
        \ '+z',
        \ ]
  call assert_equal(expected, s:git_diff())

endfunction


function Test_overlapping_hunk_op()
  func! Answer(char)
    call feedkeys(a:char."\<CR>")
  endfunc

  " Undo upper

  execute '3d'
  execute '1d'
  call s:trigger_gitgutter()
  normal gg
  call timer_start(100, {-> Answer('u')} )
  GitGutterUndoHunk
  call s:trigger_gitgutter()

  let expected = [{'lnum': 2, 'name': 'GitGutterLineRemoved'}]
  call s:assert_signs(expected, 'fixture.txt')

  " Undo lower

  execute '1d'
  call s:trigger_gitgutter()
  normal gg
  call timer_start(100, {-> Answer('l')} )
  GitGutterUndoHunk
  call s:trigger_gitgutter()

  let expected = [{'lnum': 1, 'name': 'GitGutterLineRemovedFirstLine'}]
  call s:assert_signs(expected, 'fixture.txt')
endfunction


function Test_write_option()
  set nowrite

  normal ggo*
  call s:trigger_gitgutter()

  let expected = [{'lnum': 2, 'name': 'GitGutterLineAdded'}]
  call s:assert_signs(expected, 'fixture.txt')

  set write
endfunction


function Test_inner_text_object()
  execute "normal! 2Gox\<CR>y\<CR>z\<CR>\<CR>"
  call s:trigger_gitgutter()
  normal dic
  call s:trigger_gitgutter()

  call s:assert_signs([], 'fixture.txt')
  call assert_equal(readfile('fixture.txt'), getline(1,'$'))

  " Excludes trailing lines
  normal 9Gi*
  normal 10Gi*
  call s:trigger_gitgutter()
  execute "normal vic\<Esc>"
  call assert_equal([9, 10], [line("'<"), line("'>")])
endfunction


function Test_around_text_object()
  execute "normal! 2Gox\<CR>y\<CR>z\<CR>\<CR>"
  call s:trigger_gitgutter()
  normal dac
  call s:trigger_gitgutter()

  call s:assert_signs([], 'fixture.txt')
  call assert_equal(readfile('fixture.txt'), getline(1,'$'))

  " Includes trailing lines
  normal 9Gi*
  normal 10Gi*
  call s:trigger_gitgutter()
  execute "normal vac\<Esc>"
  call assert_equal([9, 11], [line("'<"), line("'>")])
endfunction


function Test_user_autocmd()
  autocmd User GitGutter let s:autocmd_user = g:gitgutter_hook_context.bufnr

  " Verify not fired when nothing changed.
  let s:autocmd_user = 0
  call s:trigger_gitgutter()
  call assert_equal(0, s:autocmd_user)

  " Verify fired when there was a change.
  normal ggo*
  let bufnr = bufnr('')
  call s:trigger_gitgutter()
  call assert_equal(bufnr, s:autocmd_user)
endfunction


function Test_fix_file_references()
  let sid = matchstr(execute('filter autoload/gitgutter/hunk.vim scriptnames'), '\d\+')
  let FixFileReferences = function("<SNR>".sid."_fix_file_references")

  " No special characters
  let hunk_diff = join([
        \ 'diff --git a/fixture.txt b/fixture.txt',
        \ 'index f5c6aff..3fbde56 100644',
        \ '--- a/fixture.txt',
        \ '+++ b/fixture.txt',
        \ '@@ -2,0 +3,1 @@ b',
        \ '+x'
        \ ], "\n")."\n"
  let filepath = 'blah.txt'

  let expected = join([
        \ 'diff --git a/blah.txt b/blah.txt',
        \ 'index f5c6aff..3fbde56 100644',
        \ '--- a/blah.txt',
        \ '+++ b/blah.txt',
        \ '@@ -2,0 +3,1 @@ b',
        \ '+x'
        \ ], "\n")."\n"

  call assert_equal(expected, FixFileReferences(filepath, hunk_diff))

  " diff.mnemonicPrefix; spaces in filename
  let hunk_diff = join([
        \ 'diff --git i/x/cat dog w/x/cat dog',
        \ 'index f5c6aff..3fbde56 100644',
        \ '--- i/x/cat dog',
        \ '+++ w/x/cat dog',
        \ '@@ -2,0 +3,1 @@ b',
        \ '+x'
        \ ], "\n")."\n"
  let filepath = 'blah.txt'

  let expected = join([
        \ 'diff --git i/blah.txt w/blah.txt',
        \ 'index f5c6aff..3fbde56 100644',
        \ '--- i/blah.txt',
        \ '+++ w/blah.txt',
        \ '@@ -2,0 +3,1 @@ b',
        \ '+x'
        \ ], "\n")."\n"

  call assert_equal(expected, FixFileReferences(filepath, hunk_diff))

  " Backslashes in filename; quotation marks
  let hunk_diff = join([
        \ 'diff --git "a/C:\\Users\\FOO~1.PAR\\AppData\\Local\\Temp\\nvimJcmSv9\\11.1.vim" "b/C:\\Users\\FOO~1.PAR\\AppData\\Local\\Temp\\nvimJcmSv9\\12.1.vim"',
        \ 'index f42aeb0..4930403 100644',
        \ '--- "a/C:\\Users\\FOO~1.PAR\\AppData\\Local\\Temp\\nvimJcmSv9\\11.1.vim"',
        \ '+++ "b/C:\\Users\\FOO~1.PAR\\AppData\\Local\\Temp\\nvimJcmSv9\\12.1.vim"',
        \ '@@ -172,0 +173 @@ stuff',
        \ '+x'
        \ ], "\n")."\n"
  let filepath = 'init.vim'

  let expected = join([
        \ 'diff --git "a/init.vim" "b/init.vim"',
        \ 'index f42aeb0..4930403 100644',
        \ '--- "a/init.vim"',
        \ '+++ "b/init.vim"',
        \ '@@ -172,0 +173 @@ stuff',
        \ '+x'
        \ ], "\n")."\n"

  call assert_equal(expected, FixFileReferences(filepath, hunk_diff))
endfunction


function Test_encoding()
  call system('cp ../cp932.txt . && git add cp932.txt')
  edit ++enc=cp932 cp932.txt

  call s:trigger_gitgutter()

  call s:assert_signs([], 'cp932.txt')
endfunction


function Test_empty_file()
  " 0-byte file
  call system('touch empty.txt && git add empty.txt')
  edit empty.txt

  call s:trigger_gitgutter()
  call s:assert_signs([], 'empty.txt')


  " File consisting only of a newline
  call system('echo "" > newline.txt && git add newline.txt')
  edit newline.txt

  call s:trigger_gitgutter()
  call s:assert_signs([], 'newline.txt')


  " 1 line file without newline
  " Vim will force a newline unless we tell it not to.
  call system('echo -n a > oneline.txt && git add oneline.txt')
  set noeol nofixeol
  edit! oneline.txt

  call s:trigger_gitgutter()
  call s:assert_signs([], 'oneline.txt')

  set eol fixeol
endfunction


function Test_quickfix()
  call setline(5, ['A', 'B'])
  call setline(9, ['C', 'D'])
  write
  let bufnr1 = bufnr('')

  edit fixture_dos.txt
  call setline(2, ['A', 'B'])
  write
  let bufnr2 = bufnr('')

  GitGutterQuickFix

  let expected = [
        \ {'lnum': 5, 'bufnr': bufnr1, 'text': '-e'},
        \ {'lnum': 9, 'bufnr': bufnr1, 'text': '-i'},
        \ {'lnum': 2, 'bufnr': bufnr2, 'text': "-b\r"}
        \ ]

  call s:assert_list_of_dicts(expected, getqflist())

  GitGutterQuickFixCurrentFile

  let expected = [
        \ {'lnum': 2, 'bufnr': bufnr(''), 'text': "-b\r"},
        \ ]

  call s:assert_list_of_dicts(expected, getqflist())
endfunction


function Test_common_prefix()
  let sid = matchstr(execute('filter autoload/gitgutter/diff_highlight.vim scriptnames'), '\d\+')
  let CommonPrefix = function("<SNR>".sid."_common_prefix")

  " zero length
  call assert_equal(-1, CommonPrefix('', 'foo'))
  call assert_equal(-1, CommonPrefix('foo', ''))
  " nothing in common
  call assert_equal(-1, CommonPrefix('-abcde', '+pqrst'))
  call assert_equal(-1, CommonPrefix('abcde', 'pqrst'))
  " something in common
  call assert_equal(-1, CommonPrefix('-abcde', '+abcpq'))
  call assert_equal(2, CommonPrefix('abcde', 'abcpq'))
  call assert_equal(0, CommonPrefix('abc', 'apq'))
  " everything in common
  call assert_equal(-1, CommonPrefix('-abcde', '+abcde'))
  call assert_equal(4, CommonPrefix('abcde', 'abcde'))
  " different lengths
  call assert_equal(-1, CommonPrefix('-abcde', '+abx'))
  call assert_equal(1, CommonPrefix('abcde', 'abx'))
  call assert_equal(-1, CommonPrefix('-abx',   '+abcde'))
  call assert_equal(1, CommonPrefix('abx',   'abcde'))
  call assert_equal(-1, CommonPrefix('-abcde', '+abc'))
  call assert_equal(2, CommonPrefix('abcde', 'abc'))
endfunction


function Test_common_suffix()
  let sid = matchstr(execute('filter autoload/gitgutter/diff_highlight.vim scriptnames'), '\d\+')
  let CommonSuffix = function("<SNR>".sid."_common_suffix")

  " nothing in common
  call assert_equal([6,6], CommonSuffix('-abcde', '+pqrst', 0))
  " something in common
  call assert_equal([3,3], CommonSuffix('-abcde', '+pqcde', 0))
  " everything in common
  call assert_equal([5,5], CommonSuffix('-abcde', '+abcde', 5))
  " different lengths
  call assert_equal([4,2], CommonSuffix('-abcde', '+xde', 0))
  call assert_equal([2,4], CommonSuffix('-xde',   '+abcde', 0))
endfunction


" Note the order of lists within the overall returned list does not matter.
function Test_diff_highlight()
  " Ignores mismatched number of added and removed lines.
  call assert_equal([], gitgutter#diff_highlight#process(['-foo']))
  call assert_equal([], gitgutter#diff_highlight#process(['+foo']))
  call assert_equal([], gitgutter#diff_highlight#process(['-foo','-bar','+baz']))

  " everything changed
  let hunk = ['-foo', '+cat']
  let expected = []
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " change in middle
  let hunk = ['-foo bar baz', '+foo zip baz']
  let expected = [[1, '-', 6, 8], [2, '+', 6, 8]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " change at start
  let hunk = ['-foo bar baz', '+zip bar baz']
  let expected = [[1, '-', 2, 4], [2, '+', 2, 4]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " change at end
  let hunk = ['-foo bar baz', '+foo bar zip']
  let expected = [[1, '-', 10, 12], [2, '+', 10, 12]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " removed in middle
  let hunk = ['-foo bar baz', '+foo baz']
  let expected = [[1, '-', 8, 11]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " added in middle
  let hunk = ['-foo baz', '+foo bar baz']
  let expected = [[2, '+', 8, 11]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " two insertions at start
  let hunk = ['-foo bar baz', '+(foo) bar baz']
  let expected = [[2, '+', 2, 2], [2, '+', 6, 6]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " two insertions in middle
  let hunk = ['-foo bar baz', '+foo (bar) baz']
  let expected = [[2, '+', 6, 6], [2, '+', 10, 10]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " two insertions at end
  let hunk = ['-foo bar baz', '+foo bar (baz)']
  let expected = [[2, '+', 10, 10], [2, '+', 14, 14]]
  call assert_equal(expected, gitgutter#diff_highlight#process(hunk))

  " singular insertion
  let hunk = ['-The cat in the hat.', '+The furry cat in the hat.']
  call assert_equal([[2, '+', 6, 11]], gitgutter#diff_highlight#process(hunk))

  " singular deletion
  let hunk = ['-The cat in the hat.', '+The cat.']
  call assert_equal([[1, '-', 9, 19]], gitgutter#diff_highlight#process(hunk))

  " two insertions
  let hunk = ['-The cat in the hat.', '+The furry cat in the teal hat.']
  call assert_equal([[2, '+', 6, 11], [2, '+', 22, 26]], gitgutter#diff_highlight#process(hunk))

  " two deletions
  let hunk = ['-The furry cat in the teal hat.', '+The cat in the hat.']
  call assert_equal([[1, '-', 6, 11], [1, '-', 22, 26]], gitgutter#diff_highlight#process(hunk))

  " two edits
  let hunk = ['-The cat in the hat.', '+The ox in the box.']
  call assert_equal([[1, '-', 6, 8], [2, '+', 6, 7], [1, '-', 17, 19], [2, '+', 16, 18]], gitgutter#diff_highlight#process(hunk))

  " Requires s:gap_between_regions = 2 to pass.
  " let hunk = ['-foo: bar.zap', '+foo: quux(bar)']
  " call assert_equal([[2, '+', 7, 11], [1, '-', 10, 13], [2, '+', 15, 15]], gitgutter#diff_highlight#process(hunk))

  let hunk = ['-gross_value: transaction.unexplained_amount', '+gross_value: amount(transaction)']
  call assert_equal([[2, '+', 15, 21], [1, '-', 26, 44], [2, '+', 33, 33]], gitgutter#diff_highlight#process(hunk))

  let hunk = ['-gem "contact_sport", "~> 1.0.2"', '+gem ("contact_sport"), "~> 1.2"']
  call assert_equal([[2, '+', 6, 6], [2, '+', 22, 22], [1, '-', 28, 29]], gitgutter#diff_highlight#process(hunk))
endfunction


function Test_lcs()
  let sid = matchstr(execute('filter autoload/gitgutter/diff_highlight.vim scriptnames'), '\d\+')
  let Lcs = function("<SNR>".sid."_lcs")

  call assert_equal('', Lcs('', 'foo'))
  call assert_equal('', Lcs('foo', ''))
  call assert_equal('bar', Lcs('foobarbaz', 'bbart'))
  call assert_equal('transaction', Lcs('transaction.unexplained_amount', 'amount(transaction)'))
endfunction


function Test_split()
  let sid = matchstr(execute('filter autoload/gitgutter/diff_highlight.vim scriptnames'), '\d\+')
  let Split = function("<SNR>".sid."_split")

  call assert_equal(['foo', 'baz'], Split('foobarbaz', 'bar'))
  call assert_equal(['', 'barbaz'], Split('foobarbaz', 'foo'))
  call assert_equal(['foobar', ''], Split('foobarbaz', 'baz'))
  call assert_equal(['1', '2'], Split('1~2', '~'))
endfunction


function Test_foldtext()
  8d
  call s:trigger_gitgutter()
  call assert_equal(0, gitgutter#fold#is_changed())

  let v:foldstart = 5
  let v:foldend = 9
  call assert_equal(1, gitgutter#fold#is_changed())
  call assert_equal('+-  5 lines (*): e', gitgutter#fold#foldtext())

  let v:foldstart = 1
  let v:foldend = 3
  call assert_equal(0, gitgutter#fold#is_changed())
  call assert_equal('+-  3 lines: a', gitgutter#fold#foldtext())
endfunction


function Test_assume_unchanged()
  call system("git update-index --assume-unchanged fixture.txt")
  unlet b:gitgutter.path  " it was already set when fixture.txt was loaded in SetUp()
  normal ggo*
  call s:trigger_gitgutter()
  call s:assert_signs([], 'fixture.txt')
endfunction


function Test_clean_smudge_filter()
  call system("git config --local include.path ../.gitconfig")
  call system("rm fixture.foo && git checkout fixture.foo")

  func! Answer(char)
    call feedkeys(a:char."\<CR>")
  endfunc

  edit fixture.foo
  call setline(2, ['A'])
  call setline(4, ['B'])
  call s:trigger_gitgutter()
  normal! 2G
  call timer_start(100, {-> Answer('y')} )
  GitGutterStageHunk
  call s:trigger_gitgutter()

  let expected = [
        \ {'lnum': 2, 'id': 23, 'name': 'GitGutterLineModified', 'priority': 10, 'group': 'gitgutter'},
        \ {'lnum': 4, 'id': 24, 'name': 'GitGutterLineModified', 'priority': 10, 'group': 'gitgutter'}
        \ ]
  " call s:assert_signs(expected, 'fixture.foo')
  call s:assert_signs([], 'fixture.foo')
endfunction