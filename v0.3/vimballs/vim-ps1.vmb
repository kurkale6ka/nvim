" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./.gitignore	[[[1
1
/doc/tags
./README.markdown	[[[1
95
ps1.vim
=======

If you are a Windows PowerShell user who uses Vim or Gvim for editing scripts, 
then this plugin is for you.

It provides nice syntax coloring and indenting for Windows PowerShell (.ps1)
files, and also includes a filetype plugin so Vim can autodetect your PS1 scripts.

Includes contributions by:

* Tomas Restrepo
* Jared Parsons
* Heath Stewart
* Michael B. Smith
* Alexander Kostikov

Installation
------------

Copy the included directories into your .vim or vimfiles directory.

Or even better, use [pathogen.vim][1] and simply pull it in like this:

    cd ~/.vim/bundle
    git clone https://github.com/PProvost/vim-ps1.git
    
If you use [vim-plug][4] add this to your config:

    Plug 'pprovost/vim-ps1'

Folding
-------

The ps1 syntax file provides syntax folding for script blocks and digital 
signatures in scripts.

When 'foldmethod' is set to "syntax" then function script blocks will be
folded unless you use the following in your .vimrc or before opening a script:

    :let g:ps1_nofold_blocks = 1

Digital signatures in scripts will also be folded unless you use:

    :let g:ps1_nofold_sig = 1

Note: syntax folding might slow down syntax highlighting significantly,
especially for large files.

Comments and Suggestions
------------------------

Please follow, fork or submit issues on [GitHub][2] and if you
find it useful, please vote for it on [vim.org][3].

License
-------

    Copyright 2005-2012 Peter Provost
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

Version History
---------------

* v2.10 (2013-06-24) Added Heath Stewart's here strings fix
* v2.9  (2012-03-08) Included tomasr's changes
* v2.81 (2012-03-05) Fixed a dumb typo
* v2.8  (2012-03-05) Better number scanning, multiline comments, missing keywords and constants
* v2.7  (2008-09-22) Begin, process & end keywords. Better highlighting of foreach and where
* v2.6  (2007-03-05) Added unary -not operator
* v2.5  (2007-03-03) Updates for here-strings, comment todos, other small cleanups
* v2.4  (2007-03-02) Added elseif keyword
* v2.3  (2007-02-27) Added param keyword
* v2.2  (2007-02-19) Missing keywords
* v2.1  (2006-07-31) Update for renaming
* v2.0  (2005-12-21) Big update from Jared Parsons
* v1.3  (2005-12-20) Updates to syntax elements
* v1.2  (2005-08-13) Fix foreach and while problem
* v1.1 (2005-08-12) Initial release

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/PProvost/vim-ps1
[3]: http://www.vim.org/scripts/script.php?script_id=1327
[4]: https://github.com/junegunn/vim-plug
./compiler/powershell.vim	[[[1
105
" Compiler:	powershell
" Run ps1 scripts in powershell and process their output. Quickly jump through
" stack traces and see script output in the quickfix.

if exists("current_compiler")
  finish
endif
let current_compiler = "powershell"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

if !exists("g:ps1_makeprg_cmd")
  if executable('pwsh')
    " pwsh is the future
    let g:ps1_makeprg_cmd = 'pwsh'
  elseif executable('pwsh.exe')
    let g:ps1_makeprg_cmd = 'pwsh.exe'
  elseif executable('powershell.exe')
    let g:ps1_makeprg_cmd = 'powershell.exe'
  else
    let g:ps1_makeprg_cmd = ''
  endif
endif

if !executable(g:ps1_makeprg_cmd)
  echoerr "To use the powershell compiler, please set g:ps1_makeprg_cmd to the powershell executable!"
  finish
endif

" Show CategoryInfo, FullyQualifiedErrorId, etc?
let g:ps1_efm_show_error_categories = get(g:, 'ps1_efm_show_error_categories', 0)

let &l:makeprg = g:ps1_makeprg_cmd
" Load Vanilla Shell and show syntax errors
" See https://zigford.org/powershell-syntax-now-supported-by-ale-vim-plugin.html
if has('win32')
setlocal makeprg+=\ -NoProfile\ -NoLogo\ -NonInteractive\ -command\ \"&{
        \trap{$_.tostring();continue}&{
        \[void]$executioncontext.invokecommand.invokescript('%')
        \}
    \}\"
elseif has('unix')
setlocal makeprg+=\ -NoProfile\ -NoLogo\ -NonInteractive\ -command\ "&{
          \trap{\\$_.tostring();continue}&{
          \[void]\\$executioncontext.invokecommand.invokescript('%')
          \}
          \}"
    \}\"
else
  echoerr "To use the powershell compiler, please run it under Microsoft Windows or Unix!"
  finish
endif
" Use absolute path because powershell requires explicit relative paths
" (./file.ps1 is okay, but # expands to file.ps1)
setlocal makeprg+=\ %:p:S
silent CompilerSet makeprg

" Parse file, line, char from callstacks:
"     Write-Ouput : The term 'Write-Ouput' is not recognized as the name of a
"     cmdlet, function, script file, or operable program. Check the spelling
"     of the name, or if a path was included, verify that the path is correct
"     and try again.
"     At C:\script.ps1:11 char:5
"     +     Write-Ouput $content
"     +     ~~~~~~~~~~~
"         + CategoryInfo          : ObjectNotFound: (Write-Ouput:String) [], CommandNotFoundException
"         + FullyQualifiedErrorId : CommandNotFoundException

" Showing error in context with underlining.
CompilerSet errorformat=%+G+%m
" Error summary.
CompilerSet errorformat+=%E%*\\S\ :\ %m
" Error location.
CompilerSet errorformat+=%CAt\ %f:%l\ char:%c
" Errors that span multiple lines (may be wrapped to width of terminal).
CompilerSet errorformat+=%C%m
" Ignore blank/whitespace-only lines.
CompilerSet errorformat+=%Z\\s%#

if g:ps1_efm_show_error_categories
  CompilerSet errorformat^=%+G\ \ \ \ +\ %.%#\\s%#:\ %m
else
  CompilerSet errorformat^=%-G\ \ \ \ +\ %.%#\\s%#:\ %m
endif


" Parse file, line, char from of parse errors:
"     At C:\script.ps1:22 char:16
"     + Stop-Process -Name "invalidprocess
"     +                    ~~~~~~~~~~~~~~~
"     The string is missing the terminator: ".
"         + CategoryInfo          : ParserError: (:) [], ParseException
"         + FullyQualifiedErrorId : TerminatorExpectedAtEndOfString
CompilerSet errorformat+=At\ %f:%l\ char:%c


let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2:
./doc/ps1.txt	[[[1
63
*ps1.txt*  A Windows PowerShell syntax plugin for Vim

Maintainer: Peter Provost <https://www.github.com/PProvost>
License:    Apache 2.0
Version:    2.10

INTRODUCTION                                                    *ps1-syntax*

This plugin provides Vim syntax, indent and filetype detection for Windows
PowerShell scripts, modules, and XML configuration files.


ABOUT                                                           *ps1-about*

Grab the latest version or report a bug on GitHub:

https://github.com/PProvost/vim-ps1


FOLDING                                                         *ps1-folding*

The ps1 syntax file provides syntax folding (see |:syn-fold|) for script blocks
and digital signatures in scripts.

When 'foldmethod' is set to "syntax" then function script blocks will be
folded unless you use the following in your .vimrc or before opening a script: >

    :let g:ps1_nofold_blocks = 1
<
Digital signatures in scripts will also be folded unless you use: >

    :let g:ps1_nofold_sig = 1
<
Note: syntax folding might slow down syntax highlighting significantly,
especially for large files.

COMPILER                                                        *ps1-compiler*

The powershell |compiler| script 'powershell.vim' configures |:make| to
execute the script in PowerShell.

It tries to pick a smart default PowerShell command: `pwsh` if available and
`powershell` otherwise, but you can customize the command: >

    :let g:ps1_makeprg_cmd = '/path/to/pwsh'
<
To configure whether to show the exception type information: >

    :let g:ps1_efm_show_error_categories = 1
<

KEYWORD LOOKUP                                                 *ps1-keyword*

To look up keywords using PowerShell's Get-Help, press the |K| key. For more
convenient paging, the pager `less` should be installed, which is included in
many Linux distributions and in macOS.

Many other distributions are available for Windows like
https://chocolatey.org/packages/less/. Make sure `less` is in a directory
listed in the `PATH` environment variable, which chocolatey above does.

------------------------------------------------------------------------------
 vim:ft=help:
./ftdetect/ps1.vim	[[[1
11
" Vim ftdetect plugin file
" Language:           Windows PowerShell
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327
"
au BufNewFile,BufRead   *.ps1   set ft=ps1
au BufNewFile,BufRead   *.psd1  set ft=ps1
au BufNewFile,BufRead   *.psm1  set ft=ps1
au BufNewFile,BufRead   *.pssc  set ft=ps1
./ftdetect/ps1xml.vim	[[[1
8
" Vim ftdetect plugin file
" Language:           Windows PowerShell
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327

au BufNewFile,BufRead   *.ps1xml   set ft=ps1xml
./ftdetect/xml.vim	[[[1
9
" Vim ftdetect plugin file
" Language:           Windows PowerShell
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327

au BufNewFile,BufRead   *.cdxml    set ft=xml
au BufNewFile,BufRead   *.psc1     set ft=xml
./ftplugin/ps1.vim	[[[1
56
" Vim filetype plugin file
" Language:           Windows PowerShell
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin") | finish | endif

" Don't load another plug-in for this buffer
let b:did_ftplugin = 1

setlocal tw=0
setlocal commentstring=#%s
setlocal formatoptions+=tcqroj
" Enable autocompletion of hyphenated PowerShell commands,
" e.g. Get-Content or Get-ADUser
setlocal iskeyword+=-

" Change the browse dialog on Win32 to show mainly PowerShell-related files
if has("gui_win32")
	let b:browsefilter =
				\ "All PowerShell Files (*.ps1, *.psd1, *.psm1, *.ps1xml)\t*.ps1;*.psd1;*.psm1;*.ps1xml\n" .
				\ "PowerShell Script Files (*.ps1)\t*.ps1\n" .
				\ "PowerShell Module Files (*.psd1, *.psm1)\t*.psd1;*.psm1\n" .
				\ "PowerShell XML Files (*.ps1xml)\t*.ps1xml\n" .
				\ "All Files (*.*)\t*.*\n"
endif

" Look up keywords by Get-Help:
" check for PowerShell Core in Windows, Linux or MacOS
if executable('pwsh') | let s:pwsh_cmd = 'pwsh'
  " on Windows Subsystem for Linux, check for PowerShell Core in Windows
elseif exists('$WSLENV') && executable('pwsh.exe') | let s:pwsh_cmd = 'pwsh.exe'
  " check for PowerShell <= 5.1 in Windows
elseif executable('powershell.exe') | let s:pwsh_cmd = 'powershell.exe'
endif

if exists('s:pwsh_cmd')
  if !has('gui_running') && executable('less') &&
        \ !(exists('$ConEmuBuild') && &term =~? '^xterm')
    " For exclusion of ConEmu, see https://github.com/Maximus5/ConEmu/issues/2048
    command! -buffer -nargs=1 GetHelp silent exe '!' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>" | ' . (has('unix') ? 'LESS= less' : 'less') | redraw!
  elseif has('terminal')
    command! -buffer -nargs=1 GetHelp silent exe 'term ' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>"' . (executable('less') ? ' | less' : '')
  else
    command! -buffer -nargs=1 GetHelp echo system(s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full <args>')
  endif
endif
setlocal keywordprg=:GetHelp

" Undo the stuff we changed
let b:undo_ftplugin = "setlocal tw< cms< fo< iskeyword< keywordprg<" .
			\ " | unlet! b:browsefilter"

./ftplugin/ps1xml.vim	[[[1
31
" Vim filetype plugin file
" Language:           Windows PowerShell
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin") | finish | endif

" Don't load another plug-in for this buffer
let b:did_ftplugin = 1

setlocal tw=0
setlocal commentstring=#%s
setlocal formatoptions=tcqro

" Change the browse dialog on Win32 to show mainly PowerShell-related files
if has("gui_win32")
  let b:browsefilter = 
        \ "All PowerShell Files (*.ps1, *.psd1, *.psm1, *.ps1xml)\t*.ps1;*.psd1;*.psm1;*.ps1xml\n" .
        \ "PowerShell Script Files (*.ps1)\t*.ps1\n" .
        \ "PowerShell Module Files (*.psd1, *.psm1)\t*.psd1;*.psm1\n" .
        \ "PowerShell XML Files (*.ps1xml)\t*.ps1xml\n" .
        \ "All Files (*.*)\t*.*\n"
endif

" Undo the stuff we changed
let b:undo_ftplugin = "setlocal tw< cms< fo<" .
      \ " | unlet! b:browsefilter"

./indent/ps1.vim	[[[1
20
" Vim indent file
" Language:           Windows PowerShell
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327"

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

" smartindent is good enough for powershell
setlocal smartindent
" disable the indent removal for # marks
inoremap <buffer> # X#

let b:undo_indent = "setl si<"

./syntax/ps1.vim	[[[1
197
" Vim syntax file
" Language:           Windows PowerShell
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327"
"
" The following settings are available for tuning syntax highlighting:
"    let ps1_nofold_blocks = 1
"    let ps1_nofold_sig = 1
"    let ps1_nofold_region = 1

" Compatible VIM syntax file start
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" Operators contain dashes
setlocal iskeyword+=-

" PowerShell doesn't care about case
syn case ignore

" Sync-ing method
syn sync minlines=100

" Certain tokens can't appear at the top level of the document
syn cluster ps1NotTop contains=@ps1Comment,ps1CDocParam,ps1FunctionDeclaration

" Comments and special comment words
syn keyword ps1CommentTodo TODO FIXME XXX TBD HACK NOTE contained
syn match ps1CDocParam /.*/ contained
syn match ps1CommentDoc /^\s*\zs\.\w\+\>/ nextgroup=ps1CDocParam contained
syn match ps1CommentDoc /#\s*\zs\.\w\+\>/ nextgroup=ps1CDocParam contained
syn match ps1Comment /#.*/ contains=ps1CommentTodo,ps1CommentDoc,@Spell
syn region ps1Comment start="<#" end="#>" contains=ps1CommentTodo,ps1CommentDoc,@Spell

" Language keywords and elements
syn keyword ps1Conditional if else elseif switch default
syn keyword ps1Repeat while for do until break continue foreach in
syn match ps1Repeat /\<foreach\>/ nextgroup=ps1Block skipwhite
syn match ps1Keyword /\<while\>/ nextgroup=ps1Block skipwhite
syn match ps1Keyword /\<where\>/ nextgroup=ps1Block skipwhite

syn keyword ps1Exception begin process end exit inlinescript parallel sequence
syn keyword ps1Keyword try catch finally throw
syn keyword ps1Keyword return filter in trap param data dynamicparam 
syn keyword ps1Constant $true $false $null
syn match ps1Constant +\$?+
syn match ps1Constant +\$_+
syn match ps1Constant +\$\$+
syn match ps1Constant +\$^+

" Keywords reserved for future use
syn keyword ps1Keyword class define from using var

" Function declarations
syn keyword ps1Keyword function nextgroup=ps1Function skipwhite
syn keyword ps1Keyword filter nextgroup=ps1Function skipwhite
syn keyword ps1Keyword workflow nextgroup=ps1Function skipwhite
syn keyword ps1Keyword configuration nextgroup=ps1Function skipwhite
syn keyword ps1Keyword class nextgroup=ps1Function skipwhite
syn keyword ps1Keyword enum nextgroup=ps1Function skipwhite

" Function declarations and invocations
syn match ps1Cmdlet /\v(add|clear|close|copy|enter|exit|find|format|get|hide|join|lock|move|new|open|optimize|pop|push|redo|remove|rename|reset|search|select|Set|show|skip|split|step|switch|undo|unlock|watch)(-\w+)+/ contained
syn match ps1Cmdlet /\v(connect|disconnect|read|receive|send|write)(-\w+)+/ contained
syn match ps1Cmdlet /\v(backup|checkpoint|compare|compress|convert|convertfrom|convertto|dismount|edit|expand|export|group|import|initialize|limit|merge|mount|out|publish|restore|save|sync|unpublish|update)(-\w+)+/ contained
syn match ps1Cmdlet /\v(debug|measure|ping|repair|resolve|test|trace)(-\w+)+/ contained
syn match ps1Cmdlet /\v(approve|assert|build|complete|confirm|deny|deploy|disable|enable|install|invoke|register|request|restart|resume|start|stop|submit|suspend|uninstall|unregister|wait)(-\w+)+/ contained
syn match ps1Cmdlet /\v(block|grant|protect|revoke|unblock|unprotect)(-\w+)+/ contained
syn match ps1Cmdlet /\v(use)(-\w+)+/ contained

" Other functions
syn match ps1Function /\w\+\(-\w\+\)\+/ contains=ps1Cmdlet

" Type declarations
syn match ps1Type /\[[a-z_][a-z0-9_.,\[\]]\+\]/

" Variable references
syn match ps1ScopeModifier /\(global:\|local:\|private:\|script:\)/ contained
syn match ps1Variable /\$\w\+\(:\w\+\)\?/ contains=ps1ScopeModifier
syn match ps1Variable /\${\w\+\(:\?[[:alnum:]_()]\+\)\?}/ contains=ps1ScopeModifier

" Operators
syn keyword ps1Operator -eq -ne -ge -gt -lt -le -like -notlike -match -notmatch -replace -split -contains -notcontains
syn keyword ps1Operator -ieq -ine -ige -igt -ile -ilt -ilike -inotlike -imatch -inotmatch -ireplace -isplit -icontains -inotcontains
syn keyword ps1Operator -ceq -cne -cge -cgt -clt -cle -clike -cnotlike -cmatch -cnotmatch -creplace -csplit -ccontains -cnotcontains
syn keyword ps1Operator -in -notin
syn keyword ps1Operator -is -isnot -as -join
syn keyword ps1Operator -and -or -not -xor -band -bor -bnot -bxor
syn keyword ps1Operator -f
syn match ps1Operator /!/
syn match ps1Operator /=/
syn match ps1Operator /+=/
syn match ps1Operator /-=/
syn match ps1Operator /\*=/
syn match ps1Operator /\/=/
syn match ps1Operator /%=/
syn match ps1Operator /+/
syn match ps1Operator /-\(\s\|\d\|\.\|\$\|(\)\@=/
syn match ps1Operator /\*/
syn match ps1Operator /\//
syn match ps1Operator /|/
syn match ps1Operator /%/
syn match ps1Operator /&/
syn match ps1Operator /::/
syn match ps1Operator /,/
syn match ps1Operator /\(^\|\s\)\@<=\. \@=/

" Regular Strings
" These aren't precisely correct and could use some work
syn region ps1String start=/["\u201c-\u201e]/ skip=/`["\u201c-\u201e]/ end=/["\u201c-\u201e]/ contains=@ps1StringSpecial,@Spell
syn region ps1String start=/['\u2018-\u201b]/ end=/['\u2018-\u201b]/

" Here-Strings
syn region ps1String start=/@["\u201c-\u201e]$/ end=/^["\u201c-\u201e]@/ contains=@ps1StringSpecial,@Spell
syn region ps1String start=/@['\u2018-\u201b]$/ end=/^['\u2018-\u201b]@/

" Interpolation
syn match ps1Escape /`./
syn region ps1Interpolation matchgroup=ps1InterpolationDelimiter start="$(" end=")" contained contains=ALLBUT,@ps1NotTop
syn region ps1NestedParentheses start="(" skip="\\\\\|\\)" matchgroup=ps1Interpolation end=")" transparent contained
syn cluster ps1StringSpecial contains=ps1Escape,ps1Interpolation,ps1Variable,ps1Boolean,ps1Constant,ps1BuiltIn,@Spell

" Numbers
syn match   ps1Number		"\(\<\|-\)\@<=\(0[xX]\x\+\|\d\+\)\([KMGTP][B]\)\=\(\>\|-\)\@="
syn match   ps1Number		"\(\(\<\|-\)\@<=\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[dD]\="
syn match   ps1Number		"\<\d\+[eE][-+]\=\d\+[dD]\=\>"
syn match   ps1Number		"\<\d\+\([eE][-+]\=\d\+\)\=[dD]\>"

" Constants
syn match ps1Boolean "$\%(true\|false\)\>"
syn match ps1Constant /\$null\>/
syn match ps1BuiltIn "$^\|$?\|$_\|$\$"
syn match ps1BuiltIn "$\%(args\|error\|foreach\|home\|input\)\>"
syn match ps1BuiltIn "$\%(match\(es\)\?\|myinvocation\|host\|lastexitcode\)\>"
syn match ps1BuiltIn "$\%(ofs\|shellid\|stacktrace\)\>"

" Named Switch
syn match ps1Label /\s-\w\+/

" Folding blocks
if !exists('g:ps1_nofold_blocks')
	syn region ps1Block start=/{/ end=/}/ transparent fold
endif

if !exists('g:ps1_nofold_region')
	syn region ps1Region start=/#region/ end=/#endregion/ transparent fold keepend extend
endif

if !exists('g:ps1_nofold_sig')
	syn region ps1Signature start=/# SIG # Begin signature block/ end=/# SIG # End signature block/ transparent fold
endif

" Setup default color highlighting
if version >= 508 || !exists("did_ps1_syn_inits")
	if version < 508
		let did_ps1_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink ps1Number Number
	HiLink ps1Block Block
	HiLink ps1Region Region
	HiLink ps1Exception Exception
	HiLink ps1Constant Constant
	HiLink ps1String String
	HiLink ps1Escape SpecialChar
	HiLink ps1InterpolationDelimiter Delimiter
	HiLink ps1Conditional Conditional
	HiLink ps1Cmdlet Function
	HiLink ps1Function Identifier
	HiLink ps1Variable Identifier
	HiLink ps1Boolean Boolean
	HiLink ps1Constant Constant
	HiLink ps1BuiltIn StorageClass
	HiLink ps1Type Type
	HiLink ps1ScopeModifier StorageClass
	HiLink ps1Comment Comment
	HiLink ps1CommentTodo Todo
	HiLink ps1CommentDoc Tag
	HiLink ps1CDocParam Identifier
	HiLink ps1Operator Operator
	HiLink ps1Repeat Repeat
	HiLink ps1RepeatAndCmdlet Repeat
	HiLink ps1Keyword Keyword
	HiLink ps1KeywordAndCmdlet Keyword
	HiLink ps1Label Label
	delcommand HiLink
endif

let b:current_syntax = "ps1"
./syntax/ps1xml.vim	[[[1
56
" Vim syntax file
" Language:           Windows PowerShell XML
" Maintainer:         Peter Provost <peter@provost.org>
" Version:            2.10
" Project Repository: https://github.com/PProvost/vim-ps1
" Vim Script Page:    http://www.vim.org/scripts/script.php?script_id=1327"

" Compatible VIM syntax file start
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:ps1xml_cpo_save = &cpo
set cpo&vim

doau syntax xml
unlet b:current_syntax

syn case ignore
syn include @ps1xmlScriptBlock <sfile>:p:h/ps1.vim
unlet b:current_syntax

syn region ps1xmlScriptBlock
      \ matchgroup=xmlTag     start="<Script>"
      \ matchgroup=xmlEndTag  end="</Script>"
      \ fold
      \ contains=@ps1xmlScriptBlock
      \ keepend
syn region ps1xmlScriptBlock
      \ matchgroup=xmlTag     start="<ScriptBlock>"
      \ matchgroup=xmlEndTag  end="</ScriptBlock>"
      \ fold
      \ contains=@ps1xmlScriptBlock
      \ keepend
syn region ps1xmlScriptBlock
      \ matchgroup=xmlTag     start="<GetScriptBlock>"
      \ matchgroup=xmlEndTag  end="</GetScriptBlock>"
      \ fold
      \ contains=@ps1xmlScriptBlock
      \ keepend
syn region ps1xmlScriptBlock
      \ matchgroup=xmlTag     start="<SetScriptBlock>"
      \ matchgroup=xmlEndTag  end="</SetScriptBlock>"
      \ fold
      \ contains=@ps1xmlScriptBlock
      \ keepend

syn cluster xmlRegionHook add=ps1xmlScriptBlock

let b:current_syntax = "ps1xml"

let &cpo = s:ps1xml_cpo_save
unlet s:ps1xml_cpo_save

