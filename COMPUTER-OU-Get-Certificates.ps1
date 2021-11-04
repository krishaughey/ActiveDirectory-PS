# Get Certificates on Remote Servers
## Get the Local Computer Personal Store Certificates against a prompted OU of Servers
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$DomainController = Get-ADDomainController| Select-Object Name
$SearchBase = Read-Host "Enter searchbase (e.g.- OU=Servers,DC=Domain,DC=local)"
$ServerList = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,DnsHostName

$Array = @()
foreach($ServerObject in $ServerList){
$colItems = Invoke-Command -ComputerName $ServerObject.Name -scriptblock {Get-ChildItem -Path Cert:\LocalMachine -Recurse | Where-Object {$_.PSISContainer -eq $false} | Select-Object FriendlyName,PSPath,Issuer,NotAfter,NotBefore,SerialNumber,Thumbprint,DnsNameList,Subject,Version}

    foreach ($Server in $colItems){
        $Array += New-Object PsObject -Property ([ordered]@{
            'Server' = $ServerObject.DnsHostName
            'FriendlyName' = $Server.FriendlyName
            'Issuer' = $Server.Issuer
            'NotAfter' = $Server.NotAfter
            'NotBefore' = $Server.NotBefore
            'SerialNumber' = $Server.SerialNumber
            'Thumbprint' = $Server.Thumbprint
            'DnsNameList' = $Server.DnsNameList
            'Subject' = $Server.Subject
            'PSPath' = $Server.PSPath
            'Version' = $Server.Version})
      }
    }
$Array | export-csv C:\Temp\Certificate_Report_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\Temp\Certificate_Report_$timestamp.csv" -ForegroundColor Cyan
