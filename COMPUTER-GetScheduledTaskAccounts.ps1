## Get Scheduled Tasks with Domain StartName
##### Get Services with Domain StartName. Running and not disabled - Not LocalSystem,NT AUTHORITY,$Null
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,DNSHostName

Write-Host "Collecting Scheduled Tasks..." -ForegroundColor Green
Array = @()
foreach ($Server in $ServerList){
$colItems = Get-Wmiobject win32_service -ComputerName $Server | where {$_.StartMode -ne "Disabled" -and $_.State -ne "Stopped" -and $_.StartName -ne "LocalSystem" -and $_.StartName -notlike "NT AUTHORITY*" -and $_.StartName -ne $Null} | Select-Object PSComputerName,Name,DisplayName,State,StartMode,StartName
  foreach ($Task in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
        'ServerName' = $Task.
        'TaskName' = $Task.
        'State' = $Task.
        'LastRunTime' = $Task.
        'NextRunTime' = $Task.
        'TaskPath' = $Task.

  }
}
$Array | export-csv c:\Temp\Services-DomainAccounts_$timestamp.csv -NoTypeInformation
Write-Host "export = c:\Temp\Services-DomainAccounts_$timestamp.csv" -ForegroundColor Cyan

'@
FILTERS
State -ne "Disabled"
Author -notlike "Microsoft*"
Description

SELECT
Select-Object ServerName,TaskName,State,LastRunTime,NextRunTime,TaskPath | where {$_.State -ne "Disabled"}

get-scheduledtask | where {$_.AUTHOR -like "CARD*" -and $_.State -ne "Disabled"} | Select-Object * | Get-ScheduledTaskInfo | Select *


**** cmd ****
schtasks /query /nh /v /fo csv | out-file c:\work\tasks.csv

Which you can then re-import into PowerShell.

$tasks = Import-csv c:\work\tasks.csv

$tasks | group "Schedule Type" -NoElement | sort count
@'
