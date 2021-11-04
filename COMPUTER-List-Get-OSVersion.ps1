# Get OS Version
## Get the OS Version of Servers
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$DomainController = Get-ADDomainController| Select-Object Name
$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$ServerList = Get-AdComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -Server $DomainController.Name -SearchBase $SearchBase | Select-Object Name,dnshostname
#$ServerList = Get-Content c:\Temp\ServerList.txt

$Array = @()
foreach($ServerObject in $ServerList){
$colItems = Get-ADComputer $ServerObject.Name -properties Name,OperatingSystem | Select-Object Name,OperatingSystem

    foreach ($Server in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Server' = $Server.Name
            'Version' = $Server.OperatingSystem})
      }
    }
$Array | export-csv C:\Temp\OS_Version_Report_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\Temp\OS_Version_Report_$timestamp.csv" -ForegroundColor Cyan
