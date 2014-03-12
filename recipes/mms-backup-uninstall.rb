#
# Cookbook Name:: mongodb
# Recipe:: mms-agent
#
# Copyright 2011, Treasure Data, Inc.
#
# All rights reserved - Do Not Redistribute
#

dpkg_package 'mongodb-mms-backup-agent' do
  action :purge
end
