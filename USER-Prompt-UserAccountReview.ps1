## Get USERS from select OU (you will be prompted for the OU you wish to search) and export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$OU = Get-ADOrganizationalUnit -Filter * | Out-GridView -PassThru | Out-GridView -PassThru | Select Name,DistinguishedName
$ExportPath = "c:\temp\"

$FileName = "UAR-$timestamp.csv"

Import-Module ActiveDirectory

Get-ADUser -Filter * -SearchBase $OU.DistinguishedName -Server padm075.rlcorp.local -properties Name, samAccountName, Enabled, AccountExpirationDate,lastLogon, WhenChanged, employeeNumber, extensionAttribute6, extensionAttribute9, Office, Country | Select-Object Name,samAccountName,Enabled,AccountExpirationDate,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},WhenChanged,employeeNumber,extensionAttribute6,extensionAttribute9,Office,Country | export-csv "$ExportPath$FileName"
write-host "Process Complete" -ForegroundColor Green
write-host "Results= $ExportPath$timestamp.csv" -ForegroundColor Cyan
