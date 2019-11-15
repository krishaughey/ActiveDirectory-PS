## REQUIRES function Get-ClientWSUSSetting.ps1 to be loaded
# Get WSUS Client Settings
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
write-host $timestamp

$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\WSUS\NoWSUS.txt)

Import-Module -Name C:\Temp\WSUS\Modules\Get-ClientWSUSSetting.ps1 -verbose

$Results = Foreach ($server in $list)
{
   Get-ClientWSUSSetting -Computername $server -ShowEnvironment | Select Computername,WUServer
}

$Results | Out-File c:\Temp\WSUS\20191114_Check.csv
