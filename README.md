# docker-portable-wireguard

## NETWORKING

- host network will be modified when running the container, which is granted NET_ADMIN NET_RAW permission
- the host iptables is updated on "PostUp" "PostDown", which is "wg-quick up" on container start or shutdown(?)

## Credit

- https://github.com/mjtechguy/wireguard-site-to-site
