default['mongodb']['mms_agent']['api_key'] = '@API_KEY@'
default['mongodb']['mms_agent']['secret_key'] = '@SECRET_KEY@'

default['mongodb']['mms_agent']['install_dir'] = '/usr/local/share'
default['mongodb']['mms_agent']['log_dir'] = "#{node[:mongodb][:logpath]}/agent"

# because the agent download url is currently not versioned, this solely documentation with no actual checks in place
default['mongodb']['mms_agent']['version'] = '1.6.2'
# this is only an optimization, new versions will still be downloaded; see http://docs.opscode.com/resource_remote_file.html for details about the checksum attribute
default['mongodb']['mms_agent']['checksum'] = '0bdc41d8ec48db83c879d8cfdf0f370055d38601d98c0d17cc4416f4cebe2d80'
