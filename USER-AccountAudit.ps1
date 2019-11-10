## Get USERS from select OU (you will be prompted for the OU you wish to search)
##  and export info to CSV w/ TIMESTAMP and human-friendly lastlogon date
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$DN = 'OU='
$input = Read-Host -Prompt 'enter the OU you wish to search'
$OU = -join($DN,$input)

Import-Module ActiveDirectory

Get-ADUser -Filter * -SearchBase "$OU,dc=rlcorp,dc=local” -properties Name, samAccountName, Enabled, AccountExpirationDate,lastLogon, WhenChanged, employeeNumber, extensionAttribute6, extensionAttribute9, Office, Country | Select-Object Name, samAccountName, Enabled, AccountExpirationDate, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}, WhenChanged, employeeNumber, extensionAttribute6, extensionAttribute9, Office, Country | export-csv c:\Temp\$OU-Users-$timestamp.csv
