# TorCap
TOR Node Sniffer

This Bash script is designed for ethical network analysis, specifically to detect and identify connections to the Tor network and client inside the network receiving / sending data over TOR. It listens to network traffic, filters out specific IP addresses, and checks whether the destination node belongs to a Tor relay. If it does, the script retrieves information such as the Tor relay's fingerprint, nickname, country, and contact details. 

# Important Disclaimer

This tool is made for ethical purposes only. Use it responsibly and always respect privacy, consent, and the rights of others. It is crucial to ensure that the tool is used to promote positive outcomes, improve knowledge, and contribute to the well-being of all.

Never use this tool for malicious activities. Always consider the impact of your actions.

# Man-in-the-middle (MITM)

To use this script effectively, you must perform a Man-In-The-Middle (MITM) or ARP Spoofing attack on the network to intercept the traffic. Without such an interception, the script will only monitor or analyze traffic coming out from your system.

This is crucial because the script works by sniffing TCP packets within the network, and it relies on this method to identify any devices that may be unknowingly connecting to the Tor network (for example, due to malware infections). It cannot passively monitor network traffic without first performing one of these types of attacks.

# Features
- Network Traffic Monitoring: Captures and analyzes TCP traffic.
- Tor Relay Detection: Identifies connections to Tor relays based on destination IPs.
- Relay Information Retrieval: Retrieves details such as fingerprint, nickname, country, and AS name for Tor relays.

# Requirements
sudo apt-get install pv && sudo apt-get install jq

# Usage
`sudo ./tor-node-analyzer.sh`
