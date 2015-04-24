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
contraption. There are some recommended settings which should be chosen when
making the installation:

* Create a new user account (while installting OpenHRC requires root access,
  it's generally not a good idea to always use the root account)
* Disable root login over SSH
* Enable console over serial port com0 (if you are installing OpenHRC on a
  headless device)

Once you have installed [OpenBSD][openbsd] you are ready to install OpenHRC.

* Download and execute the bootstrap script (as root)
~~~~~~
  ftp https://raw.githubusercontent.com/ioc32/openhrc/master/bootstrap.sh -o - | sh
~~~~~~
  We know, piping things from the internet to the shell directly is not a good
  idea... You're more than welcome to check the contents of the script, which
  basically just installing a few basic packages and cloning this repository.
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

