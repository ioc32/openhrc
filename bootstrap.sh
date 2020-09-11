#!/bin/sh

RELEASE=$(sysctl kern.version | grep -q current && echo snapshots || echo $(uname -r))
ARCH=$(uname -p)
export PKG_PATH=https://cdn.openbsd.org/pub/OpenBSD/$RELEASE/packages/$ARCH/

echo "Using $PKG_PATH"
pkg_add -z ansible
pkg_add -z git

if [[ -d ".git" ]]
then
    echo "Updating OHRC..."
    git pull
    touch local-vars.yml
else
    echo "Downloading OHRC..."
    git clone https://github.com/ioc32/openhrc
    touch openhrc/local-vars.yml
fi

echo "Bootstrap done, set local variables in local-vars.yml and run configure.sh"
