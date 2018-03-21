" molokai colors:
let s:green=118
let s:blue=81
let s:red=197
let s:gray0=252  " lightest
let s:gray1=245
let s:gray2=243
let s:gray3=241
let s:gray4=236
let s:gray5=234
let s:gray4=232  " darkest

let s:ag=s:gray5  " active background
let s:bg=s:gray4  " inactive background
let s:fg=s:gray1  " inactive foreground
let s:ac=s:blue   " accent
let s:mt=s:gray2  " mutted

let g:tmuxline_powerline_separators=0

let g:tmuxline_preset={
	\ 'a'    : ['#S'],
	\ 'win'  : ['#F#I #W'],
	\ 'cwin' : ['#F#I #W'],
	\ 'x'    : ['#(whoami)@#H'],
	\ 'y'    : ['%b %d'],
	\ 'z'    : ['%l:%M %P'],
	\ 'options': {
	\   'status-justify': 'left'} }

let g:tmuxline_theme={
  \ 'a'       : [ s:gray0, s:gray3 ],
  \ 'b'       : [ s:mt, s:bg ],
  \ 'c'       : [ s:mt, s:bg ],
  \ 'x'       : [ s:gray3, s:bg ],
  \ 'y'       : [ s:gray0, s:bg ],
  \ 'z'       : [ s:gray0, s:bg ],
  \ 'bg'      : [ s:fg, s:bg ],
  \ 'win'     : [ s:mt, s:bg ],
  \ 'win.activity' : [ s:bg, s:mt ],
  \ 'cwin'    : [ s:ac, s:ag, 'bold'] }

