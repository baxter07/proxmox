## Monitoring Prometheus & Grafana

### Dashboards

**Kubernetes**

- https://grafana.com/grafana/dashboards/18283-kubernetes-dashboard/
- https://grafana.com/grafana/dashboards/12006-kubernetes-apiserver/
- https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/
- https://grafana.com/grafana/dashboards/8171-kubernetes-nodes/
- https://grafana.com/grafana/dashboards/747-pod-metrics/

- https://grafana.com/grafana/dashboards/741-deployment-metrics/
- https://grafana.com/grafana/dashboards/1471-kubernetes-apps/
- https://grafana.com/grafana/dashboards/13332-kube-state-metrics-v2/
- https://grafana.com/grafana/dashboards/315-kubernetes-cluster-monitoring-via-prometheus/
- https://grafana.com/grafana/dashboards/15661-1-k8s-for-prometheus-dashboard-20211010/
- https://grafana.com/grafana/dashboards/11454-k8s-storage-volumes-cluster/

**Proxmox**

- https://grafana.com/grafana/dashboards/10347-proxmox-via-prometheus/

### Install Prometheus & Grafana charts

```bash
helm upgrade -n monitoring prometheus prometheus-community/prometheus --reuse-values -f prometheus_values.yml

helm upgrade -n monitoring prometheus prometheus-community/prometheus --reuse-values \
  --set-file extraScrapeConfigs=prometheus_scrape_configs.yml

kubectl rollout restart -n monitoring deployment prometheus-server

helm upgrade -n monitoring grafana grafana/grafana --reuse-values -f grafana_values.yml

kubectl rollout restart -n monitoring deployment grafana
```

### Install PVE Exporter

- https://artifacthub.io/packages/helm/stenic/prometheus-pve-exporter

```bash
helm repo add stenic https://stenic.github.io/helm-charts

helm upgrade --install -n monitoring prometheus-pve-exporter stenic/prometheus-pve-exporter \
  --set pve.password=$(pass web/chirpse/secrets/pve-exporter-password) \
  -f proxmox_exporter_values.yml
```
