## WSUS Client Actions
##### Initiate wuauclt commands on remote hosts, chosing from AD searchbase
##### author: Kristopher F. Haughey
$ErrorActionPreference= 'silentlycontinue'
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Yellow
$SearchBase = Read-Host -Prompt "-->"
Write-Host "Enter the switch(es) you wish to execute (e.g. /DetectNow, /ReportNow, /SelfUpdateManaged, /ResetAuthorization, etc.)" -ForegroundColor Yellow
$Switches = Read-Host -Prompt "-->" # add choice 1,2,3
$ServerList = get-adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase "$SearchBase" | Select-Object -ExpandProperty DNSHostName

Write-Host "Running wuauclt with $Switches. Depending on your searbase, this might take some time... Grab a coffee?" -ForegroundColor Green
$Array = Foreach ($Server in $ServerList){
    Invoke-Command -ComputerName $Server -ScriptBlock {wuauclt.exe $Switches}
}
# $Array | Out-File C:\Temp\wsusUpdateCheck_$timestamp.csv
Write-Host "Process complete"
