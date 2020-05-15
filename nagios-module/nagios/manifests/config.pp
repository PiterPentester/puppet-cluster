# == Class: nagios::config
class nagios::config inherits nagios {

  file { '/usr/local/nagios/etc/nagios.cfg':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0644',
    content => template($module_name/nagios.cfg.erb),
  }

  file { '/usr/local/nagios/etc/objects/commands.cfg':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0644',
    content => template($module_name/commands.cfg.erb),
  }

  file { '/etc/xinetd.d/nrpe':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0644',
    content => template($module_name/nrpe.erb),
  }



  file { '/usr/local/nagios/etc/servers/worker1.cfg':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0644',
    content => template($module_name/worker1.cfg.erb),
  }

  file { '/usr/local/nagios/etc/servers/worker2.cfg':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0644',
    content => template($module_name/worker2.cfg.erb),
  }

}
