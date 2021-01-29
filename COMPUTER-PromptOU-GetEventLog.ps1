# Get Recent Event Log Errors
## report system event log error entries - prompted for OU
##### author: Kristopher F. Haughey
Import-Module ActiveDirectory
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$SearchBase = Read-Host -Prompt "-->"
$ServerList = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | Select-Object Name,dnshostname

$Array = @()
foreach ($Server in $ServerList){
$colItems =
    get-eventlog -LogName System -EntryType error -Newest 50 | Select-Object timeGenerated,entryType,source,instanceID,message
    get-eventlog -LogName System -EntryType error -Newest 50 | Select-Object timeGenerated,entryType,source,instanceID,message
  foreach ($Event in $colItems){
    $Array += New-Object PsObject -Property ( [ordered]@{
    'serverName' = $Server.name
    'timeGenerated' = $Event.timeGenerated
    'entryType' = $Event.entryType
    'source' = $Event.source
    'instanceID' = $Event.instanceID
    'message' = $Event.message} )
    }
}
$Array | export-csv c:\Temp\EventLog_$timestamp.csv -NoTypeInformation
