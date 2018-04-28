" g:coala_run_on_save is a global flag for enabling/disabling the
" automatic running of the linters plugin on every write.
let g:coala_run_on_save = get(g:, 'coala_run_on_save', 0)

" g:coala_disabled_filetypes can contain a list of filetypes that automatic
" linting should be disabled for
let g:coala_disabled_filetypes = get(g:, 'coala_disabled_filetypes', [])

let s:wd = expand("%:p:h")

" Run the linter for the current buffer, if there is one defined.
function coala#run()
    let l:temp_file = tempname()
    silent execute "!cd ".s:wd." && coala --format --find-config --limit-files=\"".expand('%:p')."\" -S format=L{line}:{message} > " . l:temp_file
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

" Set autocmd only if g:linters_automatic_on_save is true and
" filetype is not disabled filetypes.
if g:linters_automatic_on_save
      \ && -1 != index(g:linters_disabled_filetypes, &filetype)
  au BufWritePost * call coala#run()
endif
