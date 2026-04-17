# Get Local Group Membership
## Get the Local Group Membership for a prompted Group against a prompted OU of Servers
##### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

$serverList = Get-Content C:\Temp\ServerList.txt
$results = foreach ($server in $serverList) {
    Invoke-Command -ComputerName $server -ScriptBlock {Get-LocalGroupMember -Group "Administrators" | Select-Object @{Name = "ComputerName"; Expression = { $using:server } }, Name,ObjectClass,PrincipalSource}
}
$results | Export-Csv -Path C:\temp\LocalAdminsReport_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\temp\LocalAdminsReport_$timestamp.csv" -ForegroundColor Cyan
