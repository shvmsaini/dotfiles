" for custom vim location
" set runtimepath+=~/.config/vim,~/.config/vim/after
" let rtp=&runtimepath
" set runtimepath=~/.config/vim
" let &runtimepath.=','.rtp.',~/.config/vim/after'
" set viminfo+=n~/.config/.vim/viminfo

call plug#begin('~/.vim/plugged')
	Plug 'ap/vim-css-color'
	Plug 'vim-airline/vim-airline'
	Plug 'scrooloose/nerdtree'
	Plug 'dylanaraps/wal.vim'
call plug#end()

" General Settings 
set autoread
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
syntax on
set mouse=a 			" Visual Mode Text Selection with mouse
set spelllang=en_US
set shiftwidth=5
set tabstop=5
set nu				" Show row numbers
set visualbell			" Disable screen flash bells
set t_vb=				" Disable audio bells
set rnu				" Show relative line number

" Styling Settings 
set background=dark
set termguicolors
set term=kitty
colorscheme wal
" highlight Comment cterm=italic gui=italic
highlight LineNr guifg=#808080
if has("gui_running")
    	colorscheme slate
endif

" Mapping
map <F6> :!g++ -std=c++2a -Wall -Wextra -O2 % -o %:r && %:r <CR>
imap <Insert> <Nop>
nnoremap <A-j> :m .+2<CR>==
nnoremap <A-k> :m .-1<CR>==
inoremap <A-j> <Esc>:m .+2<CR>==gi
inoremap <A-k> <Esc>:m .-1<CR>==gi
vnoremap <A-j> :m '>+2<CR>gv=gv
vnoremap <A-k> :m '<-1<CR>gv=gv
nnoremap <C-A> ggVG
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnoremap <C-c> "+y
nnoremap <C-S-v> "+p
nmap <Del> x
nmap <Ctrl-V><Del> x
imap <Ctrl-V><Del> <Ctrl-V><Esc>lxi
nnoremap q: :exit

" Font Size Script 
if has("unix")
	function! FontSizePlus ()
		let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
		let l:gf_size_whole = l:gf_size_whole + 2
		let l:new_font_size = ' '.l:gf_size_whole
		let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
	endfunction

	function! FontSizeMinus ()
		let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
		let l:gf_size_whole = l:gf_size_whole - 2
		let l:new_font_size = ' '.l:gf_size_whole
		let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
	endfunction
endif


if has("gui_running")
	nmap <S-F13> :call FontSizeMinus()<CR>
	nmap <F13> :call FontSizePlus()<CR>
endif
