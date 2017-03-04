" =============================================================================
" Description: Post tweets from a scratch buffer, or get your timeline and 
" read it in a scratch buffer. 
" File: twitter.vim
" Author: Vanessa McHale <tmchale@wisc.edu>
" Version: 0.1.0.0
" ChangeLog:
"       0.1.0.0: initial commit.
if exists("g:__TWITTER_VIM__")
    finish
endif
let g:__TWITTER_VIM__ = 1

if !exists("g:twitter_cred")
    let g:twitter_cred = '~/.cred'
endif

if !exists("g:twitter_num")
    let g:twitter_num = 8
endif

" how to pipe buffer to external
" You can use :w !cmd to write the current buffer to the stdin of an external command. From :help :w_c
":buffer Twitter " should take us there?? 

if !exists("g:twitter_options")
    let g:twitter_options = ''
endif

let g:twitter_buf_name = 'Twitter'

let g:twitter_tl_buf_name = 'Timeline'

" default buffer size for 
if !exists("g:twitter_tl_buf_size")
    let g:twitter_tl_buf_size = 18
endif

if !exists("g:twitter_buf_size")
    let g:twitter_buf_size = 8
endif

" Mark a buffer as scratch
function! s:ScratchMarkBuffer()
    setlocal buftype=nofile
    " make sure buffer is deleted when view is closed
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal buflisted
    setlocal nonumber
    setlocal statusline=%F
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal wrap
    setlocal linebreak
    setlocal nolist
endfunction

" Return the number of visual lines in the buffer
fun! s:CountVisualLines()
    let initcursor = getpos(".")
    call cursor(1,1)
    let i = 0
    let previouspos = [-1,-1,-1,-1]
    " keep moving cursor down one visual line until it stops moving position
    while previouspos != getpos(".")
        let i += 1
        " store current cursor position BEFORE moving cursor
        let previouspos = getpos(".")
        normal! gj
    endwhile
    " restore cursor position
    call setpos(".", initcursor)
    return i
endfunction

" return -1 if no windows was open
"        >= 0 if cursor is now in the window
fun! s:TwitterGotoWin() "{{{
    let bufnum = bufnr( g:twitter_buf_name )
    if bufnum >= 0
        let win_num = bufwinnr( bufnum )
        " Will return negative for already deleted window
        exe win_num . "wincmd w"
        return 0
    endif
    return -1
endfunction "}}}

" Close twitter Buffer
fun! TwitterClose() "{{{
    let last_buffer = bufnr("%")
    if s:TwitterGotoWin() >= 0
        close
    endif
    let win_num = bufwinnr( last_buffer )
    " Will return negative for already deleted window
    exe win_num . "wincmd w"
endfunction "}}}

" Open a scratch buffer or reuse the previous one
fun! TwitterTimeline() "{{{
    let last_buffer = bufnr("%")

    if s:TwitterGotoWin() < 0
        new
        exe 'file ' . g:twitter_tl_buf_name
        setl modifiable
    else
        setl modifiable
        normal ggVGd
    endif

    call s:ScratchMarkBuffer()

    " separate function? cuz this should read/display stuff too. 
    " execute ':w .! tweet -c' . g:twitter_num
    execute '.! tweet -c ~/.cred view -n' . g:twitter_num
    setl nomodifiable
    
    let size = s:CountVisualLines()

    if size > g:twitter_tl_buf_size
        let size = g:twitter_tl_buf_size
    endif

    execute 'resize ' . size

    nnoremap <silent> <buffer> q <esc>:close<cr>

endfunction "}}}

" Open a scratch buffer or reuse the previous one
fun! TwitterProfile(a:screen_name) "{{{
    let last_buffer = bufnr("%")

    if s:TwitterGotoWin() < 0
        new
        exe 'file ' . g:twitter_tl_buf_name
        setl modifiable
    else
        setl modifiable
        normal ggVGd
    endif

    call s:ScratchMarkBuffer()

    " separate function? cuz this should read/display stuff too. 
    " execute ':w .! tweet -c' . g:twitter_num
    execute '.! tweet -c ~/.cred user -n' . g:twitter_num . ' ' . a:screen_name
    setl nomodifiable
    
    let size = s:CountVisualLines()

    if size > g:twitter_tl_buf_size
        let size = g:twitter_tl_buf_size
    endif

    execute 'resize ' . size

    nnoremap <silent> <buffer> q <esc>:close<cr>

endfunction "}}}

fun! TwitterWriteFromBuffer() "{{{
    let last_buffer = bufnr("%")

    if s:TwitterGotoWin() < 0
        new
        exe 'file ' . g:twitter_buf_name
        setl modifiable
    else
        setl modifiable
        normal ggVGd
    endif

    call s:ScratchMarkBuffer()

    let size = s:CountVisualLines()
    if size != g:twitter_buf_size
        let size = g:twitter_buf_size
    endif

    execute 'resize ' . size

    nnoremap <silent> <buffer> t <esc>:w !tweet -c ~/.cred send -t15<cr> 
    " nnoremap <silent> <buffer> d <esc>:w !tweet -c ~/.cred send -t15 \| :close<cr> 
    nnoremap <silent> <buffer> q <esc>:close<cr>

endfunction "}}}

command! Tweet call TwitterWriteFromBuffer()
command! Timeline call TwitterTimeline()
command! -nargs=1 Profile call TwitterProfile(<f-args>)
map <silent> tt :Timeline<CR>
