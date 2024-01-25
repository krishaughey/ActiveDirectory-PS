### Get all user accounts and report a chosen attribute(s)
## THEN export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
### author: Kristopher F. Haughey
Import-Module ActiveDirectory

#Set variables and format TimeStamp
$AdDomain = "<DOMAIN>"
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ExportPath = "c:\temp\"
$FileName = "PreferredLanguage-$AdDomain-$timestamp.csv"

#Get the user accounts (root searcbase), select properties, and export
Get-ADUser -Filter * -Server $AdDomain -properties preferredLanguage | Select-Object samAccountName,preferredLanguage | Export-Csv "$ExportPath$FileName" -NoTypeInformation
Write-Host "Process Complete" -ForegroundColor Green
Write-Host "Results= PreferredLanguage-$AdDomain-$timestamp.csv" -ForegroundColor Cyan 
