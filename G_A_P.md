[openvpn_explicit_default_deny_configuration.md](https://github.com/user-attachments/files/32958956/openvpn_explicit_default_deny_configuration.md)
# OpenVPN Explicit Default Deny Configuration

To achieve an "explicit default deny" in an OpenVPN client configuration (`.ovpn`), the most effective method is to reject all routing instructions pushed by the server. By default, OpenVPN clients accept pushed routes, which acts as a default allow. 

By using the `route-nopull` directive, you enforce a strict **default deny** on all network routing over the tunnel. You must then explicitly allow specific subnets using the `route` directive.

## `client.ovpn`

```openvpn
client
dev tun
proto udp

# Replace with your actual VPN server IP/Domain and Port
remote vpn.example.com 1194

resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun

# ------------------------------------------------------------------
# EXPLICIT DEFAULT DENY CONFIGURATION
# ------------------------------------------------------------------
# 1. Ignore all routes pushed by the server (Default Deny)
route-nopull

# 2. Explicitly allow ONLY specified subnets over the VPN (Allow-list)
# Syntax: route [network] [subnet_mask] vpn_gateway
route 10.10.10.0 255.255.255.0 vpn_gateway
route 192.168.50.0 255.255.255.0 vpn_gateway

# 3. Prevent DNS leaks (Windows clients only) by forcing DNS through the tunnel
block-outside-dns
# ------------------------------------------------------------------

# Cryptographic and Security Hardening
remote-cert-tls server
auth SHA256
cipher AES-256-GCM
tls-client
tls-version-min 1.2
auth-nocache

# Inline Certificates and Keys
<ca>
-----BEGIN CERTIFICATE-----
# [Insert CA Certificate Here]
-----END CERTIFICATE-----
</ca>

<cert>
-----BEGIN CERTIFICATE-----
# [Insert Client Certificate Here]
-----END CERTIFICATE-----
</cert>

<key>
-----BEGIN PRIVATE KEY-----
# [Insert Client Private Key Here]
-----END PRIVATE KEY-----
</key>

<tls-crypt>
-----BEGIN OpenVPN Static key V1-----
# [Insert TLS Crypt Key Here]
-----END OpenVPN Static key V1-----
</tls-crypt>
```
