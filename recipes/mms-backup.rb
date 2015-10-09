#
# Cookbook Name:: mongodb
# Recipe:: mms-backup
#
# Copyright 2011, Treasure Data, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt'
include_recipe 'python'
python_pip 'pymongo'

# preparation
user node[:mongodb][:mms_backup][:user] do
  comment 'User that the mms backup and monitoring agents run as'
  notifies :restart, 'service[mongodb-mms-backup-agent]', :delayed
end

directory '/mnt/log/mongodb-mms' do
  recursive true
  owner node[:mongodb][:mms_backup][:user]
  group node[:mongodb][:mms_backup][:group]
  mode '0755'
  ignore_failure true
end

# TODO: Add a delete step if this dir already exists and is a regular directory?
link node[:mongodb][:mms_backup][:log_dir] do
  to '/mnt/log/mongodb-mms'
  ignore_failure true
end

# installation
deb_file = "#{Chef::Config[:file_cache_path]}/mms_backup.deb"
provider = Chef::Provider::Package::Dpkg
package_opts = '--force-confold' # do not modify the current configuration file

remote_file deb_file do
  source node[:mongodb][:mms_backup][:install_url]
end
package "mongodb-mms-backup-agent" do
  source deb_file
  provider provider
  options package_opts
  version node[:mongodb][:mms_backup][:version]
end

# create a resource to the service
service 'mongodb-mms-backup-agent' do
  supports [ :enable, :disable, :start, :stop, :restart, :reload ]
  # force upstart
  provider Chef::Provider::Service::Upstart
  action :nothing
end

# configuration
template node[:mongodb][:mms_backup][:config_file] do
  source 'backup-agent.config.erb'
  variables :api_key => node[:mongodb][:mms_backup][:api_key]
  notifies :enable, 'service[mongodb-mms-backup-agent]', :delayed
  notifies :restart, 'service[mongodb-mms-backup-agent]', :delayed
end
