## Get Free Disk Space
##### Get Free & Used Disk Space on a searchbase (filters for OS like server) - local disks C: and D: - report to CSV
##### author: Kristopher F. Haughey
Import-Module ActiveDirectory
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$ServerList = get-adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,dnshostname

$ErrorActionPreference = 'silentlycontinue'
# Write-Host "WARNING: RPC ERROR WILL OCCUR IF HOST IS NOT REACHABLE" -ForegroundColor Yellow
# Write-Host "info on RPC errors - https://social.technet.microsoft.com/wiki/contents/articles/4494.windows-server-troubleshooting-the-rpc-server-is-unavailable.aspx" -ForegroundColor Gray
Write-Host "Gathering info. Depending on your searbase, this might take some time... Grab a coffee?" -ForegroundColor Green
$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-WmiObject Win32_LogicalDisk -ComputerName $Server.DNSHostName | Where-Object {($_.DeviceID -eq "C:") -or ($_.DeviceID -eq "D:")}
  foreach ($Drive in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
      'ServerName' = $Drive.PSComputerName
      'DriveName' = $Drive.Name
      'Freespace(GB)' = [Math]::Round($Drive.Freespace / 1GB)
      'TotalSize(GB)' = [Math]::Round($Drive.Size / 1GB)})
    }
}
$Array | export-csv c:\Temp\WinServer-Freespace_$timestamp.csv -NoTypeInformation
Write-Host "export = c:\Temp\WinServer-Freespace_$timestamp.csv" -ForegroundColor Cyan
