#!/bin/sh

initializeANSI() {
  esc=""

  Bf="${esc}[30m";   rf="${esc}[31m";    gf="${esc}[32m"
  yf="${esc}[33m"   bf="${esc}[34m";   pf="${esc}[35m"
  cf="${esc}[36m";    wf="${esc}[37m"

  Bb="${esc}[40m";   rb="${esc}[41m";    gb="${esc}[42m"
  yb="${esc}[43m"   bb="${esc}[44m";   pb="${esc}[45m"
  cb="${esc}[46m";    wb="${esc}[47m"

  ON="${esc}[1m";    OFF="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

initializeANSI

cat << EOF
       ${Bf}████████                  ████████
     ${Bf}██${bf}${ON}██████${OFF}██${Bf}████            ██${bf}${ON}████████${OFF}${Bf}██
   ${Bf}██${bf}${ON}████████████${OFF}██${Bf}████      ████${bf}${ON}██████${OFF}████${Bf}██
   ${Bf}██${bf}${ON}██████████████${OFF}${Bf}██${pf}██${Bf}████  ██${bf}${ON}████${OFF}██${Bf}██${bf}████${Bf}██
 ${Bf}██${bf}${ON}████████████████${OFF}██${pf}██${ON}██${OFF}██${Bf}██${bf}██${ON}██${OFF}██${Bf}██${bf}██████${Bf}██
 ${Bf}██${bf}${ON}████████${wf}${ON}██${OFF}${Bf}██${bf}${ON}████${OFF}██${wf}${ON}██${OFF}${pf}${ON}████${OFF}██${Bf}██${bf}████${Bf}██${bf}████${Bf}██
 ${Bf}██${bf}██${ON}██████${OFF}${Bf}████${bf}${ON}██${OFF}████${wf}${ON}██${pf}██████${OFF}${Bf}██${bf}██${Bf}████████
   ${Bf}██${bf}████${ON}██${OFF}${Bf}████${bf}██████${Bf}██${wf}${ON}████${pf}██${OFF}██${Bf}████
     ${Bf}████${bf}████████${Bf}████${bf}${ON}████${wf}██${OFF}${pf}████${Bf}██
     ${Bf}██${bf}${ON}██${OFF}${Bf}████████${bf}${ON}██████${OFF}██${wf}${ON}██${OFF}${pf}████${Bf}██
       ${Bf}████${yf}${ON}████${OFF}${Bf}██${bf}${ON}████${OFF}██${Bf}██${wf}${ON}██${OFF}${pf}████${Bf}██
           ${Bf}██${yf}████${Bf}████████${wf}${ON}██${OFF}${pf}████${Bf}██
         ${Bf}██${bf}██${Bf}██${pf}██${yf}██████${pf}██${Bf}██${wf}${ON}██${OFF}${Bf}██
           ${Bf}████████${pf}████${bf}██${Bf}██${wf}${ON}██${OFF}${Bf}██
                 ${Bf}██████${bf}██${Bf}████
                   ${Bf}██${bf}██████${Bf}██
                     ${Bf}██████

${reset}

EOF
