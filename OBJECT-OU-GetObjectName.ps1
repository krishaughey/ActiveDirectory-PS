### Get all user accounts and report properties
## THEN export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
### author: Kristopher F. Haughey

#Set variables and format TimeStamp
$OU = "OU=OrgUnit,DC=DOMAIN,DC=com"
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ExportPath = "c:\temp\"
$FileName = "$($OU)-$timestamp.csv"

#Get the user accounts (root searcbase), select properties, and export
Get-ADObject -Filter * -SearchBase $OU -properties Name | Select-Object Name | export-csv "$ExportPath$FileName"
write-host "Process Complete" -ForegroundColor Green
write-host "Results= $ExportPath$timestamp.csv" -ForegroundColor Cyan
