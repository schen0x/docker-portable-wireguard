#!/bin/sh

# /etc/wireguard
WG_CONF_DIR=$1

# /srv/wg-pki
KEYDIR=$2
[[ -z $KEYDIR ]] && KEYDIR=/out
# filenames
PRIVATE_KEY=$KEYDIR/$3
PUBLIC_KEY=$KEYDIR/$4
PRESHARED_KEY=$KEYDIR/$5

WIREGUARD_SERVER_PUBLICIP=$6
WIREGUARD_SERVER_LISTENING_PORT=$7
SITE_INET_CIDR=$8
BUILD_TARGET=$9

cd $WG_CONF_DIR
OUTCONF=wg0.conf

case $BUILD_TARGET in
    server)
        cp server*.conf.template $OUTCONF
        ;;

    site)
        cp site*.conf.template $OUTCONF
        ;;

    client)
        cp client*.conf.template $OUTCONF
        ;;

    *)
        echo "$0:ERROR:NoMatch, BUILD_TARGET==$BUILD_TARGET;"
	exit 1;
        ;;
esac

# get the outbound dev name (e.g eth0)
# RE=$(ip route get 1.1.1.1)
# 1.1.1.1 via 172.17.0.1 dev eth0 src 172.17.0.2 uid 0 
#! RTNETLINK answers: Network unreachable
# IFOUT=echo $RE | awk -F 'dev ' '{print $2}' | cut -d ' ' -f1
# get the other interface apart from the lo
IFOUT=$(ls /sys/class/net | grep -v "lo" | head -1)
echo $IFOUT
[[ ! -z "${IFOUT}" ]] && sed -i "s/INTERNAL_IP_INTERFACE/${IFOUT}/g" $OUTCONF

[[ -f $PRIVATE_KEY ]] && X="" && X=$(cat $PRIVATE_KEY) && sed -i "s|PRIVATE_KEY|${X}|g" $OUTCONF
[[ -f $PUBLIC_KEY ]] && X="" && X=$(cat $PUBLIC_KEY) && sed -i "s|PUBLIC_KEY|${X}|g" $OUTCONF
[[ -f $PRESHARED_KEY ]] && X="" && X=$(cat $PRESHARED_KEY) && sed -i "s|PRESHARED_KEY|${X}|g" $OUTCONF

echo $WIREGUARD_SERVER_PUBLICIP
echo $WIREGUARD_SERVER_LISTENING_PORT
[[ ! -z $WIREGUARD_SERVER_PUBLICIP ]] && sed -i "s|WIREGUARD_SERVER_PUBLICIP|${WIREGUARD_SERVER_PUBLICIP}|g" $OUTCONF
[[ ! -z $WIREGUARD_SERVER_LISTENING_PORT ]] && sed -i "s|WIREGUARD_SERVER_LISTENING_PORT|${WIREGUARD_SERVER_LISTENING_PORT}|g" $OUTCONF

