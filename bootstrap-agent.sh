#!/usr/bin/env bash
# Bootstraping puppet AGENT

# configure hostnames

if [ "$(hostname)" == "worker1" ]; then
  echo "10.0.0.10    master.puppet.io puppet
  10.0.0.12    worker2.puppet.io worker2" >> /etc/hosts
  sed -i 's|^127.0.0.1|127.0.0.1   worker1.puppet.io|' /etc/hosts
elif [ "$(hostname)" == "worker2" ]; then
  echo "10.0.0.10    master.puppet.io puppet
  10.0.0.11    worker1.puppet.io worker2" >> /etc/hosts
  sed -i 's|^127.0.0.1|127.0.0.1   worker2.puppet.io|' /etc/hosts
fi

# add repo
rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm

# update
yum -y update

# install ntp
yum -y install ntp ntpdate

# configure ntp
ntpdate 0.centos.pool.ntp.org

# enable ntpdate
systemctl enable ntpd

# disable selinux
sed -i 's/SELINUX=enabled/SELINUX=disabled/g' /etc/sysconfig/selinux

# install Java 1.8
yum install -y java-1.8.0-openjdk wget

# install AGENTS
yum install -y puppet-agent

# configure AGENT
echo "[main]
 certname = $(hostname -f)
 server = master.puppet.io
 environment = production
 runinterval = 10m" >> /etc/puppetlabs/puppet/puppet.conf

# run AGENT
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
