" .vimrc

" Load Pathogen
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" Contine with option setting

set timeoutlen=500								" Shift+O isn't quite so slow, but keep it reasonably long so leader works
set mouse=a										" Enable console mouse support
set nocp 										" Disable vi compatibility
set nohls incsearch								" No highlight of search terms, no need to press enter
set autoindent smartindent 						" Autoindent
set tabstop=4 shiftwidth=4						" 4-tabs
set showmatch mat=2								" Switch briefly to opposite (/[/etc for 0.2 sec
set ruler										" Show cursor pos.
set novisualbell 								" Visual bell looks ugly on GUI
set guioptions=ac t_Co=256						" Minimal GUI, 256 colour
set showcmd										" Some more info in bottom-right corner
set wildmenu wildmode=list:longest,full			" Tab-completion at :
set hid											" Change buffer w/o saving
set ignorecase smartcase						" Case-insensitive search (when necessary)
set magic										" Yay special search chars
set background=dark								" It probably will be
set encoding=utf8								" Just in case Unicode gets mucked up.
set nobackup noswapfile							" Swapfiles are just annoying; and I don't need x~ everywhere
set title										" Give terminal a title
set scrolloff=3									" Move down a few lines when reach end of screen
set number										" Line numbers
set wrap linebreak textwidth=0					" Default wrapping is weird...
set backspace=indent,eol,start					" Fix broken backspace
set cursorline									" Highlight current line
set clipboard+=unnamed							" Yank to clipboard by default.
set ofu=syntaxcomplete#Complete					" Enable omni-completion
let g:ConqueTerm_Color = 1						" Enable terminal colour

" Set leader right
let mapleader = ","

" Now %% = path of current file
cabbr <expr> %% expand('%:p:h')

" Toggle hls
nmap <C-K>  :set hlsearch!<CR>:set hlsearch?<CR>

" Open a shell
nmap <leader>bash	:ConqueTermVSplit bash<CR>
nmap <leader>py		:ConqueTermVSplit python<CR><Esc>:set syntax=python<CR>i

" Press F2 to save quickly in insert mode
imap <F2>	<Esc>:w!<CR>i

" Source VimL in buffer
nmap <F9>  <Esc>:so %<CR>
map <C-P>	:set paste!<CR>:set paste?<CR>

" Buffer switch quickly
nnoremap <F1>	:bp<CR>
nnoremap <F11>	:bn<CR>
nnoremap <F2>  <C-W>w
nnoremap <F10>  <C-W>W
" Re-indent whole file
nmap <leader>in  =%
" Empty file
nmap <leader>em  ggdG

" Right margin at 80 cols in Vim 7.3+
function! ToggleRightMargin()
	if version >= 703
		if &cc != 0
			set cc=0
		else
			set cc=80
		endif
	endif
endfunction
nnoremap <leader>rm	:call ToggleRightMargin()<CR>

" Better % matching
runtime macros/matchit.vim

" Generally better editing
syntax enable
filetype on
filetype plugin on
filetype indent on

" Make whitespace visible
set listchars=tab:➙·,trail:·,eol:¶
nmap <silent> <leader>s :set nolist!<CR>

" Make status bar nicer
function! CurDir()
    let curdir = substitute(getcwd(), '/home/lucas/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ \|\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

" Appearance options
if has("gui_running")
	colors solarized
	set guifont=ProFont\ 9 bg=light

	" I have this habit of doing ^Z to suspend, but by default this minimises the GUI. Ugh. Stop it.
	noremap  <C-Z>	<Esc>
else
	colors darkblue
endif

" Bind Gundo
nmap <C-S-Y> :GundoToggle<CR>

" Make moving around windows easier
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

function! DoPCRE(expr)
	let s = 'perldo s' . a:expr
	execute s
endfunction

command! -nargs=0 EdVimrc ed ~/.vimrc
command! -nargs=0 SurvivalGuide vs ~/.dotfiles_dir/SurvivalGuide
command! -nargs=* S call DoPCRE('<args>')

" Load some plugins automatically
function! SetupProgramming()
	TlistOpen
	NERDTree
	syntax on
	filetype on
	filetype plugin on
	filetype indent on
endfunction

autocmd filetype lisp,python,javascript,ruby,perl,c,bash,sh,asm,java,vim call SetupProgramming()
