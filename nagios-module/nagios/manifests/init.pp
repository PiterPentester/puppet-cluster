# == Class: nagios
class nagios {
    include nagios::install
    include nagios::fetch_file
    include nagios::config
    include nagios::services_master
    include nagios::services_agent
}
