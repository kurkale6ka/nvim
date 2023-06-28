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
./README.markdown	[[[1
98
# surround.vim

Surround.vim is all about "surroundings": parentheses, brackets, quotes,
XML tags, and more.  The plugin provides mappings to easily delete,
change and add such surroundings in pairs.

It's easiest to explain with examples.  Press `cs"'` inside

    "Hello world!"

to change it to

    'Hello world!'

Now press `cs'<q>` to change it to

    <q>Hello world!</q>

To go full circle, press `cst"` to get

    "Hello world!"

To remove the delimiters entirely, press `ds"`.

    Hello world!

Now with the cursor on "Hello", press `ysiw]` (`iw` is a text object).

    [Hello] world!

Let's make that braces and add some space (use `}` instead of `{` for no
space): `cs]{`

    { Hello } world!

Now wrap the entire line in parentheses with `yssb` or `yss)`.

    ({ Hello } world!)

Revert to the original text: `ds{ds)`

    Hello world!

Emphasize hello: `ysiw<em>`

    <em>Hello</em> world!

Finally, let's try out visual mode. Press a capital V (for linewise
visual mode) followed by `S<p class="important">`.

    <p class="important">
      <em>Hello</em> world!
    </p>

This plugin is very powerful for HTML and XML editing, a niche which
currently seems underfilled in Vim land.  (As opposed to HTML/XML
*inserting*, for which many plugins are available).  Adding, changing,
and removing pairs of tags simultaneously is a breeze.

The `.` command will work with `ds`, `cs`, and `yss` if you install
[repeat.vim](https://github.com/tpope/vim-repeat).

## Installation

Install using your favorite package manager, or use Vim's built-in package
support:

    mkdir -p ~/.vim/pack/tpope/start
    cd ~/.vim/pack/tpope/start
    git clone https://tpope.io/vim/surround.git
    vim -u NONE -c "helptags surround/doc" -c q

## FAQ

> How do I surround without adding a space?

Only the opening brackets—`[`, `{`, and `(`—add a space.  Use a closing
bracket, or the `b` (`(`) and `B` (`{`) aliases.

## Contributing

See the contribution guidelines for
[pathogen.vim](https://github.com/tpope/vim-pathogen#readme).

## Self-Promotion

Like surround.vim?  Star the repository on
[GitHub](https://github.com/tpope/vim-surround) and vote for it on
[vim.org](https://www.vim.org/scripts/script.php?script_id=1697).

Love surround.vim?  Follow [tpope](http://tpo.pe/) on
[GitHub](https://github.com/tpope) and
[Twitter](http://twitter.com/tpope).

## License

Copyright (c) Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
./doc/surround.txt	[[[1
205
*surround.txt*  Plugin for deleting, changing, and adding "surroundings"

Author:  Tim Pope <http://tpo.pe/>
License: Same terms as Vim itself (see |license|)

This plugin is only available if 'compatible' is not set.

INTRODUCTION                                    *surround*

This plugin is a tool for dealing with pairs of "surroundings."  Examples
of surroundings include parentheses, quotes, and HTML tags.  They are
closely related to what Vim refers to as |text-objects|.  Provided
are mappings to allow for removing, changing, and adding surroundings.

Details follow on the exact semantics, but first, consider the following
examples.  An asterisk (*) is used to denote the cursor position.

  Old text                  Command     New text ~
  "Hello *world!"           ds"         Hello world!
  [123+4*56]/2              cs])        (123+456)/2
  "Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
  if *x>3 {                 ysW(        if ( x>3 ) {
  my $str = *whee!;         vllllS'     my $str = 'whee!';

While a few features of this plugin will work in older versions of Vim,
Vim 7 is recommended for full functionality.

MAPPINGS                                        *surround-mappings*

Delete surroundings is *ds* .  The next character given determines the target
to delete.  The exact nature of the target is explained in |surround-targets|
but essentially it is the last character of a |text-object|.  This mapping
deletes the difference between the "i"nner object and "a"n object.  This is
easiest to understand with some examples:

  Old text                  Command     New text ~
  "Hello *world!"           ds"         Hello world!
  (123+4*56)/2              ds)         123+456/2
  <div>Yo!*</div>           dst         Yo!

Change surroundings is *cs* .  It takes two arguments, a target like with
|ds|, and a replacement.  *cS* changes surroundings, placing the surrounded
text on its own line(s) like |yS|.  Details about the second argument can be
found below in |surround-replacements|.  Once again, examples are in order.

  Old text                  Command     New text ~
  "Hello *world!"           cs"'        'Hello world!'
  "Hello *world!"           cs"<q>      <q>Hello world!</q>
  (123+4*56)/2              cs)]        [123+456]/2
  (123+4*56)/2              cs)[        [ 123+456 ]/2
  <div>Yo!*</div>           cst<p>      <p>Yo!</p>

*ys* takes a valid Vim motion or text object as the first object, and wraps
it using the second argument as with |cs|.  (It's a stretch, but a good
mnemonic for "ys" is "you surround".)

  Old text                  Command     New text ~
  Hello w*orld!             ysiw)       Hello (world)!

As a special case, *yss* operates on the current line, ignoring leading
whitespace.

  Old text                  Command     New text ~
      Hello w*orld!         yssB            {Hello world!}

There is also *yS* and *ySS* which indent the surrounded text and place it
on a line of its own.

In visual mode, a simple "S" with an argument wraps the selection.  This is
referred to as the *vS* mapping, although ordinarily there will be
additional keystrokes between the v and S.  In linewise visual mode, the
surroundings are placed on separate lines and indented.  In blockwise visual
mode, each line is surrounded.

A "gS" in visual mode, known as *vgS* , behaves similarly.  In linewise visual
mode, the automatic indenting is suppressed.  In blockwise visual mode, this
enables surrounding past the end of the line with 'virtualedit' set (there
seems to be no way in Vim Script to differentiate between a jagged end of line
selection and a virtual block selected past the end of the line, so two maps
were needed).

                                                *i_CTRL-G_s* *i_CTRL-G_S*
Finally, there is an experimental insert mode mapping on <C-G>s and <C-S>.
Beware that the latter won't work on terminals with flow control (if you
accidentally freeze your terminal, use <C-Q> to unfreeze it).  The mapping
inserts the specified surroundings and puts the cursor between them.  If,
immediately after the mapping and before the replacement, a second <C-S> or
carriage return is pressed, the prefix, cursor, and suffix will be placed on
three separate lines.  <C-G>S (not <C-G>s) also exhibits this behavior.

TARGETS                                         *surround-targets*

The |ds| and |cs| commands both take a target as their first argument.  The
possible targets are based closely on the |text-objects| provided by Vim.
All targets are currently just one character.

Eight punctuation marks, (, ), {, }, [, ], <, and >, represent themselves
and their counterparts.  If the opening mark is used, contained whitespace is
also trimmed.  The targets b, B, r, and a are aliases for ), }, ], and > 
(the first two mirror Vim; the second two are completely arbitrary and
subject to change).

Three quote marks, ', ", `, represent themselves, in pairs.  They are only
searched for on the current line.

A t is a pair of HTML or XML tags.  See |tag-blocks| for details.  Remember
that you can specify a numerical argument if you want to get to a tag other
than the innermost one.

The letters w, W, and s correspond to a |word|, a |WORD|, and a |sentence|,
respectively.  These are special in that they have nothing to delete, and
used with |ds| they are a no-op.  With |cs|, one could consider them a
slight shortcut for ysi (cswb == ysiwb, more or less).

A p represents a |paragraph|.  This behaves similarly to w, W, and s above;
however, newlines are sometimes added and/or removed.

REPLACEMENTS                                    *surround-replacements*

A replacement argument is a single character, and is required by |cs|, |ys|,
and |vS|.  Undefined replacement characters (with the exception of alphabetic
characters) default to placing themselves at the beginning and end of the
destination, which can be useful for characters like / and |.

If either ), }, ], or > is used, the text is wrapped in the appropriate pair
of characters.  Similar behavior can be found with (, {, and [ (but not <),
which append an additional space to the inside.  Like with the targets above,
b, B, r, and a are aliases for ), }, ], and >.  To fulfill the common need for
code blocks in C-style languages, <C-}> (which is really <C-]>) adds braces on
lines separate from the content.

