# Enterprise IT Resource Decommissioning Protocols
**Document Classification:** Internal / Highly Restricted  
**Maintainer Role:** Purple Team Operations / Infrastructure Architecture  
**Lifecycle State:** Active  

## 1. Abstract and Methodology
Proper decommissioning of enterprise nodes, cloud constructs, and identity access architectures is a critical mitigation strategy against shadow IT vulnerabilities, residual data exposure, and lateral escalation via orphaned access. This document outlines the cryptographic, physical, and identity-based termination procedures required for enterprise resource sunsets.

All procedures must be logged with corresponding artifacts and computationally validated before a resource is marked `Completed`.

---

## 2. Decommissioning Matrix

### Domain 1: Hardware (On-Premises)
| Task ID | Action Item | Description | Artifact/Evidence Example | Status | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **HW-01** | Inventory Verification | Cross-reference physical asset MAC/Serial with CMDB. | CMDB entry matched | Pending | |
| **HW-02** | Network Disconnection | Isolate device from production LAN/VLAN. | Port disabled on switch | Pending | |
| **HW-03** | Data Sanitization | Cryptographic wipe or overwrite per NIST 800-88. | Certificate of Destruction (CoD) | Pending | |
| **HW-04** | Asset Tag Removal | Remove enterprise tracking and RFID asset tags. | Photograph of clean chassis | Pending | |
| **HW-05** | Physical Rack Removal | Unmount from server rack and disconnect power. | Rack U-space marked available | Pending | |
| **HW-06** | Secure Transit | Log chain of custody to e-waste/disposal facility. | Shipping manifest signed | Pending | |
| **HW-07** | Lease/Disposal Closure | Return to lessor or confirm e-waste recycling. | Final e-waste receipt | Pending | |

### Domain 2: Cloud Resources (AWS/Azure/GCP)
| Task ID | Action Item | Description | Artifact/Evidence Example | Status | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **CL-01** | Dependency Mapping | Ensure no active services depend on the resource. | CloudTrail / Log analytics review | Pending | |
| **CL-02** | Final Snapshot | Take final backup of volume/database. | AMI or RDS Snapshot ID logged | Pending | |
| **CL-03** | Compute Termination | Terminate EC2/VM instances. | Instance state: `Terminated` | Pending | |
| **CL-04** | Storage Deletion | Empty and delete S3/Blob storage buckets. | Bucket deletion confirmation | Pending | |
| **CL-05** | Network Cleanup | Release Elastic IPs, delete orphaned subnets/VPCs. | EIP released to pool | Pending | |
| **CL-06** | IAM Revocation | Delete specific IAM roles, profiles, and policies. | IAM Policy deletion log | Pending | |
| **CL-07** | Billing Verification | Confirm resource is removed from billing alerts. | Cost Explorer zeroed out | Pending | |

### Domain 3: Software and Licensing
| Task ID | Action Item | Description | Artifact/Evidence Example | Status | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SW-01** | Seat Reclamation | Remove user assignment from license portal. | SaaS dashboard shows +1 free seat | Pending | |
| **SW-02** | Local Uninstallation | Run remote uninstall script on endpoint. | SCCM / Intune success log | Pending | |
| **SW-03** | KMS Key Revocation | Revoke associated decryption/license keys. | KMS revocation event | Pending | |
| **SW-04** | Subscription Cancel | Cancel auto-renewal for standalone software. | Vendor email confirmation | Pending | |
| **SW-05** | Vendor Notification | Notify vendor of reduced enterprise footprint. | Contract addendum | Pending | |
| **SW-06** | Compliance Update | Update internal software audit records. | Audit ledger entry | Pending | |
| **SW-07** | Cost Center Adjustment | Remove line item from departmental budget. | Finance portal updated | Pending | |

### Domain 4: Applications and Data Services
| Task ID | Action Item | Description | Artifact/Evidence Example | Status | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **APP-01** | DNS Deletion | Remove A, CNAME, and TXT records. | Route53 / DNS zone updated | Pending | |
| **APP-02** | SSL Revocation | Revoke TLS/SSL certificates for the app. | Certificate Authority CRL updated | Pending | |
| **APP-03** | Service Account Disable | Disable app-to-app service accounts. | AD/IAM service account locked | Pending | |
| **APP-04** | Data Archival | Export relational/NoSQL data to cold storage. | Glacier / Cold blob archive created | Pending | |
| **APP-05** | API Gateway Removal | Deprecate and delete API endpoints. | Swagger/OpenAPI spec retired | Pending | |
| **APP-06** | Secrets Deletion | Purge DB credentials from Secrets Manager. | HashiCorp Vault / AWS Secrets empty | Pending | |
| **APP-07** | App Service Teardown | Delete Kubernetes namespaces or App Services. | `kubectl delete ns` executed | Pending | |

### Domain 5: Personnel and Identity Access
| Task ID | Action Item | Description | Artifact/Evidence Example | Status | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ID-01** | IdP Suspension | Disable Active Directory or SSO (Okta) account. | AD `userObject` status = Disabled | Pending | |
| **ID-02** | MFA Revocation | Revoke Duo/Authenticator tokens. | MFA device wiped from portal | Pending | |
| **ID-03** | VPN Termination | Disable VPN client access and profiles. | Cisco/PaloAlto VPN log | Pending | |
| **ID-04** | SSH/GPG Key Invalid. | Remove public keys from `authorized_keys` / Git. | GitHub/GitLab keys revoked | Pending | |
| **ID-05** | Mailing List Removal | Remove user from distribution lists. | Exchange / Workspace group updated | Pending | |
| **ID-06** | Physical Badge Access | Deactivate RFID/building access badge. | Lenel / Kantech system disabled | Pending | |
| **ID-07** | Device Recovery | Retrieve laptop, phone, and hardware tokens. | IT Helpdesk hardware receipt | Pending | |

---
**Implementation Note:** Validation artifacts must be retained for compliance audits (SOC2/ISO27001). Do not skip domains assuming non-applicability without formal Purple Team sign-off.
