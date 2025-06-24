#!/bin/bash

cd "$(dirname "$0")" || exit
echo "Starting Zot Registry Cache..."
docker-compose up -d
echo "Zot Registry Cache started!"
echo "Registry API: http://localhost:5000"
echo "Health check: curl http://localhost:5000/v2/"
echo "Metrics: curl http://localhost:5000/metrics"
echo ""
echo "Creating k3d config file..."

cat > k3d-config.yaml << EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
servers: 1
agents: 0
ports:
  - port: 8080:80
    nodeFilters:
      - loadbalancer
  - port: 8443:443
    nodeFilters:
      - loadbalancer
registries:
  config: $(pwd)/k3d-registries.yaml
options:
  k3s:
    extraArgs:
      - arg: --disable-default-registry-endpoint
        nodeFilters:
          - all
EOF

echo "k3d config created: k3d-config.yaml"
echo ""
echo "To use with k3d clusters, run:"
echo "k3d cluster create --config k3d-config.yaml [cluster-name]"
