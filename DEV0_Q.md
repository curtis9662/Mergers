# 🛡️ Enterprise SecOps: The Threat Hunter's Arsenal
### *Curtis' 🔝 15 Advanced LINQ Queries for Security Architecture & Telemetry Analysis*

---

## 🎯 SecOps Exec Summary

To maintain a mathematically validated and highly secure enterprise posture, security architects require real-time, high-fidelity visibility into global telemetry. This artifact provides a comprehensive library of 15 advanced Devo LINQ queries.  

Designed for both **tactical threat hunting** and **strategic risk visibility**, these queries translate raw, hyper-scale log data into actionable security intelligence. They are categorized across five critical enterprise pillars: Identity, Cloud, Network, Endpoint, and Web perimeters.

---

## 🔐 Pillar 1: Identity & Access Management (IAM)
*Defending the modern perimeter: User Credentials and Authentication.*

### 1️⃣ Distributed Credential Stuffing & Brute Force
**The Threat:** Threat actors bombarding authentication portals to crack weak passwords or leverage compromised credential databases.  
**The Logic:** Groups Windows Failed Logon events (Event ID `4625`) by user and host into 5-minute rolling windows, alerting when an abnormal threshold is breached.

from box.win.security  
where eventId = "4625"  
group every 5m by targetUserName, srcHost  
select count() as failed_attempts  
where failed_attempts > 15  

---

### 2️⃣ Impossible Travel & Anomalous SSO Geo-Velocity
**The Threat:** A single user identity successfully authenticating from two geographically impossible locations within a short timeframe.  
**The Logic:** Analyzes successful enterprise logins, grouping by user per hour, and triggers if the unique country count exceeds physical travel capabilities.

from auth.all.logins  
where status = "success"  
group every 1h by user  
select count(distinct(geoip.country)) as countries_visited  
where countries_visited > 1  

---

### 3️⃣ Privileged Access Management (PAM) Evasion
**The Threat:** Unauthorized addition to privileged administrative groups.  
**The Logic:** Filters Active Directory telemetry for sensitive group modification Event IDs.

from box.win.security  
where eventId in ["4728", "4732", "4756"]  
select eventdate, hostName, accountName, targetUserName, groupName  

---

## ☁️ Pillar 2: Cloud Workload Security (AWS/Azure)

### 4️⃣ Cloud IAM Privilege Escalation (AWS)
**The Threat:** Compromised accounts elevating privileges.  

from cloud.aws.cloudtrail  
where eventName in ["AttachUserPolicy", "AttachRolePolicy", "PutUserPolicy", "CreateAccessKey"]  
group every 10m by userIdentity.arn, eventName, sourceIPAddress  
select count() as action_count  

---

### 5️⃣ Public Cloud Data Exposure (S3 Bucket Manipulation)

from cloud.aws.cloudtrail  
where eventName = "PutBucketPublicAccessBlock" or eventName = "PutBucketPolicy"  
select eventdate, sourceIPAddress, userIdentity.arn, requestParameters.bucketName  

---

### 6️⃣ Azure Active Directory Suspicious Telemetry

from cloud.azure.audit  
where operationName = "Sign-in activity" and properties.status.errorCode != "0"  
group every 5m by properties.userPrincipalName  
select count() as auth_failures  
where auth_failures > 20  

---

## 🌐 Pillar 3: Network Perimeter & Transport Layer

### 7️⃣ Covert Data Exfiltration via DNS Tunneling

from net.dns.query  
where type = "A" or type = "TXT"  
select len(query) as qlen, query, srcIp, domain  
where qlen > 100  

---

### 8️⃣ Massive Outbound Data Transfer (Perimeter Exfiltration)

from firewall.all.traffic  
where action = "allow" and isOutbound = true  
group every 1h by srcIp, dstIp  
select sum(bytesOut) as total_outbound_bytes  
where total_outbound_bytes > 1073741824  

---

### 9️⃣ External Infrastructure Scanning (RDP/SSH)

from firewall.all.traffic  
where dstPort in [3389, 22] and isOutbound = false and action = "deny"  
group every 10m by srcIp  
select count() as dropped_connections  
where dropped_connections > 250  

---

## 💻 Pillar 4: Endpoint Execution & EDR Telemetry

### 🔟 Obfuscated Lateral Movement (PowerShell)

from box.win.security  
where eventId = "4688" and has(processName, "powershell.exe") and re(commandLine, "(?i)(-enc|-encodedcommand)")  
select eventdate, hostName, accountName, processName, commandLine  

---

### 1️⃣1️⃣ Suspicious Office Macro Execution (Child Processes)

from box.win.security  
where eventId = "4688" and re(parentProcessName, "(?i)(winword\\.exe|excel\\.exe|powerpnt\\.exe)") and re(processName, "(?i)(cmd\\.exe|powershell\\.exe)")  
select eventdate, hostName, accountName, parentProcessName, commandLine  

---

### 1️⃣2️⃣ Anti-Forensics: Clearing System Event Logs

from box.win.security  
where eventId in ["1102", "104"]  
select eventdate, hostName, accountName, eventId, message  

---

## 🕸️ Pillar 5: Web Application & WAF Security

### 1️⃣3️⃣ SQL Injection (SQLi) Exploitation

from web.all.access  
where re(url, "(?i)(union.*select|drop.*table|insert.*into)")  
select eventdate, srcIp, url, userAgent, statusCode  

---

### 1️⃣4️⃣ Remote Code Execution (RCE) via JNDI Lookups

from web.all.access  
where has(url, "jndi:ldap") or has(userAgent, "jndi:ldap") or has(url, "jndi:rmi")  
select eventdate, srcIp, url, userAgent, statusCode  

---

### 1️⃣5️⃣ Automated Directory Traversal & DirBusting

from web.all.access  
where statusCode = "404"  
group every 1m by srcIp  
select count() as missed_endpoints  
where missed_endpoints > 75  

---
