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
deb_file = "#{Chef::Config[:file_cache_path]}/mms_agent.deb"
package_opts = '--force-confold' # do not modify the current configuration file

remote_file deb_file do
  source node[:mongodb][:mms_agent][:install_url]
end
package "mongodb-mms-monitoring-agent" do
  source deb_file
  options package_opts
  action :install
  version node[:mongodb][:mms_agent][:version]
end

# create a resource to the service
service 'mongodb-mms-monitoring-agent' do
  supports [ :enable, :disable, :start, :stop, :restart, :reload ]
  # force upstart
  provider Chef::Provider::Service::Upstart
  action :nothing
end

# configuration
template node[:mongodb][:mms_agent][:config_file] do
  source 'monitoring-agent.config.erb'
  variables({
    :api_key => node[:mongodb][:mms_agent][:api_key],
    :enable_munin => node[:mongodb][:mms_agent][:enable_munin],
  })
  notifies :enable, 'service[mongodb-mms-monitoring-agent]', :delayed
  notifies :restart, 'service[mongodb-mms-monitoring-agent]', :delayed
end
