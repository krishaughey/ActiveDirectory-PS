# Move and Disable a List of AD Computers
## move and disable a list of AD Computers to a prompted OU, then export a csv of attributes
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory
$DomainController = Get-ADDomainController| Select-Object Name
$SearchBase = Read-Host "Enter baseline searchbase (e.g.- OU=Servers,DC=Domain,DC=Local)"
$NewOU = Read-Host "Enter the Distinguished Name of the OU to move the objects TO (e.g.- OU=Disabled Server Accounts,OU=Domain,DC=Local)"
$ObjectList = Get-Content c:\Temp\ServerList.txt

$Array = @()
foreach($Object in $ObjectList){
$colItems = Get-ADComputer -filter {Name -like $Object} -Server $DomainController.Name -SearchBase $SearchBase -properties name,enabled,distinguishedName,description,modified | Select-Object name,enabled,distinguishedName,description,modified | Disable-ADAccount -PassThru | Move-ADObject -Identity $Object.distinguishedName -TargetPath $NewOU -Server $DomainController.Name
    foreach ($Computer in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Name' = $Computer.name
            'Status' = $Computer.enabled
            'DistinguishedName' = $Computer.distinguishedName
            'Description' = $Computer.description
            'Modified' = $Computer.modified})
      }
    }
$Array | export-csv c:\Temp\ComputerAttributes_$timestamp.csv -NoTypeInformation
Write-Host "Export available at c:\Temp\ComputerAttributes_$timestamp.csv" -ForegroundColor Cyan
