#!/bin/bash

cd "$(dirname "$0")" || exit

echo "Cleaning up Zot Registry Cache..."
echo "This will remove containers, networks, volumes, and cached images."
read -p "Are you sure? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Stopping and removing everything..."
    docker-compose down -v --rmi local
    echo "Cleanup complete!"
    echo "All cached registry data has been removed."
else
    echo "Cleanup cancelled."
fi
