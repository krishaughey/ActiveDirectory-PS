# Get Local Group Membership
## Get the Local Group Membership for a prompted Group against a prompted OU of Servers
##### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$servers = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' | Select-Object -ExpandProperty DNSHostName
$results = foreach ($server in $servers) {
    Invoke-Command -ComputerName $server -ScriptBlock {Get-LocalGroupMember -Group "Administrators" | Select-Object @{Name = "ComputerName"; Expression = { $using:server } }, Name,ObjectClass,PrincipalSource}
}
$results | Export-Csv -Path C:\temp\LocalAdminsReport_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\temp\LocalAdminsReport_$timestamp.csv" -ForegroundColor Cyan
