### Get all user accounts and report the selected attribute(s)
## THEN export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
### author: Kristopher F. Haughey
Import-Module ActiveDirectory

#Set variables and format TimeStamp
$AdDomain = "arbonnewest.com"
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ExportPath = "c:\temp\"
$FileName = "PreferredLanguage-$AdDomain-$timestamp.csv"

#Get the user accounts (root searcbase), select properties, and export
Get-ADUser -Filter * -Server $AdDomain -properties preferredLanguage | Select-Object samAccountName,preferredLanguage | export-csv "$ExportPath$FileName" -NoTypeInformation
write-host "Process Complete" -ForegroundColor Green
write-host "Results= $ExportPath$timestamp.csv" -ForegroundColor Cyan
