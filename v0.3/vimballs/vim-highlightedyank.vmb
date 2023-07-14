" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.gitignore	[[[1
2
doc/tags
doc/tags-ja
./README.md	[[[1
67
# vim-highlightedyank
Make the yanked region apparent!

## Usage

### If you are using Vim 8.0.1394 (or later version),

there is no need for configuration, as the highlight event is automatically triggered by the `TextYankPost` event.

### If you are using older Vim,

define a keymapping to `<Plug>(highlightedyank)`. Checking the existence of `TextYankPost` event would be good.

```vim
if !exists('##TextYankPost')
  nmap y <Plug>(highlightedyank)
  xmap y <Plug>(highlightedyank)
  omap y <Plug>(highlightedyank)
endif
```

### If you are using Neovim,

you don't need this plugin. Check out [here](https://neovim.io/doc/user/lua.html#lua-highlight).


## Optimizing highlight duration

If you want to optimize highlight duration, use `g:highlightedyank_highlight_duration` or `b:highlightedyank_highlight_duration`. Assign a number of time in milliseconds.

```vim
let g:highlightedyank_highlight_duration = 1000
```

A negative number makes the highlight persistent.

```vim
let g:highlightedyank_highlight_duration = -1
```

When a new text is yanked or user starts editing, the old highlighting would be deleted.

## Highlight coloring

If the highlight is not visible for some reason, you can redefine the `HighlightedyankRegion` highlight group like:

```vim
highlight HighlightedyankRegion cterm=reverse gui=reverse
```

Note that the line should be located after `:colorscheme` command execution in your vimrc.

## Suppress highlight in visual mode

The highlight may not be needed or even annoying in visual mode.

```vim
let g:highlightedyank_highlight_in_visual = 0
```

## Inspired by

 - [atom-vim-mode-plus](https://github.com/t9md/atom-vim-mode-plus)
 - [vim-operator-flashy](https://github.com/haya14busa/vim-operator-flashy)

## Demo
![vim-highlightedyank](http://i.imgur.com/HulyZ6n.gif)
./autoload/highlightedyank/highlight.vim	[[[1
331
let s:Schedule = vital#highlightedyank#new().import('Schedule')
                  \.augroup('highlightedyank-highlight')
let s:NULLPOS = [0, 0, 0, 0]
let s:MAXCOL = 2147483647
let s:ON = 1
let s:OFF = 0


" Return a new highlight object
" Return a empty dictionary if the assigned region is empty
function! highlightedyank#highlight#new(hi_group, start, end, type) abort  "{{{
  let order_list = []
  if a:type is# 'char' || a:type is# 'v'
    let order_list += s:get_order_charwise(a:start, a:end)
  elseif a:type is# 'line' || a:type is# 'V'
    let order_list += s:get_order_linewise(a:start, a:end)
  elseif a:type is# 'block' || a:type[0] is# "\<C-v>"
    let blockwidth = s:get_blockwidth(a:start, a:end, a:type)
    let order_list += s:get_order_blockwise(a:start, a:end, blockwidth)
  endif
  if empty(order_list)
    return {}
  endif

  let highlight = deepcopy(s:highlight)
  let highlight.group = a:hi_group
  let highlight.order_list = order_list
  let highlight.quenchtask = s:Schedule.Task()
  let highlight.switchtask = s:Schedule.Task()
  return highlight
endfunction "}}}


" Add a highlight on the current buffer
function! highlightedyank#highlight#add(hi_group, start, end, type, duration) abort "{{{
  let new_highlight = highlightedyank#highlight#new(a:hi_group, a:start,
                                                  \ a:end, a:type)
  if empty(new_highlight)
    return
  endif

  call s:current_highlight.delete()
  call new_highlight.add(a:duration)
  if new_highlight.status is s:OFF
    return
  endif
  let s:current_highlight = new_highlight
endfunction "}}}


" Delete the current highlight
function! highlightedyank#highlight#delete() abort "{{{
  call s:current_highlight.delete()
endfunction "}}}


function! s:get_order_charwise(start, end) abort  "{{{
  if a:start == s:NULLPOS || a:end == s:NULLPOS || s:is_ahead(a:start, a:end)
    return []
  endif
  if a:start[1] == a:end[1]
    let order = [a:start[1:2] + [a:end[2] - a:start[2] + 1]]
    return [order]
  endif

  let order = []
  let order_list = []
  let n = 0
  for lnum in range(a:start[1], a:end[1])
    if lnum == a:start[1]
      let order += [a:start[1:2] + [col([a:start[1], '$']) - a:start[2] + 1]]
    elseif lnum == a:end[1]
      let order += [[a:end[1], 1] + [a:end[2]]]
    else
      let order += [[lnum]]
    endif

    if n == 7
      let order_list += [order]
      let order = []
      let n = 0
    else
      let n += 1
    endif
  endfor
  if order != []
    let order_list += [order]
  endif
  return order_list
endfunction "}}}


function! s:get_order_linewise(start, end) abort  "{{{
  if a:start == s:NULLPOS || a:end == s:NULLPOS || a:start[1] > a:end[1]
    return []
  endif

  let order = []
  let order_list = []
  let n = 0
  for lnum in range(a:start[1], a:end[1])
    let order += [lnum]
    if n == 7
      let order_list += [order]
      let order = []
      let n = 0
    else
      let n += 1
    endif
  endfor
  if order != []
    let order_list += [order]
  endif
  return order_list
endfunction "}}}


function! s:get_order_blockwise(start, end, blockwidth) abort "{{{
  if a:start == s:NULLPOS || a:end == s:NULLPOS || s:is_ahead(a:start, a:end)
    return []
  endif

  let view = winsaveview()
  let vcol_head = virtcol(a:start[1:2])
  if a:blockwidth == s:MAXCOL
    let vcol_tail = a:blockwidth
  else
    let vcol_tail = vcol_head + a:blockwidth - 1
  endif
  let order = []
  let order_list = []
  let n = 0
  for lnum in range(a:start[1], a:end[1])
    call cursor(lnum, 1)
    execute printf('normal! %s|', vcol_head)
    let head = getpos('.')
    execute printf('normal! %s|', vcol_tail)
    let tail = getpos('.')
    let col = head[2]
    let len = tail[2] - head[2] + 1
    let order += [[lnum, col, len]]

    if n == 7
      let order_list += [order]
      let order = []
      let n = 0
    else
      let n += 1
    endif
  endfor
  if order != []
    let order_list += [order]
  endif
  call winrestview(view)
  return order_list
endfunction "}}}


function! s:get_blockwidth(start, end, type) abort "{{{
  if a:type[0] is# "\<C-v>" && a:type[1:] =~# '\d\+'
    return str2nr(a:type[1:])
  endif
  return virtcol(a:end[1:2]) - virtcol(a:start[1:2]) + 1
endfunction "}}}


function! s:is_ahead(pos1, pos2) abort  "{{{
  return a:pos1[1] > a:pos2[1] || (a:pos1[1] == a:pos2[1] && a:pos1[2] > a:pos2[2])
endfunction "}}}


" Highlight object {{{
let s:highlight = {
  \   'status': s:OFF,
  \   'group': '',
  \   'id': [],
  \   'order_list': [],
  \   'bufnr': 0,
  \   'winid': 0,
  \   'quenchtask': {},
  \   'switchtask': {},
  \ }


" Start to show the highlight
function! s:highlight.add(...) dict abort "{{{
  let duration = get(a:000, 0, -1)
  if duration == 0
    return
  end
  if empty(self.order_list)
    return
  endif

  call self.delete()
  for order in self.order_list
    let self.id += [matchaddpos(self.group, order)]
  endfor
  call filter(self.id, 'v:val > 0')
  let self.status = s:ON
  let self.bufnr = bufnr('%')
  let self.winid = win_getid()
  call self.switchtask.call(self.switch, [], self)
                     \.repeat(1)
                     \.waitfor(['BufEnter'])
  let triggers = [['BufUnload', '<buffer>'], ['CmdwinLeave', '<buffer>'],
               \  ['TextChanged', '*'], ['InsertEnter', '*'],
               \  ['TabLeave', '*']]
  if duration > 0
    call add(triggers, duration)
  endif
  call self.quenchtask.call(self.delete, [], self)
                     \.repeat(1)
                     \.waitfor(triggers)

  if !has('patch-8.0.1476') && has('patch-8.0.1449')
    redraw
  endif
endfunction "}}}


" Delete the highlight
function! s:highlight.delete() dict abort "{{{
  if self.status is s:OFF
    return 0
  endif
  if s:is_in_cmdline_window() && !self.is_in_highlight_window()
    " NOTE: cannot move out from commandline-window
    call self._quench_by_CmdWinLeave()
    return 0
  endif

  call self._quench_now()
  let self.status = s:OFF
  let self.bufnr = 0
  let self.winid = 0
  call self.switchtask.cancel()
  call self.quenchtask.cancel()
  if !has('patch-8.0.1476') && has('patch-8.0.1449')
    redraw
  endif
  return 1
endfunction "}}}


function! s:highlight.is_in_highlight_window() abort "{{{
  return win_getid() == self.winid
endfunction "}}}


function! s:highlight._quench_now() abort "{{{
  if self.is_in_highlight_window()
    " current window
    call s:matchdelete_all(self.id)
  else
    " move to another window
    let original_winid = win_getid()
    let view = winsaveview()

    noautocmd let reached = win_gotoid(self.winid)
    if reached
      " reached to the highlighted buffer
      call s:matchdelete_all(self.id)
    else
      " highlighted buffer does not exist
      call filter(self.id, 0)
    endif
    noautocmd call win_gotoid(original_winid)
    call winrestview(view)
  endif
endfunction "}}}


function! s:highlight._quench_by_CmdWinLeave() abort "{{{
  let quenchtask = s:Schedule.TaskChain()
  call quenchtask.hook(['CmdWinLeave'])
  call quenchtask.hook([1]).call(self.delete, [], self)
  call quenchtask.waitfor()
endfunction "}}}


function! s:is_in_cmdline_window() abort "{{{
  return getcmdwintype() isnot# ''
endfunction "}}}


" Quench if buffer is switched in the same window
function! s:highlight.switch() abort "{{{
  if win_getid() != self.winid
    return
  endif
  if bufnr('%') == self.bufnr
    return
  endif
  call self.delete()
endfunction "}}}


function! s:matchdelete_all(ids) abort "{{{
  if empty(a:ids)
    return
  endif

  let alive_ids = map(getmatches(), 'v:val.id')
  " Return if another plugin called clearmatches() which clears *ALL*
  " highlights including others set.
  if empty(alive_ids)
    return
  endif
  if !count(alive_ids, a:ids[0])
    return
  endif

  for id in a:ids
    try
      call matchdelete(id)
    catch
    endtry
  endfor
  call filter(a:ids, 0)
endfunction "}}}
"}}}


let s:current_highlight = highlightedyank#highlight#new('None', [0, 1, 1, 0],
                                                      \ [0, 1, 1, 0], 'V')


" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
./autoload/highlightedyank/obsolete/clock.vim	[[[1
61
" clock object - measuring elapsed time in a operation
let s:HAS_RELTIME_AND_FLOAT = has('reltime') && has('float')



function! highlightedyank#obsolete#clock#new() abort  "{{{
  return deepcopy(s:clock)
endfunction "}}}


" s:clock {{{
let s:clock = {
      \   'started' : 0,
      \   'paused'  : 0,
      \   'zerotime': reltime(),
      \   'stoptime': reltime(),
      \   'losstime': 0,
      \ }


function! s:clock.start() dict abort  "{{{
  if self.started
    if self.paused
      let self.losstime += str2float(reltimestr(reltime(self.stoptime)))
      let self.paused = 0
    endif
  else
    if s:HAS_RELTIME_AND_FLOAT
      let self.zerotime = reltime()
      let self.started  = 1
    endif
  endif
endfunction "}}}


function! s:clock.pause() dict abort "{{{
  let self.stoptime = reltime()
  let self.paused   = 1
endfunction "}}}


function! s:clock.elapsed() dict abort "{{{
  if self.started
    let total = str2float(reltimestr(reltime(self.zerotime)))
    return floor((total - self.losstime)*1000)
  else
    return 0
  endif
endfunction "}}}


function! s:clock.stop() dict abort  "{{{
  let self.started  = 0
  let self.paused   = 0
  let self.losstime = 0
endfunction "}}}
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
./autoload/highlightedyank/obsolete/highlight.vim	[[[1
471
" highlight object - managing highlight on a buffer
let s:HAS_GUI_RUNNING = has('gui_running')
let s:TYPE_LIST = type([])
let s:NULLPOS = [0, 0, 0, 0]
let s:MAXCOL = 2147483647
let s:ON = 1
let s:OFF = 0

" SID
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction
let s:SID = printf("\<SNR>%s_", s:SID())
delfunction s:SID



function! highlightedyank#obsolete#highlight#new(region) abort  "{{{
  let highlight = deepcopy(s:highlight)
  if a:region.wise ==# 'char' || a:region.wise ==# 'v'
    let highlight.order_list = s:highlight_order_charwise(a:region)
  elseif a:region.wise ==# 'line' || a:region.wise ==# 'V'
    let highlight.order_list = s:highlight_order_linewise(a:region)
  elseif a:region.wise ==# 'block' || a:region.wise[0] ==# "\<C-v>"
    let highlight.order_list = s:highlight_order_blockwise(a:region)
  endif
  return highlight
endfunction "}}}


" Highlight class "{{{
let s:highlight = {
  \   'status': s:OFF,
  \   'group': '',
  \   'id': [],
  \   'order_list': [],
  \   'bufnr': 0,
  \   'winid': 0,
  \ }


function! s:highlight.show(...) dict abort "{{{
  if empty(self.order_list)
    return 0
  endif

  if a:0 < 1
    if empty(self.group)
      return 0
    else
      let hi_group = self.group
    endif
  else
    let hi_group = a:1
  endif

  if self.status is s:ON
    if hi_group ==# self.group
      return 0
    else
      call self.quench()
    endif
  endif

  for order in self.order_list
    let self.id += s:matchaddpos(hi_group, order)
  endfor
  call filter(self.id, 'v:val > 0')
  let self.status = s:ON
  let self.group = hi_group
  let self.bufnr = bufnr('%')
  let self.winid = s:win_getid()
  return 1
endfunction "}}}


function! s:highlight.quench() dict abort "{{{
  if self.status is s:OFF
    return 0
  endif

  let winid = s:win_getid()
  let view = winsaveview()
  if s:win_getid() == self.winid
    call map(self.id, 'matchdelete(v:val)')
    call filter(self.id, 'v:val > 0')
    let succeeded = 1
  else
    if s:is_in_cmdline_window()
      let s:paused += [self]
      augroup highlightedyank-pause-quenching
        autocmd!
        autocmd CmdWinLeave * call s:got_out_of_cmdwindow()
      augroup END
      let succeeded = 0
    else
      let reached = s:win_gotoid(self.winid)
      if reached
        call map(self.id, 'matchdelete(v:val)')
        call filter(self.id, 'v:val > 0')
      else
        call filter(self.id, 0)
      endif
      let succeeded = 1
      call s:win_gotoid(winid)
      call winrestview(view)
    endif
  endif

  if succeeded
    let self.status = s:OFF
  endif
  return succeeded
endfunction "}}}


function! s:highlight.quench_timer(time) dict abort "{{{
  let id = timer_start(a:time, s:SID . 'quench')
  let s:quench_table[id] = self
  call s:set_autocmds(id)
  return id
endfunction "}}}


function! s:highlight.persist() dict abort  "{{{
  let id = s:get_pid()
  call s:set_autocmds(id)
  let s:quench_table[id] = self
  return id
endfunction "}}}


function! s:highlight.empty() abort "{{{
  return empty(self.order_list)
endfunction "}}}


" for scheduled-quench "{{{
let s:quench_table = {}
function! s:quench(id) abort  "{{{
  let options = s:shift_options()
  let highlight = s:get(a:id)
  if highlight != {}
    call highlight.quench()
  endif
  unlet s:quench_table[a:id]
  call timer_stop(a:id)
  call s:restore_options(options)
  call s:clear_autocmds()
  redraw
endfunction "}}}


function! highlightedyank#obsolete#highlight#cancel(...) abort "{{{
  if a:0 > 0
    let id_list = type(a:1) == s:TYPE_LIST ? a:1 : a:000
  else
    let id_list = map(keys(s:quench_table), 'str2nr(v:val)')
  endif

  for id in id_list
    call s:quench(id)
  endfor
endfunction "}}}


function! s:get(id) abort "{{{
  return get(s:quench_table, a:id, {})
endfunction "}}}


let s:paused = []
function! s:quench_paused(...) abort "{{{
  if s:is_in_cmdline_window()
    return
  endif

  for highlight in s:paused
    call highlight.quench()
  endfor
  let s:paused = []
  augroup highlightedyank-pause-quenching
    autocmd!
  augroup END
endfunction "}}}


function! s:got_out_of_cmdwindow() abort "{{{
  augroup highlightedyank-pause-quenching
    autocmd!
    autocmd CursorMoved * call s:quench_paused()
  augroup END
endfunction "}}}


" ID for persistent highlights
let s:pid = 0
function! s:get_pid() abort "{{{
  if s:pid != -1/0
    let s:pid -= 1
  else
    let s:pid = -1
  endif
  return s:pid
endfunction "}}}


function! s:set_autocmds(id) abort "{{{
  augroup highlightedyank-highlight
    autocmd!
    execute printf('autocmd TextChanged <buffer> call s:cancel_highlight(%s, "TextChanged")', a:id)
    execute printf('autocmd InsertEnter <buffer> call s:cancel_highlight(%s, "InsertEnter")', a:id)
    execute printf('autocmd BufUnload <buffer> call s:cancel_highlight(%s, "BufUnload")', a:id)
    execute printf('autocmd BufEnter * call s:switch_highlight(%s)', a:id)
  augroup END
endfunction "}}}


function! s:clear_autocmds() abort "{{{
  augroup highlightedyank-highlight
    autocmd!
  augroup END
endfunction "}}}


function! s:cancel_highlight(id, event) abort  "{{{
  let highlight = s:get(a:id)
  if highlight != {}
    call s:quench(a:id)
  endif
endfunction "}}}


function! s:switch_highlight(id) abort "{{{
  let highlight = s:get(a:id)
  if highlight != {} && highlight.winid == s:win_getid()
    if highlight.bufnr == bufnr('%')
      call highlight.show()
    else
      call highlight.quench()
    endif
  endif
endfunction "}}}
"}}}
"}}}



" private functions
function! s:highlight_order_charwise(region) abort  "{{{
  if a:region.head == s:NULLPOS || a:region.tail == s:NULLPOS || s:is_ahead(a:region.head, a:region.tail)
    return []
  endif
  if a:region.head[1] == a:region.tail[1]
    let order = [a:region.head[1:2] + [a:region.tail[2] - a:region.head[2] + 1]]
    return [order]
  endif

  let order = []
  let order_list = []
  let n = 0
  for lnum in range(a:region.head[1], a:region.tail[1])
    if lnum == a:region.head[1]
      let order += [a:region.head[1:2] + [col([a:region.head[1], '$']) - a:region.head[2] + 1]]
    elseif lnum == a:region.tail[1]
      let order += [[a:region.tail[1], 1] + [a:region.tail[2]]]
    else
      let order += [[lnum]]
    endif

    if n == 7
      let order_list += [order]
      let order = []
      let n = 0
    else
      let n += 1
    endif
  endfor
  if order != []
    let order_list += [order]
  endif
  return order_list
endfunction "}}}


function! s:highlight_order_linewise(region) abort  "{{{
  if a:region.head == s:NULLPOS || a:region.tail == s:NULLPOS || a:region.head[1] > a:region.tail[1]
    return []
  endif

  let order = []
  let order_list = []
  let n = 0
  for lnum in range(a:region.head[1], a:region.tail[1])
    let order += [[lnum]]
    if n == 7
      let order_list += [order]
      let order = []
      let n = 0
    else
      let n += 1
    endif
  endfor
  if order != []
    let order_list += [order]
  endif
  return order_list
endfunction "}}}


function! s:highlight_order_blockwise(region) abort "{{{
  if a:region.head == s:NULLPOS || a:region.tail == s:NULLPOS || s:is_ahead(a:region.head, a:region.tail)
    return []
  endif

  let view = winsaveview()
  let vcol_head = virtcol(a:region.head[1:2])
  if a:region.blockwidth == s:MAXCOL
    let vcol_tail = a:region.blockwidth
  else
    let vcol_tail = vcol_head + a:region.blockwidth - 1
  endif
  let order = []
  let order_list = []
  let n = 0
  for lnum in range(a:region.head[1], a:region.tail[1])
    call cursor(lnum, 1)
    execute printf('normal! %s|', vcol_head)
    let head = getpos('.')
    execute printf('normal! %s|', vcol_tail)
    let tail = getpos('.')
    let col = head[2]
    let len = tail[2] - head[2] + 1
    let order += [[lnum, col, len]]

    if n == 7
      let order_list += [order]
      let order = []
      let n = 0
    else
      let n += 1
    endif
  endfor
  if order != []
    let order_list += [order]
  endif
  call winrestview(view)
  return order_list
endfunction "}}}


" function! s:matchaddpos(group, pos) abort "{{{
if exists('*matchaddpos')
  function! s:matchaddpos(group, pos) abort
    return [matchaddpos(a:group, a:pos)]
  endfunction
else
  function! s:matchaddpos(group, pos) abort
    let id_list = []
    for pos in a:pos
      if len(pos) == 1
        let id_list += [matchadd(a:group, printf('\%%%dl', pos[0]))]
      else
        let id_list += [matchadd(a:group, printf('\%%%dl\%%>%dc.*\%%<%dc', pos[0], pos[1]-1, pos[1]+pos[2]))]
      endif
    endfor
    return id_list
  endfunction
endif
"}}}


function! s:is_ahead(pos1, pos2) abort  "{{{
  return a:pos1[1] > a:pos2[1] || (a:pos1[1] == a:pos2[1] && a:pos1[2] > a:pos2[2])
endfunction "}}}


" function! s:is_in_cmdline_window() abort  "{{{
if exists('*getcmdwintype')
  function! s:is_in_cmdline_window() abort
    return getcmdwintype() !=# ''
  endfunction
else
  function! s:is_in_cmdline_window() abort
    let is_in_cmdline_window = 0
    try
      execute 'tabnext ' . tabpagenr()
    catch /^Vim\%((\a\+)\)\=:E11/
      let is_in_cmdline_window = 1
    catch
    finally
      return is_in_cmdline_window
    endtry
  endfunction
endif
"}}}


function! s:shift_options() abort "{{{
  let options = {}

  """ tweak appearance
  " hide_cursor
  if s:HAS_GUI_RUNNING
    let options.cursor = &guicursor
    set guicursor+=a:block-NONE
  else
    let options.cursor = &t_ve
    set t_ve=
  endif

  return options
endfunction "}}}


function! s:restore_options(options) abort "{{{
  if s:HAS_GUI_RUNNING
    set guicursor&
    let &guicursor = a:options.cursor
  else
    let &t_ve = a:options.cursor
  endif
endfunction "}}}



" for compatibility
" function! s:win_getid(...) abort{{{
if exists('*win_getid')
  let s:win_getid = function('win_getid')
else
  function! s:win_getid(...) abort
    let winnr = get(a:000, 0, winnr())
    let tabnr = get(a:000, 1, tabpagenr())
  endfunction
endif
"}}}


" function! s:win_gotoid(id) abort{{{
if exists('*win_gotoid')
  function! s:win_gotoid(id) abort
    noautocmd let ret = win_gotoid(a:id)
    return ret
  endfunction
else
  function! s:win_gotoid(id) abort
    let [winnr, tabnr] = a:id

    if tabnr != tabpagenr()
      execute 'noautocmd tabnext ' . tabnr
      if tabpagenr() != tabnr
        return 0
      endif
    endif

    try
      if winnr != winnr()
        execute printf('noautocmd %swincmd w', winnr)
      endif
    catch /^Vim\%((\a\+)\)\=:E16/
      return 0
    endtry
    return 1
  endfunction
endif
"}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
./autoload/highlightedyank/obsolete/highlightedyank.vim	[[[1
418
let s:NULLPOS = [0, 0, 0, 0]
let s:NULLREGION = {
  \ 'wise': '', 'blockwidth': 0,
  \ 'head': copy(s:NULLPOS), 'tail': copy(s:NULLPOS),
  \ }
let s:MAXCOL = 2147483647
let s:HAS_GUI_RUNNING = has('gui_running')
let s:HAS_TIMERS = has('timers')
let s:TYPE_NUM = type(0)
let s:ON = 1
let s:OFF = 0

let s:STATE = s:ON

" SID
function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction
let s:SID = printf("\<SNR>%s_", s:SID())
delfunction s:SID

" intrinsic keymap
noremap <SID>(highlightedyank-y) y
noremap <SID>(highlightedyank-doublequote) "
noremap <SID>(highlightedyank-g@) g@
noremap <SID>(highlightedyank-gv) gv
let s:normal = {}
let s:normal['y']  = s:SID . '(highlightedyank-y)'
let s:normal['"']  = s:SID . '(highlightedyank-doublequote)'
let s:normal['g@'] = s:SID . '(highlightedyank-g@)'
let s:normal['gv'] = s:SID . '(highlightedyank-gv)'



function! highlightedyank#obsolete#highlightedyank#yank(mode) abort  "{{{
  let l:count = v:count ? v:count : ''
  let register = v:register ==# s:default_register() ? '' : s:normal['"'] . v:register
  if a:mode ==# 'n'
    call s:yank_normal(l:count, register)
  elseif a:mode ==# 'x'
    call s:yank_visual(register)
  endif
endfunction "}}}


function! highlightedyank#obsolete#highlightedyank#setoperatorfunc() abort "{{{
  set operatorfunc=highlightedyank#obsolete#highlightedyank#operatorfunc
  return ''
endfunction "}}}


function! highlightedyank#obsolete#highlightedyank#operatorfunc(motionwise, ...) abort "{{{
  let region = {'head': getpos("'["), 'tail': getpos("']"), 'wise': a:motionwise}
  if s:is_ahead(region.head, region.tail)
    return
  endif

  let register = v:register ==# s:default_register() ? '' : '"' . v:register
  execute printf('normal! `[%sy%s`]', register, s:motionwise2visualmode(a:motionwise))
  call s:highlight_yanked_region(region)
endfunction "}}}


function! highlightedyank#obsolete#highlightedyank#on() abort "{{{
  let s:STATE = s:ON
  if stridx(&cpoptions, 'y') < 0
    nnoremap <silent> <Plug>(highlightedyank) :<C-u>call highlightedyank#obsolete#highlightedyank#yank('n')<CR>
    xnoremap <silent> <Plug>(highlightedyank) :<C-u>call highlightedyank#obsolete#highlightedyank#yank('x')<CR>
    onoremap          <Plug>(highlightedyank) y
  else
    noremap  <expr>   <Plug>(highlightedyank-setoperatorfunc) highlightedyank#obsolete#highlightedyank#setoperatorfunc()
    nmap     <silent> <Plug>(highlightedyank) <Plug>(highlightedyank-setoperatorfunc)<Plug>(highlightedyank-g@)
    xmap     <silent> <Plug>(highlightedyank) <Plug>(highlightedyank-setoperatorfunc)<Plug>(highlightedyank-g@)
    onoremap          <Plug>(highlightedyank) g@
  endif
endfunction "}}}


function! highlightedyank#obsolete#highlightedyank#off() abort "{{{
  let s:STATE = s:OFF
  noremap <silent> <Plug>(highlightedyank) y
endfunction "}}}


function! highlightedyank#obsolete#highlightedyank#toggle() abort "{{{
  if s:STATE is s:ON
    call highlightedyank#obsolete#highlightedyank#off()
  else
    call highlightedyank#obsolete#highlightedyank#on()
  endif
endfunction "}}}


function! s:default_register() abort  "{{{
  if &clipboard =~# 'unnamedplus'
    let default_register = '+'
  elseif &clipboard =~# 'unnamed'
    let default_register = '*'
  else
    let default_register = '"'
  endif
  return default_register
endfunction "}}}


function! s:yank_normal(count, register) abort "{{{
  let view = winsaveview()
  let options = s:shift_options()
  try
    let [input, region] = s:query(a:count)
    if region != s:NULLREGION
      call s:highlight_yanked_region(region)
      call winrestview(view)
      let keyseq = printf('%s%s%s%s', a:register, a:count, s:normal['y'], input)
      execute 'normal' keyseq
    endif
  finally
    call s:restore_options(options)
  endtry
endfunction "}}}


function! s:yank_visual(register) abort "{{{
  let view = winsaveview()
  let region = deepcopy(s:NULLREGION)
  let region.head = getpos("'<")
  let region.tail = getpos("'>")
  if s:is_ahead(region.head, region.tail)
    return
  endif

  let region.wise = s:visualmode2motionwise(visualmode())
  if region.wise ==# 'block'
    let region.blockwidth = s:is_extended() ? s:MAXCOL : virtcol(region.tail[1:2]) - virtcol(region.head[1:2]) + 1
  endif
  let options = s:shift_options()
  try
    call s:highlight_yanked_region(region)
    call winrestview(view)
    let keyseq = printf('%s%s%s', s:normal['gv'], a:register, s:normal['y'])
    execute 'normal' keyseq
  finally
    call s:restore_options(options)
  endtry
endfunction "}}}


function! s:query(count) abort "{{{
  let view = winsaveview()
  let curpos = getpos('.')
  let input = ''
  let region = deepcopy(s:NULLREGION)
  let motionwise = ''
  let dummycursor = {}
  try
    while 1
      let c = getchar(0)
      if empty(c)
        if empty(dummycursor)
          let dummycursor = s:put_dummy_cursor(curpos)
        endif
        sleep 20m
        continue
      endif

      let c = type(c) == s:TYPE_NUM ? nr2char(c) : c
      if c ==# "\<Esc>"
        break
      endif

      let input .= c
      let region = s:get_region(curpos, a:count, input)
      if region != s:NULLREGION
        break
      endif
    endwhile
  finally
    call s:clear_dummy_cursor(dummycursor)
    call winrestview(view)
  endtry
  return [input, region]
endfunction "}}}


function! s:get_region(curpos, count, input) abort  "{{{
  let s:region = deepcopy(s:NULLREGION)
  let opfunc = &operatorfunc
  let &operatorfunc = s:SID . 'operator_get_region'
  onoremap <Plug>(highlightedyank) g@
  call setpos('.', a:curpos)
  try
    execute printf("normal %s%s%s", a:count, s:normal['g@'], a:input)
  catch
    let verbose = get(g:, 'highlightedyank#verbose', 0)
    echohl ErrorMsg
    if verbose >= 2
      echomsg printf('highlightedyank: Motion error. [%s] %s', a:input, v:exception)
    elseif verbose == 1
      echomsg 'highlightedyank: Motion error.'
    endif
    echohl NONE
  finally
    onoremap <Plug>(highlightedyank) y
    let &operatorfunc = opfunc
    if s:region == s:NULLREGION
      return deepcopy(s:NULLREGION)
    endif
    return s:modify_region(s:region)
  endtry
endfunction "}}}


function! s:modify_region(region) abort "{{{
  " for multibyte characters
  if a:region.tail[2] != col([a:region.tail[1], '$']) && a:region.tail[3] == 0
    let cursor = getpos('.')
    call setpos('.', a:region.tail)
    call search('.', 'bc')
    let a:region.tail = getpos('.')
    call setpos('.', cursor)
  endif
  return a:region
endfunction "}}}


function! s:operator_get_region(motionwise) abort "{{{
  let head = getpos("'[")
  let tail = getpos("']")
  if s:is_ahead(head, tail)
    return
  endif

  let s:region.head = head
  let s:region.tail = tail
  let s:region.wise = a:motionwise
endfunction "}}}


function! s:put_dummy_cursor(curpos) abort "{{{
  if !hlexists('Cursor')
    return {}
  endif
  let pos = {'head': a:curpos, 'tail': a:curpos, 'wise': 'char'}
  let dummycursor = highlightedyank#obsolete#highlight#new(pos)
  call dummycursor.show('Cursor')
  redraw
  return dummycursor
endfunction "}}}


function! s:clear_dummy_cursor(dummycursor) abort  "{{{
  if empty(a:dummycursor)
    return
  endif
  call a:dummycursor.quench()
endfunction "}}}


function! s:highlight_yanked_region(region) abort "{{{
  let maxlinenumber = s:get('max_lines', 10000)
  if a:region.tail[1] - a:region.head[1] + 1 > maxlinenumber
    return
  endif

  let keyseq = ''
  let hi_group = 'HighlightedyankRegion'
  let hi_duration = s:get('highlight_duration', 1000)
  let highlight = highlightedyank#obsolete#highlight#new(a:region)
  if highlight.empty()
    return
  endif
  if hi_duration < 0
    call s:persist(highlight, hi_group)
  elseif hi_duration > 0
    if s:HAS_TIMERS
      call s:glow(highlight, hi_group, hi_duration)
    else
      let keyseq = s:blink(highlight, hi_group, hi_duration)
      call feedkeys(keyseq, 'it')
    endif
  endif
endfunction "}}}


function! s:persist(highlight, hi_group) abort  "{{{
  " highlight off: limit the number of highlighting region to one explicitly
  call highlightedyank#obsolete#highlight#cancel()

  if a:highlight.show(a:hi_group)
    call a:highlight.persist()
  endif
endfunction "}}}


function! s:blink(highlight, hi_group, duration) abort "{{{
  let key = ''
  if a:highlight.show(a:hi_group)
    redraw
    let key = s:wait_for_input(a:highlight, a:duration)
  endif
  return key
endfunction "}}}


function! s:glow(highlight, hi_group, duration) abort "{{{
  " highlight off: limit the number of highlighting region to one explicitly
  call highlightedyank#obsolete#highlight#cancel()
  if a:highlight.show(a:hi_group)
    call a:highlight.quench_timer(a:duration)
  endif
endfunction "}}}


function! s:wait_for_input(highlight, duration) abort  "{{{
  let clock = highlightedyank#obsolete#clock#new()
  try
    let c = 0
    call clock.start()
    while empty(c)
      let c = getchar(0)
      if clock.started && clock.elapsed() > a:duration
        break
      endif
      sleep 20m
    endwhile
  finally
    call a:highlight.quench()
    call clock.stop()
  endtry

  if c == 0
    let c = ''
  else
    let c = type(c) == s:TYPE_NUM ? nr2char(c) : c
  endif

  return c
endfunction "}}}


function! s:shift_options() abort "{{{
  let options = {}

  """ tweak appearance
  " hide_cursor
  if s:HAS_GUI_RUNNING
    let options.cursor = &guicursor
    set guicursor+=a:block-NONE
  else
    let options.cursor = &t_ve
    set t_ve=
  endif

  return options
endfunction "}}}


function! s:restore_options(options) abort "{{{
  if s:HAS_GUI_RUNNING
    set guicursor&
    let &guicursor = a:options.cursor
  else
    let &t_ve = a:options.cursor
  endif
endfunction "}}}


function! s:get(name, default) abort  "{{{
  let identifier = 'highlightedyank_' . a:name
  return get(b:, identifier, get(g:, identifier, a:default))
endfunction "}}}


function! s:is_ahead(pos1, pos2) abort  "{{{
  return a:pos1[1] > a:pos2[1] || (a:pos1[1] == a:pos2[1] && a:pos1[2] > a:pos2[2])
endfunction "}}}


function! s:is_extended() abort "{{{
  " NOTE: This function should be used only when you are sure that the
  "       keymapping is used in visual mode.
  normal! gv
  let extended = winsaveview().curswant == s:MAXCOL
  execute "normal! \<Esc>"
  return extended
endfunction "}}}


function! s:visualmode2motionwise(visualmode) abort "{{{
  if a:visualmode ==# 'v'
    let motionwise = 'char'
  elseif a:visualmode ==# 'V'
    let motionwise = 'line'
  elseif a:visualmode[0] ==# "\<C-v>"
    let motionwise = 'block'
  else
    let motionwise = a:visualmode
  endif
  return motionwise
endfunction "}}}


function! s:motionwise2visualmode(motionwise) abort "{{{
  if a:motionwise ==# 'char'
    let visualmode = 'v'
  elseif a:motionwise ==# 'line'
    let visualmode = 'V'
  elseif a:motionwise[0] ==# 'block'
    let visualmode = "\<C-v>"
  else
    let visualmode = a:motionwise
  endif
  return visualmode
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
./autoload/highlightedyank.vim	[[[1
213
" highlighted-yank: Make the yanked region apparent!
" FIXME: Highlight region is incorrect when an input ^V[count]l ranges
"        multiple lines.
let s:NULLPOS = [0, 0, 0, 0]
let s:NULLREGION = [s:NULLPOS, s:NULLPOS, '']
let s:MAXCOL = 2147483647
let s:OFF = 0
let s:ON = 1
let s:HIGROUP = 'HighlightedyankRegion'



let s:timer = -1
let s:info = {}

" Highlight the yanked region
function! highlightedyank#debounce() abort "{{{
  if s:state is s:OFF
    return
  endif

  if get(v:event, 'visual', v:false)
    let highlight_in_visual = (
    \   get(b:, 'highlightedyank_highlight_in_visual', 1) &&
    \   get(g:, 'highlightedyank_highlight_in_visual', 1)
    \ )
    if !highlight_in_visual
      return
    endif
  endif

  let operator = v:event.operator
  let regtype = v:event.regtype
  let regcontents = v:event.regcontents
  if operator isnot# 'y' || regtype is# ''
    return
  endif

  if s:timer != -1
    call timer_stop(s:timer)
  endif
  let s:info = copy(v:event)
  let s:info.changedtick = b:changedtick
  " Old vim does not have visual key in v:event
  let s:info.visual = get(v:event, 'visual', v:false)

  " NOTE: The timer callback is not called while vim is busy, thus the
  "       highlight procedure starts after the control is returned to the user.
  "       This makes complex-repeat faster because the highlight doesn't
  "       performed during a macro execution.
  let s:timer = timer_start(1, {-> s:highlight()})
endfunction "}}}


let s:state = s:ON

function! highlightedyank#on() abort "{{{
  let s:state = s:ON
endfunction "}}}


function! highlightedyank#off() abort "{{{
  let s:state = s:OFF
endfunction "}}}


function! highlightedyank#toggle() abort "{{{
  if s:state is s:ON
    call highlightedyank#off()
  else
    call highlightedyank#on()
  endif
endfunction "}}}


function! s:highlight(...) abort "{{{
  let s:timer = -1
  if s:info.changedtick != b:changedtick
    return
  endif

  if s:info.visual
    let start0 = getpos("'<")
    let end0 = getpos("'>")
  else
    let start0 = getpos("'[")
    let end0 = getpos("']")
  endif
  let [start, end, type] = s:get_region(
  \   start0, end0, s:info.regtype, s:info.regcontents
  \ )
  if type is# ''
    return
  endif

  let maxlinenumber = s:get('max_lines', 10000)
  if end[1] - start[1] + 1 > maxlinenumber
    return
  endif

  let hi_duration = s:get('highlight_duration', 1000)
  if hi_duration == 0
    return
  endif

  call highlightedyank#highlight#add(s:HIGROUP, start, end, type, hi_duration)
endfunction "}}}


function! s:get_region(start, end, regtype, regcontents) abort "{{{
  if a:regtype is# 'v'
    return s:get_region_char(a:start, a:end, a:regcontents)
  elseif a:regtype is# 'V'
    return s:get_region_line(a:start, a:end, a:regcontents)
  elseif a:regtype[0] is# "\<C-v>"
    " NOTE: the width from v:event.regtype is not correct if 'clipboard' is
    "       unnamed or unnamedplus in windows
    " let width = str2nr(a:regtype[1:])
    return s:get_region_block(a:start, a:end, a:regcontents)
  endif
  return s:NULLREGION
endfunction "}}}


function! s:get_region_char(start, _, regcontents) abort "{{{
  let len = len(a:regcontents)
  let start = copy(a:start)
  let end = copy(start)
  if len == 0
    return s:NULLREGION
  elseif len == 1
    let end[2] += strlen(a:regcontents[0]) - 1
  elseif len == 2 && empty(a:regcontents[1])
    let end[2] += strlen(a:regcontents[0])
  else
    if empty(a:regcontents[-1])
      let end[1] += len - 2
      let end[2] = strlen(a:regcontents[-2])
    else
      let end[1] += len - 1
      let end[2] = strlen(a:regcontents[-1])
    endif
  endif
  let end = s:modify_end(end)
  return [start, end, 'v']
endfunction "}}}


function! s:get_region_line(start, end, regcontents) abort "{{{
  let start = copy(a:start)
  let end = copy(a:end)
  if end[2] == s:MAXCOL
    let end[2] = col([end[1], '$'])
  endif
  return [start, end, 'V']
endfunction "}}}


function! s:get_region_block(start, _, regcontents) abort "{{{
  let len = len(a:regcontents)
  if len == 0
    return s:NULLREGION
  endif

  let view = winsaveview()
  let curcol = col('.')
  let width = max(map(copy(a:regcontents), 'strdisplaywidth(v:val, curcol)'))
  let start = copy(a:start)
  call setpos('.', start)
  if len > 1
    execute printf('normal! %sj', len - 1)
  endif
  execute printf('normal! %s|', virtcol('.') + width - 1)
  let end = s:modify_end(getpos('.'))
  call winrestview(view)

  let blockwidth = width
  if strdisplaywidth(getline('.')) < width
    let blockwidth = s:MAXCOL
  endif
  let type = "\<C-v>" . blockwidth
  return [start, end, type]
endfunction "}}}


function! s:modify_end(end) abort "{{{
  " for multibyte characters
  if a:end[2] == col([a:end[1], '$']) || a:end[3] != 0
    return a:end
  endif

  let cursor = getpos('.')
  call setpos('.', a:end)
  let letterhead = searchpos('\zs', 'bcn', line('.'))
  if letterhead[1] > a:end[2]
    " try again without 'c' flag if letterhead is behind the original
    " position. It may look strange but it happens with &enc ==# 'cp932'
    let letterhead = searchpos('\zs', 'bn', line('.'))
  endif
  let a:end[1:2] = letterhead
  call setpos('.', cursor)
  return a:end
endfunction "}}}


function! s:get(name, default) abort  "{{{
  let identifier = 'highlightedyank_' . a:name
  return get(b:, identifier, get(g:, identifier, a:default))
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set ts=2 sts=2 sw=2:
./autoload/vital/_highlightedyank/Schedule.vim	[[[1
673
" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not mofidify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_highlightedyank#Schedule#import() abort', printf("return map({'Counter': '', 'delete_augroup': '', 'MetaTask': '', 'NeatTask': '', 'Switch': '', 'InvalidTriggers': '', 'Task': '', 'inherit': '', 'supercall': '', 'TaskChain': '', 'augroup': '', 'super': ''}, \"vital#_highlightedyank#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
" TODO: Implement Task.pause()/Task.resume()
" TODO: Implement NeatTask.preprocess()/.postprocess()
" TODO: Support [nested]
let s:TRUE = 1
let s:FALSE = 0
let s:ON = 1
let s:OFF = 0
let s:DEFAULTAUGROUP = 'vital-Schedule'

" Class system {{{
function! s:inherit(sub, super, ...) abort "{{{
  if a:0 == 0
    return s:_inherit(a:sub, a:super)
  endif
  let super = a:000[-1]
  let itemlist = [a:super] + a:000[:-2]
  for item in reverse(itemlist)
    let super = s:_inherit(item, super)
  endfor
  return s:_inherit(a:sub, super)
endfunction "}}}

function! s:super(sub, ...) abort "{{{
  if !has_key(a:sub, '__SUPER__')
    return {}
  endif

  let supername = get(a:000, 0, a:sub.__SUPER__.__CLASS__)
  let supermethods = a:sub
  try
    while supermethods.__CLASS__ isnot# supername
      let supermethods = supermethods.__SUPER__
    endwhile
  catch /^Vim\%((\a\+)\)\=:E716/
    echoerr printf('%s class does not have the super class named %s', a:sub.__CLASS__, supername)
  endtry

  let super = {}
  for [key, l:Val] in items(supermethods)
    if type(l:Val) is v:t_func
      let super[key] = function('s:_supercall', [a:sub, l:Val])
    endif
  endfor
  return super
endfunction "}}}

function! s:supercall(sub, supername, funcname) abort "{{{
  if !has_key(a:sub, '__SUPER__')
    return
  endif

  let supermethods = a:sub
  try
    while supermethods.__CLASS__ isnot# a:supername
      let supermethods = supermethods.__SUPER__
    endwhile
  catch /^Vim\%((\a\+)\)\=:E716/
    echoerr printf('%s class does not have the super class named %s', a:sub.__CLASS__, a:supername)
  endtry

  let args = get(a:000, 0, [])
  return s:_supercall(supermethods[a:funcname], args, a:sub)
endfunction "}}}

function! s:_inherit(sub, super) abort "{{{
  call extend(a:sub, a:super, 'keep')
  let a:sub.__SUPER__ = {}
  let a:sub.__SUPER__.__CLASS__ = a:super.__CLASS__
  let supermethods = filter(copy(a:super),
    \ 'type(v:val) is# v:t_func || v:key is# "__SUPER__"')
  call extend(a:sub.__SUPER__,  supermethods)
  return a:sub
endfunction "}}}

function! s:_supercall(sub, Funcref, ...) abort "{{{
  return call(a:Funcref, a:000, a:sub)
endfunction "}}}
"}}}

" Error list {{{
function! s:InvalidTriggers(triggerlist) abort "{{{
  return printf('vital-Schedule:E1: Invalid triggers, %s',
              \ string(a:triggerlist))
endfunction "}}}
"}}}



" Event class {{{
let s:Event = {
  \   'table': {},
  \ }

function! s:Event.add(augroup, event, pat, task) abort "{{{
  if !has_key(self.table, a:augroup)
    let self.table[a:augroup] = {}
  endif
  if !has_key(self.table[a:augroup], a:event)
    let self.table[a:augroup][a:event] = {}
  endif
  if !has_key(self.table[a:augroup][a:event], a:pat)
    let self.table[a:augroup][a:event][a:pat] = []
    call s:_autocmd(a:augroup, a:event, a:pat)
  endif
  call add(self.table[a:augroup][a:event][a:pat], a:task)
endfunction "}}}

function! s:Event.remove(augroup, event, pat, task) abort "{{{
  if !has_key(s:Event.table, a:augroup) || !has_key(s:Event.table[a:augroup], a:event)
      \ || !has_key(s:Event.table[a:augroup][a:event], a:pat)
    return
  endif

  call filter(self.table[a:augroup][a:event][a:pat],
            \ 'v:val isnot a:task && !v:val.hasdone()')

  if empty(s:Event.table[a:augroup][a:event][a:pat])
    call remove(s:Event.table[a:augroup][a:event], a:pat)
    execute printf('autocmd! %s %s %s', a:augroup, a:event, a:pat)

    if empty(s:Event.table[a:augroup][a:event])
      call remove(s:Event.table[a:augroup], a:event)

      if empty(s:Event.table[a:augroup])
        call remove(s:Event.table, a:augroup)
      endif
    endif
  endif
endfunction "}}}

function! s:_autocmd(augroup, event, pat) abort "{{{
  let autocmd = printf("autocmd %s %s call s:_doautocmd('%s', '%s', '%s')",
                      \ a:event, a:pat, a:augroup, a:event, a:pat)

  execute 'augroup ' . a:augroup
    execute autocmd
  augroup END
endfunction "}}}

function! s:_doautocmd(augroup, event, pat) abort "{{{
  if !has_key(s:Event.table, a:augroup) || !has_key(s:Event.table[a:augroup], a:event)
      \ || !has_key(s:Event.table[a:augroup][a:event], a:pat)
    return
  endif

  for task in s:Event.table[a:augroup][a:event][a:pat]
    call task.trigger()
  endfor
endfunction "}}}
"}}}



" Timer class {{{
let s:Timer = {
  \   'table': {},
  \ }

function! s:Timer.add(time, task) abort "{{{
  let id = timer_start(a:time, function('s:_timercall'), {'repeat': -1})
  let self.table[string(id)] = a:task
  return id
endfunction "}}}

function! s:Timer.remove(id) abort "{{{
  let idstr = string(a:id)
  if has_key(self.table, idstr)
    call remove(self.table, idstr)
  endif
  if !empty(timer_info(a:id))
    call timer_stop(a:id)
  endif
endfunction "}}}

function! s:_timercall(id) abort "{{{
  if !has_key(s:Timer.table, string(a:id))
    return
  endif
  let task = s:Timer.table[string(a:id)]
  call task.trigger()
endfunction "}}}
"}}}



" Switch class {{{
unlockvar! s:Switch
let s:Switch = {
  \ '__CLASS__': 'Switch',
  \ '__switch__': {
  \   'skipcount': 0,
  \   'skipif': [],
  \   }
  \ }
function! s:Switch() abort "{{{
  return deepcopy(s:Switch)
endfunction "}}}

function! s:Switch._on() abort "{{{
  let self.__switch__.skipcount = 0
  return self
endfunction "}}}

function! s:Switch._off() abort "{{{
  let self.__switch__.skipcount = -1
  return self
endfunction "}}}

function! s:Switch.skip(...) abort "{{{
  let self.__switch__.skipcount = max([get(a:000, 0, 1), -1])
  return self
endfunction "}}}

function! s:Switch.skipif(func, args, ...) abort "{{{
  let self.__switch__.skipif = [a:func, a:args] + a:000
endfunction "}}}

function! s:Switch._isactive() abort "{{{
  if !empty(self.__switch__.skipif)
    if call('call', self.__switch__.skipif)
      return s:FALSE
    endif
  endif
  return self.__switch__.skipcount == 0
endfunction "}}}

function! s:Switch._skipsthistime() abort "{{{
  if self._isactive()
    return s:FALSE
  endif
  if self.__switch__.skipcount > 0
    let self.__switch__.skipcount -= 1
    if self.__switch__.skipcount == 0
      call self._on()
    endif
  endif
  return s:TRUE
endfunction "}}}

lockvar! s:Switch
"}}}



" Counter class {{{
unlockvar! s:Counter
let s:Counter = {
  \ '__CLASS__': 'Counter',
  \ '__counter__': {
  \   'repeat': 1,
  \   'done': 0,
  \   'finishif': [],
  \   }
  \ }
function! s:Counter(count) abort "{{{
  let counter = deepcopy(s:Counter)
  let counter.__counter__.repeat = a:count
  return counter
endfunction "}}}

function! s:Counter.repeat(...) abort "{{{
  if a:0 > 0
    let self.__counter__.repeat = a:1
  endif
  let self.__counter__.done = 0
  return self
endfunction "}}}

function! s:Counter._tick(...) abort "{{{
  let self.__counter__.done += get(a:000, 0, 1)
endfunction "}}}

function! s:Counter.leftcount() abort "{{{
  if self.__counter__.repeat < 0
    return -1
  endif
  return max([self.__counter__.repeat - self.__counter__.done, 0])
endfunction "}}}

function! s:Counter.hasdone() abort "{{{
  if self.leftcount() == 0
    return s:TRUE
  endif

  " 'finishif' check
  if !empty(self.__counter__.finishif)
    if call('call', self.__counter__.finishif)
      return s:TRUE
    endif
  endif

  return s:FALSE
endfunction "}}}

function! s:Counter.finishif(func, args, ...) abort "{{{
  let self.__counter__.finishif = [a:func, a:args] + a:000
endfunction "}}}

lockvar! s:Counter
"}}}



" MetaTask class {{{
unlockvar! s:MetaTask
let s:MetaTask = {
  \ '__CLASS__': 'MetaTask',
  \ '_orderlist': [],
  \ }
function! s:MetaTask() abort "{{{
  return deepcopy(s:MetaTask)
endfunction "}}}

function! s:MetaTask.trigger() abort "{{{
  for [kind, expr] in self._orderlist
    if kind is# 'call'
      call call('call', expr)
    elseif kind is# 'execute'
      execute expr
    elseif kind is# 'task'
      call expr.trigger()
    endif
  endfor
  return self
endfunction "}}}

function! s:MetaTask.call(func, args, ...) abort "{{{
  let order = ['call', [a:func, a:args] + a:000]
  call add(self._orderlist, order)
  return self
endfunction "}}}

function! s:MetaTask.execute(cmd) abort "{{{
  let order = ['execute', a:cmd]
  call add(self._orderlist, order)
  return self
endfunction "}}}

function! s:MetaTask.append(task) abort "{{{
  let order = ['task', a:task]
  call add(self._orderlist, order)
  return self
endfunction "}}}

function! s:MetaTask.clear() abort "{{{
  call filter(self._orderlist, 0)
  return self
endfunction "}}}

function! s:MetaTask.clone() abort "{{{
  let clone = deepcopy(self)
  let clone._orderlist = copy(self._orderlist)
  return clone
endfunction "}}}

lockvar! s:MetaTask
"}}}



" NeatTask class (inherits Switch, Counter and MetaTask classes) {{{
unlockvar! s:NeatTask
let s:NeatTask = {
  \ '__CLASS__': 'NeatTask',
  \ }
function! s:NeatTask() abort "{{{
  let switch = s:Switch()
  let counter = s:Counter(1)
  let metatask = s:MetaTask()
  let neattask = deepcopy(s:NeatTask)
  return s:inherit(neattask, metatask, counter, switch)
endfunction "}}}

function! s:NeatTask.trigger() abort "{{{
  if self._skipsthistime()
    return self
  endif
  if self.hasdone()
    return self
  endif
  call s:super(self, 'MetaTask').trigger()
  call self._tick()
  if self.hasdone()
    call self.cancel()
  endif
  return self
endfunction "}}}

function! s:NeatTask.waitfor() abort "{{{
  return self
endfunction "}}}

function! s:NeatTask.cancel() abort "{{{
  return self
endfunction "}}}

function! s:NeatTask.isactive() abort "{{{
  return self._isactive()
endfunction "}}}

lockvar! s:NeatTask
"}}}



" Task class (inherits NeatTask class) {{{
unlockvar! s:Task
let s:Task = {
  \ '__CLASS__': 'Task',
  \ '__task__': {
  \   'Event': [],
  \   'Timer': -1,
  \   },
  \ '_state': s:OFF,
  \ '_augroup': '',
  \ }
function! s:Task(...) abort "{{{
  let neattask = s:NeatTask()
  let task = s:inherit(deepcopy(s:Task), neattask)
  let task._augroup = get(a:000, 0, s:DEFAULTAUGROUP)
  return task
endfunction "}}}

function! s:Task.clone() abort "{{{
  let clone = s:Task()
  let clone.__switch__ = deepcopy(self.__switch__)
  let clone.__counter__ = deepcopy(self.__counter__)
  let clone._state = s:OFF
  let clone._orderlist = copy(self._orderlist)
  return clone
endfunction "}}}

function! s:Task.waitfor(triggerlist) abort "{{{
  call self.cancel().repeat()
  let invalid = s:_invalid_triggerlist(a:triggerlist)
  if !empty(invalid)
    echoerr s:InvalidTriggers(invalid)
  endif
  let augroup = self._augroup

  let self._state = s:ON
  let events = filter(copy(a:triggerlist), 'type(v:val) is v:t_string || type(v:val) is v:t_list')
  call uniq(sort(events))
  for eventexpr in events
    let [event, pat] = s:_event_and_patterns(eventexpr)
    call s:Event.add(augroup, event, pat, self)
    call add(self.__task__.Event, [event, pat])
  endfor

  let times = filter(copy(a:triggerlist), 'type(v:val) is v:t_number')
  call filter(times, 'v:val > 0')
  if !empty(times)
    let time = min(times)
    let self.__task__.Timer = s:Timer.add(time, self)
  endif
  return self
endfunction "}}}

function! s:Task.cancel() abort "{{{
  let self._state = s:OFF
  if !empty(self.__task__.Event)
    let augroup = self._augroup
    for [event, pat] in self.__task__.Event
      call s:Event.remove(augroup, event, pat, self)
    endfor
    call filter(self.__task__.Event, 0)
  endif
  if self.__task__.Timer != -1
    let id = self.__task__.Timer
    call s:Timer.remove(id)
    let self.__task__.Timer = -1
  endif
  return self
endfunction "}}}

function! s:Task.isactive() abort "{{{
  return self._state && s:super(self, 'Switch')._isactive()
endfunction "}}}

" a method for test
function! s:Task._getid() abort "{{{
  return self.__task__.Timer
endfunction "}}}

lockvar! s:Task
"}}}



" TaskChain class (inherits Counter class) {{{
unlockvar! s:TaskChain
let s:TaskChain = {
  \ '__CLASS__': 'TaskChain',
  \ '__taskchain__': {
  \   'index': 0,
  \   'triggerlist': [],
  \   'orderlist': [],
  \   },
  \ '_state': s:OFF,
  \ '_augroup': '',
  \ }
function! s:TaskChain(...) abort "{{{
  let counter = s:Counter(1)
  let taskchain = s:inherit(deepcopy(s:TaskChain), counter)
  let taskchain._augroup = get(a:000, 0, s:DEFAULTAUGROUP)
  return taskchain
endfunction "}}}

function! s:TaskChain._gettrigger() abort "{{{
  return self.__taskchain__.triggerlist[self.__taskchain__.index]
endfunction "}}}

function! s:TaskChain._addtrigger(triggertask, args) abort "{{{
  call a:triggertask.repeat(-1)
  call a:triggertask.call(self.trigger, [], self)
  call add(self.__taskchain__.triggerlist, [a:triggertask, a:args])
endfunction "}}}

function! s:TaskChain._getorder() abort "{{{
  return self.__taskchain__.orderlist[self.__taskchain__.index]
endfunction "}}}

function! s:TaskChain._addorder(ordertask) abort "{{{
  call add(self.__taskchain__.orderlist, a:ordertask)
endfunction "}}}

function! s:TaskChain._gonext() abort "{{{
  let [trigger, _] = self._gettrigger()
  call trigger.cancel()

  let self.__taskchain__.index += 1
  if self.__taskchain__.index == len(self.__taskchain__.orderlist)
    call self._tick()
    if self.hasdone()
      call self.cancel()
      return
    else
      let self.__taskchain__.index = 0
    endif
  endif
  let [nexttrigger, args] = self._gettrigger()
  call call(nexttrigger.waitfor, args, nexttrigger)
endfunction "}}}

function! s:TaskChain._isover() abort "{{{
  return self.__taskchain__.index >= len(self.__taskchain__.orderlist)
endfunction "}}}

function! s:TaskChain.hook(triggerlist) abort "{{{
  let invalid = s:_invalid_triggerlist(a:triggerlist)
  if !empty(invalid)
    echoerr s:InvalidTriggers(invalid)
  endif

  let task = s:Task(self._augroup)
  let ordertask = s:NeatTask()
  let args = [a:triggerlist]
  call self._addtrigger(task, args)
  call self._addorder(ordertask)
  return ordertask
endfunction "}}}

function! s:TaskChain.trigger() abort "{{{
  if self._isover()
    return self
  endif

  let task = self._getorder()
  call task.trigger()
  if self.hasdone()
    call self.cancel()
  elseif task.hasdone()
    call self._gonext()
  endif
  return self
endfunction "}}}

function! s:TaskChain.waitfor() abort "{{{
  call self.cancel().repeat()
  let self._state = s:ON
  let [trigger, args] = self._gettrigger()
  call call(trigger.waitfor, args, trigger)
  return self
endfunction "}}}

function! s:TaskChain.cancel() abort "{{{
  let self._state = s:OFF
  if self._isover()
    return self
  endif

  let [trigger, _] = self._gettrigger()
  call trigger.cancel()
  call self._tick(self.leftcount())
  return self
endfunction "}}}

lockvar! s:TaskChain
"}}}



function! s:_event_and_patterns(eventexpr) abort "{{{
  let t_event = type(a:eventexpr)
  if t_event is v:t_string
    let event = a:eventexpr
    let pat = '*'
  elseif t_event is v:t_list
    let event = a:eventexpr[0]
    let pat = get(a:eventexpr, 1, '*')
    if type(pat) is v:t_number
      let pat = printf('<buffer=%d>', pat)
    endif
  else
    echoerr s:InvalidTriggers(a:eventexpr)
  endif
  return [event, pat]
endfunction "}}}

function! s:_invalid_triggerlist(triggerlist) abort "{{{
  return filter(copy(a:triggerlist), '!s:_isvalidtriggertype(v:val)')
endfunction "}}}

function! s:_isvalidtriggertype(item) abort "{{{
  let t_trigger = type(a:item)
  if t_trigger is v:t_string || t_trigger is v:t_list || t_trigger is v:t_number
    return s:TRUE
  endif
  return s:FALSE
endfunction "}}}

let s:AUTOCMDEVENTS = getcompletion('', 'event')
function! s:_isnecessaryaugroup(name) abort "{{{
  let boollist = map(copy(s:AUTOCMDEVENTS), 'eval(printf("exists(''#%s#%s'')", a:name, v:val))')
  return filter(boollist, 'v:val') != []
endfunction "}}}

function! s:augroup(name) dict abort "{{{
  let new = deepcopy(self)
  let new.Task = funcref(self.Task, [a:name])
  let new.TaskChain = funcref(self.TaskChain, [a:name])
  return new
endfunction "}}}

function! s:delete_augroup(name) abort "{{{
  if s:_isnecessaryaugroup(a:name)
    " FAIL: some autocmds are still left for the augroup
    return -1
  endif

  let ret = 0
  try
    execute 'augroup! ' . a:name
  catch /^Vim\%((\a\+)\)\=:E936/
    " FAIL: in processing the target augroup autocmd
    let ret = -2
  finally
    return ret
  endtry
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
" vim:set et ts=2 sw=2 sts=-1:
./autoload/vital/_highlightedyank.vim	[[[1
9
let s:_plugin_name = expand('<sfile>:t:r')

function! vital#{s:_plugin_name}#new() abort
  return vital#{s:_plugin_name[1:]}#new()
endfunction

function! vital#{s:_plugin_name}#function(funcname) abort
  silent! return function(a:funcname)
endfunction
./autoload/vital/highlightedyank.vim	[[[1
328
let s:plugin_name = expand('<sfile>:t:r')
let s:vital_base_dir = expand('<sfile>:h')
let s:project_root = expand('<sfile>:h:h:h')
let s:is_vital_vim = s:plugin_name is# 'vital'

let s:loaded = {}
let s:cache_sid = {}

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

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
let s:Vital.vital_files = s:_function('s:vital_files')

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
let s:Vital.import = s:_function('s:import')

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
let s:Vital.load = s:_function('s:load')

function! s:unload() abort dict
  let s:loaded = {}
  let s:cache_sid = {}
  unlet! s:vital_files
endfunction
let s:Vital.unload = s:_function('s:unload')

function! s:exists(name) abort dict
  if a:name !~# '\v^\u\w*%(\.\u\w*)*$'
    throw 'vital: Invalid module name: ' . a:name
  endif
  return s:_module_path(a:name) isnot# ''
endfunction
let s:Vital.exists = s:_function('s:exists')

function! s:search(pattern) abort dict
  let paths = s:_extract_files(a:pattern, self.vital_files())
  let modules = sort(map(paths, 's:_file2module(v:val)'))
  return s:_uniq(modules)
endfunction
let s:Vital.search = s:_function('s:search')

function! s:plugin_name() abort dict
  return self._plugin_name
endfunction
let s:Vital.plugin_name = s:_function('s:plugin_name')

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
  " Cache module before calling module.vital_loaded() to avoid cyclic
  " dependences but remove the cache if module._vital_loaded() fails.
  " let s:loaded[a:name] = export_module
  let s:loaded[a:name] = export_module
  if has_key(module, '_vital_loaded')
    try
      call module._vital_loaded(vital#{s:plugin_name}#new())
    catch
      unlet s:loaded[a:name]
      throw 'vital: fail to call ._vital_loaded(): ' . v:exception
    endtry
  endif
  return copy(s:loaded[a:name])
endfunction
let s:Vital._import = s:_function('s:_import')

" s:_get_module() returns module object wihch has all script local functions.
function! s:_get_module(name) abort dict
  let funcname = s:_import_func_name(self.plugin_name(), a:name)
  try
    return call(funcname, [])
  catch /^Vim\%((\a\+)\)\?:E117/
    return s:_get_builtin_module(a:name)
  endtry
endfunction

function! s:_get_builtin_module(name) abort
 return s:sid2sfuncs(s:_module_sid(a:name))
endfunction

if s:is_vital_vim
  " For vital.vim, we can use s:_get_builtin_module directly
  let s:Vital._get_module = s:_function('s:_get_builtin_module')
else
  let s:Vital._get_module = s:_function('s:_get_module')
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
  for line in filter(split(s:_execute(':scriptnames'), "\n"), 'v:val =~# a:filter_pattern')
    let [_, sid, path; __] = matchlist(line, '^\s*\(\d\+\):\s\+\(.\+\)\s*$')
    if s:_unify_path(path) is# unified_path
      let s:cache_sid[unified_path] = sid
      return s:cache_sid[unified_path]
    endif
  endfor
  return 0
endfunction

" We want to use a execute() builtin function instead of s:_execute(),
" however there is a bug in execute().
" execute() returns empty string when it is called in
" completion function of user defined ex command.
" https://github.com/vim-jp/issues/issues/1129
function! s:_execute(cmd) abort
  let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
  set verbose=0 verbosefile=
  redir => res
    silent! execute a:cmd
  redir END
  let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
  return res
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
  let fs = split(s:_execute(printf(':function /^%s%s_', s:SNR, a:sid)), "\n")
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

if exists('*uniq')
  function! s:_uniq(list) abort
    return uniq(a:list)
  endfunction
else
  function! s:_uniq(list) abort
    let i = len(a:list) - 1
    while 0 < i
      if a:list[i] ==# a:list[i - 1]
        call remove(a:list, i)
      endif
      let i -= 1
    endwhile
    return a:list
  endfunction
endif
./autoload/vital/highlightedyank.vital	[[[1
4
highlightedyank
a8773a35b8b122b59c956a23d1e686d595bca3b4

Schedule
./doc/highlightedyank.jax	[[[1
132
*highlightedyank.txt*	ヤンクした場所をわかりやすくする。
						Last change:03-May-2022.

書いた人   : machakann <mckn{at}outlook.jp>
ライセンス : NYSL ライセンス
          日本語版 <http://www.kmonos.net/nysl/>
          英語版 (非公式) <http://www.kmonos.net/nysl/index.en.html>

必要要件:	Vim 7.4 かそれ以降の Vim エディタであること
		|+reltime| オプション
		|+float| オプション
		|+timers| オプション (任意)

==============================================================================
INDEX					*highlightedyank-index*

INTRODUCTION				|highlightedyank-introduction|
OPTIONS					|highlightedyank-options|
HIGHLIGHT GROUPS			|highlightedyank-highlight-groups|
KNOWN ISSUES				|highlightedyank-known-issues|

==============================================================================
INTRODUCTION				*highlightedyank-introduction*

*highlightedyank.vim* はユーザーのヤンクした箇所をハイライトするだけのプラグイ
ンです。あなたのコーディング作業にほんの少しの彩りを加えます。

もし、neovim <https://neovim.io/> を使用している場合はこのプラグインは必要あり
ません。|lua-highlight| を参照してください。

Vim 8.0.1934 かそれよりも新しいバージョンを使用している場合はインストールする
だけで使えます。ハイライト処理は |TextYankPost| イベントにより実行されます。

|TextYankPost| イベントが使えない場合も次の行を vimrc に書き加えると使えます。
|TextYankPost| が存在するか確認するようにするとよいでしょう。
>
	if !exists('##TextYankPost')
	  nmap y <Plug>(highlightedyank)
	  xmap y <Plug>(highlightedyank)
	  omap y <Plug>(highlightedyank)
	endif
<

==============================================================================
OPTIONS					*highlightedyank-options*

ハイライトの持続時間は次の変数を通して変更できます。
*g:highlightedyank_highlight_duration*
*b:highlightedyank_highlight_duration*
ミリセカンド単位の数値を設定してください。
>
	let g:highlightedyank_highlight_duration = 1000
<
負数が与えられるとハイライトは時間によって消えなくなります。
>
	let g:highlightedyank_highlight_duration = -1
<
ただしいずれの場合も、ハイライト位置がずれるのを防ぐためにより前方が編集された
場合はハイライトが消去されます。また、新しい位置がヤンクされると古い位置のハイ
ライトは消えます。

------------------------------------------------------------------------------

ハイライト処理はしばしば、特に多くの行をヤンクした場合に遅くなります。これを避
けるために次の安全策が設けられています。

					*g:highlightedyank_max_lines*
					*b:highlightedyank_max_lines*
|g:highlightedyank_max_lines| と |b:highlightedyank_max_lines| を使い、ハイラ
イトを実行する上限行数を設定することができます。下記の行を vimrc に追加するこ
とで 1000 行以上をヤンクしようとしたときハイライトしないようにできます。
>
	let g:highlightedyank_max_lines = 1000
<
これらが明示的に指定されていない場合は、 10000 行を超える場合にハイライトをし
ません。

------------------------------------------------------------------------------

					*g:highlightedyank_highlight_in_visual*
					*b:highlightedyank_highlight_in_visual*
ヴィジュアル選択範囲をヤンクした場合のハイライトはあまり必要でないかもしれませ
ん。そんな場合にはこのオプションに偽値を設定してください。
>
	let g:highlightedyank_highlight_in_visual = 0
<

==============================================================================
HIGHLIGHT GROUPS			*highlightedyank-highlight-groups*

ハイライトの色を変更したければ次のハイライトグループが使えます。

HighlightedyankRegion				*hl-HighlightedyankRegion*
	ヤンクした箇所のハイライトを定義するためのハイライトグループです。
	デフォルトでは IncSearch |hl-IncSearch| にリンクされています。
>
	highlight link HighlightedyankRegion IncSearch
<
	直接色を指定する場合は次のように書きます。
>
	highlight HighlightedyankRegion ctermbg=237 guibg=#404040
<
	より詳しくは |:highlight| を参照してください。

	ただし、再定義は vimrc の中の |:colorscheme| 以降で行われる必要があり
	ます。

==============================================================================
COMMANDS				*highlightedyank-commands*

:HighlightedyankOff				*:HighlightedyankOff*
	ハイライト機能を一時停止します。

:HighlightedyankOn				*:HighlightedyankOn*
	|:HighlightedyankOff| コマンドによって停止していたハイライト機能を再開
	します。

:HighlightedyankToggle				*:HighlightedyankToggle*
	ハイライト機能のオン・オフを切り替えます。
	|:HighlightedyankOff| および |:HighlightedyankOn| の項も参照してくださ
	い。

==============================================================================
KNOWN ISSUES				*highlightedyank-known-issues*

 - 'clipboard' に "unnamed" が設定されているとき `"*yiw` は "0 |quote0|
   レジスタを更新してしまいます。
 - 'clipboard' に "unnamedplus" が設定されているとき `"+yiw` は "0 |quote0|
   レジスタを更新してしまいます。

==============================================================================
vim:tw=78:ts=8:ft=help:norl:noet:
./doc/highlightedyank.txt	[[[1
126
*highlightedyank.txt*	Make the yanked region apparent!
						Last change:03-May-2022.

Author  : machakann <mckn{at}outlook.jp>
License : NYSL license
          Japanese <http://www.kmonos.net/nysl/>
          English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>

Requirement:	Vim 7.4 or higher
		|+reltime| feature
		|+float| feature
		|+timers| feature (optional)

==============================================================================
INDEX					*highlightedyank-index*

INTRODUCTION				|highlightedyank-introduction|
OPTIONS					|highlightedyank-options|
HIGHLIGHT GROUPS			|highlightedyank-highlight-groups|
COMMANDS				|highlightedyank-commands|
KNOWN ISSUES				|highlightedyank-known-issues|

==============================================================================
INTRODUCTION				*highlightedyank-introduction*

*highlightedyank.vim* is a plugin to highlight the yanked region.
This is a pretty trick to make your coding more comfortable.

Note that if you are using neovim <https://neovim.io/>, you don't need this
plugin. Check out |lua-highlight|.

If you are using Vim 8.0.1934 or later, there is no need for configuration,
as the highlight event is automatically triggered by |TextYankPost| event.

Otherwise, it is required to define a keymapping to `<Plug>(highlightedyank)`.
It would be good to check the existence of |TextYankPost| event.
>
	if !exists('##TextYankPost')
	  nmap y <Plug>(highlightedyank)
	  xmap y <Plug>(highlightedyank)
	  omap y <Plug>(highlightedyank)
	endif
<
==============================================================================
OPTIONS					*highlightedyank-options*

					*g:highlightedyank_highlight_duration*
					*b:highlightedyank_highlight_duration*
This option changes the highlighting duration.
Assign a number of time in milli seconds.
>
	let g:highlightedyank_highlight_duration = 1000
<
If a negative number is assigned, the highlight gets persistent.
>
	let g:highlightedyank_highlight_duration = -1
<
When another text is yanked or when the user starts editing, the old
highlighting will be deleted.

------------------------------------------------------------------------------

The highlight process could be very slow when the user yanked a bunch of
lines. This plugin has an option to avoid the problem.

					*g:highlightedyank_max_lines*
					*b:highlightedyank_max_lines*
This plugin gives up highlighting if the yanked lines exceeds the number.
Adding the following line into your vimrc to give up over one thousand lines.
>
	let g:highlightedyank_max_lines = 1000
<
The default value is 10000 lines.

------------------------------------------------------------------------------

					*g:highlightedyank_highlight_in_visual*
					*b:highlightedyank_highlight_in_visual*
The highlight may not be needed or even annoying in visual mode. In that case,
set a falsy value to the option.
>
	let g:highlightedyank_highlight_in_visual = 0
<

==============================================================================
HIGHLIGHT GROUPS			*highlightedyank-highlight-groups*

In order to change the highlighting color, re-define the following highlight
group.

	The highlight group to make the yanked region noticeable.
	It is linked to the highlight group IncSearch by default.
	|hl-IncSearch|
>
	highlight link HighlightedyankRegion IncSearch
<
	In order to asign the color directly:
>
	highlight HighlightedyankRegion ctermbg=237 guibg=#404040
<
	See |:highlight| help for more details. NOTE that the line should be
	located after |:colorscheme| command execution in your vimrc.

==============================================================================
COMMANDS				*highlightedyank-commands*

:HighlightedyankOff				*:HighlightedyankOff*
	This command stops highlighting temporarily.

:HighlightedyankOn				*:HighlightedyankOn*
	This command (re)starts highlighting stopped by |:HighlightedyankOff|.

:HighlightedyankToggle				*:HighlightedyankToggle*
	This command toggles on/off of highlighting feature.
	See |:HighlightedyankOff| and |:HighlightedyankOn| also.

==============================================================================
KNOWN ISSUES				*highlightedyank-known-issues*

 - When 'clipboard' is set as "unnamed", `"*yiw` updates "0 |quote0|
   register.
 - When 'clipboard' is set as "unnamedplus", `"+yiw` updates "0 |quote0|
   register.

==============================================================================
vim:tw=78:ts=8:ft=help:norl:noet:
./plugin/highlightedyank.vim	[[[1
61
" highlighted-yank: Make the yanked region apparent!
" Last Change: 15-Mar-2018.
" Maintainer : Masaaki Nakamura <mckn@outlook.com>

" License    : NYSL
"              Japanese <http://www.kmonos.net/nysl/>
"              English (Unofficial) <http://www.kmonos.net/nysl/index.en.html>
if exists("g:loaded_highlightedyank")
  finish
endif
let g:loaded_highlightedyank = 1

" highlight group
function! s:default_highlight() abort
  highlight default link HighlightedyankRegion IncSearch
endfunction
call s:default_highlight()
augroup highlightedyank-event-ColorScheme
  autocmd!
  autocmd ColorScheme * call s:default_highlight()
augroup END

if exists('##TextYankPost') && !hasmapto('<Plug>(highlightedyank)') && !exists('g:highlightedyank_disable_autocmd')
  augroup highlightedyank
    autocmd!
    autocmd TextYankPost * call highlightedyank#debounce()
  augroup END

  " commands
  command! -nargs=0 -bar HighlightedyankOn     call highlightedyank#on()
  command! -nargs=0 -bar HighlightedyankOff    call highlightedyank#off()
  command! -nargs=0 -bar HighlightedyankToggle call highlightedyank#toggle()
else
  function! s:keymap() abort
    if stridx(&cpoptions, 'y') < 0
      nnoremap <silent> <Plug>(highlightedyank) :<C-u>call highlightedyank#obsolete#highlightedyank#yank('n')<CR>
      xnoremap <silent> <Plug>(highlightedyank) :<C-u>call highlightedyank#obsolete#highlightedyank#yank('x')<CR>
      onoremap          <Plug>(highlightedyank) y
    else
      noremap  <silent> <Plug>(highlightedyank-g@) g@
      noremap  <expr>   <Plug>(highlightedyank-setoperatorfunc) highlightedyank#obsolete#highlightedyank#setoperatorfunc()
      nmap     <silent> <Plug>(highlightedyank) <Plug>(highlightedyank-setoperatorfunc)<Plug>(highlightedyank-g@)
      xmap     <silent> <Plug>(highlightedyank) <Plug>(highlightedyank-setoperatorfunc)<Plug>(highlightedyank-g@)
      onoremap          <Plug>(highlightedyank) g@
    endif
  endfunction
  call s:keymap()

  if exists('##OptionSet')
    augroup highlightedyank-event-OptionSet
      autocmd!
      autocmd OptionSet cpoptions call s:keymap()
    augroup END
  endif

  " commands
  command! -nargs=0 -bar HighlightedyankOn     call highlightedyank#obsolete#highlightedyank#on()
  command! -nargs=0 -bar HighlightedyankOff    call highlightedyank#obsolete#highlightedyank#off()
  command! -nargs=0 -bar HighlightedyankToggle call highlightedyank#obsolete#highlightedyank#toggle()
endif

./test/test-highlightedyank.bat	[[[1
11
@echo off
set VIM=vim
if defined THEMIS_VIM set VIM=%THEMIS_VIM%

%VIM% -u NONE -i NONE -N -n -e -s -S %~dp0\test-highlightedyank.vim
if %errorlevel% neq 0 goto ERROR
echo Succeeded.
exit /b 0

:ERROR
exit /b 1
./test/test-highlightedyank.sh	[[[1
15
#! /bin/sh

SCRIPT_HOME=$0
if [ -n "`readlink $SCRIPT_HOME`" ] ; then
    SCRIPT_HOME="`readlink $SCRIPT_HOME`"
fi
SCRIPT_HOME="`dirname $SCRIPT_HOME`"

VIM=vim
if [ -n "$THEMIS_VIM" ] ; then
    VIM="$THEMIS_VIM"
fi

$VIM -u NONE -i NONE -N -n -e -s -S $SCRIPT_HOME/test-highlightedyank.vim || exit 1
echo "Succeeded."
./test/test-highlightedyank.vim	[[[1
356
if has('win32')
  set shellslash
endif
execute 'set runtimepath+=' . expand('<sfile>:p:h:h')
runtime! plugin/*.vim
scriptencoding utf-8
let s:is_win = has('win32') || system('uname') =~# '\%(MSYS\|MINGW\)'

" test utility  "{{{
function! s:assert(a1, a2, kind) abort  "{{{
  if type(a:a1) == type(a:a2) && string(a:a1) ==# string(a:a2)
    return
  endif

  %delete
  call append(0, ['Got:', string(a:a1)])
  call append(0, [a:kind, '', 'Expect:', string(a:a2)])
  $delete
  1,$print
  cquit
endfunction
"}}}
function! s:quit_by_error() abort "{{{
  %delete
  call append(0, [printf('Catched the following error at %s.', v:throwpoint), v:exception])
  $delete
  1,$print
  cquit
endfunction
"}}}
"}}}
" testset "{{{
" NOTE: %s in keyseq is replaced to register assignment.
let s:testset = [
      \   {
      \     'keyseq': '%syiw',
      \     'yanked': "foo",
      \     'foo': 1,
      \     'bar': 0,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': '%sy3e',
      \     'yanked': "foo\nbar\nbaz",
      \     'foo': 1,
      \     'bar': 1,
      \     'baz': 1,
      \   },
      \   {
      \     'keyseq': '%syy',
      \     'yanked': "foo\n",
      \     'foo': 1,
      \     'bar': 0,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': '%syj',
      \     'yanked': "foo\nbar\n",
      \     'foo': 1,
      \     'bar': 1,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': "%sy\<C-v>iw",
      \     'yanked': "foo",
      \     'foo': 1,
      \     'bar': 0,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': "%sy\<C-v>3e",
      \     'yanked': "foo\nbar\nbaz",
      \     'foo': 1,
      \     'bar': 1,
      \     'baz': 1,
      \   },
      \
      \   {
      \     'keyseq': 'viw%sy',
      \     'yanked': "foo",
      \     'foo': 1,
      \     'bar': 0,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': 'v3e%sy',
      \     'yanked': "foo\nbar\nbaz",
      \     'foo': 1,
      \     'bar': 1,
      \     'baz': 1,
      \   },
      \   {
      \     'keyseq': 'V%sy',
      \     'yanked': "foo\n",
      \     'foo': 1,
      \     'bar': 0,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': 'Vj%sy',
      \     'yanked': "foo\nbar\n",
      \     'foo': 1,
      \     'bar': 1,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': "\<C-v>iw%sy",
      \     'yanked': "foo",
      \     'foo': 1,
      \     'bar': 0,
      \     'baz': 0,
      \   },
      \   {
      \     'keyseq': "\<C-v>3e%sy",
      \     'yanked': "foo\nbar\nbaz",
      \     'foo': 1,
      \     'bar': 1,
      \     'baz': 1,
      \   },
      \ ]
let s:register_table = [
      \   {
      \     'clipboard': '',
      \     'keyseq': '',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamed',
      \     'keyseq': '',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': s:is_win ? 1 : 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus',
      \     'keyseq': '',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': s:is_win ? 0 : 1,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus,unnamed',
      \     'keyseq': '',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': 1,
      \     '@a': 0,
      \   },
      \
      \   {
      \     'clipboard': '',
      \     'keyseq': '""',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamed',
      \     'keyseq': '""',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus',
      \     'keyseq': '""',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus,unnamed',
      \     'keyseq': '""',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 0,
      \   },
      \
      \   {
      \     'clipboard': '',
      \     'keyseq': '"*',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': s:is_win ? 1 : 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamed',
      \     'keyseq': '"*',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': s:is_win ? 1 : 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus',
      \     'keyseq': '"*',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': s:is_win ? 1 : 0,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus,unnamed',
      \     'keyseq': '"*',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': s:is_win ? 1 : 0,
      \     '@a': 0,
      \   },
      \
      \   {
      \     'clipboard': '',
      \     'keyseq': '"+',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': 1,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamed',
      \     'keyseq': '"+',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': 1,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus',
      \     'keyseq': '"+',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': s:is_win ? 0 : 1,
      \     '@a': 0,
      \   },
      \   {
      \     'clipboard': 'unnamedplus,unnamed',
      \     'keyseq': '"+',
      \     '@0': 1,
      \     '@"': 1,
      \     '@*': 1,
      \     '@+': 1,
      \     '@a': 0,
      \   },
      \
      \   {
      \     'clipboard': '',
      \     'keyseq': '"a',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 1,
      \   },
      \   {
      \     'clipboard': 'unnamed',
      \     'keyseq': '"a',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 1,
      \   },
      \   {
      \     'clipboard': 'unnamedplus',
      \     'keyseq': '"a',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 1,
      \   },
      \   {
      \     'clipboard': 'unnamedplus,unnamed',
      \     'keyseq': '"a',
      \     '@0': 0,
      \     '@"': 1,
      \     '@*': 0,
      \     '@+': 0,
      \     '@a': 1,
      \   },
      \ ]
function! s:is_highlighted(lnum) abort
  let matchlist = filter(getmatches(), 'v:val.group ==# "HighlightedyankRegion"')
  let lnumlist = []
  for hi in matchlist
    let lnumlist += [get(hi, 'pos1', [0])[0]]
    let lnumlist += [get(hi, 'pos2', [0])[0]]
    let lnumlist += [get(hi, 'pos3', [0])[0]]
    let lnumlist += [get(hi, 'pos4', [0])[0]]
    let lnumlist += [get(hi, 'pos5', [0])[0]]
    let lnumlist += [get(hi, 'pos6', [0])[0]]
    let lnumlist += [get(hi, 'pos7', [0])[0]]
    let lnumlist += [get(hi, 'pos8', [0])[0]]
  endfor
  call filter(lnumlist, 'v:val != 0')
  return match(lnumlist, a:lnum) > -1
endfunction
"}}}

try

map y <Plug>(highlightedyank)
call append(0, ['foo', 'bar', 'baz'])

for s:register in s:register_table
  for s:test in s:testset
    let &clipboard = s:register.clipboard
    let [@0, @", @*, @+, @a] = ['', '', '', '', '']

    let s:keyseq = printf(s:test.keyseq, s:register.keyseq)
    call feedkeys('gg' . s:keyseq, 'tx')
    call s:assert(@0, s:register['@0'] ? s:test.yanked : '', printf('keyseq: %s (clipboard: "%s") %s', s:keyseq, s:register.clipboard, printf('-> @0: "%s"', @0)))
    call s:assert(@", s:register['@"'] ? s:test.yanked : '', printf('keyseq: %s (clipboard: "%s") %s', s:keyseq, s:register.clipboard, printf('-> @": "%s"', @")))
    call s:assert(@*, s:register['@*'] ? s:test.yanked : '', printf('keyseq: %s (clipboard: "%s") %s', s:keyseq, s:register.clipboard, printf('-> @*: "%s"', @*)))
    call s:assert(@+, s:register['@+'] ? s:test.yanked : '', printf('keyseq: %s (clipboard: "%s") %s', s:keyseq, s:register.clipboard, printf('-> @+: "%s"', @+)))
    call s:assert(@a, s:register['@a'] ? s:test.yanked : '', printf('keyseq: %s (clipboard: "%s") %s', s:keyseq, s:register.clipboard, printf('-> @+: "%s"', @a)))
    call s:assert(s:is_highlighted(1), s:test.foo, printf('keyseq: %s -> foo is %shighlighted.', s:keyseq, s:test.foo ? 'not ' : ''))
    call s:assert(s:is_highlighted(2), s:test.bar, printf('keyseq: %s -> bar is %shighlighted.', s:keyseq, s:test.bar ? 'not ' : ''))
    call s:assert(s:is_highlighted(3), s:test.baz, printf('keyseq: %s -> baz is %shighlighted.', s:keyseq, s:test.baz ? 'not ' : ''))

    call highlightedyank#highlight#cancel()
  endfor
endfor

catch
  call s:quit_by_error()
endtry
qall!

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
