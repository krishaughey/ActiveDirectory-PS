# ActiveDirectory-PS

![PowerShell](https://repository-images.githubusercontent.com/221074232/158c2480-5262-11ea-8af0-452a86d9e56d)

##### Simple Timestamp Variable
> $timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

##### Get AD Schema Version
    Get-ADObject (Get-ADRootDSE).schemaNamingContext -Property objectVersion

##### Get All Domain Controllers in the Domain
    (Get-ADForest).Domains | %{ Get-ADDomainController -Filter * -Server $_ }

##### Get All Domain Controllers in another Domain
    (Get-ADForest -server <DOMAIN NAME>).Domains | %{ Get-ADDomainController -Filter * -Server $_ } | export-csv c:\Temp\<DOMAIN NAME>DC.csv -NoTypeInformation

##### Get FSMO Role Holders
    Get-ADDomainController -Filter * | Select-Object Name, Domain, Forest, OperationMasterRoles | Where-Object {$_.OperationMasterRoles} | Format-Table -AutoSize

#### Test GPO WMI Query
    gwmi -query "<QUERY>" -computername <COMPUTER>

##### Get list of all WinServers
    Get-ADComputer -LDAPFilter "(operatingSystem=Windows\20Server*)" -SearchBase "DC=<DOMAIN>,DC=<DOMAIN>"

##### Reset AD Computer Object Password (from local machine)
    Reset-ComputerMachinePassword -Server "<DOMAINCONTROLLER>"
    OR
    netdom resetpwd /Server:<DOMAINCONTROLLER> /UserD:Administrator /PasswordD:mysuperpassword
##### Get User Attributes (LDAP filter)
    Get-ADObject -Filter " DisplayName -eq 'Kristopher Haughey' "

##### Get Contact Group Membership
    Get-ADObject -Filter " objectClass -eq 'contact' " -SearchBase "OU=Contacts,DC=DOMAIN,DC=Com" -properties name,mail,memberOf | where {$_.Name -eq "<EMAIL ADDRESS>""} | select name,mail,memberOf

##### Restore Delete Object
    Get-ADObject -Filter 'samaccountname -eq "samAccountName_of_Object"' -IncludeDeletedObjects | Restore-ADObject

##### Get all websites from local IIS
    get-website | select name,id,state,physicalpath,@{n="Bindings"; e= { ($_.bindings | select -expa collection) -join ';' }} ,@{n="LogFile";e={ $_.logfile | select -expa directory}},@{n="attributes"; e={($_.attributes | % { $_.name + "=" + $_.value }) -join ';' }} | Export-Csv -NoTypeInformation -Path C:\my_list.csv

##### Get Service (no disabled, no LocalSystem acct)
    get-wmiobject win32_service | where {$_.StartName -ne "LocalSystem" -and $_.StartMode -ne "Disabled"} | format-table Name,DisplayName,State,StartMode,StartName

##### Get DA/VPN Connection Statistics
    Get-RemoteAccessConnectionStatistics -StartDateTime 05/27/2020 -EndDateTime 06/02/2020} | select UserName,UserActivityState,ClientExternalAddress | format-table

##### Get all DFSR Namespaces, Paths, Servers, and Basic Config
	Get-DfsrMembership -GroupName * -ComputerName *

##### CERT - Repair Private Key
    certutil -repairstore my "00ad1bxxxxxxxxxxxx"
