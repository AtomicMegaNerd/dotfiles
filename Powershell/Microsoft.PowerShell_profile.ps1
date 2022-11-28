# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Oh My Posh
oh-my-posh init pwsh | Invoke-Expression

# Terminal-Icons
Import-Module -Name Terminal-Icons

# Aliases
New-Alias -Name vim -Value nvim

# Functions
function cdot { cd "C:\Users\chris\Code\Configs\dotfiles" }

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
