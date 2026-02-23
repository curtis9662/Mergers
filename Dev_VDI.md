🚀 M&A Onboarding: Microsoft DevBox Deployment Runbook
Task Type: Development | Planning | Procedural | Enterprise Process
Author: Platform Engineering Team
🎯 Strategic Objective
Provide dedicated, isolated virtual workspaces for integrated employees immediately upon merger.
The Goal: Seamless access to segmented corporate applications.
The Rule: Zero circumvention of current enterprise security controls.

🛠️ Execution Playbook
Phase 1: Validating Prerequisites
Do not proceed to infrastructure deployment until Identity & Access Management (IAM) confirms the following licensure for the new @org.tld accounts.
Requirement
Supported License Types
Status
Identity
Azure Active Directory P1 or P2 (Entra ID)
⬜
Management
Microsoft Intune
⬜
OS
Windows 11 Enterprise
⬜

(💡 Pro-Tip: These are typically bundled within M365 E3/E5, A3/A5, Business Premium, or Windows 365 Enterprise).

Phase 2: Create the Template (Dev Box Definition)
Azure requires the blueprint to exist before the pool can be constructed.
Access Dev Center: Navigate to the Azure Portal ➡️ Dev Center.
Define the Box: Select Dev box definitions ➡️ + Create.
Source: Azure Marketplace (e.g., Win 11 Enterprise + M365 Apps) OR Custom Compute Gallery.
Compute: Select appropriate SKU (e.g., 8 vCPU, 32GB RAM).
Storage: Assign minimum 256GB SSD.
Save: Wait for Azure validation to clear.

Phase 3: Project Pool Creation & IAM Assignment
Deploy the holding area for the M&A user workspaces.
Target Project: Navigate to the specific Dev Center Project designated for M&A.
Deploy Pool: Select Dev box pools ➡️ + Create.
Name: pool-ma-integration-01
Definition: Attach the template created in Phase 2.
Networking: Attach the isolated M&A Virtual Network (VNet).
Privileges: Assign Standard User or Local Admin.
Grant Access: * Navigate to Access control (IAM) ➡️ + Add role assignment.
Select DevCenter Dev Box User.
Assign to the target name.user@org.tld identities.

📢 End-User Communication
Copy the block below and send to newly acquired personnel.
Subject: 🔑 Welcome! Your Secure Virtual Workspace is Ready
Welcome to the team! To get you securely connected to our corporate applications, we have provisioned a dedicated Microsoft DevBox for you.
How to connect:
Navigate to the Microsoft Developer Portal: https://devbox.microsoft.com
Sign in using your new corporate identity: <name.user@org.tld>
Locate the workspace titled "M&A Integration Pool" and click "+ Add Dev Box".
Once creation is complete, click "Open in browser" or connect using the standard Remote Desktop App.
This secure environment gives you all the tools you need right now while we work on fully integrating our backend systems. If you run into any issues, please reach out to IT Support!

graph LR
    classDef user fill:#e1bee7,stroke:#8e24aa,stroke-width:2px;
    classDef auth fill:#ffe082,stroke:#ffb300,stroke-width:2px;
    classDef cloud fill:#b3e5fc,stroke:#039be5,stroke-width:2px;
    classDef vm fill:#c8e6c9,stroke:#43a047,stroke-width:2px;
    classDef data fill:#ffccbc,stroke:#f4511e,stroke-width:2px;

    A((🧑‍💻)):::user --> B{🛡️}:::auth
    B --> C[(☁️)]:::cloud
    C --> D[💻]:::vm
    D --> E[(🏢)]:::data

    
References & Citations:

Official Microsoft Dev Box Documentation
References & Citations:

Official Microsoft Dev Box Documentation

<img width="1025" height="371" alt="image" src="https://github.com/user-attachments/assets/fba5fa10-81c6-4eba-a561-5e0fb03b0aec" />

Refer to CSP Guidance:
https://learn.microsoft.com/en-us/azure/dev-box/quickstart-configure-dev-box-service
