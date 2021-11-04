# Update user attributes from CSV and export results
Import-Module ActiveDirectory
$ImportUser = Import-CSV "C:\Temp\UserTelephoneImport-02.csv"

$Action = Foreach ($user in $ImportUser)
{
   $u = Get-ADuser -Identity $user."samAccountName" -properties distinguishedName,samAccountName,TelephoneNumber
   $u | Set-ADUser -Replace @{TelephoneNumber = "$($user."TelephoneNumber")"}
   start-sleep 1
   Get-ADuser -Identity $user."samAccountName" -properties samAccountName,Mail,TelephoneNumber | select samAccountName,Mail,TelephoneNumber
}
$Action | Export-CSV c:\Temp\AttributeUpdateResults.csv -NoTypeInformation
Read-Host "Script Completed"
