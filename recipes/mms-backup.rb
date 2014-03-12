#
# Cookbook Name:: mongodb
# Recipe:: mms-agent
#
# Copyright 2011, Treasure Data, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'python'
python_pip 'pymongo'

# installation
deb_file = "#{Chef::Config[:file_cache_path]}/mms_backup.deb"
remote_file deb_file do
  source node[:mongodb][:mms_backup][:install_url]
end
dpkg_package "mongodb-mms-backup-agent" do
  source deb_file
  action :install
end

# create a resource to the service
service 'mongodb-mms-backup-agent' do
  supports [ :start, :stop, :restart, :reload ]
  # force upstart
  provider Chef::Provider::Service::Upstart
  action :nothing
end

# configuration
template node[:mongodb][:mms_backup][:config_file] do
  source 'backup-agent.config.erb'
  variables :api_key => node[:mongodb][:mms_backup][:api_key]
  notifies :restart, 'service[mongodb-mms-backup-agent]', :delayed
end
