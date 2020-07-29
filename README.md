# ActiveDirectory-PS

![PowerShell](https://repository-images.githubusercontent.com/221074232/158c2480-5262-11ea-8af0-452a86d9e56d)

##### Simple Timestamp Variable
> $timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

##### Get AD Schema Version
    Get-ADObject (Get-ADRootDSE).schemaNamingContext -Property objectVersion

##### Get FSMO Role Holders
    Get-ADDomainController -Filter * | Select-Object Name, Domain, Forest, OperationMasterRoles | Where-Object {$_.OperationMasterRoles} | Format-Table -AutoSize

##### Get list of all WinServers
    Get-ADComputer -LDAPFilter "(operatingSystem=Windows\20Server*)" -SearchBase "DC=<DOMAIN>,DC=<DOMAIN>"

##### Reset AD Computer Object Password
###### run from local machine
    Reset-ComputerMachinePassword -Server "<DOMAINCONTROLLER>"

##### Get all domain user accounts
    get-aduser -Filter * -searchbase "DC=<DOMAIN>,DC=<DOMAIN>" -properties displayname,samAccountName,userPrincipalName,mail,Enabled,AccountExpirationDate,LastLogon,WhenChanged,DistinguishedName | where {$_.Enabled -eq "True"} | select DisplayName,samAccountName,userPrincipalName,Enabled,Mail,AccountExpirationDate,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},WhenChanged,DistinguishedName | sort name | export-csv c:\Temp\UserAccounts.csv

##### Get all websites from local IIS
    get-website | select name,id,state,physicalpath,@{n="Bindings"; e= { ($_.bindings | select -expa collection) -join ';' }} ,@{n="LogFile";e={ $_.logfile | select -expa directory}},@{n="attributes"; e={($_.attributes | % { $_.name + "=" + $_.value }) -join ';' }} | Export-Csv -NoTypeInformation -Path C:\my_list.csv

##### Get Service (no disabled, no LocalSystem acct)
    get-wmiobject win32_service | where {$_.StartName -ne "LocalSystem" -and $_.StartMode -ne "Disabled"} | format-table Name,DisplayName,State,StartMode,StartName

##### Get Connection Statistics (DA/VPN)
    Get-RemoteAccessConnectionStatistics -StartDateTime 05/27/2020 -EndDateTime 06/02/2020} | select UserName,UserActivityState,ClientExternalAddress | format-table
