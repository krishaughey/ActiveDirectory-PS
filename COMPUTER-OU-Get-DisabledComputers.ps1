# Get Disabled Computer Objects
## Get the Disabled Comptuer Objects and their attributes from an OU
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ADDomain = Read-Host "Enter AD Domain name (e.g.- domain.local)"
Set-ADDomain $ADDomain
$DomainController = Get-ADDomainController -Discover -Domain $ADDomain | Select-Object Name
$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$ServerList = Get-AdComputer -Filter 'enabled -eq "FALSE"' -Server $DomainController.Name -SearchBase $SearchBase | Select-Object Name
#$List = Get-Content c:\Temp\ServerList.txt

$Array = @()
foreach($ServerObject in $ServerList){
$colItems = Get-ADComputer $ServerObject.Name -properties name,enabled,OperatingSystem,distinguishedName,description,modified | Select-Object name,enabled,OperatingSystem,distinguishedName,description,modified
    foreach ($Server in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Name' = $Server.name
            'Enabled' = $Server.enabled
            'OSVersion' = $Server.OperatingSystem
            'Description' = $Server.description
            'DistinguishedName' = $Server.distinguishedName
            'Modified' = $Server.modified})
      }
    }
$Array | export-csv c:\Temp\DisabledComputers_$timestamp.csv -NoTypeInformation
Write-Host "Export available at c:\Temp\DisabledComputers_$timestamp.csv" -ForegroundColor Cyan
