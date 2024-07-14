#!/bin/bash
sudo su
yum update -y
yum install -y squid
systemctl enable squid
sed -i 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf
echo 'acl allow_my_ip src 0.0.0.0/0' | sudo tee -a /etc/squid/squid.conf
echo 'visible_hostname none' | sudo tee -a /etc/squid/squid.conf
echo 'forwarded_for off' | sudo tee -a /etc/squid/squid.conf
echo 'header_access X-FORWARDED-FOR deny all' | sudo tee -a /etc/squid/squid.conf
echo 'header_access HTTP_VIA deny all' | sudo tee -a /etc/squid/squid.conf
echo 'header_access VIA deny all' | sudo tee -a /etc/squid/squid.conf
echo 'header_access CACHE-CONTROL deny all' | sudo tee -a /etc/squid/squid.conf
systemctl start squid