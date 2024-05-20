# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Starship
Invoke-Expression (&starship init powershell)

# Terminal-Icons
Import-Module -Name Terminal-Icons

# Aliases
New-Alias -Name vim -Value nvim

# Functions
function cdot { cd "C:\Users\RCD\Code\Configs\dotfiles" }

function cpy { cd "C:\Users\RCD\Code\Python" }

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
