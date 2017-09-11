# Manages the vault profile
# we do not generate or store any certificate for Vault nor store it in hiera
# because this would cause the problem Vault tries to solve (i.e. storing secrets)
# we manually genereate and store the certs on the Vault server
# cd /etc/ssl/certs/vault
# sudo openssl genrsa -out root-ca-key.pem 2048
# sudo openssl req -x509 -new -nodes -key root-ca-key.pem -sha256 -days 1024 -out root-ca-cert.pem
# sudo openssl genrsa -out vault_key.pem 2048
# sudo openssl req -new -key vault_key.pem -out device.csr
# sudo openssl x509 -req -in device.csr -CA root-ca-cert.pem -CAkey root-ca-key.pem -CAcreateserial -out vault_cert.pem -days 500 -sha256
class profile_vault (
  $address    = '0.0.0.0',
  $port       = '8200',
  $has_tls    = true,
  $telemetry  = undef
) {

  if ($has_tls) {
    $listener =  {
      'tcp' => {
        'address'       => "${address}:${port}",
        'tls_disable'   => 0,
        'tls_cert_file' => '/etc/ssl/certs/vault/vault_cert.pem',
        'tls_key_file' => '/etc/ssl/certs/vault/vault_key.pem'
      },
    }
  } else {
    $listener =  {
      'tcp' => {
        'address'     => "${address}:${port}",
        'tls_disable' => 1,
      },
    }
  }

  $vaulr_addr = $has_tls ? {
    true    => "https://127.0.0.1:${port}",
    default => "http://127.0.0.1:${port}",
  }

  $bin_dir = '/usr/local/bin'
  $config_dir = '/etc/vault'

  class { '::vault':
    # install_method      => 'repo',
    # we use the same service file with the FD limit set to inifnity
    manage_service_file => false,
    bin_dir             => '/usr/local/bin',
    manage_backend_dir  => true,
    listener            => $listener,
    telemetry           => $telemetry,
    backend             => {
      consul => {

      }
    }
  }


  # firewall{'200 accept vault':
  #   dport  => $port,
  #   action => 'accept',
  # }

  if ($has_tls) {
    file { '/etc/profile.d/vault.sh':
      ensure  => file,
      mode    => '0644',
      content => "export VAULT_ADDR=${vaulr_addr}\nexport VAULT_TLS_SERVER_NAME=${::fqdn}\nexport VAULT_CACERT=/etc/ssl/certs/vault/root-ca-cert.pem",
    }
  } else {
    file { '/etc/profile.d/vault.sh':
      ensure  => file,
      mode    => '0644',
      content => "export VAULT_ADDR=${vaulr_addr}\n",
    }
  }


  file { '/etc/systemd/system/vault.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile_vault/vault.systemd.erb'),
    notify  => Exec['systemd-reload'],
  }
  if ! defined(Exec['systemd-reload']) {
    exec {'systemd-reload':
      command     => 'systemctl daemon-reload',
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      user        => 'root',
      refreshonly => true,
    }
  }

  # sysctl::value {'fs.file-max':
  #   value => '1000000'
  # }
  #
  # limits::fragment {
  #   '*/soft/nofile':
  #     value => '1000000';
  #   '*/hard/nofile':
  #     value => '1000000';
  # }
  #
  # class { 'icinga::plugins::checkvault':
  #   tls_enabled => $has_tls
  # }

}
