# Get user attributes from CSV and export results
## using a list of samAcccountNames/usernames, GET user attributes specificed and export to CSV
##### author: Kristopher F. Haughey
Write-Host "Importing Modules, loading c:\Temp\UserList.csv, and getting AD User Account Attributes. Please standby..." -ForegroundColor Cyan
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory
$ImportUser = Import-CSV "C:\Temp\UserList.csv"

$Action = Foreach ($User in $ImportUser)
{
    Get-ADuser -Server $User."Domain" -Identity $User."samAccountName" -properties Title,Department,Manager | Select-Object userPrincipalName,samAccountName,Title,Department,Manager
}
$Action | Export-CSV c:\Temp\UserAttributeExport_$timestamp.csv -NoTypeInformation
Write-Host "Script Completed - Results have been exported to c:\Temp\UserAttributeExport_$timestamp.csv" -ForegroundColor Green
