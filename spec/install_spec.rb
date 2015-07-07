require 'chefspec'
require 'chefspec/berkshelf'

describe 'mongodb::default' do
  
  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04') do |n|
    end
  end

  it 'should install mongodb package and enable mongodb service' do
    chef_run.node.set.mongodb.package_version = "2.4.9"

    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('mongodb-10gen').with_version("2.4.9")
    expect(chef_run).to enable_service 'mongodb'
  end

  it 'if install_url is specified, it should create mongodb-10gen.deb file and notify mongodb pkg install' do
    chef_run.node.set.mongodb.install_url = "http://example.com/mongodb-10gen_2.4.9_amd64.deb"
    remote_file = "#{Chef::Config[:file_cache_path]}/mongodb-10gen.deb"

    chef_run.converge(described_recipe)
    expect(chef_run).to create_remote_file(remote_file).with(source: "http://example.com/mongodb-10gen_2.4.9_amd64.deb")
    resource = chef_run.remote_file(remote_file)
    expect(resource).to notify('package[mongodb-10gen]').to(:install).immediately
    # expect(chef_run).to install_package('mongodb-10gen').with_version("2.4.9").at_converge_time # FIXME: This does not work
    # expect(chef_run).to enable_service 'mongodb' # FIXME: This is true but need to look into why it works
  end

end
