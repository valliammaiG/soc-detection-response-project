# SOC Detection & Response Project

A working set of SIEM correlation rules, incident-investigation reports, and a
dashboard design, built from analysis of a simulated multi-stage intrusion
(an invoice-phishing malware infection with follow-on Active Directory
reconnaissance and a separate SSH brute-force/persistence scenario).

**Live preview:** see `index.html` (deployed via GitHub Pages — link in repo "About" section)

## Structure

```
├── detection-rules/     # Sigma & YARA rules, ready to load into a SIEM/YARA scanner
│   ├── credential_stuffing.yml
│   ├── dns_tunnelling.yml
│   ├── powershell_exploitation.yml
│   ├── scheduled_task_persistence.yml
│   └── suspicious_packed_dropper.yar
├── reports/              # Incident investigation write-ups
│   ├── hawkeye-red-blue-purple.md
│   ├── apt-simulation-report.md
│   ├── cyberdefenders-hawkeye-investigation.md
│   └── brutus-sherlock-findings.md
├── dashboards/
│   └── soc-dashboard-spec.md
└── index.html            # Live dashboard preview
```

## What this project covers
- **Detection engineering** — custom Sigma rules for credential stuffing, DNS
  tunnelling, PowerShell abuse, and scheduled-task persistence, each with
  documented detection logic and false-positive considerations.
- **Malware analysis** — a YARA rule for a packed dropper identified during
  PCAP investigation.
- **Incident response** — full investigation reports reconstructing attack
  chains from network captures and Unix auth logs, mapped to MITRE ATT&CK.
- **SOC tooling** — a dashboard design spec for visualizing brute-force,
  privilege-escalation, and exfiltration activity in Kibana/ELK.

## Author
Valliammai G — B.Tech Computer Science & Engineering (Cybersecurity), SRM
Institute of Science and Technology · Fortinet Certified Associate (FCA)
