## Kubernetes

### Docs

- https://kubernetes.io/docs/
- https://github.com/kubernetes-sigs/descheduler
- https://linkerd.io/

### Cheat Sheet

```bash
# Display resources filtered by label
kubectl get all -l app=nginx

# Temporarily deploy debug pod
kubectl run -n <namespace> -it --rm debug --image ubuntu-debug -- bash

# Enter pod shell
kubectl exec -n <namespace> -it <pod_name> -- bash

# Create service account token
kubectl create token <name>

# Retrieve service account token
kubectl get secret <name> -o jsonpath={".data.token"} | base64 -d

# Copy a secret between namespaces
kubectl get secret <name> -n=<namespace> -oyaml | grep -v '^\s*namespace:\s' |
	kubectl apply -n=<namespace> -f -

# Remove all unused images
sudo crictl rmi --prune
```

## Helm

### Docs

- https://helm.sh/docs/
- https://artifacthub.io/

### Install Chart

```bash
helm upgrade --install <release_name> <charts_dir>/

helm install -n <namespace> <release_name> <repo_name>/<chart> --version <chart_version> -f values.yml

helm upgrade -n <namespace> <release_name> <repo_name>/<chart> -f values.yml

helm uninstall -n <namespace> <release_name>
```

### Cheat Sheet

```bash
# List repositories
helm repo list

# List all releases
helm list -A

# Show definition, crds, readme and values of a chart
helm show all <repo>/<chart>

# Show rendered chart templates
helm get -n <namespace> manifest <release>

# Show chart values
helm get -n <namespace> values <release>

# Render chart templates locally
helm template chart-example-app/
```