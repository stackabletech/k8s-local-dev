#!/usr/bin/env -S bash -euo pipefail

# Run from the directory that the script is in
pushd "$(dirname "$0")" > /dev/null

echo "Cleaning up Zot Registry Cache..."
echo "This will remove containers, networks, volumes, and cached images."
read -p "Are you sure? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Stopping and removing everything..."
    docker compose down -v --rmi local
    echo "Cleanup complete!"
    echo "All cached registry data has been removed."
else
    echo "Cleanup cancelled."
fi
