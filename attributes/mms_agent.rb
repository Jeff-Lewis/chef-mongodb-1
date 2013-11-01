default['mongodb']['mms_agent']['api_key'] = '@API_KEY@'
default['mongodb']['mms_agent']['secret_key'] = '@SECRET_KEY@'

default['mongodb']['mms_agent']['install_dir'] = '/usr/local/share'
default['mongodb']['mms_agent']['log_dir'] = "#{node[:mongodb][:logpath]}/agent"

# because the agent download url is currently not versioned, this solely documentation with no actual checks in place
default['mongodb']['mms_agent']['version'] = '1.6.1'
# this is only an optimization, new versions will still be downloaded; see http://docs.opscode.com/resource_remote_file.html for details about the checksum attribute
default['mongodb']['mms_agent']['checksum'] = '498181cbaf9b24f9dfbf70a5bacb0d238d368793d2c1a270cf636793c4eb3a55'
