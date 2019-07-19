if exists('g:SetColorScheme')
  call g:SetColorScheme()
end

if exists('g:GtkGuiLoaded')
  " nvim-gtk
  call rpcnotify(1, 'Gui', 'Font', 'Source Code Pro 12')
elseif exists('g:GuiLoaded')
  " nvim-qt
  GuiFont! Fira Code:h9
else
  set guifont=Fira\ Code\ 14
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
end
