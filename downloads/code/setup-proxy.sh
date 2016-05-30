apt-get update
apt-get install -y squid3 iptables-persistent ntp byobu

# allow ip forwarding
sysctl -w net.ipv4.ip_forwarding = 1
sysctl -p /etc/sysctl.conf

# iptables setup
iptables -t nat -F
iptables -t nat -X
iptables -F
iptables -X
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-port 8123
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
iptables-save > /etc/iptables/rules.v4

# setup squid3
cat <<-EOF > /etc/squid3/squid.conf
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
acl SSL_ports port 443
acl Safe_ports port 80    # http
acl Safe_ports port 21    # ftp
acl Safe_ports port 443   # https
acl Safe_ports port 70    # gopher
acl Safe_ports port 210   # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280   # http-mgmt
acl Safe_ports port 488   # gss-http
acl Safe_ports port 591   # filemaker
acl Safe_ports port 777   # multiling http
acl CONNECT method CONNECT
http_access allow manager localhost
http_access deny manager
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localnet
http_access allow localhost
http_access deny all
http_port 3128 intercept
cache_dir ufs /var/spool/squid3 1024 16 256
maximum_object_size 30000 KB
coredump_dir /var/spool/squid3
refresh_pattern ^ftp:   1440  20% 10080
refresh_pattern ^gopher:  1440  0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
refresh_pattern .   0 20% 4320
visible_hostname webproxy
EOF
