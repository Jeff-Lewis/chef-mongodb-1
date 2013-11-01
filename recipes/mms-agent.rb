#
# Cookbook Name:: mongodb
# Recipe:: mms-agent
#
# Copyright 2011, Treasure Data, Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'python'

require 'fileutils'
chef_gem 'rubyzip'

# munin-node for hardware info
package 'munin-node'
# python dependencies
python_pip 'pymongo'

# download, and unzip if it's changed
package 'unzip'
remote_file '/tmp/10gen-mms-agent.zip' do
  source 'https://mms.10gen.com/settings/10gen-mms-agent.zip'
  # irrelevant because of https://jira.mongodb.org/browse/MMSSUPPORT-2258
  checksum node.mongodb.mms_agent.checksum
  notifies :run, "bash[unzip 10gen-mms-agent]", :immediately
end
bash 'unzip 10gen-mms-agent' do
  cwd '/tmp/'
  code "rm -rf #{node.mongodb.mms_agent.install_dir} && unzip -o -d #{node.mongodb.mms_agent.install_dir} /tmp/10gen-mms-agent.zip"
  action :nothing
  only_if {
    def checksum_zip_contents(zipfile)
      require 'zip/filesystem'
      require 'digest'

      files = Zip::File.open(zipfile).collect.reject{|f| f.name_is_directory?}.sort
      content = files.map{|f| f.get_input_stream.read}.join
      Digest::SHA256.hexdigest content
    end
    new_checksum = checksum_zip_contents('/tmp/10gen-mms-agent.zip')
    Chef::Log.debug "new checksum = #{new_checksum}, expected = #{node.mongodb.mms_agent.checksum}"
    !File.exist?("#{node.mongodb.mms_agent.install_dir}/settings.py") || new_checksum != node.mongodb.mms_agent.checksum
  }
end

# runit and agent logging
directory node.mongodb.mms_agent.log_dir do
  action :create
  recursive true
end
include_recipe 'runit::default'
mms_agent_service = runit_service 'mms-agent' do
  template_name 'mms-agent'
  cookbook 'mongodb'
  options({
    :mms_agent_install_dir => node.mongodb.mms_agent.install_dir,
    :mms_agent_log_dir => node.mongodb.mms_agent.log_dir
  })
  action :nothing
end

# update settings.py and restart the agent if there were any key changes
ruby_block 'modify settings.py' do
  block do
    orig_s = ''
    open("#{node.mongodb.mms_agent.install_dir}/mms-agent/settings.py") { |f|
      orig_s = f.read
    }
    s = orig_s
    s = s.gsub(/mms\.10gen\.com/, 'mms.10gen.com')
    s = s.gsub(/mms_key = ".*"/, "mms_key = \"#{node['mongodb']['mms_agent']['api_key']}\"")
    s = s.gsub(/secret_key = ".*"/, "secret_key = \"#{node['mongodb']['mms_agent']['secret_key']}\"")
    if s != orig_s
      Chef::Log.debug "Settings changed, overwriting and restarting service"
      open("#{node.mongodb.mms_agent.install_dir}/mms-agent/settings.py", 'w') { |f|
        f.puts(s)
      }
      notifies :enable, mms_agent_service, :delayed
      notifies :restart, mms_agent_service, :delayed
    end
  end
end
