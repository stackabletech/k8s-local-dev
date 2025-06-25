#!/usr/bin/env -S bash -euo pipefail
cd "$(dirname "$0")" || exit
echo "Showing Zot Registry Cache logs..."
docker-compose logs -f zot-cache
