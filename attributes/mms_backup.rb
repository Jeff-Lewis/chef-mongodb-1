default[:mongodb][:mms_backup][:api_key] = ""

# shouldn't need to changed, but configurable anyways
default[:mongodb][:mms_backup][:install_url] = "https://mms.mongodb.com/download/agent/backup/mongodb-mms-backup-agent_1.4.2.23-1_amd64.deb"
# N.B. the dir MUST be named mms-agent; this is the contents of the unarchived zip
# the location of the dir (i.e. /usr/local/share) can be freely changed
default[:mongodb][:mms_backup][:install_dir] = "/usr/local/share/mms-backup"
default[:mongodb][:mms_backup][:log_dir] = "#{node[:mongodb][:logpath]}/backup"
#default[:mongodb][:mms_backup][:install_munin] = true
# this is the debian package name
#default[:mongodb][:mms_backup][:munin_package] = 'munin-node'
#default[:mongodb][:mms_backup][:enable_munin] = true

# don't abort the chef run if there was a problem during install, e.g. downloading the archive
#default[:mongodb][:mms_backup][:ignore_failure_on_install] = true
