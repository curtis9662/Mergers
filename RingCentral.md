# RingCentral for Microsoft Teams Integration: Executive Technical Overview

Here is the curated list of authoritative technical documentation for the RingCentral for Microsoft Teams integration. This list is organized to provide executive and IT architecture teams with direct access to network, port, and service requirements.

## RingCentral Network & Port Requirements

### [RingCentral Network Requirements](https://support.ringcentral.com/article-v2/Network-requirements.html)
**Overview:** Details the essential IP supernets, FQDNs, and destination ports required for RingCentral services. This includes UDP ports 20000-64999 for RTP/SRTP media and TCP port 443 for API and signaling services.

### [RingCentral Partner Network Guidelines](https://support.ringcentral.com/article-v2/Network-requirements-partner.html)
**Overview:** Provides granular network topology requirements, application protocols, and Quality of Service (QoS) guidelines tailored for enterprise-level unified communications setups.

## Microsoft Teams Network & Port Requirements

### [Microsoft 365 URLs and IP Address Ranges](https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide)
**Overview:** The official Microsoft repository outlining mandatory firewall configurations for Teams, specifically detailing the required outbound UDP ports 3478–3481 for media traversal and TCP ports 443/80.

### [Prepare Your Organization's Network for Teams](https://learn.microsoft.com/en-us/microsoftteams/prepare-network)
**Overview:** Covers strategic network planning, bandwidth calculation, split-tunnel VPN recommendations, and DNS record requirements for ensuring high-quality media routing.

### [Microsoft Teams Call Flows](https://learn.microsoft.com/en-us/microsoftteams/microsoft-teams-online-call-flows)
**Overview:** Explains the architecture of how media routing and signaling traffic traverse between the end user, Microsoft 365 cloud, and external Session Border Controllers (SBCs).

## RingCentral Integration Services & Architecture

### [Setting Up Direct Routing (Cloud PBX 2.0)](https://support.ringcentral.com/article-v2/Enabling-direct-routing-in-RingCentral-and-Microsoft-Teams.html)
**Overview:** A comprehensive guide on configuring native Direct Routing, which establishes RingCentral as the backend telephony provider for native PSTN voice calls inside the Teams app.

### [Direct Routing Authentication Methods](https://support.ringcentral.com/article-v2/Understanding-the-Microsoft-Teams-Direct-Routing-OAuth-connection.html)
**Overview:** Compares OAuth 2.0 and Azure Active Directory connection setups. Details the necessary Microsoft Graph API service principals, admin consent requirements, and automated configurations (like dial plans and voice routing policies) executed during setup.

### [Deploying the Embedded App (Next-Gen Integration)](https://support.ringcentral.com/article-v2/RingCentral-s-next-generation-integration-for-the-Microsoft-Teams-desktop-and-web-app.html)
**Overview:** Details deployment prerequisites, licensing requirements (such as E1, E3, or E5), and the required installation architecture (desktop/web app, embedded app, and desktop plugin).

### [VDI Environment Support & Optimization](https://support.ringcentral.com/article-v2/Using-RingCentral-for-Teams-in-a-VDI-environment.html)
**Overview:** Technical specifications for running the integration on virtual desktop infrastructure environments (Citrix, Azure, and Omnissa/VMware). Includes deployment steps for universal plugins and services to ensure audio and media optimization.
