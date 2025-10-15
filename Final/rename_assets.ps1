# rename_assets.ps1
# Creates an Assets folder (if missing) and moves+renames files from
# the current directory into it using a safe, consistent naming scheme.
# Rules:
# - Convert filename to lowercase
# - Replace '&' with 'and'
# - Replace whitespace with '-'
# - Remove other non-alphanumeric/dash characters
# - Preserve and lowercase the file extension

$root = Get-Location
$exclusions = @('FINAL VERSION 2.0.html','Version2.html','rename_assets.ps1')
$assetsDir = Join-Path $root 'Assets'
if (-not (Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir | Out-Null }

Get-ChildItem -File | Where-Object { $exclusions -notcontains $_.Name } | ForEach-Object {
    $orig = $_.Name
    $base = [System.IO.Path]::GetFileNameWithoutExtension($orig)
    $ext = [System.IO.Path]::GetExtension($orig)

    # lower, replace ampersand, spaces -> dashes, remove other unwanted chars
    $safe = $base.ToLower()
    $safe = $safe -replace '&','and'
    $safe = $safe -replace '\s+','-'
    $safe = $safe -replace '[^a-z0-9\-]',''

    $newName = $safe + $ext.ToLower()
    $dest = Join-Path $assetsDir $newName

    if (Test-Path $dest) {
        Write-Host "Skipping: $orig -> $newName (already exists)"
    } else {
        Move-Item -LiteralPath $_.FullName -Destination $dest
        Write-Host "Moved: $orig -> Assets\$newName"
    }
}

Write-Host "Done. If you use 'FINAL VERSION 2.0.html', it now expects assets under Assets/ with sanitized names."
