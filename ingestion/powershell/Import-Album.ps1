[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$Path,

    [string]$OutputManifest = "album-manifest.generated.json"
)

$ErrorActionPreference = "Stop"

$resolvedPath = (Resolve-Path $Path).Path
$audioFiles = Get-ChildItem -Path $resolvedPath -File | Where-Object {
    $_.Extension.ToLowerInvariant() -in @('.flac', '.wav', '.mp3', '.m4a', '.aac', '.opus')
} | Sort-Object Name

if (-not $audioFiles) {
    throw "No supported audio files were found in $resolvedPath"
}

$tracks = foreach ($file in $audioFiles) {
    $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
    [ordered]@{
        fileName    = $file.Name
        title       = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        trackNumber = [array]::IndexOf($audioFiles, $file) + 1
        discNumber  = 1
        sha256      = $hash.Hash.ToLowerInvariant()
        sizeBytes   = $file.Length
    }
}

$manifest = [ordered]@{
    artist = "REPLACE_ME"
    album  = (Split-Path $resolvedPath -Leaf)
    year   = $null
    genre  = @()
    tracks = $tracks
}

$outputPath = Join-Path $resolvedPath $OutputManifest
$json = $manifest | ConvertTo-Json -Depth 8

if ($PSCmdlet.ShouldProcess($outputPath, "Write album import manifest")) {
    Set-Content -Path $outputPath -Value $json -Encoding UTF8
    Write-Host "Manifest written to $outputPath"
    Write-Host "Review artist/title/track metadata before any future cloud upload step."
}
