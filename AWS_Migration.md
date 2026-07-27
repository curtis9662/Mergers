# Executive Project Plan: AWS Infrastructure Integration for Acquired Entity

## Executive Summary
This project plan outlines a **Zero-Downtime Organizational Shift** strategy to ingest the acquired business’s AWS workloads into our enterprise AWS environment. Rather than migrating individual servers or databases—which introduces operational risk and downtime—we will execute an administrative detachment of their AWS account from their legacy AWS Organization and attach it directly to ours. This ensures the continuous operation of their service offerings while instantly establishing our governance, billing, and security controls.

---

## Phase 1: Plan (Discovery & Due Diligence)
*Objective: Map dependencies and establish administrative control before altering the environment.*

*   **Credential Capture:** Secure the root email address, password, and Multi-Factor Authentication (MFA) devices for the acquired account.
*   **Policy Audit (SCPs):** Analyze the legacy Service Control Policies (SCPs). Discrepancies between their legacy organization and our target organization could inadvertently break application functionality.
*   **Resource Dependency Mapping:** Audit AWS Resource Access Manager (RAM) to identify network or infrastructure dependencies on the seller’s parent organization (e.g., shared Transit Gateways, central Route 53 Resolvers, shared subnets).
*   **Financial & Contractual Review:** Evaluate legacy billing agreements, including Enterprise Discount Programs (EDP), Savings Plans, and Reserved Instances (RIs) to determine transferability or buyout requirements.

---

## Phase 2: Design (Target Architecture)
*Objective: Architect a secure, governed landing zone that isolates the new entity while enabling centralized management.*

*   **Organizational Isolation (OU):** Design a dedicated "Acquisitions" or "Transitional" Organizational Unit (OU). This acts as a sandbox to apply custom transitional security policies before enforcing strict enterprise-wide compliance.
*   **Identity & Access Management (IAM):** Architect the identity federation mapping from their legacy IAM users to our centralized AWS IAM Identity Center (SSO), ensuring least-privilege access aligned with our corporate directory.
*   **Network Integration (Hub-and-Spoke):** Design the network integration utilizing AWS Transit Gateway. This model allows the acquired Virtual Private Clouds (VPCs) to seamlessly communicate with our shared enterprise services (e.g., central logging, security tooling) without complex peering meshes.

<img width="869" height="759" alt="image" src="https://github.com/user-attachments/assets/6d75c63e-12c4-44ac-b27d-4adae01a7832" />
---

## Phase 3: Risk Categorization & Mitigation
*Objective: Proactively identify and neutralize threats to business continuity.*

| Risk Domain | Impact Level | Executive Mitigation Strategy |
| :--- | :--- | :--- |
| **Service Downtime** | **Critical** | Execute an *Account-Level* migration. Workload resources (EC2, RDS) remain untouched, ensuring zero disruption to end-users. |
| **Network Decoupling** | **Critical** | Pre-build and test replacement shared network components (Transit Gateways, DNS Resolvers) prior to severing the legacy organizational tie. |
| **Policy Clashes (Access)**| **High** | Deploy a highly permissive "dry-run" SCP to the transitional OU initially. Utilize AWS CloudTrail to monitor for access denials before tightening governance. |
| **Billing Suspension** | **High** | Ensure a valid standalone payment method (or Invoice Billing status) is applied to the account to prevent AWS automated suspension during the transfer. |
| **Identity Lockout** | **Medium** | Provision redundant, break-glass cross-account IAM administrator roles prior to migration to bypass potential root credential failures. |

---

## Phase 4: Development (Pre-Migration Setup)
*Objective: Build and stage the target environment to ensure a frictionless cutover.*

*   **Landing Zone Provisioning:** Deploy the dedicated Transitional OU via AWS Control Tower or our standard Infrastructure as Code (IaC) pipeline.
*   **Security Baseline Deployment:** Write and attach baseline SCPs to the new OU. These will block catastrophic actions (e.g., disabling CloudTrail) without impeding the acquired application's operational API calls.
*   **Cross-Account Access Implementation:** Log into the acquired account and establish an IAM Role trusting our primary management account, guaranteeing API access during the transition.
*   **Historical Data Ingestion:** Replicate their Cost & Usage Reports (CUR) from legacy S3 buckets to our central management account to preserve historical spend analytics and forecasting.

---

## Phase 5: Configuration & Execution (The Cutover)
*Objective: Execute the strict, sequential runbook to securely transfer organizational ownership.*

1.  **Financial Decoupling:** Log in as the root user and attach a valid corporate credit card or verify AWS Support has enabled "Invoice" billing. *An account cannot leave an organization without valid standalone billing.*
2.  **Legacy Organization Departure:** Initiate the "Leave Organization" command from the acquired account's AWS Organizations console. *(Note: Coordination with the seller’s management account may be required if they created the account).*
3.  **Target Organization Ingestion:** Dispatch an invitation from our enterprise management account. Accept the invitation from the acquired account's root console to finalize the transfer.
4.  **Governance Application:** Immediately move the newly joined account from the organizational "Root" into the predefined Transitional OU, automatically applying our baseline security policies.
5.  **Enterprise Integration:** Attach the acquired VPCs to our central AWS Transit Gateway. Map our corporate Identity Provider (IdP) groups via IAM Identity Center and systematically deprecate the legacy IAM users.


