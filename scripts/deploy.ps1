[CmdletBinding()]
param(
    [ValidateSet('dev','prod')]
    [string]$Environment = 'dev'
)

$ErrorActionPreference = 'Stop'
$envPath = Join-Path $PSScriptRoot "../infrastructure/environments/$Environment"
$envPath = [System.IO.Path]::GetFullPath($envPath)

if (-not (Test-Path $envPath)) {
    throw "Environment directory not found: $envPath"
}

$tfFiles = Get-ChildItem -Path $envPath -Filter '*.tf' -File -ErrorAction SilentlyContinue
if (-not $tfFiles) {
    Write-Host "No Terraform implementation exists yet for '$Environment'."
    Write-Host "Complete WP-01 before deployment."
    exit 0
}

Push-Location $envPath
try {
    terraform init
    terraform fmt -check
    terraform validate
    terraform plan
}
finally {
    Pop-Location
}
