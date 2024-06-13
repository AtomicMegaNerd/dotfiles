# Define the base paths
$dotfilesPath = Join-Path $env:USERPROFILE "Code\Configs\dotfiles\config"

# Get the package family name for Windows Terminal
$wtPackageFamilyName = (Get-AppxPackage | Where-Object { $_.Name -eq "Microsoft.WindowsTerminal" }).PackageFamilyName

# Construct the path to the settings.json file
$targetPaths = @{
    "Powershell" = Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "VSCode" = Join-Path $env:USERPROFILE "AppData\Roaming\Code\User\settings.json"
    "WindowsTerminal" = Join-Path $env:USERPROFILE "AppData\Local\Packages\$wtPackageFamilyName\LocalState\settings.json"
    "nvim" = Join-Path $env:USERPROFILE "AppData\Local\nvim"
}

# Define which targets are directories
$directories = @("nvim")

# Echo the target paths
foreach ($key in $targetPaths.Keys) {
    Write-Host "Target path: ${key}: $($targetPaths[$key])"
}

# Check if the dotfiles path exists
if (-not (Test-Path $dotfilesPath)) {
    Write-Error "The path $dotfilesPath does not exist. Exiting..."
    exit
}

# Loop through each target path
foreach ($key in $targetPaths.Keys) {
    $targetPath = $targetPaths[$key]
    Write-Host "Processing ${key} at ${targetPath}"

    # Delete the old symlink if it exists
    if (Test-Path $targetPath) {
        Write-Host "Removing old symlink at ${targetPath}"
        Remove-Item -Recurse -Force $targetPath
    }

    Write-Host "Creating symlink for ${key} at ${targetPath}"

    # Create the new symlink
    try {
        $target = Join-Path $dotfilesPath $key
        if ($directories -contains $key) {
            $command = "New-Item -ItemType SymbolicLink -Target $target -Path $targetPath"
        } else {
            $command = "New-Item -ItemType SymbolicLink -Target (Join-Path $target $(Split-Path $targetPath -Leaf)) -Path $targetPath"
        }
        Write-Host "Running: $command"
        Invoke-Expression $command
    } catch {
        Write-Error "Failed to create symbolic link for ${key}: ${_}"
    }
}