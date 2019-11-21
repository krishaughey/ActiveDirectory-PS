# Update user attributes from CSV and export results
Import-Module ActiveDirectory
$ImportUser = Import-CSV "C:\Temp\TestUserList.csv"

$Action = Foreach ($user in $ImportUser)
{
   $u = Get-ADuser -Identity $user."samaccountname"
   $u | Set-ADUser -Replace @{description = "$($user."description")"}
   start-sleep 1
   Get-ADuser -Identity $user."samaccountname" -properties samaccountname,description | select samaccountname,description
}
$Action | Format-Table -AutoSize | Out-File c:\Temp\AttributeUpdateResults.csv
