" Run the linter for the current buffer, if there is one defined.
function! coala#run()
    let l:wd = expand("%:p:h")
    let l:temp_file = tempname()
    silent execute "!cd ".l:wd." && coala --format --find-config --limit-files=\"".expand('%:p')."\" -S format=L{line}:{message} > " . l:temp_file
    if v:shell_error
        set errorformat=L%l\\:%m
        execute "cgetfile " . l:temp_file
        redir => l:errors
        silent clist
        redir END
        if l:errors =~ "The requested coafile" && errors =~ "does not exist"
            call setqflist([])
        endif
        cwindow
    else
        call setqflist([])
        cclose
    endif
endfunction
