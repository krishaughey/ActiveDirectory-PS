# Start Synchronization of WSUS -- REQUIRES PoshWSUS module https://www.powershellgallery.com/packages/PoshWSUS/2.3.1.6
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s #| ForEach-Object { $_ -replace ":", "." }

Import-Module PoshWSUS
Connect-PSWSUSServer -WsusServer wsus1.<DOMAIN>.com -port 8530
Start-PSWSUSSync
Write-Host "Synchronization completed"
$timestamp
Get-PSWSUSSyncProgress
