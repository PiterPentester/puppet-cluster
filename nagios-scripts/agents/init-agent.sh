#!/usr/bin/env bash

# install epel
yum install -y epel-release

# install nrpe
yum install -y nrpe nagios-plugins-all

sed -i 's/allowed_hosts=127.0.0.1 ::1/allowed_hosts=127.0.0.1 ::1 10.0.0.10/g' /etc/nagios/nrpe.cfg

# start services
systemctl start nrpe.service
systemctl enable nrpe.service
