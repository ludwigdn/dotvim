augroup MyCustomAutoGroup
  autocmd!
  autocmd StdinReadPre * let s:std_in=1

  " Use actual tab chars in Makefiles.
  autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

  " Start NERDTree when Vim starts with a file argument.
  "autocmd VimEnter * if argc() > 0 || exists("s:std_in") | NERDTree | wincmd p | endif
  " Start NERDTree when Vim starts with a directory argument.
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0]  | endif
  " Close whole tab if all buffers but NERDTree are closed
  autocmd BufEnter * if tabpagenr('$') >= 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  " Better syntax highlighting for large files
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

  " call function to auto-trim whitespaces at end of lines
  autocmd BufWritePre * :call TrimWhitespace()

  " This sets the file formats to unix, avoiding ^M errors when coming from dos
  autocmd BufWritePre * :set fileformat=unix

  " Run prettier whe saving a file
  autocmd BufWritePre *.{js,jsx,ts,tsx,html,json,css,scss,md,yaml} :Prettier

  " Auto source .vimrc file at saving
  autocmd BufWritePost .vimrc :so %

  " Format files
  autocmd FileType json nnoremap <silent> <leader>fm :%!python -m json.tool<CR>
  autocmd FileType apiblueprint nnoremap <silent> <leader>fm :call GenerateRefract()<CR>
  autocmd FileType xml nnoremap <silent> <leader>fm :!tidy -mi -xml -wrap 0 %<CR>
  autocmd FileType html nnoremap <silent> <leader>fm :!tidy -mi -xml -wrap 0 %<CR>

augroup END

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
