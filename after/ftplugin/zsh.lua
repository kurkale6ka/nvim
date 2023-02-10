-- UltiSnips wrongly detects sh in addition to my zsh snippets.
-- A *sh.snippets detection must be happening
-- and that * also matches z, so zsh.snippets
-- The problem is then that I am always proposed with:
-- 1. expand from sh snippets
-- 2. expand from zsh snippets
-- This is why I moved zsh snippets to their own directory
-- TODO: raise an issue
vim.b.UltiSnipsSnippetDirectories = { 'conflictingUltiSnips' }
