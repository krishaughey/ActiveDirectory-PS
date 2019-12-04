#Get users from list and export attributes, including last logon conversion and timestamp in filename
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

Get-Content C:\Temp\UserListFile.txt | Get-ADuser -properties Name, samAccountName, Enabled, AccountExpirationDate,lastLogon, WhenChanged, employeeNumber, extensionAttribute6, extensionAttribute9, Office, Country | Select-Object Name, samAccountName, Enabled, AccountExpirationDate, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}, WhenChanged, employeeNumber, extensionAttribute6, extensionAttribute9, Office, Country | export-csv c:\Temp\UAR_Q3_2019_DisabledUsersInfo-$timestamp.csv
