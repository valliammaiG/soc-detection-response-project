# Custom SIEM Dashboard — Design Spec

Visualizes brute-force, privilege-escalation, and exfiltration events (Kibana / ELK or Security Onion).

## Layout
**Row 1 — Summary metric cards**

| Metric | Query | Refresh |
|---|---|---|
| Brute-force attempts (24h) | `event.code:4625 OR event.code:4771`, count over 24h | 1 min |
| Privilege-escalation alerts | `event.code:4672 OR sigma_rule:priv_esc_*`, count over 24h | 1 min |
| Exfiltration indicators | `network.bytes_out > threshold OR dns_tunnelling_rule fired`, count over 24h | 5 min |
| Hosts affected | `cardinality(host.name)` where any rule above fired | 5 min |

**Row 2 — Visualization panels**

| Panel | Type | Query |
|---|---|---|
| Failed logons by source IP (top 5) | Horizontal bar | Terms agg on `source.ip`, filter `event.code:4625`, order desc, size 5 |
| Recent alerts | Data table / alert feed | Kibana Security > Alerts, sorted by severity then recency |

## Build Instructions (Kibana)
1. Metric cards: Visualization type `Metric`, one per card, 24h rolling time range, scoped with the KQL filters above.
2. Bar chart: `Horizontal Bar`, bucket = Terms on `source.ip.keyword`, metric = Count, order desc, size 5.
3. Alerts panel: native Kibana Security > Alerts table, or a Lens table sorted by `@timestamp` desc + `rule.severity`.
4. Apply a dashboard-level time filter (default: last 24h) so all panels stay synchronized.

## Rules Powering This Dashboard
See [`/detection-rules`](../detection-rules) — `credential_stuffing.yml`, `dns_tunnelling.yml`,
and `powershell_exploitation.yml` feed the panels above directly.

A working mockup of this layout (summary cards + ranked bar chart + live alerts panel) is
included as the project's live preview page — see `index.html` at the project root.
