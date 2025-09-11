#!/bin/bash
#This tool is made for ethical purposes only. Use this with responsibility, respecting privacy, consent, and the rights of others.
#It’s essential to ensure that the tool serves to promote positive outcomes, improve knowledge, and contribute to the well-being of all.
#Always consider the potential impact of your actions and decisions when using this technology.

#Please install pv and jq before using the tool.
#apt-get install pv and apt-get install install jq
#Happy hunting :)

MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
PURPLE='\033[1;95m'
NC='\033[0m'
GHOST_WHITE='\033[1;97m'


echo -e "${MAGENTA}
___________           _________                
\__    ___/__________ \_   ___ \_____  ______  
  |    | /  _ \_  __ \/    \  \/\__  \ \____ \ 
  |    |(  <_> )  | \/\     \____/ __ \|  |_> >
  |____| \____/|__|    \______  (____  /   __/ 
                              \/     \/|__|    
                              by INNOCENTx0
"




node_analysis() {
       echo 'Please write your interface:' | pv -qL 25
       interfaces=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' )

       for i in $(echo $interfaces);do
            echo -e "${CYAN}     $i" | tr -d ":"
       done 
       read choose_option

       match=false

       for i in $interfaces; do
                if [[ "$choose_option" == "${i//:}" ]]; then
                    match=true
                    break
                fi
            done

    if [[ "$match" == true ]]; then
        echo -e "${PURPLE}INTERFACE SELECTED: ${GHOST_WHITE}$choose_option :)"

            echo -e "${MAGENTA}STARTING.."

            tcpdump -i $choose_option 'tcp and (not src host 127.0.0.1 and not dst host 127.0.0.1) and not arp' -n 2>&1| grep -v "tcpdump"| 
            while read -r line;do
                src_node=$(echo "$line" | grep -oP 'IP \K[0-9.]+(?=\.[0-9]+ >)' )
                dest_node=$(echo "$line" | grep -oP '> \K[0-9.]+(?=\.[0-9]+:)' )


                
                check_request=$(curl -s https://onionoo.torproject.org/details?search=$dest_node)
  
                if [[ $check_request == *"fingerprint"* ]];then
                    echo -e "${CYAN}TOR CONNECTION FOUND!"
                    echo -e "${CYAN}   SOURCE NODE:${MAGENTA} $src_node"
                    echo -e "${CYAN}   DESTINATION:${MAGENTA} $dest_node"

                    fingerprint=$(echo "$check_request" | jq -r '.relays[0].fingerprint')
                    peer_nickname=$(echo "$check_request" | jq -r '.relays[0].nickname')
                    country=$(echo "$check_request" | jq -r '.relays[0].country_name')
                    contact=$(echo "$check_request" | jq -r '.relays[0].contact')
                    as_name=$(echo "$check_request" | jq -r '.relays[0].as_name')

                    echo -e "      ${MAGENTA}Fingerprint: ${GHOST_WHITE}$fingerprint"
                    echo -e "      ${MAGENTA}Peer nickname:  ${GHOST_WHITE}$peer_nickname"
                    echo -e "      ${MAGENTA}Country:  ${GHOST_WHITE}$country"
                    echo -e "      ${MAGENTA}AS Name:  ${GHOST_WHITE}$as_name"
                    echo -e "      ${MAGENTA}Contact:  ${GHOST_WHITE}$contact"


                    echo -e "${CYAN}   CLIENT ${MAGENTA}$src_node ${PURPLE}IS CONNECTING TO TOR WITH PEER ${CYAN} $dest_node! \n "
                else
                    echo -e "${CYAN}.*.*.*.*.*." | pv -qL 25
                    
                fi
            done
        else
        echo -e "${MAGENTA} No interfaces available with that name"
    fi
}



if [ $USER == root ];then 
    node_analysis
else 
    echo 'You must be root!'
    exit 
fi
