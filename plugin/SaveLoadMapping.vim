command! -nargs=+ SaveMapping call SaveLoadMapping#Save(<args>)
command! -nargs=+ LoadMapping call SaveLoadMapping#Load(<args>)
