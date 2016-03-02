" g:linters_automatic_on_save is a global flag for enabling/disabling the
" automatic running of the linters plugin on every write.
if !exists('g:linters_automatic_on_save')
	let g:linters_automatic_on_save = 1
endif

" g:linters_disabled_filetypes can contain a list of filetypes that automatic
" linting should be disabled for
if !exists('g:linters_disabled_filetypes')
	let g:linters_disabled_filetypes = []
endif

let s:empty_dict = {}
let s:filename = expand("<sfile>:p:h")
let s:wd = expand("%:p:h")
if !exists('g:linters_enabled')
	let g:linters_enabled = 1
endif

" Run the linter for the current buffer, if there is one defined.
function s:RunLinter()
	if !g:linters_enabled
		return
	endif

	let l:temp_file = tempname()
	set cmdheight=2
	echo "Running coala... When this finishes, you will see a popup if there are any errors."
	silent execute "!cd ".s:wd." && coala-json --find-config --limit-files=\"".expand('%:p')."\" | python ".s:filename."\/jsonp.py > " . l:temp_file
	if v:shell_error
		set errorformat=L%l\\:\ %m
		copen
		execute "cgetfile " . l:temp_file
	else
		call setqflist([])
		cclose
	endif

endfunction

" Check to see if linting should be done. This checks if the linters plugin is
" disabled, or if linting for the current filetype is disabled, before running
" the linters.
function! s:WritePostHook()
	if !g:linters_automatic_on_save
		return
	endif
	if -1 != index(g:linters_disabled_filetypes, &filetype)
		return
	endif

	call s:RunLinter()
endfunction

" Expose the DefineLinter() function for external use. Has the same
" parameters.
function! coala#define(filetype, linter, errorformats)
	call DefineLinter(a:filetype, a:linter, a:errorformats)
endfunction

function! coala#run()
	call s:RunLinter()
endfunction

au BufWritePost * call s:WritePostHook()


