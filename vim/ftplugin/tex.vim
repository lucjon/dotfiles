let g:latex_command = 'pdflatex'
let g:latex_nonstop_flag = '-interaction nonstopmode'
let g:latex_escape = 0
let g:latex_escape_flag = '-shell-escape'

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

command! -nargs=0  CompileLatex  call Do_interactive_latex()
command! -nargs=0  UsePDFLaTeX   let g:latex_command = 'pdflatex'
command! -nargs=0  UseXeLaTeX    let g:latex_command = 'xelatex'
command! -nargs=0  UsePlainTeX	 let g:latex_command = 'pdftex'

nnoremap <silent> <buffer>  <CR>        :call Do_compile_latex()<CR>
nnoremap <silent> <buffer>  <leader>C   :CompileLatex<CR>

set inde=
