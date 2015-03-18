let g:tmuxline_powerline_separators = 0

let g:tmuxline_preset = {
	\ 'a'    : ['#S'],
	\ 'win'  : ['#F#I #W'],
	\ 'cwin' : ['#F#I #W'],
	\ 'x'    : ['#(whoami)@#H'],
	\ 'y'    : [' %b %d'],
	\ 'z'    : ['%l:%M %P'],
	\ 'options': {
	\   'status-justify': 'left'} }

let g:tmuxline_theme = {
        \ 'a'       : [  46,  235],
        \ 'b'       : [  15,  16 ],
        \ 'c'       : [  15,  16 ],
        \ 'x.dim'   : [ 243,  16 ],
        \ 'x'       : [  46,  16 ],
        \ 'y.dim'   : [ 243,  16 ],
        \ 'y'       : [  15,  16 ],
        \ 'z'       : [  15,  16 ],
        \ 'bg'      : [  15,  16],
        \ 'win'     : [ 243,  16 ],
        \ 'win.activity' : [ 16, 243 ],
        \ 'cwin'    : [  15, 26, 'bold'] }
