require 'chefspec'
require 'chefspec/berkshelf'

describe 'mongodb::mms-backup' do
  
  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04') do |n|
      n.set.mongodb.mms_backup.api_key = 'dummy_key'
    end
  end

  it 'package install the mms_backup_agent' do
    # chef_run.node.override.mongodb.mms_backup.api_key = 'dummykey'
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('mongodb::mms-backup')
    expect(chef_run).to install_package('mongodb-mms-backup-agent')
    expect(chef_run).to render_file('/etc/mongodb-mms/backup-agent.config').with_content(/.*=dummy_key/)
    resource = chef_run.template('/etc/mongodb-mms/backup-agent.config')
    expect(resource).to notify('service[mongodb-mms-backup-agent]').to(:restart).delayed
  end

end
