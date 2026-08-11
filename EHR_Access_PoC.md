> ## Omnissa

Core Architectural Layers
1. Endpoint / Client Layer: Native application or web client running on Windows, macOS, Linux, iOS, Android, or ChromeOS that handles local hardware, USB redirection, and user input.
2. Access & Security Layer: Unified Access Gateway (UAG) acts as a secure reverse proxy in the DMZ, authenticating users and managing the Blast Secure Gateway.
3. Brokering Layer: Horizon Connection Server authenticates credentials against Active Directory and queries user desktop/application entitlements.
4. Virtual Resource Layer: Horizon Agent runs inside the target virtual machine, physical PC, or RDS host to render and stream the desktop session
5. Encrypted Protocol Traffic: All Data is contained with the Web Session, with DLP controls configured via client policies.
6. Stream Desktop App Session: User is essentially visiting the web app via port :443

<img width="1140" height="970" alt="image" src="https://github.com/user-attachments/assets/2e8f4757-880d-47ee-9244-13a021666c70" />
