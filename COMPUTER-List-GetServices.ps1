## Get Services on Computers from a list
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-Content c:\Temp\ServerList.txt
$Array = @()
foreach ($Server in $ServerList){
$colItems = Get-Service
  foreach ($Service in $colItems){
    $Array += New-Object PsObject -Property ([ordered]@{
        'Server' = $Server
        'Name' = $Service.Name
        'Status' = $Service.Status })
    }
}
$Array | export-csv c:\Temp\Services_$timestamp.csv -NoTypeInformation
