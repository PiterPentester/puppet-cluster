#!/usr/bin/env bash

# get sources & install
cd /tmp

wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.0.3/nrpe-4.0.3.tar.gz

tar -xvf nrpe-4.0.3.tar.gz

cd nrpe-4.0.3

./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu


make all
make install
make install-xinetd
make install-daemon-config

sed -i 's/only_from       = 127.0.0.1 ::1/only_from       = 127.0.0.1 ::1 10.0.0.10/g' /etc/xinetd.d/nrpe.cfg

sudo service xinetd restart
