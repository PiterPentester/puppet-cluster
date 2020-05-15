# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.


Vagrant.configure("2") do |config|

  #config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.synced_folder ".", "/mnt/host_machine"
  # Init & bootstrap MASTER for puppet
  config.vm.define :master do |master|
    master.vm.provider :virtualbox do |v|
      v.memory = 2048
      v.cpus = 2
    end
    master.vm.box = "centos/7"
    master.vm.hostname = "puppet"
    master.vm.network :private_network, ip: "10.0.0.10"
    master.vm.provision :shell, path: "bootstrap-master.sh"
  end

  # Init & bootstrap AGENTS for puppet
  %w{worker1 worker2}.each_with_index do |name, i|
    config.vm.define name do |worker|
      worker.vm.provider :virtualbox do |v|
        v.memory = 1024
        v.cpus = 1
      end
      worker.vm.box = "centos/7"
      worker.vm.hostname = name
      worker.vm.network :private_network, ip: "10.0.0.#{i + 11}"
      worker.vm.provision :shell, path: "bootstrap-agent.sh"
    end
  end

end
