##Get members of AD group and export to fomratted CSV
$Group = (Read-Host -Input "Enter the name of the group")
Get-ADGroup $Group | Get-ADGroupMember | Select-Object name,samAccountName,distinguishedName | Export-Csv c:\Temp\GroupReport.csv
