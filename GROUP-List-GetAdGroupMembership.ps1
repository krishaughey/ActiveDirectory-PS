## Get Membership on List of Groups
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$DomainController = Get-ADDomainController| Select-Object Name
#$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$GroupList = Get-Content c:\Temp\GroupList.txt

$Array = @()
foreach($GroupObject in $GroupList){
$colItems = Get-ADGroupMember $GroupObject -Server $DomainController.Name | Select-Object samAccountName
    foreach ($Member in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Group' = $GroupObject
            'Member' = $Member.samAccountName})
      }
    }
$Array | export-csv C:\Temp\Group_Membership_Report_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\Temp\Group_Membership_Report_$timestamp.csv" -ForegroundColor Cyan
