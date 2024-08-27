# syntax=docker/dockerfile:1

# --cap-add=NET_ADMIN --cap-add=NET_RAW
# https://docs.docker.com/reference/dockerfile/#understand-how-arg-and-from-interact
# An ARG declared before a FROM is outside of a build stage, so it can't be used in any instruction after a FROM. To use the default value of an ARG declared before the first FROM use an ARG instruction without a value inside of a build stage:
ARG BUILD_TARGET=server
ARG WIREGUARD_SERVER_PUBLICIP=127.0.0.1
ARG LISTENING_PORT=5060

#FROM alpine:3.20
FROM ubuntu:24.04

# TL;DR, if want to use the ARG after FROM, define the ARG again
ARG BUILD_TARGET
ARG WIREGUARD_SERVER_PUBLICIP
ARG LISTENING_PORT

# RUN \
#     # -U update cache \
#     apk add -U wireguard-tools \
#       iptables \
#       # ip6tables \
#       # openrc: rc-update  rc-service \
#       openrc \
#       # iproute2: ip command \
#       iproute2

RUN apt -y update && apt -y upgrade
RUN apt -y install wireguard iptables iproute2


# Key can be copied during the entry script later.
ARG KEYDIR=/srv/wg-pki
# the filenames
ARG PRIVATE_KEY=private_key
ARG PUBLIC_KEY=public_key
ARG PRESHARED_KEY=preshared_key

WORKDIR ${KEYDIR}
RUN [[ ! -f ${PRIVATE_KEY} ]] && wg genkey > ${PRIVATE_KEY} && wg pubkey < ${PRIVATE_KEY} > ${PUBLIC_KEY}
RUN [[ ! -f ${PRESHARED_KEY} ]] && wg genpsk > ${PRESHARED_KEY}


# Generate the Wireguard Conf
COPY ./bin/makeconf.sh /usr/local/bin/makeconf.sh
COPY ./conf /etc/wireguard
RUN ls -lah /sys/class/net/
RUN /bin/sh /usr/local/bin/makeconf.sh /etc/wireguard/ ${BUILD_TARGET} ${KEYDIR} ${PRIVATE_KEY} ${PUBLIC_KEY} ${PRESHARED_KEY} ${WIREGUARD_SERVER_PUBLICIP} ${LISTENING_PORT}
RUN ls -lah /etc/wireguard
RUN cat /etc/wireguard/wg0.conf

# COPY /etc/wireguard/wg0.conf /out/wg0.conf
# RUN rc-update add iptables
# save the firewall rules to disk
# RUN rc-service iptables save
# RUN rc-update add ip6tables





# Assume iptables are clean on init
    

# RUN \
#   echo "**** install dependencies ****" && \
#   apk add --no-cache \
#     bc \
#     coredns \
#     grep \
#     iproute2 \
#     iptables \
#     iptables-legacy \
#     ip6tables \
#     iputils \
#     kmod \
#     libcap-utils \
#     libqrencode-tools \
#     net-tools \
#     openresolv \
#     wireguard-tools && \
#   echo "wireguard" >> /etc/modules && \
#   cd /sbin && \
#   for i in ! !-save !-restore; do \
#     rm -rf iptables$(echo "${i}" | cut -c2-) && \
#     rm -rf ip6tables$(echo "${i}" | cut -c2-) && \
#     ln -s iptables-legacy$(echo "${i}" | cut -c2-) iptables$(echo "${i}" | cut -c2-) && \
#     ln -s ip6tables-legacy$(echo "${i}" | cut -c2-) ip6tables$(echo "${i}" | cut -c2-); \
#   done && \
#   sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick && \
#   rm -rf /etc/wireguard && \
#   ln -s /config/wg_confs /etc/wireguard && \
#   printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
#   echo "**** clean up ****" && \
#   rm -rf \
#     /tmp/*

# add local files
#COPY /root /

# ports and volumes
# EXPOSE 51820/udp
