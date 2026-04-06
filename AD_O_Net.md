3-tiered architecture:

CUSTOMER ON-PREMISES & MANAGED ENDPOINTS: Users are mastered in Active Directory. The Okta AD Agent integrates AD with Okta. The Netskope Client is deployed to endpoints to steer traffic to the Netskope Security Cloud.

OKTA IDENTITY CLOUD (IdP): Okta serves as the single source of truth for identity in the cloud. It manages user and group information synced from AD and provides authentication and authorization services for applications.

NETSKOPE SECURITY CLOUD (SP): Netskope acts as the Service Provider (SP), offering CASB, SWG, and Private Access (NPA). It consumes signed SAML assertions from Okta to authenticate users and enforce security policies.

![AD_O_Net2](https://github.com/user-attachments/assets/41e2c715-c0d3-4049-a76e-d0696c093683)

**Phase 1: Discovery & Assessment (Pre-Day 1)**

Start by inventorying existing IAM environments for both organizations, assessing directories, applications, and access rights. This includes identifying all user stores, credential systems, and evaluating compliance requirements.

Conclude this phase by defining your integration strategy and target IAM architecture (e.g., complete consolidation or a phased coexistence).

**Phase 2: Connectivity & Governance (Day 1)**

Establish secure network connectivity between both corporate environments.

Create an initial operational state by establishing domain trusts or setting up B2B guest access to enable cross-company collaboration on key resources.

Implement unified governance policies and define global security standards for the new, integrated organization.

**Phase 3: Immediate Integration (Day 1 Focus)**

Focus on quick wins and seamless operation: Provision acquired users into the acquirer's directory for immediate access to critical cross-company collaboration tools like email, Teams, or internal portals.

Configure Single Sign-On (SSO) for essential applications, sync key user attributes, and enable streamlined communication.

**Phase 4: Deep Integration (Post-Day 1)**

Transition from immediate integration to long-term standardization: Migrate all applications to the unified Identity Provider (IdP).

Consolidate user roles, group structures, and entitlements across the unified directory.

Automate user lifecycle management processes (Joiner, Mover, Leaver).

Decommission legacy directories and systems to reduce complexity and security risk.

<img width="1408" height="768" alt="AD_O_Net" src="https://github.com/user-attachments/assets/20582b86-a6b1-4b60-883e-6d4124fffb20" />
