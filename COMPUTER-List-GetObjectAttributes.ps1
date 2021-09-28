# Get Server Object Attributes
## Get the selected attributes from an AD Server Object
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ADDomain = Read-Host "Enter AD Domain name (e.g.- domain.local)"
Set-ADDomain $ADDomain
$DomainController = Get-ADDomainController -Discover -Domain $ADDomain | Select-Object Name
$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$List = Get-Content c:\Temp\ServerList.txt

$Array = @()
foreach($ServerObject in $List){
$colItems = Get-ADObject -filter {Name -like $ServerObject} -Server $DomainController.Name -SearchBase $SearchBase -properties name,distinguishedName,description | Select-Object name,distinguishedName,description
    foreach ($Server in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Name' = $Server.name
            'DistinguishedName' = $Server.distinguishedName
            'Description' = $Server.description})
      }
    }
$Array | export-csv c:\Temp\ServerAttributes_$timestamp.csv -NoTypeInformation
Write-Host "Export available at c:\Temp\ServerAttributes_$timestamp.csv" -ForegroundColor Cyan
