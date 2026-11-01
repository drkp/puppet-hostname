class hostname {

  file { '/etc/hostname':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "${trusted['certname']}\n",
    notify  => Exec['set-hostname'],
  }

  exec { 'set-hostname':
    command => '/bin/hostname -F /etc/hostname',
    unless  => '/usr/bin/test `hostname` = `/bin/cat /etc/hostname`',
  }

  # Explicitly manage the IPv4 loopback entry so 'localhost' resolves to
  # 127.0.0.1 even when DNS is unavailable. The node's own IP line must
  # not carry the 'localhost' alias: with nsswitch 'hosts: files dns', a
  # node-IP line that shadows 'localhost' breaks local services that dial
  # 'localhost' (e.g. the llama-swap default proxy http://localhost:PORT).
  host { 'localhost':
    ensure       => present,
    ip           => '127.0.0.1',
    host_aliases => ['localhost.localdomain'],
  }
  host { $::clientcert:
    ensure       => present,
    ip           => $facts['networking']['ip'],
    host_aliases => [$facts['networking']['hostname']],
  }

}
