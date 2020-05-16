# ActiveDirectory-PS

![PowerShell](https://repository-images.githubusercontent.com/221074232/158c2480-5262-11ea-8af0-452a86d9e56d)

##### Simple Timestamp Variable
> $timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

##### Log & Timestamp Wrapper Batch
    @echo OFF - Wrapper to Log Script
    echo [%date% - %time%] Log start >> C:\Temp\WSUS\wsusSelfUpdateManaged-Log.txt
    powershell "\\<ServerName>\<PATH>.ps1" >> C:\Temp\WSUS\wsusSelfUpdateManaged-Log.txt 2>&1
##### Get list of all WinServers
    Get-ADComputer -LDAPFilter "(operatingSystem=Windows\20Server*)" -SearchBase "DC=<DOMAIN>,DC=<DOMAIN>"

##### Reset AD Computer Object Password
    Reset-ComputerMachinePassword -Server "<SERVER>"

##### Get all websites from local IIS
    get-website | select name,id,state,physicalpath,
      @{n="Bindings"; e= { ($_.bindings | select -expa collection) -join ';' }} ,
      @{n="LogFile";e={ $_.logfile | select -expa directory}},
      @{n="attributes"; e={($_.attributes | % { $_.name + "=" + $_.value }) -join ';' }} |
      Export-Csv -NoTypeInformation -Path C:\my_list.csv
