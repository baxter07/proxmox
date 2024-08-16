## Linkerd

### Docs

- https://linkerd.io/
- https://linkerd.io/2.15/tasks/install-helm/
- https://artifacthub.io/packages/helm/linkerd2/linkerd-viz
- https://artifacthub.io/packages/helm/linkerd2/linkerd-jaeger
- https://linkerd.io/2.15/tasks/grafana/
- https://linkerd.io/2.15/tasks/exposing-dashboard/

### Installation

```bash
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install-edge | sh
export PATH=$HOME/.linkerd2/bin:$PATH
linkerd version

# Generate mTLS certificates with step-cli before installing control plane
helm repo add linkerd-edge https://helm.linkerd.io/edge

helm install linkerd-crds linkerd/linkerd-crds -n linkerd --create-namespace
helm install linkerd-control-plane -n linkerd \
  --set-file identityTrustAnchorsPEM=$HOME/.linkerd2/ca.crt \
  --set-file identity.issuer.tls.crtPEM=$HOME/.linkerd2/issuer.crt \
  --set-file identity.issuer.tls.keyPEM=$HOME/.linkerd2/issuer.key \
  linkerd/linkerd-control-plane

helm install linkerd-viz -n linkerd-viz --create-namespace linkerd/linkerd-viz

# Upgrade linkerd installation
helm upgrade -n linkerd linkerd-crds linkerd/linkerd-crds
helm upgrade -n linkerd linkerd-control-plane linkerd/linkerd-control-plane --reset-values -f values.yaml --atomic
```

### Smallstep

- https://smallstep.com/docs/step-cli/
- https://linkerd.io/2.15/tasks/generate-certificates/

#### Installation

```bash
# Installation Arch
pacman -S step-cli
# Installation Ubuntu
wget https://dl.smallstep.com/cli/docs-cli-install/latest/step-cli_amd64.deb
sudo dpkg -i step-cli_amd64.deb
# Uninstall
sudo dpkg -r step-cli
rm -r $HOME/.step
```

#### Generate mTLS certificates

```bash
# Path to store certificate files
cd ~/.linkerd2

# Generate root certificate valid for 10 years
step certificate create root.linkerd.cluster.local ca.crt ca.key \
  --profile root-ca --no-password --insecure --not-after=87600h

# Generate intermediate certificate that will be used to sign the Linkerd proxies’ CSR
step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
  --profile intermediate-ca --no-password --insecure --ca ca.crt --ca-key ca.key
```
