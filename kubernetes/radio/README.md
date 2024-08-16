## Icecast2 Radio

### Docs

- https://icecast.org/
- https://icecast.org/ezstream/
- https://hub.docker.com/r/pltnk/icecast2

### Installation

```bash
docker-compose build ezstream
docker push <domain>/ezstream

helm upgrade --install -n radio-app radio-app ./charts
```
