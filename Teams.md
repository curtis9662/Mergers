## Microsoft Teams Guest access
# Option 1: Enable External Access (Direct Chat)
Use this if you simply want users to be able to search for, call, and message people in other Microsoft 365 organizations without adding them to a specific Team. Both organizations must have this enabled to communicate.

1. **Sign in to the Teams Admin Center:** admin.teams.microsoft.com. Log in using an account with Global Administrator or Teams Administrator privileges.
2. **Navigate to External Access:** In the left-hand navigation pane, go to Users and select External access.
3. **Choose your domain configuration:** Under the section for Teams and Skype for Business users, select your preferred setting:
   * Allow all external domains: (Default) Open federation with any other Teams organization.
   * Allow only specific external domains: You must click Add external domains and enter the exact domains (e.g., partnercompany.com) you want to allow.
4. **Save and test:** Click Save. It may take a few hours for federation policies to fully sync. Test the configuration by sending a chat request to a user in the federated organization.
<img width="1096" height="1276" alt="image" src="https://github.com/user-attachments/assets/4bd481e6-aa0e-421c-adb5-d3d8d8cce114" />

Make Change Here → https://admin.teams.microsoft.com/company-wide-settings/external-communications

Add <ORG> Domain for cross environment collab

<img width="1405" height="1251" alt="image" src="https://github.com/user-attachments/assets/765432cf-8d8c-475d-934b-13f543659044" />




# Option 2: Enable Guest Access (Team and Channel Collaboration)
Use this if you need external individuals to actually join your specific Teams, access shared files, and chat within those team channels.

1. **Verify Entra ID collaboration settings:** entra.microsoft.com. Guest invitations must first be permitted at the directory level. In the Microsoft Entra admin center, navigate to External identities > External collaboration settings and ensure that admins or members are allowed to invite guests.
2. **Navigate to Guest Access in Teams:** admin.teams.microsoft.com. In the Teams Admin Center, go to Users and select Guest access.
3. **Enable Guest Access:** Toggle Allow guest access in Teams to On.
4. **Configure guest permissions:** Review the settings under the Messaging section. Ensure that Chat is enabled for guests so they can participate in conversations.
5. **Save changes:** Click Save. Note: It can take between 2 and 24 hours for guest access settings to take full effect across your Microsoft 365 tenant.

## Security Architecture Diagram:

```mermaid
flowchart TD
    %% Based on configuration steps[cite: 1]
    classDef tenant fill:#f9f9f9,stroke:#333,stroke-width:2px,color:#000;
    classDef internal fill:#d4edda,stroke:#28a745,stroke-width:2px,color:#000;
    classDef external fill:#f8d7da,stroke:#dc3545,stroke-width:2px,color:#000;
    classDef admin fill:#cce5ff,stroke:#007bff,stroke-width:2px,color:#000;
    classDef component fill:#fff,stroke:#666,stroke-width:1px,color:#000;

    subgraph OrgA["Organization A (Microsoft 365 Tenant)"]
        direction TB
        AdminA(["Global / Teams Administrator"]):::admin
        InternalUser(["Internal User"]):::internal

        subgraph Entra["entra.microsoft.com"]
            B2B["External Collaboration Settings<br/>(Permit directory-level guest invites)"]:::component
        end

        subgraph TeamsAdmin["admin.teams.microsoft.com"]
            ExtAccess["External Access Policy<br/>(Allow all or specific domains)"]:::component
            GuestAccess["Guest Access Policy<br/>(Allow guest access in Teams: On)"]:::component
            GuestPerms["Messaging Permissions<br/>(Enable Chat for guests)"]:::component
        end

        Team["Specific Team & Channels"]:::component
        Files[("Shared Files")]:::component

        Team --- Files
    end

    subgraph OrgB["Organization B (External Microsoft 365 Tenant)"]
        ExtUser(["External User"]):::external
    end

    %% Option 1: External Access Mapping[cite: 1]
    AdminA -. "Opt 1: Configures Federation" .-> ExtAccess
    ExtAccess <=="Opt 1: Direct Search, Call, & Message<br/>(Requires mutual federation)"==> ExtUser
    InternalUser <=="Opt 1: Direct Chat"==> ExtAccess

    %% Option 2: Guest Access Mapping[cite: 1]
    AdminA -. "Opt 2: Permits Directory Invites" .-> B2B
    AdminA -. "Opt 2: Enables Teams Guest Access" .-> GuestAccess
    B2B --> GuestAccess
    GuestAccess --> GuestPerms
    GuestPerms --> Team

    ExtUser == "Opt 2: Joins Specific Team" === Team
    InternalUser == "Opt 2: Collaborates in Channels" === Team
```
