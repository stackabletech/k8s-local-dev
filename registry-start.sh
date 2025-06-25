#!/usr/bin/env -S bash -euo pipefail

# Run from the directory that the script is in
pushd "$(dirname "$0")"

echo "Starting Zot Registry Cache..."
docker-compose up -d

echo "Zot Registry Cache started!"
echo "Registry UI:  http://localhost:5000"
echo "Health check: http://localhost:5000/v2/_catalog"
echo "Metrics:      http://localhost:5000/metrics"
echo ""
echo ""
echo "To use with k3d clusters, run:"
echo "k3d cluster create --config k3d-config.yaml [cluster-name]"
