## Get Scheduled Tasks with Domain StartName
##### Get Services with Domain StartName. Running and not disabled - Not LocalSystem,NT AUTHORITY,$Null
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,DNSHostName

Write-Host "Collecting Scheduled Tasks information..." -ForegroundColor Green
foreach ($Server in $ServerList){
  $objSchTaskService = New-Object -ComObject Schedule.Service
  $objSchTaskService.connect('localhost')
  $RootFolder = $objSchTaskService.GetFolder("\")
  $ScheduledTasks = $RootFolder.GetTasks(0)
  $ScheduledTasks | Select-Object Name, LastRunTime, NextRunTime,@{Name="RunAs";Expression={[xml]$xml = $_.xml ; $xml.Task.Principals.principal.userID}}
}
  foreach ($Task in $ScheduledTasks){
    $Array += New-Object PsObject -Property ([ordered]@{
        'Server' = $Service.PSComputerName
        'Name' = $Service.Name
        'DisplayName' = $Service.DisplayName
        'State' = $Service.State
        'StartMode' = $Service.StartMode
        'StartName' = $Service.StartName})
  }
  $Array | Export-Csv c:\Temp\Services-DomainAccounts_$timestamp.csv -NoTypeInformation
  Write-Host "export = c:\Temp\Services-DomainAccounts_$timestamp.csv" -ForegroundColor Cyan


********************DRAFT*********************