If t or < is used, Vim prompts for an HTML/XML tag to insert.  You may specify
attributes here and they will be stripped from the closing tag. If replacing a
tag, its attributes are kept in the new tag. End your input with > to discard
the those attributes. If <C-T> is used, the tags will appear on lines by
themselves.

If f, F, or <C-F> is used, Vim prompts for a function name to insert.  The target
text will be wrapped in a function call. If f is used, the text is wrapped with
() parentheses; F adds additional spaces inside the parentheses. <C-F> inserts the
function name inside the parentheses.

  Old text                  Command           New text ~
  "hello"                   ysWfprint<cr>     print("hello")
  "hello"                   ysWFprint<cr>     print( "hello" )
  "hello"                   ysW<C-f>print<cr> (print "hello")

If s is used, a leading but not trailing space is added.  This is useful for
removing parentheses from a function call with csbs.

CUSTOMIZING                                     *surround-customizing*

The following adds a potential replacement on "-" (ASCII 45) in PHP files.
(To determine the ASCII code to use, :echo char2nr("-")).  The carriage
return will be replaced by the original text.
>
  autocmd FileType php let b:surround_45 = "<?php \r ?>"
<
This can be used in a PHP file as in the following example.

  Old text                  Command     New text ~
  print "Hello *world!"     yss-        <?php print "Hello world!" ?>

