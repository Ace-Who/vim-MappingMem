command! -nargs=+ SaveMapping call MappingMem#Save(<args>)
command! -nargs=+ LoadMapping call MappingMem#Load(<args>)
