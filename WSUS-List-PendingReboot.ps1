## Get Computers Pending Reboot from List
##### Get WinServers pending reboot from a list
##### REQUIRES PSGallery Module "PendingReboot" https://github.com/bcwilhite/PendingReboot/
##### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-Content -Path "c:\Temp\ServerList.txt"

$Array = @()
foreach ($Server in $ServerList)
$testConnection = Test-Connection $Server
If (($testConnection -ne "") -or ($testconnection -ne $null){
$colItems = Test-PendingReboot -ComputerName $Server.dnshostname -SkipConfigurationManagerClientCheck -SkipPendingFileRenameOperationsCheck -Detailed | Select-Object ComputerName,IsRebootPending,WindowsUpdateAutoUpdate
  foreach ($RebootCheck in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
      'ServerName' = $RebootCheck.ComputerName
      'RebootPending' = $RebootCheck.IsRebootPending
      'FromUpdate' = $RebootCheck.WindowsUpdateAutoUpdate})
  }
}
Else {
  Write-Host "WARNING: $Server unreachable"
}
$Array | export-csv "C:\Temp\PendingReboot_$timestamp.csv" -NoTypeInformation
#Write-Host $Array | format-table
