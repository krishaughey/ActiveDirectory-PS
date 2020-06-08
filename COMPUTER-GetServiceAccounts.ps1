## Get Services with Domain StartName
##### Get Services with Domain StartName. Running and not disabled - Not LocalSystem,NT AUTHORITY,$Null
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,DNSHostName

Write-Host "Collecting service information..." -ForegroundColor Green
$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-Wmiobject win32_service -ComputerName $Server | where {$_.StartMode -ne "Disabled" -and $_.State -ne "Stopped" -and $_.StartName -ne "LocalSystem" -and $_.StartName -notlike "NT AUTHORITY*" -and $_.StartName -ne $Null} | Select-Object PSComputerName,Name,DisplayName,State,StartMode,StartName
  foreach ($Service in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
        'Server' = $Service.PSComputerName
        'Name' = $Service.Name
        'DisplayName' = $Service.DisplayName
        'State' = $Service.State
        'StartMode' = $Service.StartMode
        'StartName' = $Service.StartName})
  }
}
$Array | export-csv c:\Temp\Services-DomainAccounts_$timestamp.csv -NoTypeInformation
Write-Host "export = c:\Temp\Services-DomainAccounts_$timestamp.csv" -ForegroundColor Cyan
