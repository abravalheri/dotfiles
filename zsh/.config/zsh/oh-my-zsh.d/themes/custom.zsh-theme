# Based on sunaku and terminalparty themes
# with colors from molokai vim theme

local my_blue=081
local my_green=118
local my_red=197
local my_yellow=222
local my_purple=135
local my_orange=208
local my_grey_light=252
local my_grey_dark=241

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[$my_green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[$my_orange]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[$my_red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[$my_blue]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[$my_purple]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[$my_yellow]%}?"

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
#ZSH_THEME_GIT_PROMPT_DIRTY=""
#ZSH_THEME_GIT_PROMPT_CLEAN=""

local user_color=$my_green
test $UID -eq 0 && user_color=$my_red

PROMPT='%(?,%{$FG[$my_green]%},%{$FG[$my_red]%}) %% %{$reset_color%}'
RPS1='%{$FG[$my_blue]%}'\
'%~ '\
'%{$FG[$my_grey_dark]%}'\
'$(git_prompt_status)$(git_prompt_info)'\
'%{$reset_color%}'

PROMPT2='%{$FX[bold]%}%{$FG[$my_purple]%}...%{$reset_color%}'
