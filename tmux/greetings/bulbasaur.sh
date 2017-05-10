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
                        ${Bf}██████           
                      ${Bf}██${gf}${ON}██████${OFF}${Bf}██         
                  ${Bf}██████${gf}${ON}██████${OFF}${Bf}██         
              ${Bf}████${gf}${ON}████${OFF}██${ON}████${OFF}██${ON}██${OFF}${Bf}████     
      ${Bf}██    ██${gf}${ON}██████${OFF}████${ON}████${OFF}██${ON}██████${OFF}${Bf}██   
    ${Bf}██${cf}${ON}██${OFF}${Bf}██████${gf}${ON}████${OFF}██${ON}██${OFF}██${ON}██████${OFF}██${ON}██████${OFF}${Bf}██ 
    ${Bf}██${cf}${ON}██████${OFF}${Bf}████${gf}██${ON}██${OFF}██${ON}██████████${OFF}██${ON}████${OFF}${Bf}██ 
    ${Bf}██${cf}${ON}████████${OFF}██${Bf}██${gf}${ON}██${OFF}██${ON}██████████${OFF}██${ON}████${OFF}${Bf}██ 
  ${Bf}██${cf}${ON}████${OFF}██${ON}██${OFF}████${ON}██${OFF}${Bf}██████${gf}${ON}████████${OFF}██${ON}██${OFF}${Bf}██   
${Bf}████${cf}██${ON}████████████████${OFF}${Bf}██${gf}██████${Bf}████████   
${Bf}██${cf}████${ON}██████${OFF}██${ON}██████${OFF}${Bf}██${cf}██${Bf}██████${cf}██████${Bf}██   
${Bf}██${cf}${ON}████████${OFF}██${ON}██${OFF}${Bf}████${cf}${ON}██${OFF}██████████${Bf}██${cf}██${wf}${ON}██${OFF}${Bf}██   
${Bf}██${cf}██${ON}████████${OFF}${Bf}██${rf}${ON}██${wf}████${OFF}${cf}████${Bf}██${cf}████${Bf}██████     
  ${Bf}██${cf}██${ON}██████${OFF}${Bf}██${rf}${ON}██${wf}██${cf}██${OFF}██${Bf}██${cf}████${Bf}██           
    ${Bf}████${cf}████████████${Bf}██${cf}██████${Bf}██           
        ${Bf}██████████████${wf}${ON}██${OFF}${cf}██${wf}${ON}██${OFF}${Bf}██           
                      ${Bf}██████             
                                         
${reset}

EOF