Additionally, one can use a global variable for globally available
replacements.
>
  let g:surround_45 = "<% \r %>"
  let g:surround_61 = "<%= \r %>"
<
Advanced, experimental, and subject to change:  One can also prompt for
replacement text.  The syntax for this is to surround the replacement in pairs
of low numbered control characters.  If this sounds confusing, that's because
it is (but it makes the parsing easy).  Consider the following example for a
LaTeX environment on the "l" replacement.
>
  let g:surround_108 = "\\begin{\1environment: \1}\r\\end{\1\1}"
<
When this replacement is used,  the user is prompted with an "environment: "
prompt for input.  This input is inserted between each set of \1's.
Additional inputs up to \7 can be used.

Furthermore, one can specify a regular expression substitution to apply.
>
  let g:surround_108 = "\\begin{\1environment: \1}\r\\end{\1\r}.*\r\1}"
<
This will remove anything after the first } in the input when the text is
placed within the \end{} slot.  The first \r marks where the pattern begins,
and the second where the replacement text begins.

Here's a second example for creating an HTML <div>.  The substitution cleverly
prompts for an id, but only adds id="" if it is non-blank.  You may have to
read this one a few times slowly before you understand it.
>
  let g:surround_{char2nr("d")} = "<div\1id: \r..*\r id=\"&\"\1>\r</div>"
<
Inputting text replacements is a proof of concept at this point. The ugly,
unintuitive interface and the brevity of the documentation reflect this.

Finally, It is possible to always append a string to surroundings in insert
mode (and only insert mode).  This is useful with certain plugins and mappings
that allow you to jump to such markings.
>
  let g:surround_insert_tail = "<++>"
<
 vim:tw=78:ts=8:ft=help:norl:
