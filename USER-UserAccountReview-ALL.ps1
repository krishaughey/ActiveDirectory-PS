### Get all user accounts and report properties
## THEN export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
### author: Kristopher F. Haughey
Import-Module ActiveDirectory

#Set variables and format TimeStamp
$AdDomain = Get-ADDomain
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ExportPath = "c:\temp\"
$FileName = "$($AdDomain.Name)-$timestamp.csv"

#Get the user accounts (root searcbase), select properties, and export
Get-ADUser -Filter * -SearchBase $($ADDomain.DistinguishedName) -properties Name, samAccountName, Description,Enabled, AccountExpirationDate,lastLogon, WhenChanged,Office | Select-Object Name,samAccountName,Description,Enabled,AccountExpirationDate,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},WhenChanged,Office | export-csv "$ExportPath$FileName"
write-host "Process Complete" -ForegroundColor Green
write-host "Results= $ExportPath$timestamp.csv" -ForegroundColor Cyan
