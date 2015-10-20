#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2011, edelight GmbH
# Authors:
#       Markus Korn <markus.korn@edelight.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "mongodb::mongo_gem"

# provider "Chef::Provider::Service::Init::Debian" (which is what gets chosen automatically)
# does not seem to respect service_name
service "mongodb" do
  action :nothing
end

if node[:mongodb][:install_url]
  # Include :install_url attribute to download from an alternate location
  remote_file "#{Chef::Config[:file_cache_path]}/mongodb-10gen.deb" do
    source node[:mongodb][:install_url]
  end
  dpkg_package 'mongodb-10gen' do
    action :install
    source "#{Chef::Config[:file_cache_path]}/mongodb-10gen.deb"
    version node[:mongodb][:package_version]

    # The deb package automatically starts mongo, which breaks stuff.
    # Stop it immediately, but only if something changed (i.e. install).
    # Only been tested on ubuntu 12.04 (and also might only be an issue there).
    notifies :stop, "service[mongodb]", :immediately
    notifies :disable, "service[mongodb]", :immediately
  end
else
  # Without :install_url, install from the repository
  package node[:mongodb][:package_name] do
    action :install
    version node[:mongodb][:package_version]

    # The deb package automatically starts mongo, which breaks stuff.
    # Stop it immediately, but only if something changed (i.e. install).
    # Only been tested on ubuntu 12.04 (and also might only be an issue there).
    if platform_family?("debian")
      notifies :stop, "service[mongodb]", :immediately
      notifies :disable, "service[mongodb]", :immediately
    end
  end
end

# Create keyFile if specified
if node[:mongodb][:key_file]
  file "/etc/mongodb.key" do
    owner node[:mongodb][:user]
    group node[:mongodb][:group]
    mode  "0600"
    backup false
    content node[:mongodb][:key_file]
  end
end


# configure default instance IFF it's not supposed to be part of a clustered setup
is_standalone = [
  'mongodb::replicaset',
  'mongodb::shard',
  'mongodb::configserver',
  'mongodb::mongos'
].all? do |recipe|
  if Chef::Version.new(Chef::VERSION).major < 11
    !node.recipe?(recipe)
  else
    !node.run_context.loaded_recipe?(recipe)
  end
end

if is_standalone
  mongodb_instance node['mongodb']['instance_name'] do
    mongodb_type "mongod"
    bind_ip      node['mongodb']['bind_ip']
    port         node['mongodb']['port']
    logpath      node['mongodb']['logpath']
    dbpath       node['mongodb']['dbpath']
    enable_rest  node['mongodb']['enable_rest']
    smallfiles   node['mongodb']['smallfiles']
  end
end
