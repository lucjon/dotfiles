let g:latex_command = 'pdflatex'
let g:latex_nonstop_flag = '-interaction nonstopmode'
let g:latex_escape = 0
let g:latex_escape_flag = '-shell-escape'
let g:do_bibtex = 0
let g:bibtex_command = 'biber'
let g:bibtex_name = ''

function! Get_latex_cmd(...)
	if a:0 == 0
		let flags = ''
	else
		let flags = join(a:000, ' ')
	endif

	if g:latex_escape
		let flags = flags . ' ' . g:latex_escape_flag
	endif

	return g:latex_command . ' ' . flags . ' "' . expand('%') . '"'
endfunction

function! Do_compile_latex()
	silent write
	if g:do_bibtex
		call system(g:bibtex_command . ' ' . g:bibtex_name)
		if v:shell_error != 0
			echo 'Error compiling bibliography. Continuing...'
		endif
		echo g:bibtex_command . ' ' . g:bibtex_name
	endif
	call system(Get_latex_cmd(g:latex_nonstop_flag))
	if v:shell_error != 0
		echo 'Errors in (La)TeX document. Use ' . g:mapleader . 'C to compile interactively.'
	endif
endfunction

function! Do_interactive_latex()
	if has('nvim')
		sp
		execute 'term ' . Get_latex_cmd()
	else
		execute '!' . Get_latex_cmd()
	endif
endfunction

function! Do_use_bib(name)
	let g:do_bibtex = 1
	let g:bibtex_name = a:name
endfunction

command! -nargs=0  CompileLatex  call Do_interactive_latex()
command! -nargs=0  UsePDFLaTeX   let g:latex_command = 'pdflatex'
command! -nargs=0  UseXeLaTeX    let g:latex_command = 'xelatex'
command! -nargs=0  UsePlainTeX	 let g:latex_command = 'pdftex'
command! -nargs=1  UseBib        call Do_use_bib('<args>')

nnoremap <silent> <buffer>  <CR>        :call Do_compile_latex()<CR>
nnoremap <silent> <buffer>  <leader>C   :CompileLatex<CR>

set inde=

nmap <silent> <buffer> \b		:let b:in_latex_begin=1<CR>a\begin{
nmap <silent> <buffer> \B		O<Esc>\b
au InsertLeave <buffer>  call Do_latex_insertleave()

function! Do_latex_insertleave()
	if exists('b:in_latex_begin') && b:in_latex_begin
		if matchstr(getline('.'), '\%' . col('.') . 'c.') == '{'
			norm 7hD
		else
			norm a}
			norm F\y$o
			norm P$F\lct{end
			" beware, there's a space at the end of the next line
			" (deliberately)
			norm O 
			norm $x
		endif
		let b:in_latex_begin = 0
	endif
endfunction!
