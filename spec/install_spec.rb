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

end
