#Get users from list and export attributes, including last logon conversion and timestamp in filename
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

Get-Content C:\Temp\UserList.txt | Get-ADuser -Properties Name, samAccountName, Enabled, AccountExpirationDate, lastLogon, WhenChanged, employeeID, employeeNumber, Office, Country | Select-Object Name, samAccountName, Enabled, AccountExpirationDate, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}, WhenChanged, employeeID, employeeNumber, Office, Country | Export-CSV c:\Temp\UsersInfo-$timestamp.csv
