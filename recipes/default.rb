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

include_recipe "mongodb::install"

# Create keyFile if specified
if node[:mongodb][:key_file_content] then
  file node[:mongodb][:config][:keyFile] do
    owner node[:mongodb][:user]
    group node[:mongodb][:group]
    mode  "0600"
    backup false
    content node[:mongodb][:key_file_content]
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
