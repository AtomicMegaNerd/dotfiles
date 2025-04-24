# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Starship
Invoke-Expression (&starship init powershell)

# Terminal-Icons
Import-Module -Name Terminal-Icons

# Aliases
New-Alias -Name vim -Value nvim

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
