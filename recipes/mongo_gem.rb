# install the mongo ruby gem at compile time to make it globally available
if(Gem.const_defined?("Version") and Gem::Version.new(Chef::VERSION) < Gem::Version.new('10.12.0'))
  gem_package 'mongo' do
    version '1.12.1'
    action :nothing
  end.run_action(:install)
  Gem.clear_paths
else
  chef_gem 'mongo' do
    version '1.12.1'
    action :install
  end
end
