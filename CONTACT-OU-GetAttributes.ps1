### Get all user accounts and report properties
## THEN export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
### author: Kristopher F. Haughey
Import-Module ActiveDirectory

#Set Variables
$OU = "OU=Client Contacts,OU=Contacts,DC=card,DC=com"
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ExportPath = "c:\temp\"
$FileName = "$($OU)-$timestamp.csv"

#Get the Contacts, select properties, and export
Get-ADObject -Filter 'objectClass -eq "contact"' -SearchBase $OU -properties displayName,mail,department | Select-Object displayName,mail,department | export-csv "$ExportPath$FileName" -NoTypeInformation
write-host "Process Complete" -ForegroundColor Green
write-host "Results= $ExportPath$timestamp.csv" -ForegroundColor Cyan
