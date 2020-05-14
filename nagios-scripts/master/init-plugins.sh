#!/usr/bin/env bash

# install packages
yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
yum install -y perl-Net-SNMP

# get sources
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
tar zxf nagios-plugins.tar.gz

# compile & install
cd /tmp/nagios-plugins-release-2.3.3/
./tools/setup
./configure
make
make install

# restart services
systemctl restart nagios httpd nrpe
