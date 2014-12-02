require 'chefspec'
require 'chefspec/berkshelf'

describe 'mongodb::mms-backup' do
  
  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04') do |n|
      n.set.mongodb.mms_backup.api_key = 'dummy_key'
    end
  end

  # This is designed so if folks change the version in the attributes file this will fail 
  it 'package install the mms_backup_agent' do
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('mongodb::mms-backup')
    expect(chef_run).to install_package('mongodb-mms-backup-agent').with_version('2.8.0.204-1')
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/mms_backup.deb").with(
      :source => 'https://mms.mongodb.com/download/agent/backup/mongodb-mms-backup-agent_2.8.0.204-1_amd64.deb'
    )
    expect(chef_run).to render_file('/etc/mongodb-mms/backup-agent.config').with_content(/.*=dummy_key/)
    resource = chef_run.template('/etc/mongodb-mms/backup-agent.config')
    expect(resource).to notify('service[mongodb-mms-backup-agent]').to(:restart).delayed
  end

end
