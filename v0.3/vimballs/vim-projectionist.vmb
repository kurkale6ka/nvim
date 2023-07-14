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
142
# projectionist.vim

Projectionist provides granular project configuration using "projections".
What are projections?  Let's start with an example.

## Example

A while back I went and made a bunch of plugins for working with [rbenv][].
Here's what a couple of them look like:

    ~/.rbenv/plugins $ tree
    .
    ├── rbenv-ctags
    │   ├── bin
    │   │   └── rbenv-ctags
    │   └── etc
    │       └── rbenv.d
    │           └── install
    │               └── ctags.bash
    └── rbenv-sentience
        └── etc
            └── rbenv.d
                └── install
                    └── sentience.bash

As you can see, rbenv plugins have hooks in `etc/rbenv.d/` and commands in
`bin/` matching `rbenv-*`.  Here's a projectionist configuration for that
setup:

    let g:projectionist_heuristics = {
          \   "etc/rbenv.d/|bin/rbenv-*": {
          \     "bin/rbenv-*": {
          \        "type": "command",
          \        "template": ["#!/usr/bin/env bash"],
          \     },
          \     "etc/rbenv.d/*.bash": {"type": "hook"}
          \   }
          \ }

The key in the outermost dictionary says to activate for any directory
containing a subdirectory `etc/rbenv.d/` *or* files matching `bin/rbenv-*`.
The corresponding value contains projection definitions.  Here, two
projections are defined.  The first creates an `:Ecommand` navigation command
and provides boilerplate to pre-populate new files with, and the second
creates an `:Ehook` command.

[rails.vim]: https://github.com/tpope/vim-rails
[rbenv]: https://github.com/sstephenson/rbenv

## Features

See `:help projectionist` for the authoritative documentation.  Here are some
highlights.

### Global and per project projection definitions

In the above example, we used the global `g:projectionist_heuristics` to
declare projections based on requirements in the root directory.  If that's
not flexible enough, you can use the autocommand based API, or create a
`.projections.json` in the root of the project.

### Navigation commands

Navigation commands encapsulate editing filenames matching certain patterns.
Here are some examples for this very project:

    {
      "plugin/*.vim": {"type": "plugin"},
      "autoload/*.vim": {"type": "autoload"},
      "doc/*.txt": {"type": "doc"},
      "README.markdown": {"type": "doc"}
    }

With these in place, you could use `:Eplugin projectionist` to edit
`plugin/projectionist.vim` and `:Edoc projectionist` to edit
`doc/projectionist.txt`.  If no argument is given, it will edit an alternate
file of that type (see below) or a projection without a glob.  So in this
example `:Edoc` would default to editing `README.markdown`.

The `E` stands for `edit`.  You also get `S`, `V`, and `T` variants that
`split`, `vsplit`, and `tabedit`.

Tab complete is smart.  Not quite "fuzzy finder" smart but smart nonetheless.
(On that note, fuzzy finders are great, but I prefer the navigation command
approach when there are multiple categories of similarly named files.)

### Alternate files

Projectionist provides `:A`, `:AS`, `:AV`, and `:AT` to jump to an "alternate"
file, based on ye olde convention originally established in [a.vim][].  Here's
an example configuration for Maven that allows you to jump between the
implementation and test:

    {
      "src/main/java/*.java": {"alternate": "src/test/java/{}.java"},
      "src/test/java/*.java": {"alternate": "src/main/java/{}.java"}
    }

In addition, the navigation commands (like `:Eplugin` above) will search
alternates when no argument is given to edit a related file of that type.

Bonus feature: `:A {filename}` edits a file relative to the root of the
project.

[a.vim]: http://www.vim.org/scripts/script.php?script_id=31

### Buffer configuration

Check out these examples for a minimal Ruby project:

    {
      "*": {"make": "rake"},
      "spec/*_spec.rb": {"dispatch": "rspec {file}"}
    }

That second one sets the default for [dispatch.vim][].  Plugins can use
projections for their own configuration.

[dispatch.vim]: https://github.com/tpope/vim-dispatch

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/projectionist.git
    vim -u NONE -c "helptags projectionist/doc" -c q

## FAQ

> Why not a clearer filename like `.vim_projections.json`?

