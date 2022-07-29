#!/usr/bin/env pwsh

Param(
    [string]  [Parameter(Mandatory=$true)] $Environment,
    [string]  [Parameter(Mandatory=$false)] $ConnectionString,
    [string]  [Parameter(Mandatory=$false)] $Version
)

$Root = Resolve-Path "$($PSScriptRoot)\.."; 
$DbScriptsRoot = Join-Path $Root "db"

If ("$($DatabaseName)" -eq "") {
    $DatabaseName = (Get-ChildItem "$($DbScriptsRoot)" | Select-Object -ExpandProperty Name)
}

If ("$($ConnectionString)" -eq "") {
    Write-Error "ConnectionString must be set."
    Exit 1;
}

$Outdir="$($env:OutDir)"

If ("$($OutDir)" -eq "") {
    $OutDir = Join-Path $Root "logs"
}

# Create output directory if it does not exist
If (! (Test-Path "$($OutDir)")) {
    $null = New-Item -Path "$($OutDir)" -ItemType "directory"
}

$SqlFilesDirectory= Join-Path $DbScriptsRoot $DatabaseName;

$dontCreate=("$Environment" -ne "LOCAL") ? "-dnc " : ""

dotnet tool run grate -- --silent --output "$($OutDir)" $dontCreate --files "$($SqlFilesDirectory)" --connectionstring "$($ConnectionString)" --version="$($Version)" --environment="$($Environment)"
