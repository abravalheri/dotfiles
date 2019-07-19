' This script is meant to be launched from Windows
Set shell = CreateObject("WScript.Shell" )

shell.Run """C:\Windows\System32\wsl.exe"" zsh -c '$HOME/.dotfiles/@wsl/nvim-qt.launcher'", 0
