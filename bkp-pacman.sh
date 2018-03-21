#!/usr/bin/env bash
here="$(pwd)"
cd "$(dirname "${BASH_SOURCE[0]}")"

pacman -Qeni | awk '
  /^Name/ { name=$3 }
  /^Groups/ {
    if ( $3 != "base" && $3 != "base-devel" &&
         $3 != "xorg" && $4 != "xorg" &&
         $3 != "xorg-apps") {
      print name
    }
  }' > pacman-pkglist-native.txt
echo -e "base\nbase-devel\nxorg" >> pacman-pkglist-native.txt
sort -o pacman-pkglist-native.txt -u pacman-pkglist-native.txt

pacman -Qqem | awk '!/trizen/' > pacman-pkglist-foreign.txt

cd "$here"
