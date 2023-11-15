# Services
This will run the following services:
1. Grafana for dashboards, no authentication required. Port 3000
2. Loki to receive logs from grafana agent (Also act as data source for grafana)
3. Prometheus to receive metrics from grafana agent (Also act as data source for grafana)
4. Grafana agent - collect logs and metrics to send.