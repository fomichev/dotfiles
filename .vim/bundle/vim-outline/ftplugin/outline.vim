if exists("b:did_ftplugin")
	finish
endif

let b:did_ftplugin = 1

1SpeedDatingFormat %d %b %Y, %a
2SpeedDatingFormat %H:%M %d %b %Y, %a

nmap <localleader>it a<<C-R>=strftime("%H:%M %d %b %Y, %a")<CR>><Esc>
nmap <localleader>id a<<C-R>=strftime("%d %b %Y, %a")<CR>><Esc>

nmap <localleader>td :.s/TODO/DONE/
nmap <localleader>tt :.s/TODO/DONE/


finish
