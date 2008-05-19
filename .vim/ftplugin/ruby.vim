"setl makeprg=perl\ c:/home/vimfiles/tools/efm_perl.pl\ -c\ %\ $*
"setl makeprg=ruby\ %\ $*
"setl makeef&
"setl errorformat=%f:%l:%m 

setl sw=2
set shiftround
setl smarttab
setl expandtab
se ts=2

"map <buffer> <f3> :s/^/#/<CR>:noh<CR>
"map <buffer> <S-f3> :s/^\(\s*\)#/\1/<CR>:noh<CR>

" setl foldcolumn=1

setl ff=unix

setl ai 
setl number 
" add ? to keyword delimiters. do not add !, cause !blank? is too common
setl iskeyword=@,48-57,_,192-255,?
so ~/.vim/ftplugin/ri.vim
