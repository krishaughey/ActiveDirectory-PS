# Server Update Checklist
## Various reports and checks to verify systems before and after patching
### Service Account Report
### Scheduled Task Report
### Pending Updates Report
### && Stand-alone statements for non-domain machines
###### author: Kristopher F. Haughey
#Write-Host "SERVER UPDATE CHECKLIST" -ForegroundColor Cyan
#Write-Host "Select the target for the report. Answer (1) for a single host, or (2) for a list of hosts."

# I WANT TO ADD -- 
# add TEMP directory, if not there
# ask for script target (host/list)
# ask which test/report to run (or all)
# compare list of service accounts to "<DOMAIN>serviceaccounts" and give a simple verification prompt
# get pending updates waiting for restart
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-Content -Path "c:\Temp\ServerList.txt"

#SERVICE ACCOUNTS REPORT -- Computers in list
Write-Host "Collecting service information..." -ForegroundColor Green
$ServiceArray = @()
foreach ($Server in $ServerList){
$colItems_Service = Get-Wmiobject win32_service -ComputerName $Server.DNSHostName | where {$_.StartMode -ne "Disabled" -and $_.State -ne "Stopped" -and $_.StartName -ne $Null} | Select-Object PSComputerName,Name,DisplayName,State,StartMode,StartName
  foreach ($Service in $colItems_Service){
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
Write-Host "check against the membership of <DOMAIN>ServiceAccounts" -ForegroundColor Green
$ServiceAccountsMembership #this would be removed

#SCHEDULED TASKS REPORT
Write-Host "Collecting Scheduled Task information..." -ForegroundColor Green
$ScheduledTaskArray = @()
foreach ($Server in $ServerList){
$colItems_ScheduledTask = Get-ScheduledTask 
  foreach ($ScheduledTask in $colItems_ScheduledTask){
    $ScheduledTaskArray += New-Object PsObject -Property ([ordered]@{
        'Server' = $Server
        'Name' = $ScheduledTask.TaskName
        'State' = $ScheduledTask.State })
    }
}
$ScheduledTaskArray | export-csv c:\Temp\ScheduledTasks_$timestamp.csv -NoTypeInformation
Write-Host "Scheduled Task report complete" -ForegroundColor Green

#PENDING REBOOT REPORT
$colItems_PendingReboot = Test-PendingReboot -ComputerName $Server.dnshostname -SkipConfigurationManagerClientCheck -SkipPendingFileRenameOperationsCheck -Detailed | Select-Object ComputerName,IsRebootPending,WindowsUpdateAutoUpdate
  foreach ($RebootCheck in $colItems_PendingReboot){
    $PendingReboot += New-Object PsObject -Property ([ordered]@{
      'ServerName' = $RebootCheck.ComputerName
      'RebootPending' = $RebootCheck.IsRebootPending
      'FromUpdate' = $RebootCheck.WindowsUpdateAutoUpdate})
  }
$PendingReboot | export-csv "C:\Temp\PendingReboot_$timestamp.csv" -NoTypeInformation
