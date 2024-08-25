# docker-wireguard-site-to-site

- Network Topology: ROAD_WARRIOR <---> WG_PROXY (VPN SERVER) <---> WG_SITE (CLIENT AS SITE)
- Goal: ROAD_WORRIOR can access the INET of WG_SITE
- WG_PROXY can access the INET of WG_SITE when ACL is set in the "wg.conf" about the WG_SITE in the WG_PROXY server (need confirm)
- WG_SITE can naturally access WG_PROXY
- INET of the WG_SITE can access WG_PROXY if `route add 10.132.0.0/16 via 10.9.0.2 dev wg0` on the WG_SITE machine (do we need this to send back the traffic to ROAD_WORRIOR?)

## NETWORKING

- host network will be modified when running the container, which is granted NET_ADMIN NET_RAW permission
- the host iptables is updated on "PostUp" "PostDown", which is "wg-quick up" on container start or shutdown(?)

## Credit

- https://github.com/mjtechguy/wireguard-site-to-site
