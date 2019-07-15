com! Init call fireplace#evalprint("(integrant.repl/init)")
nmap cpi :Init<CR>

let maplocalleader=","
let g:sexp_enable_insert_mode_mappings = 0

nmap <LocalLeader>s ,wlog/spy<ESC>
nmap <LocalLeader>S ,wsc/spy<ESC>
" def a thing in a let binding
nmap <LocalLeader>D v<M-e><M-e>"zy:let @z=substitute(@z, '\v(\n\|\s)+', ' ', 'g')<CR>cqc(def <C-R>z)<ESC><CR>
nmap <LocalLeader>d v<M-e><M-e>"zy:let @z=substitute(@z, '\v(\n\|\s)+', ' ', 'g')<CR>cqc(user/def+ <C-R>z)<ESC><CR>
" show the value of a var
nmap <LocalLeader>/ "zyiwcqc(clojure.pprint/pprint <C-R>z)<ESC><CR>
nmap <LocalLeader>L :Last<CR>"zyG:q<CR>"zp
nmap <LocalLeader>K :Last<CR>"zyG:q<CR>'s"zp:0d<bar>$d<bar>silent! %s/^;//<CR>gg:set nomodified<CR>
nmap cqe cqc*e<CR>
autocmd! fireplace_require FileType clojure
nnoremap cpr :silent RunTests <bar> cclose <bar> cnext<CR>

function! RunInjections() abort
    call fireplace#eval("(require '[sc.api :as sc])")
    call fireplace#eval("(require '[sc.nrepl.repl :as nsc])")
    call fireplace#eval("(require '[com.gfredericks.debug-repl :refer [break! unbreak!]])")
    let l:c  = "(defmacro def+"
    let l:c .= "  {:added \"1.9\", :special-form true, :forms '[(def+ [bindings*])]}"
    let l:c .= "  [& bindings]"
    let l:c .= "  (let [bings (partition 2 (destructure bindings))]"
    let l:c .= "    (sequence cat"
    let l:c .= "              ['(do)"
    let l:c .= "               (map (fn [[var value]] `(def ~var ~value)) bings)"
    let l:c .= "               [(mapv (fn [[var _]] (str var)) bings)]])))"
    call fireplace#eval(l:c)
endf
nmap <LocalLeader>! :call RunInjections()<CR>

" nnoremap J Jx
" nnoremap \J J

fu! Star()
  let l:x = expand("<cword>")
  let l:x = escape(l:x, '\\/.*?+=$^~[]<>')
  " let l:x = substitute(l:x, '\v^(.*/)', '\\(\\w\\+\\/\\)\\?', "")
  let l:x = substitute(l:x, '\v^(.*/)', '', "")
  let @/ = '\v<:?:?('. l:x .'\/[-a-zA-Z0-9]+|([-a-zA-Z0-9.]+\/)?'. l:x .'>)'
endfu

nnoremap * :call Star()<CR>n

" au BufWrite *.clj :normal mz:%!cljfmt<CR>`z


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" snoe

" COC
" let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
" let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <localleader>u <Plug>(coc-references)
nmap <localleader>r <Plug>(coc-rename)
command! -nargs=0 Format :call CocAction('format')

let g:coc_enable_locationlist = 0
autocmd User CocLocationsChange CocList --normal location

inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> [l <Plug>(coc-diagnostic-prev)
nmap <silent> ]l <Plug>(coc-diagnostic-next)
nmap <silent> [k :CocPrev<cr>
nmap <silent> ]k :CocNext<cr>
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! Expand(exp) abort
    let l:result = expand(a:exp)
    return l:result ==# '' ? '' : "file://" . l:result
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
vmap <localleader>f <Plug>(coc-format-selected)
nmap <localleader>f <Plug>(coc-format-selected)

nnoremap <silent> crcc :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'cycle-coll', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crth :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crtt :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crtf :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crtl :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> cruw :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-thread', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crua :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crml :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'move-to-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
nnoremap <silent> cril :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'introduce-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
nnoremap <silent> crel :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'expand-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> cram :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'add-missing-libspec', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> crcn :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> cref :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'extract-function', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Function name: ')]})<CR>

nnoremap <silent> crrl :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'remove-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
nnoremap <silent> cris :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'inline-symbol', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <localleader>a  <Plug>(coc-codeaction-selected)
nmap <localleader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <localleader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <localleader>qf  <Plug>(coc-fix-current)

autocmd BufReadCmd,FileReadCmd,SourceCmd jar:file://* call s:LoadClojureContent(expand("<amatch>"))
 function! s:LoadClojureContent(uri)
  setfiletype clojure
  let content = CocRequest('clojure-lsp', 'clojure/dependencyContents', {'uri': a:uri})
  call setline(1, split(content, "\n"))
  setl nomodified
  setl readonly
endfunction

highlight Normal guibg=#101010 guifg=white
highlight CursorColumn guibg=#202020
highlight Keyword guifg=#FFAB52
highlight CursorLine guibg=#202020

augroup END
" vi:set ft=vim ts=4 sw=4 expandtab:
