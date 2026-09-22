# Enterprise Technology Domain Checklist (M&A Due Diligence)

Use this checklist to evaluate a target organization's technology landscape before acquisition. Assessing these domains will highlight architectural risks, compliance gaps, and the financial/human resources required for remediation.

| Domain | Assessment Item | Status (Yes / Incomplete / No) | Risk / Resource Notes & Remediation |
| :--- | :--- | :--- | :--- |
| **1. Architecture & Systems** | High-level system blueprints and **Architecture Diagrams** are current and accurate. | | |
| | Service boundaries, API contracts, and third-party integrations are clearly mapped. | | |
| | Legacy systems are identified, with technical debt and modernization paths quantified. | | |
| | Systems are designed for horizontal scalability without major refactoring. | | |
| **2. Security & Identity** | Multi-Factor Authentication (MFA) and Single Sign-On (SSO) are enforced company-wide. | | |
| | System architecture adheres to secure-by-design principles (e.g., least privilege, zero-trust). | | |
| | Endpoint Detection and Response (EDR) is deployed on all corporate and server endpoints. | | |
| | Secrets and keys are managed via a centralized, secure vault (no hardcoded credentials). | | |
| **3. Cloud & Infrastructure** | Infrastructure is provisioned and managed via Infrastructure as Code (IaC). | | |
| | Network segmentation and strict ingress/egress firewall rules are enforced. | | |
| | Cloud resources are monitored for configuration drift and over-provisioning. | | |
| **4. Data Management & Privacy** | Data mapping, classification (e.g., PII, PHI), and ownership registers are actively maintained. | | |
| | Encryption is enforced for all data at rest and in transit (using managed keys). | | |
| | Data retention and secure disposal policies align with legal and regulatory mandates. | | |
| **5. Compliance & Governance** | Third-party audit reports (e.g., SOC 2, ISO 27001, PCI-DSS) are valid and up to date. | | |
| | Vendor risk management program is in place for all critical third-party suppliers. | | |
| | Regular penetration testing is conducted, with critical findings remediated promptly. | | |
| **6. Resilience & Recovery** | High Availability (HA) and automated failover mechanisms are implemented and tested. | | |
| | Disaster Recovery (DR) plans are documented and meet business Target RTO/RPO. | | |
| | Backups are automated, immutable, encrypted, and isolated from the primary network. | | |
| **7. CI/CD & Supply Chain** | Software Bill of Materials (SBOM) is maintained for all proprietary applications. | | |
| | CI/CD pipelines require automated security scanning (SAST, DAST, SCA) before deployment. | | |
| | Open-source software licenses are tracked to ensure compliance and avoid legal risk. | | |
| **8. Monitoring & Operations** | Centralized logging and observability platforms (e.g., SIEM) are fully implemented. | | |
| | A formal Incident Response Plan is documented and rehearsed via regular tabletop exercises. | | |
| | Alerting is configured for anomalous behavior, performance degradation, and security events. | | |