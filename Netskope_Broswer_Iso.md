# Netskope PCI Browser Isolation Configuration Guide

This configuration guide outlines the step-by-step procedure to implement Remote Browser Isolation (RBI) within Netskope for Payment Card Industry Data Security Standard (PCI DSS) compliance. This setup ensures that endpoints handling cardholder data (CHD) and sensitive authentication data (SAD) interact with web applications through an isolated cloud browser session, preventing local data exfiltration, local caching, and clipboard leaks.

---

## Phase 1: Create a Custom RBI Template (Security Baseline)
Configure a restrictive isolation profile tailored to PCI compliance parameters to lock down user interaction within payment portals and cardholder data environments (CDE).

1. Log in to the **Netskope Web Console**.
2. Navigate to **Policies** > **Templates** > **RBI** (Remote Browser Isolation).
3. Click **New Template** and provide a descriptive name (e.g., `PCI-High-Security-RBI-Template`).
4. Configure the restrictive browser controls:
   * **Clipboard Controls:** Toggle **Copy** and **Paste** to **Block** (or restrict to *Read-Only* depending on workflow needs) to prevent credit card numbers from being copied to local endpoints.
   * **Download/Upload Controls:** Set **File Download** and **File Upload** to **Block** to eliminate unauthorized exfiltration or importation of payment records.
   * **Printing & Display:** Disable **Printing** and enable **Watermarking** (if supported by your licensing tier) to overlay user identification or timestamp parameters across the session.
5. Click **Save** to store the template.

---

## Phase 2: Configure Web Categories and URL Lists for CDE Target Paths
Isolate traffic directed toward payment portals, financial gateways, or unmanaged third-party vendor platforms handling cardholder data.

1. Navigate to **Policies** > **Web** and select the **URL Lists** tab at the top.
2. Click **New URL List** to group specific payment processing domains or unmanaged vendor URLs (e.g., named `PCI-Payment-Portals`).
3. Add the exact target URLs or wildcard patterns, then save the list.
4. Navigate to **Policies** > **Web** > **Tagging / Custom Categories** (or use built-in categories such as *Financial Services* or *Parked Domains* if applicable).
5. Create or select a custom category referencing your payment URL list.

---

## Phase 3: Construct the Real-Time Protection Isolation Policy
Bind your PCI user groups, target payment categories, and the restrictive isolation template into an enforced real-time policy.

1. Navigate to **Policies** > **Real-time Protection**.
2. Click **New Policy** and select **Web Access**.
3. **Configure Source:** 
   * On the **Include** tab, select the targeted users or user groups handling payment cards (e.g., `Finance-Billing-Team` or `Call-Center-Agents`). By default, *All Users* can be selected if enterprise-wide PCI isolation is required.
4. **Configure Destination:**
   * Select **Category** and choose the payment or financial categories / custom URL lists configured in Phase 2.
5. **Configure Profile & Action:**
   * Set the action dropdown to **Isolate**.
   * Select the restrictive template created in Phase 1 (`PCI-High-Security-RBI-Template`).
6. **Set Policy Metadata:**
   * Provide a clear policy name (e.g., `PCI-Enforce-Browser-Isolation-Payment-Portals`).
   * Add a brief policy description noting its PCI DSS compliance mapping purpose.
7. **Set Status & Priority:**
   * Ensure the **Status** toggle is set to **Enabled**.
   * **Best Practice:** Move this policy to the **top of your policy list** using the reordering tool to ensure traffic is evaluated and isolated prior to standard allow/block rules.
8. Click **Save** in the upper right corner, then click **Apply Changes** to enforce the new isolation rules globally across your tenant nodes.

---

## Phase 4: Validation and Monitoring
Verify that isolation is active and that cardholder environments are properly protected from local client endpoint exposure.

1. **Verify User Experience:** 
   * Open an incognito or corporate browser session as a test user within the targeted scope and navigate to an isolated payment URL.
   * Confirm that visual isolation indicators appear (such as a secure browser border, watermark, or notification banner confirming the session is running in isolation).
   * Test restricted controls (attempt to copy text or upload/download a file) to ensure the restrictions defined in the RBI template successfully block the actions.
2. **Audit via Skope IT:**
   * Navigate to **Skope IT** > **Events & Alerts** > **Network Events**.
   * Filter by **Action = Isolate** to review active isolated sessions, verify user identity metadata, and collect audit logs for QSA review during PCI compliance assessments.
