#!/bin/ksh

set -e

RPZ_ZONE=rpz.{{ dns.authoritative.zone }}
DEST_ZONE=/var/unbound/${RPZ_ZONE}.zone
TMP_ZONE=`mktemp -t ${RPZ_ZONE}-zone.XXXXXXXXXX`
TMP_HOSTS=`mktemp -t ${RPZ_ZONE}-hosts.XXXXXXXXXX`

URLS[0]=https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
URLS[1]=https://gitlab.com/curben/urlhaus-filter/raw/master/urlhaus-filter-hosts.txt

for URL in ${URLS[@]}; do ftp -MV -o - $URL >> $TMP_HOSTS; done

sort -u $TMP_HOSTS | \
awk -v RPZ_ZONE="${RPZ_ZONE}." \
    'BEGIN {printf "$ORIGIN %s\n",RPZ_ZONE;
            printf "%s IN SOA ns1.%s admin.%s 0000000001 86400 7200 604800 300\n",RPZ_ZONE,RPZ_ZONE,RPZ_ZONE}
     /^0\.0\.0\.0.+[a-z]$/ {printf "%s CNAME .\n",$2}' > $TMP_ZONE

nsd-checkzone $RPZ_ZONE $TMP_ZONE >/dev/null
mv -f $TMP_ZONE $DEST_ZONE
chown _unbound:_unbound $DEST_ZONE
unbound-control -q reload

rm -f $TMP_HOSTS $TMP_ZONE
