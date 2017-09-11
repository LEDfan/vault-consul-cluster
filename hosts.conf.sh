#!/bin/bash
cat << EOF > /etc/resolv.conf
nameserver 172.16.25.10
nameserver 208.67.222.222
nameserver 208.67.220.220
EOF

sudo yum install -y vim telnet bind-utils
