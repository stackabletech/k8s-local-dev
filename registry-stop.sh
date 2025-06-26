#!/usr/bin/env -S bash -euo pipefail

# Run from the directory that the script is in
pushd "$(dirname "$0")"

echo "Stopping Zot Registry Cache..."
docker compose down
echo "Zot Registry Cache stopped!"
