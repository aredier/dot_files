if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" general setings ####################################################
set number
syntax enable
" ignore python cache files
set wildignore=*/__pycache__,*/.git,*/.hg,*/.svn,.cache,.DS_Store,*.idea,*/*.o,*/

" matching characters
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
inoremap { {}<Esc>i
imap <C-j> <Enter><Esc>kA<Enter>
" get out of insert mode automaticly"

let s:on = 0
function ToggleSetUp()
   echo "setting up auto go out of insert"
   let cmd = "CursorHoldI * stopinsert"
   if !s:on
      exec "au" cmd
      let s:saveupdatetime = &updatetime
      let &updatetime = 2000
   else
      exec "au!" cmd
      let &updatetime = s:saveupdatetime
   endif
   let s:on = !s:on
endfunction


nmap ,s :call ToggleSetUp()<cr> 

" highlight lines to long"
nnoremap  <Leader>H :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>80v/
fun! s:LongLineHLToggle()
 if !exists('w:longlinehl')
  let w:longlinehl = matchadd('ErrorMsg', '.\%>120v', 0)
 else
  call matchdelete(w:longlinehl)
  unl w:longlinehl
 endif
endfunction
call s:LongLineHLToggle() 

" undo persistent files 
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
  endif

" formating
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
au BufNewFile,BufRead *.js
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
au BufNewFile,BufRead *.vue
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
set encoding=utf-8

" plugins ###########################################################
call plug#begin()

" ipython integration
Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_no_mappings = 1
let g:slime_paste_file = "/tmp/.slime_paste"
let g:slime_preserve_curpos = 1
let g:slime_dont_ask_default = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ":.0"}
nmap <leader>l <Plug>SlimeLineSend<cr>
xmap <space> <Plug>SlimeRegionSend
nmap <space> <Plug>SlimeParagraphSend

" fuzy file search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
map , :Files<CR>

" search in files
Plug 'mileszs/ack.vim'
" search and replace
Plug 'skwp/greplace.vim'

" powerline
Plug 'itchyny/lightline.vim'
set laststatus=2

" multiple cursor
Plug 'terryma/vim-multiple-cursors'

" unix emulation
Plug 'tpope/vim-eunuch'

" surounding
Plug 'tpope/vim-surround'

" nerd tree
Plug 'scrooloose/nerdtree'
let NERDTreeRespectWildIgnore=1
map <C-o> :NERDTreeToggle<CR>

" linters
Plug 'w0rp/ale'
let b:ale_fixers = {"python": ["pylint", "flake8"], 'javascript': ['eslint']}
let g:ale_python_pylint_options = "--init-hook='import sys; sys.path.append(\".\")'"

" colorscheme
Plug 'vim-python/python-syntax'
let g:python_version_2 = 0
let b:python_version_2 = 0
let g:python_highlight_all = 1
Plug 'posva/vim-vue'
Plug 'morhetz/gruvbox'
set t_Co=256
colorscheme gruvbox
set background=dark

" docstring formating
Plug 'heavenshell/vim-pydocstring'
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" git 
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" indentation
Plug 'vim-scripts/indentpython.vim'
let g:SimpylFold_docstring_preview=1

" auto complete
Plug 'davidhalter/jedi-vim'
let g:jedi#goto_command = "<C-g>"
let g:jedi#usages_command = "<C-u>"
Plug 'ervandew/supertab'
filetype plugin indent on

" comment sections
Plug 'scrooloose/nerdcommenter'
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'

" autosave
Plug '907th/vim-auto-save'
let g:auto_save = 1  " enable AutoSave on Vim startup

" javascript support
Plug 'ternjs/tern_for_vim'
Plug 'moll/vim-node'
Plug 'pangloss/vim-javascript' , { 'for': ['javascript', 'javascript.jsx', 'html', 'vue'] }


call plug#end()

" syntax ####################################################
" highlight the self keyword
" augroup self_py
	" autocmd!
	" autocmd Syntax python syn match pythonBoolean "\(\W\|^\)\@<=self\(\,\)\@=" 
	" autocmd Syntax python syn match pythonBoolean "\(\W\|^\)\@<=self\(\.\)\@=" 
" augroup end
