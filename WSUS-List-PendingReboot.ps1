## Get Computers Pending Reboot from List
##### Get WinServers pending reboot from a list
##### REQUIRES PSGallery Module "PendingReboot" https://github.com/bcwilhite/PendingReboot/
##### author: Kristopher F. Haughey
Import-Module PendingReboot
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-Content c:\Temp\ServerList.txt
$Array = @()
foreach ($Server in $ServerList) {
$colItems = Test-PendingReboot -ComputerName $Server -SkipConfigurationManagerClientCheck -SkipPendingFileRenameOperationsCheck -Detailed | Select-Object ComputerName,IsRebootPending,WindowsUpdateAutoUpdate
  foreach ($RebootCheck in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
      'ServerName' = $Server
      'RebootPending' = $RebootCheck.IsRebootPending
      'FromUpdate' = $RebootCheck.WindowsUpdateAutoUpdate})
  }
}
$Array | export-csv "C:\Temp\PendingReboot_$timestamp.csv" -NoTypeInformation
