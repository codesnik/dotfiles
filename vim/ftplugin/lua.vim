setl sw=4
set shiftround
setl smarttab
setl expandtab

map <buffer> <f3> :s/^/-- /<CR>:noh<CR>
map <buffer> <S-f3> :s/^\(\s*\)-- /\1/<CR>:noh<CR>
set foldmethod=marker
