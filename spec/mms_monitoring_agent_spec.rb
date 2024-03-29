require 'chefspec'
require 'chefspec/berkshelf'

describe 'mongodb::mms-agent' do

  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04') do |n|
      n.set.mongodb.mms_agent.api_key = 'dummy_key'
      n.set.mongodb.mms_agent.user = 'hall_monitor'
      n.set.mongodb.mms_agent.log_dir = '/tmp/monitor_log_dir'
    end
  end

  # This is designed so if folks change the version in the attributes file this will fail 
  it 'package install the mms_monitoring_agent' do
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('mongodb::mms-agent')
    expect(chef_run).to create_user('hall_monitor')
    expect(chef_run).to create_directory('/mnt/log/mongodb-mms')
    expect(chef_run).to create_link('/tmp/monitor_log_dir').with(to: '/mnt/log/mongodb-mms')
    expect(chef_run).to install_package('mongodb-mms-monitoring-agent').with_version('3.2.0.177-1')
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/mms_agent.deb").with( 
      :source => 'https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_3.2.0.177-1_amd64.deb'
    )
    expect(chef_run).to render_file('/etc/mongodb-mms/monitoring-agent.config').with_content(/.*=dummy_key/)
    resource = chef_run.template('/etc/mongodb-mms/monitoring-agent.config')
    expect(resource).to notify('service[mongodb-mms-monitoring-agent]').to(:restart).delayed
  end

end
