#WSUS - Trigger Client List to Check for Updates
$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\WSUS\NoWSUS.txt)

$Results = Foreach ($server in $list)
{
 psexec \\$server wuauclt.exe \selfupdatemanaged

}

$Results | Out-File C:\Temp\WSUS\20191114_Checkin.csv
