# Loads all cypher/*.cypher files, in numeric order, into the running Neo4j container.
# Neo4j reads each file directly from the cypher/ folder, which docker-compose.yml mounts
# into the container at /import/cypher. (Piping file contents from Windows PowerShell adds
# an invisible byte-order mark that Neo4j rejects.)
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

$password = (Get-Content .env | Where-Object { $_ -match '^NEO4J_PASSWORD=' }) -replace '^NEO4J_PASSWORD=', ''

Get-ChildItem cypher\*.cypher | Sort-Object Name | ForEach-Object {
    Write-Host "Loading $($_.Name) ..."
    docker exec landlawsug-neo4j cypher-shell -u neo4j -p $password -f "/import/cypher/$($_.Name)"
    if ($LASTEXITCODE -ne 0) { throw "Failed loading $($_.Name)" }
}
Write-Host 'Done.'
