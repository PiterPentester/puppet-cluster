#!/usr/bin/env bash
# Bootstraping puppet MASTER

# configure hosts
echo "10.0.0.11    worker1
10.0.0.12    worker2" >> /etc/hosts

# add repo
rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm

# update
yum -y update

# install postgres9.6
yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y

yum install postgresql96 postgresql96-server postgresql96-contrib postgresql96-libs -y

# init DB
/usr/pgsql-9.6/bin/postgresql96-setup initdb

# enable postgres9
systemctl enable postgresql-9.6.service
systemctl start postgresql-9.6.service

# configure postgres9
# sudo -i -u postgres sh
sudo -i -u postgres bash -c "psql -c \"CREATE USER puppetdb WITH PASSWORD 'puppetdbPass';\"" createuser -DRSP puppetdb
sudo -i -u postgres sh
createdb -E UTF8 -O puppetdb puppetdb
psql puppetdb -c 'create extension pg_trgm'
exit

# change pg_hba
sed -i 's|host    all             all             ::1/128                 ident|host    all             all             ::1/128                 md5|g' /var/lib/pgsql/9.6/data/pg_hba.conf
sed -i 's:host    all             all             127.0.0.1/32            ident:host    all             all             127.0.0.1/32            md5:g' /var/lib/pgsql/9.6/data/pg_hba.conf

# restart postgres9
service postgresql-9.6.service restart

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

# install server & puppetdb
yum install -y puppetserver puppetdb puppetdb-termini

# install puppet tools
rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-7.noarch.rpm

yum install pdk -y

# configure puppetdb
sed -i 's|# subname = //localhost:5432/puppetdb|subname = //localhost:5432/puppetdb|g' /etc/puppetlabs/puppetdb/conf.d/database.ini

sed -i 's|# username = foobar|username = puppetdb|g' /etc/puppetlabs/puppetdb/conf.d/database.ini

sed -i 's|# password = foobar|password = puppetdbPass|g' /etc/puppetlabs/puppetdb/conf.d/database.ini

sed -i 's|# gc-interval = 60|gc-interval = 20|g' /etc/puppetlabs/puppetdb/conf.d/database.ini

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
systemctl start puppetserver
systemctl start puppet

# download wget module
/opt/puppetlabs/bin/puppet module install maestrodev-wget
