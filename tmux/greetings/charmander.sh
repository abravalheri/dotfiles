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
         ${Bf}████████                  ██       
       ${Bf}██${rf}${ON}██████${OFF}██${Bf}██              ██${rf}██${Bf}██     
     ${Bf}██${rf}${ON}██████████${OFF}██${Bf}██            ██${rf}████${Bf}██   
     ${Bf}██${rf}${ON}████████████${OFF}${Bf}██            ██${rf}████${Bf}██   
   ${Bf}██${rf}${ON}██████████████${OFF}██${Bf}██        ██${rf}████${yf}██${rf}██${Bf}██ 
 ${Bf}██${rf}${ON}████████${wf}██${OFF}${Bf}██${rf}${ON}████${OFF}██${Bf}██        ██${rf}██${yf}██${ON}██${OFF}${rf}██${Bf}██ 
 ${Bf}██${rf}${ON}████████${OFF}${Bf}████${rf}${ON}██${OFF}██████${Bf}██      ██${rf}██${yf}${ON}████${OFF}${rf}██${Bf}██ 
 ${Bf}██${rf}${ON}████████${OFF}${Bf}████${rf}${ON}██${OFF}██████${Bf}██        ██${yf}${ON}██${OFF}${Bf}████   
   ${Bf}██${rf}██${ON}████████${OFF}██████████${Bf}██      ██${rf}${ON}██${OFF}${Bf}██     
     ${Bf}████${rf}██████████████████${Bf}██  ██${rf}${ON}████${OFF}${Bf}██     
         ${Bf}██████${rf}████${Bf}██${rf}██████${Bf}████${rf}██${ON}██${OFF}${Bf}██       
           ${Bf}██${yf}${ON}████${OFF}${Bf}██${rf}${ON}████${OFF}${rf}██████${Bf}██${rf}██${ON}██${OFF}${Bf}██       
           ${Bf}██${yf}${ON}██████${OFF}${Bf}████${rf}██████${Bf}██${rf}██${Bf}██         
         ${Bf}██${wf}${ON}██${OFF}${Bf}██${yf}${ON}██████${OFF}${rf}████████${Bf}████           
           ${Bf}██████${yf}████${rf}██████${Bf}████             
                 ${Bf}██████${rf}██${Bf}████               
                   ${Bf}██${wf}${ON}██${OFF}${rf}██${wf}${ON}██${OFF}${Bf}██               
                     ${Bf}██████        
${reset}

EOF
