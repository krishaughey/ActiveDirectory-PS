## Get Computers Pending Reboot
##### Get WinServers pending reboot by OU
##### REQUIRES PSGallery Module "PendingReboot" https://github.com/bcwilhite/PendingReboot/
##### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
Write-Host "Gathering info. Depending on your searbase, this might take some time... Grab a coffee?" -ForegroundColor Green
$ServerList = get-adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,dnshostname

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
