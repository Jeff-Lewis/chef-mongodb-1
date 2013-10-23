# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64-cloud.2013-06-25"
  config.vm.box_url = "https://s3.amazonaws.com/kabam-vagrant-boxes/precise64-cloud.2013-06-25.box"

  config.vm.hostname = "chef-mongodb"
  config.vm.network :private_network, ip: "10.10.10.60"

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "768"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mongodb => {
        :auto_configure => {
          :replicaset => false,
          :sharding => false
        }
      }
    }

    chef.run_list = [
      "recipe[mongodb::10gen_repo]",
      #"recipe[mongodb::default]"
      "recipe[mongodb::shard]",
      "recipe[mongodb::replicaset]"
    ]
  end
end
