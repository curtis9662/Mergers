# M&A / Vendor Due Diligence: Security Controls Audit Template

This document provides a structured table and evaluation criteria for auditing an organization or vendor's security posture during due diligence. It is formatted for direct integration into your GitHub repositories.

## 1. Executive Summary & Asset Profile
Use the following table to map out the foundational business and technical context for each target application or vendor.

| Name of Vendor | Name of Application | SBOM (Status/Format) | Roles (Access/Privilege) | Compliance Requirements | Geographic Locations of Business | Number of Associates | Expected Growth |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| *Example Corp* | *Acme Cloud SaaS* | Yes (CycloneDX) | SuperAdmin, User, API | SOC2, GDPR, HIPAA | US (East/West), EU (Frankfurt) | 1,200 | 25% YoY (Scaling to APAC) |
| [Target Vendor] | [Target App] | [e.g., SPDX/None] | [e.g., RBAC/ABAC] | [e.g., PCI-DSS] | [e.g., US-Only] | [Headcount] | [Growth Metric] |

---

## 2. Security Control Evaluation Criteria
To effectively evaluate the current status based on the profile above, audit the following security controls against the acquired organization's systems:

### A. Software Supply Chain (SBOM)
* **Dependency Mapping:** Generate and retain Software Bill of Materials (SBOMs) to instantly map inherited dependencies and gate builds on policy compliance[cite: 2].
* **Vulnerability Monitoring:** Evaluate external services and open-source software for vulnerabilities, monitor for CVEs, and pin versions immediately[cite: 2].

### B. Identity & Access Management (Roles)
* **Centralized Identity (IdP):** Centralize user authentication with an OIDC/OAuth2 IdP and enforce MFA for all privileged paths within the acquired IP[cite: 2].
* **Least Privilege Tooling:** Restrict CI/CD pipelines, VCS apps, and integrations to minimal scopes, requiring approvals for sensitive actions[cite: 5].

### C. Regulatory & Governance (Compliance Requirements)
* **Control Mapping:** Map the acquired system's controls to GDPR, PCI DSS, or relevant regulations, documenting compensating controls where gaps exist[cite: 2].
* **Data Classification:** Classify the newly acquired data with a named owner and apply appropriate controls like encryption for sensitive data[cite: 2].

### D. Architecture & Data Residency (Geographic Locations)
* **Zero-Trust Boundaries:** Treat all newly acquired networks as untrusted, authenticate every call, and make trust zones explicit before connecting to your core network[cite: 2].
* **Visual Mapping:** Review the "Architecture Diagrams" file to visualize network segmentation, potential network failure points, and critical network transitions[cite: 2].

### E. Scalability & Resilience (Associates & Expected Growth)
* **Rate Limiting & Quotas:** Enforce gateway/mesh rate limits (per endpoint, per client) with sensible defaults to prevent the new IP from causing noisy-neighbor outages during periods of expected growth[cite: 5].
* **Automated Verification:** Rely on automated scanning where applicable to test the application against ASVS verification levels to catch implementation gaps fast[cite: 2].

---
*Generated for enterprise GitHub repositories to track technical debt and security baselines during M&A and Vendor Due Diligence.*
