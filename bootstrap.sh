#!/bin/sh

RELEASE=$(sysctl kern.version | grep -q current && echo snapshots || echo $(uname -r))
ARCH=$(uname -p)
export PKG_PATH=ftp://ftp.eu.openbsd.org/pub/OpenBSD/$RELEASE/packages/$ARCH/
echo "Using $PKG_PATH"
pkg_add -z python-2
pkg_add -z ansible
pkg_add -z git

# TODO: check if there is no .git directory
echo "Downloading OHRC..."
git clone https://github.com/ioc32/openhrc

echo "Bootstrap done, edit vars.yml and run configure.sh"

