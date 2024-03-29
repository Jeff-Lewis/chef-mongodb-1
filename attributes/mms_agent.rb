default[:mongodb][:mms_agent][:api_key] = ""

default[:mongodb][:mms_agent][:version] = "3.2.0.177-1"
default[:mongodb][:mms_agent][:install_url] = "https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_#{node[:mongodb][:mms_agent][:version]}_amd64.deb"

# the following are not configurable (they come from the .deb installer), but
# listed here for reference
default[:mongodb][:mms_agent][:config_file] = "/etc/mongodb-mms/monitoring-agent.config"
default[:mongodb][:mms_agent][:log_file] = "/var/log/mongodb-mms/monitoring-agent.log"
default[:mongodb][:mms_agent][:log_dir] = "/var/log/mongodb-mms"
default[:mongodb][:mms_agent][:user] = "mongodb-mms-agent"
default[:mongodb][:mms_agent][:group] = "mongodb-mms-agent"

# configurable options
default[:mongodb][:mms_agent][:enable_munin] = true
