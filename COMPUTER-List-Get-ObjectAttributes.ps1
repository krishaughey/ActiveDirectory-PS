# Get Server Object Attributes
## Get the selected attributes from an AD Server Object
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

$DomainController = Get-ADDomainController| Select-Object Name
$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$List = Get-Content c:\Temp\ServerList.txt

$Array = @()
foreach($ServerObject in $List){
$colItems = Get-ADComputer -filter {Name -like $ServerObject} -Server $DomainController.Name -SearchBase $SearchBase -properties name,ipv4Address,enabled,distinguishedName,description,modified | Select-Object name,ipv4Address,enabled,distinguishedName,description,modified
    foreach ($Server in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Name' = $Server.name
            'IPAddress' = $Server.ipv4Address
            'Status' = $Server.enabled
            'DistinguishedName' = $Server.distinguishedName
            'Description' = $Server.description
            'Modified' = $Server.modified})
      }
    }
$Array | export-csv c:\Temp\ServerAttributes_$timestamp.csv -NoTypeInformation
Write-Host "Export available at c:\Temp\ServerAttributes_$timestamp.csv" -ForegroundColor Cyan
