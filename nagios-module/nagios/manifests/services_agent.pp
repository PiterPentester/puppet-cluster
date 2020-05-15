# == Class: nagios::services_agent
class nagios::services_agent inherits nagios {

  service { 'nrpe':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
