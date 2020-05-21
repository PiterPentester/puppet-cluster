# restart puppetserver
sudo systemctl restart puppetserver

# change hosts


# start (on agent)
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

#request signing from master (on agent)
sudo /opt/puppetlabs/bin/puppet agent --test

# sign worker cert (on master)
sudo /opt/puppetlabs/bin/puppetserver ca sign --certname worker1.puppet.io


# MANIFESTS works only in manifests dir
/etc/puppetlabs/code/environments/production/manifests/



## FIX CERT errors
# on worker
sudo rm -rf /etc/puppetlabs/puppet/ssl
# on master
sudo /opt/puppetlabs/bin/puppetserver ca clean --cetname YOU_CERT_NAME
