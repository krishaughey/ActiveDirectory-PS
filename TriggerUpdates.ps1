$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\ServerList.txt)

Foreach ($server in $list)
{
 psexec \\$server wuauclt.exe \selfupdatemanaged
}
