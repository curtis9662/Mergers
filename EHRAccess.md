# Zero Trust Architecture: Secure EHR Access via Zscaler & Okta

## Executive Summary
This document outlines the architecture and engineering steps required to transition from a legacy VPN access model to a Zero Trust Network Access (ZTNA) model for accessing a web-based Enterprise Health Record (EHR) system (using Epic as the example). This solution utilizes Zscaler Private Access (ZPA) for secure routing and Okta for Identity and Access Management (IAM) with Multi-Factor Authentication (MFA).

## 1. Architecture Components
* **Endpoint:** Zscaler Client Connector (ZCC) installed on user devices intercepts traffic destined for the EHR.
* **Identity Provider & MFA Broker:** Okta provides Single Sign-On (SSO) and enforces Multi-Factor Authentication (MFA).
* **ZTNA Broker:** Zscaler Zero Trust Exchange (ZPA Cloud) authenticates the user and applies access policies.
* **Internal Gateway:** ZPA App Connectors are lightweight VMs deployed in the same network/VPC as the EHR. They maintain a persistent *outbound* TLS tunnel to the ZPA Cloud, eliminating the need for inbound firewall ports.
* **EHR Application:** Epic (web-based client like Hyperspace/Hyperdrive).

## 2. Engineering & Implementation Steps

### Phase 1: Identity & Access Management (IAM) Integration
1.  **Configure IdP:** Integrate Okta with Zscaler via SAML 2.0.
2.  **Enforce MFA:** Create an Okta Sign-On Policy requiring MFA (e.g., Okta Verify, Push, or hardware token) whenever a user authenticates to the Zscaler application or attempts to access the Epic application.
3.  **SCIM Provisioning:** Enable SCIM to automatically sync user groups from Okta to Zscaler for role-based policy assignment.

### Phase 2: ZPA Infrastructure Setup
4.  **Deploy App Connectors:** Spin up 2 to 4 ZPA App Connector VMs (for redundancy and load balancing) within the datacenter or VPC hosting the Epic web servers.
5.  **Authenticate Connectors:** Apply Provisioning Keys generated from the ZPA admin portal to the App Connectors so they can establish secure outbound tunnels to the Zscaler Zero Trust Exchange.

### Phase 3: Application Segmentation
6.  **Define Application Segments:** In Zscaler, define the Epic web application (e.g., `epic.hospital.org`) and specify the allowed ports (TCP 443).
7.  **Server Groups:** Map the Application Segment to the specific ZPA App Connectors that have line-of-sight to the internal Epic servers.

### Phase 4: Policy Enforcement
8.  **Access Policies:** Create rules in ZPA restricting access to the Epic App Segment. Ensure only authorized Okta groups (e.g., "Clinical_Staff") have access.
9.  **Timeout Settings:** Set strict re-authentication timeouts to ensure idle users must re-authenticate with Okta MFA before regaining access to the EHR.

### Phase 5: Endpoint Deployment
10. **Deploy ZCC:** Push the Zscaler Client Connector to endpoints via your MDM (e.g., Intune, SCCM).
11. **Configure Forwarding Profile:** Ensure ZPA is enabled so that when the user accesses the Epic URL, ZCC intercepts the traffic transparently and forwards it to the ZPA Cloud.

## 3. Proof of Concept (PoC) Diagram

Below is the logical flow of the Zero Trust architecture:

[ 1. User Endpoint ]
       │
       ├─ (A) User browses to epic.hospital.org
       ├─ (B) Zscaler Client Connector intercepts traffic
       ▼
[ 2. Okta Identity Provider ] ─── (C) Prompts for MFA ───> [ User Smartphone ]
       │
       ├─ (D) User is authenticated (SAML Assertion)
       ▼
[ 3. Zscaler Zero Trust Exchange (ZPA Cloud) ]
       │
       ├─ (E) ZPA evaluates access policies
       ├─ (F) ZPA stitches endpoint session to App Connector session
       ▲
       │  (G) Persistent Outbound TLS Tunnel (No inbound open ports!)
       │
[ 4. ZPA App Connectors (Inside your Datacenter/VPC) ]
       │
       ├─ (H) App Connector proxies the web request locally
       ▼
[ 5. Epic EHR Web Servers ]

  <img width="1532" height="836" alt="image" src="https://github.com/user-attachments/assets/a6e61032-193a-4a46-a3a5-48592e75a0fa" />
