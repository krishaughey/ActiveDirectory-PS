## Get Scheduled Tasks with Domain StartName
##### Get Scheduled Tasks with Domain StartName. Running and not disabled - Not LocalSystem,NT AUTHORITY,$Null
##### author: Kristopher F. Haughey

##################################################################################################################
######    Set Variables and create Functions    ######

#$ErrorActionPreference = 'silentlycontinue'
$TimeStamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Function LogWrite
{
Param ([string]$logstring)
Add-content $Logfile -value $logstring
}
$LogPath = Read-Host -Prompt "Enter a folder path for the log and export files >>"
$LogFile = "$LogPath\ScheduledTasks_$timestamp.log"
LogWrite "START SCRIPT = $TimeStamp"

##################################################################################################################

#Get ComputerObject Names from OU (prompted)
$SearchBase = Read-Host -Prompt "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>) >>"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object -ExpandProperty Name
$Count = $($Serverlist).count
LogWrite "Log file path = $LogFile"
LogWrite "SearchBase = $Searchbase"
LogWrite "Collecting Scheduled Task information from $Count computers" | Format-List

$Array = @()
foreach ($Server in $ServerList) {
  if(!(Test-Connection -Cn $Server -BufferSize 16 -Count 1 -ea 0 -quiet)) {
    LogWrite "cannot reach $Server"
  }
  elseif (!(Get-ScheduledTask -TaskPath "\")) {
    LogWrite "no tasks in Task Scheduler library "\" on $Server"
  }
  else {
    #Get the Scheduduled Task information
    Invoke-Command -ComputerName $Server -ScriptBlock { $objSchTaskService = New-Object -ComObject Schedule.Service }
    Invoke-Command -ComputerName $Server -ScriptBlock { $objSchTaskService.connect('localhost') }
    Invoke-Command -ComputerName $Server -ScriptBlock { $RootFolder = $objSchTaskService.GetFolder("\") }
    Invoke-Command -ComputerName $Server -ScriptBlock { $ScheduledTasks = $RootFolder.GetTasks(0) }
    Invoke-Command -ComputerName $Server -ScriptBlock { $ScheduledTasks | Select Name, LastRunTime, NextRunTime,@{Name="RunAs";Expression={[xml]$xml = $_.xml ; $xml.Task.Principals.principal.userID}}  }
    #LogWrite "function complete on $Server"
  }
    foreach ($Task in $CollectScheduledTasks) {
      LogWrite "creating table object"
      $Array += New-Object PsObject -Property ([ordered]@{
          'Server' = $Server
          'Name' = $Task.Name
          'LastRunTime' = $Task.LastRunTime
          'NextRunTime' = $Task.NextRunTime
          'RunAs' = $Task.RunAs})
      LogWrite "$Task.Name,$Task.LastRunTime,$Task.NextRunTime,$Task.RunAs"
  }
}

$Array | Export-Csv $LogPath\ScheduledTasks_$timestamp.csv -NoTypeInformation
LogWrite "export = $LogPath\ScheduledTasks_$timestamp.csv"
LogWrite "END SCRIPT = $TimeStamp"
