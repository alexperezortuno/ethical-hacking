# Ethical Hacking Docker Container
This Docker container is a lightweight, portable environment equipped with popular tools for ethical hacking and penetration testing of Wi-Fi and network infrastructures. It includes essential utilities such as Aircrack-ng, Nmap, Wireshark, and more, allowing security professionals and enthusiasts to assess network vulnerabilities efficiently.

## Features
- Aircrack-ng: Test the security of Wi-Fi networks by capturing packets, performing deauthentication attacks, and cracking WPA/WPA2 keys.
- Nmap: Scan network devices, open ports, and discover potential vulnerabilities.
- Wireshark: Analyze network traffic for detailed packet inspection.
- John the Ripper: Perform password cracking for various formats.
- Ettercap: Conduct Man-in-the-Middle (MITM) attacks and analyze ARP poisoning scenarios.
- Python Support: Run custom scripts for automation or result notifications (e.g., Slack or email).
- Custom Bash Scripts: Automates Wi-Fi testing workflows for ethical hacking scenarios.

## How to Use
Build the container:

```shell
docker build -t ethical-hacking .
```

Run the container:

```shell
docker run --rm -it --privileged --net=host ethical-hacking
```

Use the pre-installed tools or execute custom scripts located in the /tools directory.

Example: Running a Wi-Fi Test Script
```shell 
/tools/aircrack_test.sh <INTERFACE> <NETWORK_NAME>
```

## Precautions
### Legal Authorization:

This container is strictly intended for authorized use only. Ensure you have explicit permission from the network owner before performing any tests.
Unauthorized use of these tools may violate laws and regulations and can result in severe penalties.
Ethical Use:

This container is designed for educational purposes, vulnerability assessment, and network hardening.
Do not use this container for malicious purposes or unauthorized hacking.

## Security:

Ensure you run the container in a secure environment to avoid misuse.
Avoid running the container on untrusted networks without proper isolation.
Disclaimer
The authors of this container are not responsible for any misuse or damages caused by the improper use of this software.
Always adhere to local laws and ethical guidelines when performing penetration testing or vulnerability assessments.
This container is provided "as is," with no guarantees of accuracy or fitness for a particular purpose.
Contributions
Feel free to contribute by submitting pull requests or opening issues on the GitHub repository. Together, we can improve this tool for ethical hacking and network security.
