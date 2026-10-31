#!/usr/bin/env bash
# Loads all cypher/*.cypher files, in numeric order, into the running Neo4j container.
set -euo pipefail
cd "$(dirname "$0")/.."
source .env

for f in cypher/*.cypher; do
  echo "Loading $f ..."
  docker exec -i landlawsug-neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < "$f"
done
echo "Done."
