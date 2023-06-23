param (
    [Parameter(Mandatory = $true)][string]$containerName = $(Read-Host "Input container name")
)

# Stop-BcContainer -containerName $containerName
# Remove-BcContainer -containerName $containerName

# will remove all unused data.
docker stop $(docker ps -a -q)
docker rm -f $(docker ps -aq)
docker container prune -af
docker image prune -af
docker system prune --force
docker system prune --all --volumes --force