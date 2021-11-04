## Get Services Logon Account of Computers in List
##### Get Services - running and not disabled - not $Null 
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-Content c:\Temp\ServerList.txt

$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-Wmiobject win32_service -ComputerName $Server | Where-Object {$_.StartMode -ne "Disabled" -and $_.State -ne "Stopped" -and $_.StartName -ne $Null} | Select-Object PSComputerName,Name,DisplayName,State,StartMode,StartName
  foreach ($Service in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
        'Server' = $Server
        'Name' = $Service.Name
        'DisplayName' = $Service.DisplayName
        'State' = $Service.State
        'StartMode' = $Service.StartMode
        'StartName' = $Service.StartName})
  }
}
$Array | export-csv c:\Temp\Services-DomainAccounts_$timestamp.csv -NoTypeInformation
