#!/usr/bin/env -S bash -euo pipefail

# Run from the directory that the script is in
SCRIPT_DIR="$(dirname "$0")"
pushd "$SCRIPT_DIR" > /dev/null

echo "Starting Zot Registry Cache..."
docker compose up -d

cat <<EOF
Zot Registry Cache started!
Registry UI:  http://localhost:5000
Health check: http://localhost:5000/v2/_catalog
Metrics:      http://localhost:5000/metrics


To use with k3d clusters, run:
k3d cluster create --config "$SCRIPT_DIR/k3d-config.yaml" [cluster-name]
EOF
