## Get Scheduled Tasks with Domain StartName
##### Get Scheduled Tasks with Domain StartName. Running and not disabled - Not LocalSystem,NT AUTHORITY,$Null
##### author: Kristopher F. Haughey
$ErrorActionPreference = 'silentlycontinue'
#Create the log
$TimeStamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Function LogWrite
{
Param ([string]$logstring)
Add-content $Logfile -value $logstring
}
$LogPath = Read-Host -Prompt "Enter a folder path for the log file >>"
$LogFile = "$LogPath\ScheduledTasks_$timestamp.log"
LogWrite "Script Start = $TimeStamp"

#Get ComputerObject Names from OU (prompted)
$SearchBase = Read-Host -Prompt "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>) >>"
LogWrite "SearchBase = $Searchbase"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name
#$ServerCount = ($ServerList).count
$ServerNames = $Serverlist.Name
#LogWrite "Collecting Scheduled Task information from $ServerCount computers..."

#Collect the information from remote machines
$Array = @()
foreach ($Server in $ServerNames) {
  if ( ([string]::IsNullOrEmpty($Server)) ) {
    LogWrite "$Server not found"
  }
  else {
    Invoke-Command -ComputerName $Server -ScriptBlock { $objSchTaskService = New-Object -ComObject Schedule.Service }
    Invoke-Command -ComputerName $Server -ScriptBlock { $objSchTaskService.connect('localhost') }
    Invoke-Command -ComputerName $Server -ScriptBlock { $RootFolder = $objSchTaskService.GetFolder("\") }
    Invoke-Command -ComputerName $Server -ScriptBlock { $ScheduledTasks = $RootFolder.GetTasks(0) }
    Invoke-Command -ComputerName $Server -ScriptBlock { $ScheduledTasks | Select-Object Name, LastRunTime, NextRunTime,@{Name="RunAs";Expression={[xml]$xml = $_.xml ; $xml.Task.Principals.principal.userID}} }
#Create a temporary table object for appending data
    foreach ($Task in $colItems){
      $Array += New-Object PsObject -Property ([ordered]@{
          'Server' = $Server
          'Name' = $Task.Name
          'LastRunTime' = $Task.LastRunTime
          'NextRunTime' = $Task.NextRunTime
          'RunAs' = $Task.RunAs})
    }
  }
}
$Array | Export-Csv c:\Temp\ScheduledTasks_$timestamp.csv -NoTypeInformation
LogWrite "export = c:\Temp\ScheduledTasks_$timestamp.csv"
LogWrite "Script End = $TimeStamp"
