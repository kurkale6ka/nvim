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
146
# abolish.vim

I sat on this plugin for 3 years before releasing it, primarily
because it's so gosh darn hard to explain.  It's three superficially
unrelated plugins in one that share a common theme: working with
variants of a word.

## Abbreviation

I know how to spell "separate".  I know how to spell "desperate".  My
fingers, however, have trouble distinguishing between the two, and I
invariably have a 50 percent chance of typing "seperate" or "desparate"
each time one of these comes up.  At first, I tried abbreviations:

    :iabbrev  seperate  separate
    :iabbrev desparate desperate

But this falls short at the beginning of a sentence.

    :iabbrev  Seperate  Separate
    :iabbrev Desparate Desperate

To be really thorough, we need uppercase too!

    :iabbrev  SEPERATE  SEPARATE
    :iabbrev DESPARATE DESPERATE

Oh, but consider the noun form, and the adverb form!

    :iabbrev  seperation  separation
    :iabbrev desparation desperation
    :iabbrev  seperately  separately
    :iabbrev desparately desperately
    :iabbrev  Seperation  separation
    :iabbrev Desparation Desperation
    :iabbrev  Seperately  Separately
    :iabbrev Desparately Desperately
    :iabbrev  SEPERATION  SEPARATION
    :iabbrev DESPARATION DESPERATION
    :iabbrev  SEPERATELY  SEPARATELY
    :iabbrev DESPARATELY DESPERATELY

Wait, there's also "separates", "separated", "separating",
"separations", "separator"...

Abolish.vim provides a simpler way.  The following one command produces
48 abbreviations including all of the above.

    :Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}

My current configuration has 25 Abolish commands that create hundreds of
corrections my fingers refuse to learn.

## Substitution

One time I had an application with a domain model called
"facility" that needed to be renamed to "building". So, a simple
search and replace, right?

    :%s/facility/building/g

Oh, but the case variants!

    :%s/Facility/Building/g
    :%s/FACILITY/BUILDING/g

Wait, the plural is more than "s" so we need to get that too!

    :%s/facilities/buildings/g
    :%s/Facilities/Buildings/g
    :%s/FACILITIES/BUILDINGS/g

Abolish.vim has your back.  One command to do all six, and you can
repeat it with `&` too!

    :%Subvert/facilit{y,ies}/building{,s}/g

From a conceptual level, one way to think about how this substitution
works is to imagine that in the braces you are declaring the
requirements for turning that word from singular to plural.  In
the facility example, the same base letters in both the singular
and plural form of the word are `facilit` To turn "facility" to a
plural word you must change the `y` to `ies` so you specify
`{y,ies}` in the braces.

To convert the word "building" from singular to plural, again
look at the common letters between the singular and plural forms:
`building`.  In this case you do not need to remove any letter
from building to turn it into plural form and you need to
add an `s` so the braces should be `{,s}`.

A few more examples:

Address to Reference

    :Subvert/address{,es}/reference{,s}/g

Blog to Post (you can just do this with a regular :s also)

    :Subvert/blog{,s}/post{,s}/g

Child to Adult

    :Subvert/child{,ren}/adult{,s}/g

Be amazed as it correctly turns the word children into the word adults!

Die to Spinner

    :Subvert/di{e,ce}/spinner{,s}/g

You can abbreviate it as `:S`, and it accepts the full range of flags
including things like `c` (confirm).

There's also a variant for searching and a variant for grepping.

## Coercion

Want to turn `fooBar` into `foo_bar`?  Press `crs` (coerce to
snake\_case).  MixedCase (`crm`), camelCase (`crc`), UPPER\_CASE
(`cru`), dash-case (`cr-`), and dot.case (`cr.`) are all just 3
keystrokes away.

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/abolish.git
    vim -u NONE -c "helptags abolish/doc" -c q

## Self-Promotion

