syntax on
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set scrolloff=999
set cursorline
hi CursorLine   cterm=NONE ctermbg=lightgrey guibg=darkred guifg=red
set cursorcolumn

set incsearch
set hlsearch
set ignorecase
set smartcase
set ruler


nnoremap a A
nnoremap <Space> i <Esc>l
nnoremap ( i(<Esc>l
nnoremap ) i)<Esc>l
nnoremap <BS> i<BS><Esc>l
nnoremap <Enter> i<Enter><Esc>
nnoremap <C-j> "zyiw:exe "Grep -r ".@z." ." <CR>
vnoremap <C-j> y:exe "Grep -r "escape(@", '\\/.*$^~[]')" ." <CR>


" replace with word under cursor
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

function! Find(name)
  let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
" replace above line with below one for gvim on windows
" let l:list=system("find . -name ".a:name." | perl -ne \"print qq{$.\\t$_}\"")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>") 

set modifiable
autocmd BufWinEnter * setlocal modifiable
