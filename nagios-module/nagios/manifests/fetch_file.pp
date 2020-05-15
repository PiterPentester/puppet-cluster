# == Class: nagios::fetch_file
class nagios::fetch_file inherits nagios {

  include ::wget

  wget::fetch { 'https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz':
    destination => '/tmp/nagioscore.tar.gz',
    timeout     => 15,
    verbose     => true,
  }

  exec { 'untar nagios core':
    command     => '/bin/tar -xvf /tmp/nagioscore.tar.gz',
    user        => 'nagios',
  }



  wget::fetch { 'https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.0.3/nrpe-4.0.3.tar.gz':
    destination => '/tmp/nrpe-4.0.3.tar.gz',
    timeout     => 15,
    verbose     => true,
  }

  exec { 'untar nagios nrpe':
    command     => '/bin/tar -xvf /tmp/nrpe-4.0.3.tar.gz',
    user        => 'nagios',
  }



  wget::fetch { 'https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz':
    destination => '/tmp/nagios-plugins.tar.gz',
    timeout     => 15,
    verbose     => true,
  }

  exec { 'untar nagios plugins':
    command     => '/bin/tar -xvf /tmp/nagios-plugins.tar.gz',
    user        => 'nagios',
  }

}
