require 'chefspec'
require 'chefspec/berkshelf'

describe 'mongodb::default' do

  PACKAGE_TIMEOUT = rand(10**6)

  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04') do |n|
      n.set.mongodb.package_timeout = PACKAGE_TIMEOUT
    end
  end

  it 'uses the timeout set in attributes when installing the mongodb package' do
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package(chef_run.node.mongodb.package_name).with(:timeout => PACKAGE_TIMEOUT)
  end

end
