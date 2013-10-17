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

# TODO do this only for when installing via .deb (OS check should be okay)
execute "kill initial mongodb" do
  command "service mongodb stop && rm -rf /etc/init.d/mongodb"
  action :nothing
end

package node[:mongodb][:package_name] do
  action :install
  version node[:mongodb][:package_version]
  # the deb package automatically starts mongo, which breaks stuff. stop it,
  # immediately, but only if something changed (i.e. install).
  notifies :run, "execute[kill initial mongodb]", :immediately
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
replicaset_recipe = 'mongodb::replicaset'
shard_recipe = 'mongodb::shard'
configserver_recipe = 'mongodb::configserver'
mongos_recipe = 'mongodb::mongos'
is_standalone = case Chef::Version.new(Chef::VERSION).major
  when 0..10 then
    !node.recipe?(replicaset_recipe) &&
    !node.recipe?(shard_recipe) &&
    !node.recipe?(configserver_recipe) &&
    !node.recipe?(mongos_recipe)
  else
    !node.run_context.loaded_recipe?(replicaset_recipe) &&
    !node.run_context.loaded_recipe?(shard_recipe) &&
    !node.run_context.loaded_recipe?(configserver_recipe) &&
    !node.run_context.loaded_recipe?(mongos_recipe)
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
