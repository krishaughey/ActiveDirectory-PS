# Get Local Group Membership
## Get the Local Group Membership for a prompted Group against a prompted OU of Servers
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory
$ADDomain = Read-Host "Enter AD Domain name (e.g.- domain.local)"
Set-ADDomain $ADDomain
$DomainController = Get-ADDomainController -Discover -Domain $ADDomain | Select-Object Name
$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$ServerList = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,dnshostname

$Array = @()
foreach($ServerObject in $ServerList){
$colItems = Invoke-Command -ComputerName $ServerObject.Name -scriptblock {Get-LocalGroupMember -Group "Administrators"} | Select-Object PSComputerName,Name,ObjectClass,PrincipalSource

    foreach ($Server in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Server' = $ServerObject.PSComputerName
            'Group' = $ServerObject.Name
            'Type' = $ServerObject.ObjectClass
            'Location' = $ServerObject.PrincipalSource})
      }
    }
$Array | export-csv C:\Temp\Group_Membership_Report_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\Temp\Group_Membership_Report_$timestamp.csv" -ForegroundColor Cyan
