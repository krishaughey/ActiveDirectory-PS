## REQUIRES function Get-ClientWSUSSetting.ps1 to be loaded
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
write-host $timestamp

$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\ServerList.txt)

Import-Module -Name C:\Temp\Modules\Get-ClientWSUSSetting -verbose

Foreach ($server in $list)
{
    Get-ClientWSUSSetting -Computername $server -ShowEnvironment | Select Computername,WUServer
}
