name              "mongodb"
maintainer        "edelight GmbH"
maintainer_email  "markus.korn@edelight.de"
license           "Apache 2.0"
description       "Installs and configures mongodb"
version           "0.987654321.26"

recipe "mongodb", "Installs and configures a single node mongodb instance"
recipe "mongodb::10gen_repo", "Adds the 10gen repo to get the latest packages"
recipe "mongodb::mongos", "Installs and configures a mongos which can be used in a sharded setup"
recipe "mongodb::configserver", "Installs and configures a configserver for mongodb sharding"
recipe "mongodb::shard", "Installs and configures a single shard"
recipe "mongodb::replicaset", "Installs and configures a mongodb replicaset"
recipe "mongodb::mms-agent", "Installs and configures a Mongo Management Service monitoring agent"
recipe "mongodb::mms-backup", "Installs and configures a Mongo Management Service backup agent"

depends "apt", "2.6.1"
depends 'build-essential', '~> 2.1.0' # This is a dependency of apt
depends "python"
depends "runit", "1.5.18"
depends "yum"

%w{ ubuntu debian freebsd centos redhat fedora amazon scientific}.each do |os|
  supports os
end

attribute "mongodb/dbpath",
  :display_name => "dbpath",
  :description => "Path to store the mongodb data",
  :default => "/var/lib/mongodb"

attribute "mongodb/logpath",
  :display_name => "logpath",
  :description => "Path to store the logfiles of a mongodb instance",
  :default => "/var/log/mongodb"

attribute "mongodb/port",
  :display_name => "Port",
  :description => "Port the mongodb instance is running on",
  :default => "27017"

attribute "mongodb/client_roles",
  :display_name => "Client Roles",
  :description => "Roles of nodes who need access to the mongodb instance",
  :type => "array",
  :default => []

attribute "mongodb/cluster_name",
  :display_name => "Cluster Name",
  :description => "Name of the mongodb cluster, all nodes of a cluster must have the same name.",
  :default => nil

attribute "mongodb/shard_name",
  :display_name => "Shard name",
  :description => "Name of a mongodb shard",
  :default => "default"

attribute "mongodb/sharded_collections",
  :display_name => "Sharded Collections",
  :description => "collections to shard",
  :type => "array",
  :default => []

attribute "mongodb/replicaset_name",
  :display_name => "Replicaset_name",
  :description => "Name of a mongodb replicaset",
  :default => nil

attribute "mongodb/enable_rest",
  :display_name => "Enable Rest",
  :description => "Enable the ReST interface of the webserver"

attribute "mongodb/smallfiles",
  :display_name => "Use small files",
  :description => "Modify MongoDB to use a smaller default data file size"

attribute "mongodb/bind_ip",
  :display_name => "Bind address",
  :description => "MongoDB instance bind address",
  :default => nil

attribute "mongodb/package_version",
  :display_name => "MongoDB package version",
  :description => "Version of the MongoDB package to install",
  :default => nil

attribute "mongodb/configfile",
  :display_name => "Configuration File",
  :description => "Name of configuration file to use with when starting mongod/mongos vs command line options",
  :default => nil

attribute "mongodb/nojournal",
  :display_name => "Disable Journals",
  :description => "Journals are enabled by default on 64bit after mongo 2.0, this can disable it",
  :default => "false"

attribute "mongodb/mms_agent",
  :display_name => "MMS Agent",
  :description => "Hash of MMS Agent attributes",
  :type => "hash"

attribute "mongodb/mms_agent/api_key",
  :display_name => "MMS Agent API Key"

attribute "mongodb/mms_agent/secret_key",
  :display_name => "MMS Agent Secret Key"

attribute "mongodb/oplog_size",
  :display_name => "oplogSize",
  :description => "Specifies a maximum size in megabytes for the replication operation log",
  :default => nil
