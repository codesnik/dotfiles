"    Copyright: Copyright (C) 2007 Stephen Bach
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               lusty-explorer.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
"
" Name Of File: lusty-explorer.vim
"  Description: Dynamic Filesystem and Buffer Explorer Vim Plugin
"   Maintainer: Stephen Bach <sjbach@users.sourceforge.net>
" Contributors: Raimon Grau, Sergey Popov, Yuichi Tateno, Bernhard Walle,
"               Rajendra Badapanda
"
" Release Date: Thursday, November 4, 2007
"      Version: 1.4.1
"               Inspired by Viewglob, Emacs, and by Jeff Lanzarotta's Buffer
"               Explorer plugin.
"
"        Usage: To launch the explorers:
"
"                 <Leader>lf  - Opens the filesystem explorer.
"                 <Leader>lr  - Opens the filesystem explorer from the parent
"                               directory of the current file.
"                 <Leader>lb  - Opens the buffer explorer.
"
"               You can also use the commands:
"
"                 ":FilesystemExplorer"
"                 ":FilesystemExplorerFromHere"
"                 ":BufferExplorer"
"
"               (Personally, I map these to ,f and ,r and ,b)
"
"               The interface is intuitive.  When one of the explorers is
"               launched, a new window appears at bottom presenting a list of
"               files/dirs or buffers, and in the status bar is a prompt:
"
"                 >>
"
"               As you type or tab-complete a name, the list updates for
"               possible matches.  When there is enough input to match an
"               entry uniquely, press <ENTER> or <TAB> to open it in your last
"               used window, or press <ESC>, <Ctrl-c> or <Ctrl-g> to cancel.
"
"               Matching is case-insensitive unless a capital letter appears
"               in the input (similar to "smartcase" mode in Vim).
"
" Buffer Explorer:
"  - Matching is done anywhere in name.
"  - Entries are listed in MRU (most recently used) order.
"  - The currently active buffer is highlighted.
"
" Filesystem Explorer:
"  - Matching is done at beginning of name.
"  - Entries are listed in alphabetical order.
"  - All opened files are highlighted.
"
"  - You can recurse into and out of directories by typing the directory name
"    and a slash, e.g. "stuff/" or "../".
"  - Variable expansion, e.g. "$D" -> "/long/dir/path/".
"  - Tilde (~) expansion, e.g. "~/" -> "/home/steve/".
"  - <Shift-Enter> will load all files appearing in the current list
"    (in gvim only).
"  - Hidden files are shown by typing the first letter of their names
"    (which is ".").
"
"  You can prevent certain files from appearing in the directory listings with
"  the following variable:
"
"    let g:LustyExplorerFileMasks = "*.o,*.fasl,CVS"
"
"  The above example will mask all object files, compiled lisp files, and
"  files/directories named CVS from appearing in the filesystem explorer.
"  Note that they can still be opened by being named explicitly.
"
"
" Install Details:
"
" Copy this file into your $HOME/.vim/plugin directory so that it will be
" sourced on startup automatically.
"
" Note! This plugin requires Vim be compiled with Ruby interpretation.  If you
" don't know if your build of Vim has this functionality, you can check by
" running "vim --version" from the command line and looking for "+ruby".
" Alternatively, just try sourcing this script.
"
" If your version of Vim does not have "+ruby" but you would still like to
" use this plugin, you can fix it.  See the "Check for Ruby functionality"
" comment below for instructions.
"
" If you are using the same Vim configuration and plugins for multiple
" machines, some of which have Ruby and some of which don't, you may want to
" turn off the "Sorry, LustyExplorer requires ruby" warning.  You can do so
" like this (in .vimrc):
"
"   let g:LustyExplorerSuppressRubyWarning = 1
"
"
" TODO:
" - when an edited file is in nowrap mode and the explorer is called while the
"   current window is scrolled to the right, name truncation occurs.
" - bug: NO ENTRIES is not red when input is a space
"   - happens because LustyExpMatch declares after LustyExpNoEntries.
" - if new_hash == previous_hash, don't bother 'repainting'.
" - add globbing?
"   - also add a lock key which will make the stuff that currently appears
"     listed the basis for the next match attempt.
"   - (also unlock key)

" Exit quickly when already loaded.
if exists("g:loaded_lustyexplorer")
  finish
endif

" Check for Ruby functionality.
if !has("ruby")
  if !exists("g:LustyExplorerSuppressRubyWarning") ||
     \ g:LustyExplorerSuppressRubyWarning == "0"
  if !exists("g:LustyJugglerSuppressRubyWarning") ||
      \ g:LustyJugglerSuppressRubyWarning == "0" 
    echohl ErrorMsg
    echon "Sorry, LustyExplorer requires ruby.  "
    echon "Here are some tips for adding it:\n"

    echo "Debian / Ubuntu:"
    echo "    # apt-get install vim-ruby\n"

    echo "Fedora:"
    echo "    # yum install vim-enhanced\n"

    echo "Gentoo:"
    echo "    # USE=\"ruby\" emerge vim\n"

    echo "FreeBSD:"
    echo "    # pkg_add -r vim+ruby\n"

    echo "Windows:"
    echo "    1. Download and install Ruby from here:"
    echo "       http://www.ruby-lang.org/"
    echo "    2. Install a Vim binary with Ruby support:"
    echo "       http://hasno.info/2007/5/18/windows-vim-7-1-2\n"

    echo "Manually (including Cygwin):"
    echo "    1. Install Ruby."
    echo "    2. Download the Vim source package (say, vim-7.0.tar.bz2)"
    echo "    3. Build and install:"
    echo "         # tar -xvjf vim-7.0.tar.bz2"
    echo "         # ./configure --enable-rubyinterp"
    echo "         # make && make install"
    echohl none
  endif
  endif
  finish
endif

let g:loaded_lustyexplorer = "yep"

" Commands.
command BufferExplorer :call <SID>BufferExplorerStart()
command FilesystemExplorer :call <SID>FilesystemExplorerStart()
command FilesystemExplorerFromHere :call <SID>FilesystemExplorerStartFromHere()

" Default mappings.
nmap <silent> <Leader>lf :FilesystemExplorer<CR>
nmap <silent> <Leader>lr :FilesystemExplorerFromHere<CR>
nmap <silent> <Leader>lb :BufferExplorer<CR>

" Old mappings (from DynamicExplorer).
nmap <silent> <Leader>df :FilesystemExplorer<CR>
nmap <silent> <Leader>db :BufferExplorer<CR>

" Vim-to-ruby function calls.
function! s:FilesystemExplorerStart()
  ruby $filesystem_explorer.run
endfunction

function! s:FilesystemExplorerStartFromHere()
  ruby $filesystem_explorer.run_from_here
endfunction

function! s:BufferExplorerStart()
  ruby $buffer_explorer.run
endfunction

function! FilesystemExplorerCancel()
  ruby $filesystem_explorer.cancel
endfunction

function! BufferExplorerCancel()
  ruby $buffer_explorer.cancel
endfunction

function! FilesystemExplorerKeyPressed(code_arg)
  ruby $filesystem_explorer.key_pressed
endfunction

function! BufferExplorerKeyPressed(code_arg)
  ruby $buffer_explorer.key_pressed
endfunction

" Setup the autocommands that handle buffer MRU ordering.
augroup LustyExplorer
  autocmd!
  autocmd BufEnter * ruby Window.buffer_stack.push
  autocmd BufDelete * ruby Window.buffer_stack.pop
  autocmd BufWipeout * ruby Window.buffer_stack.pop
augroup End


ruby << EOF
require '~/.vim/plugin/lusty-explorer'
EOF

