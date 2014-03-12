#
# Cookbook Name:: mongodb
# Recipe:: mms-agent
#
# Copyright 2011, Treasure Data, Inc.
#
# All rights reserved - Do Not Redistribute
#

# create a resource to the service
service 'mongodb-mms-monitoring-agent' do
  supports [ :enable, :disable, :start, :stop, :restart, :reload ]
  # force upstart
  provider Chef::Provider::Service::Upstart
  action [ :stop, :disable ]
end
