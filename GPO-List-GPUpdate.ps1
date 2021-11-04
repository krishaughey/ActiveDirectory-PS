#GPUPDATE on list of computers (# out -Target for user and computer GPO)
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
write-host $timestamp

$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\NoWSUS.txt)

Foreach ($server in $list)
{
    Invoke-GPUpdate -Computer $Server -Target "Computer"
}
