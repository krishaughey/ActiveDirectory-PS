#Copy DHCP Scope(s) to Secondary DHCP Server
## copy a list of DHCP scopes to a prompted server of choice
##### author: Kristopher Haughey
$ErrorActionPreference = 'silentlycontinue'
$ScopePrompt = Read-Host -Prompt 'Enter the full path to the input TXT file ( e.g.- C:\Temp\ScopeList.txt ) -->'
$ScopeList = Get-Content $ScopePrompt
$DhcpServerInDC = Get-DhcpServerInDC
Write-Host "-----DHCP SERVER LIST-----" -ForegroundColor Yellow
$DhcpServerInDC.DnsName
Write-Host "--------------------------" -ForegroundColor Yellow
$FromServer = Read-Host -Prompt "Enter the server to EXPORT the DHCP scope(s) FROM"
$ToServer = Read-Host -Prompt "Enter the server to IMPORT the DHCP scope(s) TO"

foreach ($Scope in $ScopeList){
    #Set-DhcpServerv4Scope -ComputerName $FromServer -ScopeId $Scope -State InActive
    Export-DhcpServer -ComputerName $FromServer -File "C:\Temp\dhcpexport_$Scope.xml" -ScopeId $Scope -Leases -Force
    Import-DhcpServer -ComputerName $ToServer -File "C:\Temp\dhcpexport_$Scope.xml" -BackupPath "C:\Temp\" -ScopeId $Scope -Leases -ScopeOverwrite -Force
    Set-DhcpServerv4OptionValue -ComputerName $ToServer -ScopeId $Scope -DnsDomain fhmc.local -OptionId 004 -Value 10.199.4.236 -DnsServer 10.199.7.21,10.199.2.59,10.16.128.171,10.20.8.171,10.16.128.172,10.20.8.172
    Set-DhcpServerv4Scope -ComputerName $ToServer -ScopeId $Scope -State InActive
}

Write-Host "-----"
Write-Host 'Completed operation on' ($ScopeList).count 'scopes' -ForegroundColor Green
Write-Host 'Check' $ToServer 'for the imported scopes' -ForegroundColor Cyan
Write-Host 'Export files are located in c:\Temp\' -ForegroundColor Cyan
Write-Host "-----"
