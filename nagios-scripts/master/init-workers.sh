#!/usr/bin/env bash

# crate config for worker1
echo "define host {
        use                             linux-server
        host_name                       worker1
        alias                           My puppet agent1 server
        address                         10.0.0.11
        max_check_attempts              5
        check_period                    24x7
        notification_interval           30
        notification_period             24x7
}
define service {
        use                             generic-service
        host_name                       worker1
        service_description             PING
        check_command                   check_ping!100.0,20%!500.0,60%
}" >> /usr/local/nagios/etc/servers/worker1.cfg

# crate config for worker2
echo "define host {
        use                             linux-server
        host_name                       worker2
        alias                           My puppet agent2 server
        address                         10.0.0.12
        max_check_attempts              5
        check_period                    24x7
        notification_interval           30
        notification_period             24x7
}
define service {
        use                             generic-service
        host_name                       worker2
        service_description             PING
        check_command                   check_ping!100.0,20%!500.0,60%
}" >> /usr/local/nagios/etc/servers/worker2.cfg
