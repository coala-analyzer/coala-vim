" g:coala_run_on_save is a global flag for enabling/disabling the
" automatic running of the linters plugin on every write.
let g:coala_run_on_save = get(g:, 'coala_run_on_save', 0)

" g:coala_disabled_filetypes can contain a list of filetypes that automatic
" linting should be disabled for
let g:coala_disabled_filetypes = get(g:, 'coala_disabled_filetypes', [])

" Set autocmd only if g:linters_automatic_on_save is true and
" filetype is not disabled filetypes.
if g:linters_automatic_on_save
      \ && -1 != index(g:linters_disabled_filetypes, &filetype)
  au BufWritePost * call coala#run()
endif
