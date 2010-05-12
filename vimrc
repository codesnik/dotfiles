if $TERM =~ 'xterm'
    " ugliest amd most seamless way to make 256 colors work
    set t_Co=256

    " some terminals on BSD may require that
    
    set <S-F1>=O1;2P 
    set <S-F2>=O1;2Q 
    set <S-F3>=O1;2R 
    set <S-F4>=O1;2S 
end


"se keymap=russian-jcukenwin
se noimd
se imi=0
se imsearch=0
"imap <C-L> <C-^>
"cmap <C-L> <C-^>

"colorscheme desert
colorscheme railscasts
syntax on
"se guifont=Consolas\ 11
se encoding=utf8

map <leader>. :split ~/.vimrc<cr>
map <leader>e :Explore<cr>
"map <leader><leader> :Project<cr>
map <leader><leader> :NERDTreeToggle<cr>
se guioptions=aegir
se mouse+=a

se incsearch
"se columns=120
"se lines=40
set ignorecase smartcase
set noequalalways
set confirm
set linebreak
set virtualedit=block

set fencs=ucs-bom,utf-8,cp1251

map <Tab> >>
map <S-Tab> <<
vmap <Tab> >gv
vmap <S-Tab> <gv
" thoose above make ^I unusable :( so let's replace it!
noremap g <C-I>

let g:proj_flags='mstTgv'

set nojoinspaces
se nowrapscan

se switchbuf=usetab

map Y y$

map <f2> :w<cr>
"imap <f2> :w<cr>
imap <f2> <esc>:w<cr>

map <S-f4> :Sex<cr>
map <f4> :Ex<cr>

map <f5> :make<cr>
"map <S-f5> :cw<cr>
map <S-f5> :cfile log/lasterror<cr>
map <C-f5> :Rake!<cr>
map <M-f5> :Rake!<cr>
se fillchars=

se ai
se sw=4
se ts=8
se expandtab
se smarttab
se bs=indent,eol,start

let g:netrw_silent=1

"python from vim import *

map gc :TlistOpen<cr>
let Tlist_Close_On_Select=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Inc_Winwidth=1
let Tlist_Use_SingleClick=1
let Tlist_Use_Right_Window=1

" autoread config
if !exists("autoload_vimrc")
  let autoload_vimrc = 1
  au BufWritePost .vimrc so %
endif


se autowrite
se backup
se backupdir=~/.backup,.

noremap ' `
let g:SuperTabRetainCompletionType=2

" from debian config
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

filetype plugin on
filetype indent on



se hlsearch
"set statusline=%<%f\ %{VCSCommandGetStatusLine()}\ %h%m%r%=%l,%c%V\ %P
"let VCSCommandEnableBufferSetup=1
se laststatus=2
set statusline=%1*%n\ %*\ %<%f\ %h%=%1*\ %W%Y%R%m\ %*%10(%c\ %l/%L%)\ %2*%P
hi User1 ctermbg=black ctermfg=8 cterm=bold
set wildmenu

map ` <esc>
map! ` <esc>

" no intro message
se shortmess+=I

au Filetype html,xml,xsl,eruby run macros/closetag.vim

map <F3><F3> <F3>l
let NERDMapleader="<F3>"
let NERDDefaultNesting=1
let NERDShutUp=1
let NERDSpaceDelims=1

"DBSetOption MYSQL_cmd_options=-t
"
" закончить как-нить эту прыгалку по файлам
" map / \p:se wrapscan<cr>zi/
" map <esc> :se nowrapscan<cr>zic<esc>
" cmap <space> .*
" map <enter> :se nowrapscan<cr>zi<enter>

se pt=<F10>
" tried to become more 10fingered
"map h <nop>
"map l <nop>


se clipboard=autoselect,unnamed,exclude:cons\|linux
" open project window only if there's enough space for it
" don't like it anymore
"if &columns > 100
"    au VimEnter *  Project
"    au VimEnter *  wincmd p 
"endif

" for lusty explorer
"map ,r \lr
"map ,b \lb
"map ,, \lb
"map ,f \lf


" show linebreak marker
se cpoptions+=n
se showbreak=»


let g:proj_run_fold1="lcd %h|sh"
let g:proj_run8="!rm -i %f"

" writing swap file when one second idle, also used by plugins autofollow
set updatetime=1000

"set grepprg=git\ grep\ -n
set grepprg=ack

"autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=gitcommit

"autocmd FileType gitcommit DiffGitCached | wincmd w
au BufWinEnter quickfix map <buffer> p <C-W><CR>
set history=200
set list listchars=tab:»·,trail:·

let g:browser = 'firefox -new-tab '
"let g:browser = 'safari -new-tab '
" Open the Ruby ApiDock page for the word under cursor, in a new Firefox tab
function! OpenRubyDoc(keyword)
  let url = 'http://apidock.com/ruby/'.a:keyword
  exec 'silent !'.g:browser.' '.url.' &'
 redraw!
endfunction
noremap RB :call OpenRubyDoc(expand('<cword>'))<CR>

" Open the Rails ApiDock page for the word under cursos, in a new Firefox tab
function! OpenRailsDoc(keyword)
 let url = 'http://apidock.com/rails/'.a:keyword
 exec 'silent !'.g:browser.' '.url.' &'
 redraw!
endfunction
noremap RR :call OpenRailsDoc(expand('<cword>'))<CR>

map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
map <D-0> :tablast<cr>


"compiler rubyunit
"nmap <Leader>fd :cf /tmp/autotest.txt<cr> :compiler rubyunit<cr>

let g:netrw_liststyle=3

" copy filename to clipboard
nmap cp :let @* = expand("%:p")<cr>:file<cr>

" command for rails.vim on osx
command! -bar -nargs=1 OpenURL :!open <args>

command! -bar GitGrep :se grepprg=git\ grep\ -n
command! -bar AckGrep :se grepprg=ack

"map <C-M> :

map <F1> :Rfind 
cmap <F1> <C-c>

" join haml lines
" g/^\s*[^% ]/normal kJ

