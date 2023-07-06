" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.github/FUNDING.yml	[[[1
2
github: tpope
custom: ["https://www.paypal.me/vimpope"]
./.gitignore	[[[1
1
/doc/tags
./CONTRIBUTING.markdown	[[[1
1
See the [contribution guidelines for pathogen.vim](https://github.com/tpope/vim-pathogen/blob/master/CONTRIBUTING.markdown).
./README.markdown	[[[1
51
# obsession.vim

Vim features a `:mksession` command to write a file containing the current
state of Vim: window positions, open folds, stuff like that.  For most of my
existence, I found the interface way too awkward and manual to be useful, but
I've recently discovered that the only thing standing between me and simple,
no-hassle Vim sessions is a few tweaks:

* Instead of making me remember to capture the session immediately before
  exiting Vim, allow me to do it at any time, and automatically re-invoke
  `:mksession` immediately before exit.
* Also invoke `:mksession` whenever the layout changes (in particular, on
  `BufEnter`), so that even if Vim exits abnormally, I'm good to go.
* If I load an existing session, automatically keep it updated as above.
* If I try to create a new session on top of an existing session, don't refuse
  to overwrite it.  Just do what I mean.
* If I pass in a directory rather than a file name, just create a
  `Session.vim` inside of it.
* Don't capture options and maps.  Options are sometimes mutilated and maps
  just interfere with updating plugins.

Use `:Obsess` (with optional file/directory name) to start recording to a
session file and `:Obsess!` to stop and throw it away.  That's it.  Load a
session in the usual manner: `vim -S`, or `:source` it.

There's also an indicator you can put in `'statusline'`, `'tabline'`, or
`'titlestring'`.  See `:help obsession-status`.

## Installation

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/tpope/vim-obsession.git
    vim -u NONE -c "helptags vim-obsession/doc" -c q

## Self-Promotion

Like obsession.vim?  Follow the repository on
[GitHub](https://github.com/tpope/vim-obsession) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=4472).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
./doc/obsession.txt	[[[1
39
*obsession.txt*  Continuously updated session files

Author:  Tim Pope <http://tpo.pe/>
Repo:    https://github.com/tpope/vim-obsession
License: Same terms as Vim itself (see |license|)

USAGE                                           *obsession* *:Obsession*

:Obsession {file}       Invoke |:mksession| on {file} and continue to keep it
                        updated until Vim exits, triggering on the |BufEnter|
                        and |VimLeavePre| autocommands.  If the file exists,
                        it will be overwritten if and only if it looks like a
                        session file.

                        Set `g:obsession_no_bufenter` to disable saving the
                        session on |BufEnter|, improving performance at the
                        expense of safety.

:Obsession {dir}        Invoke |:Obsession| on {dir}/Session.vim.  Use "." to
                        write to a session file in the current directory.

:Obsession              If session tracking is already in progress, pause it.
                        Otherwise, resume tracking or create a new session in
                        the current directory.

:Obsession!             Stop obsession and delete the underlying session file.

Loading a session created with |:Obsession| automatically resumes updates to
that file.

STATUS INDICATOR                                *obsession-status*

                                                *ObsessionStatus()*
Add %{ObsessionStatus()} to 'statusline', 'tabline', or 'titlestring' to get
an indicator when Obsession is active or paused.  Pass an argument to override
the text of the indicator and a second argument to override the text of the
paused indictor.

 vim:tw=78:et:ft=help:norl:
./plugin/obsession.vim	[[[1
132
" obsession.vim - Continuously updated session files
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.0
" GetLatestVimScripts: 4472 1 :AutoInstall: obsession.vim

if exists("g:loaded_obsession") || v:version < 704 || &cp
  finish
endif
let g:loaded_obsession = 1

command! -bar -bang -complete=file -nargs=? Obsession
      \ execute s:dispatch(<bang>0, <q-args>)

function! s:dispatch(bang, file) abort
  let session = get(g:, 'this_obsession', v:this_session)
  try
    if a:bang && empty(a:file) && filereadable(session)
      echo 'Deleting session in '.fnamemodify(session, ':~:.')
      call delete(session)
      unlet! g:this_obsession
      return ''
    elseif empty(a:file) && exists('g:this_obsession')
      echo 'Pausing session in '.fnamemodify(session, ':~:.')
      unlet g:this_obsession
      return ''
    elseif empty(a:file) && !empty(session)
      let file = session
    elseif empty(a:file)
      let file = getcwd() . '/Session.vim'
    elseif isdirectory(a:file)
      let file = substitute(fnamemodify(expand(a:file), ':p'), '[\/]$', '', '')
            \ . '/Session.vim'
    else
      let file = fnamemodify(expand(a:file), ':p')
    endif
    if !a:bang
      \ && file !~# 'Session\.vim$'
      \ && filereadable(file)
      \ && getfsize(file) > 0
      \ && readfile(file, '', 1)[0] !=# 'let SessionLoad = 1'
      return 'mksession '.fnameescape(file)
    endif
    let g:this_obsession = file
    let error = s:persist()
    if empty(error)
      echo 'Tracking session in '.fnamemodify(file, ':~:.')
      let v:this_session = file
      return ''
    else
      return error
    endif
  finally
    let &l:readonly = &l:readonly
  endtry
endfunction

function! s:doautocmd_user(arg) abort
  if !exists('#User#' . a:arg)
    return ''
  else
    return 'doautocmd <nomodeline> User ' . fnameescape(a:arg)
  endif
endfunction

function! s:persist() abort
  if exists('g:SessionLoad')
    return ''
  endif
  let sessionoptions = &sessionoptions
  if exists('g:this_obsession')
    let tmp = g:this_obsession . '.' . getpid() . '.obsession~'
    try
      set sessionoptions-=blank sessionoptions-=options sessionoptions+=tabpages
      exe s:doautocmd_user('ObsessionPre')
      execute 'mksession!' fnameescape(tmp)
      let v:this_session = g:this_obsession
      let body = readfile(tmp)
      call insert(body, 'let g:this_session = v:this_session', -3)
      call insert(body, 'let g:this_obsession = v:this_session', -3)
      if type(get(g:, 'obsession_append')) == type([])
        for line in g:obsession_append
          call insert(body, line, -3)
        endfor
      endif
      call writefile(body, tmp)
      call rename(tmp, g:this_obsession)
      let g:this_session = g:this_obsession
      exe s:doautocmd_user('Obsession')
    catch /^Vim(mksession):E11:/
      return ''
    catch
      unlet g:this_obsession
      let &l:readonly = &l:readonly
      return 'echoerr '.string(v:exception)
    finally
      let &sessionoptions = sessionoptions
      call delete(tmp)
    endtry
  endif
  return ''
endfunction

function! ObsessionStatus(...) abort
  let args = copy(a:000)
  let numeric = !empty(v:this_session) + exists('g:this_obsession')
  if type(get(args, 0, '')) == type(0)
    if !remove(args, 0)
      return ''
    endif
  endif
  if empty(args)
    let args = ['[$]', '[S]']
  endif
  if len(args) == 1 && numeric == 1
    let fmt = args[0]
  else
    let fmt = get(args, 2-numeric, '')
  endif
  return substitute(fmt, '%s', get(['', 'Session', 'Obsession'], numeric), 'g')
endfunction

augroup obsession
  autocmd!
  autocmd VimLeavePre * exe s:persist()
  autocmd BufEnter *
        \ if !get(g:, 'obsession_no_bufenter') |
        \   exe s:persist() |
        \ endif
  autocmd User Flags call Hoist('global', 'ObsessionStatus')
augroup END

" vim:set et sw=2:
