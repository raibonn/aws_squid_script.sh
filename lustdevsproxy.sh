#!/bin/bash
sudo su
apt update -y
apt upgrade -y
apt install squid openssl
systemctl enable squid
:>| /etc/squid/squid.conf
echo 'include /etc/squid/conf.d/*.conf' | sudo tee -a tee /etc/squid/squid.conf > /dev/null
echo 'http_access allow all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'http_port 3128' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'coredump_dir /var/spool/squid' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'refresh_pattern ^ftp:           1440    20%     10080' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'refresh_pattern -i (/cgi-bin/|\?) 0     0%      0' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'refresh_pattern \/(Packages|Sources)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'refresh_pattern \/Release(|\.gpg)$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'refresh_pattern \/InRelease$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'refresh_pattern \/(Translation-.*)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'refresh_pattern .               0       20%     4320' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'acl allow_my_ip src 0.0.0.0/0' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'visible_hostname none' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'via off' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'forwarded_for delete' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'follow_x_forwarded_for deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access X-FORWARDED-FOR deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access HTTP_VIA deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access VIA deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access CACHE-CONTROL deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'cache deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'access_log none' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'cache_store_log none' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'cache_log /dev/null' | sudo tee -a /etc/squid/squid.conf > /dev/null
systemctl start squid