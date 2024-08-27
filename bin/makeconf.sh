#!/bin/sh

CONF_DIR=$1
BUILD_TARGET=$2

KEYDIR=$3
[[ -z $KEYDIR ]] && KEYDIR=/out
# filenames
PRIVATE_KEY=$KEYDIR/$4
PUBLIC_KEY=$KEYDIR/$5
PRESHARED_KEY=$KEYDIR/$6

WIREGUARD_SERVER_PUBLICIP=$7
LISTENING_PORT=$8

cd $CONF_DIR
OUTCONF=wg0.conf

case $BUILD_TARGET in
    server)
        cp server*.conf.template $OUTCONF
        ;;

    site)
        cp server*.conf.template $OUTCONF
        ;;

    client)
        cp client*.conf.template $OUTCONF
        ;;

    *)
        echo "$1:ERROR:NoMatch"
        ;;
esac

# get the outbound dev name (e.g eth0)
RE=$(ip route get 1.1.1.1)
# 1.1.1.1 via 172.17.0.1 dev eth0 src 172.17.0.2 uid 0 
#! RTNETLINK answers: Network unreachable
IFOUT=echo $RE | awk -F 'dev ' '{print $2}' | cut -d ' ' -f1
[[ ! -z "${IFOUT}" ]] && sed -i "s/INTERNAL_IP_INTERFACE/${IFOUT}/g" $OUTCONF
# PRIVATE_KEY, PUBLIC_KEY, INTERNAL_IP_INTERFACE, WIREGUARD_SERVER_PUBLICIP, LISTENING_PORT, PRESHARED_KEY

[[ -f $PRIVATE_KEY ]] && X="" && X=$(cat $PRIVATE_KEY) && sed -i "s/PRIVATE_KEY/${X}/g" $OUTCONF
[[ -f $PUBLIC_KEY ]] && X="" && X=$(cat $PUBLIC_KEY) && sed -i "s/PUBLIC_KEY/${X}/g" $OUTCONF
[[ -f $PRESHARED_KEY ]] && X="" && X=$(cat $PRESHARED_KEY) && sed -i "s/PRESHARED_KEY/${X}/g" $OUTCONF

[[ -f $WIREGUARD_SERVER_PUBLICIP ]] && X="" && X=$(cat $WIREGUARD_SERVER_PUBLICIP) && sed -i "s/WIREGUARD_SERVER_PUBLICIP/${X}/g" $OUTCONF
[[ -f $LISTENING_PORT ]] && X="" && X=$(cat $LISTENING_PORT) && sed -i "s/LISTENING_PORT/${X}/g" $OUTCONF

