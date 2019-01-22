call g:SetColorScheme()
if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Font', 'Source Code Pro 12')
else
  GuiFont Source Code Pro:h11
end
