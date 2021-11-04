#Get Group Account Attributes from a List    
## using a list of group names, get attributes specificed and export to CSV
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$DomainController = Get-ADDomainController| Select-Object Name
$GroupList = Get-Content c:\Temp\GroupList.txt

$Array = @()
foreach($ADObject in $GroupList){
$colItems = Get-ADGroup -Filter {Name -like $ADObject} -Server $DomainController.Name -Properties name,mail | Select-Object name,mail 

    foreach ($Account in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'AccountName' = $Account.name
            'Email' = $Account.mail})
      }
    }
$Array | export-csv C:\Temp\GrouptAttributes_$timestamp.csv -NoTypeInformation
Write-Host "Export available at GroupAttributes_$timestamp.csv" -ForegroundColor Cyan
