# Get Active Computer Accounts in AD - LastLogonTimeStamp <=30 Days
### gives a count in host and sends a report to c:\Temp\
##### author: Kristopher F. Haughey

$DaysInactive = '30'
$time = (Get-Date).Adddays(-($daysInactive))
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$Active30 = Get-ADComputer -filter {lastlogontimestamp -gt $time} -properties Name,Modified,IPv4Address | Select-Object Name,Modified,IPv4Address
$Active30 | Select-Object Name,IPv4Address,Modified | Export-CSV c:\Temp\ActiveMachines_$timestamp.csv -NoTypeInformation
($Active30).count
