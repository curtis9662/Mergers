# AWS VPC Hardening for CLI Access & Identity-Driven Egress

This document outlines the architectural controls and VPC hardening configurations required to securely support AWS CLI access and restrict outbound egress traffic explicitly to authorized Authentication (AuthN) and Authorization (AuthZ) identity providers.

For visual mapping and network context, please refer to the "Architecture Diagrams" file.

## VPC Hardening Controls

| Control Category | Hardening Configuration | Implementation Details | AuthN / AuthZ & Egress Focus |
| :--- | :--- | :--- | :--- |
| **CLI Access** | **VPC Endpoints (PrivateLink)** | Deploy Interface VPC Endpoints for AWS services (e.g., `ec2messages`, `ssmmessages`, `sts`) to allow private CLI/API access without traversing the public internet. | Ensures CLI commands and STS token requests issued by authorized IAM identities remain entirely within the AWS backbone. |
| **CLI Access** | **SSM Session Manager** | Replace public bastion hosts with AWS Systems Manager (SSM) Session Manager. Disable inbound SSH/RDP (port 22/3389) on all Security Groups. | AuthZ is handled centrally via IAM policies. No inbound IP ranges need to be opened, drastically reducing the network attack surface. |
| **Egress Control** | **Security Group Egress Filtering** | Remove the default `0.0.0.0/0` outbound rule from workloads. Explicitly define allowed egress IP ranges. | Lock down egress CIDR blocks strictly to the published IP ranges of your Identity Providers (e.g., Okta, Microsoft Entra ID) to allow for seamless AuthN token validation and SSO. |
| **Egress Control** | **AWS Network Firewall / Proxy** | Deploy AWS Network Firewall or a centralized egress proxy for SNI/domain-based outbound filtering. | Allow TLS egress strictly to IdP FQDNs (e.g., `*.okta.com`, `login.microsoftonline.com`) to handle IdP IP range fluctuations and prevent IP spoofing. |
| **Access Control** | **VPC Endpoint Policies** | Attach strict resource policies to all VPC Endpoints. | Restrict Endpoint access to specific `Principal` identities (IAM Roles/Users) and enforce `aws:SourceVpc` to prevent lateral data exfiltration. |
| **Access Control** | **IAM Condition Keys (Source IP)** | Enforce `aws:SourceIp` and `aws:SourceVpce` conditions on IAM roles used by developers and CLI automation tools. | Limits the invocation of AWS CLI commands so they can only be executed from trusted corporate egress IP ranges or specific secured VPC Endpoints. |
| **Network Isolation** | **Stateless Network ACLs (NACLs)** | Apply stateless NACL rules at the subnet boundary to restrict outbound traffic and ephemeral ports. | Acts as a defense-in-depth boundary beneath Security Groups, ensuring subnets hosting CLI workspaces can only route to known internal perimeters and explicit IdP ranges. |

---
*Note: Apply these configurations via Infrastructure as Code (IaC) to maintain drift detection, ensure repeatable architectural boundaries, and enable automated enforcement in your CI/CD pipelines.*
