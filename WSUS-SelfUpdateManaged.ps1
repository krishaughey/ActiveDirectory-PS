$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\wsusServerList.txt)

Foreach ($server in $list)
{
 psexec \\$server wuauclt.exe \selfupdatemanaged
}

$LogOutFile | Out-File C:\Temp\wsusUpdateCheck.csv
