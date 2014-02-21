include_recipe 'python'
python_pip 'pymongo'

# installation
deb = 'mms_backup.deb'
remote_file "#{Chef::Config[:file_cache_path]}/#{deb}" do
  source node[:mongodb][:mms_backup][:install_url]
end
dpkg_package "mongodb-mms-backup-agent" do
  source "#{Chef::Config[:file_cache_path]}/#{deb}"
  action :install
end

service 'mongodb-mms-backup-agent' do
  supports [ :start, :stop, :restart, :reload ]
  # force upstart
  provider Chef::Provider::Service::Upstart
  action :nothing
end

# configuration
#mms_backup_creds = json_from_s3 do
  #bucket 'kabam-chef-bucket'
  #file 'TODO'
#end
mms_backup_creds = { 'api_key' => '570bbd67e931a0ede28b0ebc880f4167' }
template '/etc/mongodb-mms/backup-agent.config' do
  source 'backup-agent.config.erb'
  variables({ :api_key => mms_backup_creds['api_key'] })
  notifies :restart, 'service[mongodb-mms-backup-agent]', :delayed
end

# /var/log/mongodb-mms/backup-agent.log
Chef::Log.error 'wtf'
