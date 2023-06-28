" Vimball Archiver by Charles E. Campbell
UseVimball
finish
./README.md	[[[1
29
# hcl.vim

Syntax highlighting for [HashiCorp Configuration Language (HCL)][HCL] used by
[Consul][], [Nomad][], [Packer][], [Terraform][], and [Vault][].

  [HCL]: https://github.com/hashicorp/hcl
  [Consul]: https://www.consul.io/
  [Nomad]: https://www.nomadproject.io/
  [Packer]: https://packer.io/
  [Terraform]: https://www.terraform.io/
  [Vault]: https://www.vaultproject.io/

## Installation

Install using Vim's built-in package support:
```
mkdir -p ~/.vim/pack/jvirtanen/start
cd ~/.vim/pack/jvirtanen/start
git clone https://github.com/jvirtanen/vim-hcl.git
```

## License

Copyright 2018 Jussi Virtanen and [contributors][].

  [contributors]: https://github.com/jvirtanen/vim-hcl/graphs/contributors

Distributed under the same terms as Vim itself. See `:help license` for
details.
./ftdetect/hcl.vim	[[[1
8
autocmd BufNewFile,BufRead *.hcl set filetype=hcl

" Nomad
autocmd BufNewFile,BufRead *.nomad set filetype=hcl

" Terraform
autocmd BufNewFile,BufRead *.tf     set filetype=hcl
autocmd BufNewFile,BufRead *.tfvars set filetype=hcl
./syntax/hcl.vim	[[[1
61
" Vim syntax file
" Language:   HashiCorp Configuration Language (HCL)
" Maintainer: Jussi Virtanen
" Repository: https://github.com/jvirtanen/vim-hcl
" License:    Vim

if exists('b:current_syntax')
  finish
end

syn match hclVariable /\<[A-Za-z0-9_.\[\]*]\+\>/

syn match hclParenthesis /(/
syn match hclFunction    /\w\+(/ contains=hclParenthesis

syn keyword hclKeyword for in if

syn region hclString start=/"/ end=/"/ contains=hclEscape,hclInterpolation
syn region hclString start=/<<-\?\z([A-Z]\+\)/ end=/^\s*\z1/ contains=hclEscape,hclInterpolation

syn match hclEscape /\\n/
syn match hclEscape /\\r/
syn match hclEscape /\\t/
syn match hclEscape /\\"/
syn match hclEscape /\\\\/
syn match hclEscape /\\u\x\{4\}/
syn match hclEscape /\\u\x\{8\}/

syn match hclNumber /\<\d\+\%([eE][+-]\?\d\+\)\?\>/
syn match hclNumber /\<\d*\.\d\+\%([eE][+-]\?\d\+\)\?\>/
syn match hclNumber /\<0[xX]\x\+\>/

syn keyword hclConstant true false null

syn region hclInterpolation start=/\${/ end=/}/ contained contains=hclInterpolation

syn region hclComment start=/\/\// end=/$/    contains=hclTodo
syn region hclComment start=/\#/   end=/$/    contains=hclTodo
syn region hclComment start=/\/\*/ end=/\*\// contains=hclTodo

syn match hclAttributeName /\w\+/ contained
syn match hclAttribute     /^[^=]\+=/ contains=hclAttributeName,hclComment,hclString

syn match hclBlockName /\w\+/ contained
syn match hclBlock     /^[^=]\+{/ contains=hclBlockName,hclComment,hclString

syn keyword hclTodo TODO FIXME XXX DEBUG NOTE contained

hi def link hclVariable      PreProc
hi def link hclFunction      Function
hi def link hclKeyword       Keyword
hi def link hclString        String
hi def link hclEscape        Special
hi def link hclNumber        Number
hi def link hclConstant      Constant
hi def link hclInterpolation PreProc
hi def link hclComment       Comment
hi def link hclTodo          Todo
hi def link hclBlockName     Structure

let b:current_syntax = 'hcl'
