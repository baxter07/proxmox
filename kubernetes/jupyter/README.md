## JupyterHub

### Docs

- https://artifacthub.io/packages/helm/jupyterhub/jupyterhub
- https://z2jh.jupyter.org/en/latest/jupyterhub/installation.html
- https://github.com/jupyterhub/helm-chart

**GitLab OAuthenticator**

- https://oauthenticator.readthedocs.io/en/latest/tutorials/provider-specific-setup/providers/gitlab.html
- https://oauthenticator.readthedocs.io/en/latest/reference/api/gen/oauthenticator.gitlab.html

### Installation

```bash
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

helm install -n jupyter --create-namespace jupyterhub jupyterhub/jupyterhub --version 3.3.7 -f values.yml
helm upgrade --install -n jupyter jupyterhub jupyterhub/jupyterhub -f values.yml
```
