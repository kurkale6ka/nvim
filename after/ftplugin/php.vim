let php_folding    = 3
let php_large_file = 0

let b:surround_{char2nr('E')} = "<?php echo \r ?>"
let b:surround_{char2nr('+')} = "<?php echo '\r' ?>"
let b:surround_{char2nr('-')} = "<?php \r ?>"
let b:surround_{char2nr('v')} = "var_dump(\r)"
let b:surround_{char2nr('t')} = "try { \r } catch (Exception $e) {$e->getMessage();}"

set makeprg=php\ -l\ %\ $*
set errorformat=%E%m\ in\ %f\ on\ line\ %l,%Z%m
