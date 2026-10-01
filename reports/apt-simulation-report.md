# Multi-Stage APT Attack Simulation & Response

Full lifecycle simulation across three phases using open-source SOC tooling.

## Phase 1 — Attack Simulation (Red Team)
1. Initial access via phishing / unpatched vulnerability exploitation.
2. Persistence via scheduled task executing a PowerShell loader at logon.
3. Lateral movement via PsExec with harvested local-admin credentials; validated Pass-the-Hash with captured NTLM hashes.
4. Exfiltration via covert DNS tunnelling (primary) and encrypted HTTPS POST (secondary).

| Stage | Technique | ID |
|---|---|---|
| Persistence | Scheduled Task/Job | T1053.005 |
| Lateral Movement | Remote Services: SMB/PsExec | T1021.002 |
| Lateral Movement | Pass the Hash | T1550.002 |
| Exfiltration | Exfil Over C2 Channel: DNS | T1048.001 |

## Phase 2 — Detection & Investigation (Blue Team)
- Security Onion + Wazuh alerts on scheduled-task creation and PsExec/SMB traffic.
- Kibana correlation of scheduled-task creation → PowerShell process spawn.
- TheHive + Cortex analyzers (VirusTotal, URLhaus) confirm malicious verdicts on drop-server IP and lure URL.

**Forensic Timeline:**

| T+ | Event |
|---|---|
| 0:00 | Phishing email opened, macro executed |
| 0:45 | Initial payload dropped and executed |
| 2:10 | Scheduled task created for persistence |
| 14:30 | PsExec lateral movement to second host |
| 22:05 | DNS tunnelling exfiltration begins |

## Phase 3 — Threat Intelligence & Mitigation
- IOCs (drop-server IP, phishing domain, file hashes) packaged into a MISP event.
- Detection rules: see [`suspicious_packed_dropper.yar`](../detection-rules/suspicious_packed_dropper.yar) and [`scheduled_task_persistence.yml`](../detection-rules/scheduled_task_persistence.yml).
- Mitigation: block drop-server IP/domain, disable Office macros from internet-sourced files, restrict PsExec/SMB admin-share use to a monitored jump host.

## Security Gaps & Remediation Roadmap

| Gap | Remediation |
|---|---|
| Macro execution allowed from internet documents | Enforce ASR rule blocking Office macros from the internet |
| Flat network permissions enabled PsExec lateral movement | Segment admin-share access to a monitored jump host |
| DNS egress unmonitored | Deploy DNS-tunnelling detection (see `dns_tunnelling.yml`) |
| No centralized IOC sharing | Formalize MISP integration into SOC workflow |
