# Get All OU ACLs and send to CSV
## report on the ACLs for all OU in a domain
##### author: Kristopher F. Haughey
##### 20260323

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory
$allOu = Get-ADOrganizationalUnit -Filter *

$Array = @()
foreach($ou in $allOu){
$colItems = (Get-ACL “AD:$((Get-ADOrganizationalUnit -Identity $ou).distinguishedname)“).access | Select-Object IdentityReference,AccessControlType,ActiveDirectoryRights,IsInherited

    foreach ($ouAcl in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'OU Name' = $ou.Name
            'OU DistinguishedName' = $ou.DistinguishedName
            'IdentityReference' = $ouAcl.IdentityReference
            'AccessControlType' = $ouAcl.AccessControlType
            'ActiveDirectoryRights' = $ouAcl.ActiveDirectoryRights
            'IsInherited' = $ouAcl.IsInherited})
      }
    }
$Array | export-csv C:\Temp\OU_ACL_Report_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\Temp\OU_ACL_Report_$timestamp.csv" -ForegroundColor Cyan
