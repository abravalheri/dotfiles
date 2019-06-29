if exists('g:SetColorScheme')
  call g:SetColorScheme()
end
if exists('g:GtkGuiLoaded')
  " nvim-gtk
  call rpcnotify(1, 'Gui', 'Font', 'Source Code Pro 12')
elseif has('nvim')
  " nvim-qt
  GuiFont Source Code Pro:h11
else
  set guifont="DejaVu Sans Mono 12"
end
