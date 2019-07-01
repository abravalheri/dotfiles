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
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
end
