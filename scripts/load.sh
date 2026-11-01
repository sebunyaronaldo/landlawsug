#!/usr/bin/env bash
# Loads all cypher/*.cypher files, in numeric order, into the running Neo4j container.
# Neo4j reads each file directly from the cypher/ folder, which docker-compose.yml mounts
# into the container at /import/cypher.
set -euo pipefail
cd "$(dirname "$0")/.."
source .env

# Stop Git Bash on Windows from rewriting /import/... into a Windows path.
export MSYS_NO_PATHCONV=1

for f in cypher/*.cypher; do
  name="$(basename "$f")"
  echo "Loading $name ..."
  docker exec landlawsug-neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" -f "/import/cypher/$name"
done
echo "Done."
