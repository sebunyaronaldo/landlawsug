# Loads all cypher/*.cypher files, in numeric order, into the running Neo4j container.
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

$password = (Get-Content .env | Where-Object { $_ -match '^NEO4J_PASSWORD=' }) -replace '^NEO4J_PASSWORD=', ''

Get-ChildItem cypher\*.cypher | Sort-Object Name | ForEach-Object {
    Write-Host "Loading $($_.Name) ..."
    Get-Content $_.FullName -Raw | docker exec -i landlawsug-neo4j cypher-shell -u neo4j -p $password
    if ($LASTEXITCODE -ne 0) { throw "Failed loading $($_.Name)" }
}
Write-Host 'Done.'
