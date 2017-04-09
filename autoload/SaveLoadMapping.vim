" Set the 'cpoptions' option to its Vim default value and restore it later.
" This is to enable line-continuation within this script.
" Refer to :help use-cpo-save.
let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! SaveLoadMapping#Save(lhs, ...)
  if !exists('g:SaveLoadMapping_Saves')
    let g:SaveLoadMapping_Saves = {}
  endif
  " Short name for internal use within this function
  let l:saves = g:SaveLoadMapping_Saves
  unlockvar! l:saves
  if !exists('saves[a:lhs]')
    let l:saves[a:lhs] = {}
  endif
  let l:save = l:saves[a:lhs]
  let l:mode = get(a:000, 0, 'n')
  let l:maparg = maparg(a:lhs, l:mode, 0, 1)
  if len(l:maparg) > 0
    if !exists('l:save[l:mode]')
      let l:save[l:mode] = {}
    endif
    let l:buffer = l:maparg.buffer ? bufnr('%') : 'global'
    let l:save[l:mode][l:buffer] = l:maparg
  else
    echohl Error
    echo 'No such mapping found.'
    echohl NONE
  endif
  lockvar! l:saves
  return len(l:maparg) > 0 ? 1 : 0
endfunction

function! SaveLoadMapping#Load(lhs, ...)
  let l:mode = get(a:000, 0, 'n')
  let l:buffer = get(a:000, 1, bufnr('%'))
  " Check mapping save existence. If buffer not specified and local mapping
  " save not existing, also check the global one.
  if !exists('g:SaveLoadMapping_Saves[a:lhs][l:mode][l:buffer]')
    let l:found = 0
    if a:0 < 2
      let l:buffer = 'global'
      if exists('g:SaveLoadMapping_Saves[a:lhs][l:mode][l:buffer]')
        let l:found = 1
      endif
    endif
    if l:found == 0
      echohl Error
      echo 'No such mapping saved.'
      echohl NONE
      return 0
    endif
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
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions


