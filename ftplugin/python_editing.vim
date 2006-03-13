" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
finish
endif
let b:did_ftplugin = 1

map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>

set foldmethod=expr
set foldexpr=PythonFoldExpr(v:lnum)
set foldtext=PythonFoldText()

map <buffer> f za
map <buffer> F :call PythonFoldToggle()<CR>
let b:folded = 1

function! PythonFoldToggle()
    if( b:folded == 0 )
        exec "normal! zM"
        let b:folded = 1
    else
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

function! PythonFoldText()

    let size = 1 + v:foldend - v:foldstart
    if size < 10
        let size = " " . size
    endif
    if size < 100
        let size = " " . size
    endif
    if size < 1000
        let size = " " . size
    endif
    
    return size . ' lines:'.substitute(getline(v:foldstart), '"""', '', 'g' )

endfunction

function! PythonFoldExpr(lnum)

    if indent( nextnonblank(a:lnum) ) == 0
        return 0
    endif
        
    if getline(a:lnum) =~ '^\s*$'
        return "="
    endif
        
    if getline(a:lnum-1) =~ '^\(class\|def\)\s'
        return 1
    endif

    if indent(a:lnum) == 0
        return 0
    endif

    return '='

endfunction
