Gathering evidence that a problem occurred, its duration, and its frequency is foundational for root cause analysis. Post-incident reviews rely heavily on mapping redundancy, failover paths, and RPO/RTO annotations to properly harden the environment against future disruptions.

For visual mapping and context, please refer to the "Architecture Diagrams" file.

### Table 1 - Microsoft (Azure / M365)

| Evidence Domain | Source Service | RCA Evidence Required (What to Collect) | Hardening Application (Actionable Outcome) |
| :--- | :--- | :--- | :--- |
| **Control Plane & Identity** | Microsoft Entra ID / Azure Activity Logs | UTC timestamps of configuration changes, privileged role assignments, and authentication failures. | Restrict privileges and enforce phishing-resistant MFA policies to secure administrative access. |
| **Compute & Infrastructure** | Azure Monitor / VM Diagnostics | CPU/Memory exhaustion patterns, auto-scaling thresholds, and server crash logs. | Adjust scale-out rules, deploy across Availability Zones, and optimize resource limits. |
| **Network & Perimeter** | NSG Flow Logs / Azure Firewall | Dropped packet rates, unexpected traffic spikes, and BGP route alterations. | Refine Network Security Groups (NSGs) and strictly isolate failover Virtual Networks. |
| **Data & Disaster Recovery** | Azure Backup / Site Recovery | Backup job failures, Cross-Region Replication (CRR) sync lag, and actual RPO/RTO metrics. | Validate redundancy architectures, failover paths, and RPO/RTO alignment. |
| **Security & Threat Intel** | Microsoft Sentinel / Defender | Lateral movement alerts, unauthorized data access, and ransomware behaviors pre-incident. | Automate incident response playbooks and enforce strict Zero Trust network boundaries. |

### Table 2 - AWS

| Evidence Domain | Source Service | RCA Evidence Required (What to Collect) | Hardening Application (Actionable Outcome) |
| :--- | :--- | :--- | :--- |
| **Control Plane & Identity** | AWS CloudTrail / IAM | API call histories, `AssumeRole` events, and the source IPs of infrastructure modifications. | Implement stricter Service Control Policies (SCPs) and refine IAM least privilege. |
| **Compute & Infrastructure** | Amazon CloudWatch | System status checks, instance termination reasons, and historical load frequency. | Deploy instances across multiple Availability Zones and tune Auto Scaling target tracking. |
| **Network & Perimeter** | VPC Flow Logs / Route 53 | Denied ingress/egress patterns, ALB 5xx/4xx error rates, and DNS failover latency. | Tighten Security Group inbound rules and leverage AWS Shield Advanced for DDoS resilience. |
| **Data & Backups** | AWS Backup / S3 Access Logs | RPO compliance drift, deleted objects, and cross-region replication delays. | Enable S3 Object Lock (immutability) and implement encrypted, cross-account backup vaults. |
| **Log Ingestion & Analysis** | Amazon OpenSearch Service | Aggregated application logs, server telemetry, and centralized crash evidence. | Centralize search and analysis capabilities to rapidly extract insights and diagnose underlying issues. |
