#!/bin/bash
cd "$(dirname "$0")" || exit
echo "Showing Zot Registry Cache logs..."
docker-compose logs -f zot-cache
