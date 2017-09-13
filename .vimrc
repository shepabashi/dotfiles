if has('vim_starting')
  set nocompatible
endif

"================================
" Plugins
"================================
call plug#begin('~/.vim/plugged')

" General
Plug 'Shougo/neocomplete'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-surround'

" Git
Plug 'tpope/vim-fugitive'

" Go
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}

" HTML5
Plug 'mattn/emmet-vim', {'for': ['html', 'css', 'jsx']}
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'hail2u/vim-css3-syntax', {'for': ['html', 'css']}

" Javascript
Plug 'pangloss/vim-javascript', {'for': ['html', 'javascript', 'jsx']}
Plug 'maxmellon/vim-jsx-pretty', {'for': ['javascript', 'jsx']}
Plug 'ternjs/tern_for_vim', {'for': ['javascript', 'javascript.jsx'], 'do': 'npm install'}

" Python
Plug 'davidhalter/jedi-vim', {'for': 'python'}

call plug#end()

"================================
" Settings
"================================
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/scripts/basic.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/scripts/plugin.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/.vim/scripts/keybind.vim'
