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

# create a resource to the service
service 'mongodb-mms-backup-agent' do
  supports [ :start, :stop, :restart, :reload ]
  # force upstart
  provider Chef::Provider::Service::Upstart
  action :nothing
end

# configuration
template node[:mongodb][:mms_backup][:config_file] do
  source 'backup-agent.config.erb'
  variables({ :api_key => node[:mongodb][:mms_backup][:api_key] })
  notifies :restart, 'service[mongodb-mms-backup-agent]', :delayed
end
