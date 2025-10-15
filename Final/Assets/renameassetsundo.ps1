# rename_assets_undo.ps1
# Reverts the moves performed by rename_assets.ps1 using assets_rename_map.csv.
# Run this from the project root to move files back out of Assets/ to the root.

$root = Get-Location
$assetsDir = Join-Path $root 'Assets'
$mapFile = Join-Path $root 'assets_rename_map.csv'

if (-not (Test-Path $mapFile)) {
    Write-Error "assets_rename_map.csv not found. Cannot undo."
    exit 1
}

Import-Csv -Path $mapFile | ForEach-Object {
    $orig = $_.original
    $new = $_.new
    $src = Join-Path $assetsDir $new
    $dest = Join-Path $root $orig
    if (Test-Path $src) {
        if (Test-Path $dest) {
            Write-Host "Skipping revert for $new -> $orig because $orig already exists in root."
        } else {
            Move-Item -LiteralPath $src -Destination $dest
            Write-Host "Reverted: $new -> $orig"
        }
    } else {
        Write-Host "Not found in Assets/: $new"
    }
}

Write-Host "Undo complete (check output for any skipped files)."
