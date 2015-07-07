require 'chefspec'
require 'chefspec/berkshelf'

describe 'mongodb::default' do
  
  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04') do |n|
      n.set.mongodb.mms_backup.api_key = 'dummy_key'
    end
  end

  it 'should install mongodb package and enable mongodb service' do
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package 'mongodb-10gen'
    expect(chef_run).to enable_service 'mongodb'
  end

  it 'if install_url is specified, it should create mongodb-10gen.deb file, notify mongodb pkg install and enable mongodb service' do
    chef_run.node.set.mongodb.install_url = "http://example.com"
    chef_run.converge(described_recipe)
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/mongodb-10gen.deb")
    resource = chef_run.remote_file("#{Chef::Config[:file_cache_path]}/mongodb-10gen.deb")
    expect(resource).to notify('package[mongodb-10gen]').to(:install)
    # expect(chef_run).to install_package 'mongodb-10gen' # FIXME: This does not work
    # expect(chef_run).to enable_service 'mongodb' # FIXME: This is true but need to look into why it works
  end

=begin
  it 'package install mongodb-org via 10gen' do
    chef_run.node.set.mongodb.install_method = '10gen'
    chef_run.converge(described_recipe)

    expect(chef_run).to include_recipe('mongodb::10gen_repo')
    expect(chef_run).to include_recipe('mongodb::install')
    expect(chef_run).to install_package 'mongodb-org'
    expect(chef_run).to enable_service 'mongodb'
  end

  it 'package install mongodb-org via mongodb-org' do
    chef_run.node.set.mongodb.install_method = 'mongodb-org'
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('mongodb::10gen_repo')
    expect(chef_run).to include_recipe('mongodb::install')
    expect(chef_run).to install_package 'mongodb-org'
    expect(chef_run).to enable_service 'mongodb'
  end
=end
=begin
  # This is designed so if folks change the version in the attributes file this will fail 
  it 'package install the mms_backup_agent' do
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('mongodb::mms-backup')
    expect(chef_run).to install_package('mongodb-mms-backup-agent').with_version('3.3.0.261-1')
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/mms_backup.deb").with(
      :source => 'https://mms.mongodb.com/download/agent/backup/mongodb-mms-backup-agent_3.3.0.261-1_amd64.deb'
    )
    expect(chef_run).to render_file('/etc/mongodb-mms/backup-agent.config').with_content(/.*=dummy_key/)
    resource = chef_run.template('/etc/mongodb-mms/backup-agent.config')
    expect(resource).to notify('service[mongodb-mms-backup-agent]').to(:restart).delayed
  end
=end
end
