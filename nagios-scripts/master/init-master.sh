#!/usr/bin/env bash

# disable selinux
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# install packages
yum install -y gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix

# get sources
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar xzf nagioscore.tar.gz

# compile
cd /tmp/nagioscore-nagios-4.4.6/
./configure
make all

# create users
make install-groups-users
usermod -a -G nagios apache

# install binaries
make install

# install services
make install-daemoninit
systemctl enable httpd.service

# install command mode
make install-commandmode

# install configs
make install-config

# install apache configs
make install-webconf

# configure firewall
#firewall-cmd --zone=public --add-port=80/tcp --permanent
#firewall-cmd --reload

# configure nagios
sed -i 's:#cfg_dir=/usr/local/nagios/etc/servers:cfg_dir=/usr/local/nagios/etc/servers:g' /usr/local/nagios/etc/nagios.cfg

# make dir
mkdir /usr/local/nagios/etc/servers

# config
echo "define command{
        command_name check_nrpe
        command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}" >> /usr/local/nagios/etc/objects/commands.cfg

# Create nagiosadmin User Account
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# start apache
systemctl start httpd.service

# start nagios
systemctl start nagios.service

# start at boot
chkconfig nagios on
