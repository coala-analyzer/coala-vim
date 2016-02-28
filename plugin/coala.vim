" Make sure we're running only one instance
if exists("g:loaded_coalavim")
	finish
endif
let g:loaded_coalavim = 1

func! run_coala()
	! coala
endfunction

:command! coala call run_coala()
