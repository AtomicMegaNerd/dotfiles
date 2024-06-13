# Define the base paths
$dotfilesPath = Join-Path $env:USERPROFILE "Code\Configs\dotfiles\configs"

# Get the package family name for Windows Terminal
$wtPackageFamilyName = (Get-AppxPackage | Where-Object { $_.Name -eq "Microsoft.WindowsTerminal" }).PackageFamilyName

# Construct the path to the settings.json file
$wtSettingsPath = Join-Path $env:USERPROFILE "AppData\Local\Packages\$wtPackageFamilyName\LocalState\settings.json"

$targetPaths = @{
    "Powershell" = Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "VSCode" = Join-Path $env:USERPROFILE "AppData\Roaming\Code\User\settings.json"
    "WindowsTerminal" = $wtSettingsPath
    "Neovim" = Join-Path $env:USERPROFILE "AppData\Local\nvim"
}

# Check if the dotfiles path exists
if (-not (Test-Path $dotfilesPath)) {
    Write-Error "The path $dotfilesPath does not exist. Exiting..."
    exit
}

# Loop through each target path
foreach ($key in $targetPaths.Keys) {
    $targetPath = $targetPaths[$key]

    # Delete the old symlink if it exists
    if (Test-Path $targetPath) {
        Remove-Item $targetPath
    }

    # Create the new symlink
    try {
        New-Item -ItemType SymbolicLink -Target (Join-Path $dotfilesPath $key) -Path $targetPath
    } catch {
        Write-Error "Failed to create symbolic link for $key: $_"
    }
}

