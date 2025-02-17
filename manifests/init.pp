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

  host { $::clientcert:
    ensure => present,
    ip     => $facts['networking']['ip'],
  }

}
