#Docker Desktop fixes https://docs.docker.com/desktop/windows/troubleshoot/
#Self diagnose 
# & "C:\Program Files\Docker\Docker\resources\com.docker.diagnose.exe" check

#Requires -RunAsAdministrator

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

$containerName = "SWVO"
$major = 21
$type = "Sandbox"
$country = "nl"
$licenseFile = (get-item $PSScriptRoot ).parent.parent.FullName + "\Licence\Cronus.flf"

if (-not(Test-Path -Path $licenseFile -PathType Leaf)) {
    Write-Error 'Licence file not found.' -Category ResourceExists;
    Exit;
}

#Switch to Windows Containers (Also starts docker desktop if not running.)
Write-Output 'Switch Docker Desktop to use Windows containers';
& 'C:\Program Files\Docker\Docker\DockerCli.exe' -SwitchWindowsEngine

#Trust the PSGallery from Microsoft
$PSGallery = Get-PSRepository -Name 'PSGallery'

if ($null -eq $PSGallery) {
    Write-Error 'PSGallery is not found' -Category NotInstalled;
    Exit;
}

if ($PSGallery.Trusted -eq $false) {
    Write-Output 'Setting PSGallery as a trusted repository';
    Set-PSRepository -Name $PSGallery.name -InstallationPolicy Trusted
}

if (-not (Get-Module bcContainerHelper -ListAvailable)) {
    Write-Output 'Installing BCContainerHelper';
    Install-Module -Name BcContainerHelper -Force
}
else{
    Write-Output 'Updating BCContainerHelper';
    Update-Module bcContainerHelper
}

if (-not (Get-Module bcContainerHelper -ListAvailable)) {
    Write-Error 'BCContainerHelper is not installed' -Category NotInstalled;
    Exit;
}

#Remove old container
# Stop-BcContainer -containerName $containerName
# Remove-BcContainer -containerName $containerName

Write-Output 'Getting ArtifactUrl';
$artifactUrl = Get-BCArtifactUrl -version $major -type $type -country $country
Write-Output $artifactUrl
$credential = New-Object pscredential 'user', (ConvertTo-SecureString -String 'password' -AsPlainText -Force)

Write-Output "Creating new container: ${containerName}";
New-BcContainer `
    -accept_eula `
    -licenseFile $licenseFile `
    -containerName $containerName `
    -artifactUrl $artifactUrl `
    -Credential $credential `
    -auth UserPassword `
    -accept_outdated `
    -enableTaskScheduler `
    -updateHosts `
    -Verbose