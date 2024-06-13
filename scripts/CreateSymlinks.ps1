# Define the base paths
$dotfilesPath = Join-Path $env:USERPROFILE "Code\Configs\dotfiles\config"

# Get the package family name for Windows Terminal which can be dynamically generated
$wtPackageFamilyName = (Get-AppxPackage | Where-Object { $_.Name -eq "Microsoft.WindowsTerminal" }).PackageFamilyName

$targetPaths = @{
    "Powershell"      = Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "VSCode"          = Join-Path $env:USERPROFILE "AppData\Roaming\Code\User\settings.json"
    "WindowsTerminal" = Join-Path $env:USERPROFILE "AppData\Local\Packages\$wtPackageFamilyName\LocalState\settings.json"
    "nvim"            = Join-Path $env:USERPROFILE "AppData\Local\nvim"
}

$directories = @("nvim")

if (-not (Test-Path $dotfilesPath)) {
    Write-Error "The path $dotfilesPath does not exist. Exiting..."
    exit
}

foreach ($key in $targetPaths.Keys) {
    $targetPath = $targetPaths[$key]

    # Delete the old symlink if it exists
    if (Test-Path $targetPath) {
        Remove-Item -Recurse -Force $targetPath
    }

    # Create the new symlink for each app configuration
    try {
        $target = Join-Path $dotfilesPath $key
        $linkTarget = if ($directories -contains $key) { $target } else { Join-Path $target $(Split-Path $targetPath -Leaf) }
        New-Item -ItemType SymbolicLink -Target $linkTarget -Path $targetPath | Out-Null
    }
    catch {
        Write-Error "Failed to create symbolic link for ${key}: ${_}"
    }
}
