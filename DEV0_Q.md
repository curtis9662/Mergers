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

# Queries for AWS Security Investigations and IAM Reviews

This document provides a comprehensive guide for security analysts, threat hunters, and cloud administrators using the **Devo Platform** (Data Analytics and SIEM) to investigate AWS environments. 

The following 15 carefully curated DEVO queries (using Devo's LINQ syntax) focus specifically on Identity and Access Management (IAM) reviews, privilege escalation monitoring, and identifying anomalous behaviors within AWS CloudTrail logs.

> **Note on Data Models:** The queries below assume your AWS CloudTrail logs are ingested into the standard Devo tag `cloud.aws.cloudtrail`.
> Depending on your specific Devo parser configurations, nested JSON fields might use dot notation (e.g., `userIdentity.type`) or underscores (e.g., `userIdentity_type`).

---

## 1. Unauthorized API Calls (Access Denied / Unauthorized Operation)
**Use Case:** Identifying users, roles, or compromised keys attempting to perform actions beyond their permitted IAM policies. A sudden spike in these errors often indicates reconnaissance or lateral movement attempts.

```linq
from cloud.aws.cloudtrail
where errorCode in ('AccessDenied', 'UnauthorizedOperation')
group by eventName, userIdentity.arn, sourceIPAddress
every 1h
select count() as deny_count
where deny_count > 10
```
**Investigation Steps:**
* Check if the `userIdentity.arn` belongs to an application role with a newly deployed bug, or a human user probing the environment.
* Correlate the `sourceIPAddress` with known VPN IPs or corporate networks.

## 2. AWS Root Account Usage
**Use Case:** The AWS Root account should almost never be used for day-to-day operations. Any login or API call made by the Root user is a critical security event that requires immediate verification.

```linq
from cloud.aws.cloudtrail
where userIdentity.type = 'Root' 
  and eventName != 'ConsoleLogin' 
  and sourceIPAddress != 'AWS Internal'
select eventTime, eventName, sourceIPAddress, userAgent, recipientAccountId
```
**Investigation Steps:**
* Confirm with cloud infrastructure leaders if an emergency root action was scheduled.
* Check if MFA was used during the root console login leading to these API calls.

## 3. CloudTrail Tampering or Evasion
**Use Case:** Attackers often attempt to blind defenders by stopping logging, deleting trails, or modifying the S3 bucket where logs are stored.

```linq
from cloud.aws.cloudtrail
where eventName in ('StopLogging', 'DeleteTrail', 'UpdateTrail', 'DeleteFlowLogs')
select eventTime, userIdentity.arn, eventName, requestParameters.name, sourceIPAddress
```
**Investigation Steps:**
* Immediately isolate the IAM entity performing this action.
* Check for preceding actions by this user to see what they were attempting to hide.

## 4. Console Logins Without MFA
**Use Case:** Enforcing Multi-Factor Authentication (MFA) is a baseline security control. This query audits console logins where MFA was not utilized, which violates Zero Trust architecture principles.

```linq
from cloud.aws.cloudtrail
where eventName = 'ConsoleLogin' 
  and responseElements.ConsoleLogin = 'Success'
  and additionalEventData.MFAUsed != 'Yes'
select eventTime, userIdentity.userName, sourceIPAddress, userAgent
```
**Investigation Steps:**
* Review IAM policies applied to the offending user to ensure the `aws:MultiFactorAuthPresent` condition key is enforced.
* Trigger an automated alert to force the user to enroll in MFA.

## 5. Potential Privilege Escalation (IAM Policy Modifications)
**Use Case:** An attacker with limited permissions might attempt to attach an administrator policy to their own user account or a role they can assume.

```linq
from cloud.aws.cloudtrail
where eventSource = 'iam.amazonaws.com'
  and eventName in ('AttachUserPolicy', 'PutUserPolicy', 'AttachRolePolicy', 'PutRolePolicy', 'AttachGroupPolicy')
select eventTime, userIdentity.arn as Actor, eventName, requestParameters.policyArn as PolicyAttached, requestParameters.userName as TargetUser
```
**Investigation Steps:**
* Review the specific permissions within the attached policy (e.g., `AdministratorAccess`).
* Ensure the actor making the change is a recognized IAM administrator making an approved change via CI/CD or Terraform, rather than a manual console click.

## 6. Access Key Creation (Potential Backdoor)
**Use Case:** Creating a new access key is a common persistence mechanism. If an attacker gains temporary console access, they may generate long-lived API keys to maintain access.

```linq
from cloud.aws.cloudtrail
where eventName = 'CreateAccessKey'
select eventTime, userIdentity.arn as Creator, requestParameters.userName as TargetUser, sourceIPAddress
```
**Investigation Steps:**
* Verify if the key creation aligns with a developer request or automated rotation schedule.
* Check if the `Creator` and the `TargetUser` are different entities, which is highly suspicious.

## 7. Disabling MFA Devices
**Use Case:** To maintain easier access or bypass conditional access policies, an attacker might remove a virtual MFA device from a compromised IAM user.

```linq
from cloud.aws.cloudtrail
where eventName in ('DeactivateMFADevice', 'DeleteVirtualMFADevice')
select eventTime, userIdentity.arn, requestParameters.serialNumber, sourceIPAddress
```
**Investigation Steps:**
* Reach out to the user out-of-band to confirm if they lost their device and requested a reset.
* Suspend the IAM user temporarily if the request is unverified.

## 8. AssumeRole Across Accounts (Cross-Account Lateral Movement)
**Use Case:** The `sts:AssumeRole` API is used heavily in AWS, but tracking cross-account assumptions is vital for detecting lateral movement from a compromised sub-account to a production or billing account.

```linq
from cloud.aws.cloudtrail
where eventName = 'AssumeRole'
  and userIdentity.accountId != requestParameters.roleArn.split(':')[4]
select eventTime, userIdentity.arn as SourceEntity, requestParameters.roleArn as TargetRole, sourceIPAddress
```
**Investigation Steps:**
* Validate against known cross-account trust architectures.
* Look for an attacker chaining multiple `AssumeRole` calls in rapid succession (Role Chaining).

## 9. Security Group Modifications (Exposing Ports)
**Use Case:** An attacker or careless developer might open highly sensitive ports (e.g., SSH 22, RDP 3389, Database 3306) to the entire internet (`0.0.0.0/0`).

```linq
from cloud.aws.cloudtrail
where eventName in ('AuthorizeSecurityGroupIngress', 'RevokeSecurityGroupEgress')
  and requestParameters.ipPermissions.items[].ipRanges.items[].cidrIp = '0.0.0.0/0'
select eventTime, userIdentity.arn, requestParameters.groupId, sourceIPAddress
```
**Investigation Steps:**
* Isolate the affected EC2 instances.
* Revert the Security Group rule to its previous state immediately.

## 10. Failed Console Login Brute Force
**Use Case:** Multiple failed console logins from the same IP address or targeting the same user account indicate a brute force or credential stuffing attack.

```linq
from cloud.aws.cloudtrail
where eventName = 'ConsoleLogin' 
  and errorMessage = 'Failed authentication'
group by userIdentity.userName, sourceIPAddress
every 15m
select count() as failure_count
where failure_count > 5
```
**Investigation Steps:**
* If the `failure_count` is high, block the `sourceIPAddress` at your WAF/Perimeter.
* Check if a successful login immediately follows the failures from the same IP.

## 11. Unapproved Usage of ec2:PassRole
**Use Case:** `iam:PassRole` allows a user to assign an IAM role to an AWS resource (like an EC2 instance). An attacker can use this to assign a highly privileged role to an instance they control, then log into that instance to extract the credentials.

```linq
from cloud.aws.cloudtrail
where eventName = 'RunInstances' or eventName = 'PassRole'
  and requestParameters.iamInstanceProfile.arn is not null
select eventTime, userIdentity.arn as Actor, requestParameters.iamInstanceProfile.arn as RolePassed, sourceIPAddress
```
**Investigation Steps:**
* Audit the permissions of the `RolePassed`. Does it have excessive access (e.g., full S3 read access)?
* Verify the `Actor` is authorized to launch instances with this specific profile.

## 12. Modifying S3 Bucket Public Access Block
**Use Case:** AWS now blocks public S3 access by default. Deleting or modifying the Public Access Block on a bucket is the primary precursor to a massive data breach.

```linq
from cloud.aws.cloudtrail
where eventName in ('DeleteBucketPublicAccessBlock', 'PutBucketPublicAccessBlock')
select eventTime, userIdentity.arn, requestParameters.bucketName, sourceIPAddress
```
**Investigation Steps:**
* Review the `bucketName` to see if it holds PII, financial, or proprietary data.
* Run a secondary query to check for `GetObject` events on that bucket originating from unknown IPs immediately following this event.

## 13. High-Volume API Calls from a Single IP (Anomalous Activity)
**Use Case:** Identifying automated enumeration scripts (like Pacu, ScoutSuite, or custom botnets) scraping the AWS environment.

```linq
from cloud.aws.cloudtrail
group by sourceIPAddress, userIdentity.arn
every 10m
select count() as total_api_calls
where total_api_calls > 1000
```
**Investigation Steps:**
* Compare the volume to the historical baseline for that `userIdentity.arn`.
* If the identity is a human user, this is highly suspicious. If it is a service account, verify if a new cron job or lambda was deployed.

## 14. Changes to Network ACLs or Route Tables
**Use Case:** Network infrastructure changes can be used to route traffic to malicious infrastructure or expose internal subnets.

```linq
from cloud.aws.cloudtrail
where eventName in ('CreateNetworkAclEntry', 'ReplaceNetworkAclEntry', 'CreateRoute', 'ReplaceRoute')
select eventTime, userIdentity.arn, requestParameters.networkAclId, requestParameters.routeTableId, requestParameters.cidrBlock
```
**Investigation Steps:**
* Check if the destination CIDR block points to an unapproved VPC peering connection, Internet Gateway, or malicious external IP.

## 15. AWS Secrets Manager Extraction
**Use Case:** An attacker who breaches the perimeter will often look for stored credentials, API keys, and database passwords in AWS Secrets Manager or Systems Manager Parameter Store.

```linq
from cloud.aws.cloudtrail
where eventSource in ('secretsmanager.amazonaws.com', 'ssm.amazonaws.com')
  and eventName in ('GetSecretValue', 'GetParameter', 'GetParameters')
group by userIdentity.arn, sourceIPAddress
every 1h
select count() as secrets_accessed
where secrets_accessed > 20
```
**Investigation Steps:**
* Determine if the IAM role accessing these secrets belongs to the application that genuinely needs them.
* A sudden spike from an administrative user (who normally configures, but doesn't read secrets in bulk) is a critical indicator of compromise.

---
*Generated for Threat Hunting and Security Operations Optimization.*
