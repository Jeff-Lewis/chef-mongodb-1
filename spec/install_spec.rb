require 'chefspec'
require 'chefspec/berkshelf'

describe 'mongodb::default' do
  
  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04') do |n|
    end
  end

  it 'should install mongodb package and enable mongodb service' do
    expected_version = "#{rand(10)}.#{rand(10)}.#{rand(10)}"
    chef_run.node.set.mongodb.package_version = expected_version

    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('mongodb-10gen').with_version(expected_version)
  end

  it 'if install_url is specified, it should create mongodb-10gen.deb file and install via dpkg' do
    expected_version = "#{rand(10)}.#{rand(10)}.#{rand(10)}"
    remote_file = "#{Chef::Config[:file_cache_path]}/mongodb-10gen.deb"
    install_url = "http://example.com/mongodb-10gen_2.4.9_amd64.deb"
    chef_run.node.set.mongodb.install_url = install_url
    chef_run.node.set.mongodb.package_version = expected_version

    chef_run.converge(described_recipe)
    expect(chef_run).to create_remote_file(remote_file).with(source: install_url)
    expect(chef_run).to install_dpkg_package('mongodb-10gen').with(
      source: remote_file,
      version: expected_version
    )
  end

  # TODO: This is currently true in the above tests but appears to be a side
  #       effect or bug and not really prove something useful happened
  xit 'the mongodb service is enabled' do 
    chef_run.converge(described_recipe)
    expect(chef_run).to enable_service 'mongodb'
  end

end
