vim.cmd([[
let b:surround_{char2nr('1')} = "\\section{\r}"
let b:surround_{char2nr('2')} = "\\subsection{\r}"
let b:surround_{char2nr('3')} = "\\subsubsection{\r}"
let b:surround_{char2nr('b')} = "\\textbf{\r}"
let b:surround_{char2nr('e')} = "\\emph{\r}"
let b:surround_{char2nr('l')} = "\\\1command: \1{\r}"
let b:surround_{char2nr('m')} = "\\begin{math} \r \\end{math}"
let b:surround_{char2nr('M')} = "\\begin{math}\\displaystyle \r \\end{math}"
let b:surround_{char2nr('E')} = "\\begin{equation} \r \\end{equation}"
let b:surround_{char2nr('d')} = "\\begin{displaymath} \r \\end{displaymath}"
let b:surround_{char2nr('p')} = "\\left( \r \\right)"

iabbrev latex \latex{}
]])
