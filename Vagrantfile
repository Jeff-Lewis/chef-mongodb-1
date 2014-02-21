# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64-cloud.2013-06-25"
  config.vm.box_url = "https://s3.amazonaws.com/kabam-vagrant-boxes/precise64-cloud.2013-06-25.box"

  config.vm.hostname = "chef-mongodb"
  config.vm.network :private_network, ip: "10.10.10.60"

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.omnibus.chef_version = '11.8.2'

  config.vm.provider :virtualbox do |vb|
    vb.customize [ "modifyvm", :id, "--memory", "768" ]
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mongodb => {
        :auto_configure => {
          :replicaset => false,
          :sharding => false
        },
        :nojournal => true,
        :mms_agent => {
          :api_key => "#{ENV['MMS_API_KEY']}",
          :secret_key => "#{ENV['MMS_SECRET_KEY']}",
          :install_dir => "/opt/mongodb/mms-agent",
          :install_munin => false,
          :enable_munin => false
        }
      }
    }

    #chef.environment = 'vagrant'
    #chef.log_level = :debug

    chef.run_list = [
      "recipe[apt::default]",
      "recipe[mongodb::10gen_repo]",
      "recipe[mongodb::default]",
      #"recipe[mongodb::mms-agent]",
      "recipe[mongodb::mms-backup]"
    ]
  end
end
