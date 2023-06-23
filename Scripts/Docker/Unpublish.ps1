param (
    [Parameter(Mandatory = $false)][string]$containerName = $(Read-Host "Input container name"),
    [Parameter(Mandatory = $false)][string]$appName = $(Read-Host "Input app name")
)

if([String]::IsNullOrEmpty($containerName))
{
    $containerName = 'SWVO';
}

if([String]::IsNullOrEmpty($appName))
{
    $appName = 'SWVO';
}

Unpublish-BcContainerApp -containerName $containerName -appName $appName -uninstall -tenant default
Sync-BcContainerApp -containerName $containerName -appName $appName -Mode Clean -Force