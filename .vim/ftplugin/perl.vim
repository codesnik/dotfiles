"setl makeprg=perl\ c:/home/vimfiles/tools/efm_perl.pl\ -c\ %\ $*
" setl makeprg=perl\ -MVi::QuickFix\ -c\ %\ $*
" setl shellpipe=
" setl makeef=errors.err
" setl errorformat=%f:%l:%m 
setl sw=4
set shiftround
setl smarttab
setl expandtab

map <buffer> <f3> :s/^/#/<CR>:noh<CR>
map <buffer> <S-f3> :s/^\(\s*\)#/\1/<CR>:noh<CR>
"map <buffer> <f9> :w<cr>:silent !start cmd /c perl -Mcp866 % 2>&1 \|less<cr>:<cr>
"map! <buffer> <f9> <esc>:w<cr>:silent !start cmd /c perl -Mcp866 % 2>&1 \|less<cr>:<cr>

imap <M-.> -><left><left><C-left>$<C-right><right><right$>

setl foldtext=MyPerlFold()
setl foldcolumn=1
"if !exists("perlpath")
	"let perlpath = ',c:/src/lib,C:/usr/lib,c:/usr/site/lib'
"endif

setl ff=unix
setl equalprg=perltidy
setl iskeyword+=:
"run pdoc4vim.vim

"-----
"
if exists("*MyPerlFold")
  finish
endif

function! MyPerlFold()
        let line = getline(v:foldstart)
"       let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
"       return v:folddashes . sub
       return line . '  (' . (v:foldend-v:foldstart) . ')'
"return v:folddashes . ' ' . line . '  (' . (v:foldend-v:foldstart) . ')-'
endfunction

setl ai 
setl number 
