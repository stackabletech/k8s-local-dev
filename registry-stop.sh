#!/usr/bin/env -S bash -euo pipefail
cd "$(dirname "$0")" || exit

echo "Stopping Zot Registry Cache..."
docker-compose down
echo "Zot Registry Cache stopped!"
