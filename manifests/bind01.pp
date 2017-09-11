include stdlib
include ::profile_consul::agent
# firewall{'010 dns tcp':
#   dport  => '53',
#   proto  => 'tcp',
#   action => 'accept',
# }
#
# firewall{'010 dns upd':
#   dport  => '53',
#   proto  => 'udp',
#   action => 'accept',
# }
#

class { '::bind':
  chroot=> true,
}

if ! ($::operatingsystem in ['CentOS', 'RHEL']) {
  fail('profile_bind: Only CentOS is supported')
}

file { '/etc/named':
  ensure => directory
}

file { '/etc/named/zones':
  ensure => directory
}

bind::server::conf { '/etc/named.conf':
  listen_on_addr => ['172.16.25.10', '127.0.0.1'],
  allow_query    => [ 'any' ],
  require        => [
    Class['::bind'],
    File['/etc/named/consul.conf'],
    File['/etc/named/zones/db.vault-cluster.net'],
    File['/etc/named/zones/db.172.16'],
    File['/etc/named/named.conf.local'],
    ],
  notify         => Service[$::bind::service::servicename],
  extra_options  => [['dnssec-must-be-secure', 'consul no']],
  includes       => ['/etc/named/consul.conf', '/etc/named/named.conf.local']
}

file { '/etc/named/consul.conf':
  ensure  => present,
  content => template('profile_bind/consul.conf.erb')
}

file { '/etc/named/zones/db.vault-cluster.net':
  ensure  => present,
  content => template('profile_bind/db.vault-cluster.net.erb')
}

file { '/etc/named/zones/db.172.16':
  ensure  => present,
  content => template('profile_bind/db.172.16.erb')
}

file { '/etc/named/named.conf.local':
  ensure => present,
  content => template('profile_bind/named.conf.local')
}
