# Kubernetes Local Testing Environment

This repo contains a bunch of scripts to bring up a local Kubernetes environment (using [k3d](https://k3d.io/), which itself is a wrapper to bring up [k3s](https://k3s.io/) clusters) and a [Zot](https://zotregistry.dev/) image registry serving as a transparent pull-through cache.

## Prerequisites

* You need to have [k3d](https://k3d.io)
* You need to have Docker Compose

## Quick Start

> [!NOTE]
> These scripts can be invoked from any directory.
> Take note of the k3d config path emitted from the start script.

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

## Push local images

zot only supports OCI manifests and they are incompatible with what a `docker build` produces by default.

You'll need to use a tool like [skopeo](https://github.com/containers/skopeo) to copy the images to zot.
                            
This will copy an image from your local docker daemon to the zot registry
```
 skopeo --insecure-policy copy --dest-tls-verify=false --format=oci docker-daemon:oci.stackable.tech/sdp/nifi:2.4.0-stackable0.0.0-dev docker://localhost:5000/sdp/nifi:2.4.0-stackable0.0.0-dev
 ```

You can then reference those images using the `host.k3d.internal` URL:

```
host.k3d.internal:5000/sdp/nifi:2.4.0-stackable0.0.0-dev
```

## Help

### Pods don't come up

If none of the pods come up (eg: coredns), it is likely that the firewall is
preventing taffic from the k3s node to the docker network (so the kubelet cannot
pull via the mirror).

Example error event on the Pod:

```
failed to do request: Head "https://host.k3d.internal:5000/v2/mirror/docker-io/rancher/mirrored-pause/manifests/3.6?ns=docker.io": dial tcp 172.21.0.1:5000: i/o timeout
```

You might need to manage firewall rules yourself, but this could be a good
starting point (the IP comes from the error above):

```shell
sudo iptables -I INPUT -p tcp -d 172.21.0.1 --dport 5000 -j ACCEPT
```

### ImagePullBackOff

One reason for this could be that you hibernated or restarted your computer.
Sometimes the internal DNS resolution in k3d doesn't work afterwards and can't find the registry anymore.
In that case the only solution I found so far is to create a new cluster but there _might_ be other ways.
