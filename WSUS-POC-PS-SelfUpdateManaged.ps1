#WSUS - Trigger Client List to Check for Updates

#$ErrorActionPreference= 'silentlycontinue'
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

write-host $timestamp
$list = (Get-Content C:\Temp\Clients.txt)

$Results = Foreach ($server in $list)
{
 #psexec \\$server wuauclt.exe \selfupdatemanaged
 Invoke-Command -Computername $server -ScriptBlock {}
}
$Results | Out-File C:\Temp\WsusClientCheckin_$timestamp.csv
