# OpenHRC

OpenHRC (Open Household Router Contraption) is a set of [Ansible][ansible]
playbooks and scripts to easily setup and maintain a home router running
[OpenBSD][openbsd].


## Overview

OpenHRC implements the basic networking services for a household, running the
following (quite common) scenario:

~~~~~~
          +--------------+
          | The Internet |
          +------+-------+
                 |
                 v
         +-------+---------+
         |   Cable modem   |
         +-------+---------+
                 |
                 v
            +----+-----+
     +------+ OpenHRC  +-------+
     |      +----------+       |
     v                         |
+----+-----+                +--+--+
| Home LAN |                | DMZ |
+----------+                +-----+
~~~~~~

Included services:

* DHCP server
* NTP server
* Local caching DNS resolver
* Firewall


## Hardware

OpenHRC should work on any device which can run [OpenBSD][openbsd] and has at
least 2 network interfaces. We have tested it successfully on the following
devices:

* [PC Engines APU][apu]
* [Soekris net4801][soekris]


## Installation

OpenHRC assumes you have successfully installed [OpenBSD][openbsd] in your
contraption.

Once you have installed [OpenBSD][openbsd] you are ready to install OpenHRC.

* Download and execute the bootstrap script (as root)
~~~~~~
  ftp -o - https://raw.githubusercontent.com/ioc32/openhrc/master/bootstrap.sh | sh
~~~~~~
  We know, piping things from the internet to the shell directly is not a good
  idea... You're more than welcome to check the contents of the script, which
  basically just installs a few basic packages and clones this repository.
* Edit vars.yml to your liking
* Run ./configure.sh
* Reboot and have fun!


## Authors

Brought you by:

* Iñigo Ortiz de Urbina Cazenave <inigo@infornografia.net>
* Saúl Ibarra Corretgé <saghul@gmail.com>

with love.


## License

Simplified BSD License. Check LICENSE file.

[ansible]: http://www.ansible.com
[openbsd]: http://www.openbsd.org
[apu]: http://www.pcengines.ch/apu.htm
[soekris]: http://soekris.com/products/eol-products/net4801.html


## FAQ

**Q:** I have bad throughput in my system, what's up?

**A:** If you are using a snapshot you might need to disable some kernel debugging:
~~~~~~
sysctl -w kern.pool_debug=0
~~~~~~

**Q:** How do I forward a range of ports?

**A:** When defining a port forwarding, the external_ports and internal_ports options
can take a port range, using a colon:
~~~~~~
port_forwardings:
  -
    external_ports: 5000:6000
    target: 10.0.0.51
    internal_ports: 2000:3000
    protocols: udp,tcp
~~~~~~

**Q:** No IPv6 support, are you serious?

**A:** It's comming up in the next release, hold tight!

