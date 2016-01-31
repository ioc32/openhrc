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

* DHCP
* NTP
* Local caching and validating DNS resolver
* Authoritative DNS server for a configurable zone
* Firewall
* UPnP
* DDNS


## Hardware

OpenHRC should work on any device which can run [OpenBSD][openbsd] and has at
least 2 network interfaces. We have tested it successfully on the following
devices:

* [PC Engines APU][apu]
* [Soekris net4801][soekris]


## Installation

Watch [the video!][video]

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
  Alternatively, you can clone this repo and manually run the bootstrapping
  script (you'll need to install git first):
~~~~~~
  git clone https://github.com/ioc32/openhrc && cd openhrc
  ./bootstrap.sh
~~~~~~
* View vars.yml, override variables in local-vars.yml to your liking
* Run ./configure.sh
* Reboot and have fun!


## Authors

Brought to you by:

* Iñigo Ortiz de Urbina Cazenave <inigo@infornografia.net>
* Saúl Ibarra Corretgé <saghul@gmail.com>

with love.


## License

Simplified BSD License. Check LICENSE file.

[ansible]: http://www.ansible.com
[openbsd]: http://www.openbsd.org
[apu]: http://www.pcengines.ch/apu.htm
[soekris]: http://soekris.com/products/eol-products/net4801.html
[video]: https://www.youtube.com/watch?v=LZeKDM5jc90


## FAQ

**Q:** I have bad throughput in my system, what's up?

**A:** If you are using a snapshot you might need to disable some kernel debugging:
~~~~~~
sysctl kern.pool_debug=0
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

**A:** It's coming up in the next release, hold tight!

**Q:** How can I override the variables used in the playbooks?

**A:** You can provide your own variables in the local-vars.yml file.
The user_* list variables are empty by default. Override those you need by adding them to local variables file.
In order to override variables stored in dictionaries (like the firewall or dns sections, for example), you can override individual keys that will be merged with the remaining default keys.

**Q:** My favorite site/TLD have screwed their DNSSEC. Is there anything I can do?

**A:** You can either disable DNSSEC validation entirely (not recommended):
~~~~~~
dns:
  recursive:
      enable_dnssec_validation: false
~~~~~~
or enable the permissive validation mode, which will ensure unbound keeps validating domains and passing responses down to clients even when validation fails (ad bit and SERVFAIL RCODE will not be set, of course):
~~~~~~
dns:
  recursive:
    enable_dnssec_validation: true
    permissive_dnssec_validation: true
~~~~~~

You may also need to remove all bogus data from unbound's cache:
~~~~~~
# unbound-control flush_bogus
ok removed 0 rrsets, 0 messages and 0 key entries
~~~~~~
or remove all labels below the broken zone:
~~~~~~
# unbound-control flush_zone ke.
ok removed 10 rrsets, 0 messages and 1 key entries
~~~~~~

**Q:** How can I configure the authoritative DNS server?

**A:** The default zone is "home.lan", you can override it and create custom records by editing
local-vars.yml:

~~~~~~
dns:
  authoritative:
    zone: kasa.lan
    records:
      - foo.kasa.lan IN A 10.0.0.20
      - bar.kasa.lan IN A 10.0.0.30
~~~~~~

**Q:** Is the authoritative DNS server accessible externally?

**A:** No, NSD binds to localhost and only unbound (servicing LAN queries) forwards queries to it.
