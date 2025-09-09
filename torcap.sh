#!/bin/bash
#This tool is made for ethical purposes only. Use this with responsibility, respecting privacy, consent, and the rights of others.
#It’s essential to ensure that the tool serves to promote positive outcomes, improve knowledge, and contribute to the well-being of all.
#Always consider the potential impact of your actions and decisions when using this technology.

#Please install pv and jq before using the tool.
#apt-get install pv and apt-get install install jq
#Happy hunting :)

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\e[1;36m'

echo -e "${CYAN}
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
            echo -e "${GREEN}     $i" | tr -d ":"
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
        echo -e "${CYAN}INTERFACE SELECTED: $choose_option :)"

            echo -e "${RED}STARTING.."

            tcpdump -i $choose_option 'tcp and (not src host 127.0.0.1 and not dst host 127.0.0.1) and not arp' -n 2>&1| grep -v "tcpdump"| 
            while read -r line;do
                src_node=$(echo "$line" | grep -oP 'IP \K[0-9.]+(?=\.[0-9]+ >)' )
                dest_node=$(echo "$line" | grep -oP '> \K[0-9.]+(?=\.[0-9]+:)' )


                
                check_request=$(curl -s https://onionoo.torproject.org/details?search=$dest_node)
  
                if [[ $check_request == *"fingerprint"* ]];then
                    echo -e "${GREEN}TOR CONNECTION FOUND!"
                    echo -e "${GREEN}   SOURCE NODE:${RED} $src_node"
                    echo -e "${GREEN}   DESTINATION:${RED} $dest_node"

                    fingerprint=$(echo "$check_request" | jq -r '.relays[0].fingerprint')
                    peer_nickname=$(echo "$check_request" | jq -r '.relays[0].nickname')
                    country=$(echo "$check_request" | jq -r '.relays[0].country_name')
                    contact=$(echo "$check_request" | jq -r '.relays[0].contact')
                    as_name=$(echo "$check_request" | jq -r '.relays[0].as_name')

                    echo "      Fingerprint: $fingerprint"
                    echo "      Peer nickname: $peer_nickname"
                    echo "      Country: $country"
                    echo "      AS Name: $as_name"
                    echo "      Contact: $contact"


                    echo -e "${GREEN}   CLIENT ${RED}$src_node ${GREEN}IS CONNECTING TO TOR WITH PEER WITH${RED} $dest_node! \n "
                else
                    echo ".*.*.*.*.*." | pv -qL 25
                    
                fi
            done
        else
        echo -e "${RED} No interfaces available with that name"
    fi
}



if [ $USER == root ];then 
    node_analysis
else 
    echo 'You must be root!'
    exit 
fi
