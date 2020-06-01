## WSUS Client Actions
##### Initiate wuauclt commands on remote hosts, chosing from AD searchbase
##### author: Kristopher F. Haughey

$ErrorActionPreference = 'silentlycontinue'
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
Write-Host "Enter the switch(es) you wish to execute (e.g. /DetectNow, /ReportNow, /SelfUpdateManaged, /ResetAuthorization, etc.)"
$Switches = Read-Host -Prompt "-->"
$ServerList = get-adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,dnshostname

Write-Host "Gathering info. Depending on your searbase, this might take some time... Grab a coffee?" -ForegroundColor Green

$LogOutFile = Foreach ($dnshostname in $ServerList){
  psexec \\$server wuauclt.exe "$Switches"
}
$LogOutFile | Out-File C:\Temp\wsusUpdateCheck_$timestamp.csv
