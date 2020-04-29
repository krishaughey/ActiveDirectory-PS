### Get USERS from select OU (you will be prompted for the OU you wish to search in GridView)
## THEN export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$OU = Get-ADOrganizationalUnit -Filter * | Where-Object {!$_.PSIsContainer -and  ($_.Name -like "*USER*") } | Out-GridView -PassThru | Out-GridView -PassThru | Select Name,DistinguishedName
$ExportPath = "c:\temp\"

$FileName = "$($OU.DistinguishedName)-$timestamp.csv"

Import-Module ActiveDirectory

Get-ADUser -Filter * -SearchBase $OU.DistinguishedName -properties Name, samAccountName, Description,Enabled, AccountExpirationDate,lastLogon, WhenChanged,Office | Select-Object Name,samAccountName,Description,Enabled,AccountExpirationDate,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},WhenChanged,Office | export-csv "$ExportPath$FileName"
write-host "Process Complete" -ForegroundColor Green
write-host "Results= $ExportPath$timestamp.csv" -ForegroundColor Cyan
