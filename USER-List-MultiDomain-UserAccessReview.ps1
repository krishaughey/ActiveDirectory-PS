#Get users from list and export attributes, including last logon conversion and timestamp in filename
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$Domains = Get-Content c:\Temp\DomainList.txt

$array = foreach($domain in $Domains){
    Get-Content C:\Temp\UserList.txt | Get-ADuser -Server $domain -Properties Name, userPrincipalName, mail, Enabled, AccountExpirationDate, lastLogon, WhenChanged, employeeID, employeeNumber, Office, Country | Select-Object Name, userPrincipalName, mail, Enabled, AccountExpirationDate, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}, WhenChanged, employeeID, employeeNumber, Office, Country
}

$array | Export-CSV c:\Temp\UsersInfo-$timestamp.csv -NoTypeInformation
