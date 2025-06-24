#!/bin/bash
cd "$(dirname "$0")" || exit

echo "Stopping Zot Registry Cache..."
docker-compose down
echo "Zot Registry Cache stopped!"
