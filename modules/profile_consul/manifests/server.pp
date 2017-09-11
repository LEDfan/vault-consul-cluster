class profile_consul::server (
  $server_nodes = $::profile_consul::params::server_nodes,
  $agent_nodes  = $::profile_consul::params::agent_nodes,
  $node_addr,
  $node_name,
  $datacenter) inherits profile_consul::params {
  include stdlib
  package { 'unzip':
     ensure => present,
  }->
  class { '::consul':
    config_hash => {
      'bootstrap_expect' => length($server_nodes),
      'data_dir'         => '/var/lib/consul',
      'datacenter'       => $datacenter,
      'log_level'        => 'INFO',
      'node_name'        => $node_name,
      'server'           => true,
      'ui_dir'           => '/var/lib/consul/ui',
      'client_addr'      => '0.0.0.0',
      'bind_addr'        => $node_addr,
      'retry_join'       => concat($server_nodes, $agent_nodes),
    }
  }
}
