param (
    [Parameter(Mandatory = $true)][string]$email = $(Read-Host "Input Email"),
    [Parameter(Mandatory = $true)][string]$Name = $(Read-Host "Input Name")
)

git config user.email $email
git config user.name $Name