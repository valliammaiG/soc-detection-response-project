# CyberDefenders HawkEye Lab — Investigation Findings

**Compromised host:** `Beijing-5cd1-PC` (10.4.10.132) on domain `pizzajukebox.com`

## Timeline

| Time (s into capture) | Event |
|---|---|
| ~46-47s | DNS resolves `proforma-invoices.com` → `217.182.138.150`; HTTP GET `/proforma/tkraw_Protected99.exe` begins |
| ~68s onward, every ~604s | Recurring beacon: query to `bot.whatismyipaddress.com`, immediately followed by `macwinlogistics.in` |
| Throughout | Benign noise: `dns.msftncsi.com`, `update.googleapis.com`, `isatap.localdomain`, SSDP M-SEARCH — none part of the incident |

## Key Findings
- **Initial vector:** invoice-phishing lure delivering a packed payload (`tkraw_Protected99.exe`), consistent with the HawkEye malware family.
- **C2 beaconing:** `macwinlogistics.in` (`23.229.162.69`) is the actual C2 domain, disguised behind a plausible logistics-company name. The precise ~604-second interval (confirmed across 7+ cycles) is the clearest signal of automated malware behavior.
- **IP self-discovery:** `bot.whatismyipaddress.com` (`66.171.248.178`) abused by the malware to learn the victim's real egress IP ahead of each C2 check-in.

## IOC Table

| Type | Value | Role |
|---|---|---|
| Domain | proforma-invoices.com | Initial phishing lure / payload host |
| IP | 217.182.138.150 | Hosted malicious payload |
| File | tkraw_Protected99.exe | HawkEye-family dropper |
| Domain | macwinlogistics.in | C2 / beacon domain |
| IP | 23.229.162.69 | C2 infrastructure |
| Domain | bot.whatismyipaddress.com | Abused IP-lookup service |
| Hostname | Beijing-5cd1-PC | Compromised endpoint |
| Behavioral | ~604s beacon interval | C2 check-in cadence |

## Recommendations
- Isolate and reimage `Beijing-5cd1-PC`.
- Block both malicious domains/IPs at DNS and firewall/proxy layers.
- Add a general-purpose fixed-interval-beacon detection rule — high value, low false-positive risk.
