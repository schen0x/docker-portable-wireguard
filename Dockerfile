# syntax=docker/dockerfile:1

# --cap-add=NET_ADMIN --cap-add=NET_RAW

FROM alpine:3.20

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WIREGUARD_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

RUN \
    # -U update cache \
    apk add -U wireguard-tools \
      iptables ip6tables \
      # openrc: rc-update  rc-service \
      openrc \

RUN rc-update add iptables
# save the firewall rules to disk
RUN rc-service iptables save
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
