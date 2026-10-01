# HawkEye Lab — Red / Blue / Purple Team Report

**Environment:** Domain `pizzajukebox.com` | DC: `PizzaJukebox-DC` (10.4.10.4) | Victim host: `10.4.10.132` (Beijing-5cd1-PC)

## Summary
Network capture analysis revealed a full attack chain: an invoice-phishing lure
(`proforma-invoices.com` → `217.182.138.150`) delivered a packed executable
(`tkraw_Protected99.exe`) consistent with the HawkEye keylogger/infostealer
family, alongside Active Directory reconnaissance (DRSUAPI probing, SYSVOL
GPP hunting, and LDAP enumeration).

## Red Team — Attack Chain
1. **Initial Access** — Invoice-phishing lure domain resolved and payload retrieved over HTTP.
2. **Payload Delivery** — `tkraw_Protected99.exe` (~270KB) downloaded in plaintext from `217.182.138.150`.
3. **Discovery** — LDAP enumeration with malformed SASL packets, consistent with automated AD-collection tooling.
4. **Credential Access Preparation** — DRSUAPI EPM map request (DCSync precursor) and SYSVOL `gpt.ini` read (GPP password hunting).
5. **Lateral Movement Staging** — WPAD/NBNS broadcast queries, exploitable via Responder-style tooling.

| Tactic | Technique | ID |
|---|---|---|
| Initial Access | Phishing | T1566 |
| Execution | User Execution: Malicious File | T1204.002 |
| Discovery | Account Discovery | T1087.002 |
| Credential Access | OS Credential Dumping: DCSync | T1003.006 |
| Credential Access | Unsecured Credentials: GPP | T1552.006 |
| Credential Access | AiTM: LLMNR/NBT-NS | T1557.001 |

## Blue Team — Detection Opportunities
See [`/detection-rules`](../detection-rules) for the implemented Sigma rules covering
scheduled-task persistence and PowerShell abuse related to this campaign.

Key IOCs:
- Domain: `proforma-invoices.com` / IP: `217.182.138.150`
- Payload: `tkraw_Protected99.exe`

## Purple Team — Coverage Gaps & Recommendations
- **Highest-priority gap:** no evidence of DC-side auditing (Event 4662) for DRSUAPI calls — this is the single highest-fidelity detection opportunity in an AD environment.
- Enable LDAP query logging (Event 1644) to catch enumeration bursts.
- Disable NBT-NS/LLMNR organization-wide to remove the WPAD-spoofing surface.
- Remove any legacy GPP `cpassword` entries from SYSVOL.
