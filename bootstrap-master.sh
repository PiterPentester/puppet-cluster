#!/usr/bin/env bash
# Bootstraping puppet MASTER

# configure hosts
echo "10.0.0.11    worker1
10.0.0.12    worker2" >> /etc/hosts

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
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# install Java 1.8
yum install -y java-1.8.0-openjdk wget

# install server
yum install -y puppetserver

# configure puppetserver
sed -i 's/JAVA_ARGS="-Xms2g -Xmx2g -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger"/JAVA_ARGS="-Xms1g -Xmx1g -Djruby.logger.class=com.puppetlabs.jruby_utils.jruby.Slf4jLogger"/g' /etc/sysconfig/puppetserver

echo "[master]
 dns_alt_names=master.puppet.io,puppet

 [main]
 certname = master.puppet.io
 server = master.puppet.io
 environment = production
 runinterval = 10m" >> /etc/puppetlabs/puppet/puppet.conf

# enable & start puppetserver
systemctl enable puppetserver