Like abolish.vim? Follow the repository on
[GitHub](https://github.com/tpope/vim-abolish) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=1545).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

## License

Copyright (c) Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
./doc/abolish.txt	[[[1
180
*abolish.txt*  Language friendly searches, substitutions, and abbreviations

Author:  Tim Pope <http://tpo.pe/>
License: Same terms as Vim itself (see |license|)

This plugin is only available if 'compatible' is not set.

INTRODUCTION                                    *abolish* *:Abolish* *:Subvert*

Abolish lets you quickly find, substitute, and abbreviate several variations
of a word at once.  By default, three case variants (foo, Foo, and FOO) are
operated on by every command.

Two commands are provided.  :Abolish is the most general interface.
:Subvert provides an alternative, more concise syntax for searching and
substituting.
>
	:Abolish [options] {abbreviation} {replacement}
	:Abolish -delete [options] {abbreviation}

	:Abolish -search [options] {pattern}
	:Subvert/{pattern}[/flags]
	:Abolish!-search [options] {pattern}
	:Subvert?{pattern}[?flags]

	:Abolish -search [options] {pattern} {grep-arguments}
	:Subvert /{pattern}/[flags] {grep-options}
	:Abolish!-search [options] {pattern} {grep-arguments}
	:Subvert!/{pattern}/[flags] {grep-options}

	:[range]Abolish -substitute [options] {pattern} {replacement}
	:[range]Subvert/{pattern}/{replacement}[/flags]
<
						*:S*
In addition to the :Subvert command, a :S synonym is provided if not
already defined.  This will be used in examples below.

PATTERNS					*abolish-patterns*

Patterns can include brace pairs that contain comma separated alternatives:

  box{,es} => box, boxes, Box, Boxes, BOX, BOXES

For commands with a replacement, corresponding brace pairs are used in both
halves.  If the replacement should be identical to the pattern, an empty
brace pair may be used.  If fewer replacements are given than were given in
the pattern, they are looped.  That is, {a,b} on the replacement side is the
same as {a,b,a,b,a,b,...} repeated indefinitely.

The following replaces several different misspellings of "necessary":
>
	:%S/{,un}nec{ce,ces,e}sar{y,ily}/{}nec{es}sar{}/g
<
ABBREVIATING					*abolish-abbrev*

By default :Abolish creates abbreviations, which replace words automatically
as you type.  This is good for words you frequently misspell, or as
shortcuts for longer words.  Since these are just Vim abbreviations, only
whole words will match.
>
	:Abolish anomol{y,ies} anomal{}
	:Abolish {,in}consistant{,ly} {}consistent{}
	:Abolish Tqbf The quick, brown fox jumps over the lazy dog
<
Accepts the following options:

 -buffer: buffer local
 -cmdline: work in command line in addition to insert mode

A good place to define abbreviations is "after/plugin/abolish.vim",
relative to ~\vimfiles on Windows and ~/.vim everywhere else.

With a bang (:Abolish!) the abbreviation is also appended to the file in
g:abolish_save_file.  The default is "after/plugin/abolish.vim", relative
to the install directory.

Abbreviations can be removed with :Abolish -delete:
>
	Abolish -delete -buffer -cmdline anomol{y,ies}
<
SEARCHING					*abolish-search*

The -search command does a search in a manner similar to / key.
search.  After searching, you can use |n| and |N| as you would with a normal
search.

The following will search for box, Box, and BOX:
>
	:Abolish -search box
<
When given a single word to operate on, :Subvert defaults to doing a
search as well:
>
	:S/box/
<
This one searches for box, boxes, boxed, boxing, Box, Boxes, Boxed, Boxing,
BOX, BOXES, BOXED, and BOXING:
>
	:S/box{,es,ed,ing}/
<
The following syntaxes search in reverse.
>
	:Abolish! -search box
	:S?box?
<
Flags can be given with the -flags= option to :Abolish, or by appending them
after the separator to :Subvert. The flags trigger the following behaviors:

 I: Disable case variations (box, Box, BOX)
 v: Match inside variable names (match my_box, myBox, but not mybox)
 w: Match whole words (like surrounding with \< and \>)

A |search-offset| may follow the flags.
>
	:Abolish -search -flags=avs+1 box
	:S?box{,es,ed,ing}?we
<
GREPPING					*abolish-grep*

Grepping works similar to searching, and is invoked when additional options
are given.  These options are passed directly to the :grep command.
>
	:Abolish -search box{,es}
	:S /box{,es}/ *
	:S /box/aw *.txt *.html
<
The slash delimiters must both be present if used with :Subvert.  They may
both be omitted if no flags are used.

Both an external grepprg and vimgrep (via grepprg=internal) are supported.
With an external grep, the "v" flag behaves less intelligently, due to the
lack of look ahead and look behind support in grep regexps.

SUBSTITUTING					*abolish-substitute*

Giving a range switches :Subvert into substitute mode.  This command will
change box -> bag, boxes -> bags, Box -> Bag, Boxes -> Bags, BOX -> BAG,
BOXES -> BAGS across the entire document:
>
	:%Abolish -substitute -flags=g box{,es} bag{,s}
	:%S/box{,es}/bag{,s}/g
<
The "c", "e", "g", and "n" flags can be used from the substitute command
|:s_flags|, along with the "a", "I", "v", and "w" flags from searching.

COERCION					*abolish-coercion* *cr*

Abolish's case mutating algorithms can be applied to the word under the cursor
using the cr mapping (mnemonic: CoeRce) followed by one of the following
characters:

  c:       camelCase
  p:       PascalCase
  m:       MixedCase (aka PascalCase)
  _:       snake_case
  s:       snake_case
  u:       SNAKE_UPPERCASE
  U:       SNAKE_UPPERCASE
  k:       kebab-case (not usually reversible; see |abolish-coercion-reversible|)
  -:       dash-case (aka kebab-case)
  .:       dot.case (not usually reversible; see |abolish-coercion-reversible|)

For example, cru on a lowercase word is a slightly easier to type equivalent
to gUiw.

COERCION REVERSIBILITY				*abolish-coercion-reversible*

Some separators, such as "-" and ".", are listed as "not usually reversible".
The reason is that these are not "keyword characters", so vim (and
abolish.vim) will treat them as breaking a word.

For example: "key_word" is a single keyword.  The dash-case version,
"key-word", is treated as two keywords, "key" and "word".

This behaviour is governed by the 'iskeyword' option.  If a separator appears
in 'iskeyword', the corresponding coercion will be reversible.  For instance,
dash-case is reversible in 'lisp' files, and dot-case is reversible in R
files.

 vim:tw=78:ts=8:ft=help:norl:
./plugin/abolish.vim	[[[1
634
" abolish.vim - Language friendly searches, substitutions, and abbreviations
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.2
" GetLatestVimScripts: 1545 1 :AutoInstall: abolish.vim

" Initialization {{{1

if exists("g:loaded_abolish") || &cp || v:version < 700
  finish
endif
let g:loaded_abolish = 1

if !exists("g:abolish_save_file")
  if isdirectory(expand("~/.vim"))
    let g:abolish_save_file = expand("~/.vim/after/plugin/abolish.vim")
  elseif isdirectory(expand("~/vimfiles")) || has("win32")
    let g:abolish_save_file = expand("~/vimfiles/after/plugin/abolish.vim")
  else
    let g:abolish_save_file = expand("~/.vim/after/plugin/abolish.vim")
  endif
endif

" }}}1
" Utility functions {{{1

function! s:function(name) abort
  return function(substitute(a:name,'^s:',matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_'),''))
endfunction

function! s:send(self,func,...)
  if type(a:func) == type('') || type(a:func) == type(0)
    let l:Func = get(a:self,a:func,'')
  else
    let l:Func = a:func
  endif
  let s = type(a:self) == type({}) ? a:self : {}
  if type(Func) == type(function('tr'))
    return call(Func,a:000,s)
  elseif type(Func) == type({}) && has_key(Func,'apply')
    return call(Func.apply,a:000,Func)
  elseif type(Func) == type({}) && has_key(Func,'call')
    return call(Func.call,a:000,s)
  elseif type(Func) == type('') && Func == '' && has_key(s,'function missing')
    return call('s:send',[s,'function missing',a:func] + a:000)
  else
    return Func
  endif
endfunction

let s:object = {}
function! s:object.clone(...)
  let sub = deepcopy(self)
  return a:0 ? extend(sub,a:1) : sub
endfunction

if !exists("g:Abolish")
  let Abolish = {}
endif
call extend(Abolish, s:object, 'force')
call extend(Abolish, {'Coercions': {}}, 'keep')

function! s:throw(msg)
  let v:errmsg = a:msg
  throw "Abolish: ".a:msg
endfunction

function! s:words()
  let words = []
  let lnum = line('w0')
  while lnum <= line('w$')
    let line = getline(lnum)
    let col = 0
    while match(line,'\<\k\k\+\>',col) != -1
      let words += [matchstr(line,'\<\k\k\+\>',col)]
      let col = matchend(line,'\<\k\k\+\>',col)
    endwhile
    let lnum += 1
  endwhile
  return words
endfunction

function! s:extractopts(list,opts)
  let i = 0
  while i < len(a:list)
    if a:list[i] =~ '^-[^=]' && has_key(a:opts,matchstr(a:list[i],'-\zs[^=]*'))
      let key   = matchstr(a:list[i],'-\zs[^=]*')
      let value = matchstr(a:list[i],'=\zs.*')
      if type(get(a:opts,key)) == type([])
        let a:opts[key] += [value]
      elseif type(get(a:opts,key)) == type(0)
        let a:opts[key] = 1
      else
        let a:opts[key] = value
      endif
    else
      let i += 1
      continue
    endif
    call remove(a:list,i)
  endwhile
  return a:opts
endfunction

" }}}1
" Dictionary creation {{{1

function! s:mixedcase(word)
  return substitute(s:camelcase(a:word),'^.','\u&','')
endfunction

function! s:camelcase(word)
  let word = substitute(a:word, '-', '_', 'g')
  if word !~# '_' && word =~# '\l'
    return substitute(word,'^.','\l&','')
  else
    return substitute(word,'\C\(_\)\=\(.\)','\=submatch(1)==""?tolower(submatch(2)) : toupper(submatch(2))','g')
  endif
endfunction

function! s:snakecase(word)
  let word = substitute(a:word,'::','/','g')
  let word = substitute(word,'\(\u\+\)\(\u\l\)','\1_\2','g')
  let word = substitute(word,'\(\l\|\d\)\(\u\)','\1_\2','g')
  let word = substitute(word,'[.-]','_','g')
  let word = tolower(word)
  return word
endfunction

function! s:uppercase(word)
  return toupper(s:snakecase(a:word))
endfunction

function! s:dashcase(word)
  return substitute(s:snakecase(a:word),'_','-','g')
endfunction

function! s:spacecase(word)
  return substitute(s:snakecase(a:word),'_',' ','g')
endfunction

function! s:dotcase(word)
  return substitute(s:snakecase(a:word),'_','.','g')
endfunction

call extend(Abolish, {
      \ 'camelcase':  s:function('s:camelcase'),
      \ 'mixedcase':  s:function('s:mixedcase'),
      \ 'snakecase':  s:function('s:snakecase'),
      \ 'uppercase':  s:function('s:uppercase'),
      \ 'dashcase':   s:function('s:dashcase'),
      \ 'dotcase':    s:function('s:dotcase'),
      \ 'spacecase':  s:function('s:spacecase'),
      \ }, 'keep')

function! s:create_dictionary(lhs,rhs,opts)
  let dictionary = {}
  let i = 0
  let expanded = s:expand_braces({a:lhs : a:rhs})
  for [lhs,rhs] in items(expanded)
    if get(a:opts,'case',1)
      let dictionary[s:mixedcase(lhs)] = s:mixedcase(rhs)
      let dictionary[tolower(lhs)] = tolower(rhs)
      let dictionary[toupper(lhs)] = toupper(rhs)
    endif
    let dictionary[lhs] = rhs
  endfor
  let i += 1
  return dictionary
endfunction

function! s:expand_braces(dict)
  let new_dict = {}
  for [key,val] in items(a:dict)
    if key =~ '{.*}'
      let redo = 1
      let [all,kbefore,kmiddle,kafter;crap] = matchlist(key,'\(.\{-\}\){\(.\{-\}\)}\(.*\)')
      let [all,vbefore,vmiddle,vafter;crap] = matchlist(val,'\(.\{-\}\){\(.\{-\}\)}\(.*\)') + ["","","",""]
      if all == ""
        let [vbefore,vmiddle,vafter] = [val, ",", ""]
      endif
      let targets      = split(kmiddle,',',1)
      let replacements = split(vmiddle,',',1)
      if replacements == [""]
        let replacements = targets
      endif
      for i in range(0,len(targets)-1)
        let new_dict[kbefore.targets[i].kafter] = vbefore.replacements[i%len(replacements)].vafter
      endfor
    else
      let new_dict[key] = val
    endif
  endfor
  if exists("redo")
    return s:expand_braces(new_dict)
  else
    return new_dict
  endif
endfunction

" }}}1
" Abolish Dispatcher {{{1

function! s:SubComplete(A,L,P)
  if a:A =~ '^[/?]\k\+$'
    let char = strpart(a:A,0,1)
    return join(map(s:words(),'char . v:val'),"\n")
  elseif a:A =~# '^\k\+$'
    return join(s:words(),"\n")
  endif
endfunction

function! s:Complete(A,L,P)
  " Vim bug: :Abolish -<Tab> calls this function with a:A equal to 0
  if a:A =~# '^[^/?-]' && type(a:A) != type(0)
    return join(s:words(),"\n")
  elseif a:L =~# '^\w\+\s\+\%(-\w*\)\=$'
    return "-search\n-substitute\n-delete\n-buffer\n-cmdline\n"
  elseif a:L =~# ' -\%(search\|substitute\)\>'
    return "-flags="
  else
    return "-buffer\n-cmdline"
  endif
endfunction

let s:commands = {}
let s:commands.abstract = s:object.clone()

function! s:commands.abstract.dispatch(bang,line1,line2,count,args)
  return self.clone().go(a:bang,a:line1,a:line2,a:count,a:args)
endfunction

function! s:commands.abstract.go(bang,line1,line2,count,args)
  let self.bang = a:bang
  let self.line1 = a:line1
  let self.line2 = a:line2
  let self.count = a:count
  return self.process(a:bang,a:line1,a:line2,a:count,a:args)
endfunction

function! s:dispatcher(bang,line1,line2,count,args)
  let i = 0
  let args = copy(a:args)
  let command = s:commands.abbrev
  while i < len(args)
    if args[i] =~# '^-\w\+$' && has_key(s:commands,matchstr(args[i],'-\zs.*'))
      let command = s:commands[matchstr(args[i],'-\zs.*')]
      call remove(args,i)
      break
    endif
    let i += 1
  endwhile
  try
    return command.dispatch(a:bang,a:line1,a:line2,a:count,args)
  catch /^Abolish: /
    echohl ErrorMsg
    echo   v:errmsg
    echohl NONE
    return ""
  endtry
endfunction

" }}}1
" Subvert Dispatcher {{{1

function! s:subvert_dispatcher(bang,line1,line2,count,args)
  try
    return s:parse_subvert(a:bang,a:line1,a:line2,a:count,a:args)
  catch /^Subvert: /
    echohl ErrorMsg
    echo   v:errmsg
    echohl NONE
    return ""
  endtry
endfunction

function! s:parse_subvert(bang,line1,line2,count,args)
  if a:args =~ '^\%(\w\|$\)'
    let args = (a:bang ? "!" : "").a:args
  else
    let args = a:args
  endif
  let separator = '\v((\\)@<!(\\\\)*\\)@<!' . matchstr(args,'^.')
  let split = split(args,separator,1)[1:]
  if a:count || split == [""]
    return s:parse_substitute(a:bang,a:line1,a:line2,a:count,split)
  elseif len(split) == 1
    return s:find_command(separator,"",split[0])
  elseif len(split) == 2 && split[1] =~# '^[A-Za-z]*n[A-Za-z]*$'
    return s:parse_substitute(a:bang,a:line1,a:line2,a:count,[split[0],"",split[1]])
  elseif len(split) == 2 && split[1] =~# '^[A-Za-z]*\%([+-]\d\+\)\=$'
    return s:find_command(separator,split[1],split[0])
  elseif len(split) >= 2 && split[1] =~# '^[A-Za-z]* '
    let flags = matchstr(split[1],'^[A-Za-z]*')
    let rest = matchstr(join(split[1:],separator),' \zs.*')
    return s:grep_command(rest,a:bang,flags,split[0])
  elseif len(split) >= 2 && separator == ' '
    return s:grep_command(join(split[1:],' '),a:bang,"",split[0])
  else
    return s:parse_substitute(a:bang,a:line1,a:line2,a:count,split)
  endif
endfunction

function! s:normalize_options(flags)
  if type(a:flags) == type({})
    let opts = a:flags
    let flags = get(a:flags,"flags","")
  else
    let opts = {}
    let flags = a:flags
  endif
  if flags =~# 'w'
    let opts.boundaries = 2
  elseif flags =~# 'v'
    let opts.boundaries = 1
  elseif !has_key(opts,'boundaries')
    let opts.boundaries = 0
  endif
  let opts.case = (flags !~# 'I' ? get(opts,'case',1) : 0)
  let opts.flags = substitute(flags,'\C[avIiw]','','g')
  return opts
endfunction

" }}}1
" Searching {{{1

function! s:subesc(pattern)
  return substitute(a:pattern,'[][\\/.*+?~%()&]','\\&','g')
endfunction

function! s:sort(a,b)
  if a:a ==? a:b
    return a:a == a:b ? 0 : a:a > a:b ? 1 : -1
  elseif strlen(a:a) == strlen(a:b)
    return a:a >? a:b ? 1 : -1
  else
    return strlen(a:a) < strlen(a:b) ? 1 : -1
  endif
endfunction

function! s:pattern(dict,boundaries)
  if a:boundaries == 2
    let a = '<'
    let b = '>'
  elseif a:boundaries
    let a = '%(<|_@<=|[[:lower:]]@<=[[:upper:]]@=)'
    let b =  '%(>|_@=|[[:lower:]]@<=[[:upper:]]@=)'
  else
    let a = ''
    let b = ''
  endif
  return '\v\C'.a.'%('.join(map(sort(keys(a:dict),function('s:sort')),'s:subesc(v:val)'),'|').')'.b
endfunction

function! s:egrep_pattern(dict,boundaries)
  if a:boundaries == 2
    let a = '\<'
    let b = '\>'
  elseif a:boundaries
    let a = '(\<\|_)'
    let b = '(\>\|_\|[[:upper:]][[:lower:]])'
  else
    let a = ''
    let b = ''
  endif
  return a.'('.join(map(sort(keys(a:dict),function('s:sort')),'s:subesc(v:val)'),'\|').')'.b
endfunction

function! s:c()
  call histdel('search',-1)
  return ""
endfunction

function! s:find_command(cmd,flags,word)
  let opts = s:normalize_options(a:flags)
  let dict = s:create_dictionary(a:word,"",opts)
  " This is tricky.  If we use :/pattern, the search drops us at the
  " beginning of the line, and we can't use position flags (e.g., /foo/e).
  " If we use :norm /pattern, we leave ourselves vulnerable to "press enter"
  " prompts (even with :silent).
  let cmd = (a:cmd =~ '[?!]' ? '?' : '/')
  let @/ = s:pattern(dict,opts.boundaries)
  if opts.flags == "" || !search(@/,'n')
    return "norm! ".cmd."\<CR>"
  elseif opts.flags =~ ';[/?]\@!'
    call s:throw("E386: Expected '?' or '/' after ';'")
  else
    return "exe 'norm! ".cmd.cmd.opts.flags."\<CR>'|call histdel('search',-1)"
    return ""
  endif
endfunction

function! s:grep_command(args,bang,flags,word)
  let opts = s:normalize_options(a:flags)
  let dict = s:create_dictionary(a:word,"",opts)
  if &grepprg == "internal"
    let lhs = "'".s:pattern(dict,opts.boundaries)."'"
  elseif &grepprg =~# '^rg\|^ag'
    let lhs = "'".s:egrep_pattern(dict,opts.boundaries)."'"
  else
    let lhs = "-E '".s:egrep_pattern(dict,opts.boundaries)."'"
  endif
  return "grep".(a:bang ? "!" : "")." ".lhs." ".a:args
endfunction

let s:commands.search = s:commands.abstract.clone()
let s:commands.search.options = {"word": 0, "variable": 0, "flags": ""}

function! s:commands.search.process(bang,line1,line2,count,args)
  call s:extractopts(a:args,self.options)
  if self.options.word
    let self.options.flags .= "w"
  elseif self.options.variable
    let self.options.flags .= "v"
  endif
  let opts = s:normalize_options(self.options)
  if len(a:args) > 1
    return s:grep_command(join(a:args[1:]," "),a:bang,opts,a:args[0])
  elseif len(a:args) == 1
    return s:find_command(a:bang ? "!" : " ",opts,a:args[0])
  else
    call s:throw("E471: Argument required")
  endif
endfunction

" }}}1
" Substitution {{{1

function! Abolished()
  return get(g:abolish_last_dict,submatch(0),submatch(0))
endfunction

function! s:substitute_command(cmd,bad,good,flags)
  let opts = s:normalize_options(a:flags)
  let dict = s:create_dictionary(a:bad,a:good,opts)
  let lhs = s:pattern(dict,opts.boundaries)
  let g:abolish_last_dict = dict
  return a:cmd.'/'.lhs.'/\=Abolished()'."/".opts.flags
endfunction

function! s:parse_substitute(bang,line1,line2,count,args)
  if get(a:args,0,'') =~ '^[/?'']'
    let separator = matchstr(a:args[0],'^.')
    let args = split(join(a:args,' '),separator,1)
    call remove(args,0)
  else
    let args = a:args
  endif
  if len(args) < 2
    call s:throw("E471: Argument required")
  elseif len(args) > 3
    call s:throw("E488: Trailing characters")
  endif
  let [bad,good,flags] = (args + [""])[0:2]
  if a:count == 0
    let cmd = "substitute"
  else
    let cmd = a:line1.",".a:line2."substitute"
  endif
  return s:substitute_command(cmd,bad,good,flags)
endfunction

let s:commands.substitute = s:commands.abstract.clone()
let s:commands.substitute.options = {"word": 0, "variable": 0, "flags": "g"}

function! s:commands.substitute.process(bang,line1,line2,count,args)
  call s:extractopts(a:args,self.options)
  if self.options.word
    let self.options.flags .= "w"
  elseif self.options.variable
    let self.options.flags .= "v"
  endif
  let opts = s:normalize_options(self.options)
  if len(a:args) <= 1
    call s:throw("E471: Argument required")
  else
    let good = join(a:args[1:],"")
    let cmd = a:bang ? "." : "%"
    return s:substitute_command(cmd,a:args[0],good,self.options)
  endif
endfunction

" }}}1
" Abbreviations {{{1

function! s:badgood(args)
  let words = filter(copy(a:args),'v:val !~ "^-"')
  call filter(a:args,'v:val =~ "^-"')
  if empty(words)
    call s:throw("E471: Argument required")
  elseif !empty(a:args)
    call s:throw("Unknown argument: ".a:args[0])
  endif
  let [bad; words] = words
  return [bad, join(words," ")]
endfunction

function! s:abbreviate_from_dict(cmd,dict)
  for [lhs,rhs] in items(a:dict)
    exe a:cmd lhs rhs
  endfor
endfunction

let s:commands.abbrev     = s:commands.abstract.clone()
let s:commands.abbrev.options = {"buffer":0,"cmdline":0,"delete":0}
function! s:commands.abbrev.process(bang,line1,line2,count,args)
  let args = copy(a:args)
  call s:extractopts(a:args,self.options)
  if self.options.delete
    let cmd = "unabbrev"
    let good = ""
  else
    let cmd = "noreabbrev"
  endif
  if !self.options.cmdline
    let cmd = "i" . cmd
  endif
  if self.options.delete
    let cmd = "silent! ".cmd
  endif
  if self.options.buffer
    let cmd = cmd . " <buffer>"
  endif
  let [bad, good] = s:badgood(a:args)
  if substitute(bad, '[{},]', '', 'g') !~# '^\k*$'
    call s:throw("E474: Invalid argument (not a keyword: ".string(bad).")")
  endif
  if !self.options.delete && good == ""
    call s:throw("E471: Argument required".a:args[0])
  endif
  let dict = s:create_dictionary(bad,good,self.options)
  call s:abbreviate_from_dict(cmd,dict)
  if a:bang
    let i = 0
    let str = "Abolish ".join(args," ")
    let file = g:abolish_save_file
    if !isdirectory(fnamemodify(file,':h'))
      call mkdir(fnamemodify(file,':h'),'p')
    endif

    if filereadable(file)
      let old = readfile(file)
    else
      let old = ["\" Exit if :Abolish isn't available.","if !exists(':Abolish')","    finish","endif",""]
    endif
    call writefile(old + [str],file)
  endif
  return ""
endfunction

let s:commands.delete   = s:commands.abbrev.clone()
let s:commands.delete.options.delete = 1

" }}}1
" Maps {{{1

function! s:unknown_coercion(letter,word)
  return a:word
endfunction

call extend(Abolish.Coercions, {
      \ 'c': Abolish.camelcase,
      \ 'm': Abolish.mixedcase,
      \ 'p': Abolish.mixedcase,
      \ 's': Abolish.snakecase,
      \ '_': Abolish.snakecase,
      \ 'u': Abolish.uppercase,
      \ 'U': Abolish.uppercase,
      \ '-': Abolish.dashcase,
      \ 'k': Abolish.dashcase,
      \ '.': Abolish.dotcase,
      \ ' ': Abolish.spacecase,
      \ "function missing": s:function("s:unknown_coercion")
      \}, "keep")

function! s:coerce(type) abort
  if a:type !~# '^\%(line\|char\|block\)'
    let s:transformation = a:type
    let &opfunc = matchstr(expand('<sfile>'), '<SNR>\w*')
    return 'g@'
  endif
  let selection = &selection
  let clipboard = &clipboard
  try
    set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
    let regbody = getreg('"')
    let regtype = getregtype('"')
    let c = v:count1
    let begin = getcurpos()
    while c > 0
      let c -= 1
      if a:type ==# 'line'
        let move = "'[V']"
      elseif a:type ==# 'block'
        let move = "`[\<C-V>`]"
      else
        let move = "`[v`]"
      endif
      silent exe 'normal!' move.'y'
      let word = @@
      let @@ = s:send(g:Abolish.Coercions,s:transformation,word)
      if word !=# @@
        let changed = 1
        exe 'normal!' move.'p'
      endif
    endwhile
    call setreg('"',regbody,regtype)
    call setpos("'[",begin)
    call setpos(".",begin)
  finally
    let &selection = selection
    let &clipboard = clipboard
  endtry
endfunction

nnoremap <expr> <Plug>(abolish-coerce) <SID>coerce(nr2char(getchar()))
vnoremap <expr> <Plug>(abolish-coerce) <SID>coerce(nr2char(getchar()))
nnoremap <expr> <Plug>(abolish-coerce-word) <SID>coerce(nr2char(getchar())).'iw'

" }}}1

if !exists("g:abolish_no_mappings") || ! g:abolish_no_mappings
  nmap cr  <Plug>(abolish-coerce-word)
endif

command! -nargs=+ -bang -bar -range=0 -complete=custom,s:Complete Abolish
      \ :exec s:dispatcher(<bang>0,<line1>,<line2>,<count>,[<f-args>])
command! -nargs=1 -bang -bar -range=0 -complete=custom,s:SubComplete Subvert
      \ :exec s:subvert_dispatcher(<bang>0,<line1>,<line2>,<count>,<q-args>)
if exists(':S') != 2
  command -nargs=1 -bang -bar -range=0 -complete=custom,s:SubComplete S
        \ :exec s:subvert_dispatcher(<bang>0,<line1>,<line2>,<count>,<q-args>)
endif

" vim:set ft=vim sw=2 sts=2:
