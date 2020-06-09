## Get Scheduled Tasks with Domain StartName
##### Get Scheduled Tasks with Domain StartName. Running and not disabled - Not LocalSystem,NT AUTHORITY,$Null
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,DNSHostName

Write-Host "Collecting Scheduled Tasks information..." -ForegroundColor Green

$Array = @()
foreach ($Server in $ServerList){
$colItems =(
    Invoke-Command -ComputerName $Server -ScriptBlock -Wait { $objSchTaskService = New-Object -ComObject Schedule.Service } +
    Invoke-Command -ComputerName $Server -ScriptBlock -Wait { $objSchTaskService.connect('localhost') } +
    Invoke-Command -ComputerName $Server -ScriptBlock -Wait { $RootFolder = $objSchTaskService.GetFolder("\") } +
    Invoke-Command -ComputerName $Server -ScriptBlock -Wait { $ScheduledTasks = $RootFolder.GetTasks(0) } +
    Invoke-Command -ComputerName $Server -ScriptBlock -Wait { $ScheduledTasks | Select-Object Name, LastRunTime, NextRunTime,@{Name="RunAs";Expression={[xml]$xml = $_.xml ; $xml.Task.Principals.principal.userID }} })
}
  foreach ($Task in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
        'Server' = $Server
        'Name' = $Task.Name
        'LastRunTime' = $Task.LastRunTime
        'NextRunTime' = $Task.NextRunTime
        'RunAs' = $Task.RunAs}) #<--- Not sure if this will work
  }
  $Array | Export-Csv c:\Temp\Services-DomainAccounts_$timestamp.csv -NoTypeInformation
  Write-Host "export = c:\Temp\Services-DomainAccounts_$timestamp.csv" -ForegroundColor Cyan