Nothing about the file is Vim specific.  See
[projectionist](https://github.com/glittershark/projectionist) for an example
of another tool that uses it.

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
./autoload/projectionist.vim	[[[1
946
" Location:     autoload/projectionist.vim
" Author:       Tim Pope <http://tpo.pe/>

if exists("g:autoloaded_projectionist")
  finish
endif
let g:autoloaded_projectionist = 1

" Section: Utility

function! s:sub(str, pat, repl) abort
  return substitute(a:str, '\v\C'.a:pat, a:repl, '')
endfunction

function! s:gsub(str, pat, repl) abort
  return substitute(a:str, '\v\C'.a:pat, a:repl, 'g')
endfunction

function! s:startswith(str, prefix) abort
  return strpart(a:str, 0, len(a:prefix)) ==# a:prefix
endfunction

function! s:endswith(str, suffix) abort
  return strpart(a:str, len(a:str) - len(a:suffix)) ==# a:suffix
endfunction

function! s:uniq(list) abort
  let i = 0
  let seen = {}
  while i < len(a:list)
    let str = string(a:list[i])
    if has_key(seen, str)
      call remove(a:list, i)
    else
      let seen[str] = 1
      let i += 1
    endif
  endwhile
  return a:list
endfunction

function! projectionist#lencmp(i1, i2) abort
  return len(a:i1) - len(a:i2)
endfunction

function! s:real(file) abort
  let pre = substitute(matchstr(a:file, '^\a\a\+\ze:'), '^.', '\u&', '')
  if empty(pre)
    let path = s:absolute(a:file, getcwd())
  elseif exists('*' . pre . 'Real')
    let path = {pre}Real(a:file)
  else
    let path = a:file
  endif
  return exists('+shellslash') && !&shellslash ? tr(path, '/', '\') : path
endfunction

function! projectionist#slash(...) abort
  let s = exists('+shellslash') && !&shellslash ? '\' : '/'
  return a:0 ? tr(a:1, '/', s) : s
endfunction

function! s:slash(str) abort
  return tr(a:str, projectionist#slash(), '/')
endfunction

function! projectionist#json_parse(string) abort
  let string = type(a:string) == type([]) ? join(a:string, ' ') : a:string
  if exists('*json_decode')
    try
      return json_decode(string)
    catch
    endtry
  else
    let [null, false, true] = ['', 0, 1]
    let stripped = substitute(string, '\C"\(\\.\|[^"\\]\)*"', '', 'g')
    if stripped !~# "[^,:{}\\[\\]0-9.\\-+Eaeflnr-u \n\r\t]"
      try
        return eval(substitute(string, "[\r\n]", ' ', 'g'))
      catch
      endtry
    endif
  endif
  throw "invalid JSON: ".string
endfunction

function! projectionist#shellescape(arg) abort
  return a:arg =~# "^[[:alnum:]_/.:-]\\+$" ? a:arg : shellescape(a:arg)
endfunction

function! projectionist#shellpath(arg) abort
  if empty(a:arg)
    return ''
  elseif a:arg =~# '^[[:alnum:].+-]\+:'
    return projectionist#shellescape(s:real(a:arg))
  else
    return projectionist#shellescape(a:arg)
  endif
endfunction

function! s:join(arg) abort
  if type(a:arg) == type([])
    return join(a:arg, ' ')
  elseif type(a:arg) == type('')
    return a:arg
  else
    return ''
  endif
endfunction

function! s:parse(mods, args) abort
  let flags = ''
  let pres = []
  let cmd = {'args': []}
  if a:mods ==# '' || a:mods ==# '<mods>'
    let cmd.mods = ''
  else
    let cmd.mods = a:mods . ' '
  endif
  let args = copy(a:args)
  while !empty(args)
    if args[0] =~# "^++mods="
      let cmd.mods .= args[0][8:-1] . ' '
    elseif args[0] =~# '^++'
      let flags .= ' ' . args[0]
    elseif args[0] =~# '^+.'
      call add(pres, args[0][1:-1])
    elseif args[0] !=# '+'
      call add(cmd.args, args[0])
    endif
    call remove(args, 0)
  endwhile

  let cmd.pre = flags . (empty(pres) ? '' : ' +'.escape(join(pres, '|'), '| '))
  return cmd
endfunction

function! s:fcall(fn, path, ...) abort
  return call(get(get(g:, 'io_' . matchstr(a:path, '^\a\a\+\ze:'), {}), a:fn, a:fn), [a:path] + a:000)
endfunction

function! s:mkdir_p(path) abort
  if a:path !~# '^\a[[:alnum:].+-]\+:' && !isdirectory(a:path)
    call mkdir(a:path, 'p')
  endif
endfunction

" Section: Querying

function! s:roots() abort
  return reverse(sort(keys(get(b:, 'projectionist', {})), function('projectionist#lencmp')))
endfunction

function! projectionist#path(...) abort
  let abs = '^[' . projectionist#slash() . '/]\|^\a\+:\|^\.\.\=\%(/\|$\)'
  if a:0 && s:slash(a:1) =~# abs || (a:0 > 1 && a:2 is# 0)
    return s:slash(a:1)
  endif
  if a:0 && type(a:1) ==# type(0)
    let root = get(s:roots(), (a:1 < 0 ? -a:1 : a:1) - 1, '')
    if a:0 > 1
      if a:2 =~# abs
        return a:2
      endif
      let file = a:2
    endif
  elseif a:0 > 1 && type(a:2) == type('')
    let root = substitute(s:slash(a:2), '/$', '', '')
    let file = a:1
    if empty(root)
      return file
    endif
  elseif a:0 == 1 && empty(a:1)
    return ''
  else
    let root = get(s:roots(), a:0 > 1 ? (a:2 < 0 ? -a:2 : a:2) - 1 : 0, '')
    if a:0
      let file = a:1
    endif
  endif
  if !empty(root) && exists('file')
    return root . '/' . file
  else
    return root
  endif
endfunction

function! s:path(path, ...) abort
  if a:0 || type(a:path) == type(0)
    return call('projectionist#path', [a:path] + a:000)
  else
    return a:path
  endif
endfunction

function! projectionist#filereadable(...) abort
  return s:fcall('filereadable', call('s:path', a:000))
endfunction

function! projectionist#isdirectory(...) abort
  return s:fcall('isdirectory', call('s:path', a:000))
endfunction

function! projectionist#getftime(...) abort
  return s:fcall('getftime', call('s:path', a:000))
endfunction

function! projectionist#readfile(path, ...) abort
  let args = copy(a:000)
  let path = a:path
  if get(args, 0, '') =~# '[\/.]' || type(get(args, 0, '')) == type(0) || type(path) == type(0)
    let path = projectionist#path(path, remove(args, 0))
  endif
  return call('s:fcall', ['readfile'] + [path] + args)
endfunction

function! projectionist#glob(file, ...) abort
  let root = ''
  if a:0
    let root = projectionist#path('', a:1)
  endif
  let path = s:absolute(a:file, root)
  let files = s:fcall('glob', path, a:0 > 1 ? a:2 : 0, 1)
  if len(root) || a:0 && a:1 is# 0
    call map(files, 's:slash(v:val) . (v:val !~# "[\/]$" && projectionist#isdirectory(v:val) ? "/" : "")')
  endif
  if len(root)
    call map(files, 'strpart(v:val, 0, len(root)) ==# root ? strpart(v:val, len(root)) : v:val')
  endif
  return files
endfunction

function! projectionist#real(...) abort
  return s:real(call('s:path', a:000))
endfunction

function! s:all() abort
  let all = []
  for key in s:roots()
    for value in b:projectionist[key]
      call add(all, [key, value])
    endfor
  endfor
  return all
endfunction

if !exists('g:projectionist_transformations')
  let g:projectionist_transformations = {}
endif

function! g:projectionist_transformations.dot(input, o) abort
  return substitute(a:input, '/', '.', 'g')
endfunction

function! g:projectionist_transformations.underscore(input, o) abort
  return substitute(a:input, '/', '_', 'g')
endfunction

function! g:projectionist_transformations.backslash(input, o) abort
  return substitute(a:input, '/', '\\', 'g')
endfunction

function! g:projectionist_transformations.colons(input, o) abort
  return substitute(a:input, '/', '::', 'g')
endfunction

function! g:projectionist_transformations.hyphenate(input, o) abort
  return tr(a:input, '_', '-')
endfunction

function! g:projectionist_transformations.blank(input, o) abort
  return tr(a:input, '_-', '  ')
endfunction

function! g:projectionist_transformations.uppercase(input, o) abort
  return toupper(a:input)
endfunction

function! g:projectionist_transformations.camelcase(input, o) abort
  return substitute(a:input, '[_-]\(.\)', '\u\1', 'g')
endfunction

function! g:projectionist_transformations.capitalize(input, o) abort
  return substitute(a:input, '\%(^\|/\)\zs\(.\)', '\u\1', 'g')
endfunction

function! g:projectionist_transformations.snakecase(input, o) abort
  let str = a:input
  let str = substitute(str, '\v(\u+)(\u\l)', '\1_\2', 'g')
  let str = substitute(str, '\v(\l|\d)(\u)', '\1_\2', 'g')
  let str = tolower(str)
  return str
endfunction

function! g:projectionist_transformations.dirname(input, o) abort
  return substitute(a:input, '.[^'.projectionist#slash().'/]*$', '', '')
endfunction

function! g:projectionist_transformations.basename(input, o) abort
  return substitute(a:input, '.*['.projectionist#slash().'/]', '', '')
endfunction

function! g:projectionist_transformations.singular(input, o) abort
  let input = a:input
  let input = s:sub(input, '%([Mm]ov|[aeio])@<!ies$', 'ys')
  let input = s:sub(input, '[rl]@<=ves$', 'fs')
  let input = s:sub(input, '%(nd|rt)@<=ices$', 'exs')
  let input = s:sub(input, 's@<!s$', '')
  let input = s:sub(input, '%([nrt]ch|tatus|lias|ss)@<=e$', '')
  return input
endfunction

function! g:projectionist_transformations.plural(input, o) abort
  let input = a:input
  let input = s:sub(input, '[aeio]@<!y$', 'ie')
  let input = s:sub(input, '[rl]@<=f$', 've')
  let input = s:sub(input, '%(nd|rt)@<=ex$', 'ice')
  let input = s:sub(input, '%([osxz]|[cs]h)$', '&e')
  let input .= 's'
  return input
endfunction

function! g:projectionist_transformations.open(input, o) abort
  return '{'
endfunction

function! g:projectionist_transformations.close(input, o) abort
  return '}'
endfunction

function! g:projectionist_transformations.nothing(input, o) abort
  return ''
endfunction

function! g:projectionist_transformations.vim(input, o) abort
  return a:input
endfunction

function! s:expand_placeholder(placeholder, expansions) abort
  let transforms = split(a:placeholder[1:-2], '|')
  if has_key(a:expansions, get(transforms, 0, '}'))
    let value = a:expansions[remove(transforms, 0)]
  else
    let value = get(a:expansions, 'match', "\030")
  endif
  for transform in transforms
    if !has_key(g:projectionist_transformations, transform)
      return "\030"
    endif
    let value = g:projectionist_transformations[transform](value, a:expansions)
    if value =~# "\030"
      return "\030"
    endif
  endfor
  if has_key(a:expansions, 'post_function')
    let value = call(a:expansions.post_function, [value])
  endif
  return value
endfunction

function! s:expand_placeholders(value, expansions, ...) abort
  if type(a:value) ==# type([]) || type(a:value) ==# type({})
    return filter(map(copy(a:value), 's:expand_placeholders(v:val, a:expansions, 1)'), 'type(v:val) !=# type("") || v:val !~# "[\001-\006\016-\037]"')
  endif
  let value = substitute(a:value, '{[^{}]*}', '\=s:expand_placeholder(submatch(0), a:expansions)', 'g')
  return !a:0 && value =~# "[\001-\006\016-\037]" ? '' : value
endfunction

let s:valid_key = '^\%([^*{}]*\*\*[^*{}]\{2\}\)\=[^*{}]*\*\=[^*{}]*$'

function! s:match(file, pattern) abort
  if a:pattern =~# '^[^*{}]*\*[^*{}]*$'
    let pattern = s:slash(substitute(a:pattern, '\*', '**/*', ''))
  elseif a:pattern =~# '^[^*{}]*\*\*[^*{}]\+\*[^*{}]*$'
    let pattern = s:slash(a:pattern)
  else
    return ''
  endif
  let [prefix, infix, suffix] = split(pattern, '\*\*\=', 1)
  let file = s:slash(a:file)
  if !s:startswith(file, prefix) || !s:endswith(file, suffix)
    return ''
  endif
  let match = file[strlen(prefix) : -strlen(suffix)-1]
  if infix ==# '/'
    return match
  endif
  let clean = substitute('/'.match, '\V'.infix.'\ze\[^/]\*\$', '/', '')[1:-1]
  return clean ==# match ? '' : clean
endfunction

function! projectionist#query_raw(key, ...) abort
  let candidates = []
  let file = a:0 ? a:1 : get(b:, 'projectionist_file', expand('%:p'))
  for [path, projections] in s:all()
    let pre = path . projectionist#slash()
    let attrs = {'project': path, 'file': file}
    let name = file[strlen(path)+1:-1]
    if strpart(file, 0, len(path)) !=# path
      let name = ''
    endif
    if has_key(projections, name) && has_key(projections[name], a:key)
      call add(candidates, [projections[name][a:key], attrs])
    endif
    for pattern in reverse(sort(filter(keys(projections), 'v:val =~# s:valid_key && v:val =~# "\\*"'), function('projectionist#lencmp')))
      let match = s:match(name, pattern)
      if (!empty(match) || pattern ==# '*') && has_key(projections[pattern], a:key)
        let expansions = extend({'match': match}, attrs)
        call add(candidates, [projections[pattern][a:key], expansions])
      endif
    endfor
  endfor
  return candidates
endfunction

function! projectionist#query(key, ...) abort
  let candidates = []
  let file = a:0 > 1 ? a:2 : get(a:0 ? a:1 : {}, 'file', get(b:, 'projectionist_file', expand('%:p')))
  for [value, expansions] in projectionist#query_raw(a:key, file)
    call extend(expansions, a:0 ? a:1 : {}, 'keep')
    call add(candidates, [expansions.project, s:expand_placeholders(value, expansions)])
    unlet value
  endfor
  return candidates
endfunction

function! s:absolute(path, in) abort
  if a:path =~# '^\%([[:alnum:].+-]\+:\)\|^\.\?[\/]\|^$'
    return a:path
  else
    return substitute(a:in, '[\/]$', '', '') . projectionist#slash() . a:path
  endif
endfunction

function! projectionist#query_file(key, ...) abort
  let files = []
  let _ = {}
  for [root, _.match] in projectionist#query(a:key, a:0 ? a:1 : {})
    call extend(files, map(filter(type(_.match) == type([]) ? copy(_.match) : [_.match], 'len(v:val)'), 's:absolute(v:val, root)'))
  endfor
  return s:uniq(files)
endfunction

let s:projectionist_max_file_recursion = 3

function! s:query_file_recursive(key, ...) abort
  let keys = type(a:key) == type([]) ? a:key : [a:key]
  let start_file = get(a:0 ? a:1 : {}, 'file', get(b:, 'projectionist_file', expand('%:p')))
  let files = []
  let visited_files = {start_file : 1}
  let current_files = [start_file]
  let depth = 0
  while !empty(current_files) && depth < s:projectionist_max_file_recursion
    let next_files = []
    for file in current_files
      let query_opts = extend(a:0 ? copy(a:1) : {}, {'file': file})
      for key in keys
        let [root, match] = get(projectionist#query(key, query_opts), 0, ['', []])
        let subfiles = type(match) == type([]) ? copy(match) : [match]
        call map(filter(subfiles, 'len(v:val)'), 's:absolute(v:val, root)')
        if !empty(subfiles)
          break
        endif
      endfor
      for subfile in subfiles
        if !has_key(visited_files, subfile)
          let visited_files[subfile] = 1
          call add(files, subfile)
          call add(next_files, subfile)
        endif
      endfor
    endfor
    let current_files = next_files
    let depth += 1
  endwhile
  return files
endfunction

function! s:shelljoin(val) abort
  return substitute(s:join(a:val), '["'']\([{}]\)["'']', '\1', 'g')
endfunction

function! projectionist#query_exec(key, ...) abort
  let opts = extend({'post_function': 'projectionist#shellpath'}, a:0 ? a:1 : {})
  return filter(map(projectionist#query(a:key, opts), '[s:real(v:val[0]), s:shelljoin(v:val[1])]'), '!empty(v:val[0]) && !empty(v:val[1])')
endfunction

function! projectionist#query_scalar(key) abort
  let values = []
  for [root, match] in projectionist#query(a:key)
    if type(match) == type([])
      call extend(values, match)
    elseif type(match) !=# type({})
      call add(values, match)
    endif
    unlet match
  endfor
  return values
endfunction

function! s:query_exec_with_alternate(key) abort
  let values = projectionist#query_exec(a:key)
  for file in projectionist#query_file('alternate')
    for [root, match] in projectionist#query_exec(a:key, {'file': file})
      if filereadable(file)
        call add(values, [root, match])
      endif
      unlet match
    endfor
  endfor
  return values
endfunction

" Section: Activation

function! projectionist#append(root, ...) abort
  if type(a:root) != type('') || empty(a:root)
    return
  endif
  let projections = copy(get(a:000, -1, {}))
  if type(projections) == type('') && !empty(projections)
    try
      let l:.projections = projectionist#json_parse(projectionist#readfile(projections, a:root))
    catch
      let l:.projections = {}
    endtry
  endif
  if type(projections) == type({})
    let root = projectionist#slash(substitute(a:root, '.\zs[' . projectionist#slash() . '/]$', '', ''))
    if !has_key(b:projectionist, root)
      let b:projectionist[root] = []
    endif
    for [k, v] in items(filter(copy(projections), 'type(v:val) == type("")'))
      if (k =~# '\*') ==# (v =~# '\*') && has_key(projections, v)
        let projections[k] = projections[v]
      endif
    endfor
    call add(b:projectionist[root], filter(projections, 'type(v:val) == type({})'))
    return 1
  endif
endfunction

function! projectionist#define_navigation_command(command, patterns) abort
  for [prefix, excmd] in items(s:prefixes)
    execute 'command! -buffer -bar -bang -nargs=* -complete=customlist,s:projection_complete'
          \ prefix . substitute(a:command, '\A', '', 'g')
          \ ':execute s:open_projection("<mods>", "'.excmd.'<bang>",'.string(a:patterns).',<f-args>)'
  endfor
endfunction

function! projectionist#activate() abort
  if empty(b:projectionist)
    return
  endif
  if len(s:real(s:roots()[0]))
    command! -buffer -bar -bang -nargs=? -range=1 -complete=customlist,s:dir_complete Pcd
          \ exe 'cd' projectionist#real(projectionist#path(<count>) . '/' . <q-args>)
    command! -buffer -bar -bang -nargs=* -range=1 -complete=customlist,s:dir_complete Ptcd
          \ exe (<bang>0 ? 'cd' : 'tcd') projectionist#real(projectionist#path(<count>) . '/' . <q-args>)
    command! -buffer -bar -bang -nargs=* -range=1 -complete=customlist,s:dir_complete Plcd
          \ exe (<bang>0 ? 'cd' : 'lcd') projectionist#real(projectionist#path(<count>) . '/' . <q-args>)
    if exists(':Cd') != 2
      command! -buffer -bar -bang -nargs=? -range=1 -complete=customlist,s:dir_complete Cd
            \ exe 'cd' projectionist#real(projectionist#path(<count>) . '/' . <q-args>)
    endif
    if exists(':Tcd') != 2
      command! -buffer -bar -bang -nargs=? -range=1 -complete=customlist,s:dir_complete Tcd
            \ exe (<bang>0 ? 'cd' : 'tcd') projectionist#real(projectionist#path(<count>) . '/' . <q-args>)
    endif
    if exists(':Lcd') != 2
      command! -buffer -bar -bang -nargs=? -range=1 -complete=customlist,s:dir_complete Lcd
            \ echo (<bang>0 ? 'cd' : 'lcd') projectionist#real(projectionist#path(<count>) . '/' . <q-args>)
    endif
    command! -buffer -bang -nargs=1 -range=0 -complete=command ProjectDo
          \ exe s:do('<bang>', <count>==<line1>?<count>:-1, <q-args>)
  endif
  for [command, patterns] in items(projectionist#navigation_commands())
    call projectionist#define_navigation_command(command, patterns)
  endfor
  for [prefix, excmd] in items(s:prefixes) + [['', 'edit']]
    execute 'command! -buffer -bar -bang -nargs=* -range=-1 -complete=customlist,s:edit_complete'
          \ 'A'.prefix
          \ ':execute s:edit_command("<mods>", "'.excmd.'<bang>", <count>, <f-args>)'
  endfor

  for [root, makeprg] in projectionist#query_exec('make')
    unlet! b:current_compiler
    let compiler = fnamemodify(matchstr(makeprg, '\S\+'), ':t:r')
    setlocal errorformat=%+I%.%#,
    if exists(':Dispatch')
      silent! let compiler = dispatch#compiler_for_program(makeprg)
    endif
    if !empty(findfile('compiler/'.compiler.'.vim', escape(&rtp, ' ')))
      execute 'compiler' compiler
    elseif compiler ==# 'make'
      setlocal errorformat<
    endif
    let &l:makeprg = makeprg
    let &l:errorformat .= ',%\&chdir '.escape(root, ',')
    break
  endfor

  for [root, command] in projectionist#query_exec('console')
    let offset = index(s:roots(), root) + 1
    let b:start = '-dir=' . fnameescape(root) .
          \ ' -title=' . escape(fnamemodify(root, ':t'), '\ ') . '\ console ' .
          \ command
    execute 'command! -bar -bang -buffer -nargs=* Console ' .
          \ (has('patch-7.4.1898') ? '<mods> ' : '') .
          \ (exists(':Start') < 2 ?
          \ 'ProjectDo ' . (offset == 1 ? '' : offset.' ') . '!' . command :
          \ 'Start<bang> ' . b:start) . ' <args>'
    break
  endfor

  for [root, command] in projectionist#query_exec('start')
    let offset = index(s:roots(), root) + 1
    let b:start = '-dir=' . fnameescape(root) . ' ' . command
    break
  endfor

  for [root, command] in s:query_exec_with_alternate('dispatch')
    let b:dispatch = '-dir=' . fnameescape(root) . ' ' . command
    break
  endfor

  for dir in projectionist#query_file('path')
    let dir = substitute(dir, '^\a\a\+:', '+&', '')
    if stridx(','.&l:path.',', ','.escape(dir, ', ').',') < 0
      let &l:path = escape(dir, ', ') . ',' . &path
    endif
  endfor

  for root in s:roots()
    let tags = s:real(root . projectionist#slash() . 'tags')
    if len(tags) && stridx(','.&l:tags.',', ','.escape(tags, ', ').',') < 0
      let &l:tags = &tags . ',' . escape(tags, ', ')
    endif
  endfor

  if exists('#User#ProjectionistActivate')
    doautocmd User ProjectionistActivate
  endif
endfunction

" Section: Completion

function! projectionist#completion_filter(results, query, sep, ...) abort
  if a:query =~# '\*'
    let regex = s:gsub(a:query, '\*', '.*')
    return filter(copy(a:results),'v:val =~# "^".regex')
  endif

  let C = get(g:, 'projectionist_completion_filter', get(g:, 'completion_filter'))
  if type(C) == type({}) && has_key(C, 'Apply')
    let results = call(C.Apply, [a:results, a:query, a:sep, a:0 ? a:1 : {}], C)
  elseif type(C) == type('') && exists('*'.C)
    let results = call(C, [a:results, a:query, a:sep, a:0 ? a:1 : {}])
  endif
  if get(l:, 'results') isnot# 0
    return results
  endif
  unlet! results

  let results = s:uniq(sort(copy(a:results)))
  call filter(results,'v:val !~# "\\~$" && !empty(v:val)')
  let filtered = filter(copy(results),'v:val[0:strlen(a:query)-1] ==# a:query')
  if !empty(filtered) | return filtered | endif
  if !empty(a:sep)
    let regex = s:gsub(a:query,'[^'.a:sep.']','[&].*')
    let filtered = filter(copy(results),'v:val =~# "^".regex')
    if !empty(filtered) | return filtered | endif
    let filtered = filter(copy(results),'a:sep.v:val =~# ''['.a:sep.']''.regex')
    if !empty(filtered) | return filtered | endif
  endif
  let regex = s:gsub(a:query,'.','[&].*')
  let filtered = filter(copy(results),'v:val =~# regex')
  return filtered
endfunction

function! s:dir_complete(lead, cmdline, _) abort
  let pattern = substitute(a:lead, '^\@!\%(^\a\+:/*\)\@<!\%(^\.\.\=\)\@<!/', '*&', 'g') . '*/'
  let c = matchstr(a:cmdline, '^\d\+')
  let matches = projectionist#glob(pattern, projectionist#real(c ? c : 1))
  return map(matches, 'fnameescape(v:val)')
endfunction

" Section: Navigation commands

let s:prefixes = {
      \ 'E': 'edit',
      \ 'S': 'split',
      \ 'V': 'vsplit',
      \ 'T': 'tabedit',
      \ 'O': 'drop',
      \ 'D': 'read'}

function! projectionist#navigation_commands() abort
  let commands = {}
  for [path, projections] in s:all()
    for [pattern, projection] in items(projections)
      let name = s:gsub(get(projection, 'command', get(projection, 'type', get(projection, 'name', ''))), '\A', '')
      if !empty(name) && pattern =~# s:valid_key
        if !has_key(commands, name)
          let commands[name] = []
        endif
        let command = [path, pattern]
        call add(commands[name], command)
      endif
    endfor
  endfor
  call filter(commands, '!empty(v:val)')
  return commands
endfunction

function! s:find_related_file(patterns) abort
  let alternates = s:query_file_recursive(['related', 'alternate'], {'lnum': 0})
  for alternate in alternates
    for pattern in a:patterns
      if !empty(s:match(alternate, pattern))
        return alternate
      endif
    endfor
  endfor
  let current_file = get(b:, 'projectionist_file', expand('%:p'))
  for pattern in a:patterns
    if pattern !~# '\*'
      continue
    endif
    for candidate in projectionist#glob(pattern)
      let candidate_alternates = s:query_file_recursive(
            \ ['related', 'alternate'],
            \ {'lnum': 0, 'file': candidate})
      for candidate_alternate in candidate_alternates
        if candidate_alternate ==# current_file
          return candidate
        endif
        for alternate in alternates
          if alternate ==# candidate_alternate
            return candidate
          endif
        endfor
      endfor
    endfor
  endfor
endfunction

function! s:open_projection(mods, edit, variants, ...) abort
  let formats = []
  for variant in a:variants
    call add(formats, variant[0] . projectionist#slash() . (variant[1] =~# '\*\*'
          \ ? variant[1] : substitute(variant[1], '\*', '**/*', '')))
  endfor
  let cmd = s:parse(a:mods, a:000)
  if get(cmd.args, -1, '') ==# '`=`'
    let s:last_formats = formats
    return ''
  endif
  if len(cmd.args)
    call filter(formats, 'v:val =~# "\\*"')
    let name = join(cmd.args, ' ')
    let dir = matchstr(name, '.*\ze/')
    let base = matchstr(name, '[^\/]*$')
    call map(formats, 'substitute(substitute(v:val, "\\*\\*\\([\\/]\\=\\)", empty(dir) ? "" : dir . "\\1", ""), "\\*", base, "")')
  else
    let related_file = s:find_related_file(formats)
    if !empty(related_file)
      let formats = [related_file]
    else
      call filter(formats, 'v:val !~# "\\*"')
    endif
  endif
  if empty(formats)
    return 'echoerr "Invalid number of arguments"'
  endif
  let target = formats[0]
  for format in formats
    if projectionist#filereadable(format)
      let target = format
      break
    endif
  endfor
  call s:mkdir_p(fnamemodify(target, ':h'))
  return cmd.mods . a:edit . cmd.pre . ' ' .
        \ fnameescape(fnamemodify(target, ':~:.'))
endfunction

function! s:projection_complete(lead, cmdline, _) abort
  execute matchstr(a:cmdline, '\a\@<![' . join(keys(s:prefixes), '') . ']\w\+') . ' `=`'
  let results = []
  for format in s:last_formats
    if format !~# '\*'
      continue
    endif
    let glob = substitute(format, '[^\/]*\ze\*\*[\/]\*', '', 'g')
    let results += map(projectionist#glob(glob), 's:match(v:val, format)')
  endfor
  call s:uniq(results)
  return map(projectionist#completion_filter(results, a:lead, '/'), 'fnameescape(v:val)')
endfunction

" Section: :A

function! s:jumpopt(file) abort
  let pattern = '!$\|:\d\+:\d\+$\|[:@#]\d\+$\|[@#].*$'
  let file = substitute(a:file, pattern, '', '')
  let jump = matchstr(a:file, pattern)
  if jump =~# '^:\d\+:\d\+$'
    return [file, '+call\ cursor('.tr(jump[1:-1], ':', ',') . ') ']
  elseif jump =~# '^[:+@#]\d\+$'
    return [file, '+'.jump[1:-1].' ']
  elseif jump ==# '!'
    return [file, '+AD ']
  elseif !empty(jump)
    return [file, '+A'.escape(jump, ' ').' ']
  else
    return [file, '']
  endif
endfunction

function! s:edit_command(mods, edit, count, ...) abort
  let cmd = s:parse(a:mods, a:000)
  let file = join(cmd.args, ' ')
  if len(file)
    if file =~# '^[@#+]'
      return 'echoerr ":A: @/#/+ not supported"'
    endif
    let open = s:jumpopt(projectionist#path(file, a:count < 1 ? 1 : a:count))
    if empty(open[0])
      return 'echoerr "Invalid count"'
    endif
  elseif a:edit =~# 'read'
    call projectionist#apply_template()
    return ''
  else
    let expansions = {}
    if a:count > 0
      let expansions.lnum = a:count
    endif
    let alternates = projectionist#query_file('alternate', expansions)
    let warning = get(filter(copy(alternates), 'v:val =~# "replace %.*}"'), 0, '')
    if !empty(warning)
      return 'echoerr '.string(matchstr(warning, 'replace %.*}').' in alternate projection')
    endif
    call map(alternates, 's:jumpopt(v:val)')
    let open = get(filter(copy(alternates), 'projectionist#getftime(v:val[0]) >= 0'), 0, [])
    if empty(alternates)
      return 'echoerr "No alternate file"'
    elseif empty(open)
      let choices = ['Create alternate file?']
      let i = 0
      for [alt, _] in alternates
        let i += 1
        call add(choices, i.' '.alt)
      endfor
      let i = inputlist(choices)
      if i > 0
        let open = get(alternates, i-1, [])
      endif
      if empty(open)
        return ''
      endif
    endif
  endif
  let [file, jump] = open
  call s:mkdir_p(fnamemodify(file, ':h'))
  return cmd.mods . a:edit . cmd.pre . ' ' .
        \ jump . fnameescape(fnamemodify(file, ':~:.'))
endfunction

function! s:edit_complete(lead, cmdline, _) abort
  let pattern = substitute(a:lead, '^\@!\%(^\a\+:/*\)\@<!\%(^\.\.\=\)\@<!/', '*&', 'g') . '*'
  let c = matchstr(a:cmdline, '^\d\+')
  let matches = projectionist#glob(pattern, c ? c : 1)
  return map(matches, 'fnameescape(v:val)')
endfunction

" Section: :ProjectDo

function! s:do(bang, count, cmd) abort
  let cd = haslocaldir() ? 'lcd' : exists(':tcd') && haslocaldir(-1) ? 'tcd' : 'cd'
  let cwd = getcwd()
  let cmd = substitute(a:cmd, '^\d\+ ', '', '')
  let offset = cmd ==# a:cmd ? 1 : matchstr(a:cmd, '^\d\+')
  try
    execute cd fnameescape(projectionist#real('', offset))
    execute (a:count >= 0 ? a:count : '').substitute(cmd, '\>', a:bang, '')
  catch
    return 'echoerr '.string(v:exception)
  finally
    execute cd fnameescape(cwd)
  endtry
  return ''
endfunction

" Section: Make

function! s:qf_pre() abort
  let dir = substitute(matchstr(','.&l:errorformat, ',\%(%\\&\)\=\%(ch\)\=dir[ =]\zs\%(\\.\|[^,]\)*'), '\\,' ,',', 'g')
  let cwd = getcwd()
  if !empty(dir) && dir !=# cwd
    let cd = haslocaldir() ? 'lcd' : exists(':tcd') && haslocaldir(-1) ? 'tcd' : 'cd'
    execute cd fnameescape(dir)
    let s:qf_post = cd . ' ' . fnameescape(cwd)
  endif
endfunction

augroup projectionist_make
  autocmd!
  autocmd QuickFixCmdPre  *make* call s:qf_pre()
  autocmd QuickFixCmdPost *make*
        \ if exists('s:qf_post') | execute remove(s:, 'qf_post') | endif
augroup END

" Section: Templates

function! projectionist#apply_template() abort
  if !&modifiable
    return ''
  endif
  let template = get(projectionist#query('template'), 0, ['', ''])[1]
  if type(template) == type([]) && type(get(template, 0)) == type([])
    let template = template[0]
  endif
  if type(template) == type([])
    let l:.template = join(template, "\n")
  endif
  if !empty(template)
    silent %delete_
    if template =~# '\t' && !exists('b:sleuth') && exists(':Sleuth') == 2
      silent! Sleuth!
    endif
    if exists('#User#ProjectionistApplyTemplatePre')
      doautocmd <nomodeline> User ProjectionistApplyTemplatePre
    endif
    if &et
      let template = s:gsub(template, '\t', repeat(' ', &sw ? &sw : &ts))
    endif
    call setline(1, split(template, "\n"))
    if exists('#User#ProjectionistApplyTemplate')
      doautocmd <nomodeline> User ProjectionistApplyTemplate
    endif
    doautocmd BufReadPost
  endif
  return ''
endfunction
./doc/projectionist.txt	[[[1
218
*projectionist.txt* *projectionist* Project configuration

Author:  Tim Pope <http://tpo.pe/>
Repo:    https://github.com/tpope/vim-projectionist
License: Same terms as Vim itself (see |license|)

SETUP                                           *projectionist-setup*

Projections are maps from file names and globs to sets of properties
describing the file.  The simplest way to define them is to create a
".projections.json" in the root of the project.  Here's a simple example for a
Maven project:
>
    {
      "src/main/java/*.java": {
        "alternate": "src/test/java/{}.java",
        "type": "source"
      },
      "src/test/java/*.java": {
        "alternate": "src/main/java/{}.java",
        "type": "test"
      },
      "*.java": {"dispatch": "javac {file}"},
      "*": {"make": "mvn"}
    }
<
In property values, "{}" will be replaced by the portion of the glob matched
by the "*".  You can also chain one or more transformations inside the braces
separated by bars, e.g. "{dot|hyphenate}".  The complete list of available
transformations is as follows:

Name            Behavior ~
dot             / to .
underscore      / to _
backslash       / to \
colons          / to ::
hyphenate       _ to -
blank           _ and - to space
uppercase       uppercase
camelcase       foo_bar/baz_quux to fooBar/bazQuux
snakecase       FooBar/bazQuux to foo_bar/baz_quux
capitalize      capitalize first letter and each letter after a slash
dirname         remove last slash separated component
basename        remove all but last slash separated component
singular        singularize
plural          pluralize
file            absolute path to file
project         absolute path to project
open            literal {
close           literal }
nothing         empty string
vim             no-op (include to specify other implementations should ignore)

From a globbing perspective, "*" is actually a stand in for "**/*".  For
advanced cases, you can include both globs explicitly: "test/**/test_*.rb".
When expanding with {}, the ** and * portions are joined with a slash.  If
necessary, the dirname and basename expansions can be used to split the value
back apart.

The full list of available properties in a projection is as follows:

						*projectionist-alternate*
"alternate" ~
        Determines the destination of the |projectionist-:A| command.  If this
        is a list, the first readable file will be used.  Will also be used as
        a default for |projectionist-related|.
						*projectionist-console*
"console" ~
        Command to run to start a REPL or other interactive shell.  Will be
        defined as :Console.  This is useful to set from a "*" projection or
        on a simple file glob like "*.js".  Will also be used as a default for
        "start".  Expansions are shell escaped.
						*projectionist-dispatch*
"dispatch" ~
        Default task to use for |:Dispatch| in dispatch.vim.  If not provided,
        the option for any existing alternate file is used instead.
        Expansions are shell escaped.
						*projectionist-make*
"make" ~
        Sets 'makeprg'.  Also loads a |:compiler| plugin if one is available
        matching the executable name.  This is useful to set from a "*"
        projection.  Expansions are shell escaped.
						*projectionist-path*
"path" ~
        Additional directories to prepend to 'path'.  Can be relative to the
        project root or absolute.  This is useful to set on a simple file glob
        like "*.js".
						*projectionist-related*
"related" ~
        Indicates one or more files to search when a navigation command is
        called without an argument, to find a default destination.  Related
        files are searched recursively.
						*projectionist-start*
"start" ~
        Command to run to "boot" the project.  Examples include `lein run`,
        `rails server`, and `foreman start`.  It will be used as a default
        task for |:Start| in dispatch.vim.  This is useful to set from a "*"
        projection.  Expansions are shell escaped.
						*projectionist-template*
"template" ~
        Array of lines to use when creating a new file.
						*projectionist-type*
"type" ~
        Declares the type of file and create a set of navigation commands for
        opening files that match the glob.  If this option is provided for a
        literal filename rather than a glob, it is used as the default
        destination of the navigation command when no argument is given.  For
        a "type" value of "foo", the following navigation commands will be
        provided:
        `:Efoo`: delegates to |:edit|
        `:Sfoo`: delegates to |:split|
        `:Vfoo`: delegates to |:vsplit|
        `:Tfoo`: delegates to |:tabedit|
        `:Dfoo`: delegates to |:read|
        `:Ofoo`: delegates to |:drop|

                                                *g:projectionist_heuristics*
In addition to ".projections.json", projections can be defined globally
through use of the |projectionist-autocmds| API or through the variable
g:projectionist_heuristics, a |Dictionary| mapping between a string describing
the root of the project and a set of projections.  The keys of the dictionary
are files and directories that can be found in the root of a project, with &
separating multiple requirements and | separating multiple alternatives.  You
can also prefix a file or directory with ! to forbid rather than require its
presence.

In the example below, the first key requires a directory named
lib/heroku/ and a file named init.rb, and the second requires a directory
named etc/rbenv.d/ or one or more files matching the glob bin/rbenv-*.
>
    let g:projectionist_heuristics = {
          \ "lib/heroku/&init.rb": {
          \   "lib/heroku/command/*.rb": {"type": "command"}
          \ },
          \ "etc/rbenv.d/|bin/rbenv-*": {
          \   "bin/rbenv-*": {"type": "command"},
          \   "etc/rbenv.d/*.bash": {"type": "hook"}
          \ }}

Note the use of VimScript |line-continuation|.

COMMANDS                                        *projectionist-commands*

In addition to any navigation commands provided by your projections (see
|projectionist-type|), the following commands are available.

                                                *projectionist-:A*
:A                      Edit the alternate file for the current buffer, as
                        defined by the "alternate" key.

:A {file}               Edit {file} relative to the innermost root.
                                                *projectionist-:AS*
:AS [file]              Like :A, but open in a split.
                                                *projectionist-:AV*
:AV [file]              Like :A, but open in a vertical split.
                                                *projectionist-:AT*
:AT [file]              Like :A, but open in a tab.
                                                *projectionist-:AO*
:AO [file]              Like :A, but open using |:drop|.

                                                *projectionist-:AD*
:AD                     Replace the contents of the buffer with the new file
                        template.

:AD {file}              Like :A, but |:read| the file into the current buffer.

                                                *projectionist-:Pcd*
                                                *projectionist-:Cd*
:Pcd                     |:cd| to the innermost root.

:Pcd {path}              |:cd| to {path} in the innermost root.

                                                *projectionist-:Plcd*
                                                *projectionist-:Lcd*
:Plcd [path]             Like :Pcd, but use |:lcd|.

                                                *projectionist-:Ptcd*
                                                *projectionist-:Tcd*
:Ptcd [path]             Like :Pcd, but use |:tcd|.

                                                *projectionist-:ProjectDo*
:ProjectDo {cmd}        Change directory to the project root, execute the
                        given command, and change back.  This won't work if
                        {cmd} leaves the focus in a different window.  Tab
                        complete will erroneously reflect the current working
                        directory, not the project root.

AUTOCOMMANDS                                    *projectionist-autocmds*

Projectionist.vim dispatches a |User| *ProjectionistDetect* event when
searching for projections for a buffer.  You can call *projectionist#append()*
to register projections for the file found in *g:projectionist_file* .
>
    autocmd User ProjectionistDetect
          \ if SomeCondition(g:projectionist_file) |
          \   call projectionist#append(root, projections) |
          \ endif
<
The |User| *ProjectionistActivate* event is triggered when one or more sets of
projections are found.  You can call *projectionist#query()* to retrieve an
array of pairs of project roots and values for a given key.  Since typically
you only care about the first (most precisely targeted) value, the following
pattern may prove useful:
>
    autocmd User ProjectionistActivate call s:activate()

    function! s:activate() abort
      for [root, value] in projectionist#query('wrap')
        let &l:textwidth = value
        break
      endfor
    endfunction
<
You can also call *projectionist#path()* to get the root of the innermost set
of projections, which is useful for implementing commands like
|projectionist-:Pcd|.

 vim:tw=78:et:ft=help:norl:
./plugin/projectionist.vim	[[[1
172
" Location:     plugin/projectionist.vim
" Author:       Tim Pope <http://tpo.pe/>
" Version:      1.3
" GetLatestVimScripts: 4989 1 :AutoInstall: projectionist.vim

if exists("g:loaded_projectionist") || v:version < 704 || &cp
  finish
endif
let g:loaded_projectionist = 1

" ProjectionistHas('Gemfile&lib/|*.gemspec', '/path/to/root')
function! ProjectionistHas(req, ...) abort
  if type(a:req) != type('')
    return
  endif
  let ns = matchstr(a:0 ? a:1 : a:req, '^\a\a\+\ze:')
  if !a:0
    return s:nscall(ns, a:req =~# '[\/]$' ? 'isdirectory' : 'filereadable', a:req)
  endif
  for test in split(a:req, '|')
    if s:has(ns, a:1, test)
      return 1
    endif
  endfor
endfunction

let s:slash = exists('+shellslash') ? '\' : '/'

if !exists('g:projectionist_heuristics')
  let g:projectionist_heuristics = {}
endif

function! s:nscall(ns, fn, path, ...) abort
  if !get(g:, 'projectionist_ignore_' . a:ns)
    return call(get(get(g:, 'io_' . a:ns, {}), a:fn, a:fn), [a:path] + a:000)
  else
    return call(a:fn, [a:path] + a:000)
  endif
endfunction

function! s:has(ns, root, requirements) abort
  if empty(a:requirements)
    return 0
  endif
  for test in split(a:requirements, '&')
    let relative = '/' . matchstr(test, '[^!].*')
    if relative =~# '\*'
      let found = !empty(s:nscall(a:ns, 'glob', escape(a:root, '[?*') . relative))
    elseif relative =~# '/$'
      let found = s:nscall(a:ns, 'isdirectory', a:root . relative)
    else
      let found = s:nscall(a:ns, 'filereadable', a:root . relative)
    endif
    if test =~# '^!' ? found : !found
      return 0
    endif
  endfor
  return 1
endfunction

function! s:IsAbs(path) abort
  return tr(a:path, s:slash, '/') =~# '^/\|^\a\+:'
endfunction

function! s:Detect(...) abort
  let b:projectionist = {}
  unlet! b:projectionist_file
  if a:0
    let file = a:1
  elseif &l:buftype =~# '^\%(nowrite\)\=$' && len(@%) || &l:buftype =~# '^\%(nofile\|acwrite\)' && s:IsAbs(@%)
    let file = @%
  else
    return
  endif
  if !s:IsAbs(file)
    let s = exists('+shellslash') && !&shellslash ? '\' : '/'
    let file = substitute(getcwd(), '\' . s . '\=$', s, '') . file
  endif
  let file = substitute(file, '[' . s:slash . '/]$', '', '')

  try
    if exists('*ExcludeBufferFromDiscovery') && ExcludeBufferFromDiscovery(file, 'projectionist')
      return
    endif
  catch
  endtry
  let ns = matchstr(file, '^\a\a\+\ze:')
  if empty(ns)
    let file = resolve(file)
  elseif get(g:, 'projectionist_ignore_' . ns)
    return
  endif
  let root = file
  if empty(ns) && !isdirectory(root)
    let root = fnamemodify(root, ':h')
  endif
  let previous = ""
  while root !=# previous && root !~# '^\.\=$\|^[\/][\/][^\/]*$'
    if s:nscall(ns, 'filereadable', root . '/.projections.json')
      try
        let value = projectionist#json_parse(projectionist#readfile(root . '/.projections.json'))
        call projectionist#append(root, value)
      catch /^invalid JSON:/
      endtry
    endif
    for [key, value] in items(g:projectionist_heuristics)
      for test in split(key, '|')
        if s:has(ns, root, test)
          call projectionist#append(root, value)
          break
        endif
      endfor
    endfor
    let previous = root
    let root = fnamemodify(root, ':h')
  endwhile

  if exists('#User#ProjectionistDetect')
    try
      let g:projectionist_file = file
      doautocmd <nomodeline> User ProjectionistDetect
    finally
      unlet! g:projectionist_file
    endtry
  endif

  if !empty(b:projectionist)
    let b:projectionist_file = file
    call projectionist#activate()
  endif
endfunction

if !exists('g:did_load_ftplugin')
  filetype plugin on
endif

augroup projectionist
  autocmd!
  autocmd FileType *
        \ if &filetype !=# 'netrw' |
        \   call s:Detect() |
        \ elseif !exists('b:projectionist') |
        \   call s:Detect(get(b:, 'netrw_curdir', @%)) |
        \ endif
  autocmd BufFilePost *
        \ if type(getbufvar(+expand('<abuf>'), 'projectionist')) == type({}) |
        \   call s:Detect(expand('<afile>')) |
        \ endif
  autocmd BufNewFile,BufReadPost *
        \ if empty(&filetype) |
        \   call s:Detect() |
        \ endif
  autocmd CmdWinEnter *
        \ if !empty(getbufvar('#', 'projectionist_file')) |
        \   let b:projectionist_file = getbufvar('#', 'projectionist_file') |
        \   let b:projectionist = getbufvar('#', 'projectionist') |
        \   call projectionist#activate() |
        \ endif
  autocmd User NERDTreeInit,NERDTreeNewRoot
        \ if exists('b:NERDTree.root.path.str') |
        \   call s:Detect(b:NERDTree.root.path.str()) |
        \ endif
  autocmd VimEnter *
        \ if get(g:, 'projectionist_vim_enter', 1) && argc() == 0 |
        \   call s:Detect(getcwd()) |
        \ endif
  autocmd BufWritePost .projections.json call s:Detect(expand('<afile>'))
  autocmd BufNewFile *
        \ if !empty(get(b:, 'projectionist')) |
        \   call projectionist#apply_template() |
        \ endif
augroup END
