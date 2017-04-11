" Change the 'cpoptions' option temporarily {{{
" Set to its Vim default value and restore it later.
" This is to enable line-continuation within this script.
" Refer to :help use-cpo-save.
let s:save_cpoptions = &cpoptions
set cpoptions&vim
" }}}

function! SaveLoadMapping#Save(lhs, ...) "{{{
  let l:mode = get(a:000, 0, '')
  let l:maparg = maparg(a:lhs, l:mode, 0, 1)
  if len(l:maparg) == 0
    echohl Error
    echo 'No such mapping found.'
    echohl NONE
    return 0
  endif
  if !exists('g:SaveLoadMapping_Saves')
    let g:SaveLoadMapping_Saves = {}
  endif
  " Short name for internal use within this function
  let l:saves = g:SaveLoadMapping_Saves
  unlockvar! l:saves
  if !exists('l:saves[a:lhs]')
    let l:saves[a:lhs] = {}
  endif
  if !exists('l:saves[a:lhs][l:mode]')
    let l:saves[a:lhs][l:mode] = {}
  endif
  let l:buffer = l:maparg.buffer ? bufnr('%') : 'global'
  let l:saves[a:lhs][l:mode][l:buffer] = l:maparg
  lockvar! l:saves
  return len(l:maparg) > 0 ? 1 : 0
endfunction "}}}

function! SaveLoadMapping#Load(lhs, ...) "{{{
  let l:mode = get(a:000, 0, '')
  let l:bufGiven = a:0 > 1
  let l:buffer = get(a:000, 1, bufnr('%'))
  let l:found = exists('g:SaveLoadMapping_Saves[a:lhs][l:mode][l:buffer]')
  if !l:found && !l:bufGiven
    let l:buffer = 'global'
    let l:found = exists('g:SaveLoadMapping_Saves[a:lhs][l:mode][l:buffer]')
  endif
  if !l:found
    echohl Error
    echo 'No such mapping saved.'
    echohl NONE
    return 0
  endif
  let l:maparg = g:SaveLoadMapping_Saves[a:lhs][l:mode][l:buffer]
  let l:mapcmd = join([
  \ l:mode . (l:maparg.noremap ? 'noremap' : 'map')
  \ , l:maparg.buffer ? '<buffer>' : ''
  \ , l:maparg.expr   ? '<expr>'   : ''
  \ , l:maparg.nowait ? '<nowait>' : ''
  \ , l:maparg.silent ? '<silent>' : ''
  \ , l:maparg.lhs
  \ , substitute(l:maparg.rhs, '<SID>', '<SNR>' . l:maparg.sid . '_', 'g')
  \ ])
  execute l:mapcmd
  return 1
endfunction "}}}

" Restore 'cpoptions' setting {{{
let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
" }}}
