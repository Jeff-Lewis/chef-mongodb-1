default[:mongodb][:mms_backup][:api_key] = ""

# shouldn't need to changed, but configurable anyways
default[:mongodb][:mms_backup][:install_url] = "https://mms.mongodb.com/download/agent/backup/mongodb-mms-backup-agent_1.4.2.23-1_amd64.deb"

# the following are not configurable, but listed here for reference
default[:mongodb][:mms_backup][:config_file] = "/etc/mongodb-mms/backup-agent.config"
default[:mongodb][:mms_backup][:log_file] = "/var/log/mongodb-mms/backup-agent.log"
