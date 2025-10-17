-- " Example of global projections where the root is HOME
-- "
-- " When no .projections.json is created,
-- " the value of projectionist#path() is HOME, regardless of the 'path option.
-- " Not sure where it's set...
-- "
-- " All paths must be relative to root (HOME in this example)
-- " With 'type: script', we get the new :Escript command
-- let g:projectionist_heuristics = {
--         \ "repos/github/scripts/": {
--         \   "repos/github/scripts/*.pl": {"type": "script"}
--         \ }}

return {
    'tpope/vim-projectionist',
}
