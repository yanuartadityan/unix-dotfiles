set backspace=2
set tabstop=4
set nu
set relativenumber
set mouse=a

" plugins
set nocompatible
filetype off

set rtp +=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'elzr/vim-json'
Plugin 'stephpy/vim-yaml'
Plugin 'tpope/vim-fugitive'
call vundle#end()
filetype plugin indent on

com! FormatJSON %!python -m json.tool
" shortcuts
imap jj <Esc>
