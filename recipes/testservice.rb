outfile = '/tmp/out'
testservice = 'ntp'

# setup test
file outfile do
  action :touch
  mode 0777
end
service testservice do
  action :start
end

# check that it's on
bash "check_service_before" do
  code "service #{testservice} status > #{outfile}; true"
  user 'root'
end

service testservice do
  action :nothing
  provider Chef::Provider::Service::Init::Debian
end
service "should_be_the_same_service" do
  action :nothing
  provider Chef::Provider::Service::Init::Debian
  service_name testservice
end

bash "ls" do
  # this works
  notifies :stop, "service[#{testservice}]", :immediately
  # but this doesn't
  #notifies :stop, "service[should_be_the_same_service]", :immediately
end

# now it should be off
bash "check_service_after" do
  code "service #{testservice} status >> #{outfile}; true"
  user 'root'
end
