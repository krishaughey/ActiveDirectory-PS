# Server Update Checklist
## Various reports and checks to verify systems before and after patching
###### author: Kristopher F. Haughey 

$ServerList = Get-Content -Path "c:\Temp\ServerList.txt"

#SERVICE ACCOUNTS REPORT
Write-Host "Collecting service information..." -ForegroundColor Green
$ServiceArray = @()
foreach ($Server in $ServerList){
$colItems = Get-Wmiobject win32_service -ComputerName $Server.DNSHostName | where {$_.StartMode -ne "Disabled" -and $_.State -ne "Stopped" -and $_.StartName -ne $Null} | Select-Object PSComputerName,Name,DisplayName,State,StartMode,StartName
  foreach ($Service in $colItems){
    $ServiceArray += New-Object PsObject -Property ([ordered]@{
        'Server' = $Service.PSComputerName
        'Name' = $Service.Name
        'DisplayName' = $Service.DisplayName
        'State' = $Service.State
        'StartMode' = $Service.StartMode
        'StartName' = $Service.StartName})
  }
}
$ServiceArray | export-csv c:\Temp\Services-DomainAccounts_$timestamp.csv -NoTypeInformation
Write-Host "service account report complete" -ForegroundColor Green
$ServiceAccountsMembership = Get-ADGroupMember -Identity "ServiceAccounts" | Select-Object Name
Write-Host "check against the membership of CARD\ServiceAccounts" -ForegroundColor Green
$ServiceAccountsMembership

#SCHEDULED TASKS REPORT
Write-Host "Collecting Scheduled Task information..." -ForegroundColor Green
$ScheduledTaskArray = @()
foreach ($Server in $ServerList){
$colItems = Get-ScheduledTask 
  foreach ($ScheduledTask in $colItems){
    $ScheduledTaskArray += New-Object PsObject -Property ([ordered]@{
        'Server' = $Server
        'Name' = $ScheduledTask.TaskName
        'State' = $ScheduledTask.State })
    }
}
$ScheduledTaskArray | export-csv c:\Temp\ScheduledTasks_$timestamp.csv -NoTypeInformation
Write-Host "Scheduled Task report complete" -ForegroundColor Green
