## The Conflict: Why They Clash

By default, OpenVPN often defaults to a "full tunnel," meaning it tries to capture all network traffic and send it to your private VPN gateway. At the same time, the Netskope Client establishes its own tunnel to steer web, cloud, or all traffic to the Netskope Security Cloud for security inspection (DLP, threat protection, etc.).

If you don't configure them to coexist, one of two things usually happens:

* **The Double Tunnel:** Netskope traffic gets pushed inside the OpenVPN tunnel. This creates suboptimal routing (hairpinning), latency, and performance degradation.
* **Dropped Connections:** The clients fight for the same traffic at the OS level, causing dropped packets, MTU (Maximum Transmission Unit) errors, or intermittent disconnects.

---

## The Steering Decision: Best Practice

The standard architectural decision for co-management is **Split Tunneling**. 

[Image of split tunneling vs full tunnel network diagram]

* **OpenVPN** should be responsible *only* for traffic destined for your internal, private corporate network resources.
* **Netskope** should be responsible for all internet-bound, SaaS, and public cloud traffic so it can apply security policies and content inspection.

---

## How to Configure Coexistence

To achieve this, you have to tell both applications to back off of each other's territory.

### 1. Configurations in OpenVPN

You must configure OpenVPN to allow Netskope to intercept internet traffic.

* **Enable Split Tunneling:** If you are using OpenVPN Access Server or OpenVPN Cloud, ensure that split tunneling is enabled. You want to route *only* specific private subnets through the VPN.
* **Do not force all internet traffic through the VPN:** In the OpenVPN Access Server Admin WebUI (under `VPN Settings > Routing`), ensure that the setting for routing client internet traffic through the VPN is disabled (or configured to allow bypasses).

### 2. Configurations in Netskope

You need to add "Exceptions" in Netskope’s Steering Configuration so Netskope completely ignores the traffic establishing the OpenVPN tunnel. 

> **Note:** If Netskope intercepts the VPN's connection to its gateway, the VPN will break.

Log into your Netskope tenant and add the following exceptions under `Settings > Security Cloud Platform > Steering Configuration > Exceptions`:

* **Destination Network / Location
