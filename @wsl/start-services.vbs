' This script is meant to be launched from Windows
Set shell = CreateObject("WScript.Shell" )

shell.Run """C:\Windows\System32\wsl.exe"" zsh -c 'sudo $HOME/.local/bin/start-services.sh'", 0

