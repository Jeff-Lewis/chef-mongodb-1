default[:mongodb][:mms_backup][:api_key] = ""

default[:mongodb][:mms_backup][:version] = "2.4.0.156-1"
default[:mongodb][:mms_backup][:install_url] = "https://mms.mongodb.com/download/agent/backup/mongodb-mms-backup-agent_#{node[:mongodb][:mms_backup][:version]}_amd64.deb"

# the following are not configurable (they come from the .deb installer), but
# listed here for reference
default[:mongodb][:mms_backup][:config_file] = "/etc/mongodb-mms/backup-agent.config"
default[:mongodb][:mms_backup][:log_file] = "/var/log/mongodb-mms/backup-agent.log"
