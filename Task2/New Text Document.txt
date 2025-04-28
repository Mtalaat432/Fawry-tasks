Troubleshooting DNS and Network Connectivity Issue for internal.example.com

Problem Statement:
The internal web dashboard at internal.example.com is unreachable from multiple systems. Although the service is running, users get a "host not found" error. You suspect a DNS or network misconfiguration.

Objective:
Verify DNS Resolution and Service Reachability.

Trace potential issues (both DNS and network layers).

Propose fixes for identified issues.

1. Verify DNS Resolution
Objective:
Ensure that the domain internal.example.com resolves to the correct IP address.

How to Confirm the Root Cause:
If DNS resolution is failing, the domain will not resolve to the correct IP address.

Check if DNS settings are correct and if the /etc/hosts file is properly configured.

Commands to Fix It:
Check current DNS settings:

bash
Copy
Edit
cat /etc/resolv.conf
Ensure that DNS servers are correctly listed (e.g., 8.8.8.8 or internal DNS servers).

Test DNS Resolution for internal.example.com:

bash
Copy
Edit
nslookup internal.example.com
or

bash
Copy
Edit
dig internal.example.com
If DNS resolution fails, check /etc/hosts or DNS server configuration.

Fix the DNS resolution by adding an entry to /etc/hosts: If DNS resolution is not working, add an entry to the /etc/hosts file for direct mapping:

bash
Copy
Edit
sudo nano /etc/hosts
Add this line at the end:

bash
Copy
Edit
10.0.0.15   internal.example.com
Save and exit (Ctrl + O, Enter, Ctrl + X).

Flush DNS cache (if needed):

bash
Copy
Edit
sudo systemd-resolve --flush-caches
2. Diagnose Service Reachability
Objective:
Verify whether the web service (port 80 or 443) is reachable on the resolved IP.

How to Confirm the Root Cause:
If the web service is up but unreachable, there could be a problem with the service not listening on the correct port or network issues.

Confirm if the server is actively listening on HTTP/HTTPS ports and check for firewall blocks or misconfigurations.

Commands to Fix It:
Check if the web service is running (Apache/Nginx):

bash
Copy
Edit
sudo systemctl status apache2
or

bash
Copy
Edit
sudo systemctl status nginx
If the service is not running, start it:

bash
Copy
Edit
sudo systemctl start apache2
or

bash
Copy
Edit
sudo systemctl start nginx
Check if the server is listening on the correct port (80/443):

bash
Copy
Edit
sudo ss -tuln | grep ':80'
or

bash
Copy
Edit
sudo netstat -tuln | grep ':80'
If there is no output, the web service is not listening on port 80 (or 443). You may need to configure the server to listen on these ports or check your firewall settings.

Test the service's reachability:

Use curl to test if the web service is reachable:

bash
Copy
Edit
curl http://internal.example.com
Alternatively, use telnet to test the connection:

bash
Copy
Edit
telnet internal.example.com 80
If the connection is refused or times out, ensure the web server is running and accepting traffic on that port.

Check firewall settings (if you haven't already):

Ensure the firewall isn't blocking the web server ports:

bash
Copy
Edit
sudo ufw status
If firewall is enabled, allow HTTP/HTTPS traffic:

bash
Copy
Edit
sudo ufw allow 80
sudo ufw allow 443
3. Trace the Issue – Possible Causes
Objective:
List all possible reasons why internal.example.com might be unreachable, even if the service is up and running.

Possible Causes:
DNS Misconfiguration:

Incorrect DNS settings or /etc/hosts misconfiguration.

External DNS server issues.

Service Not Running:

Apache/Nginx is not running or is listening on the wrong port.

Firewall Blocking Traffic:

UFW (Uncomplicated Firewall) or another firewall is blocking the required ports (80/443).

Network Connectivity Issues:

The VM may not have proper network connectivity or may be using a NAT network.

How to Confirm the Root Cause:
DNS Issue: Test with nslookup or dig. Add an entry to /etc/hosts if necessary.

Service Issue: Check if Apache/Nginx is running and if the server is listening on the required ports.

Firewall Issue: Ensure UFW is not blocking ports 80/443.

Network Connectivity: Ensure proper network settings and confirm if the VM's network interface is working.

4. Propose and Apply Fixes
For Each Potential Issue:
Issue 1: DNS Misconfiguration
Confirm: Check if internal.example.com resolves correctly using nslookup or dig.

Fix:

Add the correct IP and domain to /etc/hosts.

Ensure that /etc/resolv.conf points to the correct DNS servers.

Flush DNS cache with sudo systemd-resolve --flush-caches.

Issue 2: Service Not Running
Confirm: Check the status of Apache/Nginx using systemctl.

Fix:

Start the service using sudo systemctl start apache2 or sudo systemctl start nginx.

Check if the service is listening on the required ports using ss -tuln or netstat.

Issue 3: Firewall Blocking Traffic
Confirm: Check firewall status with sudo ufw status.

Fix:

Allow HTTP and HTTPS ports through the firewall:

bash
Copy
Edit
sudo ufw allow 80
sudo ufw allow 443
Issue 4: Network Connectivity
Confirm: Check the VM's network settings and IP address with ip addr show.

Fix: Restart networking services or renew IP address:

bash
Copy
Edit
sudo systemctl restart networking
sudo dhclient
5. Bonus: Configure Local /etc/hosts Entry
For testing, you can configure a local entry in /etc/hosts to bypass DNS for internal.example.com.

Add a Local Entry:
Open /etc/hosts:

bash
Copy
Edit
sudo nano /etc/hosts
Add the following line at the end of the file:

bash
Copy
Edit
10.0.0.15    internal.example.com
Save and exit (Ctrl + O, Enter, Ctrl + X).

Persist DNS Settings:
To ensure that DNS settings are persistent:

Use systemd-resolved or NetworkManager for managing DNS configurations.

Example to set DNS via systemd-resolved:

bash
Copy
Edit
sudo systemctl restart systemd-resolved
sudo resolvectl dns eth0 8.8.8.8
