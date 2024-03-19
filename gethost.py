"""
Tries to determine the IP address to the Host PC. Appends this IP and a
more friendly hostname (ex `hostpc`) to the /etc/hosts file. Note that
this appends unconditionally, without any checks to see if the hostname
was already added.
"""
import socket
import sys 

ip_list = set()
ais = socket.getaddrinfo("host.docker.internal", 0, 0, 0, 0)

for result in ais:
    ip_list.add(result[-1][0])

if not len(ip_list):
    print("No IPs found. Try `nslookup host.docker.internal`")
    sys.exit(1)

if len(ip_list) > 1:
    all_ips = ", ".join(ip_list)
    print(f"Multiple IPs found: {all_ips}")
    sys.exit(1)

host_ip = list(ip_list)[0]
print(f"Found Host IP: {host_ip}")

with open("/etc/hosts", "a") as file:
    file.write(f"{host_ip} hostpc\n")