./plugin/surround.vim	[[[1
630
" surround.vim - Surroundings
" Author:       Tim Pope <http://tpo.pe/>
" Version:      2.2
" GetLatestVimScripts: 1697 1 :AutoInstall: surround.vim

if exists("g:loaded_surround") || &cp || v:version < 700
  finish
endif
let g:loaded_surround = 1

" Input functions {{{1

function! s:getchar()
  let c = getchar()
  if c =~ '^\d\+$'
    let c = nr2char(c)
  endif
  return c
endfunction

function! s:inputtarget()
  let c = s:getchar()
  while c =~ '^\d\+$'
    let c .= s:getchar()
  endwhile
  if c == " "
    let c .= s:getchar()
  endif
  if c =~ "\<Esc>\|\<C-C>\|\0"
    return ""
  else
    return c
  endif
endfunction

function! s:inputreplacement()
  let c = s:getchar()
  if c == " "
    let c .= s:getchar()
  endif
  if c =~ "\<Esc>" || c =~ "\<C-C>"
    return ""
  else
    return c
  endif
endfunction

function! s:beep()
  exe "norm! \<Esc>"
  return ""
endfunction

function! s:redraw()
  redraw
  return ""
endfunction

" }}}1

" Wrapping functions {{{1

function! s:extractbefore(str)
  if a:str =~ '\r'
    return matchstr(a:str,'.*\ze\r')
  else
    return matchstr(a:str,'.*\ze\n')
  endif
endfunction

function! s:extractafter(str)
  if a:str =~ '\r'
    return matchstr(a:str,'\r\zs.*')
  else
    return matchstr(a:str,'\n\zs.*')
  endif
endfunction

function! s:fixindent(str,spc)
  let str = substitute(a:str,'\t',repeat(' ',&sw),'g')
  let spc = substitute(a:spc,'\t',repeat(' ',&sw),'g')
  let str = substitute(str,'\(\n\|\%^\).\@=','\1'.spc,'g')
  if ! &et
    let str = substitute(str,'\s\{'.&ts.'\}',"\t",'g')
  endif
  return str
endfunction

function! s:process(string)
  let i = 0
  for i in range(7)
    let repl_{i} = ''
    let m = matchstr(a:string,nr2char(i).'.\{-\}\ze'.nr2char(i))
    if m != ''
      let m = substitute(strpart(m,1),'\r.*','','')
      let repl_{i} = input(match(m,'\w\+$') >= 0 ? m.': ' : m)
    endif
  endfor
  let s = ""
  let i = 0
  while i < strlen(a:string)
    let char = strpart(a:string,i,1)
    if char2nr(char) < 8
      let next = stridx(a:string,char,i+1)
      if next == -1
        let s .= char
      else
        let insertion = repl_{char2nr(char)}
        let subs = strpart(a:string,i+1,next-i-1)
        let subs = matchstr(subs,'\r.*')
        while subs =~ '^\r.*\r'
          let sub = matchstr(subs,"^\r\\zs[^\r]*\r[^\r]*")
          let subs = strpart(subs,strlen(sub)+1)
          let r = stridx(sub,"\r")
          let insertion = substitute(insertion,strpart(sub,0,r),strpart(sub,r+1),'')
        endwhile
        let s .= insertion
        let i = next
      endif
    else
      let s .= char
    endif
    let i += 1
  endwhile
  return s
endfunction

function! s:wrap(string,char,type,removed,special)
  let keeper = a:string
  let newchar = a:char
  let s:input = ""
  let type = a:type
  let linemode = type ==# 'V' ? 1 : 0
  let before = ""
  let after  = ""
  if type ==# "V"
    let initspaces = matchstr(keeper,'\%^\s*')
  else
    let initspaces = matchstr(getline('.'),'\%^\s*')
  endif
  let pairs = "b()B{}r[]a<>"
  let extraspace = ""
  if newchar =~ '^ '
    let newchar = strpart(newchar,1)
    let extraspace = ' '
  endif
  let idx = stridx(pairs,newchar)
  if newchar == ' '
    let before = ''
    let after  = ''
  elseif exists("b:surround_".char2nr(newchar))
    let all    = s:process(b:surround_{char2nr(newchar)})
    let before = s:extractbefore(all)
    let after  =  s:extractafter(all)
  elseif exists("g:surround_".char2nr(newchar))
    let all    = s:process(g:surround_{char2nr(newchar)})
    let before = s:extractbefore(all)
    let after  =  s:extractafter(all)
  elseif newchar ==# "p"
    let before = "\n"
    let after  = "\n\n"
  elseif newchar ==# 's'
    let before = ' '
    let after  = ''
  elseif newchar ==# ':'
    let before = ':'
    let after = ''
  elseif newchar =~# "[tT\<C-T><]"
    let dounmapp = 0
    let dounmapb = 0
    if !maparg(">","c")
      let dounmapb = 1
      " Hide from AsNeeded
      exe "cn"."oremap > ><CR>"
    endif
    let default = ""
    if newchar ==# "T"
      if !exists("s:lastdel")
        let s:lastdel = ""
      endif
      let default = matchstr(s:lastdel,'<\zs.\{-\}\ze>')
    endif
    let tag = input("<",default)
    if dounmapb
      silent! cunmap >
    endif
    let s:input = tag
    if tag != ""
      let keepAttributes = ( match(tag, ">$") == -1 )
      let tag = substitute(tag,'>*$','','')
      let attributes = ""
      if keepAttributes
        let attributes = matchstr(a:removed, '<[^ \t\n]\+\zs\_.\{-\}\ze>')
      endif
      let s:input = tag . '>'
      if tag =~ '/$'
        let tag = substitute(tag, '/$', '', '')
        let before = '<'.tag.attributes.' />'
        let after = ''
      else
        let before = '<'.tag.attributes.'>'
        let after  = '</'.substitute(tag,' .*','','').'>'
      endif
      if newchar == "\<C-T>"
        if type ==# "v" || type ==# "V"
          let before .= "\n\t"
        endif
        if type ==# "v"
          let after  = "\n". after
        endif
      endif
    endif
  elseif newchar ==# 'l' || newchar == '\'
    " LaTeX
    let env = input('\begin{')
    if env != ""
      let s:input = env."\<CR>"
      let env = '{' . env
      let env .= s:closematch(env)
      echo '\begin'.env
      let before = '\begin'.env
      let after  = '\end'.matchstr(env,'[^}]*').'}'
    endif
  elseif newchar ==# 'f' || newchar ==# 'F'
    let fnc = input('function: ')
    if fnc != ""
      let s:input = fnc."\<CR>"
      let before = substitute(fnc,'($','','').'('
      let after  = ')'
      if newchar ==# 'F'
        let before .= ' '
        let after = ' ' . after
      endif
    endif
  elseif newchar ==# "\<C-F>"
    let fnc = input('function: ')
    let s:input = fnc."\<CR>"
    let before = '('.fnc.' '
    let after = ')'
  elseif idx >= 0
    let spc = (idx % 3) == 1 ? " " : ""
    let idx = idx / 3 * 3
    let before = strpart(pairs,idx+1,1) . spc
    let after  = spc . strpart(pairs,idx+2,1)
  elseif newchar == "\<C-[>" || newchar == "\<C-]>"
    let before = "{\n\t"
    let after  = "\n}"
  elseif newchar !~ '\a'
    let before = newchar
    let after  = newchar
  else
    let before = ''
    let after  = ''
  endif
  let after  = substitute(after ,'\n','\n'.initspaces,'g')
  if type ==# 'V' || (a:special && type ==# "v")
    let before = substitute(before,' \+$','','')
    let after  = substitute(after ,'^ \+','','')
    if after !~ '^\n'
      let after  = initspaces.after
    endif
    if keeper !~ '\n$' && after !~ '^\n'
      let keeper .= "\n"
    elseif keeper =~ '\n$' && after =~ '^\n'
      let after = strpart(after,1)
    endif
    if keeper !~ '^\n' && before !~ '\n\s*$'
      let before .= "\n"
      if a:special
        let before .= "\t"
      endif
    elseif keeper =~ '^\n' && before =~ '\n\s*$'
      let keeper = strcharpart(keeper,1)
    endif
    if type ==# 'V' && keeper =~ '\n\s*\n$'
      let keeper = strcharpart(keeper,0,strchars(keeper) - 1)
    endif
  endif
  if type ==# 'V'
    let before = initspaces.before
  endif
  if before =~ '\n\s*\%$'
    if type ==# 'v'
      let keeper = initspaces.keeper
    endif
    let padding = matchstr(before,'\n\zs\s\+\%$')
    let before  = substitute(before,'\n\s\+\%$','\n','')
    let keeper = s:fixindent(keeper,padding)
  endif
  if type ==# 'V'
    let keeper = before.keeper.after
  elseif type =~ "^\<C-V>"
    " Really we should be iterating over the buffer
    let repl = substitute(before,'[\\~]','\\&','g').'\1'.substitute(after,'[\\~]','\\&','g')
    let repl = substitute(repl,'\n',' ','g')
    let keeper = substitute(keeper."\n",'\(.\{-\}\)\(\n\)',repl.'\n','g')
    let keeper = substitute(keeper,'\n\%$','','')
  else
    let keeper = before.extraspace.keeper.extraspace.after
  endif
  return keeper
endfunction

function! s:wrapreg(reg,char,removed,special)
  let orig = getreg(a:reg)
  let type = substitute(getregtype(a:reg),'\d\+$','','')
  let new = s:wrap(orig,a:char,type,a:removed,a:special)
  call setreg(a:reg,new,type)
endfunction
" }}}1

function! s:insert(...) " {{{1
  " Optional argument causes the result to appear on 3 lines, not 1
  let linemode = a:0 ? a:1 : 0
  let char = s:inputreplacement()
  while char == "\<CR>" || char == "\<C-S>"
    " TODO: use total count for additional blank lines
    let linemode += 1
    let char = s:inputreplacement()
  endwhile
  if char == ""
    return ""
  endif
  let cb_save = &clipboard
  set clipboard-=unnamed clipboard-=unnamedplus
  let reg_save = @@
  call setreg('"',"\032",'v')
  call s:wrapreg('"',char,"",linemode)
  " If line mode is used and the surrounding consists solely of a suffix,
  " remove the initial newline.  This fits a use case of mine but is a
  " little inconsistent.  Is there anyone that would prefer the simpler
  " behavior of just inserting the newline?
  if linemode && match(getreg('"'),'^\n\s*\zs.*') == 0
    call setreg('"',matchstr(getreg('"'),'^\n\s*\zs.*'),getregtype('"'))
  endif
  " This can be used to append a placeholder to the end
  if exists("g:surround_insert_tail")
    call setreg('"',g:surround_insert_tail,"a".getregtype('"'))
  endif
  if &ve != 'all' && col('.') >= col('$')
    if &ve == 'insert'
      let extra_cols = virtcol('.') - virtcol('$')
      if extra_cols > 0
        let [regval,regtype] = [getreg('"',1,1),getregtype('"')]
        call setreg('"',join(map(range(extra_cols),'" "'),''),'v')
        norm! ""p
        call setreg('"',regval,regtype)
      endif
    endif
    norm! ""p
  else
    norm! ""P
  endif
  if linemode
    call s:reindent()
  endif
  norm! `]
  call search("\032",'bW')
  let @@ = reg_save
  let &clipboard = cb_save
  return "\<Del>"
endfunction " }}}1

function! s:reindent() abort " {{{1
  if get(b:, 'surround_indent', get(g:, 'surround_indent', 1)) && (!empty(&equalprg) || !empty(&indentexpr) || &cindent || &smartindent || &lisp)
    silent norm! '[=']
  endif
endfunction " }}}1

function! s:dosurround(...) " {{{1
  let sol_save = &startofline
  set startofline
  let scount = v:count1
  let char = (a:0 ? a:1 : s:inputtarget())
  let spc = ""
  if char =~ '^\d\+'
    let scount = scount * matchstr(char,'^\d\+')
    let char = substitute(char,'^\d\+','','')
  endif
  if char =~ '^ '
    let char = strpart(char,1)
    let spc = 1
  endif
  if char == 'a'
    let char = '>'
  endif
  if char == 'r'
    let char = ']'
  endif
  let newchar = ""
  if a:0 > 1
    let newchar = a:2
    if newchar == "\<Esc>" || newchar == "\<C-C>" || newchar == ""
      if !sol_save
        set nostartofline
      endif
      return s:beep()
    endif
  endif
  let cb_save = &clipboard
  set clipboard-=unnamed clipboard-=unnamedplus
  let append = ""
  let original = getreg('"')
  let otype = getregtype('"')
  call setreg('"',"")
  let strcount = (scount == 1 ? "" : scount)
  if char == '/'
    exe 'norm! '.strcount.'[/d'.strcount.']/'
  elseif char =~# '[[:punct:][:space:]]' && char !~# '[][(){}<>"''`]'
    exe 'norm! T'.char
    if getline('.')[col('.')-1] == char
      exe 'norm! l'
    endif
    exe 'norm! dt'.char
  else
    exe 'norm! d'.strcount.'i'.char
  endif
  let keeper = getreg('"')
  let okeeper = keeper " for reindent below
  if keeper == ""
    call setreg('"',original,otype)
    let &clipboard = cb_save
    if !sol_save
      set nostartofline
    endif
    return ""
  endif
  let oldline = getline('.')
  let oldlnum = line('.')
  if char ==# "p"
    call setreg('"','','V')
  elseif char ==# "s" || char ==# "w" || char ==# "W"
    " Do nothing
    call setreg('"','')
  elseif char =~ "[\"'`]"
    exe "norm! i \<Esc>d2i".char
    call setreg('"',substitute(getreg('"'),' ','',''))
  elseif char == '/'
    norm! "_x
    call setreg('"','/**/',"c")
    let keeper = substitute(substitute(keeper,'^/\*\s\=','',''),'\s\=\*$','','')
  elseif char =~# '[[:punct:][:space:]]' && char !~# '[][(){}<>]'
    exe 'norm! F'.char
    exe 'norm! df'.char
  else
    " One character backwards
    call search('\m.', 'bW')
    exe "norm! da".char
  endif
  let removed = getreg('"')
  let rem2 = substitute(removed,'\n.*','','')
  let oldhead = strpart(oldline,0,strlen(oldline)-strlen(rem2))
  let oldtail = strpart(oldline,  strlen(oldline)-strlen(rem2))
  let regtype = getregtype('"')
  if char =~# '[\[({<T]' || spc
    let keeper = substitute(keeper,'^\s\+','','')
    let keeper = substitute(keeper,'\s\+$','','')
  endif
  if col("']") == col("$") && virtcol('.') + 1 == virtcol('$')
    if oldhead =~# '^\s*$' && a:0 < 2
      let keeper = substitute(keeper,'\%^\n'.oldhead.'\(\s*.\{-\}\)\n\s*\%$','\1','')
    endif
    let pcmd = "p"
  else
    let pcmd = "P"
  endif
  if line('.') + 1 < oldlnum && regtype ==# "V"
    let pcmd = "p"
  endif
  call setreg('"',keeper,regtype)
  if newchar != ""
    let special = a:0 > 2 ? a:3 : 0
    call s:wrapreg('"',newchar,removed,special)
  endif
  silent exe 'norm! ""'.pcmd.'`['
  if removed =~ '\n' || okeeper =~ '\n' || getreg('"') =~ '\n'
    call s:reindent()
  endif
  if getline('.') =~ '^\s\+$' && keeper =~ '^\s*\n'
    silent norm! cc
  endif
  call setreg('"',original,otype)
  let s:lastdel = removed
  let &clipboard = cb_save
  if newchar == ""
    silent! call repeat#set("\<Plug>Dsurround".char,scount)
  else
    silent! call repeat#set("\<Plug>C".(a:0 > 2 && a:3 ? "S" : "s")."urround".char.newchar.s:input,scount)
  endif
  if !sol_save
    set nostartofline
  endif
endfunction " }}}1

function! s:changesurround(...) " {{{1
  let a = s:inputtarget()
  if a == ""
    return s:beep()
  endif
  let b = s:inputreplacement()
  if b == ""
    return s:beep()
  endif
  call s:dosurround(a,b,a:0 && a:1)
endfunction " }}}1

function! s:opfunc(type, ...) abort " {{{1
  if a:type ==# 'setup'
    let &opfunc = matchstr(expand('<sfile>'), '<SNR>\w\+$')
    return 'g@'
  endif
  let char = s:inputreplacement()
  if char == ""
    return s:beep()
  endif
  let reg = '"'
  let sel_save = &selection
  let &selection = "inclusive"
  let cb_save  = &clipboard
  set clipboard-=unnamed clipboard-=unnamedplus
  let reg_save = getreg(reg)
  let reg_type = getregtype(reg)
  let type = a:type
  if a:type == "char"
    silent exe 'norm! v`[o`]"'.reg.'y'
    let type = 'v'
  elseif a:type == "line"
    silent exe 'norm! `[V`]"'.reg.'y'
    let type = 'V'
  elseif a:type ==# "v" || a:type ==# "V" || a:type ==# "\<C-V>"
    let &selection = sel_save
    let ve = &virtualedit
    if !(a:0 && a:1)
      set virtualedit=
    endif
    silent exe 'norm! gv"'.reg.'y'
    let &virtualedit = ve
  elseif a:type =~ '^\d\+$'
    let type = 'v'
    silent exe 'norm! ^v'.a:type.'$h"'.reg.'y'
    if mode() ==# 'v'
      norm! v
      return s:beep()
    endif
  else
    let &selection = sel_save
    let &clipboard = cb_save
    return s:beep()
  endif
  let keeper = getreg(reg)
  if type ==# "v" && a:type !=# "v"
    let append = matchstr(keeper,'\_s\@<!\s*$')
    let keeper = substitute(keeper,'\_s\@<!\s*$','','')
  endif
  call setreg(reg,keeper,type)
  call s:wrapreg(reg,char,"",a:0 && a:1)
  if type ==# "v" && a:type !=# "v" && append != ""
    call setreg(reg,append,"ac")
  endif
  silent exe 'norm! gv'.(reg == '"' ? '' : '"' . reg).'p`['
  if type ==# 'V' || (getreg(reg) =~ '\n' && type ==# 'v')
    call s:reindent()
  endif
  call setreg(reg,reg_save,reg_type)
  let &selection = sel_save
  let &clipboard = cb_save
  if a:type =~ '^\d\+$'
    silent! call repeat#set("\<Plug>Y".(a:0 && a:1 ? "S" : "s")."surround".char.s:input,a:type)
  else
    silent! call repeat#set("\<Plug>SurroundRepeat".char.s:input)
  endif
endfunction

function! s:opfunc2(...) abort
  if !a:0 || a:1 ==# 'setup'
    let &opfunc = matchstr(expand('<sfile>'), '<SNR>\w\+$')
    return 'g@'
  endif
  call s:opfunc(a:1, 1)
endfunction " }}}1

function! s:closematch(str) " {{{1
  " Close an open (, {, [, or < on the command line.
  let tail = matchstr(a:str,'.[^\[\](){}<>]*$')
  if tail =~ '^\[.\+'
    return "]"
  elseif tail =~ '^(.\+'
    return ")"
  elseif tail =~ '^{.\+'
    return "}"
  elseif tail =~ '^<.+'
    return ">"
  else
    return ""
  endif
endfunction " }}}1

nnoremap <silent> <Plug>SurroundRepeat .
nnoremap <silent> <Plug>Dsurround  :<C-U>call <SID>dosurround(<SID>inputtarget())<CR>
nnoremap <silent> <Plug>Csurround  :<C-U>call <SID>changesurround()<CR>
nnoremap <silent> <Plug>CSurround  :<C-U>call <SID>changesurround(1)<CR>
nnoremap <expr>   <Plug>Yssurround '^'.v:count1.<SID>opfunc('setup').'g_'
nnoremap <expr>   <Plug>YSsurround <SID>opfunc2('setup').'_'
nnoremap <expr>   <Plug>Ysurround  <SID>opfunc('setup')
nnoremap <expr>   <Plug>YSurround  <SID>opfunc2('setup')
vnoremap <silent> <Plug>VSurround  :<C-U>call <SID>opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
vnoremap <silent> <Plug>VgSurround :<C-U>call <SID>opfunc(visualmode(),visualmode() ==# 'V' ? 0 : 1)<CR>
inoremap <silent> <Plug>Isurround  <C-R>=<SID>insert()<CR>
inoremap <silent> <Plug>ISurround  <C-R>=<SID>insert(1)<CR>

if !exists("g:surround_no_mappings") || ! g:surround_no_mappings
  nmap ds  <Plug>Dsurround
  nmap cs  <Plug>Csurround
  nmap cS  <Plug>CSurround
  nmap ys  <Plug>Ysurround
  nmap yS  <Plug>YSurround
  nmap yss <Plug>Yssurround
  nmap ySs <Plug>YSsurround
  nmap ySS <Plug>YSsurround
  xmap S   <Plug>VSurround
  xmap gS  <Plug>VgSurround
  if !exists("g:surround_no_insert_mappings") || ! g:surround_no_insert_mappings
    if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
      imap    <C-S> <Plug>Isurround
    endif
    imap      <C-G>s <Plug>Isurround
    imap      <C-G>S <Plug>ISurround
  endif
endif

" vim:set ft=vim sw=2 sts=2 et:
