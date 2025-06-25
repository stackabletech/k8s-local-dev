#!/usr/bin/env -S bash -euo pipefail

# Run from the directory that the script is in
pushd "$(dirname "$0")"

echo "Showing Zot Registry Cache logs..."
docker-compose logs -f zot-cache
