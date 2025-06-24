# Kubernetes Local Testing Environment

This repo contains a bunch of scripts to bring up a local Kubernetes environment (using [k3d](https://k3d.io/), which itself is a wrapper to bring up [k3s](https://k3s.io/) clusters) and a [Zot](https://zotregistry.dev/) image registry serving as a transparent pull-through cache.
              
## Prerequisites

* You need to have [k3d](https://k3d.io)
* You need to have Docker Compose

## Quick Start

1. Start the Zot registry:
   ```bash
   ./registry-start.sh
   ```

2. Create the k3d cluster:
   ```bash
   # k3d cluster create --config k3d-config.yaml [NAME]
   k3d cluster create --config k3d-config.yaml test-cluster
   ```

## Registry Cache

The Zot registry caches images from:
- Docker Hub (`docker.io`) → `/mirror/docker-io`
- Stackable registry (`oci.stackable.tech`) → `/mirror/stackable`

Features:
- On-demand image synchronization
- Garbage collection (24h intervals): It should clean up any mirrored images that have not been pulled in 30 days
- Web UI available at http://localhost:5000
- Prometheus metrics at http://localhost:5000/metrics

## K3d/K3s

k3s is configured in a way that it will _not_ fall back to any default repository if it can't reach zot.

- **LoadBalancer HTTP**: http://localhost:8080
- **LoadBalancer HTTPS**: https://localhost:8443

## Testing

Test the setup with sample deployments:
```bash
kubectl run nginx-test --image=nginx:alpine
kubectl run redis-test --image=redis:alpine
```

These images should now appear in the Zot Web UI.

## Management Scripts

- `registry-start.sh`: Start registry services
- `registry-stop.sh`: Stop registry services  
- `registry-logs.sh`: View (tail) registry logs
- `registry-cleanup.sh`: Clean up registry data (including the volume with the mirrored images)

## TODO

Document how to push images.
Using `docker push` returns `manifest invalid` because Zot does not support docker manifests.
See: https://github.com/project-zot/zot/issues/2234
