 # Update user attributes from CSV and export results
## using a list of samAcccountNames/usernames, SET user attributes specificed and export to CSV
##### author: Kristopher F. Haughey
Write-Host "Importing Modules, loading c:\Temp\UserList.csv, and SETTING AD User Account Attributes. Please standby..." -ForegroundColor Cyan
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory
$ImportUser = Import-CSV "C:\Temp\UserList.csv"

$Action = Foreach ($User in $ImportUser)
{
   $u = Get-ADUser -Server $User."Domain" -Identity $User."samAccountName" -Properties Title,Department,Manager
   $Manager = Get-ADUser -Server $User."Domain" -Identity $User.Manager | Select-Object DistinguishedName
   $u | Set-ADUser -Server $User."Domain" -Replace @{Title = "$($User."Title")"}
   $u | Set-ADUser -Server $User."Domain" -Replace @{Department = "$($User."Department")"}
   $u | Set-ADUser -Server $User."Domain" -Replace @{Manager = "$($Manager."DistinguishedName")"}
   Start-Sleep 1
   Get-ADuser -Server $User."Domain" -Identity $User."samAccountName" -properties Title,Department,Manager | Select-Object userPrincipalName,samAccountName,Title,Department,Manager
}
$Action | Export-CSV c:\Temp\AttributeUpdateResults_$timestamp.csv -NoTypeInformation
Write-Host "Script Completed - Results have been exported to c:\Temp\AttributeUpdateResults_$timestamp.csv" -ForegroundColor Green
