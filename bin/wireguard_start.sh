#!/bin/bash

# write conf to mounted folder, if not existed yet, on start
[[ ! -f /etc/wireguard/wg0.conf ]] && cp /srv/wg-makeconf/wg0.conf /etc/wireguard/wg0.conf
chmod 700 /etc/wireguard/wg0.conf
wg-quick up wg0

