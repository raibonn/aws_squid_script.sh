#!/bin/bash

#excute as root
#sudo su

#Refresh System
apt update -y
apt upgrade -y

###HTTP###
#install HTTP Proxy
apt install squid openssl

#Make symlink
systemctl enable squid

#Clear Config
#/etc/squid/squid.conf
:>| /etc/squid/squid.conf

#Write Config
echo 'include /etc/squid/conf.d/*.conf' | sudo tee -a tee /etc/squid/squid.conf > /dev/null
echo 'http_access allow all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'http_port 3128' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'coredump_dir /var/spool/squid' | sudo tee -a /etc/squid/squid.conf > /dev/null
#echo 'refresh_pattern ^ftp:           1440    20%     10080' | sudo tee -a /etc/squid/squid.conf > /dev/null
#echo 'refresh_pattern -i (/cgi-bin/|\?) 0     0%      0' | sudo tee -a /etc/squid/squid.conf > /dev/null
#echo 'refresh_pattern \/(Packages|Sources)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
#echo 'refresh_pattern \/Release(|\.gpg)$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
#echo 'refresh_pattern \/InRelease$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
#echo 'refresh_pattern \/(Translation-.*)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims' | sudo tee -a /etc/squid/squid.conf > /dev/null
#echo 'refresh_pattern .               0       20%     4320' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'acl allow_my_ip src 0.0.0.0/0' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'visible_hostname none' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'via off' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'forwarded_for delete' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'follow_x_forwarded_for deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access X-FORWARDED-FOR deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access HTTP_VIA deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access VIA deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'header_access CACHE-CONTROL deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'request_header_access Cache-Control deny all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'acl NOCACHE src all' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'cache deny NOCACHE' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'access_log none' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'cache_store_log none' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'cache_log /dev/null' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'cache_dir none /dev/null' | sudo tee -a /etc/squid/squid.conf > /dev/null
echo 'max_filedescriptors 8196' | sudo tee -a /etc/squid/squid.conf > /dev/null

#echo '* - nofile 8196' | sudo tee -a /etc/security/limits.conf > /dev/null

#echo 'max_filedescriptors 16384' | sudo tee -a /etc/security/limits.conf

#echo "max_filedescriptors 32768" >> /etc/squid/local_bottom.conf

#Start HTTP Proxy port:3128
systemctl start squid

#Edit limit
#/etc/systemd/system/multi-user.target.wants/squid.service
#sed -i '/NotifyAccess=all/i LimitNOFILE=8196' /etc/systemd/system/multi-user.target.wants/squid.service
sed -i '/NotifyAccess=all/i LimitNOFILE=8196' /usr/lib/systemd/system/squid.service
sudo systemctl daemon-reload
systemctl restart squid

###Socks5###
#install SOCKS5 Proxy
apt install dante-server

#Config Edit
echo 'internal: 0.0.0.0 port = 1080' | sudo tee -a /etc/danted.conf > /dev/null
echo 'external: enX0' | sudo tee -a /etc/danted.conf > /dev/null
echo 'socksmethod: none' | sudo tee -a /etc/danted.conf > /dev/null
echo 'clientmethod: none' | sudo tee -a /etc/danted.conf > /dev/null
echo '' | sudo tee -a /etc/danted.conf > /dev/null
echo 'client pass {' | sudo tee -a /etc/danted.conf > /dev/null
echo '  from: 0.0.0.0/0 to: 0.0.0.0/0' | sudo tee -a /etc/danted.conf > /dev/null
echo '}' | sudo tee -a /etc/danted.conf > /dev/null
echo '' | sudo tee -a /etc/danted.conf > /dev/null
echo 'socks pass {' | sudo tee -a /etc/danted.conf > /dev/null
echo '  from: 0.0.0.0/0 to: 0.0.0.0/0' | sudo tee -a /etc/danted.conf > /dev/null
echo '}' | sudo tee -a /etc/danted.conf > /dev/null

#Activate Proxy
systemctl enable danted
systemctl restart danted
