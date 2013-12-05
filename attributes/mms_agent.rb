default[:mongodb][:mms_agent][:api_key] = ""
default[:mongodb][:mms_agent][:secret_key] = ""

# shouldn't need to changed, but configurable anyways
default[:mongodb][:mms_agent][:install_url] = "https://mms.mongodb.com/settings/mms-monitoring-agent.zip"
default[:mongodb][:mms_agent][:install_dir] = "/usr/local/share/mms-agent"
default[:mongodb][:mms_agent][:log_dir] = "#{node[:mongodb][:logpath]}/agent"
default[:mongodb][:mms_agent][:install_munin] = true
# this is the debian package name
default[:mongodb][:mms_agent][:munin_package] = 'munin-node'
default[:mongodb][:mms_agent][:enable_munin] = true
