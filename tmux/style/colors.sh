#!/bin/bash

# ==== OPTIONS ====
# Default values
C=1
H=999

while [[ $# -gt 1 ]]; do
  # Use -gt 1 to consume two arguments per pass in the loop (e.g. each
  # argument has a corresponding value to go with it).
  # Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
  # some arguments don't have a corresponding value to go with it such
  # as in the --default example).
  # note: if this is set to -gt 0 the /etc/hosts part is not recognized
  # (may be a bug)

  key="$1"

  case $key in
    -c|--columns)
      C=$2
      shift # past argument
      ;;
    -l|--highlight)
      H=$2
      shift # past argument
      ;;
    -h|--help)
      echo "Usage: $0 [options]"
      echo ""
      echo "-h, --help           Display this help message."
      echo "-c N, --columns N    Number of columns to be printed (default 1)."
      echo "-l N, --highlight N  Highlight the color of number N."
      exit 0
      ;;
    *)
      # unknown option
      ;;
  esac

  shift # past argument or value
done

for i in {0..255} ; do
    [ "$i" -eq $H ] && printf "\x1b[1;3;4;5m" # bold, italic, blink; underline
    printf "\x1b[38;5;${i}mcolour${i}"        # Print the color
    printf "\x1b[0m \t"                       # reset style

    [ $(( i % $C )) -eq $(($C-1)) ] && printf "\n" # make columns
done
